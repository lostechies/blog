---
wordpress_id: 124
title: More on Scrummerfall
date: 2008-01-09T21:05:54+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/01/09/more-on-scrummerfall.aspx
dsq_thread_id:
  - "264827499"
categories:
  - Agile
redirect_from: "/blogs/jimmy_bogard/archive/2008/01/09/more-on-scrummerfall.aspx/"
---
A couple of comments have led me to think that I didn&#8217;t explain what it is.&nbsp; Let&#8217;s review waterfall phases:

  * Requirements specifications
  * Design
  * Implementation
  * Integration
  * Testing
  * Deployment

Each of these has a gated exit, such that to exit one phase, you need to meet certain criteria.&nbsp; For example, to leave &#8220;Design&#8221; phase, you have to have your detailed design with estimates signed off by developers, analysts, and the customer.&nbsp; You cannot enter Implementation until you have finished design.

Scrummerfall&nbsp;still uses a phase-based methodology, but uses iterations for the &#8220;Design&#8221; and &#8220;Implementation&#8221; phases.&nbsp; Testing is done as unit tests during development, but&nbsp;QA is not involved until the actual Testing phase&nbsp;later.

Scrummerfall is easier to introduce in companies heavily invested in waterfall, as it&#8217;s only one&nbsp;group (developers) that are actually changing how they work.

Scrummerfall also makes two assumptions that become more invalid and costly the larger the projects are:

  * Requirements don&#8217;t change after&nbsp;Design
  * Integration, Testing, and Deployment are best done at the end

Now just because&nbsp;Agile doesn&#8217;t&nbsp;have gated phases for these activities doesn&#8217;t mean they don&#8217;t happen.&nbsp; Design and requirements gathering still happen, as do release planning, testing, deployment, etc.&nbsp; The difference is that all of these activities happen **each iteration**.

This is very tough in fixed-bid projects, which assume that requirements, cost, and deadline don&#8217;t change.&nbsp; There are alternatives to fixed-bid projects, which I won&#8217;t cover here, that provide the best of both fixed-bid and time-and-materials projects.

With Agile, you don&#8217;t do a &#8220;Testing&#8221; iteration and a &#8220;Design&#8221; iteration.&nbsp; That&#8217;s&nbsp;lipstick on&nbsp;a pig, you&#8217;re still doing waterfall.&nbsp; 

So how do you avoid Scrummerfall if you&#8217;re trying to introduce Agile into your organization?&nbsp; The trick is to sell the right ideas to **all** of the folks involved.&nbsp; If it&#8217;s only developers leading Agile adoption, chances are you won&#8217;t get too far past TDD, continuous integration, pair programming, and the rest of the engineering-specific XP practices.

Get buy-in from an analyst, a PM, a tester, your customer, and your developers.&nbsp; You won&#8217;t have to convert _all_ of the analysts and PMs, just the ones working on your project.&nbsp; Remember, each person needs to see tangible business value from the changes you are proposing.&nbsp; I tend to target management for Scrum and developers on XP, because although it&#8217;s easy to get everyone to agree on values and principles, the concrete practices vary widely between the different roles.