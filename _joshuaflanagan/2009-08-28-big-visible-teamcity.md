---
wordpress_id: 3950
title: Big Visible TeamCity
date: 2009-08-28T20:00:34+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2009/08/28/big-visible-teamcity.aspx
dsq_thread_id:
  - "262735999"
categories:
  - greasemonkey
  - teamcity
redirect_from: "/blogs/joshuaflanagan/archive/2009/08/28/big-visible-teamcity.aspx/"
---
<a href="http://code.google.com/p/bigvisiblecruise/" target="_blank">Big Visible Cruise</a> is a cool utility for adding a build information radiator to your team room. It makes your Cruise Control build status immediately clear with a large green (good) or red (bad) screen. My (admittedly limited) search for an equivalent solution for <a href="http://www.jetbrains.com/teamcity/" target="_blank">JetBrains’ TeamCity</a> came up empty. TeamCity has a few built-in notification options, but none of them seemed to be the right fit. I toyed with many different possibilities, all of which would require more development or infrastructure than we wanted to allocate to the task. Luckily, we found a solution that cost us little time and requires very little deployment footprint.

On individual build configuration pages, there is an option to “enable status widget”. This makes the build status publicly available on your TeamCity server at http://<buildserver>/externalStatus.html. This is what it looks like when we expose the status of our two builds:

[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/joshuaflanagan/uploads/2011/03/image_thumb_5E1B5714.png" width="644" height="498" />](http://lostechies.com/content/joshuaflanagan/uploads/2011/03/image_1F29D679.png) 

Now, we can put that up on a big monitor for everyone to see, but I don’t think it “radiates” any information – you still need to purposefully read it. However, through the power of <a href="http://www.greasespot.net/" target="_blank">GreaseMonkey</a> and <a href="http://jquery.com/" target="_blank">jQuery</a>, we were able to modify that page to look like this:

[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/joshuaflanagan/uploads/2011/03/image_thumb_6008A61D.png" width="644" height="497" />](http://lostechies.com/content/joshuaflanagan/uploads/2011/03/image_21172582.png) 

Now, it is immediately clear to anyone in the room when one of our builds has a problem. The script also refreshes the page automatically every 15 seconds, which the default externalStatus.html page does not do.

You can easily recreate this using Firefox, the GreaseMonkey Add-on, and my <a href="http://code.google.com/p/pablo/source/browse/trunk/joshuaflanagan/bigvisibleteamcity/bigvisibleteamcity.user.js" target="_blank">bigvisibleteamcity.user.js</a> GreaseMonkey extension. If you aren’t familiar with GreaseMonkey, just install the add-on, then drag the *.user.js file onto your browser window, and you will be prompted to install it.

You will need to edit the bigvisibleteamcity.user.js file to change the URL in the @include line to refer to the externalStatus.html page on your server.

I didn’t spend a lot of time on the styling, but the hooks are there if you want to. If you are familiar with javascript, it should be clear in the source how to change the refresh time, or to add support for multiple rows of boxes, etc. Let me know if you make any cool changes.

Credit due to Dovetail cohorts <a href="http://www.lostechies.com/blogs/chad_myers/" target="_blank">Chad Myers</a> for the idea and <a href="http://blogs.dovetailsoftware.com/blogs/styson/" target="_blank">Sam Tyson</a> for bootstrapping me on GreaseMonkey scripting.