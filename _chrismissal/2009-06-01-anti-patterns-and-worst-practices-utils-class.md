---
wordpress_id: 3356
title: Anti-Patterns and Worst Practices – Utils Class
date: 2009-06-01T12:36:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/06/01/anti-patterns-and-worst-practices-utils-class.aspx
dsq_thread_id:
  - "262156862"
categories:
  - Best Practices
  - Design Principles
  - DRY
redirect_from: "/blogs/chrismissal/archive/2009/06/01/anti-patterns-and-worst-practices-utils-class.aspx/"
---
[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;margin: 0px 0px 0px 10px;border-right-width: 0px" alt="tools" src="//lostechies.com/chrismissal/files/2011/03/tools_thumb_53296EBA.jpg" width="244" align="right" border="0" height="184" />](//lostechies.com/chrismissal/files/2011/03/tools_486986B4.jpg) If you ever start typing &ldquo;Utils&rdquo; or &ldquo;Utility&rdquo; stop and think a bit; if you need some help, ask a fellow developer a question of what this code actually does. This anti-pattern is caused either by lack of domain knowledge, or laziness, sometimes both. The problem isn&rsquo;t with the functions that these Utils are performing, but what they&rsquo;re called and how they&rsquo;re grouped together. Most often, I see the following types of functions inside a Utils class.

{% gist 2917597 file=Utils.cs %}

[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)

There&rsquo;s really no reason that this type of functionality belongs in a Utils class (usually as a static method). If you&rsquo;re logging something, why not create a Logger class; it is what it is. Something as common as logging has been solved by others in more robust ways than opening a file and writing some text. Better yet, use a solution that already exists and save yourself the time to implement it on your own:

  * log4net (.Net) 
  * log4r (Ruby) 
  * log4j (Java) 

Maybe you have some more specific functionality for which you can&rsquo;t seem to find a place. You&rsquo;re taking in some data and spitting out something a bit different. Rather than coding it right inline the objects that need it, you decided to place it somewhere it can be re-used (Good! Following DRY: Don&rsquo;t Repeat Yourself), inside the Utils class.

{% gist 2917597 file=MoreUtils.cs %}

[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)

BAD! You got the DRY part right, but you can do better! The first line of this post asks you to ask yourself (or somebody else) what your code is doing. Let&rsquo;s ask ourselves what this code is doing. It is taking in a day of the week and the current time and is spitting out a shipping delivery message. I&rsquo;m not always great with naming, but I don&rsquo;t see anything wrong with creating a class named ShippingMessageGenerator. At least when I come across a function that exists in a ShippingMessageGenerator class I have more of an idea of what it is all about than if I saw the same function in a Utils class.

### Call it What it is

We recently needed to modify some code that sends text requests (a RequestExecutor class) to a third-party system. There were characters that needed to be removed from the requests because they are delimiters in the text. Not a hard task, but tackling it at the point of concern would probably cause a lot of repetition in our code for cleaning up this data. We could put it in a static RequestUtils class so the code is in one place. This is better, but still doesn&rsquo;t give the full clarity of what is going on.

One of our guys was working on this bug and implemented a RequestSanitizer class that does exactly what it sounds like. Sanitizes or cleans up the request. Our RequestExecutor has a dependency on this class since it only worries about sending clean requests. It doesn&rsquo;t have the job of cleaning them. Why is this good?

  * The code that sanitizes the requests is in one place, and is obvious.
  * The RequestSanitizer class has only one reason to change.

### Filling that Gap

I&rsquo;m not trying to tell anybody that they shouldn&rsquo;t use a Utils class, but rather that they should know that there&rsquo;s probably a better way. Since the problem I see with Utility classes is that they&rsquo;re usually just a collection of a whole bunch of stuff that doesn&rsquo;t really belong together, they probably exist for common reasons. There&rsquo;s a lot of functionality that people have to write that seems fitting in a Utility class. However, if you&rsquo;re writing this code, somebody else has probably already written it. You can more than likely take advantage of some open source libraries to fulfill this need.

  * If you have some methods that take in one object to create another, why not consider [Jimmy Bogard&rsquo;s](https://lostechies.com/jimmybogard/) [AutoMapper](http://www.codeplex.com/AutoMapper).
  * Any of the log4__ libraries mentioned prior.
  * If you&rsquo;re using ASP.NET MVC, there&rsquo;s a lot of value in using [MvcContrib](http://www.codeplex.com/MVCContrib).

Remember, ask yourself: _What does this code do?_

[See more [Anti-Patterns and Worst Practices](https://lostechies.com/chrismissal/2009/05/26/anti-patterns-and-worst-practices-you-re-doing-it-wrong/)]