---
wordpress_id: 216
title: How To Have Bundler Load A Gem From The Vendor Folder Into A Rails 3 App
date: 2011-02-24T03:09:12+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2011/02/23/how-to-have-bundler-load-a-custom-gem-into-a-rails-3-app.aspx
dsq_thread_id:
  - "262217226"
categories:
  - Ruby
---
I have a rails 3 app that needs some specific functionality that is built into a gem. Unfortunately, the current gem that is published on RubyGems.org only works with rails 2. I was able to get the gem to work by commenting out some code that I don&#8217;t need, though. I wanted to do a custom gem build and have this gem installed into my rails app&#8217;s vendor folder, so Bundler could load it from there (note: the gem is MIT licensed, so there&#8217;s nothing stopping me from doing this, legally). But I only want this one gem to load from the vendor folder. The rest of the gems in the app should load from wherever bundler normally loads gems.

 

### Installing The Gem Into The Vendor Folder

In order for Bundler to use the gem from the vendor folder, all of the files form the gem must be in that folder &#8211; more specifically, unpacked into a sub-folder for the gem. There are a number of ways that this can be done:

  * bundle package
  * copy & paste
  * git clone
  * gem unpack

Running bundle package wasn&#8217;t an option for me, as I didn&#8217;t have the gem installed currently. Plus, I only wanted to run this one gem from the vendor folder, not every gem that the app needs. There may be a way to make bundle package work for my needs, but I couldn&#8217;t figure out how.

If you have access to the source code, you could just copy & paste the files from the source into a folder. This includes copying the files out of a ruby installation or rvm gemset; it doesn&#8217;t really matter where the code came from, as long as it&#8217;s the actual code for the gem, in the correct folder structure.

If the gem&#8217;s source is hosted in a git repository, you can specify the location of the repository in the Gemfile with the :git option for the gem. Alternatively, you can clone the repository into the vendor folder, which is essentially the same thing as a copy & paste. This wasn&#8217;t an option for me, either.

What did work for me was the gem unpack command. This command unpacks the gem file into a folder, without going through the dependency resolution process of a gem install. Here&#8217;s a screen shot of how I unpacked the gem into my app&#8217;s vendor folder:

<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-02-23-at-8.53.41-PM.png" border="0" alt="Screen shot 2011 02 23 at 8 53 41 PM" width="600" height="73" />

The end result is that my vendor/vitalkey-notamock-1.0.1 folder now contains all of the code from the gem:

<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-02-23-at-8.57.19-PM.png" border="0" alt="Screen shot 2011 02 23 at 8 57 19 PM" width="600" height="275" />

 

### Setting The Location Of The Gem In The Gemfile

Once the gem has been unpacked into the folder, the Gemfile in the app needs to be updated to point bundler to this folder for this gem. According to the [gemfile documentation](http://gembundler.com/man/gemfile.5.html), this is done with the :path option. Here&#8217;s the gem line in my Gemfile, loading my custom gem:

<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-02-23-at-8.59.18-PM.png" border="0" alt="Screen shot 2011 02 23 at 8 59 18 PM" width="446" height="71" />

Note that if you don&#8217;t specify the version number (the 2nd parameter) then you have to provide a .gemspec file in the folder that you set here. There&#8217;s a few different ways to get the gemspec file, but since we know what version we are dealing with, it&#8217;s easier to specify the version here.

 

### Bundler&#8217;s Auto-Require

The gemfile documentation also talks about a :require option, as shown in the previous screen shot. This is used by bundler to automatically require the right file for the project to use the gem. In many cases, the file that gets required is the same name as the gem. For example, my albacore project gem is named the same as the file that gets required, to use it:

> require &#8216;albacore&#8217;

In my rails app&#8217;s case, the file to require is not the same name as the gem. By specifying the :require option, though, bundler can still require the file for me, preventing me from having to put a require statement in my app. If I didn&#8217;t specify the :require option here, I don&#8217;t think bundler would fail to load the gem, but I would have to put the require statement in my code, when I needed this gem:

> require &#8216;not\_a\_mock&#8217;

 

### That&#8217;s It. Done

Yeah, I know. This really isn&#8217;t that special or difficult. However, it took me a number of hours to figure this out because the documentation for bundler and gemfiles sucks. It&#8217;s ambiguous in some places, cryptic in others, and generally assumes that you know everything about how bundler and rubygems work, already. Hopefully this blog post will help someone else and prevent them from having to go through what I went through.