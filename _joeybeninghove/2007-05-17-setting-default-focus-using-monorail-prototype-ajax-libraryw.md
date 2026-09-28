---
wordpress_id: 10
title: Setting Default Focus Using MonoRail/Prototype Ajax Libraryw
date: 2007-05-17T13:03:40+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/05/17/setting-default-focus-using-monorail-prototype-ajax-libraryw.aspx
categories:
  - Castle
  - MonoRail
  - usability
  - Web
redirect_from: "/blogs/joeydotnet/archive/2007/05/17/setting-default-focus-using-monorail-prototype-ajax-libraryw.aspx/"
---
It&#8217;s the little things that make web applications a bit more user friendly.&nbsp; One of these very basic things is simply making sure that some element, ideally the most important one (i.e. search box, first data entry element, etc.), is set to have default focus when the page loads.&nbsp; Think about those precious seconds that would be lost if, when you browsed to Google.com, you had to set focus to the search box yourself.&nbsp; Ugh!&nbsp; 🙂&nbsp; (Some if this may be the keyboard-addict coming out in me&#8230;)

What makes this even worse, is that it&#8217;s really not that hard to do this in your pages.&nbsp; Here&#8217;s&nbsp;just one&nbsp;example of how I&#8217;m doing it on my current [MonoRail](http://castleproject.org/monorail/index.html) project using the fabulous [Prototype](http://www.prototypejs.org/) javascript library.

I&#8217;ve built a simple reusable &#8220;sub view&#8221; named&nbsp;defaultFocus.brail&nbsp;which can be called from any of my pages, passing in the id of the html element I want to have default focus.

**views/common/defaultFocus.brail**

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff"><</span><span style="color: #800000">script</span> <span style="color: #ff0000">type</span><span style="color: #0000ff">="text/javascript"</span><span style="color: #0000ff">></span>

<pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   1:</span>     Event.observe(window, <span style="color: #006080">'load'</span>, <span style="color: #0000ff">function</span>() { document.getElementById(<span style="color: #006080">'&lt;?brail output controlIdToFocus ?&gt;'</span>).focus(); });</pre>


<p>
  <span style="color: #0000ff"></</span><span style="color: #800000">script</span><span style="color: #0000ff">></span>
  </div>
  
  
  <p>
    So then, an example of this can be used in one of your views&#8230;
  </p>
  
  
  <p>
    <strong>views/home/index.brail</strong>
  </p>
  
  
  <div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
    <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
      <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   1:</span> <span style="color: #0000ff">&lt;?</span><span style="color: #800000">brail</span> <span style="color: #ff0000">OutputSubView</span>(<span style="color: #0000ff">'/common/defaultFocus'</span>, { <span style="color: #0000ff">'controlIdToFocus'</span><span style="color: #ff0000">:</span><span style="color: #0000ff">'searchCriteria'</span> }) ?<span style="color: #0000ff">&gt;</span></pre>
      
      
      <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   2:</span> <span style="color: #0000ff">&lt;</span><span style="color: #800000">input</span> <span style="color: #ff0000">type</span><span style="color: #0000ff">="text"</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="searchCriteria"</span> <span style="color: #ff0000">id</span><span style="color: #0000ff">="searchCriteria"</span> <span style="color: #0000ff">/&gt;</span></pre>
      
    </div>
    
  </div>
  
  
  <p>
    Pretty simply stuff.&nbsp; Yet you&#8217;d be surprised how many web applications and pages out there don&#8217;t do this!&nbsp; One example I just noticed today&nbsp;is in the Community Server blog dashboard in the &#8220;Tag Editor&#8221; dialog box.&nbsp; 
  </p>
  
  
  <p>
    <a title="cs_tageditor" href="http://www.flickr.com/photos/74595743@N00/502157032/"><img alt="cs_tageditor" src="http://static.flickr.com/211/502157032_ffd20947c7.jpg" border="0" /></a>
  </p>
  
  
  <p>
    This niftly little web dialog window has a jazzy slide down effect when it opens, but lacks a very basic thing such as setting the default focus to the &#8220;Name&#8221; input box.&nbsp; On a related note, if I&#8217;m adding a new tag, wouldn&#8217;t I want it to be enabled by default most of the time?&nbsp; Again, just a little thing&#8230;
  </p>
  
  
  <p>
    I&#8217;m certainly guilty of these things myself&nbsp;sometimes, but I&nbsp;just wanted to encourage folks (including myself)&nbsp;to be good web usability citizens and look for opportunities to make little enhancements like this that can make web applications that much easier to use.
  </p>
  
  
  <p>
    As usual, I&#8217;ve updated my <a href="http://code.google.com/p/joeydotnet/source">ongoing sample code library</a> to include these changes.
  </p>