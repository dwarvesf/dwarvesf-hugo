---

title: Docker và những điều cần biết.
draft: false
description: "Giới thiệu về docker."
date: "2015-08-09T10:45:19+07:00"
categories: intro, go, hugo

coverimage: 2015-08-08-docker-introduction.png

excerpt: "Docker là gì và có gì thú vị? Chúng ta hãy cùng đi qua bài viết này để hiểu thêm về docker."

authorname: Iv Kean
authorlink: https://www.facebook.com/ivkeanle
authorgithub: ivkean
authorbio: Scouting Unit
authorimage: cotton.png

---

- Gần đây Docker đang gây được nhiều chú ý trong cộng đồng công nghệ thế giới, với nhiều hứa hẹn trong tương lai. Các hãng công nghệ lớn như Google, Amazon, Microsoft, IBM, Ebay… đã bắt đầu hỗ trợ Docker trên nền tảng của họ.

- Vậy Docker là gì, có gì thú vị ?  Chúng ta hãy cùng nhau điểm qua một số điều dưới đây để hiểu hơn về Docker và có thể triển khai được website Golang được viết với framework Beego.

## Docker là gì?
- Docker là một nền tảng mở dành cho các lập trình viên, quản trị hệ thống dùng để xây dựng, vận chuyển và chạy các ứng dụng. Ban đầu viết bằng Python, hiện tại đã chuyển sang Go-lang.

## Vậy docker khác gì so với máy ảo ?

{{% img src="/images/2015-08-09-screen-shoot-docker-compare-vm.png" class="third right" %}}  

- Ở hình trên, ta có thể thấy như sau:
 + Máy ảo (virtual machine): mỗi máy ảo gồm các ứng dụng, các file nhị phân, thư viện, tất cả users hệ thống. Chúng tạo tạo nên một lượng dữ liệu rất lớn, có thể lên đến hơn 10GBs.
 + Với Docker container: chỉ chứa những ứng dụng và những thứ cần thiết để chạy ứng dụng, có khả năng share kernel với những container khác. Chúng chạy độc lập trên hệ thống. Chúng cũng không bị hạn chế bởi cấu hình máy nào, vì docker container có thể chạy trên bất kì máy tính, bất kì cấu hình, hoặc thậm chí trên cả cloud.


## Các thành phần của Docker
1. Docker Engine: còn được gọi là Docker, dùng để tạo và chạy các “container” 
2. Kitematic: là giao diện GUI cho Docker
3. Docker Hub: là 1 dịch vụ host public của Docker để quản lý các image của bạn. 
4. Docker Compose: là 1 công cụ để tạo và chạy nhiều containers cùng lúc. Với Docker Compose, bạn chỉ việc định nghĩa các containers trên 1 file (text) và chạy 1 dòng lệnh duy nhất, sau đó mọi thứ sẽ được docker cài đặt, setup và chạy ứng dụng như ý bạn.
5. Docker Trusted Registry: là dịch vụ cung cấp private image.
6. Docker Registry: nơi để lưu trữ các images của cộng đồng Docker.

## Một số khái niệm
* Image: là 1 đối tượng chứa sẵn cấu hình. Ví dụ: image có sẵn hệ điều hành ubuntu, image có sẵn Golang, … Các thao tác với image: build, run, remove
* Container: là 1 đối tượng mà ứng dụng chạy trong đó. Container được tạo từ image. Các thao tác với container: ps, start, stop, restart, logs, remove
* Dockerfile: là 1 file (text), để định nghĩa 1 image sẽ được tạo như thế nào, gồm các ứng dụng nào được cài sẵn bên trong đó.

## Tạo web Golang bằng framework Beego bằng Dockerfile

- Ta bắt đầu với việc tạo 1 Dockerfile, ở đây tôi sử dụng “vi” để tạo file, với nội dung như sau:

```
# vì ta chạy code golang nên ta cần image là google/golang có sẵn trên docker hub
FROM google/golang

# ta get source beego về
RUN go get github.com/astaxie/beego 
RUN go get github.com/beego/bee

# set vị trí path hiện tại
WORKDIR /gopath/src/

# tạo 1 project bằng lệnh bee new
RUN bee new app

# set vị trí path để chạy app beego
WORKDIR /gopath/src/app

# set port chạy app
EXPOSE 8080

# set lệnh để chạy app
CMD bee run
```

- Để biết thêm về syntax tạo 1 image bằng Dockerfile, các bạn có thể xem tại: https://docs.docker.com/articles/dockerfile_best-practices/

- Ta save file lại, và chạy lệnh:
```
docker build –t beego . (các bạn đừng quên dấu . phía cuối :D)
```

- Lệnh trên thực hiện các thao tác sau:
 1. Đặt tag name cho image là beego.
 2. Docker build image dựa trên file Dockerfile mà ta đang đứng ở path hiện tại.

{{% img src="/images/2015-08-09-screen-shoot-docker-init-dockerfile.png" class="third right" %}} 

- Ta kiểm tra các images được tạo bằng lệnh:
```
docker images
```

{{% img src="/images/2015-08-09-screen-shoot-docker-images.png" class="third right" %}} 

- Sau đó, ta chạy lệnh:
```
docker run –-name demo-beego-app –p 8080:8080 –d beego
```

- Lệnh trên thực hiện các thao tác sau:
 1. Set name (--name) cho container sẽ được tạo là demo-beego-app.
 2. Đặt map port (-p) từ port bên ngoài (bên trái) 8080 vào port bên trong docker (bên phải) là 8080.
 3. Detach container (-d) chạy background.

- Sau khi chạy lệnh trên, chúng ta đã có 1 web beego chạy trên docker container ☺. Giờ chúng ta log thử bằng browser:

{{% img src="/images/2015-08-09-screen-shoot-docker-beego.png" class="third right" %}}

- Bài viết ghi lại những hiểu biết của tôi trong quá trình tìm hiểu và sử dụng Docker còn khá cơ bản. Rất mong nhận được góp ý từ các bạn ☺.

- Các bạn cũng có thể tìm hiểu ở trang chủ: https://docs.docker.com/index.html
