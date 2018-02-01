---
id: 192
title: 'Ruby v1.9.2 On Windows: can&#8217;t find executable rake for rake-0.8.7'
date: 2010-10-11T14:10:01+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/10/11/ruby-v1-9-2-on-windows-can-t-find-executable-rake-for-rake-0-8-7.aspx
dsq_thread_id:
  - "262292517"
categories:
  - Rake
  - Ruby
---
FYI – I saw [this question over on StackOverflow](http://stackoverflow.com/questions/3902526/rake-failing-to-start/3906791) and did a little bit of searching for the problem and workarounds. In searching for an answer, I found [issue #3677 on the ruby-lang redmine site](http://redmine.ruby-lang.org/issues/show/3677). It turns out there’s a bug in v1.9.2 of Ruby, at least for Windows and possibly for Linux and other systems, as well. There’s some interesting discussion on the issue and a few workarounds are posted.

It turns out Rake v0.8.7 is bundled with Ruby v1.9.2, which means you don’t need to run “gem install rake” for this version of ruby. If you do, though, you’ll end up getting an error like this:

> <pre>C:&gt;rake
C:/installs/ruby_trunk_installed/lib/ruby/1.9.1/rubygems.rb:340:in `bin_path': can't find executable rake for rake-0.8.7 (Gem::Exception)
        from C:/installs/ruby_trunk_installed/bin/rake:19:in `&lt;main&gt;'</pre>

The two main workarounds for this are:

  1. Don’t run “gem install rake” on a ruby v1.9.2 installation. Since it’s built in, you don’t need to bother with this. 
  2. If you do install rake (perhaps it got pulled down as a dependency of another gem), and you get this error, delete the rake.gemspec file located at (rubyinstalldir)librubygems1.9.1specifications 

Either of these will prevent the problem, or fix the problem. Hopefully the underlying cause will be fixed in a patch of ruby v1.9.2. Until then, these options should work around the issue.