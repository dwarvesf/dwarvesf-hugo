---

title: Giới thiệu Hugo
draft: false
description: "Hugo - a static site generator"
date: "2015-01-25T17:05:55+07:00"
categories: intro, go, hugo

coverimage: 2015-01-25-hugo-cover.png

excerpt: "Hugo là một dự án mã nguồn mở viết bằng ngôn ngữ Go bởi tác giả Steve Francia, dùng để phát sinh những file HTML tĩnh từ plain text."

authorname: Tiểu Bảo
authorlink: http://tieubao.me
authortwitter: mrcexii
authorgithub: tieubao
authorbio: Tonta-Chief
authorimage: gancho.png

---

*Bắt đầu chuỗi bài viết sẽ là những bài hướng dẫn cách tạo một site riêng cho mình, đồ chơi được tui giới thiệu sẽ toàn được viết trên ngôn ngữ golang.*

Hugo là một dự án mã nguồn mở viết bằng ngôn ngữ Go bởi tác giả [Steve Francia](https://github.com/spf13), dùng để phát sinh những file HTML tĩnh từ plain text. Những file HTML tĩnh này có thể dùng để làm trang web đơn giản như trang chủ hoặc blog cá nhân. Nếu bạn từng nghịch ruby thì bạn có thể hình dung Hugo là một bản sao của Blog Framework [Octopress](http://octopress.org) nhưng được viết bằng ngôn ngữ Go thay vì Ruby. Trang web mà các bạn đang đọc cũng được sử dụng Hugo để tạo nên. Source code được open trên [Github](https://github.com/dwarvesf/dwarvesf-hugo).

Đến với Hugo, các bạn sẽ được trải nghiệm nhiều điều thú vị. Hugo cho phép dễ dàng tạo ra một website đơn giản, trang cá nhân, portfolio, docs, blogs mà không cần quan tâm đến việc cấu hình cơ sở dữ liệu, cài đặt blogs sẽ vui hơn bao giờ hết bằng các câu lệnh git.

So sánh với các framework đang có hiện tại như WordPress và Octopress, Hugo mong muốn tạo ra một framework không quá phức tạp trong việc cấu hình như Octopress, tinh gọn và nhẹ nhàng trong xử lý và phản hồi cho người dùng hơn là sự nặng nề WordPress, đồng thời vẫn giữ được một chút chất Geeky. Ví dụ một số trang sử dụng Hugo: http://gohugo.io/showcase/

Các thông tin chi tiết hơn các bạn có thể tìm đọc ở trang chủ của [Hugo](http://gohugo.io/overview/introduction). Phần bên dưới tui sẽ tập trung trình bày cách cài đặt, sử dụng và deploy một trang web được sinh ra bởi Hugo lên một trong các trang miễn phí - Github Pages.

## Cài đặt Hugo

- *Mac*: sử dụng Homebrew `brew install hugo`
- *Linux*: Download và copy file binary của hugo vào trong folder đã được append vào $PATH

## Sử dụng Hugo

Document của Hugo mô tả khá rõ ràng các chức năng mà Hugo cung cấp cũng như những bước đầu tiếp cận, do đó việc viết lại là không cần thiết, các bạn có thể xem thêm tại [đây](http://gohugo.io/overview/quickstart/). Bên dưới tui sẽ tổng kết một số câu lệnh cơ bản nhất gọi là.

Tạo site mới: 

```
$ hugo new site /path/to/site
```

Cấu trúc được tạo ra sau khi chạy câu lệnh trên:
```
  ▸ archetypes/
  ▸ content/
  ▸ layouts/
  ▸ static/
    config.toml
```

Tạo thử một bài mới:
```
$ hugo new post/first.md
```

Chạy server, mở trang `http://localhost:1313` và xem thử kết quả nào
```
$ hugo server --watch --buildDrafts
```

Kết quả của tui
{{% img src="/images/2015-01-25-result.png" class="third right" %}}

OK vậy là đã xong bước cơ bản nhất. Phiên bản của các bạn có thể sẽ đơn giản hơn rất nhiều nhưng đừng nóng vội, ở bài sau tui sẽ hướng dẫn tiếp cách cài đặt theme và đưa trang web lên trên Github. Hẹn gặp lại sau.
