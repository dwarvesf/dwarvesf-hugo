---

title: Docker registry
draft: false
date: "2016-07-21T22:45:19+07:00"
categories: intro, docker

coverimage: 2016-21-07-private-containers.png

excerpt: "The Docker toolset to pack, ship, store, and deliver content."

authorname: Iv Kean
authorlink: https://www.facebook.com/ivkeanle
authorgithub: ivkean
authorbio: Scouting Unit
authorimage: cotton.png

---

## Summary
The Docker toolset to pack, ship, store, and deliver content.

This repository's main product is the Docker Registry 2.0 implementation for storing and distributing Docker images. It supersedes the docker/docker-registry project with a new API design, focused around security and performance.

## To be simple

### Server

Simply, just run below command:
```
$ docker run -d -p 5000:5000 --restart=always --name registry registry:2
```

### Client

Get any image from the hub and tag it to point to your registry:

```
$ docker pull ubuntu && docker tag ubuntu your-domain:5000/ubuntu

$ docker push your-domain/ubuntu

$ docker pull your-domain:5000/ubuntu
```

## Running a domain registry

While running on `localhost` has its uses, most people want their registry to be more widely available. To do so, the Docker engine requires you to secure it using TLS, which is conceptually very similar to configuring your web server with SSL.

### Server

Lets create a directory to save some items related to.

```
$ mkdir registry && cd registry && mkdir certs && mkdir data && mkdir auth
```

First of all, lets create `htpasswd` file so that client can login to this hub.

```
$ docker run --entrypoint htpasswd registry:2 -Bbn testuser testpassword > auth/htpasswd
```

And now, lets copy or create your own domain.crt and domain.key and save it into certs/

```
$ openssl req \ -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key \ -x509 -days 365 -out certs/domain.crt
```

Then, we need to create docker-compose.yml:

```
registry:
  restart: always
  image: registry:2
  ports:
    - 443:5000
  environment:
    REGISTRY_HTTP_TLS_CERTIFICATE: /certs/domain.crt
    REGISTRY_HTTP_TLS_KEY: /certs/domain.key
    REGISTRY_HTTP_SECRET: someRandomSecret
    REGISTRY_AUTH: htpasswd
    REGISTRY_AUTH_HTPASSWD_PATH: /auth/htpasswd
    REGISTRY_AUTH_HTPASSWD_REALM: Registry Realm
  volumes:
    - ~/docker_registry_tls/data:/var/lib/registry
    - ~/docker_registry_tls/certs:/certs
    - ~/docker_registry_tls/auth:/auth
 ```

And run, `$ docker-compose up -d`

That's all, now you can login to your hub to push, pull

### Client

You need to login

```
$ docker login your-domain/ubuntu
```

#### Issue

You may get some troubles like:

```
FATA[0000] Error response from daemon: v1 ping attempt failed with error:
Get https://myregistrydomain.com:5000/v1/_ping: tls: oversized record received with length 20527.
If this private registry supports only HTTP or HTTPS with an unknown CA certificate,please add
`--insecure-registry myregistrydomain.com:5000` to the daemon's arguments.
In the case of HTTPS, if you have access to the registry's CA certificate, no need for the flag;
simply place the CA certificate at /etc/docker/certs.d/myregistrydomain.com:5000/ca.crt
```

#### Solution

- Linux
```
$ cp certs/domain.crt /usr/local/share/ca-certificates/myregistrydomain.com.crt
update-ca-certificates
```

- RedHat
```
$ cp certs/domain.crt /etc/pki/ca-trust/source/anchors/myregistrydomain.com.crt
update-ca-trust
```

- On some distributions, e.g. Oracle Linux 6, the Shared System Certificates feature needs to be manually enabled:

```
$ update-ca-trust enable
```

or You can open /etc/default/docker and add the following at the end:

```
DOCKER_OPTS="$DOCKER_OPTS --insecure-registry <your-domain>"
```

#### Note: 

If you use `boot2docker` (Mac), you may do some steps below:

```
$ docker-machine ssh <your-machine>
```

```
$ cd /var/lib/boot2docker && sudo vi profile
```

and you need to add `--insecure-registry=<your-domain>` (dont need to include port if your hub server use port 443) inside EXTRA_ARGS like:

```
EXTRA_ARGS='
--label provider=virtualbox
--insecure-registry=<your-domain>
'
```

Exit and `docker-machine restart <your-machine>`.

Now you can login to your hub and pull-push your image.