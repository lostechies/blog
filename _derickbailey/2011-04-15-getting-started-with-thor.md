---
wordpress_id: 265
title: Getting Started With Thor
date: 2011-04-15T07:00:20+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=265
dsq_thread_id:
  - "280125524"
categories:
  - Documentation
  - Open Source
  - Ruby
  - Thor
---
I&#8217;ve known about [Thor](https://github.com/wycats/thor) for some time now, and have been using it in my Rails 3 work. It seemed like a great little tool for writing command line apps in ruby. So, when I had a need to write a small file importer, I decided to give thor a run and see how it worked.

The end result is something I&#8217;m very happy with. I really like the polished feel that my thor task has, with command line options, help screen, etc.  Unfortunately, the process of learning thor was painful and generally awful. The documentation makes it sound like thor is a rake-style syntax, but I found that to be very misleading. I tried to use my extensive rake experience to build my thor scripts, based on the examples in their documentation, and I failed miserably.

After struggling through this, I decided to do something about it and spent my lunch time today working on the [Thor wiki](https://github.com/wycats/thor/wiki). I moved all of the documentation out of the readme file and into the wiki, first. Jose Valim was kind enough to accept a pull request on the thor code to change the readme, too, so it now points to the wiki. After that, I dove into what I hope is a useful &#8216;getting started&#8217; wiki page, to try and help others get up and running with Thor faster than I was able to.

In the getting started page, I explain a few of the conventions that thor uses and show how to build and run some very simple example tasks, including task parameters and options.

So, what are you waiting for? Go read [the Getting Started page on the Thor wiki](https://github.com/wycats/thor/wiki/Getting-Started)! The great part about this is that it&#8217;s a wiki page, so anyone with a Github account can update it and help improve it.