---

title: Cài đặt Sublime Text và plugins hỗ trợ code Golang
draft: false
description: "Sublime text và plugins hỗ trợ code Golang."
date: "2015-08-11T13:50:47+07:00"
categories: intro, go, sublime

coverimage: 2015-01-11-gopher-cover-2.jpg

excerpt: "Sublime Text là một editor, được hỗ trợ syntax cho nhiều ngôn ngữ java, html, css, python, … có khá nhiều plugin phong phú và đa dạng để hỗ trợ cho việc code dễ dàng và nhanh hơn. Hôm nay tui sẽ hướng dẫn các bạn cài đặt sublime text cũng như các plugin hỗ trợ việc code Golang."

authorname: Iv Kean
authorlink: https://www.facebook.com/ivkeanle
authorgithub: ivkean
authorbio: Scouting Unit
authorimage: cotton.png

---

- Sublime Text là một editor, được hỗ trợ syntax cho nhiều ngôn ngữ java, html, css, python, … có khá nhiều plugin phong phú và đa dạng để hỗ trợ cho việc code dễ dàng và nhanh hơn. Hôm nay tui sẽ hướng dẫn các bạn cài đặt sublime text cũng như các plugin hỗ trợ việc code Golang.

- Cài đặt SublimeText:

 - Với Ubuntu:
```
For Sublime-Text-2:
sudo add-apt-repository ppa:webupd8team/sublime-text-2 
sudo apt-get update 
sudo apt-get install sublime-text 
```

```
For Sublime-Text-3:
sudo add-apt-repository ppa:webupd8team/sublime-text-3 
sudo apt-get update 
sudo apt-get install sublime-text-installer
```

 - Với Mac:
```
http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20Build%203083.dmg
```

- Sau khi cài đặt xong, chúng ta sẽ cài thêm các plugin như sau:
	1. Chạy sublime text.
	2. Cài đặt Package Control. Sử dụng tổ hợp phím Ctrl + `
	{{% img src="/images/Screen Shot 2015-08-10 at 10.41.43 PM.png" class="third right" %}}
	
	Nếu là sublime 3, chúng ta paste code này:
	
		import urllib.request,os,hashlib; h = 'eb2297e1a458f27d836c04bb0cbaf282' + 'd0e7a3098092775ccb37ca9d6b2e4b7d'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http:/ /packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)
	

	Nếu sublime 2, chúng ta paste code này:
	
		import urllib2,os,hashlib; h = 'eb2297e1a458f27d836c04bb0cbaf282' + 'd0e7a3098092775ccb37ca9d6b2e4b7d'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); os.makedirs( ipp ) if not os.path.exists(ipp) else None; urllib2.install_opener( urllib2.build_opener( urllib2.ProxyHandler()) ); by = urllib2.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); open( os.path.join( ipp, pf), 'wb' ).write(by) if dh == h else None; print('Error validating download (got %s instead of %s), please try manual install' % (dh, h) if dh != h else 'Please restart Sublime Text to finish installation')
	
	Để biết thêm chi tiết về việc cài đặt Package Control, các bạn có thể vào trang:
	https://packagecontrol.io/installation

	- Sau khi cài đặt Package Control, chúng ta có thể vào:
	{{% img src="/images/Screen Shot 2015-08-10 at 10.44.49 PM.png" class="third right" %}}

	- Chọn Package Control.

	{{% img src="/images/Screen Shot 2015-08-10 at 10.47.55 PM.png" class="third right" %}}

	- Chọn install package và search các package cần thiết và install.

	- Ở đây, ta sẽ tiến hành install GoSublime và GoImport

	- Với GoSublime, chúng ta có thể:
		+ code completion
		+ check lint/syntax Go
		+ list danh sách các biến, function được khai báo trong file
		+ và nhiều chức năng khác. Để biết thêm chi tiết về các tính năng, các bạn có thể vào trang https://github.com/DisposaBoy/GoSublime

	- Với GoImport, chúng ta có thể tự động import hoặc remove package khỏi file hiện tại sau khi Save. 

	- Giờ thì chúng ta tiến hành install các plugin:
		- Cài đặt GoImport

		Chắc chắn rằng bạn đã set GOPATH và có $GOPATH/bin. Download package GoImport về: 

		```go get -u golang.org/x/tools/cmd/goimports```

		- Cài đặt  GoSublime

		Preferences -> Package Control -> Install Package -> type GoSublime. Sau khi click, sublime text sẽ cài đặt plugin cho bạn.

		Các bạn có thể vào phần List Packages để kiểm tra các package đã được cài.

		Sau khi cài đặt GoSublime, ta tiến hành config như sau:
		{{% img src="/images/Screen Shot 2015-08-10 at 11.10.35 PM.png" class="third right" %}}

		Vào phần Setting – User, và copy đoạn này vào: 

		```
		{
		    "env": {
		        "GOPATH": "$HOME/Documents/go:$GS_GOPATH",
		        "GOROOT": "/usr/local/go/"
		    },
		    "fmt_cmd": ["goimports"]
		} 
		```
		Sau đó, chúng ta restart lại sublime.

- Kiểm tra
	- Kiểm tra GoImport, ta tạo 1 file .go và type fmt.Println(“test”), save lại, nếu file tự động thêm package fmt thì GoImport đã được cài đặt thành công.

	- Sau đó, kiểm tra “code completion” của GoSublime bằng cách type fmt lần nữa, nếu hiện như hình sau, thì bạn đã cài plugin GoSublime thành công.

	{{% img src="/images/Screen Shot 2015-08-10 at 11.16.18 PM.png" class="third right" %}}
	
- Chúc các bạn cài đặt thành công và cải thiện được tốc độ code nhanh hơn với 2 plugin trên :).

		




