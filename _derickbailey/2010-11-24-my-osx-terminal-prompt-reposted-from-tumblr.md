---
wordpress_id: 198
title: My OSX Terminal Prompt (Reposted from Tumblr)
date: 2010-11-24T20:22:50+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/11/24/my-osx-terminal-prompt-reposted-from-tumblr.aspx
dsq_thread_id:
  - "263109745"
categories:
  - Uncategorized
---
I wanted to post this on LosTechies, originally, but I didn&#8217;t have a good blogging tool at the time. I&#8217;m using MarsEdit now, and it seems to do what I want&#8230; but I digress&#8230;

 

## My OSX Terminal Prompt

I made a few very minor tweaks to my OSX prompt after posting the previous screen shot on [Tumblr](http://derickbailey.lostechies.com). There&#8217;s not a lot of difference, here, but I also wanted to include the PS1 export in case others want to use it (by request of [@rkitson](http://twitter.com/rkitson))

<img style="border: 0px initial initial" src="http://img.skitch.com/20101122-7a23mc2ema91bmsfkx3sudq8c.jpg" alt="My OSX Prompt" width="499" height="215" />

The first thing to note is that there is a blank line after the last command and before the current location / status indicators.

The first section, in white, is the current folder. I added a trailing / to this. Makes it easier to understand when your at the root folder or at ~/

The second section, in green, shows the current branch and status of a git repository. This is built into git, which is cool. No more parsing out git status messages. I haven&#8217;t quite figured out all of the symbols for this, but here&#8217;s the ones I do know:

  * &#8220;=&#8221; is for a tracking branch, and says current commit is same as remote
  * &#8220;>&#8221; is also for a tracking branch, and says current commit is forward of remote
  * &#8220;<&#8221; is also for a tracking branch, and says current commit is behind remote
  * &#8220;*&#8221; is for local changes that are not yet committed
  * &#8220;%&#8221; I don&#8217;t remember what this is for

The prompt combines these symbols in various ways. For example, &#8220;=*&#8221; says local changes not committed, but most recent commit is same as remote. This section hides itself when you&#8217;re not in a git repository.

The third section, in red, shows the RVM ruby version and gemset that is currently being used. This is built into RVM, as well. Just have to specify which options you want (and I don&#8217;t remember what the options mean off-hand). This section hides itself when you&#8217;re not using any specific version of ruby, with RVM.

Finally, I drop to a new line before putting &#8220;$ &#8221; &#8211; yes, with a space &#8211; as my prompt. This keeps the prompt at the same place on the screen at all times.

&#8230; and not shown in this screen shot, I set the title bar of the terminal to &#8220;username@machinename&#8221;

 

## The PS1 Settings For This Prompt

For those that are interested, here&#8217;s the PS1 setting for this:

> function prompt {
> 
> local LIGHT_RED=&#8221;[33[1;31m]&#8221;   
> local LIGHT_GREEN=&#8221;[33[1;32m]&#8221;   
> local NO_COLOUR=&#8221;[33[0m]&#8221;
> 
> local TITLEBAR='[33]0;u@h07]&#8217;
> 
> source ~/.git-completion.bash
> 
> export GIT\_PS1\_SHOWDIRTYSTATE=true   
> export GIT\_PS1\_SHOWUNTRACKEDFILES=true   
> export GIT\_PS1\_SHOWUPSTREAM=auto   
> export GIT\_PS1\_SHOWSTASHSTATE=true
> 
> PS1=&#8221;$TITLEBARnw/$LIGHT\_GREEN$(\_\_git\_ps1 &#8216; (%s)&#8217;) $LIGHT\_RED$(~/.rvm/bin/rvm-prompt i v g)n$NO\_COLOUR$ &#8220;
> 
> }
> 
> #call the prompt function to set things in motion  
> prompt