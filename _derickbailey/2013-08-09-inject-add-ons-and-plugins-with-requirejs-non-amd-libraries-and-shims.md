---
wordpress_id: 1142
title: Inject Add-Ons And Plugins With RequireJS, Non-AMD Libraries And Shims
date: 2013-08-09T11:22:03+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1142
dsq_thread_id:
  - "1589566127"
categories:
  - JavaScript
  - requirejs
---
I&#8217;m using a few libraries that don&#8217;t have official support for AMD, in my current project with RequireJS. No problem &#8211; just shim the library in, and it&#8217;s good to go. Some of these libraries also need some add-ons and plugins, though&#8230; and there aren&#8217;t necessarily official hooks for the add-ons, either. So I find myself in this situation: I need a non-AMD library with non-AMD add-ons, loaded through a single require statement in my module. What to do?

## Named Dependencies

In your app configuration for RequireJS, you can name dependencies to make it easier to load them later. I do this for my 3rd party libraries and other common things in the app. 

Example:

[gist file=1.js id=6195292]

I&#8217;ve named &#8220;jquery&#8221;, &#8220;rsvp&#8221;, &#8220;kendoui&#8221; and &#8220;thatCoolLib&#8221; (a made up example name for this post) here, so that I don&#8217;t have to load them by the full path, later.

Now I can include these libs in my other modules with just the name.

[gist file=3.js id=6195292]

Now let&#8217;s say that I now want to load an add-on for thatCoolLib, by including yet another file in the project. Perhaps I want to add a new function to an existing prototype from that library. How do I do that?

## Hijacking The Named Dependencies

Say I&#8217;ve got this awesome plugin for thatCoolLib:

[gist file=2.js id=6195292]

I want to get this loaded in to the library whenever I require &#8220;thatCoolLib&#8221;, but I don&#8217;t want to specify yet another dependency in my modules. I just want this add-on to be available, always.  To do that, I can hijack the named dependencies, and compose the modified version of thatCoolLib at runtime.

Rename the current &#8220;thatCoolLib&#8221; in the requirejs config, to &#8220;thatCoolLib.original&#8221; or any other name that would say this is the original version. Keep it pointing to the same file, though &#8211; just change the name.

Now add another named dependency, called &#8220;thatCoolLib&#8221; &#8211; yes, the name that you just changed &#8211; and point it to a new file. In this case, I&#8217;ll point it to &#8220;vendor/thatCoolLib.bootstrap&#8221;. 

[gist file=4.js id=6195292]

Create the &#8220;thatCoolLib.boostrap.js&#8221; file, next. Add a standard AMD module to it, and require the &#8220;thatCoolLib.original&#8221; in to the module. Now you can modify the original object with your add-on code, and then return thatCoolLib from your new module. You can even include other external files, and attach the functions to the library inside of this module.

[gist file=5.js id=6195292]

## New Behavior Without Modifying The Rest Of The App

Now when any part of your app requires &#8220;thatCoolLib&#8221; in to a module, it will get the new behavior from the plugins. But the best part, here, is that any existing use of &#8220;thatCoolLib&#8221; will also have the new behavior available, without having to change any of the dependencies, or any any new dependencies, in the existing modules.