---
wordpress_id: 218
title: Installing Ruby 1.8.6 And RubyGems On OSX (Snow Leopard) With RVM
date: 2011-03-14T17:16:57+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2011/03/14/installing-ruby-1-8-6-and-rubygems-on-osx-snow-leopard-with-rvm.aspx
dsq_thread_id:
  - "262067335"
categories:
  - OSX
  - Ruby
redirect_from: "/blogs/derickbailey/archive/2011/03/14/installing-ruby-1-8-6-and-rubygems-on-osx-snow-leopard-with-rvm.aspx/"
---
[RubyGems no longer supports Ruby v1.8.6](http://blog.segment7.net/2010/04/23/ruby-1-8-6-policy), so when I tried to install 1.8.6 on my Macbook, via [RVM](http://rvm.beginrescueend.com/), I ran into this nice little error message:

<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-03-14-at-8.49.58-AM.png" border="0" alt="Screen shot 2011 03 14 at 8 49 58 AM" width="600" height="233" />

The interesting bit is that ruby itself installed. It&#8217;s only RubyGems that didn&#8217;t install correctly. Parts of rubygems were installed, and I could run the &#8220;gem&#8221; command, but I would get errors with any ruby code that needed rubygems to be around.

The fix is pretty simple: install a compatible version of rubygems, manually.

Head over to http://rubyforge.org/frs/?group_id=126 and grab the version of rubygems that you want. I went with 1.4.2 even though the blog post I linked to says it won&#8217;t work. It does. Drop the .tgz file on your computer somewhere and unpack it:

> tar xvf rubygems-1.4.2-tgz

Then be sure you are using the correct version of ruby in rvm:

> rvm use 1.8.6

And install rubygems:

> cd rubygems-1.4.2  
> ruby setup.rb

and that&#8217;s it! I now have ruby 1.8.6 with rubygems 1.4.2 running on OSX. I&#8217;ve installed gems and verified that my apps work, too.