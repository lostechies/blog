---
id: 139
title: Combining Modules in Require.js
date: 2012-12-14T15:44:07+00:00
author: John Teague
layout: post
guid: http://lostechies.com/johnteague/?p=139
dsq_thread_id:
  - "974424422"
categories:
  - Uncategorized
---
Here&#8217;s a quick tip that I learned today the hard way, because it&#8217;s actually in the [documentation](http://requirejs.org/docs/whyamd.html#sugar).

In one of my projects, I&#8217;ve got a bunch of commands that I want to attach to an event based on what menu item is selected.  My app object listens for menu events and then wires up the command based on the selected menu item.  My first version looked like this:

[gist id=4286282 bump=12]

This is module definition is obviously going to get very messy as I add more available commands.  The solution was to create a new module to combine all of the commands and use a different variation on the module definition, where you&#8217;re only dependency is require itself.

[gist id=4288585]

Now I can simplify my app module to look like this

[gist id=4288549]

<div>
</div>