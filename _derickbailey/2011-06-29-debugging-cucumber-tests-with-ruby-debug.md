---
wordpress_id: 462
title: Debugging Cucumber Tests With Ruby-Debug
date: 2011-06-29T13:33:12+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=462
dsq_thread_id:
  - "345585513"
categories:
  - Cucumber
  - Debugging
  - Ruby
---
Today I ran into a scenario where I needed to step through some ruby code and examine the state of various objects in my rails app. I&#8217;ve used the ruby-debug gem a number of times to do exactly this. However, this scenario was being run via cucumber. After some quick googling, I found a number of blog posts saying that you should be able to stick a &#8216;debugger&#8217; statement anywhere in your code (including your feature step definitions) and it should work. An hour after I started trying, [I finally got it working thanks to Tim Tyrrell](https://twitter.com/#!/timtyrrell/status/86146874788159490).

### Getting It To Work

Here&#8217;s the first things that I did to get ruby-debug to work with cucumber.

[gist id=1054669 file=1-general-setup.rb]

The first chunk of code in my Gemfile ensures that I have the ruby debugger loaded up. I&#8217;ve had this line in my Gemfile for some time now, since I&#8217;ve done debugging of my rails apps.

The second chunk of code in the cucumber env.rb file is the magic sauce that I needed to get this working. Once I added that line to this file, I was able to place a &#8216;debugger&#8217; or &#8216;breakpoint&#8217; statement anywhere I wanted and ruby-debug attached correctly.

The last chunk should go in some cucumber step definition file. It&#8217;s a convenience step that [Tim also suggested adding](https://twitter.com/#!/timtyrrell/status/86144726503391232). That way, you can just add &#8220;Then I debug&#8221; as a step to any cucumber feature file, and step into the code at that point. This is useful when you don&#8217;t know exactly where the code is failing and you want to attach the debugger prior to the failing step.

### Doing It Right With Bundler&#8217;s :require Option

I&#8217;m a little surprised that I had to add the require &#8216;ruby-debug&#8217; to my env.rb file, honestly. Bundler usually handles the &#8216;require&#8217; for you, when you include a gem &#8230; except that the gem is named &#8216;ruby-debug19&#8217; and the require statement is &#8216;ruby-debug&#8217;, which breaks the convention that bundler uses to do the include.

Fortunately,  we can fix the Gemfile to specify by specifying the :require option.

[gist id=1054669 file=2-the-right-way.rb]

Now that I have my Gemfile properly loading &#8216;ruby-debug&#8217;, I can get rid of the require &#8220;ruby-debug&#8221; line in my env.rb file. Re-run the cucumber suite, and the debugger attaches correctly.