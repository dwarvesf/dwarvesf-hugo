---

title: Hướng dẫn sử dụng Testing trong Go
draft: false
description: "Unit Test trong Go"
date: "2015-09-09T15:01:07+07:00"
categories: intro, go, testing

coverimage: 2015-01-25-hugo-cover.png

excerpt: "Như các bạn đã biết, testing trong lập trình cũng quan trọng như việc viết code. Testing đơn giản là đảm bảo phần mềm hoạt động đúng với mong muốn của khách hang và trong quá trình sử dụng, giảm thiểu khả năng xảy ra lỗi."

authorname: Lê Ngọc Thạch 
authorlink: http://runikikat.com
authortwitter: runivn
authorgithub: RuniVN
authorbio: Unknown
authorimage: chao.png

---
- Như các bạn đã biết, testing trong lập trình cũng quan trọng như việc viết code. Testing đơn giản là đảm bảo phần mềm hoạt động đúng với mong muốn của khách hàng và trong quá trình sử dụng giảm thiểu khả năng xảy ra lỗi.
- Vậy làm thế nào để viết test trong Go? Tại sao mỗi file package của go hay có một file dạng filename_test.go đi kèm? 
- Go cung cấp package [testing]( http://golang.org/pkg/testing/) hỗ trợ viết test. Trong bài này mình sẽ giới thiệu cách sử dụng Unit Test trong Go bằng thư viện testify

## Cài đặt 
```
go get  "github.com/stretchr/testify/assert"

```
## Code
Mình sẽ lấy ví dụ từ project của mình.    
Mình có một hàm GetDirectLink nhận vào input là một link bài hát(trong trường hợp này thuộc website nhaccuatui) và output là một list url dùng để download trực tiếp.

```
package nhaccuatui


func (nct *NhacCuaTui) GetDirectLink(link string) ([]string, error) {
	if link == "" {
		return nil, errors.New("Empty Link")
	}

	var listStream []string
	if strings.Contains(link, song) {
		urlList := strings.Split(link, ".")
		if len(urlList) < 4 {
			return nil, errors.New("Wrong Format Link")
		}
		req := httplib.Get(linkDownloadSong + urlList[3])

		var res ResponseNhacCuaTui
		err := req.ToJson(&res)
		if err != nil {
			return nil, err
		}
		if res.Data.StreamUrl == "" {
			return nil, errors.New("Invalid Link")
		}
		listStream = append(listStream, res.Data.StreamUrl)
		return listStream, nil
	}
}
```
Bây giờ mình sẽ viết test cho hàm này. Đầu tiên mình tạo file nhaccuatui_test.go chứa các function về Testing.    
Hàm đầu tiên mình sẽ test link input vào bị rỗng.
```
package nhaccuatui

import (
	"testing"
	"github.com/stretchr/testify/assert"
)

var nct NhacCuaTui

func TestLinkEmptyString(t *testing.T) {
	_, err := nct.GetDirectLink("")
	assert.Equal(t, "Empty Link", err.Error())
}
```
Câu lệnh assert.Equal cho phép so sánh hai giá trị, một là expected value(mình sẽ tính toán trước) và một là actual value(được trả về từ lúc chạy hàm). Trong trường hợp này sẽ trả về true khi err trả về đúng bằng "Empty String" 
## Chạy Test

Giờ chúng ta thử chạy file test trên bằng câu lệnh:
```
go test

```
Lưu ý khi các bạn bỏ file _test.go vào trong thư mục, để chạy các file test trong các thư mục đó các bạn phải chạy câu lệnh
``` 
go test ./...
```
Mình chạy câu lệnh trên và đây là kết quả
{{% img src="/images/firstresultTest.png" class="third right" %}}

Test pass vì actual value và expected value giống nhau.  	

Thử thay thế câu báo lỗi trả về thành Not Empty String và chạy lại go test
```
	assert.Equal(t, "Not Empty Link", err.Error())

```
ta được kết quả


{{% img src="/images/wrongStringReturn.png" class="third right" %}}

Hàm assert có rất nhiều cách sử dụng, ví dụ assert.NotNil, assert.True ... tuỳ ý lựa chọn.

Ngoài cách dùng thư viện testify các bạn có thể sử dụng các function trong testing package của Go. Mình sẽ viết lại hàm test trên bằng cách khác
```

func TestLinkEmptyString(t *testing.T) {
	t.Log("Try to empty link, expect error output")
	_, err :=  nct.GetDirectLink("")
	if err == nil {
		t.Error("Expected error of not nil but it was nil instead")
	}
}

```
## Lời kết

Trên đây là những gì mình tìm hiểu được trong quá trình implement unit testing trong Go. Còn nhiều cấp độ testing khác, rất mong nhận được đóng góp ý kiến từ các bạn.    
Nếu có điều gì muốn trao đổi, liên hệ qua mail thach@dwarvesf.com với mình nha.
