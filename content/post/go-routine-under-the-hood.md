---

title: Goroutine under the hood
draft: false
date: "2017-06-05T14:36:15+07:00"
categories: go routine, programming, concurrency

coverimage: 2015-02-05-revel-installation-banner.png

excerpt: "Trong bài này mình sẽ đi sâu vào goroutines và cơ chế hoạt động của nó."

authorname: RuniVn
authorlink: https://www.facebook.com/lnthach
authorgithub: RuniVN
authorbio: Backend Engineer
authorimage: cotton.png

---

Chắc các bạn cũng không lạ lẫm gì Go nữa, Go là một ngôn ngữ backend được phát triển bởi Google.

![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/h46t11xlnx_blob)

Một vài điểm mạnh nổi bật trong Go:

- Static binaries
- Concurrency
- High performance

Trong đó concurrency được coi là first class citizen. Trong bài này mình sẽ đi sâu vào goroutines và cơ chế hoạt động của nó.

# Một ít kiến thức căn bản

### Phân biệt parallelism và concurrenncy:
Cả hai đều là cách để thực hiện multi processing programming, nhưng:

- Concurrency là việc handle nhiều thứ cùng một lúc. Thử tưởng tượng bạn đang tung bóng và bắt bóng trên tay, bạn có 4 quả bóng, nhưng một lúc bạn chỉ có thể tung một quả bằng tay phải, giữ một quả bằng tay trái và hai quả còn lại ở trên bầu trời.
- Parallelism là việc nhiều tác vụ đang chạy cùng một lúc(ví dụ multi processor). Bạn có thể vừa giặt đồ, vừa đọc sách, 2 tác vụ này chạy song song với nhau và không cần xài chung tài nguyên gì.

### Phân biệt preemptive scheduling và cooperative scheduling:
Tại mỗi thời điểm chỉ có một process được thực thi, vì vậy sẽ có nhiều loại scheduling CPU sao cho đạt hiệu quả tùy mục đích sử dụng nhất.
 - Preemptive scheduling là khi các process sẵn sàng nhường quyền điều khiển CPU.
 - Cooperative(hay còn gọi là non premptive): Khi một process được điều phối CPU, nó sẽ sử dụng CPU cho đến khi nó giải phóng(bằng cách kết thúc hoặc qua next state).

### Phân biệt process, thread và goroutine:

