---
wordpress_id: 649
title: 'RabbitMQ for Windows: Introduction'
date: 2012-03-05T07:00:00+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=649
dsq_thread_id:
  - "599330771"
categories:
  - Uncategorized
tags:
  - RabbitMQ
---
## Posts In This Series

<div>
  <ul>
    <li>
      RabbitMQ for Windows: Introduction
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/03/07/rabbitmq-for-windows-building-your-first-application/">RabbitMQ for Windows: Building Your First Application</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/03/18/rabbitmq-for-windows-hello-world-review/">RabbitMQ for Windows: Hello World Review</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/03/28/rabbitmq-for-windows-exchange-types/">RabbitMQ for Windows: Exchange Types</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/04/02/rabbitmq-for-windows-direct-exchanges/">RabbitMQ for Windows: Direct Exchanges</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/05/16/rabbitmq-for-windows-fanout-exchanges/">RabbitMQ for Windows: Fanout Exchanges</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/05/18/rabbitmq-for-windows-topic-exchanges/">RabbitMQ for Windows: Topic Exchanges</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/05/29/rabbitmq-for-windows-headers-exchanges/">RabbitMQ for Windows: Headers Exchanges</a>
    </li>
  </ul>
</div>

If you’re interested in getting started with distributed programming and you develop on the Microsoft Windows platform, <a href="http://www.rabbitmq.com" target="_blank">RabbitMQ</a> may be what you’re looking for.&nbsp; RabbitMQ is an open source, standards-based, multi-platform message broker with client libraries available for a host of development platforms including .Net.&nbsp;&nbsp; 

This series will provide a gentle introduction to getting started with RabbitMQ for .Net developers, including a Windows environment installation guide along with an introduction to basic concepts and features through the use of examples in C#.&nbsp; In this first installment, we’ll cover installation and basic configuration. 

## Installation 

The first thing to know about RabbitMQ installation is that RabbitMQ runs on the [Erlang](http://en.wikipedia.org/wiki/Erlang_(programming_language)) virtual runtime.&nbsp; “_What is Erlang_”, you ask, and “_Why should I ask our admins to install yet another runtime engine on our servers_”?&nbsp; Erlang is a functional language which places a large emphasis on concurrency and high reliability.&nbsp; Developed by&nbsp; Joe Armstrong, Mike Williams, and Robert Virding to support telephony applications at Ericsson, Erlang’s flagship product, the Ericsson AXD301 switch, is purported to have achieved a reliability of nine [&#8220;9&#8221;s](http://en.wikipedia.org/wiki/Nines_(engineering)). 

A popular quote among Erlang adherents is Verding’s “First Rule of Programming”: 

> “Any sufficiently complicated concurrent program in another language contains an ad hoc informally-specified bug-ridden slow implementation of half of Erlang.” &#8211; Robert Verding 

Sound like the perfect platform to write a message broker in?&nbsp; The authors of RabbitMQ thought so too. 

With that, let’s get started with the installation. 

### &nbsp;

### Step 1: Install Erlang

The first step will be to download and install Erlang for Windows.&nbsp; You can obtain the latest installer from [here](http://www.erlang.org/download.html) (version R15B at the time of this writing) . 

After downloading and completing the Erlang installation wizard, you should have a new ERLANG_HOME environment variable set.&nbsp; If not, you’ll want to set this now so RabbitMQ will be able to locate your installation of Erlang. 

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="ErlangEnv" border="0" alt="ErlangEnv" src="https://lostechies.com/content/derekgreer/uploads/2012/03/ErlangEnv_thumb.png" width="395" height="438" />](https://lostechies.com/content/derekgreer/uploads/2012/03/ErlangEnv.png) 

&nbsp; 

### &nbsp;

### Step 2: Install RabbitMQ

Next, download and install the latest version of RabbitMQ for Windows from [here](http://www.rabbitmq.com/download.html) (version 2.7.1 at the time of this writing). 

### &nbsp;

### Step 3: Install the RabbitMQ Management Plugin 

By default, the RabbitMQ Windows installer registers RabbitMQ as a Windows service, so technically we’re all ready to go.&nbsp; In addition to the command line utilities provided for managing and monitoring our RabbitMQ instance, a Web-based management plugin is also provided with the standard Windows distribution.&nbsp; The following steps detail how to get the management plugin up and going. 

First, from an elevated command prompt, change directory to the sbin folder within the RabbitMQ Server installation directory (e.g. %PROGRAMFILES%\RabbitMQ Server\rabbitmq\_server\_2.7.1\sbin\). 

Next, run the following command to enable the rabbitmq management plugin: 

<pre class="prettyprint">rabbitmq-plugins.bat enable rabbitmq_management 
</pre>

&nbsp; 

Lastly, to enable the management plugin we need to reinstall the RabbitMQ service.&nbsp; Execute the following sequence of commands to reinstall the service: 

<pre class="prettyprint">rabbitmq-service.bat stop 
rabbitmq-service.bat install 
rabbitmq-service.bat start 
</pre>

&nbsp; 

To verify management plugin is up and running, start your favorite browser and navigate to <http://localhost:55672/mgmt/>.&nbsp; If everything went ok, you should see a screen similar to the following: 

&nbsp; 

&nbsp;[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="RabbitManagement" border="0" alt="RabbitManagement" src="https://lostechies.com/content/derekgreer/uploads/2012/03/RabbitManagement_thumb.png" width="640" height="302" />](https://lostechies.com/content/derekgreer/uploads/2012/03/RabbitManagement.png)

Note: The management plugin URL has been changed to <http://localhost:15672/> for versions 3.0 and higher.

From here, you’ll be able to configure and monitor your RabbitMQ instance. 

That concludes our installation guide.&nbsp; Next time, we’ll walk through writing our first RabbitMQ C# application.
  
</b>
