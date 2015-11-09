---

title: Cách cấu hình một site Hugo
draft: false
description: "Hugo - a static site generator"
date: "2015-01-26T23:49:15+07:00"
categories: intro, go, hugo

coverimage: 2015-01-25-hugo-cover.png

excerpt: "Ở phần trước tui đã giới thiệu với các bạn Hugo là gì và các thành phần cơ bản của Hugo. Ở bài này tui sẽ tập trung đi vào cấu hình và deploy site này lên Github Pages."

authorname: Tiểu Bảo
authorlink: http://tieubao.me
authortwitter: mrcexii
authorgithub: tieubao
authorbio: Tonta-Chief
authorimage: gancho.png

---

Ở phần trước tui đã giới thiệu với các bạn Hugo là gì và các thành phần cơ bản của Hugo. Ở bài này tui sẽ tập trung đi vào cấu hình và deploy site này lên Github Pages.

## Configuration

Cấu trúc thông thường của một site Hugo
```
  ▸ archetypes/
  ▸ content/
  ▸ layouts/
  ▸ static/
    config.toml
```

Trong đó file `config.toml` đóng vai trò lưu trữ các cấu hình chung như: Tên site, URL, theme, social handle ..v.v. Hugo hỗ trợ đọc file config này với 3 đuôi chính: toml, yaml và json. `Json` thì mọi người đã quá quen thuộc, `yaml` là đuôi được sử dụng phổ biến của các file config bên ngôn ngữ Ruby, framework Octopress cũng sử dụng đuôi file này; [`toml`](https://github.com/toml-lang/toml) là kiểu ngôn ngữ mới ra đời, cũng nhằm mục đích tạo những file cấu hình đơn giản, dễ đọc và dễ hiểu nhất cho cả người và máy. Các bạn có thể tham khảo thêm ở Github. Không qua thân thuộc với `toml` nên tui quyết định vẫn giữ và sử dụng đuôi `.yaml`

Ví dụ file cấu hình của tui:

``` yaml

---

baseurl:            http://blog.dwarvesf.com/
pygmentsuseclasses: true 
theme:              hugo-incorporated

params:
  inc:
    # Blog Information
    title:        "Dwarves Foundation"
    subtitle:     "We are Dwarves. We love #gopher"
    cover_image:  cover.png
    logo:         logo.png

```

## Theme

Hugo cung cấp một cơ chế load theme khá tiện lợi. Các theme được phát triển bởi nhiều lập trình viên khác nhau và tạo một pull request tới repository [spf13/hugoThemes](https://github.com/spf13/hugoThemes).

Để install một theme, bạn chỉ cần clone repo mong muốn hoặc toàn bộ repo vào thư mục `themes`. 

```
$ git clone --recursive https://github.com/spf13/hugoThemes themes
```

Khi tiến hành chạy thử Hugo, bạn chỉ cần chọn loại theme mong muốn. Bên dưới là câu lệnh chạy server hugo với theme `hype`

```
$ hugo server --theme=hyde --buildDrafts
```

Cấu trúc của một thư mục chứa theme khá đơn giản và hoàn toàn mô phỏng lại thư mục chứa site hiện tại. Ví dụ:

{{% img src="/images/2015-01-26-hugo-theme-folder.png" class="third right" %}}

Tùy loại theme mà các file cấu hình sẽ khác nhau về số lượng giá trị cần cấu hình cũng như tên gọi.

``` 
# File cấu hình theme herring-cove

name = "Herring Cove"
description = "Herring Cove is ported from the jekyll theme of the same name"
license = "MIT"
tags = ["blog", "company"]

[author]
    name = "spf13"
    homepage = "http://spf13.com"

# If Porting existing theme
[original]
    author =  "arnp"
    repo = "http://www.github.com/arnp/herring-cove"

```

``` 
# File cấu hình theme hugo-incorperated
---

baseurl:            http://blog.nilproductions.com/
pygmentsuseclasses: true 
theme:              hugo-incorporated

params:
  inc:
    # Blog Information
    title:        "Hugo Incorporated"
    subtitle:     "Modern Hugo based blog for companies"
    cover_image:  blog-cover.jpg
    logo:         logo.png

    # Company information
    company:      nil productions 
    url:          http://nilproductions.com/
    facebook:     
    github:       nilproductions
    twitter:      nw_iw
    gplus:        ''
    about_link:   http://nilproductions.com/about/

    # Product Information
    product_link: http://nilproductions.com/
    tagline:      "Coming up nil for quite some time."

    # Comments
    disqus:
      # Eg. "exampleblog" Set to false to disable comments
      shortname:  false

    # Sharing settings
    sharing:
      twitter:    true
      facebook:   true
      gplus:      false
      hn:         true

    # Analytics     
    analytics:
      google: false # Add tracking code in _includes/_google-analytics.html

    # Google Fonts
    google_font: 'Droid+Sans:400,700'
    
    # Setup your fonts, colors etc at _assets/stylesheets/main.scss
```

##### Nguyên tắc hoạt động

Khi tiến hành generate các file html tĩnh, hugo sẽ lấy theme được chọn cùng với cấu hình hiện tại theo thứ tự ưu tiên từ bên ngoài vào bên trong, tức là sẽ lấy các giá trị config, style ... của thư mục root trước, sau đó mới đến các giá trị bên trong thư mục theme và tiến hành kết với dữ liệu trong các file markdown. Điều này giúp các ban có thể linh hoạt thay đổi cấu hình của các theme một cách dễ dàng.

Mỗi theme tuy được viết cấu trúc khác nhau, nhưng đều tuân thủ theo nguyên tắc chia để trị, các thành phần sẽ được cắt nhỏ thành các partial, đến trang nào cần thì mới include vào để load lên.

Hugo cho phép định nghĩa nhiều loại post khác nhau, với mỗi loại post các bạn có thể lên các layout khác nhau. Điều này tạo nên sự đa dạng cho trang web và đây cũng là một phần mà tui rất thích. Với tính năng này, tui có thể xây dựng một site với đầy đủ các phần Home, Blog, About, Jobs ... mà không bị gò bó như các blog framework khác. Nếu các bạn quan tâm đến tính năng này như tui thì có thể tham khảo trang http://chimeraarts.org

## Deploy static site

Sau khi chạy câu lệnh `hugo server`, Hugo sẽ generate folder `public/` đầy đủ đồ chơi html, css và javascript như hình phía trên. Đến lúc này các bạn có một vài công việc có thể tự nghịch tùy vào sở thích của mình:

- Custom lại một theme đã có sẵn bằng cách edit trực tiếp vào folder `themes/` hoặc tạo thêm các file nằm rời để override các giá trị mặc định
- Tự một theme mới luôn cho oách http://gohugo.io/themes/creation/
- Đưa folder `public/` lên trên một host nào đó mà các bạn có, như vậy là xong. Bạn có thể tự dựng Raspi, xin một host free nào đó rồi upload lên .v..v. Còn tui thì tui lựa chọn [Github Pages](https://pages.github.com), một tính năng khá đỉnh của Github. 

Với mỗi account đăng kí, Github sẽ chọn một repo riêng (bạn phải tự tạo) với tên repo có dạng `username.github.io`, mặc định branch `master` để làm một site từ các html tĩnh. Bạn có thể tham khảo source code của site Dwarves Foundation hiện tại ở: https://github.com/dwarvesf/dwarvesf.github.io. Hoặc một số site khác đỉnh hơn mà tui sực nhớ: 

- Square: https://github.com/square/square.github.io
- Blog cá nhân của tui: https://github.com/tieubao/tieubao.github.io

Rồi, bắt đầu đưa site lên thôi. Các bạn thực hiện các bước sau:

**Notes**: Ở bên dưới để tránh nhầm lẫn nên tui đã tách ra 2 folders rời nhau. `public/` dành cho draft và `release/` dành để publish.

- Tạo account github
- Tạo repository có tên `username-hugo` để chứa source code của các file markdown
- Ignore folder `public/`, bởi vì đây là các static files được build dưới dạng draft dùng để xem ở localhost
- Push source lên trên repo vừa mới tạo bằng cách sử dụng các lệnh `git push` quen thuộc
- Tạo repository có tên `username.github.io` để chứa file tĩnh html, css, js trong folder `release/`
- Chạy command `$ git submodule add git@github.com:<username>/<username>.github.io.git release` để link repo `username.github.io` đến thư mục release.
- Việc cuối cùng là tiến hành deploy folder `release/` lên Github thôi. Để các bạn không phải lập đi lập lại các câu lệnh chạy server để generate html tĩnh, và một số câu lệnh git khác. Tác giả đã cung cấp đoạn shell sau:

```
#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project. 
hugo -d release # if using a theme, replace by `hugo -t <yourtheme>`

# Go To Public folder
cd release

# Add changes to git.
git add -A

# Commit changes.
msg="Rebuilding site on `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back
cd ..
```

Các bạn chỉ cần vác thằng mày về, change mode +x cho nó `chmod +x deploy.sh`. Những lần sau khi muốn deploy blog lên Github, bạn chỉ cd vào thư mục chứa site của mình, rồi chạy: 

```
$ ./deploy.sh "<message>"
```

Nếu các bạn rảnh rỗi thì có thể tìm hiểu thêm về git và submodule để có thể tự viết đoạn shell riêng cho mình. Một số người dùng Hugo cũng có viết về cách mà họ tùy biến, các bạn có thể dễ dàng tìm thấy qua Google. Thực hiện hoàn tất các việc trên, bạn có thể vào địa chỉ `https://username.github.io` để xem lại thành quả của mình.

#### Tên miền riêng

Đối với các bạn chịu đầu tư mua một domain riêng cho mình, các bạn có thể thực hiện các bước sau để cấu hình:

- Tạo folder `static/` nếu chưa có
- Tạo file `CNAME` có nội dung là tên miền mà bạn đã mua

{{% img src="/images/2015-01-26-cname.png" class="third right" %}}

- Deploy lại lên Github
- Cấu hình URL Forwarding trên site mà các bạn đã mua domain

{{% img src="/images/2015-01-26-hugo-url-forward.png" class="third right" %}}

OK done. Bài này tui xin kết thúc tại đây, chúc các bạn thành công và vui vẻ với trang cá nhân của mình. Bài sau tui sẽ tiếp tục hướng dẫn cách mà nhiều thành viên có thể cùng viết bài trên Hugo.