---
id: 4321
title: A Very Poor Object Model Is Really No Object Model At All
date: 2008-05-05T01:59:02+00:00
author: Evan Hoff
layout: post
guid: /blogs/evan_hoff/archive/2008/05/04/a-very-poor-object-model-is-really-no-object-model-at-all.aspx
categories:
  - Uncategorized
---
First let me say that I&#8217;ve met <a href="http://keithelder.net/blog/" target="_blank">Keith</a> personally, and he&#8217;s a really cool guy.&nbsp; Cool enough in fact, that he&#8217;s on my RSS subscription list. I&#8217;d consider him a friend.&nbsp; 🙂

This is my response to his recent post, <a href="http://keithelder.net/blog/archive/2008/05/02/How-To-Not-Screw-Up-Your-Application-Object-Model.aspx" target="_blank">How To Not Screw Up Your Application Object Model</a>.&nbsp; I&#8217;ll also point to <a href="http://www.rgoarchitects.com/nblog/2008/05/04/OOPsAnExampleOfMisusingTheTermOOP.aspx" target="_blank">Arnon&#8217;s reaction</a>.

Exhibit A:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="461" src="http://www.lostechies.com/blogs/evan_hoff/WindowsLiveWriter/AVeryPoorObjectModelIsReallyNoObjectMode_13513/objectmodel_thumb[1].png" width="640" border="0" />](http://www.lostechies.com/blogs/evan_hoff/WindowsLiveWriter/AVeryPoorObjectModelIsReallyNoObjectMode_13513/objectmodel[3].png) 

**This is a very, very poor object model.**&nbsp; It&#8217;s a very poor object model even if it perfectly represents the business requirements. I&#8217;m going to nickname this the &#8220;college freshman&#8221; object model, and we all know how useful college freshmen are in the real world (and just how much they have to learn before they become useful).&nbsp; In short, never do this&#8211;again, even if it perfectly represents your business problem (which it won&#8217;t).

I&#8217;ll also repeat what Arnon said.&nbsp; In a nutshell, **don&#8217;t use a bulldozer where a simple shovel will do**.&nbsp; Building an app for a vet is a good candidate for CRUD and Microsoft Access.&nbsp; Don&#8217;t overcomplicate your solution.

Also, **if you are developing outside the guidance and expertise of the customer, you greatly increase your chances of failure and waste.&nbsp; Don&#8217;t do that.&nbsp; It&#8217;s irresponsible and foolish.**

I&#8217;d also like to point out that this object model is driven by the C++ object model thinking&nbsp;of yesterday.&nbsp; We&#8217;ve learned a lot since the 70&#8217;s and 80&#8217;s, and that includes how to do objects.

I&#8217;ll point out two very important facts that are rather obvious:

  * We don&#8217;t have multiple inheritance in C# or VB.NET.&nbsp; That greatly affects how we do OOP.
  * Inheritance is a very fragile.&nbsp; 99% of the time it&#8217;s the wrong tool to use (as this diagram elegantly illustrates)

Luckily, we&#8217;ve learned a lot in the past 10 years and evolved our design techniques since then.

Inheritance is the old stuff.&nbsp; Composition is the new stuff.&nbsp; We&#8217;ve learned about the <a href="http://en.wikipedia.org/wiki/Fragile_base_class" target="_blank">fragile base class</a> problem and moved on.&nbsp; A solution using composition (instead of inheritance) yields way more flexibility and is much more resilient to change (when used properly).&nbsp; Where inheritance represents the relationship with the most coupling between two classes, composition allows us to freely decouple two (or more) classes.

Is bad OOP really bad OOP or is it just not OOP at all?

**If&nbsp;you&#8217;ve implemented a deep type hierarchy in your .NET app while trying to build an &#8220;object model&#8221;, you&#8217;ve sorely misunderstood how to apply OOP in .NET.**

In conclusion, I&#8217;d like to challenge Keith to write a new post on the following:

> The reason is because we have been beat to death with OOP principles.

I&#8217;d be curious as to what principles you are referring to.&nbsp;&nbsp;I get the feeling that the OOP principles you are referring to are completely different from the ones I follow.&nbsp; I&#8217;d love to carry this discussion further.