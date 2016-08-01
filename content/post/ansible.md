---

title: Continuous Delivery với Ansible
draft: false
date: "2016-04-22T10:45:19+07:00"
categories: intro, ansible

coverimage: 2016-04-22-ansible-cover.png

excerpt: "Ansible là một tool đơn giản để hỗ trợ việc deploy của bạn trở nên nhanh chóng và dễ dàng hơn."

authorname: Iv Kean
authorlink: https://www.facebook.com/ivkeanle
authorgithub: ivkean
authorbio: Scouting Unit
authorimage: cotton.png

---

## Ansible

Trước khi Ansible ra đời, có lẽ chúng ta thường deploy bằng Ftp Zilla hoặc xịn hơn nữa có thể là ssh lên host và sử dụng git để update source code mới về. Các công việc này hoàn toàn bằng thủ công và trải qua nhiều giai đoạn khiến chúng ta mất rất nhiều thời gian (nào là git commit, push, ssh lên server để git pull, blah blah, ...). Cứ mỗi lần update code mới và chúng ta lại thực hiện n công việc này một lần nữa. Điều này thật khủng khiếp !!!

Và thế là Ansible đã xuất hiện, công việc của chúng ta chỉ còn là viết 1 script file .yml và chạy script, thế là mọi thứ trở nên tự động, tự động build, ssh lên server và update code. Việc của chúng ta bây giờ là uống 1 tách cafe và chờ đợi thôi :D. 

Trước khi đến script cơ bản để mô phỏng quá trình deploy, chúng ta hãy xem qua cách cài đặt.

## Cài đặt Ansible

### Với Ubuntu

```
$ sudo apt-get install software-properties-common
$ sudo apt-add-repository ppa:ansible/ansible
$ sudo apt-get update
$ sudo apt-get install ansible
```

### Với Mac

```
$ sudo easy_install pip
$ sudo pip install ansible
$ pip install git+git://github.com/ansible/ansible.git@devel
```

Với OS X Mavericks, có thể bạn sẽ gặp một số phiền phức từ compiler, hãy thử với lệnh này:
```
$ sudo CFLAGS=-Qunused-arguments CPPFLAGS=-Qunused-arguments pip install ansible
```

Chi tiết ở: http://docs.ansible.com/ansible/intro_installation.html

## Một số lệnh cơ bản của Ansible

Chúng ta hãy xem qua 1 script đơn giản dưới đây, script sẽ build app thành file binary sau đó build 1 docker image và push lên docker hub, tiếp theo ansible sẽ ssh lên host để pull image và run với image mới.

Giả sử ta có 1 file main.go như sau:
```
package main

import "github.com/gin-gonic/gin"

func main() {
  r := gin.Default()

  r.GET("/", func(c *gin.Context) {
    c.JSON(200, gin.H{
      "message": "Hello",
    })
  })

  r.Run()
}
```

Tạo 1 Dockerfile:
```
FROM iron/go

WORKDIR /app

COPY hello /app/

ENTRYPOINT ["/app/hello"]
```

Chúng ta tạo 1 file deploy.yml và paste dòng script dưới đây vào:
```
- name: Rebuild and Push image domain.com/hello
  hosts: dockerhost
  tasks:
  - name: Build app
    command: gox -osarch="linux/amd64" -output="hello"
  - name: Build image
    command: docker build -t domain.com/hello .
  - name: Login docker hub
    docker_login:
      registry: domain.com
      username: user
      password: password
      email: hi@dwarvesf.com
  - name: Push image
    command: docker push domain.com/hello

- name: Pull and Run image
  hosts: staging
  tasks:
  - name: install apt packages
    apt: "name='{{ item }}' state=present"
    sudo: yes
    with_items:
      - python-pip
  - name: install docker-py
    sudo: yes
    pip: name=docker-py version=1.4.0
  - name: Login docker hub
    docker_login:
      registry: domain.com
      username: user
      password: password
      email: hi@dwarvesf.com
  - name: Pull image
    command: docker pull domain.com/hello
  - name: Run container
    command: docker run -d -p 8080:8080 --name hello-container domain.com/hello
```

Sau đó chúng ta tạo 1 file host, để định nghĩa cho dockerhost và staging:
```
xxx.xxx.xxx.xxx ansible_connection=ssh ansible_ssh_user=root
dockerhost ansible_connection=local

[staging]
xxx.xxx.xxx.xxx
```
 
- Giải thích:
  - `name` là tên của task đang chạy.
  - `hosts` là những host sẽ được chạy đoạn script.
  - Sau `hosts` sẽ là `tasks`, `tasks` là 1 chuỗi các lệnh mà ansible sẽ chạy.
  - Chuỗi các lệnh thực hiện bằng các module khác nhau (docker, command, shell, git, ..).

Giờ thì chúng ta chạy lệnh:

```
$ ansible-playbook -i host deploy.yml
```

- option `-i` để chạy file host khai báo các host mà file `deploy.yml` sử dụng ở `hosts`

Ta được kết quả sau:
{{% img src="/images/2016-04-22-ansible-pic1.png" class="third right" %}}

Giờ ta thử ssh vào host và kiểm tra:
{{% img src="/images/2016-04-22-ansible-pic2.png" class="third right" %}}

Thế là xong.
