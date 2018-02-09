---
wordpress_id: 588
title: 'Adding A &#8216;has_image?&#8217; Matcher To Capybara'
date: 2011-09-27T15:33:42+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=588
dsq_thread_id:
  - "427730624"
categories:
  - Capybara
  - Rails
  - RSpec
  - Test Automation
---
I&#8217;m rather shocked that Capybara doesn&#8217;t have a &#8216;has\_image?&#8217; matcher built in to it. But after search around google for a while, the only thing I found was a bunch of StackOverflow answers that all say to use &#8216;has\_xpath?&#8217; to find the image. How painful is that?! So, here&#8217;s my implementation of a &#8216;has_image?&#8217; matcher.

Drop this into &#8216;/features/support/has_image.rb&#8217;

{% gist 1246299 1-has_image.rb %}

Then you can run code like this in your cucumber steps, and it will look for the image based on the &#8216;src&#8217; attribute, and assuming a &#8216;/images/&#8217; path for your images.

{% gist 1246299 2-use.rb %}

Note that I&#8217;m using the magic rspec matchers to go from &#8220;.should have\_image&#8221; to the &#8220;.has\_image?&#8221; method that I just added.

Also note that I made use of the &#8216;contains&#8217; xpath function in my matcher. This is because Rails likes to put gibberish at the end of image paths, to enable caching, etc:

<img title="Screen Shot 2011-09-27 at 4.27.14 PM.png" src="http://lostechies.com/derickbailey/files/2011/09/Screen-Shot-2011-09-27-at-4.27.14-PM.png" border="0" alt="Screen Shot 2011 09 27 at 4 27 14 PM" width="477" height="45" />

The &#8216;contains&#8217; function lets you specify the actual image name without having to worry about the junk at the end of the src attribute.
