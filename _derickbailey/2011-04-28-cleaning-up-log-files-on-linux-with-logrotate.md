---
id: 273
title: Cleaning Up Log Files On Linux, With Logrotate
date: 2011-04-28T06:41:51+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=273
dsq_thread_id:
  - "290455611"
categories:
  - Linux
  - Logs
  - Philosophy of Software
---
In [my previous post](http://lostechies.com/derickbailey/2011/04/27/the-whenever-gem-making-cron-easy/), I talked about the need to run a command on a schedule with cron. I also mentioned cron creating a bunch of email and how to redirect the output to log files with the whenever gem. After getting everything set up and running, sending data to the correct log files, I realized the need to keep my log files from filling up my drive space. A quick [question on twitter led me to the &#8220;logrotate&#8221; system in linux](https://twitter.com/#!/bphogan/status/62966908881862656). This little tool will rotate, compress, and clean out your log files based on many different configuration options.

 

### A Bit Of Philosophy, First

Before I get into logrotate, though, I thought it would be good to mention that I&#8217;ve been reading [The Art Of Unix Programming](http://www.amazon.com/Art-UNIX-Programming-ebook/dp/B003U2T5BA/) recently (thanks to [Dru Sellers for the recommendation](https://twitter.com/#!/drusellers/status/60368374101839873)). It&#8217;s a great book, even in the first few chapters that I&#8217;ve read so far. One of the philosophies or principles that it directly mentions is how to correct log what your application is doing. In a list of basic philosophies, it states:

> 11. Rule of Silence: When a program has nothing surprising to say, it should say nothing.
> 
> 12. Rule of Repair: When you must fail, fail noisily and as soon as possible.

The two rules, applied to logging, helped me realize that I was doing some bad things with the app that was being called by cron. In fact, the majority of the reason that I needed to look into logrotate is because I was breaking rule #11. My little command line app was logging a bunch of data to STDOUT, every time it ran. This was filling up my log files quickly, making me nervous about drive space, etc, and causing me to need a tool like logrotate.

With these principles in mind, though, I changed how my app works. Instead of always logging a bunch of information about what was happening, I set it up to not log anything, by default. I then added a \`&#8211;verbose/-v\` option to the tool which would log everything. I needed the detail when configuring my environment, to make sure everything was processing correctly. However, once it was all set up, I did not actually need any of the log data except in the case of errors and crashes.

Now that I have my app logging correctly &#8211; log nothing normally, log everything in verbose mode, log any errors or crashes &#8211; I could move on to logrotate and set a more reasonable schedule for rotation.

 

### Configuring A Simple Logrotate

There&#8217;s a default logrotate configuration file that holds several system level log files. However, you should avoid touching this file. Instead, you should create a file in \`/etc/logrotate.d/\` named after your app. For example, if your app is named &#8220;foobar&#8221;, you would create a file called \`/etc/logrotate.d/foobar\`.

In this file, you need to specify the log file or files, and the options for how to rotate them. If I wanted to rotate my /var/logs/foobar.log file once a day and keep a maximum of 10 days worth of files, I could set up my logrotate configuration like this:

<pre>/var/logs/foobar.log {<br />  daily<br />  rotate 10<br />} </pre>

 

Once you have your logrotate configuration file in place, you&#8217;re done. There is no need to restart a logrotate daemon, because there isn&#8217;t one. It turns out logrotate runs as a daily cron job.

 

### Good Examples And Documentation

There are a lot of available options for rotating the log, too. You can compress the logs, handle a log file not existing or being empty, run some pre or post rotation scripts, etc. It&#8217;s quite a powerful little tool and fairly easy to understand the options, too. There are plenty of good tutorials for logrotate on the interwebs, and the man pages for logrotate will explain the vast array of options for you. I read through [this tutorial](http://linuxers.org/howto/howto-use-logrotate-manage-log-files) and it was enough to get me up and running pretty quickly.

 

 