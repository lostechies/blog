---
wordpress_id: 21
title: 'ReSharper 3.0 &#8211; Like a kid in a candy store again'
date: 2007-06-28T11:40:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/06/28/resharper-3-0-like-a-kid-in-a-candy-store-again.aspx
categories:
  - Productivity
  - Resharper
  - usability
redirect_from: "/blogs/joeydotnet/archive/2007/06/28/resharper-3-0-like-a-kid-in-a-candy-store-again.aspx/"
---
When I first started using [ReSharper](http://www.jetbrains.com/resharper/) a couple years ago and with each subsequent release, I&#8217;ve had a lot of fun just exploring all of those &#8220;little&#8221; features that sometimes go unnoticed, but yet, can greatly increase your productivity in Visual Studio.&nbsp; With the latest 3.0 release, I&#8217;m in that mode again.&nbsp; I&#8217;m finding many more cool &#8220;little&#8221; features that just make my life easier.&nbsp; For instance, here&#8217;s just one example&#8230;

#### Basic namespace/folder maintenance

Being a bit picky about project/code organization, I&#8217;m a stickler for good folder structures and keeping the namespaces in sync.&nbsp; In the past when I&#8217;ve needed to move a class to a new folder/namespace I&#8217;d go through the following steps:

  * F6 to show ReSharper&#8217;s very nice Rename dialog 
  * Type in the new namespace for the class 
  * Create the folder in the solution explorer 
  * Cut and paste the file from the solution explorer into the new folder

Very straightforward and fast.&nbsp; This is one of those organizational steps that you may think cannot be improved upon.&nbsp; But just leave it to JetBrains&#8230;

Now, thanks to ReSharper 3.0, all I have to do is this:

  * Create the folder in the solution explorer 
  * Cut and paste the file from the solution explorer into the new folder 
  * F12 to the nice new warning that ReSharper gives me&#8230;

> [<img src="http://static.flickr.com/1142/648818009_539365eded.jpg" alt="resharper30_namespace_filepath_warning" border="0" />](http://www.flickr.com/photos/74595743@N00/648818009/ "resharper30_namespace_filepath_warning")

  * Alt-Enter to have ReSharper automatically fix it for me

> [<img src="http://static.flickr.com/1223/648818081_e3957db4fb.jpg" alt="resharper30_namespace_filepath_correcting" border="0" />](http://www.flickr.com/photos/74595743@N00/648818081/ "resharper30_namespace_filepath_correcting")

The key thing about this is that I don&#8217;t have to actually type the namespace anymore.&nbsp; May seem small, but many of these &#8220;little&#8221; features combined with each other can make you much more productive in your development efforts.

Off to discover some more candy&#8230;&nbsp; 🙂