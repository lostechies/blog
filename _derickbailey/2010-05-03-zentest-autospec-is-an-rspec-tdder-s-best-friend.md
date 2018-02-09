---
wordpress_id: 151
title: ZenTest+Autospec Is An RSpec TDDer’s Best Friend
date: 2010-05-03T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/05/03/zentest-autospec-is-an-rspec-tdder-s-best-friend.aspx
dsq_thread_id:
  - "262068685"
categories:
  - Albacore
  - Behavior Driven Development
  - Command Line
  - Continuous Integration
  - Productivity
  - Rake
  - RSpec
  - Ruby
  - Unit Testing
  - Vim
redirect_from: "/blogs/derickbailey/archive/2010/05/03/zentest-autospec-is-an-rspec-tdder-s-best-friend.aspx/"
---
In all the time that I’ve been using RSpec (almost a year now), I never knew about the zentest or autospec tools until I was recently watching a code kata that was using Ruby and RSpec. … so, now I have to ask… why didn’t I know about ZenTest and autospec until just over a week ago?! For the last year or so, I’ve been manually running my [albacore](http://albacorebuild.net) test suite after every change that I made. This meant a series of time wasting steps, dependent on what I was doing: 

> **Run New Tests:** alt-tab over to my command prompt, type in “spec spec/whatever_spec.rb –fs –c”, hit enter and wait for the tests to complete
> 
> **Re-Run Tests:** alt-tab over to my command prompt, pressing the up arrow on my keyboard to reload the previously run command, hitting enter to re-run the tests and wait for them to complete

But NO MORE! With ZenTest installed, I can use the autospec feature of Rspec and be done with the manual execution of tests! Now All I need to do is run the “autospec” command from the home directory of my albacore project. This will configure ZenTests’s autotest feature to run my rspec tests. It will then run the entire suite of tests (which takes a couple of minutes, since albacore is nothing but integration tests). Once the suite has finished running, autotest will pause and wait for a file system change in my albacore folder structure. When it sees a file system change, it will attempt to find the tests that correspond to the file being changed and re-run only the changed tests.

For example… when I write out my tests for the xunit task from gVim

<a href="http://lostechies.com/derickbailey/files/2011/03/image_2764383A.png" target="_blank"><img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_thumb_7EE55625.png" width="444" height="285" /></a>

autospec picks up on the changes to the tests and re-runs just the xunit tests:

&#160; <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_04BFF9BF.png" width="444" height="343" /></p> 

&#160;

### Install ZenTest and RSpec

Installation is easy. You only need rspec and ZenTest (note the capital Z and T in ZenTest when installing the gem)

&#160; <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_2AB5AA15.png" width="721" height="411" />

Now you, too, can enjoy the awesomeness that is automatic test runs without having to go through a CI server. 🙂

&#160;

### Questions: How Do I … ????

Unfortunately, the documentation for ZenTest and RSpec’s autotest are somewhat lacking. It seems to be very difficult to find any single source of information, other than the implementations in the source code. There are a few places with “official” documentation, but the options and configurations are not completely specified. There’s also an html file with examples and plugins listed, that comes with ZenTest. 

Here are the places that I know of, to find information:

  * ZenTest homepage: [http://www.zenspider.com/ZSS/Products/ZenTest/](http://www.zenspider.com/ZSS/Products/ZenTest/ "http://www.zenspider.com/ZSS/Products/ZenTest/")
  * ZenTest rdocs: [http://zentest.rubyforge.org/ZenTest/](http://zentest.rubyforge.org/ZenTest/ "http://zentest.rubyforge.org/ZenTest/")
  * RSpec Autotest Integration: [http://wiki.github.com/dchelimsky/rspec/autotest-integration](http://wiki.github.com/dchelimsky/rspec/autotest-integration "http://wiki.github.com/dchelimsky/rspec/autotest-integration")
  * Getting Started: installed with ZenTest in your gems folder: (your ruby install folder)librubygems1.8gemsZenTest-4.3.1articlesgetting\_started\_with_autotest.html

Some things that I really want to know, which I can’t find anyhwere…

  * How do I get it to produce my “Format: SpecDoc” from rspec (the “-fs” parameter that I use)?
  * How do I get it to produce my “Colour” specs from rspec (the “-c” parameter that I use)?

There are some pretty cool plugins for this, though. Maybe one of them will help answer my questions or provide functionality that replaces what I want. Does anyone know of a good list of plugins, other than the “getting started” html file I mentioned? Does anyone know of a good place to get information on how to configure autotest, other than reading through the source code and what little rdocs there are?