---
wordpress_id: 62
title: Weird CruiseControl.NET error
date: 2007-09-17T13:50:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/09/17/weird-cruisecontrol-net-error.aspx
dsq_thread_id:
  - "272670244"
categories:
  - Misc
redirect_from: "/blogs/jimmy_bogard/archive/2007/09/17/weird-cruisecontrol-net-error.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/09/weird-cruisecontrolnet-error.html)._

So I&#8217;m setting up [CC.NET](http://confluence.public.thoughtworks.org/display/CCNET/Welcome+to+CruiseControl.NET) for it seems like the hundredth time, and out of the box I get a weird error from the Dashboard.&nbsp; CC.NET has always been a smooth install and configuration process for me, so I was a little taken aback when I got the following error when trying to look at a build report:

<pre>The system cannot find the file specified.</pre>

That&#8217;s all I see in the HTML, nothing else.&nbsp; I&nbsp;double-checked the&nbsp;Virtual Directory settings,&nbsp;and it matches what CC.NET documentation recommends.&nbsp;&nbsp;The build log the page is pointing at definitely exists.&nbsp; I know it&#8217;s something small (it always is).&nbsp; Has anyone seen this error in the CC.NET Dashboard build report page before?&nbsp;