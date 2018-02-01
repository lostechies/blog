---
id: 139
title: 'The *nix Rube Goldberg Machine &#8211; .bat;.cmd done better'
date: 2012-04-16T19:11:22+00:00
author: Ryan Rauh
layout: post
guid: http://lostechies.com/ryanrauh/?p=139
dsq_thread_id:
  - "652006878"
categories:
  - Shell
tags:
  - bash
---
# Learn your shell! 

My primary work machine is Ubuntu \*happy face\* but my day to day work is in a windows VM \*sad face\*

Our project uses a lot of nugets packages and some of those nugets bring in command line tools that we use while developing our project. For example we use a tool called bottles that can package our application up into &#8220;deployable zipfiles&#8221;.

Anyways that tools comes into our project via nuget, but I have to call that tool from the command line all the time. So my coworkers made a batch file that will find the exe in the nuget packages folder and delegate all the command line argument to it so we can all bottles from the root of our project like this

 `~/lecode/leproject>bottles create-all` 

Here&#8217;s the source code for that cmd file.

[gist id=&#8221;2400567&#8243; file=&#8221;bottles.cmd&#8221;]

Pretty simple, it runs a for loop looking for any files named BottleRunner.exe and sets a variable. Then it checks if that variable was found and does a GOTO \*gasp\* delegating arguments to the exe.

That&#8217;s all well and good but I want to run bottles from bash, cause I&#8217;m in bash way more that cmd and lets face it I hate cmd.exe and don&#8217;t want to use it. 

So I came up with this piece of awesome.

[gist id=&#8221;2400567&#8243; file=&#8221;bottles&#8221;]

 `find source/packages -type d | sort -r | grep "Bottles\.Tools" | sed -n 1p | xargs grep -rl "BottleRunner\.exe" | sed -n 1p` 

Holy crap! that&#8217;s a nasty one, what does it do?

 `find source/packages -type d` 
  
Find all directories (-type d) in the source/packages folder

 `find source/packages -type d | sort -r`
  
Pipe that into sort in order to sort it descending (-r)

 `find source/packages -type d | sort -r | grep "Bottles\.Tools"`
  
grep for folders that contain Bottles.Tools

 `find source/packages -type d | sort -r | grep "Bottles\.Tools" | sed -n 1p` 
  
Only print the first line (-n 1p) so that the highest version number gets printed

 `find source/packages -type d | sort -r | grep "Bottles\.Tools" | sed -n 1p | xargs grep -rl "BottleRunner\.exe"` 
  
Recursively search that directory (-r) for for files named BottleRunner.exe and print out the file path (-l)

 `find source/packages -type d | sort -r | grep "Bottles\.Tools" | sed -n 1p | xargs grep -rl "BottleRunner\.exe" | sed -n 1p` 
  
Print the top line in case there is a config file BottleRunner.exe.config

``for exe in  `find source/packages -type d | sort -r | grep "Bottles\.Tools" | sed -n 1p | xargs grep -rl "BottleRunner\.exe" | sed -n 1p`; do $exe $@; done`` 
  
Throw that into a for loop so that I can delegate all of the arguments ($@) to the latest bottlerunner.exe

You can use that to delegate to other tools as well just change &#8220;Bottles.Tools&#8221; with the name of you nuget and BottleRunner.exe to the name of the exe you want.

Now I can safely run bottles from bash

`bottles create-all` 

So much WIN!

Don&#8217;t herp derp it, use my sweet script and avoid cmd.exe

-Ryan