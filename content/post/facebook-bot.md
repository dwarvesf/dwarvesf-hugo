---

title: "Viết một facebook messenger bot đơn giản cùng Go + ngrok"
date: "2016-06-08T13:09:56+07:00"
draft: false

description: "Viết một facebook messenger bot đơn giản cùng Go + ngrok"
categories: facebook,bot,messenger,go

coverimage: blog-cover.jpg

excerpt: "Messenger bots của facebook ra cũng khá lâu rồi. Đã có nhiều người sử dụng cho page facebook của mình"

authorname: Lê Ngọc Thạch
authorlink: http://runikitkat.com
authortwitter: runivn
authorgithub: RuniVN
authorbio: Unknown
authorimage: chao.png

---

Messenger bots của facebook ra cũng khá lâu rồi. Đã có nhiều người sử dụng cho page facebook của mình. Bài này của mình sẽ hướng dẫn các bạn viết 1 con bot tự động trả lời theo pattern có sẵn bằng Go - cho server và ngrok - để publish localhost ra ngoài.

Kiểu này:
![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/Screen%20Shot%202016-07-08%20at%201.43.47%20PM.png_tigvw7dimg)

Những thứ bạn cần có:

- Một page facebook
- Nhiêu đủ rồi


# Facebook stuffs
Đầu tiên bạn vào https://developers.facebook.com và chọn app của mình.
![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/Screen%20Shot%202016-07-08%20at%201.49.49%20PM.png_bectpu8v2e)

Ở tab bên trái các bạn `Add Product`. Chọn `Webhooks`, và `New Subscription` và chọn `Page` ở dropdown. Sẽ hiện ra cái popup như này:

![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/Screen%20Shot%202016-07-08%20at%201.51.56%20PM.png_4suocqh1zi)

Ở đây mình chỉ chọn subscription field là `messages`.


Để có thể lưu cái subscription này lại, bạn cần một `Callback URL` và một `Verify token`

Callback URL là nơi mà messenger sẽ gửi data khi nhận được message trên page của facebook.
Ở đây mình sẽ sử dụng Go làm server, chạy trên localhost. Sau đó dùng ngrok publish ra một https URL(vì Callback URL facebook chỉ nhận https)

Verify token thì bạn điền token mà mình muốn verify lại 1 lần nữa(sử dụng trong Go server để double check)

Ta da! Để cái popup này lại đấy, chuyển sang viết server.

# Go server
Tạo 1 file `main.go`.

Viết hàm main cho nó, làm nhiệm vụ là serve ở port 8085 một cái webhook.

```
func main() {
	http.HandleFunc("/webhook", webhookHandler)
	http.ListenAndServe(":8085", nil)
}

```
Viết hàm `webhookHandler`

```
func webhookHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		verifyTokenAction(w, r)
	}
	if r.Method == "POST" {
		webhookPostAction(w, r)
	}
}
```

Tại sao lại có 2 hàm GET và POST ở đây? GET sẽ được gọi khi bạn bấm nút `Verify and Save` ở popup phía trên. Còn POST sẽ được gọi khi có ai đó nhắn tin trên facebook page. Với GET thì mình chỉ check xem có gửi đúng `verifyToken` không, và log ra thôi.

```
func verifyTokenAction(w http.ResponseWriter, r *http.Request) {
	if r.URL.Query().Get("hub.verify_token") == verifyToken {
		log.Print("verify token success.")
		fmt.Fprintf(w, r.URL.Query().Get("hub.challenge"))
	} else {
		log.Print("Error: verify token failed.")
		fmt.Fprintf(w, "Error, wrong validation token")
	}
}
```

Quan trọng là xử lý hàm POST:
```
func webhookPostAction(w http.ResponseWriter, r *http.Request) {
	var receivedMessage ReceivedMessage
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Print(err)
	}
	if err = json.Unmarshal(body, &receivedMessage); err != nil {
		log.Print(err)
	}
	messagingEvents := receivedMessage.Entry[0].Messaging
	for _, event := range messagingEvents {
		senderID := event.Sender.ID
		if &event.Message != nil && event.Message.Text != "" {
			message := getReplyMessage(event.Message.Text)
			sendTextMessage(senderID, message)
		}
	}
	fmt.Fprintf(w, "Success")
}
func getReplyMessage(receivedMessage string) string {
	var message string
	receivedMessage = strings.ToUpper(receivedMessage)
	log.Print(" Received message: " + receivedMessage)

    if strings.Contains(receivedMessage, "HELLO") {
		message = "Hi, my name is Annie. Nice to meet you"
	}

	return message
}

func sendTextMessage(senderID string, text string) {
	recipient := new(Recipient)
	recipient.ID = senderID
	sendMessage := new(SendMessage)
	sendMessage.Recipient = *recipient
	sendMessage.Message.Text = text
	sendMessageBody, err := json.Marshal(sendMessage)
	if err != nil {
		log.Print(err)
	}
	req, err := http.NewRequest("POST", FacebookEndPoint, bytes.NewBuffer(sendMessageBody))
	if err != nil {
		log.Print(err)
	}
	fmt.Println("%T", req)
	fmt.Println("%T", err)

	values := url.Values{}
	values.Add("access_token", accessToken)
	req.URL.RawQuery = values.Encode()
	req.Header.Add("Content-Type", "application/json; charset=UTF-8")
	client := &http.Client{Timeout: time.Duration(30 * time.Second)}
	res, err := client.Do(req)
	if err != nil {
		log.Print(err)
	}
	defer res.Body.Close()
	var result map[string]interface{}
	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		log.Print(err)
	}
	if err := json.Unmarshal(body, &result); err != nil {
		log.Print(err)
	}
	log.Print(result)
}
```

Hàm trên có 2 hàm:
- `getReplyMessage`: Ở đây mình chỉ xem thử nếu có chữ hello thì mình sẽ trả về message greeting tương ứng. Các bạn có thể sử dụng các kĩ thuật khác cao cấp hơn.
- `sendTextMessage`: Hàm này sẽ gửi về POST request về facebook endpoint, sau đó facebook sẽ gửi tin nhắn tới người nhận(người vừa mới chat trên page facebook).

Chạy server lên bằng `go run main.go`. Ta được một server đang chạy ở port 8085

# Ngrok

Các bạn tải ngrok về ở đây https://ngrok.com/

Chạy ngrok:
```
ngrok http 8085
```
Sẽ được như này:

![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/Screen%20Shot%202016-07-08%20at%202.39.47%20PM.png_95j7zf1bgb)

`localhost:8085` đã được ngrok chuyển thành `https` và publish ra bên ngoài.


# Config

Mọi thứ gần như đã xong. Các bạn chỉ cần paste callback URL đã được forward bởi ngrok vào popup của facebook lúc nãy, điền verify token là xong rồi.


![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/Screen%20Shot%202016-07-08%20at%202.43.19%20PM.png_oe8usmiac8)

Như vậy là các bạn có thể pm facebook page chat thử và chờ response.

# Kết
Trên này là một sample đơn giản. Facebook messenger bots có rất nhiều tiềm năng trong lĩnh vực bán hàng hay trả lời tự động. Các bạn nào chưa nghịch thì có thể nghịch thử.



