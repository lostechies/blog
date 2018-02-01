---
id: 1468
title: Windows Docker Containers
date: 2016-04-30T23:31:48+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1468
dsq_thread_id:
  - "4790706584"
categories:
  - ASP.NET vNext
  - containers
  - docker
  - How To
  - installation
  - introduction
  - Setup
  - tutorial
---
# Introduction

In this post I am going to show step by step how to install a local version of Windows Server 2016 TP5 in Hyper-V and how to configure it to be a container host.

# Tutorial

It is still not straight forward to configure a **Windows Server 2016** as a container host and use Docker to build and run containers. Microsoft provides pre-configured VMs in Azure but I want to run a Windows Container host on my developer machine in Hyper-V. Up to TP4 I failed to do this. Now that TP5 is finally out I tried again and after some first failures I finally succeeded. I want to describe the steps necessary to achieve this on my machine and I hope that I can help some folks out there trying the same to avoid all the hassle I went through.

## Enable Hyper-V

First we need to enable Hyper-V on our laptop. Do this via **Control Panel**. In the **Programs** section select **Turn Windows features on or off**. [<img src="https://lostechies.com/gabrielschenker/files/2016/04/install-hyper-v.png" alt="" title="install-hyper-v" width="1000" height="314" class="alignnone size-full wp-image-1469" />](https://lostechies.com/gabrielschenker/files/2016/04/install-hyper-v.png)

## Download Windows Server 2016 TP5

Once the feature is installed we have to reboot our machine. Next we want to download **Windows Server 2016 TP5**. We can get it from [here](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-technical-preview). Make sure you download **Windows Server 2016 Technical Preview 5** and not the **Hyper-V** or the **Essentials** version.

## Define a switch

Now we can start the Hyper-V management console. First we add a new virtual switch. Make sure that you select the type **External** and that you link it to you Ethernet card. Note that there is an error that makes it impossible to link it to a WLAN port. I lost quite some time trying to configure my switch when I was on WLAN and not on a wired connection.

## Create the VM

Once we have defined the external switch we can create a new VM. Navigate through the VM creation wizard and create a new VM. When asked, mount the ISO that you just downloaded to the VM. Once you&#8217;re done, start the VM. First we are asked to define a new password for the Admin. Then we can start working. Make sure that you have internet connection using e.g. `ping` or `ipconfig`.

## Make it a container host

Now we are ready to make this Windows Server 2016 TP5 VM a container host. For this we use `Powershell`. On the command prompt enter `powershell`. Next we load a script prepared by Microsoft from `http://aka.ms`. We use the `wget` command for this. Please note the URL that we&#8217;re using. It is different from what is published in many documents and videos of Microsoft.

`wget http://aka.ms/tp5/install-ContainerHost -OutFile c:\install-ContainerHost.ps1`

Now we can use this Powershell file to configure our server as a container host by executing this command

`powershell -NoProfile -ExecutionPolicy Bypass c:\install-ContainerHost.ps1`

Now we need to be patient, very patient. You might wanna brew some coffee and watch a nice movie while the script is running. It took more than an hour on my decently fast machine having an SSD as the main drive. A lot of things are going to happen. The server is also going to reboot some time into the operation. After the reboot the script will download the **WindowsServerCore** container image and extract it. Your screen should look similar to this

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/install-container-host1.png" alt="" title="install-container-host" width="1283" height="525" class="alignnone size-full wp-image-1475" />](https://lostechies.com/gabrielschenker/files/2016/04/install-container-host1.png)

When the script execution has finally come to an end we *&#42;need&#42; to restart the server otherwise Docker won&#8217;t see the new image when executing `docker images`. When I executed the said command without first restarting the **Docker Daemon** I nearly got a heart attack since no image was listed. Another waste of time I thought, but then I did what I always do when nothing works anymore&#8230; We can do this like this `net stop "Docker Daemon"<br />
net start "Docker Daemon"`

Now using the `docker images` command I got this

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/docker-images.png" alt="" title="docker-images" width="970" height="316" class="alignnone size-full wp-image-1479" />](https://lostechies.com/gabrielschenker/files/2016/04/docker-images.png)

Hallelujah, I thought! There is is, the expected **windowsservercore** image. It is currently the only image available to us on our machine.

## Tagging an image

To tag our image we can use the normal Docker tag command

`docker tag [image-id] windowsservercore:latest`

where `[image-id]` is the ID of the Docker image as listed in the previous picture. In my case this is `dfee88ee9fd`.

## More images

We can use the Powershell command `Find-ContainerImage` to see what other images are available to us. We should see this [<img src="https://lostechies.com/gabrielschenker/files/2016/04/find-container-image.png" alt="" title="find-container-image" width="1234" height="126" class="alignnone size-full wp-image-1480" />](https://lostechies.com/gabrielschenker/files/2016/04/find-container-image.png)

Apparently there is an image called `NanoServer` available to us. Lets install it on our machine using this command

`Install-ContainerImage -Name NanoServer`

This will take a few moments and once done we can verify that we now have not only `windowsservercore` but also `nanoserver` listed as available images on the local machine. Use this command

`Get-ContainerImage`

and the result should be similar to this

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/get-container-image.png" alt="" title="get-container-image" width="1246" height="162" class="alignnone size-full wp-image-1481" />](https://lostechies.com/gabrielschenker/files/2016/04/get-container-image.png)

After restarting the Docker daemon (see above) we can also see the `nanoserver` image using the `docker images` command

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/restart-docker-daemon.png" alt="" title="restart-docker-daemon" width="919" height="241" class="alignnone size-full wp-image-1484" />](https://lostechies.com/gabrielschenker/files/2016/04/restart-docker-daemon.png)

# Create Container Images

## IIS Image

We can take it as our base and create some new images of from it. Let&#8217;s create an IIS image first as a test. Let&#8217;s run an instance of the image `windowsservercore` as follows

`docker run -it windowsservercore powershell`

Once we&#8217;re inside the container running in a Powershell console we use this command to install IIS

`Install-WindowsFeature web-server`

and we can exit the container by typing `exit` in the console. Finally we create an image from the current state of the container using this command

`docker commit iisbase windowsservercore-iis`

This operation takes a moment. Once we&#8217;re done we can use `docker images` to verify that we have indeed created a new image called `windowsservercore-iis`. We can run a Docker container from this image and open port 80 to the public by using this command

`docker run -dt --name iisdemo -p 80:80 windowsservercore-iis`

If we open a browser and navigate to the IP address of our container host VM (in my case this is 192.168.1.95) we see the expected result

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/iis-container.png" alt="" title="iis-container" width="804" height="502" class="alignnone size-full wp-image-1489" />](https://lostechies.com/gabrielschenker/files/2016/04/iis-container.png)

Great, we have our first custom built container running! But wait a second&#8230; Docker does not recommend to build images using the `docker commit` command. The preferred way is to use a `Dockerfile`.

## Using a Dockerfile to create an image

Let&#8217;s do this. Create a folder `c:\docker\iis` and navigate to this folder. Create a new file using

`echo "" > Dockerfile`

then use notepad to edit this file

`notepad .\Dockerfile`

Now add the following content to the file

`FROM windowsservercore<br />
RUN ["powershell","Install-WindowsFeature","web-server"]`

Save the file. Make sure that you save the file as ASCII encoded or UTF-8 without encoding. Docker doesn&#8217;t like the BOM at the beginning of a standard UTF-8 encoded file. We should see an output similar to the following

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/build-iis-image1.png" alt="" title="build-iis-image" width="828" height="270" class="alignnone size-full wp-image-1493" />](https://lostechies.com/gabrielschenker/files/2016/04/build-iis-image1.png)

And once again we can run an instance of this image with

`docker run -dt --name iisdemo -p 80:80 iis`

Navigating with the browser to the IP address of the VM shows the same result as above. The default IIS site is shown as expected.

## Nginx Image

Now let&#8217;s create an [nginx](http://www.nginx.org) image as a second test. Let&#8217;s again run an instance of the image `windowsservercore` as follows

`docker run -it windowsservercore powershell`

Now after a short time we should find ourselves inside a Docker container in a Powershell console. Now we want to download **nginx** and can do this as follows

`wget http://nginx.org/download/nginx-1.10.0.zip -UseBasicParsing -OutFile nginx.zip`

This will take a few seconds to download. Now we need to extract this zip file using the following command

`Expand-Archive nginx.zip`

This will expand the file into a folder `nginx`. The binaries are in a subfolder `nginx-1.10.0`. We can now exit this container by typing `exit` in the Powershell console. Now we can use this container to create an image from it. First we need to know what it&#8217;s id is. Let&#8217;s do this by using `docker ps -a`. Our container should be in the list and it&#8217;s status should be `Exited`. Remember the ID of the container. Now we can use the following command to generate an image

`docker commit [container-id] windowsservercore-nginx`

When we now use `docker images` to get a list of container images we should see this

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/nginx-image.png" alt="" title="nginx-image" width="968" height="186" class="alignnone size-full wp-image-1487" />](https://lostechies.com/gabrielschenker/files/2016/04/nginx-image.png)

As mentioned above, a better way to create an Nginx based image is to use a `Dockerfile`. For this let&#8217;s create a folder `c:\docker\nginx`. In this folder we create a new new file called `Dockerfile`. The content of the file should be

[gist id=fa1d9e3e4320940e6a2c9a03409f68c2]

We can build this image using

`docker build -t nginx .`

and then we run a container like this

`docker run -dt --name nginx -p 80:80 nginx`

if we navigate with a browser to our IP address we see this

[<img src="https://lostechies.com/gabrielschenker/files/2016/04/nginx-container.png" alt="" title="nginx-container" width="637" height="322" class="alignnone size-full wp-image-1495" />](https://lostechies.com/gabrielschenker/files/2016/04/nginx-container.png)

Nice. We just have successfully build a second custom image based on the popular Nginx web server.

# Summary

In this post I have described how we can configure a developer machine to run a **Windows Server 2016 TP5** VM in Hyper-V which is configured to be a Windows Container host. I also have shown how we can now use Docker to build container images and run instances of those as containers. It is very nice to see that the Docker API for Windows Containers is exactly the same as for Linux Containers. This makes life much easier for us developers that have to deal with both operating systems on a daily basis. If on the other hand you&#8217;re a pure Windows developer you can also use **Powershell** to create container images and instantiate and run containers.