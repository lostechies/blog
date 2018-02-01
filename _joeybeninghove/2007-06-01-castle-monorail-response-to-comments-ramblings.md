---
id: 14
title: 'Castle MonoRail &#8211; Response To Comments/Ramblings'
date: 2007-06-01T12:58:59+00:00
author: Joey Beninghove
layout: post
guid: /blogs/joeydotnet/archive/2007/06/01/castle-monorail-response-to-comments-ramblings.aspx
categories:
  - Castle
  - MonoRail
  - Web
---
[Billy](http://devlicio.us/blogs/billy_mccafferty/default.aspx) has&nbsp;[decided to move forward with using MonoRail](http://devlicio.us/blogs/billy_mccafferty/archive/2007/05/29/concise-introduction-to-castle-monorail.aspx) on one of his current projects.&nbsp; As I was writing the comment on his post to respond to some other folks&#8217; comments, I decided it was getting too long and perhaps I should must make it a post on its own. 

Billy stated that his main concern for moving to MonoRail is losing support for 3rd party control suites like telerik.&nbsp; To which a commenter said: 

> &#8220;You don&#8217;t have to abandon third-party controls like telerik &#8211; just use the WebFormsViewEngine.&#8221; 

One of the issues with using the WebFormsViewEngine, AFAIK, is that you lose the true MVC-ness of what MonoRail is trying to accomplish for you. The whole idea behind MVC, is that the Controller is the first point of contact for a request, not the View. But when using web forms, you really can&#8217;t do that in a nice way&nbsp;(as [Ayende points out](http://www.ayende.com/Blog/archive/2007/06/01/MVC-in-WebForms-The-impossible-fight-to-get-rid-of.aspx)), since the web form (i.e. ASPX) has to be the first point of contact. Then the View has to implement a special IControllerAware interface and delegate requests back to the controller. And then&#8230; we&#8217;re back to MVP again.&nbsp; 

Of course, MVP is a good pattern in its own right.&nbsp; I&#8217;ve successfully used it for years of, dare I say, &#8220;classic&#8221; web forms development in ASP.NET.&nbsp; But I find the separation and flexibility&nbsp;of a true MVC framework like MonoRail, solves the problem in a much simpler way.&nbsp; Sure you don&#8217;t have the&nbsp;bloat, ah hem, \*features\* like page lifecycles and viewstate.&nbsp; But I still think not having to worry about that kind of stuff is a good thing. 

I&#8217;ve now used Castle MonoRail in 2 projects and the&nbsp;bottom line for me&nbsp;is that frameworks like&nbsp;MonoRail (and RoR, even though I&#8217;ve yet to have had&nbsp;the pleasure of using it) are making web development fun \*and\* productive again.&nbsp; I haven&#8217;t really missed the &#8220;server controls&#8221; aspect of web forms much at all.&nbsp; 

In fact, MonoRail better&nbsp;allows me to develop my presentation/UI layer in the same fashion as I already develop everything else underneath.&nbsp; By using an incremental approach, I can build what I need in a simple fashion and&nbsp;**harvest** reusable components as necessary.&nbsp; 

I&#8217;ve experienced the pain of having to utilize 3rd party ASP.NET controls and it&#8217;s definitely not all chocolates and roses.&nbsp; Often, in the time you can spend&nbsp;hunting down some nasty bug/behavior in a 3rd party control (that probably does more than you need in the first place) you could&#8217;ve leveraged something simpler, even your own solution if needed.&nbsp; 

Now I&#8217;m most definitely not advocating [NIH](http://en.wikipedia.org/wiki/Not_Invented_Here), but if you can be more productive and deliver more early business value by creating your own solution or extending an existing framework/component, then I would just consider that to be&nbsp;good judgement. 

Anyway, I could probably go on and on, but guess that&#8217;s enough for now. 

Oh, almost forgot the <you MUST go download [ReSharper](http://www.jetbrains.com/resharper/download/index.html) right now, even the [3.0 Beta](http://www.jetbrains.com/resharper/beta.html)> statement&#8230;&nbsp; 😛