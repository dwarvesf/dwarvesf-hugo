---

title: Giới thiệu fastlane
draft: false
description: "Fastlane - Connect all iOS and Android deployment tools into one streamlined workflow"
date: "2016-03-22T20:00:00+07:00"
categories: intro, ios, android, fastlane

coverimage: 2016-21-05-fastlane-banner.png

excerpt: "Fastlane là một công cụ hỗ trợ cho các lập trình viên iOS và Android tự động hóa các công việc tẻ nhạt như tạo ảnh screenshot, làm việc với provisioning profile và release ứng dụng trên store."

authorname: Hiếu Phan
authorlink: https://www.facebook.com/hieuphan.sng
authortwitter: hieutieutu
authorgithub: hieuphq
authorbio: iOS Craft
authorimage: hunter.png

---

## fastlane
Đây là bài mở đầu trong chuỗi các bài viết giới thiệu về [**fastlane**](https://fastlane.tools) và cách sử dụng các công cụ của [**fastlane**](https://fastlane.tools)

Khi đưa ứng dụng lên trên store chúng ta sẽ luôn đối mặt với vấn đề với việc cung cấp các thông tin chi tiết của ứng dụng. Các bước tạo một ứng dụng trên iOS:

- Tạo bundle id cho từng app. Tạo ứng dụng trên iTunes Connect
- Tạo profiles, cetificates, provisioning
- Thông tin ứng dụng: mô tả ứng dụng, loại ứng dụng
- Upload ảnh chụp màn hình(screenshots) với các độ phân giải khác nhau với từng ngôn ngữ khác nhau
- Đóng gói thành file và upload lên store
- ...

### Ước gì mọi thứ đơn giản hơn

[**fastlane**](https://fastlane.tools) là một dự án mã nguồn mở ra đời nhằm hỗ trợ lập trình viên iOS và Android thực hiện việc deploy ứng dụng của mình lên App Store một cách đơn giản.

Cùng với fastlane bạn sẽ thấy việc release sản phẩm lên app store sẽ không còn phức tạp và mệt mỏi click chuột với các bước thực hiện phức tạp nữa thay vào đó là **Một Dòng Lệnh**

## Lợi ích
Dev khi sử dụng các công cụ của fastlane cảm thoải mái:

- Setup một lần cho một team, sử dụng lại nhiều lần cho nhiều project khác nhau
- Thao tác đơn giản. Đa phần mọi tool sau khi đã config, chỉ cần dùng một dòng lệnh để thực hiện các công việc phức tạp
- Dùng chung resource trong toàn team, giảm thời gian tạo môi trường phát triển cho thành viên mới.

## Các [công cụ](https://github.com/fastlane/fastlane#fastlane-toolchain) trong fastlane

**Công cụ giành cho iOS**

- [*scan*](https://github.com/fastlane/fastlane/tree/master/scan): **Test** ứng dụng **iOS** và **Mac**
- [*deliver*](https://github.com/fastlane/fastlane/tree/master/deliver): Upload **screenshots**, **metadata**, và **app** lên **App Store**
- [*snapshot*](https://github.com/fastlane/fastlane/tree/master/snapshot): Tự động chụp **screenshots** theo từng ngôn ngữ trên device khác nhau
- [*frameit*](https://github.com/fastlane/fastlane/tree/master/frameit): Đưa **screenshots** vào từng thiết bị một cách nhanh chóng
- [*pem*](https://github.com/fastlane/fastlane/tree/master/pem): Tạo và renew **push notification profile** trên các ứng dụng iOS
- [*sigh*](https://github.com/fastlane/fastlane/tree/master/sigh): Tạo, renew, download và sửa **provisioning profiles**.
- [*produce*](https://github.com/fastlane/fastlane/tree/master/produce): Tạo một **App mới** trên **iTunes Connect** và **Dev Portal**
- [*cert*](https://github.com/fastlane/fastlane/tree/master/cert): Tạo tự động và chỉnh sửa **iOS Signing Certificates**
- [*spaceship*](https://github.com/fastlane/fastlane/tree/master/spaceship): Được viết bằng Ruby. Dùng để **truy cập** đến **Apple Dev Center** và **iTunes Connect**
- [*pilot*](https://github.com/fastlane/fastlane/tree/master/pilot): Quản lý TestFlight **testers** và các phiên bản đã release trên TestFlight
- [*boarding*](https://github.com/fastlane/boarding): Tạo trang web để gởi lời mời **dùng thử beta release** tới người dùng một cách dễ dàng
- [*gym*](https://github.com/fastlane/fastlane/tree/master/gym): **Build** ứng dụng iOS
- [*match*](https://github.com/fastlane/fastlane/tree/master/match): Đồng bộ hoá **Certificates** và **Profiles** trong toàn team bằng git

**Công cụ cho Android**

- [*supply*](https://github.com/fastlane/fastlane/tree/master/supply): Quản lý ứng dụng trên **Google Play**. Update, Release các phiên bản
- [*screengrab*](https://github.com/fastlane/fastlane/tree/master/screengrab): Tự động chụp **screenshots** theo từng ngôn ngữ trên nhiều device khác nhau

## Workflow trong fastlane

{{% img src="/images/2016-21-05-intro-fastlane-tree.png" class="third center" %}}

## Tóm lại

Trong quá trình phát triển ứng dụng fastlane hỗ trợ lập trình viên từ việc chuẩn bị môi trường lập trình, đến việc đưa app đến tay người dùng chỉ bằng thao tác một dòng lệnh.