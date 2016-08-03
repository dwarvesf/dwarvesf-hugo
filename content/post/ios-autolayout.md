---
title: Auto layout trên storyboard cho swift 
date: "2016-07-30T23:09:45+07:00"
draft: false
description: "IOS - Tìm hiểu về auto layout cho swift"
categories: intro, ios, swift, auto Layout

authorname: Duy Khang
---

**Tại sao lại dùng auto layout?**

Khi xây dựng một ứng dụng, chúng ta sẽ xây dựng trên storyboard với simulator là iphone 6. Lúc chạy ứng dụng trên simulator của iphone 6 thì UI hiện lên giống như lúc chúng ta layout, nhưng khi ứng dụng đó cho xoay ngang thì UI của app lúc này sẽ bị thiếu, bị lệch hoặc tràn ra 2 bên, khi đó chúng ta sẽ set frame lại cho từng control, việc set lại như vậy sẽ tốn nhiều thời gian và phải thực thi nhiều lần khi ứng xoay dọc rồi xoay ngang. Với những thiết bị khác nhau, chúng ta phải tìm những thiết bị đó và tuỳ chỉnh layout cụ thể. **Auto layout** sẽ giúp chúng ta làm việc này mà không cần phải set frame nhiều lần, sử dụng auto layout sẽ giúp rút ngắn code lại, làm cho việc layout trở nên dễ dàng hơn.

**Sử dụng auto layout canh giữa cho uibutton**

Xcode cung cấp 2 cách để định nghĩa auto layout

1. Auto layout bar

2. Control drag

**Layout bar**

{{% img src="/images/2016-07-31-ios-layoutbuilder.png" class="third right" %}}

* Align: Tạo alignment contraints

* Pin: Tạo spacing contraints, 

* Issue: Giải quyết các vần đề về layout như update frame, update contraints, clear contraints

Khi add một button vào view, mục đích muốn button đó luôn nằm giữa màn hình thì chúng ta sẽ thao tác như sau

{{% img src="/images/2016-07-31-ios-centerbutton.gif" class="third right" %}}

Sử dụng Pin để tạo các spacing contraint, chúng ta sẽ tạo 2 button có kích thướt bằng nhau, các khoảng cách sẽ co giãn theo từng kích thướt màn hình

{{% img src="/images/2016-07-31-ios-twobutton.gif" class="third right" %}}

Kết quả chúng ta được layout như thế này

{{% img src="/images/2016-07-31-resultautolayout.png" class="third right" %}}

Trong ví dụ trên, chúng ta có sử dụng **control drag** cho button thứ 2, kéo contraint cho button 2 bằng top của button 1, width và height của button 2 cũng bằng với button 1.

**Issue**

{{% img src="/images/2016-07-31-issueautolayout.png" class="third right" %}} 


* Update frame

Update UI đúng vị trí mà chúng ta đã tạo contraint, khi click vào control nhìn thấy viền màu cam thì control đó chưa nằm đúng vị trí của nó, chúng ta cần update lại frame để có có thể nằm đúng vị trí.

* Update contraints

Khi control đã có contraint, nhưng bạn muốn update lại contraint đó, có 2 cách:

- Thứ nhất chúng ta có thể duy chuyển control trên storyboard tới vị trí cần update và click vào update contraints

- Thứ 2 sẽ update control trên ở list contraint của control, ta chỉ việc thay đổi constant hoặc các thuộc tính mà mình mong muốn.

{{% img src="/images/2016-07-31-ios-updatecontraint.gif" class="third right" %}} 

* Clear contraints

Clear contraints: xoá tất cả các contraint hiện có trên control


**Tổng kết**

Bài viết này tổng hợp sử dụng auto layout cơ bản, giúp các bạn mới vào làm ios app có thể hiểu cơ bản về auto layout là như thế nào và cách sử dụng ra sao. Bài tiếp theo chúng ta sẽ tìm hiểu cách auto layout bằng code, một số app chúng ta sẽ viết layout bằng code không sử dụng storyboard vì thế việc sử dụng auto layout cũng bằng code sẽ như thế nào. Cảm ơn các bạn và hẹn gặp hướng dẫn auto layout bằng code tiếp theo.
