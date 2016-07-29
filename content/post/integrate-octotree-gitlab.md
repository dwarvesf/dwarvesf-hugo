---

title: Tích hợp Octotree vào Gitlab trên Safari
draft: false
description: "Introduce octotree and how to integrate it into gitlab in Safari browser"
date: "2016-05-22T17:00:00+07:00"
categories: intro, octotree, extension

coverimage: 2016-05-22-integrate-octotree-into-gitlab-2.jpg

excerpt: "Bài viết giới thiệu về Octotree và cách tích hợp vào Gitlab trên Safari"

authorname: Nam Bùi Vũ
authorlink: https://www.facebook.com/namvu.bui
authortwitter: nambv
authorgithub: nambv
authorbio: Android Craft Special List
authorimage: inhel.png

---

## Tổng quan
Khi làm việc với source control (Github, Gitlab...) trên browser (Chrome, Firefox, Safari, Opera...), chúng ta thường gặp khó khăn và mất thời gian khi truy cập vào file và folder trên repository. Mọi việc sẽ dễ dàng hơn khi octotree ra đời. Nó giúp bạn xem và tương tác với source control dưới dạng "cây thư mục", như thế này:

{{% img src="/images/2016-05-22-integrate-octotree-into-gitlab-1.png" class="third right" %}}

- Octotree homepage: https://github.com/buunguyen/octotree

- Chrome extension:  https://chrome.google.com/webstore/detail/octotree/bkhaagjahfmjljalopjnoealnfndnagc

- Firefox extension: https://addons.mozilla.org/en-US/firefox/addon/octotree/

Safari extension:  
	
1. Download [octotree.safariextension](/files/octotree.safariextension.zip)
2. Open Safari > Develop > Show Extension Builder > Add extension
3. Chọn octotree.safariextension > Install > Reload


## Tích hợp cho Gitlab trên Safari

Mặc định, Octotree chỉ chơi với Github, chúng ta cần làm thêm vài bước sau đây để nó có thể chơi được với Gitlab. Ở đây mình sẽ hướng dẫn trên trình duyệt Safari:

1. Open octotree.safariextension with sublime
2. Open file info.plist
3. Tìm tới dòng `<string>https://gitlab.com/*</string>`, thêm 1 dòng mới vào là domain gitlab mà bạn đã đăng ký, ở đây mình ví dụ domain Gitlab của Dwarves Foundation là `<string>https://git.dwarvesf.com/*</string>`
4. Tìm tới dòng `<string>gitlab.com</string>` và thêm vào 1 dòng với domain gitlab của bạn, ví dụ; `<string>git.dwarvesf.com</string>`
5. Save changes
6. Open Safari > Develop > Show Extension Builder > octotree > Reload

Done! Sau khi configure xong, bạn vào gitlab sẽ thấy octotree đã được tích hợp vào Safari thành công!


{{% img src="/images/2016-05-22-integrate-octotree-into-gitlab-3.png" class="third right" %}}

	
