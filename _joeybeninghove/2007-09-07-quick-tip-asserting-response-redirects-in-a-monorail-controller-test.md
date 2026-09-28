---
wordpress_id: 25
title: 'Quick Tip: Asserting response redirects in a MonoRail controller test'
date: 2007-09-07T22:16:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/09/07/quick-tip-asserting-response-redirects-in-a-monorail-controller-test.aspx
categories:
  - Castle
  - MonoRail
  - TDD
  - Web
redirect_from: "/blogs/joeydotnet/archive/2007/09/07/quick-tip-asserting-response-redirects-in-a-monorail-controller-test.aspx/"
---
Reading [this post](http://schambers.wordpress.com/2007/09/04/testing-monorail-controllers-from-castles-trunk/trackback/) by [Sean](http://schambers.wordpress.com/) reminded me of when I first started using the trunk&#8217;s BaseControllerTest.&nbsp; One nifty little property on the base test controller&#8217;s mock Response object is **RedirectedTo**.&nbsp; So you can do something like this:

<div style="border: 1px solid gray;margin: 20px 0px 10px;padding: 4px;overflow: auto;font-size: 8pt;width: 97.5%;cursor: text;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #606060">   1:</span> <span style="color: #008000">// some call on the controller that should do the redirect</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4"><span style="color: #606060">   2:</span> Assert.AreEqual(<span style="color: #006080">"/productSearch/performSearch.rails"</span>, Response.RedirectedTo);</pre>
  </div>
</div>

In previous MonoRail projects, I used the very nice base class from the guys at [Eleutian](http://blog.eleutian.com/) and it worked great.&nbsp; But I&#8217;ve been using the trunk&#8217;s BaseControllerTest exclusively on my current project since it started a few months ago and it rocks as well.&nbsp; Nice to have it &#8220;out of the box&#8221; now.