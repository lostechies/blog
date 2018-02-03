---
wordpress_id: 3973
title: 'Code samples from my ADNUG talk &#8211; Coding with Conventions'
date: 2011-02-23T02:42:45+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2011/02/22/code-samples-from-my-adnug-talk-coding-with-conventions.aspx
dsq_thread_id:
  - "262428390"
categories:
  - Uncategorized
---
A couple people have asked for the code I used during my talk at the Austin .NET User Group last night.

The code is on github: <https://github.com/joshuaflanagan/adnug_Feb2011>

The master branch has the state of the code before I started the talk. The live branch has the code after I was done.

If you aren&#8217;t familiar with git, you can download the two branches as zip files:

master: <https://github.com/joshuaflanagan/adnug_Feb2011/archives/master>

live: <https://github.com/joshuaflanagan/adnug_Feb2011/archives/live>

&#160;

The sample application is built on ASP.NET MVC 3. It demonstrates a simplified version of the convention-based view helpers from <a href="http://fubumvc.com/" target="_blank">FubuMVC</a>. The view helpers make use of the <a href="https://github.com/DarthFubuMVC/htmltags" target="_blank">HtmlTags</a> library (now available via <a href="http://www.nuget.org/" target="_blank">nuget</a>), which I recommend you use whenever building HtmlHelper extensions (for ASP.NET MVC or FubuMVC).

&#160;

If you are curious, I also have a version of the same sample application that was built on FubuMVC:

<https://github.com/joshuaflanagan/leveraging-conventions>

That code includes a readme with basic setup instructions, as well as notes.txt which contains an outline of the steps I followed during the presentation.

As always, feel free to contact me with any questions or feedback.