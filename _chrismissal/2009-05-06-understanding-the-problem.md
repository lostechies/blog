---
wordpress_id: 3351
title: Understanding the Problem
date: 2009-05-06T22:56:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/05/06/understanding-the-problem.aspx
dsq_thread_id:
  - "428146872"
categories:
  - Project Management
redirect_from: "/blogs/chrismissal/archive/2009/05/06/understanding-the-problem.aspx/"
---
<div class="wlWriterEditableSmartContent" style="padding-right: 0px;padding-left: 0px;float: right;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  <a href="//lostechies.com/chrismissal/files/2011/03/logicHomework28x6_00058DE0.jpg" rel="thumbnail"><img src="//lostechies.com/chrismissal/files/2011/03/logicHomework2_59C855E9.png" width="335" border="0" height="260" /></a>
</div>

In my <a href="/blogs/chrismissal/archive/2009/05/06/unit-testing-where-s-the-dollar.aspx" target="_blank">previous post</a> I supplied a riddle entitled &ldquo;Where&rsquo;s the Dollar?&rdquo; and asked for the problem with its logic. This may seem ridiculous but these things come up all the time in software development when translating what our customers/clients want into sound logic and precise calculations.

One thing I&rsquo;ve been trying to do better is ask the &ldquo;<a href="http://en.wikipedia.org/wiki/5_Whys" target="_blank">five</a>&nbsp;<a href="http://www.toyota.co.jp/en/vision/traditions/mar_apr_06.html" target="_blank">whys</a>&rdquo; to really get to the root of the problem. I&rsquo;ve found that asking these questions and providing solutions can open up more opportunities than previously existed. While working on an ecommerce site, we were supposed to restrict a payment type when shipping to certain locations. Upon digging deeper, I found that if the payment type was restricted because the shipping amount needed to be calculated &ldquo;on the floor&rdquo; (the amount is determined by the weight, size and location of the shipment) as most of the shipments to these locations were, but not all. Since not all shipments to these locations were calculated later by rule, there were some opportunities to provide an additional payment for these circumstances. By truly understanding the problem and not just what is projected, we were able to provide more value to online shoppers in this case.

When looking back on the <a href="/blogs/chrismissal/archive/2009/05/06/unit-testing-where-s-the-dollar.aspx" target="_blank">problem of the missing dollar</a> you&rsquo;ll have figured out by now that the incorrect calculation is based on adding up amounts gained and amounts spent. This becomes more clear when the numbers aren&rsquo;t off by only one dollar. Now that I have a better understanding of the situation, I would rephrase it like so:

> &hellip; Here&rsquo;s the fun.&nbsp; You have three men who paid 10 dollars a piece and received one dollar back&hellip; this means they each paid nine dollars.&nbsp; The bellboy kept two dollars for himself.&nbsp; So, one x 3 equals 3 plus the 2 dollars the bellboy kept plus the 25 dollars at the front desk equals 30 dollars &#8212; why did the men pay a total of 27 dollars? Because 25 went to the room and the bellboy stole the other two dollars. Add that to the 3 they got back, and voila, you have all $30 accounted for.

There&rsquo;s no substitute for domain experts, but domain experts aren&rsquo;t much help for improving the process if they can&rsquo;t share their knowledge and ability to solve problems within the process. If you&rsquo;re a subject matter expert or you&rsquo;re dealing with one, be sure you/they share how you/they came to the solution with others. This not only provides the visibility of how the problem was solved, but also gets others thinking in the same manner. Describing in detail the problem, the causes and the resolution not only provides a better understanding for everyone, but can also provide confidence in those that may need it.