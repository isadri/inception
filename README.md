# Docker

# Introduction

### History

Applications are at the heart of businesses. If applications break, businesses break. Sometimes they even go bust. These statements get truer every day.

Most applications run on servers. In the past we could only run one application per server. The open-systems world of Windows and Linux just didn’t have the technologies to safely and securely run multiple applications on the same server.

As a result, the story went something like this… Every time the business needed a new application, the IT department would buy a new server. Most of the time nobody knew the performance requirements of the new application, forcing the IT department to make guesses when choosing the model and size of the server to buy.

As a result, IT did the only thing it could do - it bought big fast servers that cost a lot of money. After all, the last thing anyone wanted, including the business, was under-powered servers unable to execute transactions and potentially losing customers and revenue. So, IT bought big. And that results a tragic waste of company capital and environmental resources!

Amid all of this, VMware, Inc. gave the world a gift - the virtual machine (VM). And almost overnight, the world changed into a much better place. We finally had a technology that allowed us to run multiple business applications safely on a single server.

This was a game changer. IT departments no longer needed to procure a brand-new oversized server every time the business needed a new application. More often than not, they could run new apps on existing servers that were sitting around with spare capacity.

But as great as VMs are, they’re far from perfect. The fact that every VM requires its own dedicated operating system (OS) is a major flaw. Every OS consumes CPU, RAM and other resources that could otherwise be used to power more applications. Every OS needs patching and monitoring. All of this results in wasted time and resources.

The VM model has other challenges too. VMs are slow to boot, and portability isn’t great - migrating and moving VM workloads between hypervisors and cloud platforms is harder than it needs to be.

### Hello Containers!

In the container model, the container is roughly analogous to the VM. A major difference is that containers do not require their own full-blown OS. In fact, all containers on a single host share the host’s OS. This frees up huge amounts of system resources such as CPU, RAM, and storage. It also reduces potential licensing costs and reduces the overhead of OS patching and other maintenance.

Containers are also fast to start and ultra-portable. Moving container workloads from your laptop, to the cloud, and then to VMs or bare metal in your data center is a breeze.

Modern containers started in the Linux world and are the product of an immense amount of work from a wide variety of people over a long period of time.

Some of the major technologies that enabled the massive growth of containers in recent years include, **kernel namespaces**, **control groups (**or **cgroups)**, **capabilities**, and of course **Docker**. To re-emphasize what was said earlier - the modern container ecosystem is deeply indebted to the many individuals and organizations that laid the strong foundations that we currently build on.

Despite all of this, containers remained complex and outside of the reach of most organizations. It wasn’t until Docker came along that containers were effectively democratized and accessible to the masses. Docker was the magic that made containers simple!

### Docker and Windows

Microsoft has worked extremely hard to bring Docker and container technologies to the Windows platform.

Windows desktop and server platforms support both of the following:

- Windows containers
- Linux containers

*Windows containers* run Windows apps that require a host system with a Windows kernel. Windows 10 and Windows 11, as well as all modern versions of Windows Server, have native support Windows containers.

Any Windows host running the WSL 2 ( Windows Subsystem for Linux) can also run Linux containers. This makes Windows 10 and 11 great platforms for developing and testing Windows and Linux containers.

However, despite all of the work Microsoft has done developing *Windows containers*, the vast majority of containers are Linux containers. This is because Linux containers are smaller and faster, and the majority of tooling exists for Linux.

### Windows containers vs Linux containers

It’s vital to understand that a container shares the kernel of the host it’s running on. This means containerized Windows apps need a host with a Windows kernel, whereas containerized Linux apps need a host with a Linux kernel.

As previously mentioned, it’s possible to run Linux containers on Windows machines with the WSL 2 backend installed.

### Mac containers

There is currently no such thing as Mac containers. However, you can run Linux containers on your Mac using *Docker Desktop*. This works by seamlessly running your containers inside of a lightweight Linux VM on your Mac.

### Kubernetes

Kubernetes is an open-source project out of Google that has quickly emerged as the most popular tool for deploying and managing containerized apps.

<aside>
💡 A containerized app is an application running as a container.

</aside>

Kubernetes used to use Docker as its default *container runtime* - the low-level technology that pulls images and starts and stops containers. However, modern Kubernetes clusters have a pluggable container runtime interface (CRI) that makes it easy to swap-out different container runtimes.

## Architecture

