---
id: 3360
title: We Remembered Not to Dive Too Deep Too Soon
date: 2009-07-23T02:45:00+00:00
author: Chris Missal
layout: post
guid: /blogs/chrismissal/archive/2009/07/22/we-remembered-not-to-dive-too-deep-too-soon.aspx
dsq_thread_id:
  - "272650202"
categories:
  - development
  - Project Management
---
While reading &#8220;[Remember to not dive too deep too soon](http://devlicio.us/blogs/derik_whittaker/archive/2009/07/22/remember-to-not-dive-too-deep-too-soon.aspx)&#8221; by [Derik Whittaker](http://devlicio.us/blogs/derik_whittaker/default.aspx), I was reminded of something that happened at work today. We were going over a couple new stories in our backlog and needed to assign points to them.

Before adopting Scrum a couple of months ago (versus the Slam Dunk Model), we would have had a task that required somebody on our team to:

  1. Install a 3rd party component that logs what people are searching on (and not finding).
  2. Configure the log server so that the fields we&#8217;re interested in are correctly parsed out.
  3. Upload this data into a SQL Server database so that reports can be run against it.

<img style="float: right;margin-left: 10px;margin-right: 10px" src="//lostechies.com/chrismissal/files/2011/03/waterfall_quebec.jpg" />

This isn&#8217;t an awful task by any means, but there are a lot of unknowns
  
in this list. The first being the one that we&#8217;re stuck on now, it&#8217;s
  
installed, but not creating the files correctly. It will likely take
  
one of us to open a support ticket with our vendor and wait on them to
  
help us out debugging the issue. We can&#8217;t estimate this very
  
accurately, not having dealt with their support team very often. This
  
would have been a tough task to estimate and we probably would have
  
guessed too little in the beginning.

Now that we have things like estimation meetings, a backlog and points
  
for our estimates, we&#8217;re not only getting things done on time, but
  
we&#8217;re finding better ways to do them. We&#8217;re not so often stuck with our preconceived notions of what we think it will take to get it done.

I didn&#8217;t intend for this to be a discussion about Scrum, but I wanted to provide another reason for Derik&#8217;s post that &#8220;diving too deep&#8221; into the details of a feature/task is bad. We used to be, and sometimes still catch ourselves, talking about all the low-level details of the code and what kind of tools we&#8217;re going to use. This task of logging search terms that are not found was worded very well as a story that provides value. With the story, we discussed other alternatives that would provide the value that the story was looking for; it wanted to provide only not found search terms. This didn&#8217;t mention anything about opening support tickets, writing an application to parse a file or the like. We decided we could probably do this fairly easily by simply creating another [log4net](http://logging.apache.org/log4net/) appender. Boom! Done.

I think the discussions are good to have, but if you&#8217;re getting too detailed like Derik mentions, who cares what the schema of the table is as long as it is providing the client with the value for which they&#8217;re asking. Even though it&#8217;s fun to talk about, skip the low level stuff.