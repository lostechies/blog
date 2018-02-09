---
wordpress_id: 862
title: Creating an Ubuntu developer VM on Hyper-V – Part 4
date: 2014-12-31T18:54:30+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=862
dsq_thread_id:
  - "3378471027"
categories:
  - ASP.NET vNext
  - How To
  - installation
  - introduction
  - REST
  - Setup
  - Ubuntu
  - VM
---
# Introduction

We have been in the past and still are to a certain extent a .NET shop. Thus it is very important to us that we can develop our backend using ASP.NET Web API. ASP.NET vNext is now OSS and runs equally well on Windows, Linux and Mac. Well, at least that’s what the folks at Microsoft tell us. The goal of this post is to verify that we can indeed create a RESTful backend using ASP.NET vNext on Ubuntu.

Please make sure you have also read my previous posts about setting up a Ubuntu VM.

  * [Creating an Ubuntu developer VM on Hyper-V](http://lostechies.com/gabrielschenker/2014/12/29/creating-an-ubuntu-developer-vm-on-hyper-v/)&nbsp; 
      * [Creating an Ubuntu developer VM on Hyper-V – Part 2](http://lostechies.com/gabrielschenker/2014/12/30/creating-an-ubuntu-developer-vm-on-hyper-v-part-2/) 
          * [Creating an Ubuntu developer VM on Hyper-V – Part 3](http://lostechies.com/gabrielschenker/2014/12/31/creating-an-ubuntu-developer-vm-on-hyper-v-part-3/)</ul> 
        # Installing ASP.NET vNext
        
        Please refer [here](https://github.com/aspnet/home) for more details. But please be aware that at the time of writing the documentation is somewhat incomplete to say the least.
        
        Let’s first install the K version manager (KVM). With the following command we get the KVM setup
        
        {% gist 5075ae759ef4392a8126 %}
        
        Note that as a prerequisite we need to have [Mono](http://www.mono-project.com/) 3.4.1 or later installed as described in [this](http://lostechies.com/gabrielschenker/2014/12/29/creating-an-ubuntu-developer-vm-on-hyper-v/) post.
        
        We can now install the latest version of KVM like this (at the time of this writing it is v 1.0.0-beta1)
        
        <font face="courier new">kvm upgrade</font>
        
        To test the whole thing I first create a new folder aps.net-vNext and navigate to it
        
        <font face="courier new">mkdir ~/dev/asp.net-vNext</font>
        
        <font face="courier new">cd ~/dev/asp.net-vNext</font>
        
        and then clone the ASP.NET Home directory from GitHub to it
        
        <font face="courier new">git clone </font>[<font face="courier new">https://github.com/aspnet/Home.git</font>](https://github.com/aspnet/Home.git "https://github.com/aspnet/Home.git")
        
        ## Running the Console sample application
        
        We can now try to play with the samples in the Home folder. Let’s start with the simplest one, the ConsoleApp. Let’s navigate to this folder
        
        <font face="courier new">cd ./Home/samples/ConsoleApp</font>
        
        ## Creating the necessary certificates
        
        If we try to run <font color="#000000" face="Courier New">kpm restore </font>now directly as described [here](https://github.com/aspnet/home#running-the-samples) then we get loads of errors. The reason is that the .NET Framework on Windows uses the Windows Certificates store to check whether to accept an SSL certificate from a remote site. In Mono, there is no Windows Certificate store, it has its own store. By default, it is empty and we need to manage the entries ourselves. We can do this using the following script
        
        {% gist ef91e2443c92a6a2bd5e %}
        
        Having added all those certificates to the store we can now download/restore all nuget packages required by our sample app
        
        <font face="courier new">kpm restore</font>
        
        and then run the sample
        
        <font face="courier new">k run .</font>
        
        which gives us
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2014/12/image_thumb10.png" width="619" height="119" />](http://lostechies.com/gabrielschenker/files/2014/12/image10.png)
        
        ## Running the Web samples
        
        Running the Web samples is a bit more tricky. First of all we need kestrel, a development web server for ASP.NET vNext. At the time of writing there is an open issue with running Kestrel on Linux. Kestrel relies on libuv. To install a compatible version of libuv use the following script (that I found [here](http://carolynvanslyck.com/blog/2014/09/dotnet-vnext-impressions/))
        
        {% gist 2f0d4706a92446fcf266 %}
        
        After all this we should be able to get our MVC and Web samples going. Navigate to the corresponding sample folder and restore the nuget packages
        
        <font face="Courier New">kpm restore</font>
        
        and then run the sample
        
        <font face="courier new">k kestrel</font>
        
        which now should give this
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2014/12/image_thumb11.png" width="611" height="153" />](http://lostechies.com/gabrielschenker/files/2014/12/image11.png)
        
        with your browser navigate to localhost:5004 and enjoy 🙂
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2014/12/image_thumb12.png" width="611" height="470" />](http://lostechies.com/gabrielschenker/files/2014/12/image12.png)&nbsp;
        
        We can stop Kestrel by pressing CTRL-z
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2014/12/image_thumb13.png" width="610" height="143" />](http://lostechies.com/gabrielschenker/files/2014/12/image13.png)
        
        ## Defining a REST API
        
        Now let’s add a simple REST API to the HelloMVC sample app. Add a file **TodoController.cs** to the Controllers directory and add the following code
        
        {% gist 63161f462b022fe3e8bc %}
        
        save and restart kestrel. In the browser navigate to <http://localhost:5004/api/todo> and you should see this
        
        [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2014/12/image_thumb14.png" width="614" height="386" />](http://lostechies.com/gabrielschenker/files/2014/12/image14.png) </p> 
        
        Well, well, that’s a good start…!
        
        # Summary
        
        In the last four posts I have summarized all the necessary steps that are needed to setup a Ubuntu VM ready to develop Angular single page applications that are backed by either a Node JS or a .NET (Mono) backend. The backend relies on GetEventStore as a write model store and on Elastic Search and MongoDB as read model stores. Thus we are now ready to implement an end-to-end sample. This will be the topic of my next few posts. Stay tuned.