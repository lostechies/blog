---
wordpress_id: 57
title: Introducing ActiveSupport.NET
date: 2008-02-07T19:20:52+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2008/02/07/introducing-activesupport-net.aspx
categories:
  - 'C#'
  - Rails
  - Ruby
redirect_from: "/blogs/joeydotnet/archive/2008/02/07/introducing-activesupport-net.aspx/"
---
To my surprise, none of my googling seemed to come up with anyone doing this.&nbsp; So I figured I&#8217;d start it off (please let me know if you know of any other efforts already underway).&nbsp; As some would say, taking [extension method abuse](http://codebetter.com/blogs/david.hayden/archive/2007/03/28/Extension-Methods-in-C_2300_-3.0---Shiny-New-Hammer-Looking-for-a-Nail-_3A002900_.aspx) to a whole new level.&nbsp; 😀&nbsp; But, I see these little utility methods to be a good fit as extensions methods to make the syntactic sugar that much sweeter.

One of the many great things about working in Rails is the core extensions in the [ActiveSupport](http://api.rubyonrails.org/) library.&nbsp; It just \*becomes\* part of the Ruby language as you work with Rails.&nbsp; And I wanted to get that same feeling when working in C#.&nbsp; So this is my attempt to start porting over the core extensions from Ruby&#8217;s ActiveSupport Library.

So far I&#8217;ve just ported over a few string access and conversion extensions, but check &#8217;em out and let me know if you&#8217;d find something like this to be useful.&nbsp; Here are some examples of what&#8217;s currently supported&#8230;

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060"> 1:</span> <span style="color: #008000">// some accessors</span></pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060"> 2:</span> <span style="color: #006080">"blah"</span>.At(2) <span style="color: #008000">// 'a'</span></pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060"> 3:</span> <span style="color: #006080">"blah"</span>.First() <span style="color: #008000">// 'b'</span></pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060"> 4:</span> <span style="color: #006080">"blah"</span>.First(2) <span style="color: #008000">// "bl"</span></pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060"> 5:</span> <span style="color: #006080">"blah"</span>.From(1) <span style="color: #008000">// "lah"</span></pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060"> 6:</span> <span style="color: #006080">"blah"</span>.Last() <span style="color: #008000">// 'h'</span></pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060"> 7:</span> <span style="color: #006080">"blah"</span>.Last(2) <span style="color: #008000">// "ah"</span></pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060"> 8:</span> <span style="color: #006080">"blah"</span>.To(2) <span style="color: #008000">// "bla"</span></pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060"> 9:</span>&nbsp; </pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060"> 10:</span> <span style="color: #008000">// couple simple conversions (still needs lots of work)</span></pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060"> 11:</span> <span style="color: #006080">"1/4/2008"</span>.ToDate() <span style="color: #008000">// DateTime</span></pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060"> 12:</span> <span style="color: #006080">"01:15:35"</span>.ToTime() <span style="color: #008000">// DateTime</span></pre>
  </div>
</div>

You can grab the source at its [google code repository](http://code.google.com/p/activesupportnet/source/checkout).&nbsp; You can just do a &#8220;build test&#8221; from a command line in the trunk to run the unit test suite.

Enjoy.&nbsp; 🙂