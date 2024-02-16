# Docker

## Notes about this article

All the information provided here is from following books: [**Docker Deep Dive by Nigel Poulton**](https://vk.com/doc281151819_663610256?hash=IkgbhjPqBezQ9si246ccWxj0Iv0ogZTLBuEk8ekWdOk), [**Docker: Up & Running: Shipping Reliable Containers in Production by Sean P. Kane, Karl Matthias**](https://dl.ebooksworld.ir/motoman/Docker.Up.and.Running.Shipping.Reliable.Containers.in.Production.2nd.Edition.www.EBooksWorld.ir.pdf), [**The Docker Book by James Turnbull**](https://github.com/sudhabharadwajm/the-best-docker-books/blob/master/books/The%20Docker%20Book%20-%20James%20Turnbull%20-%20v17.03.0.pdf) and [**Docker in Action, Second Edition by Jeffrey Nickoloff and Stephen Kuenzli**](https://alek772.github.io/Books/Docker%20in%20Action%20Second%20Edition.pdf).

I'll split this artice into two parts:
  1. [Theory](#Theory)
  2. [Hands-On](#Hands\-On)

So if you're only interesting in practicing with Docker, you can go to the [Hands-On](#Hands\-On) part. And if you want to understand Docker concepts a little deeper you should read the [Theory](#Theory) part.

## Table of Contents
1. [Theory](#Theory)
   * [Intoduction](#Introduction)
   * [The Docker Engine](#The-Docker-Engine)
   * [Images](#Images)
   * [Containers](#Containers)
   * [Networking](#Networking)

2. [Hands-On](#Hands\-On)

# Theory

## Introduction

### History

Applications are at the heart of businesses. If applications break, businesses break. Sometimes they even go bust. These statements get truer every day.

Most applications run on servers. In the past we could only run one application per server. The open-systems world of Windows and Linux just didn’t have the technologies to safely and securely run multiple applications on the same server.

As a result, the story went something like this… Every time the business needed a new application, the IT department would buy a new server. Most of the time nobody knew the performance requirements of the new application, forcing the IT department to make guesses when choosing the model and size of the server to buy. As a result, IT did the only thing it could do - it bought big fast servers that cost a lot of money.

Amid all of this, VMware, Inc. gave the world a gift - the virtual machine (VM). And almost overnight, the world changed into a much better place. We finally had a technology that allowed us to run multiple business applications safely on a single server.

This was a game changer. IT departments no longer needed to procure a brand-new oversized server every time the business needed a new application. More often than not, they could run new apps on existing servers that were sitting around with spare capacity.

But as great as VMs are, they’re far from perfect. The fact that every VM requires its own dedicated operating system (OS) is a major flaw. Every OS consumes CPU, RAM and other resources that could otherwise be used to power more applications. Every OS needs patching and monitoring. All of this results in wasted time and resources.

The VM model has other challenges too. VMs are slow to boot, and portability isn’t great - migrating and moving VM workloads between hypervisors and cloud platforms is harder than it needs to be.

### Hello Containers!

In the container model, the container is roughly analogous to the VM. A major difference is that containers do not require their own full-blown OS. In fact, all containers on a single host share the host’s OS. This frees up huge amounts of system resources such as CPU, RAM, and storage. It also reduces potential licensing costs and reduces the overhead of OS patching and other maintenance.

Containers are also fast to start and ultra-portable. Moving container workloads from your laptop, to the cloud, and then to VMs or bare metal in your data center is a breeze.

Modern containers started in the Linux world and are the product of an immense amount of work from a wide variety of people over a long period of time.

Some of the major technologies that enabled the massive growth of containers in recent years include, **kernel namespaces**, **control groups** (or **cgroups**), **capabilities**, and of course **Docker**. To re-emphasize what was said earlier - the modern container ecosystem is deeply indebted to the many individuals and organizations that laid the strong foundations that we currently build on.

Despite all of this, containers remained complex and outside of the reach of most organizations. It wasn’t until Docker came along that containers were effectively democratized and accessible to the masses. Docker was the magic that made containers simple!

### Introducing Docker

Docker is an open-source engine that automates the deployement of applications into containers. It is so powerful technology, and that often means something that comes with a high level of complexity. And, under the hood, Docker is fairly complex, however, its fundamental user-facing structure is indeed a simple client/server model. There are several pieces sitting behind the Docker API, including *containerd* and *runc* (more about these components is explained later), these are responsible for starting and stopping containers (including building all of the OS constructs such as namespaces and cgroups), but the basic system interaction is a client talking over an API to a server. Underneath this simple exterior, Docker heavily interacts with the kernel.

### Docker and Windows

Microsoft has worked extremely hard to bring Docker and container technologies to the Windows platform.

Windows desktop and server platforms support both of the following:

- Windows containers
- Linux containers

*Windows containers* run Windows apps that require a host system with a Windows kernel.

Any Windows host running the WSL 2 ( Windows Subsystem for Linux) can also run Linux containers.

### Windows containers vs Linux containers

It’s vital to understand that a container shares the kernel of the host it’s running on. This means containerized Windows apps need a host with a Windows kernel, whereas containerized Linux apps need a host with a Linux kernel.

As previously mentioned, it’s possible to run Linux containers on Windows machines with the WSL 2 backend installed.

### Mac containers

There is currently no such thing as Mac containers. However, you can run Linux containers on your Mac using *Docker Desktop*. This works by seamlessly running your containers inside of a lightweight Linux VM on your Mac.

### Container Networking

> [!NOTE]
> Docker networking has some complexitiy, and we'll deep into it in later section.

Even though Docker containers are largely made up of processes running on the host system itself, they usually behave quite differently from other processes at the network layer. Docker initially supported a single networking model, but now supports a robust assortment of configurations that handle most application requirements. Most people run their containers in the default configuration, called *bridge mode*.

To understand bridge mode, it’s easiest to think of each of your Docker containers as behaving like a host on a private network. The Docker server acts as a virtual bridge and the containers are clients behind it. A bridge is just a network device that repeats traffic (transmitting of information) from one side to another. So you can think of it like a mini-virtual network with each container acting like a host attached to that network.

The actual implementation is that each container has its own virtual [Ethernet](https://en.wikipedia.org/wiki/Ethernet) interface connected to the Docker bridge and its own IP address allocated to the virtual interface. Docker lets you bind and expose individual or groups of ports on the host to the container so that the outside world can reach your container on those ports. That traffic passes over a proxy that is also part of the Docker daemon before getting to the container.

Docker detects which network blocks are unused on the host and allocates one of those to the virtual network. That is bridged to the host’s local network through an interface on the server called *docker0*. This means that all of the containers are on a network together and can talk to each other directly. But to get to the host or the outside world, they go over the *docker0* virtual bridge interface.

### Containers are not Virtual Machines

Containers are not virtual machines but they’re very lightweight wrappers around a single Unix process. During actual implementation, that process might spawn others, but on the other hand, one statically compiled binary could be all that’s inside your container. Containers are also ephemeral: they may come and go much more readily than a traditional virtual machine.

Virtual machines are by design a stand-in for real hardware that you might throw in a rack and leave there for a few years. Because a real server is what they’re abstracting, virtual machines are often long-lived in nature. On the other hand, a particular container might exist for months, or it may be created, run a task for a minute, and then be destroyed. All of that is OK, but it’s fundamentally different approach than the one virtual machines are typically used for.

To help drive this differentiation home, if you run Docker on a Mac or Windows system you are leveraging a Linux virtual machine to run *dockerd*, the Docker server. However, on Linux *dockerd* can be run natively and therefore there is no need for a virtual machine to be run anywhere on the system.

![Screenshot from 2024-02-07 17-56-16](https://github.com/isadri/inception/assets/116354167/d614928e-2527-4062-a344-4204865d7b7b)

### Limited Isolation

Containers are isolated from each other, but that isolation is probably more limited than you might expect. While you can put limits on their resources, the default container configuration just has them all sharing CPU and memory on the host system, much as you would expect from colocated Unix processes. This means that unless you constrain them, containers can compete for resources on your production machines.

It’s often the case that many containers share one or more common filesystem layers. That’s one of the more powerful design decisions in Docker, but it also means that if you update a shared [image](#Images), you may want to recreate a number of containers that still use the older one.

Containerized processes are just processes on the Docker server itself. They are running on the same exact instance of the Linux kernel as the host operating system. They even show up in the *ps* output on the Docker server. That is utterly different from a hypervisor, where the depth of process isolation usually includes running an entirely separate instance of the operating system kernel for each virtual machine.

> [!WARNING]
> By default, many containers use UID 0 to launch processes. Because the container is *contained*, this seems safe, but in reality it isn’t. Because everything is running on the same kernel, many types of security vulnerabilities or simple misconfiguration can give the container’s *root* user unauthorized access to the host’s system resources, files, and processes.

### Containers are Lightweight

Creating a new container is much faster than creating a new virtual machine. The new container is so small because it is just a reference to a layered filesystem image and some metadata about the configuration. There is no copy of the data allocated to the container. Containers are just processes on the existing system, so there may not be a need to copy any data for the exclusive use of the container.

The lightness of containers means that you can use them for situations where creating another virtual machine would be too heavyweight or where you need something to be truly ephemeral. You probably wouldn’t, for instance, spin up an entire virtual machine to run a *curl* command to a website from a remote location, but you might spin up a new container for this purpose.

## The Docker Engine

Now let’s talk about the Docker engine. This technical stuff is not needed in order to use Docker, but as **Nigel Poulton** mentions in his book: *to be a real master of anything, you need to understand what’s going on under the hood*. So what’s the Docker engine?

The *Docker engine* (or just *Docker*) is the core software that runs and manages containers. Under the hood, Docker if fairly complex, however, its fundamental user-facing structure is indeed a simple client/server mode.

The major components that make up Docker are the Docker daemon, the build system, *containerd*, *runc*, and various plugins such networking and volumes.Together, these create and run containers.

![Screenshot from 2024-02-08 14-51-29](https://github.com/isadri/inception/assets/116354167/df6af995-5252-4e1e-97d4-4a04cf5bef0e)

### Client/Server Model

Docker is a client/server application. The Docker client talks to the Docker server or daemon, which, in turn, does all the work.

![Screenshot from 2024-02-07 14-53-46](https://github.com/isadri/inception/assets/116354167/984ffa44-eda9-4da9-ad75-bff77b616cfb)

Optionally there is a third component called the registry, which stores Docker images and their metadata (we'll talk about [images](#Images) later). The server does the ongoing work of building, running, and managing your containers, and you use the client to tell the server what to do. The Docker daemon can run on any number of servers in the infrastructure, and a single client can address any number of servers. Clients drive all of the communication, but Docker servers can talk directly to image registries when told to do so by the client. Clients are responsible for telling servers what to do, and servers focus on hosting containerized applications.

Docker is a little different in structure from some other client/server software. It has a *docker* client and a *dockerd* server, but rather than being entirely monolithic, the server then orchestrates a few other components behind the scene on behalf of the client, including *docker-proxy*, *runc* and *containerd*. Docker cleanly hides any complexity behind the simple server API, though, so you can just think of it as a client and server for most purposes. Each Docker host will normally have one Docker server running that can manage a number of containers. You can then use the *docker* command-line tool client to talk to the server, either from the server itself or, if properly secured, from a remote client.

![Screenshot from 2024-02-09 15-48-00](https://github.com/isadri/inception/assets/116354167/fb732bc6-ff4c-495b-aed3-9a0d515f93d7)

> [!NOTE]
> The *docker* command-line tool and *dockerd* daemon talk to each other over network sockets.

### From LXC to libcontainer

In order to create a container, Docker needs to interact with the kernel. In the past, there was a components called **LXC** that provides the daemon an access to the fundamental buildings-blocks of containers that existed in the Linux kernel. Things like *namespaces* and *control groups* (*cgroups*).

![Screenshot from 2024-02-08 15-03-51](https://github.com/isadri/inception/assets/116354167/80ea2722-ee75-4a54-9468-e2eec28e1557)

The problem is that, LXC was Linux-specific, and being reliant on an external tool for something so core to the project was a huge risk. As a result, Docker. Inc. (the company) developed their own tool called *libcontainer* as a replacement for LXC.

### Unix Philosophy

It is important to understand that the docker daemon doesn’t create a container directly, instead, it uses another components to do that. This followed the tried-and-tested Unix philosophy of building small specialized tools that can be pieced together into large tools.

The next figure shows how Docker engine architecture looks like:

![Screenshot from 2024-02-08 15-21-41](https://github.com/isadri/inception/assets/116354167/08f749d6-b673-42a9-81f4-57ea6c0e5367)

let’s explain what is *containerd*, *runc* and *shim*.

### runc

*runc* is a small, lightweight CLI wrapper for libcontainer, and it has a single purpose in life - create containers, and it’s fast.

### containerd

The sole purpose of *containerd* is to manage container lifecycle operations such as *start*, *stop*, *pause*, *rm*…

In the Docker engine stack, *containerd* sits between the daemon and *runc*.

Before we explain what is *shim*, we need to understand the process of creating a new container.

### Starting a New Container

you can enter the following command in the Docker CLI to tell the daemon to start a new container based on the *alpine:latest* image.

```bash
docker container run --name c1 -it alpine:latest sh
```

When you type this command, the Docker client sends it to the Docker daemon. Once the the daemon receives the command to create a new container, it makes a call to *containerd* (because the daemon doesn’t contain any code to create containers).

Despite its name, *containerd* cannot actually create containers. It uses *runc* to do that. *runc* interfaces with the OS kernel to pull together all of the constructs necessary to create a container (namespaces, cgroups etc.). The container process is started as a child process of *runc*, and as soon as it starts, *runc* will exit.

![Screenshot from 2024-02-08 16-00-00](https://github.com/isadri/inception/assets/116354167/0d8fbc88-d7ed-43b1-94ab-dd436da3d11b)

> [!NOTE]
> Having all of the logic and code to start and manage containers removed from the daemon means that the entire container runtime is decoupled from the Docker daemon. Sometimes, this is referred as *daemonless containers* and it makes it possible to perform maintenance and upgrades on the Docker daemon without impacting running containers.

Let’s now talk about *shim*.

### shim

*shim* is integral to the implementation of daemonless containers.

As mentioned before, *containerd* uses *runc* to create new container. In fact, if forks a new instance of *runc* for every container it creates. However, once each container is created, the runc process exits. This means you can run hundreds of containers without having to run hundreds of *runc* instances.

Once a container’s parent process runc process exits, the associated containerd-shim process becomes the container’s parent. Some responsibilities the shim performs as a container’s parent include:

- Keeping any STDIN and STDOUT streams open so that when the daemon is restarted, the container doesn’t terminate due to pipes being closed.
- Returns the container’s exit status back to the daemon.

### What is left to the daemon?

The daemon is capable of pushing and pulling images, implementing the Docker API, authentication, security, etc.

## Images

An image is read-only package that contains everything you need to run an application. It includes application code, application dependencies, a minimal set of OS constructs, and metadata. A single image can be used to start one or more containers.

You can think of images as similar to classes. You can create one or more objects from a class. Same for images, you can create one or more containers from an image.

You get container images by *pulling* them from a *registry*. The most common registry is Docker Hub but others exist. The *pull* operation downloads an image to your local Docker host where Docker can use it to start one or more containers.

Images are made up of multiple *layers* that are stacked on top of each other and represented as a single object, and each identified by a unique hash. Inside of the image is a cut-down operating system (part of the OS) and all of the files and dependencies required to run an application.

### Images and containers

![Screenshot from 2024-02-08 17-53-45](https://github.com/isadri/inception/assets/116354167/f270653e-fec3-43da-b71a-2b7686a4e26a)

You use the `docker run` and `docker service create` commands to start one or more containers from a single image. Once you’ve started a container from an image, the two constructs become dependent on each other, and you cannot delete the image until the last container using it has been stopped and destroyed.

### Images are usually small

The whole purpose of a container is to run a single application or service. This means it only needs the code and dependencies of the app it’s running, it doesn’t need anything else.

Images don’t include a kernel. This is because containers share the kernel of the host they’re running on. It’s normal for the only OS components included in an image to be a few important filesystem components and other basic constructs.

Windows-bases images tend to be a lot bigger than Linux-based images because of the way the Windows OS works.

### Pulling images

A cleanly installed Docker host has no images in its local repository.

The process of getting images onto a Docker host is called *pulling an image*. So, if you want, for example, the latest Debian image on your Docker host, you’d have to *pull* it. To pull a Debian image with the latest version, use the following command:

```bash
docker pull debian:latest
```

Now the image is present in the Docker host’s local repository. You can check that the image is installed by using the following command:

```bash
docker images
```

![Screenshot from 2024-02-10 11-07-02](https://github.com/isadri/inception/assets/116354167/71b46f6d-349c-4d8b-b711-8edf392b860f)

### Image naming

When pulling an image, you have to specify the name of the image you’re pulling. **But how does Docker find an image?**

### Image registries

Images are stored in centralized places called *registries*. The job of a registry is to securely store container images and make them easy to access from different environments.

The most common registry is Docker Hub, but others exist. However, the Docker client defaults to using Docker Hub.

Image registries contain one or more *image repositories*. In turn, image repositories contain one or more images.

![Screenshot from 2024-02-08 18-13-50](https://github.com/isadri/inception/assets/116354167/ca2ba681-cf72-452e-b9d9-8ddbc1c9432f)

### Image naming and tagging

As you saw, to pull a Debian image we used the following command `docker pull debian:latest`. The format for ‘docker pull’ is as follows:

```bash
# docker pull <repository>:<tag>
```

But this format will work only if the image is from an official repository. If you do not specify an image tag after the repository name, Docker will assume you are referring to the image tagged as *latest*, and if the repository doesn’t have an image tagged as *latest* the command will fail.

One thing to note here is that if an image is tagged as *latest*, this doesn’t guarantee that it is the most recent image in the repository. And a single image can have as many tags as you want.

> [!WARNING]
> The *latest* tag is a floating tag, and it is a really bad idea to use it in most production workflows, as your dependencies can get updated out from under you, and it is impossible to roll back to *latest* because the old version is no longer the one tagged *latest*. It is also makes it hard to verify if the same image is running on different servers.

### Images and Layers

A Docker image is a collection of loosely-connected read-only layers where each layer comprises one or more files.

![Screenshot from 2024-02-09 11-39-20](https://github.com/isadri/inception/assets/116354167/b6287c39-9a2c-44a6-ae44-1ebb6ec089d4)

Docker takes care of stacking the layers and representing them as a single unified object.

You can see the layers of an image by using the `docker inspect` command, for example, if we inspect the image that we pulled, an output will be displayed, but we only interested in a field names *RootFS*.

> [!NOTE]
> *rootfs* is a filesystem that Docker layers on top of another filesystem called *boot filesystem* (*bootfs*). *bootfs* is the base filesystem layer inside of an image.

Remember, the output will be different in your Docker host.

```bash
docker inspect debian:latest
```

![Screenshot from 2024-02-09 11-45-46](https://github.com/isadri/inception/assets/116354167/f7902830-bf7f-4486-ba37-dad963e0e1ab)

This trimmed output shows one layer with its hash.

> [!NOTE]
> Pulling images using their names (tags) has a problem, because tags are mutable. This means it’s possible to accidentally tag an image with the wrong tag (name). Sometimes, it’s even possible to tag an image with the same tag as an existing, but different, image. Instead of pulling images using tags, you can pull images using images digests. Every image has a cryptographic *content hash* (called *digest*). It’s impossible to change the contents of the image without creating a new unique digest. To see the digest of an image, use the following command:

```bash
docker images --digests <image>
```

### Multi-Architecture Images:

One question could be on your mind: **How does Docker know that it will install an image on Linux x64, on Windows x64 or on different versions of ARM?** There are two constructs that make this possible:

- **manifest lists**
- **manifests**

The **manifest list** is a list of architectures (CPU architectures) supported by a particular image tag. Each supported architecture then has its own *manifest* that lists the layers used to build it.

For example, the *golang* image may have the following **manifest list** and **manifests**.

![Screenshot from 2024-02-09 12-13-11](https://github.com/isadri/inception/assets/116354167/4539fd18-f951-49e9-9052-37cbb29153a8)

The **manifest list** has entries for each architecture the image supports.

For example, when Docker pulls an image on Linux on ARM,  Docker makes the relevant calls to Docker Hub, and if a **manifest list** exists for the image, it will be parsed to see if an entry exists for Linux on ARM. If it exists, the **manifest** for the Linux ARM image is retrieved. Each layer is then pulled from Docker Hub and assembled on the Docker host.

You can use the `docker manifest inspect <image> | grep ‘architecture\|os` to inspect the manifest list of any image. For example, here’s the manifest list of Debian image on Docker Hub:

![Screenshot from 2024-02-09 14-39-30](https://github.com/isadri/inception/assets/116354167/95ea31a4-3162-43f9-ab27-1de44daa66c6)

## Containers

A container is the runtime instance of an image. In the same way that you can start a virtual machine (VM) from a virtual machine template, you start one or more containers from a single image.

![Screenshot from 2024-02-10 16-31-08](https://github.com/isadri/inception/assets/116354167/9b93cbf6-3266-45fb-90e4-bf2b3c5c0457)

### Containers vs Virtual Machines (VMs)

Containers and VMs both need a host to run on, but the process of starting an application inside a container and a VM is different.
For example, let's assume you want to run an application inside of a VM. First, the hypervisor needs to boot. Once booted, the hypervisor claims all physical resources such as CPU, RAM, storage, and network cards. It then carves these hardware resources into virtual constructs. It then packages them into a VM. We take this VM and install an operating system and application on it. This means that if you want to run 4 application, you'd create 4 VMs and install 4 operating systems.

![Screenshot from 2024-02-10 16-45-08](https://github.com/isadri/inception/assets/116354167/575e6cc5-97a0-471b-a21a-13ab0ca23c9b)

Contrast this with a container where the host's OS claims all hardware resources. Next you install a container engine such as Docker. The container engine then carves-up the OS resources (process tree, filesystem, network stack etc) and packages them into container. Inside of the container you run the application. This means that if you want to run 4 application, you'd create 4 containers in the same OS (the host's OS) and run a single application inside each.

![Screenshot from 2024-02-10 17-26-47](https://github.com/isadri/inception/assets/116354167/55531520-e778-4a0a-9d73-ca1bf58bbc56)

At a high level, hypervisors perform **hardware virtualization** - they carve up physical hardware resources into virtual versions called VMs. On the other hand, containers perform **OS virtualization** - they carve OS resources into virtual versions called containers.

> [!NOTE]
> Containers start a lot faster than VMs because they only have to start the application - the kernel is already up and running on the host. In the VM model, each VM needs to boot a full OS before it can start the app.

Now we know the difference between containers and VMs, let's see how to creating a container?

### Creating containers

To start a container, we use the `docker run` command. `docker run` wraps two separate steps into one. The first thing it does is create a container from the underlying image. You use the `docker create` to do this. The second thing `docker run` does is execute the container, which you can also do separately with the `docker start` command.
For example, lets run a new container from a Debian image.

![Screenshot from 2024-02-10 17-37-31](https://github.com/isadri/inception/assets/116354167/f80e2961-248f-497f-973b-3ea768635ac0)

> [!NOTE]
> Since we didn't specify a tag for the image, Docker will use the *latest* tag, but as you remember, if the image's repository doesn't include the *latest* tag the command will fail.

Let's look at each piece of this command:
  1. First, we told Docker to run a command using `docker run`.
  2. In the `-it` flags, the `-i` flag keeps **STDIN** open from the container, even if we're not attached to it. This persistent standard input is one half of what we need for an interactive shell. The `-t` flag is the other half and tells Docker to assign a pseudo-tty to the container we're about to create. This provides us with an interactive shell in the new container.
  3. Next, we to Docker which image to use to create a container, in this case the **debian** image.
So what was happening in the background here? Firstly, Docker checked locally for the **debian** image. If it can't find the image on our local Docker host, it will reach out to the Docker Hub registry, and look for it there. Once Docker has found the image, it downloaded the image and stored it on the local host.
Docker then used this image to create a new container inside a filesystem. The container has a network, IP address, and a bridge interface to talk to the local host. Finally, we told Docker which command to run in our new container, in this case launching a Bash shell with the `/bin/bash` command.
When the container had been created, Docker ran the `/bin/bash` command inside it, and the container's shell was presented to us.

> [!NOTE]
> When you run this command the first time in your Docker host, Docker will not find the image in your Docker host, and it will grab it from Docker Hub, and then downloaded it. But, if you run the same command again, Docker will find the image in your Docker host, and it will create the container directly, without downloaded the image again. You can see it in action. Run the same command again, and you will notice that the container executed much faster.

### Working with our first container
Now we are inside the container as the *root* user, and it is a fully fledged Debian host, and we can anything we like in it. Let's see the container's hostname.

![Screenshot from 2024-02-10 17-55-49](https://github.com/isadri/inception/assets/116354167/94acb44f-b817-4634-9a05-84a2df57af78)

Run the `docker ps` command in your host's terminal:

![Screenshot from 2024-02-10 17-57-13](https://github.com/isadri/inception/assets/116354167/3791dbf2-6117-461f-a13b-6fc42b299b10)

> [!NOTE]
> The `docker ps` command shows information about a running container, its ID, the image used to create it, the command that is executed inside it, how much time the container is running, the ports exposed in it and the name of the container inside the Docker host.

You will notice that the container's hostname is the same as the container's ID. And if we also have a look at the */etc/hosts* file.

![Screenshot from 2024-02-10 18-01-13](https://github.com/isadri/inception/assets/116354167/5a9d3ac1-2d3c-4604-bd1a-76c3cbc96b7f)

We will see that Docker has added a host entry for our container with its IP address. And we'll use the `hostname -I` command the see the container's IP.

![Screenshot from 2024-02-10 18-04-39](https://github.com/isadri/inception/assets/116354167/363b7b1c-8cf0-4b5e-a307-c0f704a1c6ed)

We see that the container have an IP address of 172.17.0.2, just like any other host. We can also check its running processes.

![Screenshot from 2024-02-10 18-06-15](https://github.com/isadri/inception/assets/116354167/4ea272cf-254d-4898-8236-9e37f8d15b4d)

The `ps` command does not exist in the container, so how do we install it? Well, remember, we are inside a Debian system, so we can just install `ps` command by using the `apt-get` package manager as follows.

```bash
apt-get update && apt-get install procps
```
Now, after we installed the `ps` command, we can use it to see its running processes.

![Screenshot from 2024-02-10 18-13-44](https://github.com/isadri/inception/assets/116354167/5634f2a3-5c9e-4f47-8999-e08f07afe0f4)

You can keep playing with the container for as along as you like. When you're done, type `exit` or *Ctl-D*, and you'll return to the command prompt of your host.
Now the container has stopped running. The container only runs for as long as the command we specified, `/bin/bash`, is running. Once we exited the container, that command ended, and the container was stopped.

> [!NOTE]
> Containers run until the main process exits.

If we use the `docker ps` command, we will not the container that we were in it.

![Screenshot from 2024-02-10 18-19-45](https://github.com/isadri/inception/assets/116354167/6bb0f077-d125-4938-b8c7-a7f3cc283a89)

But the container still exits, it is just stopped. Add the `-a` flag to `docker ps` command to show all containers, no matter if they running or are stopped.

![Screenshot from 2024-02-10 18-22-11](https://github.com/isadri/inception/assets/116354167/f8acb198-610e-492f-863a-9f0819d975e1)

The *STATUS* field says that the container is stopped 2 minutes ago with 0 as the exit status.

> [!NOTE]
> If you want to specify a particular name of a container in place of the automatically name that Docker generate, you can use the `--name` flag like this: `docker run --name container_1 -it debian /bin/bash`.
> Container names are useful to help us identify and build logical connections between containers and applications, as we will see later.
> And remember that the names are unique. You cannot create two containers with the same name, you need to delete the previous container with the same name before you can create a new one.

### Starting a stopped container

Our *container_1* container is stopped, how do we bring it back to life?
To restart our stopped container we can use the `docker start` command with the name of our container or its ID.
```bash
docker start container_1
```
or
```bash
docker start 0af8722f3fea
```

> [!NOTE]
> You can use the container's name or the container's ID in any docker container command.

Now if we run the `docker ps` command again without the `-a` flag, we will see that our container is back to life.

![Screenshot from 2024-02-10 18-37-37](https://github.com/isadri/inception/assets/116354167/6b2a98eb-c620-4621-863f-90d2a7d7ca2b)

Our container is running now, but how can we go inside of it (or more technically, *attach to it*)?

### Attaching to a container

Our container is restarted with the same options we had specified when we launched it with the `docker run` command. So there is an interactive session waiting on our running container. We can reattach to that session using the `docker attack` command.

```bash
docker attach container_1
```
And we will be brought back to our container's Bash prompt.
If we exit this shell, the container will be stopped again.

### Running containers in the background (daemonized containers)

Daemonized containers don't have an interactive session and they are ideal for running applications and services such as nginx.
Let's start a daemonized container.

![Screenshot from 2024-02-10 18-49-29](https://github.com/isadri/inception/assets/116354167/358ecff7-a7af-4d2a-91ad-989b1f269837)

Here, we've used the `docker run` command with the `-d` flag to tell Docker to detach the container to the background (you can use the `--detach` flag for the same effect).
We've also specified a `while` loop as our container command. Our loop will `echo` `hello inception` over and over again until the container is stopped or the process stops.
You'll see that, instead of being attached to a shell like the case in *container_1* container, the `docker run` command has instead returned the container's ID and returned us to our command prompt. This is because we told Docker to run this container as a daemon using the `-d` falg.
Now if we run `docker ps`, we see that the *container_2* is running.

![Screenshot from 2024-02-10 18-55-03](https://github.com/isadri/inception/assets/116354167/3531245d-16bb-4b60-bec0-55bf16d5eeda)

You can use the `docker logs` command to fetche the logs of a container.

![Screenshot from 2024-02-11 18-01-35](https://github.com/isadri/inception/assets/116354167/93654f4b-f2bd-4bd7-bb3f-b928d486a02c)

### Running a process inside a running container

You can run additional processes inside our containers using the `docker exec` command.
There are two types of commands we can run inside a container: background and interactive. Background tasks run inside the container without interaction and interactive tasks remain in the foreground.
For example, to create a file in the background inside the container, use the following command.
```bash
docker exec -d container_2 touch my_file
```
We can also run interactive tasks like opening a shell inside our container_2 container.
```bash
docker exec -it container_2 /bin/bash
```
This command will create a new bash session inside the container.

### Stopping a daemonized container

Now our container_2 container is running, but how to stop it? This is as simple as using the `docker stop` command.
```bash
docker stop container_2
```
or via the container ID
```bash
docker stop c18084c9f8f0
```
Now run the `docker ps -a` command to see that the container is actually stopped.

### Automatic container restarts

What if you want your container to be running even if the container has stopped because of a failure? To do this, you can use the `--restart` flag with the `docker run` command. The `--restart` checks for the container's exit code and makes a decision whether or not to restart it.
```bash
docker run -d --name container_3 --restart=always debian /bin/sh -c "while true: do echo hello inception; sleep 1; done"
```
There is three restart policies you can, and these are:
  * `always`
  * `unless-stopped`
  * `on-failure`

The `always` policy restarts a failed container unless it's been explicitly stopped. For example, we'll start a new interactive container and tell it to run a shell process. We'll then type `exit` to kill the shell. Since the shell is the main process inside of the container (it has PID 1), this will kill the container. However, Docker will automatically restart it because of the `--restart=always` policy.

![Screenshot from 2024-02-11 18-22-00](https://github.com/isadri/inception/assets/116354167/6e10e881-ef5c-47f4-96d7-d20334651206)

> [!NOTE]
> Notice that the container is created 10 seconds ago and is running 4 seconds ago. This because it has been restarted.

> [!NOTE]
> Be aware that Docker has restarted the same container and not created a new one.

> [!WARNING]
> If you start a container with the `--restart=alway` policy and you stop it using `docker stop` and then you restart the Docker daemon, the container will be restarted.
> You can try this, by stopping the container_4 container, and then restart the Docker daemon using `sudo systemctl restart docker`. When you type `docker ps`, you will that the container is automatically restarted.

The main difference between the `always` and `unless-stopped` policies is that containers with the `--restart=unless-stopped` policy will not be restarted when the daemon restarts if they were in the *Stopped (Exited)* state.
The `on-failure` policy will restart a container if it exits with a non-zero exit code. It will also restart containers when the Docker daemon restarts, even ones that were in the stopped state.

### Deleting a container

We've create many containers, and now we're not using any one of them, and they take some memory space. Thus, it's time to delete them.
To delete a container, we use the `docker rm` container along with the name of the container we want to delete or its ID.
```bash
docker rm container_1
```
or
```bash
docker rm d54d3fa008e6
```
Writing the name of each container we want to delete is annoying. For that, we'll use this command to delete all the containers.
```bash
docker rum $(docker ps -aq)
```

> [!WARNING]
> If a container is still running, it will not delete, you need to stop it first, and then delete, or you can use the `-f` flag to force. However, using the `-f` flag will send a **SIGKILL** signal, and the container will not stop gracefull. The `docker stop` command will sends a **SIGTERM** signal and gives the container, and the app it's running, a chance to complete any operations and gracefully exit.

## Networking

Networking is all about communicating between processes that may or may not share the same local resources. To understand Docker networking, we need to understand some basic network abstractions that are commonly used by processes.

### Basics: Protocols, interfaces, and Ports

A *protocol* with respect to communication and networking is a sort of language. Two parties that agree on a protocol can understand what the other is communicating.
A network *interface* has an address and represents a location, and it has an IP address. It's common for computers to have two kinds of *interfaces*: an Ethernet interface and a loopback interface. An *Ethernet interface* is used to connect to other interfaces and processes. A *loopback interface* isn't connected to any other interface.

> [!NOTE]
> Each container has its own private loopback and a separate virtual Ethernet interface.

A network interface is like a mailbox. Messages are delivered to a mailbox for recipients at that address (IP in case of network interface), and messages are taken from a mailbox to be delivered elsewhere.
A *port* is like a recipient or a sender. Ports are just numbers, and each port is associated with a specific process or service.
That's enough for the basics, let's get back to Docker networking.

### Docker Networking

When you install Docker, Docker creates a virtual network, the purpose of this virtual network is to connect all of the running containers to the network that your computer is connected to. This virutal network called a *bridge*.
A bridge is an interface that connects multiple networks so that they can function as a single network. Bridges work by selectively forwarding traffic between the connected networks.

![Screenshot from 2024-02-12 14-59-23](https://github.com/isadri/inception/assets/116354167/57b7d650-47dc-40ef-9e06-cf8150cc44ce)

A container attached to a Docker network will get a unique IP address that is routable from other containers attached to the same Docker network.
You can create and manage Docker networks directly by using the `docker network` subcommands.
For example, to list the default networks that are availble with every Docker intallation, use the `docker network ls` command.

![Screenshot from 2024-02-12 17-44-06](https://github.com/isadri/inception/assets/116354167/8820c940-3d09-4a6b-b04b-a134a63b0d2b)

By default, Docker includes three networks, and each is provided by a different dirver. And these networks are:
* ***bridge***:
  this is the default network and provided by a *bridge* driver. The *bridge* driver provides intercontainer connectivity for all containers running on the same machine. The *bridge* driver uses Linux namepaces, virtual Ethernet devices, and the Linux firewall to build the *bridge* network. The *bridge* network is then local to the machine where Docker is installed and creates routes between participating containers and the wider network where the host is attached.
*  ***host***:
  this network is provided by the *host* driver, which instructs Docker not to create any special networking namespace or resources for attached containers (which is the case for the *bridge* network). Containers on the *host* network interact with the host's network stack like any other uncontained processes.
*  ***none***:
  the *none* network uses the *null* driver. Containers attached to the *none* network will not have any network connectivity outside themselves.

> [!NOTE]
> A driver is just a software that is responsible for the creation and management of all resources on the network.

### Ping a Container From Another Container

Let's create a new container and run it in the background.
```bash
docker run -d --name c1 debian sleep 1d
```
Now, create another interactive container.
```bash
docker run -it --name c2 debian bash
```

> [!WARNING]
> We need the `ping` command to ping the c1 container. To install the `ping` command use the following command
> ```bash
> apt-get update && apt-get install -y iputils-ping
> ```

Now, we need the IP address of the `c1` container in order to ping it. To do that, exit from the `c2` container without stopping it (press Ctrl-P and then Ctrl-Q).
We know that every container created is connected to the *bridge* network by default. If we inspect the *bridge* network, we'll see all the containers that are connected to it, with their names, MAC addresses and IP addresses. Use the `docker inspect bridge` command.

![Screenshot from 2024-02-14 11-48-59](https://github.com/isadri/inception/assets/116354167/79239ef7-34d1-440a-ae83-68733baa6f72)

The output is trimmed because we're only interested in the containers that are connected to the network. We can see that both the `c1` and `c2` containers are attached to the *bridge* network along with their IP addresses. The IP address of the `c1` container is 172.17.0.2.
Now attach to the `c2` container again by using the `docker attach c2` command.
Once we are inside the `c2` container, we can ping the `c1` container.

![Screenshot from 2024-02-14 11-49-49](https://github.com/isadri/inception/assets/116354167/169d3837-b849-458e-ad8b-2666474e3f27)

The command works!

But the problem is that if you want to ping the `c1` container by name (i.e., `ping c1`), the command won't work. This is because the *bridge* network support a Docker feature called *service discovery*.

> [!NOTE]
> *Service discovery* allows all containers and Swarm services to locate each other by name. The only requirement is that they be on the same network.

So, using the *bridge* default network is not recommended. And that's why you need to create your own bridge network.

### Creating a User-Defined Bridge Network

Each container is assigned a unique private IP address that's not directly reachable from the external network. Connections are routed through another Docker network interface called *docker0*. All the containers that are on a network together can talk to each other directly. But to get to the host or the outside world, they go over the *docker0* virtual bridge interface.

![Screenshot from 2024-02-14 13-15-44](https://github.com/isadri/inception/assets/116354167/97bb7a32-02e4-40eb-8ea1-6e51cfed250f)

Build a new container with the following command:
```bash
docker network create --driver bridge --attachable user-network
```
This command creates a new local bridge network named `user-network`. And we specify the driver to be used to create the network as the `bridge` (by default it will be the `bridge`, so you can use the command without the `--driver` flag). Making the new network as `attachable` allows us to attach and detach containers from the network at any time. Check that the network has been created by running the `docker network ls`.

![Screenshot from 2024-02-14 13-22-46](https://github.com/isadri/inception/assets/116354167/0ea39aec-b47a-4e98-8ede-7c604f2b13db)

We'll now create a new container attached to that network.
```bash
docker run -it --network user-network --name network-explorer debian sh
```
List the IP addresses that are available in the container by running:
```bash
ip addr
```

> [!WARNING]
> You need to install the `ip` command by running:
> ```bash
> apt-get update && apt-get install -y iproute2
> ```

![Screenshot from 2024-02-14 13-27-08](https://github.com/isadri/inception/assets/116354167/15330dab-6966-4b00-bf7e-54837ae6575a)

You can see from this list that the container has two network devices: the loopback interface (or localhost) and eth0 (a virtual Ethernet device), which is connected to the bridge network. The IP address of the eth0 (i.e., `172.18.0.2`) is the one that any other container on this bridge network should use to communicate with services you run in this container. The loopback interface can be used only for communication within the same container.
Next, we'll create another bridge network and attach our running `network-explorer` container to both networks. First, detach your terminal from the running container (press Ctrl-P and then Ctrl-Q) and then create the second bridge network
```bash
docker network create --attachable user-network2
```
Again, check that the network has been created by using `docker network ls`.

![Screenshot from 2024-02-14 15-16-45](https://github.com/isadri/inception/assets/116354167/ddd1d655-757e-460b-aaad-a7cc85bd5476)

> [!NOTE]
> Notice that the driver is the `bridge` driver even we didn't specify it with the `--driver` flag.

Once the second network has been created, we can attach the `network-explorer` container to the `user-network2` network by using the following command.
```bash
docker network connect user-network2 network-explorer
```
After the container has been attached to the second network, we'll go back to our `network-explorer` container.
```bash
docker attach network-explorer
```
List again the IP address by using `ip addr` command.

![Screenshot from 2024-02-14 15-20-36](https://github.com/isadri/inception/assets/116354167/fa13604f-a727-4267-8714-8b3227e4d1ef)

We see that a new network interface has been added, and our container is attached to both user-defined bridge networks.
Now, we'll back to our ping example, but instead of running two containers attached to the default bridge network, we'll run them in a user-defined network. Let's create a new container attached to the `user-network` network (you can use `user-network2`).
```bash
docker run -d --network user-network --name user1 debian sleep 1d
```
Now, run the other container
```bash
docker run -it --network user-network --name user2 debian bash
```
and install `ip` command using
```bash
apt-get update && apt-get install -y iputils-ping
```
Now, ping it using `ping user1` command.

![Screenshot from 2024-02-14 15-38-15](https://github.com/isadri/inception/assets/116354167/9d2f6349-90b3-482f-af63-92bdf8469673)

As you can see, we managed to ping the `user1` container by name instead of its IP address.
This is because (and by [docker docs](https://docs.docker.com/network/drivers/bridge/)) containers on the default *bridge* network can only access each other by IP addresses, unless you use the `--link` option. On a user-defined bridge network, containers can resolve each other by name.

### Port Publication

Now that we can connect a container with another, how can we connect it to an external network?
Docker allows us to do that by mapping the host port to the container port at container creationg and cannot be changed later, so traffic hitting the host port will be directed to the container port. The `docker run` and `docker create` commands provide a `-p` or `--publish` list option. The format of the `-p` option is as follows

![Screenshot from 2024-02-13 11-17-21](https://github.com/isadri/inception/assets/116354167/f772ad84-bb7c-4f55-b4b6-c1b4a5faf03f)

This option will forward traffic hitting port 8080 from all host interfaces to port 8080 in the new container. This is the full format, you can use intead `8080:8080` for the same effect. We see this in action in the [Hands-on](#Hands\-On) part.

## Docker Volumes

There are two main categories of data: persistent and non-persistent.
Persistent is the data we need to keep. *Non-persisten* is the data we don't need to keep.
* ***Non-persistent Data:***

  To deal with non-persistent data, Every Docker container gets its own non-persistent storage. When a container is launched from an image, Docker mounts a read-write filesystem on top of any layers of the image that the container was created from. This is where whatever processes we want our container to run will execute.
When Docker first starts a container, the initial read-write layer is empty. As changes occur, they are applied to this layer; for example, if you want to change a file, then that file will be copied from the read-only layer below into the read-write layer. The read-only version of the file will still exist but is now hidden underneath the copy.
This pattern is traditionally called *copy on write*. Each read-only layer is read-only, this image never changes. When a container is created, Docker builds from the stack of images and then adds the read-write layer on top. That layer, combined with the knowledge of the image layers below it and some configuration data, form the container.
As a result, deleting the container will delete the storage and any data on it.
* ***Persistent Data:***

  To deal with persistent data, you need to manage the container filesystem and mount points.

### File Trees and Mount Points

Unlike other operating systems, Linux unifies all storage into a single tree. Storage devices such as disk partitions or USB disk partitions are attached to specific locations in that tree. Those locations are called *mount points*. A mount point defines the location in the tree, the access properties to the data at that point (for example, writability), and the source of the data mounted at that point (for example, a specific hard disk, USB device).

![Screenshot from 2024-02-15 10-29-04](https://github.com/isadri/inception/assets/116354167/e515cc82-72c1-461a-8855-0e98933d673e)

Mount points allow software and users to use the file tree in a Linux environment without knowing exactly how that tree is mapped into specific storage devices.
Every container has something called a *MNT namespace* (I'll explain *namespaces* later) and a unique file tree root. The image that a container is created from is mounted at that container's file tree root, or at the / point, and that every container has a different set of mount points.
Logic follows that if different storage devices can be mounted at various points in a file tree, we can mount nonimage-related storage at other points in a container file tree. That is exactly how containers get access to storage on the host filesystem and share storage between containers.
The three most common types of storage mounted into containers:
  * Bind mounts
  * In-memory storage
  * Docker volumes

All three types of mount points can be created using the `--mount` flag on the `docker run` and `docker create` subcommands.

### Bind Mounts

*Bind mounts* are mount points used to remount parts of a filesystem tree onto other locations. When working with containers, bind mounts attach a user-specified location on the host filesystem to a specific point in a container file tree. Bind mounts are useful when the host provides a file or directory that is needed by a program running in a container, or when that containerized program produces a file or log that is processed by users or programs running outside containers.
The problem with bind mounts is that they tie otherwise portable container descriptions to the filesystem of a specific host. If a container description depends on content at a specific location on the host filesystem, that description isn't protable to host where the content is unavailable or available in some other location.

### In-Memory Storage

Most service software and web applications use private key files, database passwords, API key files, or other sensitive configuration files, and need upload buffering space. In these cases, it is important that you never include those types of files in an image or write them to disk. Instead, you should use in-memory storage. For example, to run a container with in-memory storage as its mount type, you can set the type as follows.
```docker
docker run --mount type=tmpfs,dst=/tmp <image>
```
This command creates an empty `tmpfs` device and attaches it to the new container's file tree at /tmp. Any files created under this file tree will be written to memory instead of disk.

### Docker Volumes

*Docker volumes* are named filesystem trees managed by Docker. All operations on Docker volumes can be accomplished using the `docker volume` subcommand set. Using volumes is a method of decoupling storage from specialized locations on the filesystem that you might specify with bind mounts.
You can create and inspect volumes by using the `docker volume create` and `docker volume inspect` subcommands. By default, Docker creates volumes by using the `local` volume plugin. The default behavior will create a directory to store the contents of a volume somewhere in a part of the host filesystem under control of the Docker engine. For example, the following command create a volume named `location-example`:
```docker
docker volume create --driver local location-example
```
Check that the volume has been created by using the `docker volume ls` command

![Screenshot from 2024-02-16 16-09-51](https://github.com/isadri/inception/assets/116354167/d9e32761-5697-4fbe-b64e-02222bfab5dc)

The following command displays the location of the volume host filesystem tree:
```docker
docker volume inspect --format '{{json .Mountpoint}}' location-example
```
A *volume* is a tool for sharing data that has a scope of life cycle that's independent of a single container.
Images are appropriate for packaging and distributing relatively static files such as programs, volumes hold dynamic data or specializations. This distinction makes images reusable and data simple to share. This is why volumes provide container-independent data management.

# Hands-On
