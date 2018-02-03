---
wordpress_id: 43
title: Funny question and response of the day
date: 2007-10-08T19:36:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/10/08/funny-question-and-response-of-the-day.aspx
categories:
  - 'C#'
---
A co-worker of mine sent an email with this question to the whole&nbsp;&#8220;dev&#8221;
  
group:

> &#8220;Does anyone have a random password generator that I can quickly plug into my
  
> application?&#8221;

My response:

> &#8220;Guid.NewGuid().ToString()&#8221;&nbsp; 😛

What&#8217;s even funnier is that my team lead sent the exact same response
  
(Guid).&nbsp; Others replied with &#8220;google &#8216;.net random password generator'&#8221;.&nbsp;
  
LOL.

The correct answer turned out to be:

> System.Web.Security.Membership.GeneratePassword

But of course&nbsp;that&#8217;s not nearly as funny, now is it&#8230;

&nbsp;