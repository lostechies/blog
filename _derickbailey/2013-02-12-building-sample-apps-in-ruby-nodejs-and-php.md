---
wordpress_id: 1053
title: Building Sample Apps in Ruby, NodeJS and PHP
date: 2013-02-12T14:41:02+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1053
dsq_thread_id:
  - "1079775221"
categories:
  - Community
  - NodeJS
  - PHP
  - Productivity
  - Ruby
---
In the last three years I&#8217;ve gone from full time .NET development to full time Ruby on Rails and then full time JavaScript. It&#8217;s been an awesome ride, so far, but it&#8217;s not done yet. I started digging in to PHP recently, and while I&#8217;m not going to be doing full time work with it I am certainly adding it to my list languages and runtimes that I enjoy using. 

I know PHP is not the sexiest language in the web world right now, but it has a few things going for it: maturity in the language and frameworks for it, the amazingly friendly community of developers, and how quickly I can get a simple web server up and running.

To illustrate that last point, here&#8217;s a quick comparison of what it takes to get sample web app up and running with my three favorite languages / runtimes right now.

## Ruby / Sinatra

The fastest way I know to get a Ruby web app up and running is to use Sinatra. I love Sinatra for it&#8217;s simplicity and flexibility. I have a handful of projects and websites built in it. But it takes a bit to get up and running. I have to install the Sinatra gem and everything else associated with it, then configure an app.rb file with all the right routes and other configuration options to serve up the project files.

Sinatra is my primary choice when building Ruby apps. It&#8217;s great for sharing with the Ruby community because everyone understands it. It&#8217;s also cross-platform so anyone on Windows, Linux or Mac can run it. But it is no longer my primary choice for cross-platform demos and sample apps.

I don&#8217;t use Rails unless I know I need to build a full stack, server-side MVC app w/ all the logic and complexity that comes along with Rails. This is not a knock against Rails. It&#8217;s just &#8220;the simplest thing that could work&#8221; philosophy, and getting things done.

## NodeJS

Node is about the same amount of work to get up and running for a simple demo app. I have to install the Express package through npm and then configure an app.js file to server things correctly. This takes about the same amount of work as Ruby and Sinatra. 

There are 3 distinct advantages that I see in Node/Express over, though:

  * Jade as default HTML templates
  * Easier to run cross-platform
  * NPM eats RubyGems lunch

With Sinatra, I have to go through extra steps to install and configure HAML as the template engine. It&#8217;s worth the extra 2 or 3 things to do, and I always do it. But with Express, Jade is the default template engine. Jade is HAML++ in JavaScript and I love it more than HAML for it&#8217;s even further reduction of noise in HTML tag attributes, etc.

NodeJS is far easier to run cross-platform. Installing and configuring Ruby on a Windows machine is dead-simple. On a Mac? It takes me an hour+ every time I help someone. The community is trying to fix this, but hasn&#8217;t yet. I don&#8217;t know about Linux, but I&#8217;m getting it&#8217;s easier on there than on a Mac. NodeJS, on the other hand, is just easier to install and use everywhere. I can share a NodeJS app with any developer on any platform, and be confident that someone who has never installed or used NodeJS will be able to get it up and running in less than 10 minutes.

NPM is also eating RubyGems lunch right now, for simplicity and feature set, because NPM includes what Bundler does for RubyGems. It really comes down to that. I hate having to &#8220;gem install bundler&#8221; and then &#8220;bundle install&#8221; separately. That&#8217;s stupid. RubyGems should include Bundler in it the way NPM does.

For these three reasons, Node/Express have become my default stack for sharing code with the world. But Node/Express still require more work than PHP, to get a sample web server up and running.

## PHP

What does it take to get a PHP web server running, so I can begin hacking on a sample app?

> php -S localhost:5000

Done. 

No package manager config files to build. No packages to install. No need to configure a web server file with code. I just type that one liner and I&#8217;m good to go. I can edit and display any .php file or .html file that I want, without any other infrastructure work.

The good news is that I can also get something very similar to Ruby/Sinatra or NodeJS/Express with the PHP Slim framework. It&#8217;s the PHP counterpart of Sinatra and Express &#8211; but it&#8217;s optional. I don&#8217;t have to use this to get a basic PHP project up and running.

The downside to PHP is that it took me a few days to get it installed and configured on my Mac. OSX comes with a poor version of PHP built in, so I had to install the latest. After many different attempts from many different sources of advice, I finally got it installed through Homebrew. Then I had to figure out why the new version wasn&#8217;t the default version. Moving beyond that, I had to figure out that &#8220;SQLite&#8221; and &#8220;SQLite3&#8221; are considered separate, unrelated things instead of just versions of SQLite.

Once I got past those hurdles, though, I found myself quite productive with PHP, quickly. The ability to stand up a sample project in one line of terminal commands is quite appealing. I don&#8217;t know that PHP will become a regular thing for sharing code, though. I&#8217;ll certainly use it when I want to share with the PHP community, or when I need to get a web server up and running in no time flat to server a simple HTML page, though.

If you haven&#8217;t looked at PHP, or it has been a long time (it has been near 13 years since I used it last), I&#8217;d recommend checking it out again. If nothing else, it will server as a quick way to get a simple web server off the ground, to start demoing some HTML and JavaScript.

## What&#8217;s Next?

I probably need to learn Python for my next web server language. I keep hearing good things about it from a language purity perspective. But that will have to wait until I see another opportunity to learn something new, again.