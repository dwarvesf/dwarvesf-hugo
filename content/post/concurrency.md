
---

date: "2015-09-15T13:09:56+07:00"
draft: false
title: "Concurrency trong Go Lang"

description: "Khái niệm và cách sử dụng concurrency trong Go"
categories: intro, go, hugo,concurrency

coverimage: blog-cover.jpg

excerpt: "Concurrency trong Go được đánh giá là một trong những đặc điểm nổi bật nhất của Go. Trong bài này mình sẽ trình bày một số khái niệm căn bản và đưa ra vài ví dụ của concurrency trong Go."

authorname: Lê Ngọc Thạch
authorlink: http://runikikat.com
authortwitter: runivn
authorgithub: RuniVN
authorbio: Unknown
authorimage: gancho.png

---
- Concurrency trong Go được đánh giá là một trong những đặc điểm nổi bật nhất của Go. Trong bài này mình sẽ trình bày một số khái niệm căn bản và đưa ra vài ví dụ của concurrency trong Go.

## Tổng quan
  * Concurrency trong một chương trình là khi chúng ta cho phép chạy nhiều hơn một công việc(task) một cách đồng thời.
  * Concurrency không phải là Parallelism
  * Cocurrency có vào hai khái niệm cơ bản: goroutines và channels

## Chi tiết
Chúng ta sẽ đi vào từng phần của Concurrency trong Go.
#### Goroutines
  - Một goroutine là một hàm mà có thể chạy đồng thời với các hàm khác.
  - Goroutines được xem như như thread nhưng nhẹ hơn, tuy nhiên nó không phải là một tiến trình(process) hay là thread của hệ thống(OS).
  - Lý thuyết hoạt động goroutines dựa trên sự chia sẻ vùng nhớ.
  - Sử dụng bằng cách thêm keyword "go" trước một hàm.
Ví dụ:

```
func say(s string) {
    for i := 0; i < 5; i++ {
        time.Sleep(100 * time.Millisecond)
        fmt.Println(s)
    }
}

func main() {
    say("world")
    say("hello")
}

```
Chạy chương trình này ta có sẽ có kết quả:

{{% img src="/images/routine1.png" class="third right" %}}
Sở dĩ có kết quả này là do hàm say("world") chạy xong mới tới hàm say("hello") được chạy.
Bây giờ ta sửa hàm main lại như sau

```

func main() {
    go say("world")
    say("hello")
}
```
Hàm say với keyword go đứng trước sẽ chạy cùng lúc với hàm say không có keyword go. Ta được kết quả:

{{% img src="/images/routine2.png" class="third right" %}}

Goroutines rất rẻ. Một goroutine được tạo ra chỉ tốn 2KB trong stack, và khi chạy xong bị huỷ bởi runtime. Chúng ta có thể sử dụng goroutines thoải mái mà không phải lo nghĩ về việc tốn kém bộ nhớ.
Chúng ta có thể define số goroutines chạy cùng lúc tối đa bằng khai báo:

```
export GOMAXPROCS=100
```
Một chương trình chạy có thể có một hoặc nhiều goroutines.
Tuy nhiên hàm main lại đặc biệt hơn. Khi hàm main() exit, tất cả các goroutines lập tức bị terminate.
Ví dụ
```
func main(){

  go func(){
    fmt.Println("Hello")
  }()
}
```
Chương trình này sẽ không cho ra kết quả gì, vì hàm anonymous trên sẽ không được thực hiện. Hàm main() exit trước, và goroutine bị terminate.
Nếu chúng ta sử dụng một cách khác:

```
func main(){

  go func(){
    fmt.Println("Hello")
  }()
  time.Sleep(time.Second*5)
}
```
Chương trình sẽ cho ra kết quả là in ra Hello. Chúng ta buộc hàm goroutine phải chạy, trong trường hợp này là làm chậm quá trình kết thúc của hàm main một vài giây.

Nhưng với một hàm main mà có lệnh Sleep trong một vài giây sẽ gây khó hiểu và code không đẹp đẽ lắm.
Từ đó sinh ra một khái niệm mới: WaitGroup.



Một WaitGroup sẽ chờ một tập hợp goroutines kết thúc. Hàm goroutines chính sẽ thêm số goroutines mà nó muốn chờ, mỗi hàm goroutine khi chạy xong sẽ gọi Done(). Cho tới khi mà các goroutines chưa được chạy xong, thì waitgroup sẽ block chương trình tại thời điểm đó.

