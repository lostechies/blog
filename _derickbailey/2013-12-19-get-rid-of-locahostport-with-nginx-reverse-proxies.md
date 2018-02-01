---
id: 1185
title: 'Get Rid Of &#8220;locahost:#port#&#8221; With NGINX Reverse Proxies'
date: 2013-12-19T22:41:54+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=1185
dsq_thread_id:
  - "2062172058"
categories:
  - nginx
  - Service
  - SignalLeaf
  - Web
---
I ran in to a situation recently where I needed to have one of my web projects running on port 80 on my Mac. Normally, when i start up this project in NodeJS, it runs on port 3000. But due to an interesting interaction between this project and another project, port numbers can&#8217;t be used in my project&#8217;s URL. Now you might think that this would be easy&#8230; just tell NodeJS to use port 80 and be done with it, right? In simple scenarios, that would work just fine. But I have anything but a simple scenario. My project has multiple web server instances (all communicating with a RabbitMQ &#8211; but that&#8217;s another story) and I need all of them to run on port 80, at different URLs&#8230; all on my Mac, where I am writing code and debugging the interactions. 

Right&#8230; so&#8230; multiple web server instances, all on port 80, with different DNS entries (URLs) for each. Great. There goes my day&#8230; or at least I thought so. Fortunately, **[NGINX](http://nginx.com/) to the rescue!** Using reverse-proxies and a couple of entries in my /etc/hosts file, I was able to get all my servers up and running on their own port and have them appear at their own URL. 

## The Gist Of A Reverse Proxy

**The idea behind a proxy is that it does something on your behalf,** and returns the result to you &#8211; sometimes modified to suit some specific purpose. A web proxy, for example, will request things from the web and filter them, or compress them further, or do other crazy things that web proxies might do. This is typically transparent to you, the end user. You make a request as you normally would, and the proxy picks it up on your behalf, as your request makes its way out to the internet and back.

**A reverse proxy is one that happens in the opposite direction than the normal &#8220;handle this request and send me the results&#8221; type of proxy.** Instead of your web browser request being proxied for some purpose, it&#8217;s the web server that is being proxied. In other words, a reverse proxy handles all the incoming requests for your web server, and sends the real request to the right place to handle it. It sits in front of the real services, pushes requests to the actual service and sends responses from the service back to the original requestor. 

**In the case of wanting to stand up multiple services on port 80, or the need to get rid of a port # from a server and use port 80, a reverse proxy is the perfect solution.** It won&#8217;t actually let you stand up multiple services on port 80, though. Instead, it will take a myriad of services that all run on different ports (3000, 3001, 4000, etc) and proxy them through port 80. Each service, running in any language that it wants to run in, will have it&#8217;s own port like you would expect. Nginx takes over port 80 and listens for specific requests. When it sees a request it knows how to handle, it takes that requests and proxies it to the actual service that can handle it. 

It&#8217;s a pretty slick setup, and one that should understand if you&#8217;re going to be doing scalable web development with multiple services on a single port or URL.

## Installing And Starting NGINX

This was pretty easy for me on my Mac. I just used HomeBrew&#8230; didn&#8217;t even bother checking to see if it was possible. I just opened my terminal and ran

<pre>brew install nginx</pre>

and it worked! A few minutes later, I had a working version of nginx on my box. The basics of starting and stopping nginx are:

<pre>sudo nginx</pre>

This will start it up. Note that &#8216;sudo&#8217; is only required if you&#8217;re trying to take a port below 1024. Anything above that doesn&#8217;t require sudo. To stop it, run

<pre>sudo nginx -s stop</pre>

This, as you expect, stops nginx (again, the sudo bit). But you might want to have nginx run on startup with your machine. That&#8217;s easy enough. Just [add an nginx.plist file to your box](http://wiki.nginx.org/OSX_launchd) and tell launchctl to run it at startup:

<pre>launchctl load -F /System/Library/LaunchDaemons/nginx.plist</pre>

Using this also prevents you from having to run &#8216;sudo&#8217; to start it, since it&#8217;s a system command launching it. I recommend doing this so that you don&#8217;t have to launch nginx yourself again. The only downside is that it will take over your ports that you assign it to. If you need something else on port 80, you&#8217;ll have to stop nginx.

But then, the whole point of this configuration is to proxy many services from port 80 to the actual service &#8211; so why don&#8217;t you just do that instead?

## Setting Up A Reverse Proxy

There are a cubic ton of options and configuration options in nginx. It&#8217;s a bit crazy, honestly, and took me a bit to figure out. The ones that you care about, though, include setting up a `server` with a `location` and various `proxy_*` settings in that location. A server is really a virtual server. It tells nginx what port to listen on, what `server_name` to look for (HOST header), and it allows different &#8220;locations&#8221; &#8211; virtual directories &#8211; to be pointed at different actual resources or processes. In the case of a reverse proxy, the `location` settings will contain the `proxy_*` configuration.

A very basic configuration for a reverse proxy might look like this (and this is the one I&#8217;m actually using right now)

<pre>server {<br />    listen 80;<br />    server_name dev.signalleaf.com;</pre>

<pre>    location / {<br />        proxy_pass http://localhost:3000/;<br />        proxy_redirect off;<br />        proxy_set_header X-Real-IP $remote_addr;<br />        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;<br />        proxy_set_header Host $http_host;<br />        proxy_set_header X-NginX-Proxy true;<br />    }<br /> }</pre>

There are several things going on here. First off, I&#8217;m attaching nginx to port 80. Secondly, I&#8217;m telling it to listen for the server name of &#8220;dev.signalleaf.com&#8221; &#8211; this will be a HOST header that my browser sends. Then I&#8217;m telling it to watch for the root of that URL (the &#8220;/&#8221; location) and telling it how to handle the proxying of information from the original request over to my actual NodeJS/ExpressJS server that is running on `localhost:3000`. 

And A hosts Entry

Before I can make this work on my box, though, I need one more thing: an entry in my `/etc/hosts` file to make dev.signalleaf.com actually work on my box. This isn&#8217;t a real DNS entry that I want to have live on the internet. It&#8217;s just an entry that I want on my box, so that I can use dev.signalleaf.com as my development URL (getting rid of the :3000 port number in the process). 

<pre>127.0.0.1 dev.signalleaf.com</pre>

## Let The Magic Happen

With nginx and my hosts file entry in place, I can hit http://dev.signalleaf.com on my box, and get the content that is typically served up from localhost:3000! My goal of getting rid of the port number has been achieved. From here, it won&#8217;t take a ton of extra configuration to get the additional services configured in nginx, all responding from port 80. 

 