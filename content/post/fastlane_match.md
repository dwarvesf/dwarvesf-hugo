---

title: Fastlane - Hướng dẫn sử dụng Match
draft: false
description: "Match - Đồng bộ certificates và profiles trong nhóm bằng git"
date: "2016-07-24T15:14:53+07:00"
categories: tutorial, ios, fastlane, match

coverimage: 2016-07-24-match-banner.png

excerpt: "Match là một công cụ mã nguồn mở nằm trong Fastlane. Với match iOS dev có thể quản lý và chia sẻ certificate và profile giữa các thành viên trong team thông qua một git repository."

authorname: Hiếu Phan
authorlink: https://www.facebook.com/hieuphan.sng
authortwitter: hieutieutu
authorgithub: hieuphq
authorbio: iOS Craft
authorimage: hunter.png

---

## Match

Tiếp nối bài giới thiệu về fastlane, một số blog sau sẽ hướng dẫn dùng một số công cụ trong bộ các công cụ trong fastlane để hỗ trợ các iOS dev có thể làm giảm thời gian khi deploy một app mới lên store. Một lợi ích sau khi biết được cách dùng các công cụ này là làm tự động mọi thứ trong quá trình release một app đến người dùng.

Match là công cụ giúp tạo mới, đồng bộ [certificates và provisioning profile(gọi tắt là profiles)](https://developer.apple.com/support/certificates/) của một app. Match sẽ tạo tất cả certificates & provisioning profiles và lưu vào một git repository riêng. Người có quyền truy cập đến repo đó sẽ có thể lấy và sử dụng.

## Lý do cần Match

Khi deploy một ứng dụng App Store, release bản beta hoặc cài đặt nó trên một thiết bị thật, hầu hết các nhóm cần có một mã riêng cho mỗi thành viên. Điều này dẫn đến cần phải tạo rất nhiều profiles.

Dev phải cập nhật và tải về profile mới nếu muốn thêm một thiết bị mới hoặc certificate bị hết hạn. Ngoài ra điều này đòi hỏi tốn nhiều thời gian khi setup một máy tính mới để sẽ tiếp tục code trên project cũ.

## Cách tiếp cận mới 

Chia sẻ một certificate trong team của bạn để đơn giản hóa thiết lập của bạn và ngăn ngừa lỗi. Tưởng tượng sẽ có một nơi làm trung tâm, nơi certificates của bạn và profiles được lưu giữ, nơi mà mọi người trong nhóm có thể truy cập chúng trong suốt quá trình xây dựng.

{{% img src="/images/2016-07-24-match-flow.png" class="third center" %}}

## Lợi ích của Match

- Tự động đồng bộ hóa các certificate keys và profiles iOS cho tất cả các thành viên trong nhóm của bạn sử dụng git
- Xử lý tất cả việc nặng nhọc của việc tạo và lưu trữ certificates và profiles
- Cài codesigning trên một máy mới trong một phút
- Được thiết kế để làm việc với các ứng dụng với nhiều target và bundle id
- Toàn quyền kiểm soát các tập tin của bạn và Git repo, không có dịch vụ bên thứ ba tham gia
- Provisioning profile sẽ luôn được lấy đúng
- Dễ dàng tạo lại profile và certificate nếu tài khoản hiện tại của bạn đã hết hạn hoặc hồ sơ không hợp lệ
- Tự động gia hạn profiles của bạn để lấy  tất cả các thiết bị của bạn đưa vào profiles bằng cách sử dụng option --force
- Hỗ trợ cho nhiều tài khoản Apple và nhiều nhóm cùng lúc
- Tích hợp chặt chẽ với Fastlane để có thể làm việc với [gym](https://github.com/fastlane/fastlane/tree/master/gym) và các công cụ khác của fastlane

## Cách sử dụng

### Cài đặt

- Sử dụng brew để cài đặt match

```
brew install match
```

### Khởi tạo với iOS Project

- Tạo một repo git mới để chứa certificates. Repo này **PHẢI LÀ PRIVATE GIT REPO**. GitHub hoặc BitBucket là lựa chọn tốt hiện giờ. Hoặc có thể sử dụng gitlab và một server riêng để dựng version control system rồi tự chơi trong team.
- Vào project iOS và chạy lệnh và thực hiện theo các bước để init Matchfile

```
match init
```

- Sau khi thực hiện theo hướng dẫn, mở Matchfile để xem các thiết đặt mặc định. Thiết đặt mặc định sẽ được gọi khi dùng lệnh match không có bất kì tham số nào

```
match
```

```
git_url "<git_repo_url>"

type "development" # Kiểu mặc định, có thể là: appstore, adhoc hoặc development

app_identifier "<app.bundle.id>" 
username "<apple-account@email.com>" # Your Apple Developer Portal username
```

- Để xem thêm các thiết đặt để thêm vào có thể dùng lệnh
``match --help``
- Sau khi thiết lập các thông số mặc định, chúng ta sẽ có được:
    + Thông số mặc định cho iOS project
    + Certificates và provisionsing profile trên private repo
    + Các biến môi trường để đưa vào xcode. Với nó chúng ta có thể build app ra thiết bị thật

### Load provisioning vào xcode
{{% img src="/images/2016-07-24-match-demo.gif" class="third center" %}}

- Sau khi chạy lệnh ``match``, chúng ta sẽ có biến môi trường để đưa vào trong Xcode. Với biến môi trường đó, khi chúng ta cần provisioning profile để ký lên file và deploy lên máy thật, Xcode sẽ lấy nó ra từ nơi match đã lưu trữ để sử dụng.
- Biến môi trường sẽ có dạng

```
sigh_<bundle_id>_<environment> 

# enviroment có thể là: appstore, adhoc, development
```