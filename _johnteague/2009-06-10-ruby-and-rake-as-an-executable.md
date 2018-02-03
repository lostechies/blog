---
wordpress_id: 31
title: Ruby and Rake as an executable
date: 2009-06-10T20:05:00+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2009/06/10/ruby-and-rake-as-an-executable.aspx
dsq_thread_id:
  - "262055672"
categories:
  - Uncategorized
---
I&#8217;ve been trying for months to get my partner in [crime](http://www.nextleveltechnology.com), [Stephen Balkum](http://www.stephenbalkum.com), to switch to Rake as our default build system.&nbsp; We&#8217;ve been using Nant FOREVER and while it works, I really hate writing Nant scripts.

The problem Stephen had with going to Rake where twofold.&nbsp; One, we&#8217;re still doing (mostly) .Net apps, so the only thing we&#8217;d use Ruby for right now is Rake (hopefully that will change soon too).&nbsp; And Ruby is a pretty big installation if you&#8217;re only building .Net projects with Rake.

The other, more important, more problem is that we like to have completely self-contained projects.&nbsp; So when a new dev comes online all they have to do is checkout from source control, click build.bat and you are ready to go.&nbsp; You simply can&#8217;t do that with Ruby and Rake.&nbsp; You must install Ruby and then get all of the gems necessary to run Rake.

Well, Stephen found a way around all of this.&nbsp; He has encapsulated Ruby, Rake, and all dependencies into a single 3mb executable.&nbsp; Now it can be checked in and passed around like any other required tool.

You can read more about it [here](http://www.stephenbalkum.com/archive/2009/06/09/when-all-you-need-is-a-rake.aspx)