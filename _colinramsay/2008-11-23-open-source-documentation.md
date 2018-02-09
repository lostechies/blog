---
wordpress_id: 4689
title: Open Source Documentation
date: 2008-11-23T15:49:00+00:00
author: Colin Ramsay
layout: post
wordpress_guid: /blogs/colin_ramsay/archive/2008/11/23/open-source-documentation.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/colin_ramsay/archive/2008/11/23/open-source-documentation.aspx/"
---
Recently I&#8217;ve set up a network attached storage computer on my home network. As well as providing RAID storage for all the devices in the house, it acts as a central download server for everyone to use. Key to this strategy is [SABnzbd](http://www.sabnzbd.org/), a Python application which downloads binaries from newsgroups, and which sits on the server as a daemon, grabbing files on a schedule or when we ask it to. The functionality of this software is incredible, but more than that, there is a great deal of documentation for each feature directly linked from the web interface. This enabled me to set up advanced features such as RSS feeds, categorisation, and post-download scripts, in order to shift SABnzbd from being handy to indispensible.

This post is not about SABnzbd though &#8211; it&#8217;s about documentation. My latest project has been a very quick CMS solution using Monorail, and I&#8217;ve been taking advantage of the new features available in Castle&#8217;s trunk. The new routing in Monorail, the fluent API for component registration in Microkernel, and more new features, have all been making my life easier&#8230; once I&#8217;ve figured them out. I&#8217;m in awe of the people who have produced these features and I&#8217;m not adverse to digging round test cases where I can, in order to find out how to use them. 

However, it would unarguably be better if the Castle documentation reflected these new changes. It&#8217;s understandable that the documention lags behind these features, and since I don&#8217;t have the intimate Castle knowledge needed to contribute to fixing bugs or adding new code, I figured it&#8217;d be good to try and work on this documentation. Castle uses an [XML based documentation format](http://castleproject.org/community/getinvolved.html#documentation) which is just fine for final docs, but not that great for scrabbling down notes and filling out information. For that, I&#8217;ve decided to use the using.castleproject.org wiki, a site designed to hold tips and tricks for the Castle Project.

I&#8217;ve set up a [simple system of tagging](http://using.castleproject.org/display/CASTLE/Helping+With+Documentation) which allows people to search out stuff in need of documentation and then tag it when it&#8217;s complete. At that point, I plan on converting it into a patch for the official Castle documentation. In this way we can get the rapid prototyping of a wiki combined with an easy route to formal documentation. I think barrier for entry is a definite problem for contributing on many projects, and documentation can be a good place to start. For Castle, I&#8217;m trying to make even the barrier for entry for even that documentation very low. So if you can help out with the [routing documentation](http://using.castleproject.org/display/MR/Routing+Overview) or the [validation documentation](http://using.castleproject.org/display/MR/Monorail+Validation) or anything else that&#8217;s missing or incomplete in the [main Castle docs](http://castleproject.org/), please pitch in and try and help! 

(Also published on [my personal blog](http://colinramsay.co.uk/diary/2008/11/23/open-source-documentationopen-source-documentation/))