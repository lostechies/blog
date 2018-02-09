---
wordpress_id: 39
title: 'Hudson CI Server: setting up remote slaves AND restrictive security together'
date: 2010-04-14T14:35:12+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2010/04/14/hudson-ci-server-setting-up-remote-slaves-and-restrictive-security-together.aspx
dsq_thread_id:
  - "1069725906"
categories:
  - CI
  - Hudson
redirect_from: "/blogs/rssvihla/archive/2010/04/14/hudson-ci-server-setting-up-remote-slaves-and-restrictive-security-together.aspx/"
---
### <font color="#ff0000">NOTE: this applies to Hudson version 1.352</font>

Ok so yesterday I was setting up a publicly accessible build server, that was not to be viewable to anonymous sources. So I configured Hudson to “matrix security” and disallowed all access to anonymous see fig 1-1.However, once I did this my slaves stopped working entirely.&#160; Now I could have allowed some anonymous access but here was the long sought for trick.

1) configure slaves to use “launch method” JNLP fig 1-2 below.

2) on client use java webstart to install the service by going to “http://yourserver:port/computer/slave-name/slave-agent.jnlp”. Make sure you select "install as a windows service”. In my case I had to select “file” then “install as a windows service”

3) open up wherever your base Hudson slave home was (mine was c:hudson) and find&#160; hudson-slave.xml.

4) once hudson-slave.xml is open look for the arguments line and make the following changes (replace user:pass with whatever your username and password is that has rights).

> before: <arguments>-Xrs -jar "%BASE%slave.jar" -jnlpUrl <http://yourserver:8080/computer/yourslave/slave-agent.jnlp</arguments>>
> 
> after:&#160;&#160;&#160; <arguments>-Xrs -jar "%BASE%slave.jar" -jnlpUrl <http://yourserver:8080/computer/yourslave/slave-agent.jnlp> -jnlpCredentials user:pass -auth user:pass</arguments>

5) restart your hudson slave service and after a page refresh on your build server you should now have an up and reporting node!

&#160;

Fig 1-1

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/ryansvihla/files/2011/03/image_thumb_75016308.png" width="938" height="288" />](http://lostechies.com/ryansvihla/files/2011/03/image_4BF6C40C.png) 

fig 1-2

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/ryansvihla/files/2011/03/image_thumb_60127146.png" width="935" height="302" />](http://lostechies.com/ryansvihla/files/2011/03/image_76D1B8CF.png)