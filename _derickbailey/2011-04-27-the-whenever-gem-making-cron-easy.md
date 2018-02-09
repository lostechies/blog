---
wordpress_id: 271
title: 'The Whenever Gem: Making Cron Easy'
date: 2011-04-27T12:42:31+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=271
dsq_thread_id:
  - "289889628"
categories:
  - Command Line
  - DSL
  - Linux
  - Ruby
---
I recently had to learn how to use Cron to set up a scheduled task on our rails server. In spite of the ubiquity of cron, I found the documentation and even the &#8220;how to&#8221; tutorials to be horrible at best. Fortunately, several people pointed me to a nice little ruby gem that takes the pain out of configuring cron jobs: [the whenever gem](https://github.com/javan/whenever).

 

### The Whenever File

Whenever was built to work with rails apps that need to schedule something, so it uses a few rails folder conventions. By default, it looks for a file called \`config/schedule.rb\` when you run the \`whenever\` command line tool. However, you can specify any arbitrary file you want by passing the \`-f filename\` parameter to the command line.

In my use of whenever, i started out with a custom file name. In the end, though, I switched to the default \`config/schedule.rb\` because it made the tool easier to work with and allowed me to split up my cron job configuration into different environments, similar to a rails app.

 

### The Whenever DSL

Whenever uses a simple DSL to create cron jobs for you, and can update your crontab file as well. The DSL is fairly simple to work with and understand. For example, if I need to run a job every hour, I can write this:

<pre>every 1.hour do<br />  command "./my_executable --with-some-param"<br />end</pre>

 

When you run the \`whenever\` executable against this, it will show you the correct cron job syntax. Even better, though, if you run \`whenever -w\` against this file, it will write the correct cron job syntax to your crontab file. If you want to remove the job, just run \`whenever -c\` and it will clear out all of the generated tasks for that file.

 

### Output To Log Files

Another thing I learned about cron is that by default, it will send an email for everything that is logged (re: output to STDOUT and STDERROR), which typically ends up in /var/mail/account_name. I don&#8217;t like this &#8211; I want real log files. So, I set up a log file in \`/var/logs/\` with the right permissions and then added the output configuration i needed to the top of my whenever file.

<pre>set :output, { :standard =&gt; "/var/logs/my_app.log", :error =&gt; "/var/logs/my_app.errors.log" }</pre>

 

When you run whenever against the file, now, it will append > syntax to pipe the output to the log files I specified.

 

### A Lot More Than Just This

There is a lot more to whenever than just this. There are several built in command types, for example, including a rake command and a ruby script runner. I&#8217;ve only shown the &#8216;command&#8217; command in this example. For more info on what it can do, check out the documentation in the readme and wiki at the github project page.

I&#8217;m also using whenever to deploy cron jobs to my linux server, to run some ruby (thor) scripts. I&#8217;ll talk about this another post, though, as it&#8217;s a fairly involved subject of it&#8217;s own.