---
wordpress_id: 201
title: Web Development Stack In OSX
date: 2010-12-09T05:18:45+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/12/09/web-development-stack-in-osx.aspx
dsq_thread_id:
  - "263109292"
categories:
  - Behavior Driven Development
  - Command Line
  - git
  - Productivity
  - RSpec
  - Ruby
  - Source Control
  - Test Automation
  - Testing
  - Tools and Vendors
  - Unit Testing
  - Vim
redirect_from: "/blogs/derickbailey/archive/2010/12/09/web-development-stack-in-osx.aspx/"
---
It has been almost a month since I ventured out into contracting and took up OSX on a Macbook Pro as my primary operating system. In that time, I&#8217;ve been very fortunate to have [Joey Beninghove](http://joeybeninghove.com/) guide me through the torrent of options and possibilities for building web apps in OSX. I&#8217;ve thrown in a few of my own tools based on all the things I&#8217;m doing and my own personal experience, too. Most of these tools are available to other platforms, too. You don&#8217;t have to be a OSX user to take advantage of them, but it certainly seems to be easy if you are.

Here&#8217;s what I&#8217;ve settled on, so far, creating an awesome development experience &#8211; far better than any IDE I&#8217;ve ever used.

 

## Terminal

At the root of it all is the OSX Terminal. I&#8217;m using the standard Bash shell at this point, though a number of people have told me I need to try out ZSH. I&#8217;ll probably get around to that eventually. For now, though, Terminal handles my needs quite nicely.

I&#8217;ve already talked about [my terminal prompt](http://www.lostechies.com/blogs/derickbailey/archive/2010/11/24/my-osx-terminal-prompt-reposted-from-tumblr.aspx). Joey has also talked about [setting up window groups to auto-start the various components of a project](http://www.lostechies.com/blogs/joeydotnet/archive/2010/07/16/quick-tip-osx-terminal-automation.aspx). It works out well &#8211; only requires one menu option to launch all of the core services of a project.

 

## Homebrew

<http://mxcl.github.com/homebrew/>

I don&#8217;t like installing things manually. Linux has the wonder packages managers, and OSX has a few options, too. The choice of Homebrew vs. Macports wasn&#8217;t too hard, really. I&#8217;ve used Macports in the past and it was&#8230; usable. I went with Homebrew at the suggestion of several people and it&#8217;s been quite nice in comparison to Macports. The commands seem to be easier and more friendly to work with.

 

## Git

<http://git-scm.com>

Installed via Homebrew

> brew install git

The only source control I love, at this point. I&#8217;m sure that will change once the next new hotness comes down the line&#8230; but for today (and the last 2 years), Git is where it&#8217;s at for me.

 

## VIM (MacVim)

<http://vim.org>

Installed via Homebrew

> brew install macvim

Ah, vim. It&#8217;s the most difficult &#8220;text editor&#8221; I&#8217;ve ever used and the most amazing code editor I&#8217;ve ever fell in love with. After many months of working with vim and vim-like plugins for other editors, I can&#8217;t imagine using anything that doesn&#8217;t have vim&#8217;s core editing features.

&#8230; and the many, many plugins available make automating most tasks that you would want from an IDE, extremely simple. Here&#8217;s the plugins that I use:

  * bufexplorer
  * command-t
  * nerdtree
  * twilight (color theme)
  * vim-cucumber
  * viim-endwise
  * vim-fugitive
  * vim-git
  * vim-haml
  * vim-rails
  * vim-rake
  * vim-ruby
  * vim-surround
  * vim-textile

Of course, there are countless others available.

 

## RVM (Ruby Version Manager)

<http://rvm.beginrescueend.com/>

If you do any work with ruby on OSX or Linux, you need to be using RVM. It allows you to easily switch between different versions of ruby, install new versions of ruby, and manage your gems for specific projects with gem sets. The best part is, you can automate rvm usage by putting a .rvm file in a folder. When you cd into that folder in terminal, rvm will read the file and automatically set the correct version of ruby and the gem set that you want to use for that project.

 

## Ruby On Rails

[http://rubyonrails.org](http://rubyonrails.org/)

The de-facto standard in MVC web frameworks, these days. Here&#8217;s a few of the plugins that Joey and I are currently using with Rails:

  * RSpec
  * Cucumber
  * Capybara
  * HAML
  * SASS
  * Compass
  * FactoryGirl
  * Mongoid
  * JQuery

These, combined with other misc items and Rails itself, make the web development story very nice.

 

## MongoDB

<http://www.mongodb.org/>

Installed from Homebrew

> brew install mongodb

Yes, I&#8217;ve jumped into the whole &#8220;NoSQL&#8221; thing. I&#8217;m impressed with MongoDB, so far. From it&#8217;s native Javascript interface, to the drivers that are available for the various languages, and the performance and scalability of the system. It&#8217;s quite impressive and an option that everyone should have in their back pocket.

The Rails drive that Joey and I are using is Mongoid. It handles most of our needs without any effort. The few things it doesn&#8217;t handle are easy to do on our own.

 

## XAMPP

<http://www.apachefriends.org/en/xampp.html>

Yes, I am doing more than just Rails work. I&#8217;m also working on some WordPress sites &#8211; mostly converting existing sites to WordPress, including the creation of themes, etc.

If you&#8217;re doing any WordPress work, or any web work that involves **A**pache, **M**ySql, **P**HP or **P**erl, then you need to be using XAMPP. This goes for OSX, Linux, and Windows. XAMPP is, in a nutshell, a complete package for web development in the xAMPP stack (hence, the name). You don&#8217;t need to install or configure any of these tools on your machine, with XAMPP. It is an isolated install of them, providing a clean separation between your machine and the web development stack.

 

## LiveReload

<https://github.com/mockko/livereload>

This is probably my favorite new tool out of all of these tools. Not only is the technology behind it really really cool &#8211; EventMachine and websockets &#8211; but what it does is amazing.

This tool monitors your file system and watches for changes to your web app&#8217;s files &#8211; ruby code, php code, css, html, you name it and LiveReload will monitor it. Just set what you want to watch in a .livereload file in your project folder. When any changes to the watched files are found, your browser (Safari or Chrome) will automatically reload the page that you are looking at!

What this means, in practice, is that you no longer have to do the save-switch-refresh dance when you are building html and css &#8211; or writing code in your controllers or WordPress themes! You can have your browser window set on the page you are editing / styling, enable livereload for the page, and then switch over to your editor of choice. When you make some changes and save the file(s), your browser will refresh the page for you and you will see the changes immediately! No more &#8220;save&#8221;, &#8220;switch to the browser&#8221;, &#8220;hit refresh&#8221;, &#8220;switch back to the code editor&#8221;. Just save and see your changes.

 

## More Than Just This List

Of course there are fare more tools and add-ons that I am using, than this list. I&#8217;ve only touched on the big name tools that give me the most bang for the buck. Beyond this, the tools get much more specialized and specific to the app that I&#8217;m building at any given point in time.