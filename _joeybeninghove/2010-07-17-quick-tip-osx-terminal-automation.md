---
wordpress_id: 75
title: OSX Terminal Automation
date: 2010-07-17T01:42:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2010/07/16/quick-tip-osx-terminal-automation.aspx
categories:
  - automation
  - OSX
  - Rails
  - Ruby
  - terminal
redirect_from: "/blogs/joeydotnet/archive/2010/07/16/quick-tip-osx-terminal-automation.aspx/"
---
## My OSX Terminal Environment (as of today)

Some of this might be old hat for a lot of you, but maybe this will help at least a few people. &nbsp;I&#8217;m a pretty big automation addict. &nbsp;During my Ruby on Rails work, I find myself opening up the same set of terminal windows, positioned in the same way, running the same commands&#8230;all the time. &nbsp;I typically keep at least 3 OSX terminal windows open (some with multiple tabs). &nbsp;But when I sit down to start working with nothing open yet, I usually keep 2 terminal windows tiled to the left, 1 on top of another. &nbsp;

The top one I usually use for most filesystem and git operations. &nbsp;I also use this one to open other tabs for running things like **rails console** or a mongodb console if necessary.

The bottom one I usually have [rstakeout](http://github.com/EdvardM/rstakeout "rstakeout")&nbsp;running in the background to run my specs or cucumber scenarios automatically. &nbsp;

Then I keep a third terminal window open, tiled to the right at full height running **rails server** in one tab and **compass watch** in another tab.

## Automating It

First step is to set up specific terminal settings for each window/tab based on how you want them to behave when they start. &nbsp;Here is an example of a basic terminal that changes to the directory I want when started.

<div class="thumbnail">
  <a href="http://skitch.com/joeybeninghove/dc63t/vk-terminal"><img src="http://img.skitch.com/20100717-gctbsrtgdgnr7trkbj8cnsrsc8.preview.jpg" alt="vk_terminal" /></a><br /><span style="font-family: Lucida Grande, Trebuchet, sans-serif, Helvetica, Arial;font-size: 10px;color: #808080">Uploaded with <a href="http://plasq.com/">plasq</a>&#8216;s <a href="http://skitch.com">Skitch</a>!</span>
</div>

And here is a separate terminal setting for automatically starting Compass when the terminal session is started.

<div class="thumbnail">
  <a href="http://skitch.com/joeybeninghove/dc63u/terminal-compass"><img src="http://img.skitch.com/20100717-tdmp8wg87144u1m2sk13u5qc8b.preview.jpg" alt="terminal_compass" /></a><br /><span style="font-family: Lucida Grande, Trebuchet, sans-serif, Helvetica, Arial;font-size: 10px;color: #808080">Uploaded with <a href="http://plasq.com/">plasq</a>&#8216;s <a href="http://skitch.com">Skitch</a>!</span>
</div>

And here is a another one for autostarting the rails server when the terminal session is started.

<div class="thumbnail">
  <a href="http://skitch.com/joeybeninghove/dc63w/terminal-rails-server"><img src="http://img.skitch.com/20100717-mdrfd9mkcibex98uuii4x4wppd.preview.jpg" alt="terminal_rails_server" /></a><br /><span style="font-family: Lucida Grande, Trebuchet, sans-serif, Helvetica, Arial;font-size: 10px;color: #808080">Uploaded with <a href="http://plasq.com/">plasq</a>&#8216;s <a href="http://skitch.com">Skitch</a>!</span>
</div>

Now, all these can easily be combined into a &#8216;Windows Group&#8217; that can be opened by the OSX Terminal in one shot, opening multiple terminal windows/tabs all at once using separate terminal settings. &nbsp;Just open the terminal windows/tabs and position them how you like them, then just save it as a window group.

<div class="thumbnail">
  <a href="http://skitch.com/joeybeninghove/dc64a/terminal-windows-group"><img alt="terminal_windows_group" src="http://img.skitch.com/20100717-km1acfs75w7ix6epmhqt8ma4u3.preview.jpg" /></a><br /><span style="font-family: Lucida Grande, Trebuchet, sans-serif, Helvetica, Arial;font-size: 10px;color: #808080">Uploaded with <a href="http://plasq.com/">plasq</a>&#8216;s <a href="http://skitch.com">Skitch</a>!</span>
</div>

Here&#8217;s a quick video of a window group in action:</p> 

[My OSX Terminal Environment](http://vimeo.com/13406868) from [Joey Beninghove](http://vimeo.com/user3814096) on [Vimeo](http://vimeo.com).

As you can see, I can get my entire terminal environment up and running with a single command. &nbsp;(Even better when I can use the fabulous [ViKing](http://www.vikingapp.com "ViKing") app by Kevin Colyar to navigate the OSX menus using Vim bindings!)

## Wrap Up

In case you&#8217;re wondering which OSX terminal theme I&#8217;m using, it&#8217;s my own tweaked version of [IR_Black](http://blog.infinitered.com/entries/show/6 "IR_Black") which I really like. &nbsp;Also, if you want to try out my terminal settings directly, I&#8217;ve exported the terminal settings files and the window grouping and pushed them up to my [terminal repo on GitHub](http://github.com/joeybeninghove/terminal "terminal"). &nbsp;Also I&#8217;d LOVE to hear other tips on how you&#8217;re automating your development environments, specifically in OSX!

Happy Automating!