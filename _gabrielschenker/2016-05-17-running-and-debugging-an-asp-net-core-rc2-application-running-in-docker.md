---
wordpress_id: 1500
title: Running and debugging an ASP.NET Core RC2 application in Docker
date: 2016-05-17T21:05:04+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1500
dsq_thread_id:
  - "4836082848"
categories:
  - .NET
  - ASP.NET vNext
  - containers
  - docker
  - How To
  - introduction
---
# Introduction

In a [previous post](https://lostechies.com/gabrielschenker/2016/04/22/testing-and-debugging-a-containerized-asp-net-application/) I demonstrated how we can run and test an ASP.NET Core RC1 application. Yesterday [RC2](http://dot.net) was made public and it is now time to revisit the subject. This time we are going to create an ASP.NET Core RC2 MVC application, Docker-ize it and analyze how we can run and debug this application.

[<img src="https://lostechies.com/gabrielschenker/files/2016/05/Install-rc2.png" alt="" title="Install-rc2" width="600" height="372" class="alignnone size-full wp-image-1503" />](https://lostechies.com/gabrielschenker/files/2016/05/Install-rc2.png)

# Prerequisites

Please follow the instructions [here](http://dot.net) to install RC2 of .NET Core and ASP.NET Core as well as the necessary tooling support. Once you have installed RC2 please make sure to also install the Visual Studio Extension **Docker Tools for Visual Studio 2015 &#8211; Preview** that provides first class Docker support. You can find this extension [here](https://visualstudiogallery.msdn.microsoft.com/0f5b2caa-ea00-41c8-b8a2-058c7da0b3e4).

[<img src="https://lostechies.com/gabrielschenker/files/2016/05/docker-tools-for-vs1.png" alt="" title="docker-tools-for-vs" width="816" height="257" class="alignnone size-full wp-image-1511" />](https://lostechies.com/gabrielschenker/files/2016/05/docker-tools-for-vs1.png)

Finally please make sure that you have the [Docker Toolbox](https://www.docker.com/products/docker-toolbox) installed.

# Create an application

Start Visual Studio and create a new **ASP.NET Web Core Web Application**. Let&#8217;s call the solution `HelloRC2` and the project `Web`.

[<img src="https://lostechies.com/gabrielschenker/files/2016/05/new-project.png" alt="" title="new-project" width="1130" height="555" class="alignnone size-full wp-image-1506" />](https://lostechies.com/gabrielschenker/files/2016/05/new-project.png)

Select **Web Application** as template

[<img src="https://lostechies.com/gabrielschenker/files/2016/05/select-template.png" alt="" title="select-template" width="450" height="285" class="alignnone size-full wp-image-1508" />](https://lostechies.com/gabrielschenker/files/2016/05/select-template.png)

So far so good. Let&#8217;s try to run this application locally on our developer machine. Select `Web` as target and press `F5` to start the application. After compiling Visual Studio will start `Kestrel` (the new lightweight Microsoft Web Server) in a console window. It will also open a browser window at `localhost:5000`. By default `Kestrel` listens at port `5000`.

If the browser reports an error _This site can&#8217;t be reached_ then you might need to hit refresh since `Kestrel` was not starting up fast enough and thus was not ready to serve the request from the browser.

Wonderful, we have our ASP.NET Core application up and running. But this is not so exciting because it&#8217;s what we have done all the time&#8230; Thus let&#8217;s come to the more fascinating part, running the application in a Docker container.

# Add Docker support

In the **Solution Explorer** right click on the `Web` project and select `Add` from the context menu. From the sub-menu select `Docker Support`. A folder called `Docker` will be added to our project containing a few interesting files. In addition to that the extension also adds two support files to the `Properties` folder. These are needed to provide the seamless integration of building, running and debugging Docker containers from within Visual Studio.

[<img src="https://lostechies.com/gabrielschenker/files/2016/05/docker-tooling.png" alt="" title="docker-tooling" width="414" height="665" class="alignnone size-full wp-image-1513" />](https://lostechies.com/gabrielschenker/files/2016/05/docker-tooling.png)

With that we&#8217;re ready to start&#8230;

# Run and debug the application

Make sure you select `Docker` as target

[<img src="https://lostechies.com/gabrielschenker/files/2016/05/docker-as-target.png" alt="" title="docker-as-target" width="408" height="320" class="alignnone size-full wp-image-1515" />](https://lostechies.com/gabrielschenker/files/2016/05/docker-as-target.png)

Hit `F5` to start the application. If you observe the `Output` window while the application is building you will notice that the script `DockerTask.ps1` that was added to the `Docker` folder is executed. This script will do the following

  * build the application 
  * publish the application 
  * create a Docker image using the published application 
  * create and run a container from the above image 
  * start a browser page listening at `[IP address]` (where `[IP address]` corresponds to the IP address of your Docker host. In most cases this is `192.168.99.100`)

As a result you should see your Web application running inside a container. The look and feel of the application in the browser is exactly the same as when we were running it directly on our developer machine

While building the container image the script has also added remote debugging support into the image. Thus we should be able to start a debugging session. Let&#8217;s do this now. Add a break point to line 18 of the `HomeController`. Now in the application select the `About` menu and observe how the debugger stops at the break point. We can now observe the content of variables or step through the code line by line &#8211; exactly the same way as we&#8217;re used when we&#8217;re debugging an application running directly on our developer box.

# Summary

In this post I have demonstrated how we can create an ASP.NET Core RC2 MVC application, deploy the application into a Docker container and remote debug the application running in the container.

Given the fact, that the tooling support is only in Preview 1 I am sure that once it is finalized we will have first class support for Docker containers from within Visual Studio. This is really exciting!