---
wordpress_id: 334
title: 'Don&#8217;t Build A Security System Until There Is Something To Secure'
date: 2011-05-17T07:00:54+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=334
dsq_thread_id:
  - "306014011"
categories:
  - AntiPatterns
  - Bootstrap
  - Goals
  - Risk Management
  - Security
---
<del>I know a lot of people give credit to the idea of &#8220;<a href="http://lostechies.com/chadmyers/2008/03/16/time-to-login-screen-and-the-absolute-basic-requirements-for-good-software/">time to login</a>&#8220;. Personally, I don&#8217;t think that&#8217;s the right way to look at starting an app.</del> (**Note:** As Joshua Flanagan pointed out in the comments below, I completely mis-represented the post I linked to. Sorry about that. The rest of this post is still valid, though.)

Let&#8217;s say you are hired to build a time-punch machine, for clocking in and out of work. Do you immediately go and build a secure room with a buzz-in door and hire an armed guard to make sure only actual employees can get to the time-punch machine? Or do you build the time-punch machine and once it&#8217;s ready, figure out how the company wants to secure it? Chances are, it&#8217;s enough to just have a card wall where people keep their cards. You grab your card and punch-in or punch-out. You don&#8217;t grab other&#8217;s cards. It&#8217;s the honor system and it works. (yes, that was an extreme and probably ridiculous example, but it gets the point across)

Back to software, now&#8230; If you&#8217;re hired to build a time-tracking software application, why do you want to go off and build a security mechanism first? If the time-punch machine can use the honor system, why can&#8217;t the first working version of the time tracking app? Maybe the first version can just deliver a screen that let&#8217;s people enter time and write their name in as one of the fields.

### It&#8217;s About Value, Risk, and Validation

When a client asks you for the time tracking app, their goal is to track time. Yes, they also want to make sure people are tracking their own time and not messing things up. Eventually a security mechanism will be needed as it helps to solve some of these potential problems. But delivering a working version of the time tracking page(s) first gives you much faster feedback on the direction of the app, with something that is actually valuable to the customer &#8211; for more valuable than just a login screen.

There is also a lot of risk in building a security system first. It&#8217;s very easy to over or under engineer a security system and find out that you built a secure room with armed guard when all you needed was an &#8220;on your honor&#8221; sign next to the card wall. I&#8217;ve often spent weeks or months building a full security system with role management and permissions that are stored in a database, etc, just to find out the client really needed something simple. I&#8217;ve also found myself in the opposite corner, building something simple and then the client coming back and saying that they need something much larger. It&#8217;s difficult to know with any certainty what kind of security needs a system will have, until there are things that actually need to be secured. Once those exist, though, it&#8217;s easier to judge how they need to be secured and how access to them needs to be granted.

As someone who has been a client, and now someone that is in the business of making clients happy, I can tell you that I want to see functionality first. It&#8217;s hard to get validation of what your building when you aren&#8217;t building the thing that gets you to your end goal.  So, don&#8217;t build a security system until there is something to secure.