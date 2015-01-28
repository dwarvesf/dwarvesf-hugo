
---

title: Giới thiệu về Go
draft: false
description: "Hugo - a static site generator"
date: "2015-01-26T23:49:15+07:00"
categories: intro, go, hugo

coverimage: 2015-01-25-hugo-cover.png

excerpt: "Ở phần trước tui đã giới thiệu với các bạn Hugo là gì và các thành phần cơ bản của Hugo. Ở bài này tui sẽ tập trung đi vào cấu hình và deploy site này lên Github Pages."

authorname: Nam Bùi Vũ
authorlink: 
authortwitter: 
authorgithub: nambv
authorbio: Scouting Unit
authorimage: inhel.png

---

Tới thời điểm này, khá nhiều ngôn ngữ đã ra đời phục vụ việc lập trình cho phía Server-side như: PHP, Ruby on Rails, Python, NodeJs... Mỗi ngôn ngữ đều có những ưu khuyết điểm riêng. Ở đây, mình sẽ giới thiệu một ngôn ngữ còn khá lạ lẫm với người Việt, đó là Go - một ngôn ngữ lập trình Server-side được phát triển bởi Google.

## 1. Giới thiệu Go
Go là một ngôn ngữ lập trình đồng thời (Concurrent Program) được Google giới thiệu lần đầu tiên vào nằm 2009. Go được các thành viên phát triển nói đến về một ngôn ngữ cho server, được phát triển cho cộng đồng trên nền C.

Go được ví như C - rút gọn. Những gì bạn có thể viết được trên C, bạn có thể viết được trên Go với tốc độ nhanh hơn gấp 5 lần với khác biệt rất nhỏ. Có thể đối với những bạn thường lập trình trên C# hay Java thì Go nhìn có vẻ khá lạ lẫm, nhưng khi bạn đã làm quen dc với Go, bạn sẽ thấy Go khá thú vị và tốc độ lập trình rất nhanh (như mình đã đề cập trước đó)

Một trong những điểm mình thích nhất ở Go là tốc độ xử lý. Trong khi C được đánh giá có tốc độ xử lý cực nhanh, thì Go chỉ bị C bỏ lại với khoảng cách rất gần! Trước khi nhìn vào benchmark của Go, mình sẽ giởi thiệu với các bạn các cú pháp syntax Go chuẩn, các kiểu dữ liệu cơ bản, và so sánh nó với C.

## 2. Go, một ngôn ngữ server ngắn gọn
Nói đến đây, bạn có thấy Go thú vị và hấp dẫn hơn một tẹo rồi phải không? Mong là vậy! Dù rồi hay chưa, tôi sẽ tăng tính thuyết phục và đặc sắc của Go bằng cách cho bạn xem những syntax đẹp và so sánh nó với C!
Thứ nhất, khai báo biến (variable) trong Go vô cùng ngắn gọn. Thay vì khai báo cụ thể kiểu dữ liệu của biến, Go có bộ tham chiếu kiểu dữ liệu (type inference) thực hiện việc gán kiểu và khởi tạo biến cho chúng ta. Để khai báo một biến đơn giản...
Trong C:
int myVar = 33;
Trong Go:
myVar := 33
 Ngắn gọn hơn C, bạn có thể thấy như thế! Không chỉ có thế, Go không đòi hỏi kết thúc câu lệnh bằng dấu “;”, trả về nhiều kết quả trong function, và có thể trả về cặp (pair) kết quả và lỗi cho bạn (result, err). Pair cũng là cách chuẩn để xử lý lỗi trong Go. Tôi sẽ đề cập kỹ hơn ở các bài viết về syntax trong Go.
Hơn vậy, bạn có thể định nghĩa một biến bằng utf-8, một điều khá mới mẻ trong Go, ví dụ:
biếnSố := 33
Bây giờ, ta tiến hành xét một chương trình Hello World trong Go và C:

helloworld.c
```
#include <stdio.h>
 
int main ()
{
  printf ("Hello World!\n");
}
```