-  Process hiểu nôm na là một tiến trình xử lý của máy tính. Thuở xa xưa, máy tính chỉ chạy được một process trong một thời điểm. Khi multi processing ra đời, [time sharing model](https://en.wikipedia.org/wiki/Time-sharing) trở nên phổ biến. Mỗi process sẽ cung cấp resource riêng biệt để thực hiện chương trình.

Time sharing là một cách để share resource của máy tính cho các process, hay nói cách khác là các process có thể đồng thời làm việc trên một single core computer.

Nói vậy thôi, nhưng nó chỉ là "ảo ảnh" của concurrency. Thực chất trong đó là việc switch sự phân bố của CPU rất nhanh giữa các active process với nhau. Để làm được chuyện đó cần phải lưu lại state của một process, và khởi động lại state của một process khác.

Đó chính là context switching.

Context switching cost cho các process rất nặng nề, bao gồm việc phải store tất cả register của CPU.

- Thấy nặng nề quá nên đẻ ra thằng thread. Thread thật ra giống y chang process, nhưng nó là thực thể nằm trong process, và được cái là cho phép share resource. Process này không thể xài chung tài nguyên với process khác, nhưng thread trong cùng một process có thể xài chung tài nguyên với nhau.

Tuy vậy, cost để context switching giữa các thread còn khá cao, vì mỗi thread cũng chứa rất nhiều state.

-  Goroutine lấy ý tưởng của thread và phát huy. Thử tìm hiểu xem sao.

# Goroutine
![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/fy6g2oyuqm_blob)

Các bạn hiểu nôm na một goroutine là một function mà có thể chạy đồng thời với các function khác. Các goroutine share nhau address space.
Không khác gì thread nhỉ?

Một số đặc điểm goroutine:

- Goroutine là cooperative.
- Compiler sẽ biết register nào được sử dụng vào tự động lưu nó
- Context switch của Goroutine xảy ra ở 2 thời điểm: khi một go routine đang chờ data để xử lý (channel operation) hoặc cần thêm space để nhét data (IO, GC).

# So sánh goroutine và thread

- Về bộ nhớ: Bạn khởi tạo một goroutine chỉ mất 4Kb stack trong khi khởi tạo một thread thì lại cần từ 1- 4Mb. => Dùng goroutine để multiplex request cho server vô cùng đơn giản khi bạn có thể spawn cả chục nghìn go routine, còn nếu 1 thread - 1 request thì rất dễ dẫn tới out of memory.
- Setup/teardown cost: Thread sẽ expensive trong việc này vì bạn phải request OS resource và trả lại khi dùng xong(thường cách hay dùng sẽ là thread pool để hạn chế việc này). Còn với goroutine thì việc khởi tạo/hủy đều thực hiện ở run time và cost cho việc này rất rẻ.
- Context switching: Thread sử dụng preemptive scheduling, khi switch phải save/restore 16 registers trong khi Go routine sử dụng cooperative và chỉ cần 3 register(PC, DX, SP).

# Multiplex goroutine
Bởi vì Goroutine là cooperative, nên OS gần như không còn dính dáng tới việc đưa ra quyết định schedule. Đảm nhận việc này là Go scheduler.

Có 3 model cơ bản trong multi threading. Đó là N:1, 1:1 và N:M
- N:1(user space thread) là khi có nhiều thread chạy trên cùng một OS thread. Cùng một OS thread thì cho phép việc context switch rất nhanh, nhưng lại không thể tận dụng được multi core system. Tức là trong một lúc chỉ có một thread được execute, như vậy nếu 1 thread đang bị block bởi IO, thì mấy thread khác cũng không thể làm gì được.
- 1:1(kernel thread) là 1 thread sẽ gắn với một OS thread. Cái này thì multi core được, nhưng context switch lại expensive.
- N:M, đây là cách của Go sử dụng, chắc các bạn cũng đoán được, đó là N go routines sẽ chạy được trên M OS thread. Như vậy sẽ vừa quick context switch vừa tận dụng được multi core. Cơ mà để làm được như vậy, thì Go scheduler phải tay to, và xử lý cực kì phức tạp.

# Go scheduler

Trong Go scheduler sẽ có 3 thực thể. M P G
![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/7tt20uu4gq_blob)

M đại diện cho OS thread.(machine)

P là processor, nó sẽ giữ context tương ứng với một OS thread.

G là goroutine.

![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/ndz0upn5ir_blob)


Trên hình trên chúng ta thấy được 2 M, có giữ context P, mỗi cái sẽ chạy một goroutine G (Lưu ý là để chạy goroutine, M phải giữ context P)

G màu xám là những go routine đang pending, và sẵn sàng để được schedule. Mỗi context P sẽ nắm giữ một list G màu xám như vậy. Cứ mỗi `go` statement được chạy, nó sẽ được add vào run queue. Khi tới thời điểm, context sẽ pop một goroutine ra, allocate cho nó lên stack, set cho nó một instruction pointer và cho nó chạy.

M và G hẳn là đã rõ rồi, cơ mà P ở đây vai trò là gì? Tại sao không gắn thẳng goroutine vào thread mà phải thông qua context?

Nó sẽ rơi vào trường hợp sau đây, đó là khi thread đang chạy bị block. Nguyên nhân gây ra block có thể là IO hay GC.
Ví dụ khi gọi system call, ghi file chẳng hạn, thì trong thời gian block, go scheduler sẽ pass context này cho thread khác để có thể tiếp tục chạy.
![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/djsaexr43v_blob)

Như hình trên, M0 đang handling một cái syscall, điều này làm những goroutine trong running queue sẽ ko được schedule, nên Go scheduler sẽ pass context P cho M1. Lưu ý là M1 có thể được tạo ra trong lúc đó, hoặc lấy ra từ thread cache.

Khi M0 làm xong syscall, thì nó sẽ:
- Tìm kiếm xung quanh, bằng cách chôm 1/2 goroutine run queue của thread khác
- Nếu không tìm thấy gì, nó sẽ đặt mình vào thread cache và ngủ.

# Tại sao Goroutine lại nhẹ như vậy?
 Để khởi tạo goroutine chỉ mất tầm 4KB trong khi bạn cần 4Mb để có thể tạo ra một thread.

 Lí do là Goroutine có thể tăng/giảm kích thước khi cần trong lúc runtime(dynamic allocation).
![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/5nb52d9gmf_blob)

Go sử dụng segmented stacks. Cho các bạn chưa biết thì segmented stacks là loại stack mà cho phép tăng/giảm stack space tùy vào mục đích sử dụng, và quá trình này thực hiện ở runtime.

Quá trình tăng stack khi cần thiết của một go routine sẽ thực hiện như sau:
- Một go routine khi init sẽ có 4KB space
- Nếu quá tải, Go runtime sẽ allocate thêm stack. Việc quản lý một function có run out of memory hay không được thực hiện bởi `prologue`. Mỗi function đều có một prologue để quản lý bộ nhớ.


# Goroutine blocking
Goroutine sẽ bị block trong các trường hợp sau:
- Network
- Sleep
- Channel operations

Khi một goroutine bị block, nó sẽ không khiến thread mà nó đang nằm trên bị ảnh hưởng theo.

Nếu các bạn để ý, goroutines giống như một lớp abstraction của thread. Nó giúp programmer không phải làm việc trực tiếp với threads, và OS thì hầu như không biết sự tồn tại của go routine.
![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/mhqrpx4uab_Screen%20Shot%202017-03-28%20at%205.06.11%20PM.png)

Cái mà OS thấy chỉ đơn giản là một process ở user level xin được cấp phát và chạy multiple threads. Việc schedule goroutines trên threads tất tần tật chỉ đơn thuần là việc xây dựng một môi trường ảo ở runtime.

Tất cả I/O trong Go đều là blocking. Vậy xử lý những tác vụ async như network I/O thì như thế nào?

Để giải quyết vấn đề async IO thì trong Go sẽ có một phần để convert từ non-blocking sang blocking I/O. Phần này gọi là `netpoller`. Công việc nó là nó sẽ ngồi và đợi events từ các goroutines mà muốn thực hiện network I/O, sau đó dựa vào tập file descriptor từ OS để quyết định goroutines nào sẽ được perform I/O.

# Q&A
Q: Tuy context switch của goroutines rẻ, nhưng mà giờ có cả triệu goroutines thì nó cũng chậm chứ?
A: Hỏi hay đấy, nhưng go scheduler cũng giống thread scheduler. Với các OS ngày nay thì độ phức tạp của scheduling algo là O(1). Nên việc có bao nhiêu goroutines không ảnh hưởng tới context switch cost.

Q: Ủa sao cái blocking goroutine mechanism của netpoller nhìn giống giống epoll/kqueue trong Unix vậy.
A: Pro ghê, cách mà goroutines được xử lý khi bị blocking khá giống với event driven trong C. Thật ra under the hood thì Go cũng sử dụng epoll/kqueue luôn. Bạn có thể đọc source Go ở [netpoller](https://golang.org/src/runtime/netpoll.go) để tìm hiểu thêm.

# Nguồn
1. Analysis of the Go runtime scheduler - http://www.cs.columbia.edu/~aho/cs6998/reports/12-12-11_DeshpandeSponslerWeiss_GO.pdf
2. The Go net poller - https://morsmachine.dk/netpoller
3. The Go scheduler - https://morsmachine.dk/go-scheduler
4. Why Go routines stack infinite - https://dave.cheney.net/2013/06/02/why-is-a-goroutines-stack-infinite
5. How Go routines work - http://blog.nindalf.com/how-goroutines-work/
