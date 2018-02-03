---
wordpress_id: 66
title: Organizing with Solution Folders
date: 2007-09-26T13:31:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/09/26/organizing-with-solution-folders.aspx
dsq_thread_id:
  - "269784294"
categories:
  - Misc
  - Tools
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/09/organizing-with-solution-folders.html)._

I don&#8217;t know how long it&#8217;s been around, but I found a nice organization feature for VS Solutions, [Solution Folders](http://msdn2.microsoft.com/en-us/library/haytww03(VS.80).aspx).&nbsp; Solution Folders are logical (not physical) folders that you can use to organize projects and solution items.&nbsp; You can nest folders as deep as you like also, just right-click the solution in the Solution Explorer and click &#8220;Add->New Solution Folder&#8221;.

 ![](http://s3.amazonaws.com/grabbagoftimg/SolutionFolder_Snapshot.PNG)

It&#8217;s easy to get carried away, but I like to organize my projects by app, when I have over 10 or so projects in my solution.&nbsp; Typically, it will look like this:

  * Common Projects
  * Tests

  * Windows App
  * Tests

  * Web App
  * Tests

  * Build

Here&#8217;s an example with NBehave:

 ![](http://s3.amazonaws.com/grabbagoftimg/SolutionFolder_Example.PNG)

This solution was small enough that it really didn&#8217;t need it, but with a solution with several dozen projects and many applications, solution folders can prevent quite a few headaches.