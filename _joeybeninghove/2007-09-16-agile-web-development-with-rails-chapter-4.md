---
wordpress_id: 34
title: 'Agile Web Development with Rails &#8211; Chapter 4'
date: 2007-09-16T12:36:49+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/09/16/agile-web-development-with-rails-chapter-4.aspx
categories:
  - Books
  - Rails
  - Reviews
  - Ruby
---
</p> 

Cool!&nbsp; Now I get to start building stuff.

#### Chapter 4&nbsp;

I just pop open my <span style="background: #000;color: #00ff00">kermit green</span> command line window and type &#8220;rails demo&#8221;.&nbsp; And BAM!&nbsp; We&#8217;ve got&nbsp;ourselves an&nbsp;application!&nbsp; Ok, so it might not do&nbsp;much yet.&nbsp; But it&#8217;s given me a nice &#8220;filing cabinet&#8221; to keep everything organized.&nbsp; Everything from the controllers source code, views, database scripts, test fixtures, configuration files, log files, scripts, images, etc.&nbsp; All in a nicely organized tree.&nbsp; Very nice.

Now I just fire up a&nbsp;the built-in web server using &#8220;ruby scriptserver&#8221;, open up browser and there we go.&nbsp; We have a full working application.&nbsp; That entire process, from generating the application, starting the server and browsing to the application literally took about&nbsp;5 seconds.&nbsp; 

At this point it takes me through the obligatory Hello World implementation.&nbsp; I can just use the rails generator to create a controller named &#8220;Say&#8221; with a method named &#8220;Hello&#8221;, then create a quick rhtml view named &#8220;hello.rhtml&#8221; in the appropriate appviewssay directory and that&#8217;s it.&nbsp; What&#8217;s really great about all of this style of development is that I never have to restart the internal web server because in development mode, automatically detects file changes and reloads them instantly.&nbsp; Try that in C#.

Then it just takes me through adding some controller code and I get to discover some more of the elegance of the Ruby language.&nbsp; Stuff like &#8220;3.times&#8221; and &#8220;1.hour.from_now&#8221;.&nbsp; How cool is that!&nbsp; Some basic ERb (Embedded Ruby) commands are then shown for linking to other actions.&nbsp; I&#8217;m pretty familiar with this kind of thing in MonoRail already.&nbsp; The way you can use hashes in Ruby is very nice, and is very similar to how Ayende implemented then in Brail.&nbsp; 

Well that&#8217;s about it for now.&nbsp; This was just a demo app.&nbsp; Looks like next I get to start building a &#8220;real&#8221; application.&nbsp; Woohoo!&nbsp; 🙂