Docker is so powerful technology, and that often means something that comes with a high level of complexity. And, under the hood, Docker is fairly complex, however, its fundamental user-facing structure is indeed a simple client/server model. There are several pieces sitting behind the Docker API, including *containerd* and *runc* (these are responsible for starting and stopping containers (including building all of the OS constructs such as namespaces and cgroups), but the basic system interaction is a client talking over an API to a server. Underneath this simple exterior, Docker heavily leverages kernel mechanisms such iptables, virtual bridging, cgroups, namespaces, and various filesystems drivers.

### Client/Server Model

It’s easiest to think of Docker as consisting of two parts: the client and the server/daemon.

![Screenshot from 2024-02-07 14-53-46.png](Docker%201b3809b7bf974f5794c421b4e24bf52b/Screenshot_from_2024-02-07_14-53-46.png)

Optionally there is a third component called the registry, which stores Docker images and their metadata. The server does the ongoing work of building, running, and managing your containers, and you use the client to tell the server what to do. The Docker daemon can run on any number of servers in the infrastructure, and a single client can address any number of servers. Clients drive all of the communication, but Docker servers can talk directly to image registries when told to do so by the client. Clients are responsible for telling servers what to do, and servers focus on hosting containerized applications.

Docker is a little different in structure from some other client/server software. It has a *docker* client and a *dockerd* server, but rather than being entirely monolithic, the server then orchestrates a few other components behind the scene on behalf of the client, including *docker-proxy*, *runc*, *containerd*, and sometimes *docker-init*. Docker cleanly hides any complexity behind the simple server API, though, so you can just think of it as a client and server for most purposes. Each Docker host will normally have one Docker server running that can manage a number of containers. You can then use the *docker* command-line tool client to talk to the server, either from the server itself or, if properly secured, from a remote client.

### Network Ports and Unix Sockets

The *docker* command-line tool and *dockerd* daemon talk to each other over network sockets. Docker, Inc., has registered two ports with IANA for use by the Docker daemon and client: TCP ports 2375 for unencrypted traffic and 2376 for encrypted SSL connections. Using a different port is easily configurable for scenarios where you need to use different settings. The default setting for the Docker installer is to use only a Unix socket to make sure the system defaults to the most secure installation, but this is also easily configurable.

### Container Networking

Even though Docker containers are largely made up of processes running on the host system itself, they usually behave quite differently from other processes at the network layer. Docker initially supported a single networking model, but now supports a robust assortment of configurations that handle most application requirements. Most people run their containers in the default configuration, called *bridge mode*.

To understand bridge mode, it’s easiest to think of each of your Docker containers as behaving like a host on a private network. The Docker server acts as a virtual bridge and the containers are clients behind it. A bridge is just a network device that repeats traffic from one side to another. So you can think of it like a mini-virtual network with each container acting like a host attached to that network.

The actual implementation is that each container has its own virtual Ethernet interface connected to the Docker bridge and its own IP address allocated to the virtual interface. Docker lets you bind and expose individual or groups of ports on the host to the container so that the outside world can reach your container on those ports. That traffic passes over a proxy that is also part of the Docker daemon before getting to the container.

Docker detects which network blocks are unused on the host and allocates one of those to the virtual network. That is bridged to the host’s local network through an interface on the server called *docker0*. This means that all of the containers are on a network together and can talk to each other directly. But to get to the host or the outside world, they go over the *docker0* virtual bridge interface.

### Containers are not Virtual Machines

Containers are not virtual machines but they’re very lightweight wrappers around a single Unix process. During actual implementation, that process might spawn others, but on the other hand, one statically compiled binary could be all that’s inside your container. Containers are also ephemeral: they may come and go much more readily than a traditional virtual machine.

Virtual machines are by design a stand-in for real hardware that you might throw in a rack and leave there for a few years. Because a real server is what they’re abstracting, virtual machines are often long-lived in nature. Even in the cloud where companies often spin virtual machines up and down on demand, they usually have a running lifespan of days or more. On the other hand, a particular container might exist for months, or it may be created, run a task for a minute, and then be destroyed. All of that is OK, but it’s fundamentally different approach than the one virtual machines are typically used for.

To help drive this differentiation home, if you run Docker on a Mac or Windows system you are leveraging a Linux virtual machine to run *dockerd*, the Docker server. However, on Linux *dockerd* can be run natively and therefore there is no need for a virtual machine to be run anywhere on the system.

![Screenshot from 2024-02-07 17-56-16.png](Docker%201b3809b7bf974f5794c421b4e24bf52b/Screenshot_from_2024-02-07_17-56-16.png)

### Limited Isolation

Containers are isolated from each other, but that isolation is probably more limited than you might expect. While you can put limits on their resources, the default container configuration just has them all sharing CPU and memory on the host system, much as you would expect from colocated Unix processes. This means that unless you constrain them, containers can compete for resources on your production machines.

It’s often the case that many containers share one or more common filesystem layers. That’s one of the more powerful design decisions in Docker, but it also means that if you update a shared image, you may want to recreate a number of containers that still use the older one.

Containerized processes are just processes on the Docker server itself. They are running on the same exact instance of the Linux kernel as the host operating system. They even show up in the *ps* output on the Docker server. That is utterly different from a hypervisor, where the depth of process isolation usually includes running an entirely separate instance of the operating system kernel for each virtual machine.

<aside>
⛔ By default, many containers use UID 0 to launch processes. Because the container is *contained*, this seems safe, but in reality it isn’t. Because everything is running on the same kernel, many types of security vulnerabilities or simple misconfiguration can give the container’s *root* user unauthorized access to the host’s system resources, files, and processes.

</aside>

### Containers are Lightweight

Creating a new container is much faster than creating a new virtual machine. The new container is so small because it is just a reference to a layered filesystem image and some metadata about the configuration. There is no copy of the data allocated to the container. Containers are just processes on the existing system, so there may not be a need to copy any data for the exclusive use of the container.

The lightness of containers means that you can use them for situations where creating another virtual machine would be too heavyweight or where you need something to be truly ephemeral. You probably wouldn’t, for instance, spin up an entire virtual machine to run a *curl* command to a website from a remote location, but you might spin up a new container for this purpose.
