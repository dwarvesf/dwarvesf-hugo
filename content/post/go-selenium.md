
---

title: Sử dụng go-selenium để crawl dữ liệu
draft: false
description: "Một thư viện để crawl dữ liệu với selenium"
date: "2016-02-26T23:49:15+07:00"
categories: crawl, go, selenium

coverimage: 2015-01-28-golang-banner.png

excerpt: " Crawl là một vấn đề hay gặp trong quá trình làm software. Ví dụ lấy tin tức, tin giảm giá, vé xem phim... là những dạng của crawl. Một cách khá đơn giản đó là phân tích HTML, đọc các thẻ và rút trích dữ liệu."

authorname: Lê Ngọc Thạch
authorlink: https://www.facebook.com/lnthach
authortwitter: runivn
authorgithub: RuniVN
authorbio: Fullstack
authorimage: chao.png

---

## Crawl dữ liệu
Crawl là một vấn đề hay gặp trong quá trình làm software. Ví dụ lấy tin tức, tin giảm giá, vé xem phim... là những dạng của crawl. Một cách khá đơn giản đó là phân tích HTML, đọc các thẻ và rút trích dữ liệu. Thư viện trên Go mình hay dùng đó là [goquery](https://github.com/PuerkitoBio/goquery).

Tuy nhiên việc crawl một trang bằng đọc HTML thuần sẽ không work được trong một số trường hợp như: dữ liệu được load bằng ajax(lúc đọc HTML sẽ chỉ thấy wrapper chứ không thấy dữ liệu) hay muốn vào được trang cần crawl thì phải qua bước login,...

Trong bài này mình sẽ lấy một ví dụ, mình muốn crawl lấy những giảm giá của amazon: [amazon deal](http://www.amazon.com/gp/goldbox/all-deals/ref=gbps_ftr_s-3_3022_wht_541966?ie=UTF8&*Version*=1&*entries*=0&gb_f_GB-SUPPLE=sortOrder:BY_SCORE,enforcedCategories:3760911%252C2335752011%252C541966&pf_rd_p=2292853022&pf_rd_s=slot-3&pf_rd_t=701&pf_rd_i=gb_all&pf_rd_m=ATVPDKIKX0DER&pf_rd_r=14CQSB5TF4GTC2RNHDAG)
Trang này javasript sẽ gọi ajax lấy dữ liệu và sau đó mới đổ vào cây DOM. Khi dùng goquery đọc HTML thì sẽ không thấy được các thẻ div như khi inspect element.

Với những loại như thế này, mình sử dụng selenium để chạy web trên browser thật, thực hiện thao tác để được trang HTML fully load rồi mới trích xuất dữ liệu.

Selenium chạy trên nền JVM, khá nổi tiếng trong lĩnh vực automation test. Nó cho phép mình chạy script test trên browser thật.
Cách làm của mình sẽ là: Dùng selenium chạy trang amazon lên, đợi javascript load xong và sau đó crawl dữ liệu bình thường.

## Cách cài đặt

Đầu tiên các bạn vào link của [seleniumhq](http://docs.seleniumhq.org/download/) để tải và cài đặt seleniumhq. Seneliumhq đóng vai trò như là một server, sẽ nhận các request được gửi từ code Go của mình.

Để chạy, chúng ta vào thư mục chứa file jar và chạy câu lệnh:

```java -jar selenium-server-standalone-2.50.1.jar -port 8081```

![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/Screen%20Shot%202016-02-26%20at%203.57.22%20PM.png_uka1cbcuxl)

=>> Chúng ta được một server selenium chạy ở port 8081.

Tiếp theo các bạn kéo goselenium về bằng go get:

```go get sourcegraph.com/github.com/sourcegraph/go-selenium```

Việc kế tiếp là cài đặt browser, mình chọn Firefox. Các bạn lưu ý, khi chạy trên local thì chỉ cần cài đặt Firefox trên web là được. Còn khi setup trên host thì các bạn cần cài đặt firefox bằng shell script. Các bạn có thể tham khảo [cách setup selenium trên Ubuntu 14.04](https://gist.github.com/curtismcmullan/7be1a8c1c841a9d8db2c)

Setup đã xong! Giờ vào code Go thôi.

Chúng ta cần:
- Remote vào server selenium
- Truy xuất tới đường dẫn amazon deal
- Tiến hành phân tích HTML để lấy thông tin, mình sẽ in ra thông tin page title và image sản phẩm đầu tiên.
```
func main() {
	var webDriver selenium.WebDriver
	var err error
    // set browser as firefox
	caps := selenium.Capabilities(map[string]interface{}{"browserName": "firefox"})
    // remote to selenium server
	if webDriver, err = selenium.NewRemote(caps, "http://localhost:8081/wd/hub"); err != nil {
		fmt.Printf("Failed to open session: %s\n", err)
		return
	}
	defer webDriver.Quit()

	err = webDriver.Get(URL_AMAZON_DEAL)
	if err != nil {
		fmt.Printf("Failed to load page: %s\n", err)
		return
	}
	// sleep for a while for fully loaded javascript
	time.Sleep(4 * time.Second)
	// get title
	if title, err := webDriver.Title(); err == nil {
		fmt.Printf("Page title: %s\n", title)
	} else {
		fmt.Printf("Failed to get page title: %s", err)
		return
	}

	var elem selenium.WebElement
	elem, err = webDriver.FindElement(selenium.ByCSSSelector, "#widgetContent")
	if err != nil {
		fmt.Printf("Failed to find element: %s\n", err)
		return
	}

	var firstElem selenium.WebElement
	firstElem, err = elem.FindElement(selenium.ByCSSSelector, ".a-section .dealContainer")
	if err != nil {
		fmt.Printf("Failed to find element: %s\n", err)
		return
	}
    // get image
	image, err := firstElem.FindElement(selenium.ByCSSSelector, "img")
	if err == nil {
		img, _ := image.GetAttribute("src")
		fmt.Println(img)
	}
}
```
Chạy code lên chúng ta được

```
    Page title: Gold Box Deals | Today's Deals - Amazon.com

    https://images-na.ssl-images-amazon.com/images/I/51eU5JrGAXL._AA210_.jpg
```

Như vậy chúng ta đã lấy được thông tin cần lấy.


## Kết luận
Trên đây là những gì mình tìm hiểu được khi gặp vấn đề về crawl trong quá trình software development, ở đây là ngôn ngữ Go.
Selenium có thể giúp chúng ta trong nhiều trường hợp khác, ví dụ những trang web cần đăng nhập, các trang web có captcha...
Nếu ai có kinh nghiệm gì khác, mong các bạn đóng góp thêm.




