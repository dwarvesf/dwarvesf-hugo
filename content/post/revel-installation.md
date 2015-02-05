
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
authorimage: ivkean.jpg

---

Hiện tại đã có khá nhiều framework viết bằng Go giúp cho việc lập trình ứng dụng web được dễ dàng và hệ thống hơn như revel, beego, martini, goji, … Mỗi framework có những điểm mạnh riêng, nhưng ở bài này tui sẽ hướng dẫn các bạn cài đặt và viết ứng dụng myapp đầu tiên bằng REVEL

## Cài đặt go
```sudo apt-get update```<br>
```sudo apt-get install golang ```

## Cài đặt git 
```sudo apt-get install git``` <br>
```sudo apt-get install build-essential libssl-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip```


## Cài đặt mercurial 
```sudo apt-get install python-setuptools python-dev build-essential``` <br>
```sudo easy_install -U mercurial```

## Cấu hình GOPATH 
1. Tạo 1 folder: ```mkdir ~/goREVEL``` <br>
2. Thông báo cho Go biết <b>GOPATH</b> là folder vừa tạo: ```export GOPATH=~/goREVEL``` <br>
3. Lưu <b>GOPATH</b> để sử dụng cho 1 shell session: ```echo export GOPATH=$GOPATH >> ~/.bash_profile``` 

## Cài đặt REVEL
```go get github.com/REVEL/REVEL```

## Cài đặt REVEL tool	 
```go get github.com/REVEL/cmd/REVEL``` <br>

Để có thể sử dụng được các lệnh REVEL ở bất cứ đâu, bạn cần phải lưu <b>$GOPATH/bin</b> vào .bashrc bằng cách copy 2 dòng sau vào cuối file .bashrc: <br>
```export GOPATH=~/goREVEL```  <br>
```export PATH="$PATH:$GOPATH/bin" ```
	
## Kiểm tra cài đặt 
```revel help``` 

## Tạo 1 ứng dụng web

```cd $GOPATH``` <br>
```revel new myapp``` <br>

và bạn đã có thể chạy ứng dụng bằng lệnh sau: <br>
    ```revel run myapp``` <br>

Khi đó, REVEL sẽ chạy trên localhost với port là 9000 và bạn sẽ thấy: <br>

	{{% img src="/images/2015-02-05-revel-installation-run-my-app.png" class="third right" %}}

Vậy là bạn đã cài đặt và chạy thành công ứng dụng đầu tiên bằng REVEL. <br>
Ở bài sau, tui sẽ hướng dẫn các bạn làm việc với Controller, View, Routing và Parameters <br>

## Lời kết
Việc cài đặt và chạy ứng dụng bằng REVEL không quá khó, nhưng nó lại đem đến cho bạn môi trường mvc gần tương tự như PHP giúp bạn có thể thích nghi nhanh chóng với việc code web bằng Golang, một ngôn ngữ còn tương tối mới và đang có cộng đồng khá đông đảo. Đó là một điều khá thuận lợi cho việc phát triển mạnh hơn của Golang. <br><br>Nếu có vấn đề gì trong quá trình cài đặt, xin hãy comment bên dưới hoặc có thể gửi mail đến cho tui theo địa chỉ: ivkeanle@gmail.com
 
