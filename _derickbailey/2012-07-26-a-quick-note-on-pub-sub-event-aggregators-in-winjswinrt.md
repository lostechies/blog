---
wordpress_id: 968
title: A Quick Note On Pub-Sub / Event Aggregators In WinJS/WinRT
date: 2012-07-26T21:51:33+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=968
dsq_thread_id:
  - "781562244"
categories:
  - Design Patterns
  - JavaScript
  - WinJS
---
By now you know that I&#8217;m a fan of pub-sub / event aggregators, whether it&#8217;s .[NET / Winforms](http://lostechies.com/derickbailey/2009/12/23/understanding-the-application-controller-through-object-messaging-patterns/) or [Backbone](http://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0CGUQFjAA&url=http%3A%2F%2Flostechies.com%2Fderickbailey%2F2012%2F04%2F03%2Frevisiting-the-backbone-event-aggregator-lessons-learned%2F&ei=eQ4SUILbNOeviAKA14DYBg&usg=AFQjCNHm0a5wDNQB4t0kbNDHbOvJgstaoQ&sig2=DvIEAhIe9BxBm-w3vd7Ixg) or whatever. For the last 3 weeks working on this WinJS / WinRT app with the Microsoft P&P group, I&#8217;ve had this thought that I want to do the same thing in WinJS / WinRT apps. Only I couldn&#8217;t figure out how. [@Bennage](https://twitter.com/bennage) and I had several discussions on this and decided to look in to it later. Well today was &#8220;later&#8221; apparently, and thanks to the Chris Tavares I found these wonderful little nuggets of awesome:

[**WinJS.Application.queueEvent**](http://msdn.microsoft.com/en-us/library/windows/apps/br211886.aspx) &#8211; queue an event to be sent

[**WinJS.Application.addEventListener**](http://msdn.microsoft.com/en-us/library/windows/apps/br229799.aspx) &#8211; handle an event that was sent

{% gist 3186090 1.js %}

Of course this is only an application level event aggregator. If I want to use localized / sub-application / module event aggregators, I need to find another way to make that happen. I [have some leads on this](http://msdn.microsoft.com/en-us/library/windows/apps/br211693.aspx), but haven&#8217;t had a chance to work on them yet. I have hope, though, and this is yet another reason that I really like working on WinJS apps.
