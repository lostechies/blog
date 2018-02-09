---
wordpress_id: 4571
title: 'Look Ma! Real Proxies&#8230;'
date: 2008-12-03T21:57:03+00:00
author: Mo Khan
layout: post
wordpress_guid: /blogs/mokhan/archive/2008/12/03/look-ma-real-proxies.aspx
categories:
  - Design Patterns
redirect_from: "/blogs/mokhan/archive/2008/12/03/look-ma-real-proxies.aspx/"
---
I took some time today to pull down the source code for [SvnBridge](http://www.codeplex.com/SvnBridge) today, and man, I was blown away. I started at Program.cs and made it to line 25 Bootstrapper.Start(). From there I went on to look at the hand rolled container, then the ProxyFactory.

In order for me to fully grasp the System.Runtime.Remoting API for creating proxies I had to re-write the code from SVN Bridge&#8230;. I just had too&#8230; it&#8217;s just how I learn. It&#8217;s like tracing over cartoons when you&#8217;re a kid. I still do it!

In case you&#8217;re interested, the attached code is the sample I put together that is derived from the source code of SvnBridge. If you haven&#8217;t checked out the source for the project, you really should.

Pretty cool stuff&#8230;. Hopefully, this helps out anyone else who&#8217;s just as curious

[My reduced sample source code&#8230;](http://mokhan.ca/blog/content/binary/proxies.zip)</p> 

<div style="font-size: 13pt;background: white;color: black;font-family: courier new">
  <pre style="margin: 0px"><span style="color: blue">private</span> <span style="color: blue">static</span> <span style="color: blue">void</span> Main(<span style="color: blue">string</span>[] args)</pre>
  
  <pre style="margin: 0px">{</pre>
  
  <pre style="margin: 0px">&#160;&#160;&#160; <span style="color: blue">var</span> marshal_mathers = <span style="color: blue">new</span> <span style="color: #2b91af">Person</span>(<span style="color: #a31515">"marshall mathers"</span>);</pre>
  
  <pre style="margin: 0px">&#160;&#160;&#160; <span style="color: blue">var</span> some_celebrity = <span style="color: #2b91af">ProxyFactory</span>.Create&lt;<span style="color: #2b91af">IPerson</span>&gt;(marshal_mathers, <span style="color: blue">new</span> <span style="color: #2b91af">MyNameIsSlimShadyInterceptor</span>());</pre>
  
  <pre style="margin: 0px">&#160;</pre>
  
  <pre style="margin: 0px">&#160;&#160;&#160; <span style="color: blue">try</span></pre>
  
  <pre style="margin: 0px">&#160;&#160;&#160; {</pre>
  
  <pre style="margin: 0px">&#160;&#160;&#160;&#160;&#160;&#160;&#160; <span style="color: blue">var</span> name = some_celebrity.what_is_your_name();</pre>
  
  <pre style="margin: 0px">&#160;&#160;&#160;&#160;&#160;&#160;&#160; name.should_be_equal_to(<span style="color: #a31515">"slim shady"</span>);</pre>
  
  <pre style="margin: 0px">&#160;&#160;&#160; }</pre>
  
  <pre style="margin: 0px">&#160;&#160;&#160; <span style="color: blue">catch</span> (<span style="color: #2b91af">Exception</span> e)</pre>
  
  <pre style="margin: 0px">&#160;&#160;&#160; {</pre>
  
  <pre style="margin: 0px">&#160;&#160;&#160;&#160;&#160;&#160;&#160; <span style="color: #2b91af">Console</span>.Out.WriteLine(e);</pre>
  
  <pre style="margin: 0px">&#160;&#160;&#160; }</pre>
  
  <pre style="margin: 0px">&#160;&#160;&#160; <span style="color: #2b91af">Console</span>.Out.WriteLine(<span style="color: #a31515">"will the real slim shady please stand up..."</span>);</pre>
  
  <pre style="margin: 0px">&#160;&#160;&#160; <span style="color: #2b91af">Console</span>.In.ReadLine();</pre>
  
  <pre style="margin: 0px">}</pre>
</div>