Sử dụng WaitGroup:
```

func main() {
    var message []int
    var wg sync.WaitGroup //tạo instance

    wg.Add(3) // Thêm 3 goroutines vào danh sách muốn đợi
    go func() {
        defer wg.Done() // sau khi chạy 2 lệnh dưới xong sẽ kết thúc,
                        // trả về done cho wg
        time.Sleep(time.Second * 3)
        messages[0] = 1
    }()
    go func() {
        defer wg.Done()
        time.Sleep(time.Second * 2)
        messages[1] = 2
    }()
    go func() {
        defer wg.Done()
        time.Sleep(time.Second * 1)
        messages[2] = 3
    }()
    go func() {
        for i := range messages {
            fmt.Println(i)
        }
    }()

    wg.Wait() // chừng nào chưa chạy xong chưa chạy xong 3 hàm trên,
              // block chương trình.
}
```
Chúng ta có thể hiểu như sau: Khi wg(WaitGroup) Add n goroutines để đợi, với mỗi goroutine chạy xong, wg sẽ giảm đi 1. Hàm wg.Wait() chỉ được chạy qua khi và chỉ khi wg có số goroutines để đợi bằng 0.

Thử viết lại hàm lúc nãy bằng waitgroup:
```
  var wg sync.WaitGroup
  wg.Add(1)
  go func() {
    defer wg.Done()
    fmt.Println("Hello")
  }()
  wg.Wait()
```
Chúng ta được kết quả tương tự.

#### Channel
  * Channel sinh ra dùng để giao tiếp giữa 2 goroutines, bao gồm gửi và nhận dữ liệu.
  * Channel là reference type.
  * Về cơ bản, concept của channel là "typed pipes". Nó tạo một đường ống liên kết giữa 2 goroutines, chúng ta có thể gửi các object phức tạp qua channel.
  * Channel có thể dùng cho synchronization.

{{% img src="/images/channels.jpg" class="third right" %}}

Sử dụng:
Chúng ta tạo channel bằng <b>make</b>
```
chInt := make(chan int)
chQuacker := make(chan Quacker)
// Quacker là interface
// tất cả hàm nào implement hàm Quack() đều có thể làm việc với channel
```
  * Channel sử dụng kí hiệu mũi tên hướng về bên trái.
Để gửi data thông qua channel:
```
 chanInt <- 3
```
Để nhận data từ channel

```
 x := chanInt
```
Kiểm tra channel đóng
```
 _, ok = <- c // ok bằng true nếu c còn mở
```
Close một channel
```
close(c)
```
Ví dụ:

```

func main() {
  a := hello("A")
  b := hello("B")
  for i := 0; i < 5; i++ {
    fmt.Println(<-a) // lấy data từ channel
    fmt.Println(<-b)
  }
}
func hello(name string) chan string {
  c := make(chan string) // tạo instance channel
  go func() {
    for {
      c <- "Hello from" + name // gửi string vào channel
      time.Sleep(100 * time.Millisecond)
    }
  }()
  return c
}

```
Ta có kết quả:
{{% img src="/images/channel1.png" class="third right" %}}

Một lệnh send trên một channel sẽ block cho đến khi có một lệnh nhận có mặt trên cùng channel đó.

Ví dụ:
```
func main(){
  ch := make(chan int)
  ch <- 42
}
```
Trong hàm này chúng ta cố gắng gửi 42 vào ch, nhưng không có lệnh nhận, vì vậy sẽ gặp deadlock(block forever). Tương tự cho việc nhận từ một channel trong khi nó chưa được send
```
func main(){
  ch := make(chan int)
  recieved := <- 42
}
```
Trong Go có khái niệm select, giống switch case nhưng chỉ dành cho channel:
```
select{
  case <- c1: // thử nhận giá trị từ channel c1
  case x := <- c2 // thử nhận giá trị từ c2 và gán vào x
  case c3 <- value  // thử gửi value vào c3
  default:
}
```
Lưu ý:

  1. Mỗi case phải là một expression nhận hoặc gửi
  2. Tất cả các statement sẽ được duyệt qua. Nếu có một cái sẵn sàng, nó sẽ được chạy. Nếu nhiều cái cùng sẵn sàng, một case sẽ được chạy bằng cách random. Nếu không có cái nào, default sẽ được chạy.
Ví dụ, để set timeout cho một lệnh gửi, nhận của channel
```
chInt := make(chan Int)
select {
 case i := <- chInt:
      fmt.Println("got int",i)
 case <- time.After(time.Second * 5):
}
```
Hàm trên có nghĩa là, chờ để nhận giá trị từ channel vào i, nhưng không quá 5s.
## Lời kết
Trên đây là những gì mình tìm hiểu được về concurrency trong Go - một trong những miracles trong Go.
Nếu có điều gì muốn trao đổi, liên hệ qua mail thach@dwarvesf.com với mình nha.
