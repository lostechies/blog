---
id: 118
title: 'The *nix Rube Goldberg Machine &#8211; find/grep/vim'
date: 2012-03-22T21:39:02+00:00
author: Ryan Rauh
layout: post
guid: http://lostechies.com/ryanrauh/?p=118
dsq_thread_id:
  - "621120827"
categories:
  - Uncategorized
---
# Learn your shell! 

## Piping grep into grep 

![Yo Dawg](http://cdn.memegenerator.net/instances/400x/16865380.jpg)

I was spelunking my .bash_history and came across this little piece of awesome.

 `~/lecode> find source/ -type f | grep -v " " | xargs grep this\.Asset.* | grep dovetail | grep -v .*\.css | grep -v dovetail\/dovetail | cut -d \: -f 1 | xargs gvim` 

Wow! So what the heck was I doing there? Lets walk through it.

So I&#8217;ve got a problem&#8230; I am OCD about where asset files are located in our project. It&#8217;s a complete mess and every time I complain about it&#8230;

<blockquote style="overflow:hidden;">
  <p>
    <img src="http://cl.ly/3b1n2i321K1H0h3p2N3G/trollface.jpg" width="64px" style="float:left;padding:0;margin:5px;" /> &#8220;It will be too hard to go through the app and change all the paths&#8230;&#8221;
  </p>
</blockquote>

![guise... srsly](http://28.media.tumblr.com/tumblr_lhgjim2jYx1qbiuveo1_400.gif)

<blockquote style="overflow:hidden;">
  <p>
    <img src="http://www.gravatar.com/avatar/29283ede6c447fdc62f0ceac42df33ea?s=64" width="64px" style="float:right;padding:0;margin:5px;" /> &#8220;You under estimate my command line awesome-itude!&#8221;
  </p>
</blockquote>

Turns out its not that hard of a problem, let me break it down. All of our asset imports are abstracted out into an extension method we call from our view

 `<% this.Asset("myasset"); %>` 

Perfect so I have something consistent to grep for

 `~/lecode> find source/ -type f` 
  
Find all the files in the source directory

 `~/lecode> find source/ -type f | grep -v " "` 
  
Pipe that into grep and inverse match any path with a space (-v)

 `~/lecode> find source/ -type f | grep -v " " | xargs grep this\.Asset.*` 
  
xargs that path into grep and search each file for any lines containing \`this.Asset*\`

 `~/lecode> find source/ -type f | grep -v " " | xargs grep this\.Asset.* | grep dovetail` 
  
I only care about asset calls that contain dovetail

 `~/lecode> find source/ -type f | grep -v " " | xargs grep this\.Asset.* | grep dovetail | grep -v .*\.css` 
  
Inverse grep (-v) any lines containing .css

 `~/lecode> find source/ -type f | grep -v " " | xargs grep this\.Asset.* | grep dovetail | grep -v .*\.css | grep -v dovetail\/dovetail` 

<img width="550px" src="http://f.cl.ly/items/3s2s093G3U1d0L22171C/Image%202012-03-22%20at%203.52.27%20PM.png" alt="console output" />
  
Inverse grep (-v) assets that start with dovetail/dovetail because those are correct.

 `~/lecode> find source/ -type f | grep -v " " | xargs grep this\.Asset.* | grep dovetail | grep -v .*\.css | grep -v dovetail\/dovetail | cut -d \: -f 1` 

Notice how grep outputs the file path and then the match. We can use cut to parse the output on the &#8220;:&#8221; (-d \:) and take the first column (-f 1)

<img width="550px" src="http://f.cl.ly/items/2I2W0s1d1X0k3K1u3n3L/Image%202012-03-22%20at%203.56.32%20PM.png" alt="console output" />

 `~/lecode> find source/ -type f | grep -v " " | xargs grep this\.Asset.* | grep dovetail | grep -v .*\.css | grep -v dovetail\/dovetail | cut -d \: -f 1 | xargs gvim` 
  
Now I have my file names, xargs that into gvim and it loads up a new instance of gvim with all the files I need to change in a buffer list. Now I can make my change and :bnext (buffer next) to the next file.

<blockquote style="overflow:hidden;">
  <p>
    <img src="http://f.cl.ly/items/2v0x1U0d1p2L0z1g2u1N/clippy.gif" width="64px" style="float:left;padding:0;margin:5px;" /> &#8220;It looks like you are trying to change a bunch of files&#8230; Want to use find and replace?&#8221;
  </p>
</blockquote>

<blockquote style="overflow:hidden;">
  <p>
    <img src="http://www.gravatar.com/avatar/29283ede6c447fdc62f0ceac42df33ea?s=64" width="64px" style="float:right;padding:0;margin:5px;" /> &#8220;Shut up troll!&#8221;
  </p>
</blockquote>

Deeerp
  
-Ryan