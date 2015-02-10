
---

title: Revel – Routes, Controller, View và Parameters
draft: false
description: "Giới thiệu đến các bạn Routes, Controller, View và Parameters."
date: "2015-02-10T18:39:15+07:00"
categories: intro, go, hugo

coverimage: 2015-02-05-revel-installation-banner.png

excerpt: "Tiếp theo bài trước, hôm nay tui sẽ giới thiệu đến các bạn Routes, Controller, View và Parameters với cách sử dụng cực kì đơn giản mà Revel đã support cho chúng ta."

authorname: Iv Kean
authorlink: https://www.facebook.com/ivkeanle
authorgithub: ivkean
authorbio: Scouting Unit
authorimage: ivkean.png

---

- Tiếp theo bài trước, hôm nay tui sẽ giới thiệu đến các bạn Controller, View, Route và Parameters với cách sử dụng cực kì đơn giản mà Revel đã support cho chúng ta.<br>

## Routes
- Nằm trong thư mục conf/routes, routes dùng để định nghĩa các đường dẫn URL cho trang web và xác định với url X thì sẽ sử dụng method (GET/POST) gì, cần phải sử dụng Controller Y gì và thực hiện function Z nào
{{% img src="/images/2015-02-10-revel-part2-route.png" class="third right" %}}
## Controller và View
- Controller để xử lý các request từ client, chúng được thiết kế không khác với các mô hình MVC thường thấy, nên có lẽ việc này sẽ giúp chúng ta tiếp cận dễ dàng hơn. Dưới đây là demo về Controller:<br>
	+ Chúng ta định nghĩa 1 URL trong routes. Tui định nghĩa cho url domain.com/users như sau: ```GET  /users  User.Index``` 
	+ Chúng ta tạo 1 file user.go trong thư mục app/controllers và định nghĩa cho function Index như sau:<br>
```
func (c User) Index() revel.Result {
var greeting string
var username string
greeting = “Hello”
username = “ivkean”
return c.Render(greeting,username)
}
``` 
<br>
	+ Chúng ta tạo folder User trong thư mục App/views và do gọi đến function Index nên chúng ta cần tạo 1 file Index.html trong thư mục User vừa tạo và thêm đoạn code như sau:<br>
```
{{set . "title" "Users"}}
{{template "header.html" .}}
<header class="hero-unit" style="background-color:#A9F16C">
  <div class="container">
    <div class="row">
      <div class="hero-text">
        <h1>{{.greeting}} {{.username}}</h1>
        <p></p>
      </div>
    </div>
  </div>
</header>
<div class="container">
  <div class="row">
    <div class="span6">
      {{template "flash.html" .}}
    </div>
  </div>
</div>
{{template "footer.html" .}}
```
- Chúng ta hãy chú ý đến dòng đầu tiên, ```{{set . "title" "Users"}}``` dùng để gán nội dung Users cho biến title- Tiếp theo là dòng thứ 2, ```{{template "header.html" .}}``` để include nội dung file header.html trong thư mục views. Trong header.html, ta có thể thấy ```<title>{{.title}}</title>``` dùng để set tên cho page với biến title đã được khai báo ở dòng đầu tiên. 
- Và kết quả như hình dưới đây: <br>
{{% img src="/images/2015-02-10-revel-part2-controller-view.png" class="third right" %}}

## Parameters
- Giờ chúng ta hãy thử truyền param cho url để server xử lý và render lên view.
- Vẫn như các bước trên, ta định nghĩa trong routes: ``` GET /users/username/:username User.ShowUserName ``` <br>
- Tiếp đến là định nghĩa function ShowUserName trong user.go <br>

```
func (c User) ShowUserName() revel.Result {
	greeting := "Welcome User: "
	var username string
	c.Params.Bind(&username,"username")
	return c.Render(greeting,username)
}
```
- Hàm Bind có thể thực hiện với các biến:
	+ Các loại int
	+ String
	+ Bools
	+ Các loại biến con trỏ
	+ Các loại biến Slices
	+ Structs
	+ time.Time: dates và times
	+ *os.File, []byte, io.Reader, io.ReadSeeker đối với file uploads

- Và tạo file ShowUserName.html trong views/User và code tương tự như Index.html. Kết quả:
{{% img src="/images/2015-02-10-revel-part2-parameter.png" class="third right" %}}
## Lời kết
- Revel đã hỗ trợ tốt ở các phần Routes, Controller, View và Parameters, nên chỉ với một số thao tác đơn giản chúng ta đã dễ dàng tiếp cận với chúng chỉ trong bài viết ngắn gọn này.
Ở bài viết sau, tui sẽ giới thiệu với các bạn kết nối với database bằng gosexy/db được phát triển từ upper.io.
 
