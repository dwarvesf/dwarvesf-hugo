
---

title: REVEL - MVC server side web framework Cho Golang
draft: false
description: "Giới thiệu MVC server side framework Revel"
date: "2015-02-05T14:36:15+07:00"
categories: intro, go, hugo

coverimage: 2015-02-05-revel-installation-banner.png

excerpt: "Một trong những MVC server side framework giúp cho việc lập trình web bằng Golang dễ dàng hơn."

authorname: Iv Kean
authorlink: https://www.facebook.com/ivkeanle
authorgithub: ivkean
authorbio: Scouting Unit
authorimage: cotton.png

---

- Hiện tại đã có khá nhiều framework viết bằng Go giúp cho việc lập trình ứng dụng web được dễ dàng và hệ thống hơn như revel, beego, martini, goji, … Mỗi framework có những điểm mạnh riêng, nhưng ở bài này tui sẽ hướng dẫn các bạn cài đặt và viết ứng dụng myapp đầu tiên bằng REVEL.<br>

- Trong đó, beego và revel là 2 framework cung cấp mô hình MVC giúp chúng ta dễ dàng code và maintain hơn trong việc tạo ứng dụng web. <br>

- Về phía martini và goji, 2 framework này tương đối giống nhau (gần giống với nodejs), nhưng chúng không hỗ trợ render view nên theo tui sẽ thích hợp hơn khi sử dụng với mục đích làm server RESTful hay cập nhật real-time cho client. <br>


- Chúng ta tiếp tục so sánh giữa beego và revel:
+ Hot-compile/reload:
	- Cả 2 đều hỗ trợ hot-compile/reload (không cần phải restart server để chạy code mới), nhưng ở beego, file được tự động compile mỗi khi có thay đổi (mỗi khi save), còn Revel thì không như vậy, Revel sẽ đợi đến khi nhận được request mới thực hiện compile code mới, ở mặt này theo tui thấy Revel có vẻ như sử dụng ít tài nguyên hơn. <br>
+ ORM:
	- Revel không hỗ trợ ORM nhưng có ví dụ cách sử dụng GORP. Beego lại tự build cho mình ORM. Ở phần database, tôi sẽ hướng dẫn các bạn kết nối dễ dàng với upper.io <br>
+ Template engine: 
	- Cả 2 đều sử dụng template engine của Golang <br>
+ Vấn đề dev: 
	- Revel cho phép ta code và xem kết quả tốt hơn, chỉ việc refresh để xem kết quả, và kết quả hiện trên browser dù cho có lỗi, chúng vẫn được hiện lên browser. Beego thì không hiện lên browser, beego hiện lỗi lên console <br>
	
- Theo cá nhân tui, phần Route của Revel khá rõ ràng và gần giống như các framework PHP khác, beego thì không, nên tui sẽ thử chọn Revel để dev xem sao :D. <br>

## Trước hết là cài đặt Go
```sudo apt-get update```<br>
```sudo apt-get install golang ```

## Tiếp đến là  git 
```sudo apt-get install git``` <br>
```sudo apt-get install build-essential libssl-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip```


## Và cuối cùng là mercurial 
```sudo apt-get install python-setuptools python-dev build-essential``` <br>
```sudo easy_install -U mercurial```<br>

- Việc cài đặt Git và mercurial cho phép ```go get``` tải về một số dependencies cần thiết cho việc cài đặt revel

## Cấu hình GOPATH 
1. Tạo 1 folder: ```mkdir ~/goRevel``` <br>
2. Thông báo cho Go biết <b>GOPATH</b> là folder vừa tạo: ```export GOPATH=~/goRevel``` <br>
3. Lưu <b>GOPATH</b> để sử dụng cho 1 shell session: ```echo export GOPATH=$GOPATH >> ~/.bash_profile``` 

## Giờ chúng ta đã có thể cài đặt REVEL
```go get github.com/REVEL/REVEL```<br>

Dòng lệnh trên thực hiện 2 việc sau:<br>
+ Go sử dụng git để tải repository vào ```$GOPATH/src/github.com/revel/revel/```<br>
+ Go tìm tất cả những dependencies cần thiết và chạy ```go get```

## và cài đặt REVEL tool	 
```go get github.com/REVEL/cmd/REVEL``` <br>

- Công cụ REVEL command line cho phép bạn tạo(new), chạy ứng dụng(run) và đóng gói ứng dụng(package) và 1 số chức năng khác để sử dụng REVEL tiện hơn.  <br>

- Để có thể sử dụng được các lệnh REVEL ở bất cứ đâu, bạn cần phải lưu <b>$GOPATH/bin</b> vào .bashrc bằng cách copy 2 dòng sau vào cuối file .bashrc: <br>
```export GOPATH=~/goRevel```  <br>
```export PATH="$PATH:$GOPATH/bin" ```
	
## Kiểm tra cài đặt 
```revel help``` 

## Tạo 1 ứng dụng web

```cd $GOPATH``` <br>
```revel new myapp``` <br>

và bạn đã có thể chạy ứng dụng bằng lệnh sau: <br>
    ```revel run myapp``` <br>

- Khi đó, REVEL sẽ chạy trên localhost với port là 9000 và bạn sẽ thấy: <br>

	{{% img src="/images/2015-02-05-revel-installation-run-my-app.png" class="third right" %}}

- Vậy là bạn đã cài đặt và chạy thành công ứng dụng đầu tiên bằng REVEL. <br>
- Ở bài sau, tui sẽ hướng dẫn các bạn làm việc với Controller, View, Routing và Parameters <br>

## Lời kết
- Việc cài đặt và chạy ứng dụng bằng REVEL không quá khó, nhưng nó lại đem đến cho bạn môi trường mvc gần tương tự như PHP giúp bạn có thể thích nghi nhanh chóng với việc code web bằng Golang, một ngôn ngữ còn tương tối mới và đang có cộng đồng khá đông đảo. Đó là một điều khá thuận lợi cho việc phát triển mạnh hơn của Golang. <br><br>
- Nếu có vấn đề gì trong quá trình cài đặt, xin hãy comment bên dưới hoặc có thể gửi mail đến cho tui theo địa chỉ: ivkeanle@gmail.com
 
