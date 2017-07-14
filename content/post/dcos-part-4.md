---

title: DC/OS series [Part 4] - Deploy simple application with backend & database
draft: false
date: "2017-06-10T14:01:25+07:00"
categories: dcos, devops, application, database

<!--coverimage: https://dcos.io/assets/images/social-img.png-->

excerpt: "With this article, we will know how to connect our application to database (such postgres, mysql, etc.) in DC/OS."

authorname: Iv Kean
authorlink: https://www.facebook.com/ivkeanle
authorgithub: ivkean
authorbio: Scouting Unit
authorimage: cotton.png

---

## Create an application with Golang

First of all, we will go with `Golang` because `Go` is easy to implement backend server and deploy in 1 min. So we will have a few code to initialize `todolist` application that prodive `GET` tasks.

```
func main() {
	// connect DB
	db, err := gorm.Open("postgres",
		fmt.Sprintf("user=%v password=%v host=%v dbname=%v sslmode=disable",
			os.Getenv("DB_USER"), os.Getenv("DB_PASSWORD"), os.Getenv("DB_HOST"), os.Getenv("DB_NAME")))
	if err != nil {
		panic(fmt.Sprintf("Failed to open sql connection: %v", err.Error()))
	}
	db.LogMode(true)
	db.AutoMigrate(models.Task{})

	// we will seed some data
	tasks := []string{"get a coffee cup", "write blog"}
	for _, v := range tasks {
		db.Create(&models.Task{Name: v})
	}

	// init API server
	r := gin.Default()
	r.GET("/tasks", func(c *gin.Context) {
		var data []models.Task
		err := db.Offset(0).Limit(10).Find(&data).Error
		if err != nil {
			c.JSON(http.StatusInternalServerError, err.Error())
		}
		c.JSON(200, gin.H{
			"data": data,
		})
	})
	r.Run()
}
```

Above code allow us easy to customize configuration of database connection. When we deploy application, we just need to change these settings below which are environment variables:

 - DB_USER
 - DB_PASSWORD
 - DB_HOST
 - DB_NAME

After that, We need to do some stuffs to dockerize application and push it to docker hub or private docker registry. To do that, let's create a Dockerfile first:

```
FROM alpine:3.4

RUN apk add --no-cache ca-certificates

ENV GOPATH /go
ENV DB_USER=postgres
ENV DB_PASSWORD=postgres
ENV DB_HOST=localhost
ENV DB_NAME=todolist

WORKDIR /go/src/todolist/backend
ADD main /go/src/todolist/backend

CMD ["/go/src/todolist/backend/main"]
```

Following to these steps, you will be able to build and push your image to docker hub:

```
// this will help us to run app in image alpine
$ CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

// build image and push it to docker hub
$ docker build -t <namespace>/todolist .
$ docker push <namespace>/todolist
```

## Setting up database on DC/OS

Let's go to our DC/OS and create a `postgres` service

Go to DC/OS and choose package tab, then find `postgres`:
<img src="/images/20171006-dcos-part-4-postgres-1.png" class="w-100" />

Customize your configuration after click `Advance setting` from pop-up page:
<img src="/images/20171006-dcos-part-4-postgres-2.png" class="w-100" />
<img src="/images/20171006-dcos-part-4-postgres-3.png" class="w-100" />

Finally, you need to wait a few minutes and get the result like this:
<img src="/images/20171006-dcos-part-4-postgres-4.png" class="w-100" />

You also need to config more a little bit to be able to backup data:
<img src="/images/20171006-dcos-part-4-postgres-5.png" class="w-100" />

A very important thing is sharing volumes. You will need to set a specific node with public IP to make sure if service restart, it will only be deployed to a node that you have specified before. There are 2 things need to be config:

 1. Set a specific node in `Service` tab:
 <img src="/images/20171006-dcos-part-4-postgres-6.png" class="w-100" />

 2. Share volumes:
 <img src="/images/20171006-dcos-part-4-postgres-7.png" class="w-100" />

 For me, I usually share volumes inside container to `/srv` in node: `/srv/todolist/postgresql`:`/var/lib/postgresql/data`

Then, you also need to enable `LOAD BALANCED SERVICE ADDRESS`, it will allow your application connect to `postgres`
 <img src="/images/20171006-dcos-part-4-postgres-8.png" class="w-100" />

After all, click `REVIEW & RUN` to change setting

## Deploy application

As usual, we will need file `marathon.json` to define app and deploy:

You also need to replace your configuration `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`

```
{
  "id": "/todolist/backend",
  "cpus": 0.5,
  "mem": 512,
  "instances": 1,
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "<namespace>/todolist",
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 8080
        }
      ],
      "forcePullImage": true
    }
  },
  "env": {
    "PORT": "8080",
    "DB_HOST": "todolistpostgresql.marathon.l4lb.thisdcos.directory",
    "DB_USER": "postgres",
    "DB_PASSWORD": "password!",
    "DB_NAME": "todolist",
    "BUILD_ID": "123"
  },
  "healthChecks": [
    {
      "portIndex": 0,
      "protocol": "TCP",
      "gracePeriodSeconds": 300,
      "intervalSeconds": 60,
      "timeoutSeconds": 20,
      "maxConsecutiveFailures": 0
    }
  ],
  "labels": {
    "HAPROXY_GROUP": "external",
    "HAPROXY_0_VHOST": "todolist.yourdomain.com"
  }
}
```

OK, we can deploy now !

```
$ dcos marathon app add marathon.json
```

As my expectation, it will be like this :D :
 <img src="/images/20171006-dcos-part-4-postgres-9.png" class="w-100" />

Everything is available now. Let's check it:
 <img src="/images/20171006-dcos-part-4-postgres-10.png" class="w-100" />

That's all. Thanks for reading :)







