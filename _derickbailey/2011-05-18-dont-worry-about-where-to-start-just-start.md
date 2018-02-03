---
wordpress_id: 336
title: 'Don&#8217;t Worry About Where To Start. Just Start.'
date: 2011-05-18T07:04:31+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=336
dsq_thread_id:
  - "306949642"
categories:
  - Analysis and Design
  - AntiPatterns
  - Bootstrap
  - Goals
---
When writing a blog post or an article, the most horrifying thing in the world is the blank page. Where do I start? How do I make sure to capture interest to keep people reading? Should I talk about ??? or ??? and what about ??? &#8230; analysis paralysis, anyone?

The same thing happens in software. Open visual studio, or vim, or whatever editor of your choice. Maybe create a project structure or have rails generate it for you. Then &#8230; CRAP?! WHERE DO I START?! What feature do I write first? (well, we know [what not to start with](http://lostechies.com/derickbailey/2011/05/17/dont-build-a-security-system-until-there-is-something-to-secure/), at least) What test do I write first? How do I know if I&#8217;m starting at the right place and delivering everything that I need, right away?!

I&#8217;ve run into this more times than I can count, on both writing blog posts / articles and writing software.

 

### The Secret Sauce: Start, Realize, Scrap. Repeat.

The secret is not to actually think about where to start. Just start. If you have an idea of what you want the system to do, start writing that idea out in the code. I guarantee that once you actually start writing the code, you&#8217;ll realize where you should have started. Great! That&#8217;s exactly the point! Writing that first few lines of code or that first automated test will expose all of the things that you don&#8217;t have in place. You&#8217;re brain will quickly sort through them and figure out &#8220;oh, i need to have this core piece in place, first. but, i can do without these other things if I just hard code or make assumptions here, for now.&#8221; AWESOME! That&#8217;s exactly the kind of response you want from your brain! Once you&#8217;ve had these realizations, just toss what you started with into the trash and start over. Or if what you started may actually have value, dump it in a code snippet or source control somewhere so you can grab it later. Chances are, though, that what you think may have value will be completely wrong by the time you get to it.

For example, look at writing a time tracking system. The goal is probably to report who is spending what time, where. So, start by spec&#8217;ing out the report (via code of course &#8211; test-first style). You&#8217;ll quickly realize that it&#8217;s hard to report on data you don&#8217;t have. However, starting by looking at the end goal will inform you on what the rest of the system should look like. &#8220;Oh, I need to show X, Y and Z on the report&#8230; I didn&#8217;t realize that. I need to build A, B and C to make sure I can show what they need here&#8221;. From the end-goal, you can work backwards and figure out where to actually start.

Sometimes you&#8217;re not that lucky, though. Sometimes you need to start working before you know what the end goal is. That&#8217;s fine, too. Just start working. The key here is to get feedback as early and often as possible, so that you can begin to get a better idea of what the goal is. You&#8217;re likely going to throw away a lot of what you start with, in this scenario, so be sure to build things as quickly and cheaply as possible. There is a cost to learning by doing, and we want to minimize that cost as much as possible so we can get to doing something of real value.

 

### On Writing

Incidentally, I apply the same thing to writing blog posts and articles. I just start writing with whatever pops into my head, whether or not it&#8217;s a good introduction (and it never is &#8211; even this blog post has gone through two iterations of introduction and was originally part of another blog post). Once I have something down on the blank screen, I realize what I actually need in order to set up the correct context. Then I go back to the top of the page and start to flesh out the context. Eventually, I have a starting point for the post / article, but it&#8217;s never the thing I started with.