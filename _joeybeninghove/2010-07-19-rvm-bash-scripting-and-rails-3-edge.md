---
wordpress_id: 76
title: RVM, Bash Scripting and Rails 3 Edge
date: 2010-07-19T20:34:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2010/07/19/rvm-bash-scripting-and-rails-3-edge.aspx
categories:
  - automation
  - bash
  - Rails
  - Ruby
  - rvm
redirect_from: "/blogs/joeydotnet/archive/2010/07/19/rvm-bash-scripting-and-rails-3-edge.aspx/"
---
I&#8217;ve only begun to tap into the power of bash scripting, but I had a need to automate setting up a Rails 3 app on edge, using [RVM](http://rvm.beginrescueend.com/) like I want. &nbsp;So I decided to whip up a very simple script that does the following for the name of app you&#8217;re creating:

  1. Creates a new [RVM gemset](http://rvm.beginrescueend.com/gemsets/basics/) for the app
  2. Creates a directory for the app
  3. Creates an [.rvmrc](http://rvm.beginrescueend.com/workflow/rvmrc/) file under the new app directory to ensure the proper gemset is used whenever you switch to it 
      1. Note: This assumes you have [REE 1.8.7](http://www.rubyenterpriseedition.com/) installed under rvm (rvm install ree), which is the main ruby I&#8217;m still using for everything
  4. Installs latest prerelease of [bundler](https://github.com/carlhuda/bundler)
  5. Installs latest **[edge](https://github.com/rails/rails)** [version of rails 3](https://github.com/rails/rails)

<div>
  Here&#8217;s the bash script:
</div></p> 

<div>
  What this quickly gives you is a new Rails 3 app running on edge, with everything installed in its own RVM gemset to keep from polluting the rest of your ruby environments or applications.
</div>

<div>
</div>

<div>
  Of course I&#8217;m no bash expert, so I&#8217;d love to hear any improvements or other bash scripting-fu you guys are doing.
</div>

&nbsp;