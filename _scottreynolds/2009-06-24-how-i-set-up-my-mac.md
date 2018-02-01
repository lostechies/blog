---
id: 4041
title: How I Set Up My Mac
date: 2009-06-24T03:24:23+00:00
author: Scott Reynolds
layout: post
guid: /blogs/scottcreynolds/archive/2009/06/24/how-i-set-up-my-mac.aspx
categories:
  - mac
---
Some time ago I [switched](http://scottcreynolds.com/archive/2008/07/12/moving-to-the-macbook-pro.aspx) to Mac OS X for my day to day work, using Windows only in a virtual machine for when I absolutely needed to use Visual Studio.

I just got a new 15&#8243; MacBook Pro as part of an initiative to roll my entire team over to Mac as our day to day platform (story for another day) and thought I would document my setup for their benefit (and anyone else&#8217;s).

## Step 1 &#8211; System Settings

#### Updates &#8211; Do Software Updates until you can&#8217;t do any more.

Seriously. Just get it out of the way now.

#### The equivalent of &#8220;lock workstation&#8221; from Windows

  1. Open System Preferences
  2. Choose &#8220;Desktop & Screensaver&#8221;
  3. Choose &#8220;Screen Saver&#8221; at the top
  4. Go to &#8220;Hot Corners&#8221; and set a corner to activate screen saver
  5. Go back to System Preferences and choose Security
  6. Under &#8220;General&#8221; check &#8220;Require password to wake&#8230;&#8221;
  7. Check &#8220;Disable automatic login&#8221;

That done, you roll your mouse to your hot corner, activate the screen saver, and your station is locked. No getting [goated!](http://www.codinghorror.com/blog/archives/000997.html)

#### Trackpad Settings

I like my trackpad a certain way. Tap to click, and tap two fingers to &#8220;right-click&#8221;. These settings are found in System Preferences under Trackpad

#### My Dock

I don&#8217;t like to see my dock, so I make it small and auto-hide. I also remove all applications from the dock so that at any given time the only ones there are the ones that are active.

#### GitHub Setup

If you use [Github](http://github.com) regularly, then on a new machine you will need to generate your SSH key and set it up in GitHub. Follow the instructions on your account page.

## Step 2 &#8211; Critical Software

To get up and running immediately, I install the following: 

  1. Xcode &#8211; Get it from the OS disk. Do it first since gems stuff needs it. Later, sign up for ADC and get the iPhone SDK too. Also MacRuby.
  2. [AppCleaner](http://www.freemacsoft.net/AppCleaner/) &#8211; I like this for doing &#8220;uninstalls&#8221; and keeping down orphaned file bloat.
  3. Install a launcher. I like [Quicksilver](http://blacktree.com/?quicksilver)
  4. [Adium](http://adium.im/) &#8211; Chat/IM/IRC (though I use Colloquy for IRC). Let Adium install Growl.
  5. [TextExpander](http://www.smileonmymac.com/TextExpander/) &#8211; Awesome snippet tool. Add the HTML and CSS bundles from the preferences if you do web work. Add the symbols and accented words bundles too.
  6. [TextMate](http://www.macromates.com) &#8211; My editor of choice for most things.
  7. [RazorSQL](http://razorsql.com) &#8211; Manage SQL Server, SQLite, MySql, and many more in this excellent free tool.
  8. [Dropbox](http://getdropbox.com) &#8211; for syncing to multiple machines and sharing with people
  9. [Mono and MonoDevelop](http://monodevelop.com) &#8211; Doing a lot more of my .net work in MonoDevelop as time goes on. Launching that Windows VM less and less.
 10. [Git for OS X](http://code.google.com/p/git-osx-installer/)
 11. VMWare Fusion &#8211; I keep a Vista VM on a separate drive to use when I need it. Running your VMs on an external drive seems faster (slower to start up) for some reason.

I use a lot more in terms of software, but this is the base package needed to get up and running and be productive at work.

## Step 3 &#8211; Ruby and Rails setup

Setting my rails environment up fresh is a nice couple of minutes of command line goodness. Fire up terminal and do the following: 

  1. gem update &#8211;system (update the preinstalled stuff)
  2. gem sources -a http://gems.github.com (add github to gem sources)
  3. gem install rspec
  4. gem install rspec-rails
  5. gem install cucumber
  6. gem install webrat
  7. gem install wirble
  8. gem install nokogiri
  9. gem install ZenTest

Next, I edit ~/.irbrc in my favorite editor and make it look like so:

<pre>require 'rubygems'
require 'wirble'

Wirble.init
Wirble.colorize

alias q exit
</pre>

This puts rubygrms and wirble into irb, wirble providing you things like colorizing, history, tab-completion and more. The _alias q exit_ bit is so that q will exit irb for me, giving it a kind of vim-y feel. This is optional.

## Step 4 &#8211; TextMate Bundles

Being a big TextMate user, I install the following bundles right away: 

  * [Cucumber](http://github.com/bmabey/cucumber-tmbundle/tree/master)
  * [Webrat](http://github.com/bmabey/webrat-tmbundle/tree/master)
  * [Git](http://wiki.github.com/dchelimsky/rspec/textmate http://gitorious.org/git-tmbundle)
  * [Rspec]()

The easiest way to get these installed is to create the Bundles directory if it doesn&#8217;t exist: 

<pre>mkdir -p ~/Library/Application Support/Textmate/Bundles/</pre>

then go to that directory and start git-cloneing the bundles. Each should have the git-clone command on their readme or wiki.
  
A handy snippet when installing bundles is a little script that will tell TextMate to reload bundles without you having to do it manually:

<pre>osascript -e 'tell app "TextMate" to reload bundles'
</pre>

## Other Applications

Other applications that I find useful and install after all of the above: 

  * [Colloquy](http://colloquy.info) &#8211; IRC
  * [Cyberduck](http://cyberduck.ch/) &#8211; FTP
  * [MarsEdit](http://www.red-sweater.com/marsedit/) &#8211; Blogging
  * [TweetDeck](http://tweetdeck.com/beta/) &#8211; Twitter
  * [Evernote](http://evernote.com) &#8211; Note keeping and lists. Syncs with the Evernote on my iPhone. Life is good.
  * [Appshelf](http://www.kedisoft.com/appshelf/) &#8211; App to keep your registrations and serial numbers all in one place. Nicely done.
  * [iStat](http://www.islayer.com/apps/) Menus &#8211; System Monitoring in the Menu Bar
  * [VLC](http://videolan.org/vlc) &#8211; Plays like&#8230;any media format. Seriously.
  * [Skype](http://www.skype.com) &#8211; You know&#8230;for skype stuff

<!-- Technorati Tags Start -->

Technorati Tags:
  
<a href="http://technorati.com/tag/mac" rel="tag">mac</a>, <a href="http://technorati.com/tag/os%20x" rel="tag">os x</a>, <a href="http://technorati.com/tag/software" rel="tag">software</a>, <a href="http://technorati.com/tag/rails" rel="tag">rails</a>, <a href="http://technorati.com/tag/ruby" rel="tag">ruby</a>, <a href="http://technorati.com/tag/textmate" rel="tag">textmate</a> 

<!-- Technorati Tags End -->