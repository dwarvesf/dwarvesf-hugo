
---

date: "2015-09-10T13:09:56+07:00"
draft: false
title: "Giới thiệu Interface của Go"

description: "Interface trong Go và cách sử dụng"
categories: intro, go, hugo

coverimage: 2015-01-25-hugo-cover.png

excerpt: "Như các bạn đã biết, testing trong lập trình cũng quan trọng như việc viết code. Testing đơn giản là đảm bảo phần mềm hoạt động đúng với mong muốn của khách hang và trong quá trình sử dụng, giảm thiểu khả năng xảy ra lỗi."

authorname: Lê Ngọc Thạch 
authorlink: http://runikikat.com
authortwitter: runivn
authorgithub: RuniVN
authorbio: Unknown
authorimage: gancho.png

---
- Trong bài này mình sẽ trình bày những gì mình tìm hiểu được về interface trong Go, khái niệm, khai báo cũng như cách sử dụng và một vài ví dụ thực tế.

## Khái niệm 
 Interface là một dạng wrapper các khai báo hàm(chỉ là tên của hàm) ở mức độ prototype. Các hàm này sẽ được định nghĩa ở các lớp dẫn xuất, mỗi lớp dẫn xuất sẽ có cách định nghĩa lại hàm khác nhau tương ứng với mục đích sử dụng

## Khai báo

Một interface với hàm SayYourName() trả về một string được khai báo như sau:

 ```
type Hello interface{
	SayYourName() string 
}
 ```
## Cách sử dụng 

Interface trong Go follow concept Duck typing như sau:
```
When I see a bird that walks like a duck and swims like a duck and quacks like a duck, I call that bird a duck.
```
Có nghĩa là nếu một con nào có thể đi như con vịt, bơi như con vịt thì tôi gọi đó là con vịt.

Mình sẽ đưa một ví dụ cụ thể. Mình có struct User, struct này có một hàm SayYourName()
```

type User struct {
	FirstName, LastName string
}

func (u *User) SayYourName() string {
	return fmt.Sprintf("%s %s", u.FirstName, u.LastName)
}
```

Một hàm có param là interface Hello và trả về một string 

```
func Greet(n Hello) string {
	return fmt.Sprintf("Dear %s", n.SayYourName())
}
```
Ở đây, hàm Greet nhận vào một param là interface Hello, và nó cũng chấp nhận <b>bất cứ param nào nếu nó có hàm SayYourName</b>.      
Thử chạy chương trình:
```
func main() {
	u := &User{"Runi", "Lazy"}
	fmt.Println(Greet(u))
}
```
Thật vậy ta có, kết quả "Dear Runi Lazy"

Chú ý là param truyền vào hàm Greet phải là những đối tượng có thể có chứa các hàm của riêng đối tượng đó, nhưng bắt buộc phải có  <b>tất cả</b> những hàm của interface Hello. Giả sử thêm vào interface này một hàm Goodbye():
```
type Hello interface{
	SayYourName() string 
	Goodbye() string
}
``` 
Kết quả ta bị báo lỗi như sau:

{{% img src="/images/interfacewrong.png" class="third right" %}}

## Sử dụng Interface trong Go
Ngoài interface có chứa khai báo hàm, interface còn một khái niệm là empty interface, hay interface{}.
Interface này không có hàm, cũng có nghĩa là tất cả các loại variables hay struct... đều có thể thoả mãn làm param cho hàm nhận vào empty interface.

```
func DoSomething(v interface{}) {
   // ...
}
//Hàm này nhận vào bất cứ loại param nào.
```
Như vậy ta có thể sử dụng empty interface cho các hàm nào mà param truyền vào vẫn chưa xác định cụ thể. Khi vào trong hàm thì tuỳ trường hợp sẽ có các cách tuỳ biến để convert về giá trị chúng ta cần.

Ví dụ, ta có hàm PrintAll nhận vào một mảng giá trị empty interface.
```
func PrintAll(vals []interface{}) {
    for _, val := range vals {
        fmt.Println(val)
    }
}

```
Trong hàm main ta tiến hành convert:
```

func main() {
    names := []string{"stanley", "david", "oscar"}
    vals := make([]interface{}, len(names))
    for i, v := range names {
        vals[i] = v
    }
    PrintAll(vals)
}

```
Một ví dụ khác, mình sưu tầm từ blog [how to use interface in Go](http://jordanorelli.com/post/32665860244/how-to-use-interfaces-in-go):   
Khi nhận response từ Twitter API thì date time có dạng timestamp như sau:
```
"Thu May 31 00:00:01 +0000 2012"
```
Dưới dây là một hàm dùng để in ra kiểu của timeStamp khi nhận từ response:
```
var input = `
{
    "created_at": "Thu May 31 00:00:01 +0000 2012"
}
`

func main() {
    var val map[string]interface{}

    if err := json.Unmarshal([]byte(input), &val); err != nil {
        panic(err)
    }

    fmt.Println(val)
    for k, v := range val {
        fmt.Println(k, reflect.TypeOf(v))
    }
}
```
Chạy hàm trên ta được :


{{% img src="/images/returntwitter.png" class="third right" %}}

Hum.. timeStamp mà lại kiểu string thì chưa hợp lý lắm, thử parse lại về trực tiếp kiểu time.Time 
```
    var val map[string]time.Time
    if err := json.Unmarshal([]byte(input), &val); err != nil {
        panic(err)
    }

```
Thử chạy lại:

{{% img src="/images/panicinterface.png" class="third right" %}}

Lỗi này xảy ra vì không thể parse chuỗi kia về time.Time được (Twitter API được viết bằng Ruby, cách parse sẽ khác với Go).  
Vậy chúng ta thử viết lại hàm parse chuỗi. Ta có interface Unmarshal, được lấy từ [Encode Json Package](http://golang.org/pkg/encoding/json/#Unmarshaler)

```
type Unmarshaler interface {
    UnmarshalJSON([]byte) error
}
```
Ta cần viết lại hàm UnmarshalJSON để có thể parse về timeStamp(sử dụng RubyDate)
```
type Timestamp time.Time

func (t *Timestamp) UnmarshalJSON(b []byte) error {
     v, err := time.Parse(time.RubyDate, string(b[1:len(b)-1]))
    if err != nil {
        return err
    }
    *t = Timestamp(v)
    return nil
}

```
Khi đó, hàm main sẽ được viết lại như sau:
```
func main() {
	var val map[string]Timestamp

	if err := json.Unmarshal([]byte(input), &val); err != nil {
		panic(err)
	}

	fmt.Println(val)
	for k, v := range val {
		fmt.Println(k, reflect.TypeOf(v))
	}
}
```

Chạy chương trình ta được kết quả:
{{% img src="/images/interfacetimestamp.png" class="third right" %}}

Như vậy chúng ta đã vừa tạo một đối tượng có hàm UnmarshalJSON để có thể truyền vào hàm json.Unmarshal trong package encoding/json nhờ đó có được kết quả mong muốn.

## Lời kết
Trên đây là những gì mình tìm hiểu được trong quá trình sử dụng interface trong Go. Interface là một trong những kĩ thuật đặc trưng của Go, mong nhận được ý kiến đóng góp từ các bạn.
Nếu có điều gì muốn trao đổi, liên hệ qua mail thach@dwarvesf.com với mình nha.
