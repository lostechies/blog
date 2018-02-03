---
wordpress_id: 204
title: A Semi-Intelligent Watchr Script For Rails And RSpec
date: 2010-12-15T19:05:13+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/12/15/a-semi-intelligent-watchr-script-for-rails-and-rspec.aspx
dsq_thread_id:
  - "262078644"
categories:
  - Productivity
  - RSpec
  - Ruby
  - Smoke Test
  - Test Automation
  - Testing
  - Unit Testing
---
I&#8217;m using [Watchr](https://github.com/mynyml/watchr) in my current Rails 3 project, instead of Autotest, to run my Cucumber and RSpec tests whenever I save a file. It makes life so much easier than having to manually run them. Yesterday, I decided to put a little more intelligence in my rspec script, and have it run the tests for the file that i&#8217;m working with &#8211; whether it&#8217;s a spec file or a model, controller, or whatever else.

Here&#8217;s what I came up with as a starting point:</p> 

Run it via &#8220;watchr rspec.watchr&#8221; from the command line / terminal. The first thing it does is run all specs in the /spec folder &#8211; a quick sanity check or smoke test to make sure everything is working before you start on new specs or code changes.

 

## What It Does

When you save any file in the /app folder &#8211; whether it&#8217;s a model, a controller, sass file, or anything else anywhere under that folder, it will try to find the corresponding \_spec file in the /spec folder. For example, if you save /app/models/user.rb it will try to find the /spec/models/user\_spec.rb specs, and run them.

> Running Specs: /spec/models/user_spec.rb

Followed by the usual RSpec output. If the spec file that it is looking for is not found, it tells you which file was saved and what _spec.rb file it was expecting to find.

> Specs Not Found For:   
> /app/controllers/my_controller.rb
> 
> Looking For Spec File:  
> /spec/controllers/my\_controller\_spec.rb

It searches as deep as you want to go within your models folder, as well. If you have a model at

> /app/models/some/folder/name/my_model.rb

then the script will attempt to run specs at

> /spec/models/some/folder/name/my\_model\_spec.rb

And lastly, whenever you save a file in the /spec folder directly, it runs that file.

 

## It will Probably Do More, In The Future

It&#8217;s fairly basic, but it gets the job done for now. I&#8217;m sure I&#8217;ll add to it over time, too. What features do you have in your watchr script? What am I missing that you would like to see? I have a few ideas, but I&#8217;m not sure if they are feasible, yet.