---

title: Hướng dẫn nhiều thành viên cùng viết bài trên Hugo
draft: false
description: "Hugo - a static site generator"
date: "2015-01-27T16:19:17+07:00"
categories: intro, go, hugo

coverimage: 2015-01-25-hugo-cover.png

excerpt: "Tiếp theo bài trước, sau khi đã cấu hình và deploy thư mục `source/` chứa các file `.md` và thư mục `public/` chứa html tĩnh đã được dịch ra thì Github của tui sẽ như sau:"

authorname: Tiểu Bảo
authorlink: http://tieubao.me
authortwitter: mrcexii
authorgithub: tieubao
authorbio: Tonta-Chief
authorimage: gancho.png

---

Tiếp theo bài trước, sau khi đã cấu hình và deploy thư mục `source/` chứa các file `.md` và thư mục `public/` chứa html tĩnh đã được dịch ra thì Github của tui sẽ như sau:

{{% img src="/images/2015-01-27-github-dwarves.png" class="third right" %}}

Để các thành viên khác có thể cùng đóng góp bài viết, tui cần phải đảm bảo họ có quyền truy cập vào 2 repo đó. Các thành viên khác cần có account Github và được add vào `Setting > Collaborators` của từng repo. [^1]

{{% img src="/images/2015-01-27-github-setting.png" class="third right" %}}

Sau khi được cấp phát quyền truy cập vào đó, với vai trò là một thành viên mới, bạn sẽ phải clone 2 repo đó về bằng câu lệnh:

```
$ git clone git@github.com:dwarvesf/dwarvesf-hugo.git
$ cd dwarvesf-hugo
$ git clone --recursive git@github.com:dwarvesf/dwarvesf.github.io.git public/
```

Dùng `git remote` để kiểm tra xem các folder còn trỏ đúng vào các repo hay không:

```
$ git remote -v
$ cd public | git remote -v
```

{{% img src="/images/2015-01-27-git-remote.png" class="third right" %}}

OK. Giờ để viết blog thì các bạn chỉ cần xài các câu lệnh căn bản ở những phần trước là được.

Viết bài mới:

```
$ hugo new path/to/file.md
```

Build:

```
$ hugo server --watch --buildDrafts
```

Deploy lên Github:

```
$ ./deploy.sh "<message>"
```

[^1]: Nếu bạn muốn kiểm soát chặt chẽ hơn về nội dung thì không cần cấp phát quyền cho các thành viên khác mà nên apply tính năng [`Pull Request`](https://help.github.com/articles/using-pull-requests/) của Github