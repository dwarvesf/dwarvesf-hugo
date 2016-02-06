---

title: Docker với Microcontainers
draft: false
description: "Containers are awesome. Microcontainers are awesome."
date: "2016-02-04T12:00:25+07:00"
categories: docker, go

coverimage: 2016-02-04-tiny-container.png

excerpt: "Các docker image như node, go, ... với nhiều tool được cài đặt sẵn bên trong dẫn đến dung lượng quá lớn và có vẻ như không cần thiết cho việc deploy project của chúng ta."

authorname: Iv Kean
authorlink: https://www.facebook.com/ivkeanle
authorgithub: ivkean
authorbio: Scouting Unit
authorimage: cotton.png

---

- Khi sử dụng docker, bạn sẽ nhanh chóng nhận ra image dùng để chạy project chiếm 1 dung lượng không nhỏ. Một image ubuntu đơn thuần cũng đã sử dụng gần 200mb nhưng bạn lại không sử dụng hết các tool có sẵn của nó. Các image khác như node, go, ... cũng đa phần chạy trên nền ubuntu, debian và chỉ cài đặt thêm môi trường để bạn dễ dàng deploy hơn nhưng việc download 1 image mới trở nên tốn thời gian vì dung lượng quá lớn và có vẻ như không cần thiết. 

- Chính vì thế, tôi đã tìm ra được 1 image mà trong đó không có gì cả, theo đúng nghĩa đen là không có gì cả :D, trừ 1 số metadata được thêm vào bởi Docker.

```
docker pull scratch
```

- Vì vậy, có thể nói, đây là Docker image có dung lượng nhỏ nhất.

## Chúng ta sẽ tìm hiểu cách deploy 1 app web với image này ngay bây giờ :D

- Tôi sẽ demo với beego web.

- Tôi không thể compile app go trong image empty này vì nó không có Go complier. Và vì đang sử dụng Mac nên tôi không thể compile 1 Linux binary. (Thực tế là chúng ta hoàn toàn có thể cross-compile nhưng tôi sẽ không đề cập ở bài viết này. Bạn có thể tham khảo tại <a target="_blank" href="https://golang.org/doc/install/source#environment">đây</a>).

- Vì thế tôi cần tạo 1 môi trường để compile và docker build source Go:

```
docker run --rm -it -v "$GOPATH":/go  -e "GOPATH=/go"  -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):$(which docker) golang bash
```

- Với lệnh ở trên, `--rm` sẽ xóa container sau khi exit, `-v "$GOPATH":/go` share directory GOPATH của máy với container, `-e "GOPATH=/go"`, `-v /var/run/docker.sock:/var/run/docker.sock` dùng để chạy đc docker bên trong container (docker trong docker :D), `-v $(which docker):$(which docker)` dùng để share command docker, golang là image môi trường để build Go binary và build image, bash để bắt đầu Bash session.

- Lúc này, vì đã vào bên trong container nên tôi cd đến project `/go/src/git.dwarvesf.com/ivkean/web`.

- Tạo 1 Dockerfile với nội dung như sau:

```
# scratch
FROM scratch

WORKDIR /web

# copy binary into image
COPY web web

# copy other necessary files
COPY conf conf
COPY static static
COPY views views

EXPOSE 8080

ENTRYPOINT ["/web/web"]
```

- Build source bằng lệnh: `go build`

- Và link library bằng: `CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o web .`

- Build với docker: `docker build -t beego-web .`

{{% img src="/images/2016-02-04-tiny-container-docker-build.png" class="third right" %}}

- Image vừa tạo chỉ chiếm dung lượng 17.5MB :D

{{% img src="/images/2016-02-04-tiny-container-run-docker-images.png" class="third right" %}}

- Khi đó, máy bạn đã có 1 image là beego-web, việc còn lại là:

```
docker run -d -p 8080:8080 beego-web
```

{{% img src="/images/2016-02-04-tiny-container-run-bee-web.png" class="third right" %}}

- Chúc các bạn thành công.

