---

title: Grand Central Dispatch
draft: false
description: "IOS - Tìm hiểu multi thread trong swift"
date: "2016-07-29T16:21:23+07:00"
categories: intro, ios, swift, gcd, multi thread


authorname: Duy Khang
---

Grand Central Dispatch (GCD) là một phần của ngôn ngữ lập trình. Nó để xử lý và hỗ trợ các queue task.

  GCD sẽ hỗ trợ việc xử lý multi thread giúp cho ứng dụng mượt hơn, giảm thiểu tối đa bug có thể xảy ra khi xử lý đồng thời, tối ưu hiệu suất của ứng dụng

**Các thuật ngữ GCD:**

* Serial and Concurrency

	Serial là các task được thực thi theo tuần tự, task này xong tới task khác

	Concurrency là các task thực thi đồng thời, không biết task nào sẽ thực thi trước, task nào thực thi sau.

* Synchronous and Asynchronous

	Synchronous trả về kết quả tuần tự và được sắp xếp 

	Asynchronous trả về kết quả ngẩu nhiên và không sắp xếp

* Deadlock

	Hai task thực thi phải chờ nhau kết thúc, task 1 không thể kết thúc nếu task 2 chưa kết thúc và ngược lại.

* Queues

	GCD cung cấp dispatch queues, thực thi theo cơ chế FIFO. Queues gồm serial queues và concurrent queues

Serial queues: các task sẽ hoạt động tuần tự nhau

{{% img src="/images/2016-07-29-ios-serial-queue.png" class="third right" %}}

{{% img src="/images/2016-07-29-ios-code-serial-queue.png" class="third right" %}}

Concurrent queues: Các task không sắp xếp nhau, không chờ task trước kết thúc rồi đến task sau, các task thực thi một cách ngẩu nhiên, và không biết được số lượng task sẽ thực thi cùng một thời điểm.

{{% img src="/images/2016-07-29-ios-concurrent-queue.png" class="third right" %}}

{{% img src="/images/2016-07-29-ios-code-concurrent-queue.png" class="third right" %}}

Queue types: là một serial queue đặt biệt gọi là main thread, queue type sẽ đảm bảo các thread đều thực thi xong, sau đó update lại UI

Khi các luồng được thực thi xong thì sẽ merge vào luồng chính, dưới đây là cách sử dụng concurrent để download ảnh và khi download xong thì merge vào main thread

{{% img src="/images/2016-07-29-ios-code-demo.png" class="third right" %}}

Trong ứng dụng ios, các bạn có thể dùng GCD để xử lý ảnh trên tableview, trong lúc chờ ảnh download từ trên mạng về thì ứng dụng có thể thực thi các task khác, khi ảnh đã tải xong thì quá trình merge lên main thread, không làm ảnh hưởng đến performance của app.


