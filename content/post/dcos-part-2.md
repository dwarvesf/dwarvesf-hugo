---

title: DC/OS series [Part 2] - Deploy simple applications
draft: false
date: "2017-05-05T14:10:20+07:00"
categories: dcos, devops

<!--coverimage: https://dcos.io/assets/images/social-img.png-->

excerpt: "Install DC/OS CLI and Deploy simple applications"

authorname: Iv Kean
authorlink: https://www.facebook.com/ivkeanle
authorgithub: ivkean
authorbio: Scouting Unit
authorimage: cotton.png

---

There are so many interesting things in DC/OS GUI  (`Dashboard` with useful metrics/status from all nodes, `Services` tab help us to know which application/service is runnning on which node, its status, etc.).

In this article, we will try to deploy applications to DC/OS and run it.

# Universe packages
The Universe tab shows all of the available DC/OS services from package repositories. You can install packages from the DC/OS Universe with a single click. The packages can be installed with defaults or customized directly in the web interface.

<img src="https://dcos.io/docs/1.9/img/ui-dashboard-universe.gif" class="w-100" />

# DC/OS CLI
You also can use the DC/OS command-line interface (CLI) to manage your cluster nodes, install DC/OS packages, inspect the cluster state, and administer the DC/OS service subcommands, deploy application, etc.

## Installing
You can quickly install the CLI from the DC/OS web interface.

1. Click Install CLI from the top-left corner of the DC/OS web interface.
<img src="https://dcos.io/docs/1.9/img/install-cli.png" class="w-100" />

2. Copy and paste the code snippets into your terminal.
<img src="https://dcos.io/docs/1.9/img/install-cli-terminal.png" class="w-100" />

## Usaging

To list available commands, either run dcos with no parameters or run dcos help:

```
Command line utility for the Mesosphere Datacenter Operating
System (DC/OS). The Mesosphere DC/OS is a distributed operating
system built around Apache Mesos. This utility provides tools
for easy management of a DC/OS installation.

Available DC/OS commands:

    auth               Authenticate to DC/OS cluster
    config             Manage the DC/OS configuration file
    experimental       Experimental commands. These commands are under development and are subject to change
    help               Display help information about DC/OS
    job                Deploy and manage jobs in DC/OS
    marathon           Deploy and manage applications to DC/OS
    node               Administer and manage DC/OS cluster nodes
    package            Install and manage DC/OS software packages
    service            Manage DC/OS services
    task               Manage DC/OS tasks

Get detailed command description with 'dcos <command> --help'.
```

OK. We will focus on command `dcos marathon app add <app-resource>` which help us deploy application to DC/OS

| Name           | Description |
|----------------|------|
|`<app-resource>`| Path to a file or HTTP(S) URL that contains the app’s JSON definition. If omitted, the definition is read from stdin. For a detailed description, see the documentation.|

## Deploy a simple app

1. Create an app definition file named my-app.json with these contents

    ```
    {
        "id": "/nginx",
        "instances": 1,
        "cpus": 0.1,
        "mem": 64,
        "container": {
        "type": "DOCKER",
        "docker": {
              "image": "nginx",
              "network": "BRIDGE",
              "portMappings": [
                {"containerPort": 80}
              ]
            }
        }
    }
    ```

    #### Note

    By default, applications will be deployed to `private node`, so if you want to deploy to `public node`, you can add `"acceptedResourceRoles": ["slave_public"]` to `my-app.json`
2. Add your app to Marathon:

    ```
    $ dcos marathon app add <my-app.json>
    ```

    If this is added successfully, output will be something like this:
    ```
    Created deployment d562b50a-17b0-44ce-b7d2-02a0c3cc799e
    ```

3. Verify that the app is added with this command:

    ```
    $ dcos marathon app list
    ```

    The output can be look like this:
    ```
    ID      MEM  CPUS  TASKS  HEALTH  DEPLOYMENT  CONTAINER  CMD
    /nginx   64  0.1    0/1    ---      scale       DOCKER   None
    ```

4. Check application on DC/OS GUI

    Click on `Services` tab, you will see list of applications that you are running. To check application's information, just click on service and choose service ID that you want to see

    {{% img src="/images/20170505-dcos-part-2-list-services.png" class="third right" %}}

    As the picture above, you can check your application directly via `Endpoint`

    {{% img src="/images/20170505-dcos-part-2-app-run.png" class="third right" %}}




