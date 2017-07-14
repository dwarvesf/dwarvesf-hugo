---

title: DC/OS series [Part 1] - Quick look & Installation
draft: false
date: "2017-05-04T19:04:30+07:00"
categories: dcos, devops

<!--coverimage: https://dcos.io/assets/images/social-img.png-->

excerpt: "DC/OS - Data center OS is based on the production proven Apache Mesos distributed systems kernel"

authorname: Iv Kean
authorlink: https://www.facebook.com/ivkeanle
authorgithub: ivkean
authorbio: Scouting Unit
authorimage: cotton.png

---

# What is DC/OS ?
DC/OS - Data center OS is based on the production proven Apache Mesos distributed systems kernel, combining years of real-life experience with best practices for building and running modern applications in production.

A DC/OS cluster is composed of three types of nodes: masters, private agents, and public agents.

There are some nodes that we will talk about:

- Bootstrap: we use this node to setup some configurations, to initialize a file which is called `dcos_generate_config.sh`, we will use this file to install DCOS into other nodes.

- Master: This node monitors all metrics from all other child nodes (public agent, private agent)

- Public agent: A public agent node is an agent node that is on a network that allows ingress from outside of the cluster via the cluster’s infrastructure networking.

- Private agent: A private agent node is an agent node that is on a network that does not have ingress access from outside of the cluster via the cluster’s infrastructure networking.

# Why DC/OS ?
Build modern apps using state of the art technologies such as containers and big data services, and confidently move from development to production.

# How can we install it ?

## System requirement -> [Here](https://dcos.io/docs/1.9/installing/custom/system-requirements/)

## Installing
OK. Let's go to the most excited section - Installing DC/OS!

Currenly, DC/OS supported to run with specific installation guideline for each Provider:

- [Amazon Web Service (AWS)](https://dcos.io/docs/1.9/installing/cloud/aws/)
- [Azure](https://dcos.io/docs/1.9/installing/cloud/azure/)
- [Digital Ocean](https://dcos.io/docs/1.9/installing/cloud/digitalocean/)
- [GCE](https://dcos.io/docs/1.9/installing/cloud/gce/)
- [Packet](https://dcos.io/docs/1.9/installing/cloud/packet/)

In this article, I will show you the way to install DC/OS generally. So that you can apply it for every clouds that you're using.

## Step 1 - Prepare on bootstrap node

- Create a directory named `genconf`

```
mkdir -p genconf
```

- Create a configuration file and save as `genconf/config.yaml`

```
---
bootstrap_url: http://<bootstrap_ip>:<your_port>
cluster_name: '<cluster-name>'
exhibitor_storage_backend: static
ip_detect_filename: /genconf/ip-detect
master_discovery: static
master_list:
- <master-private-ip-1>
- <master-private-ip-2>
- <master-private-ip-3>
resolvers:
- 8.8.4.4
- 8.8.8.8
cluster_docker_credentials:
 auths:
  'https://hub.registry1.com':
   auth: ZHdhpLtMG7wi7DsydLkd2FVz
   email: quang@dwarvesf.com
  'https://index.docker.io/v1/':
   auth: HdhpLtMG7wi7DsydLkd2FVzZHdhpLtMG7wi7DsydFVz==
   email: hi@dwarvesf.com
cluster_docker_credentials_dcos_owned: true
cluster_docker_credentials_enabled: 'true'
enable_docker_gc: 'true'
```

- Create a `ip-detect` script

```
#!/usr/bin/env bash
set -o nounset -o errexit
export PATH=/usr/sbin:/usr/bin:$PATH
echo $(ip addr show eth0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
```

- Download the DC/OS installer

```
curl -O https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh
```

- From the bootstrap node, run the DC/OS installer shell script to generate a customized DC/OS build file. The setup script extracts a Docker container that uses the generic DC/OS install files to create customized DC/OS build files for your cluster. The build files are output to ./genconf/serve/.

```
sudo bash dcos_generate_config.sh
```

- From your home directory, run this command to host the DC/OS install package through an NGINX Docker container. For `<your-port>`, specify the port value that is used in the `bootstrap_url`.

```
sudo docker run -d -p <your-port>:80 -v $PWD/genconf/serve:/usr/share/nginx/html:ro nginx
```

## Step 2 - Install DC/OS to master nodes

- SSH to your master nodes:

```
ssh <master-ip>
```

- Make a new directory and navigate to it:

```
mkdir /tmp/dcos && cd /tmp/dcos
```

- Download the DC/OS installer from the NGINX Docker container, where `<bootstrap-ip>` and `<your_port>` are specified in bootstrap_url:

```
curl -O http://<bootstrap-ip>:<your_port>/dcos_install.sh
```

- Run this command to install DC/OS on your master nodes:

```
sudo bash dcos_install.sh master
```

## Step 3 - Install DC/OS to master nodes

- SSH to your nodes:

```
ssh <node-ip>
```

- Make a new directory and navigate to it:

```
mkdir /tmp/dcos && cd /tmp/dcos
```

- Download the DC/OS installer from the NGINX Docker container, where `<bootstrap-ip>` and `<your_port>` are specified in bootstrap_url:

```
curl -O http://<bootstrap-ip>:<your_port>/dcos_install.sh
```

- Run this command to install DC/OS on your agent nodes. You must designate your agent nodes as public or private.

  - Private agent nodes: ```sudo bash dcos_install.sh slave```

  - Public agent nodes: ```sudo bash dcos_install.sh public```

## Step 4 - Launch the DC/OS

You can access to web interface at `http://<master-node-public-ip>/` and bingo !

<img src="https://dcos.io/docs/1.9/img/dcos-gui.png" class="w-100" />

We're done.

If this doesn’t work, take a look at the [troubleshooting docs](https://dcos.io/docs/1.9/installing/troubleshooting/)

