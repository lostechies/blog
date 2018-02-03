---
wordpress_id: 3361
title: Zero Percent in Google Analytics Site Overlay
date: 2009-08-01T17:19:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/08/01/zero-percent-in-google-analytics-site-overlay.aspx
dsq_thread_id:
  - "277191700"
categories:
  - Analytics
---
I was recently looking at a Google Analytics Site Overlay (a very nice feature if you haven&#8217;t seen it before) and noticed that almost all links are showing up as 0% click-through. I know this couldn&#8217;t be the case because the the bounce rate for that page was 32.75%; the numbers just didn&#8217;t add up. After digging through some help pages, I found the following: (<http://www.google.com/support/googleanalytics/bin/answer.py?hl=en&answer=66982>)

<p style="padding-left: 30px">
  <b>Character Encoding</b><b></p> 
  
  <p>
    </b>We do not support characters from character sets other than<br /> UTF-8. If you have other character sets on your site, you may see<br /> garbage characters (usually empty boxes or question marks instead of<br /> the actual characters) in the report.
  </p>
  
  <p>
    Many of these URLs that contained (&) for the ampersand instead of the (&) which Google Analytics is much happier to see.
  </p>
  
  <p>
    &nbsp;
  </p>