helloworld.go
```
package main
 
import (
    "fmt"
)
 
func main() {
    fmt.Println("Hello World!")
}
```

Chúng ta có thể thấy được sự tương đồng giữa Go và C qua đoạn code trên
Bạn sẽ thấy được Go ngắn gọn hơn C rõ ràng hơn khi bạn viết các chương trình lớn, phức tạp và cần xử lý đồng thời (concurrency). Có một bài blog so sánh C và Go, cũng như các chi tiết về những lợi thế về syntax của Go so với C: http://www.syntax-k.de/projekte/go-review
Tiếp theo. chúng ta sẽ so sánh khả năng chịu tải của Go để xem Go có thực sự chịu tải tốt đúng như tuyên bố của những lập trình viên hay không

## 3. Khả năng chịu tải của Go
Hãy nhìn cách Go chạy một loạt các chương trình đơn giản nhưng lặp đi lặp lại trong bảng dưới đây:

{{% img src="/images/2015-01-28-go-vs-ruby.png" class="third right" %}}

( Website test trực tuyến: http://benchmarksgame.alioth.debian.org/ )
Như chúng ta thấy từ số liệu thống kê, Golang hiệu quả hơn Ruby rất nhiều!!! Trong chương trình đầu tiên - ‘fasta-redux’, Ruby mất 110 giây để thực thi xong, nhưng Go chỉ mất 1.79 giây. Nhanh hơn gấp gần 100 lần! Quá ấn tượng phải không!!!
Go không chỉ ấn tượng về tốc độ xử lý, mà còn thuận lợi về xử lý đồng thời hơn hầu hết các ngôn ngữ server hiện giờ. Go sử dụng các Goroutines (mình sẽ nói rõ hơn về Goroutlines ở những bài viết sau).

Go đã cung cấp được chúng ta một ngôn ngữ lập trình ở server với tốc độ cực nhanh, một cú pháp ngắn gọn, hằng trăm package mặc định hữu dụng, cơ chế xử lý đa luồng đồng thời, và vô số thư viện được phát triển bởi các lập trình viên trên khắp thế giới. Tất cả giúp chúng ta xây dựng website, server bằng Go một cách nhanh và hiệu quả nhất.

## 4. Tóm tắt
Với tuổi đời còn khá non trẻ (từ 2009) so với những ngôn ngữ khác (C hơn 40 năm, C++ hơn 30 năm, Ruby khoảng 20 năm, Java cỡ 17 năm, C# tầm 10-12 năm...) thì 5 năm thực sự là khoảng thời gian không nhiều để ta so sánh những sản phẩm nổi bật được viết và phát hành bằng Go so với những ngôn ngữ khác. Tuy nhiên, Go đang được Google và cộng đồng lập trình viên tiếp tục phát triển và hoàn thiện. Tin vui là hiện nay, cộng đồng quan tâm đến Go trên thế giới không nhỏ!
Cộng đồng Go lớn nhất hiện nay trên thế giới là [`Gopherarcademy`](http://blog.gopheracademy.com/), bên cạnh đó còn có  [`GoMeetUp`](http://go.meetup.com/)
Một trong những event lớn về Go trong thời gian gần đây là ngày 23-25/01/2015 vừa qua, [`Gopher Gala`](http://gophergala.com/) đã đứng ra tổ chức sự kiện Hackathon đầu tiên cho Go trên toàn thế giới
Go đang dần được chấp nhận và triển khai rộng rãi trên nhiều Startup và Công ty thương mại. Nhiều nhà cung cấp Saas/ Paas sử dụng Go trong dự án của họ. Dịch vụ gửi mail [`SendGrid`](http://sendgrid.com/blog/convince-company-go-golang/) cũng đang áp dụng Go để xây dựng hệ thống mạnh mẽ hơn, nhanh hơn và đáng tin cậy hơn!
Túm cái váy lại, nếu bạn đang tìm kiếm một ngôn ngữ lập trình đồng thời, song song, đơn giản, sexy và tuyệt vời, hãy đến với Go!
 

