---
wordpress_id: 4038
title: 'Pro Tip: Don&#8217;t co-opt .net conventions for your own purposes'
date: 2009-04-24T03:11:31+00:00
author: Scott Reynolds
layout: post
wordpress_guid: /blogs/scottcreynolds/archive/2009/04/24/pro-tip-don-t-co-opt-net-conventions-for-your-own-purposes.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/scottcreynolds/archive/2009/04/24/pro-tip-don-t-co-opt-net-conventions-for-your-own-purposes.aspx/"
---
Right. 

So it turns out that the visual studio/.net convention of assembly.extension.config for config files is NOT to be used for your own devices outside of visual studio. 

Example: 

Today I made an app called whatever.client.exe. It needed to read an xml file for some config, but I didn&#8217;t want to use Visual Studio to generate that config, and I didn&#8217;t want the Properties.Settings.Default stuff, for reasons beyond the scope of this post I just wanted to load the xml config file and parse it myself. 

Easiest way to do this I thought was name it whatever.client.exe.config and load it by looking at Application.ExecutablePath and appending a &#8220;.config&#8221;. 

No dice. Dropping a file with that name in the executing directory of the app caused the app to fail to launch with the message &#8220;&#8230;failed to start because its side by side configuration is incorrect&#8221;. Ok then. Even if you just create an xml named with that convention in the application directory, and don&#8217;t involve visual studio at all, it still dies. 

The fix is just name it something else of course, and everything is fine. Learn something new every day I guess. 

**Edit**

Ok so [Tomas Restrepo](http://twitter.com/tomasrestrepo/) was kind enough to point out that this is a OS convention that is just being used by .net, so it&#8217;s not .net app-specific. See [Here](http://msdn.microsoft.com/en-us/library/aa374182.aspx) for further information.

<!-- Technorati Tags Start -->

Technorati Tags:
  
<a href="http://technorati.com/tag/c%23" rel="tag">c#</a>, <a href="http://technorati.com/tag/visual%20studio%20.net" rel="tag">visual studio .net</a> 

<!-- Technorati Tags End -->