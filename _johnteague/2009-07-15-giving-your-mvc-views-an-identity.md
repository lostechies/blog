---
wordpress_id: 33
title: Giving Your MVC Views an Identity
date: 2009-07-15T05:01:00+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2009/07/15/giving-your-mvc-views-an-identity.aspx
dsq_thread_id:
  - "262055685"
categories:
  - CSS
  - MVC
---
One of the great CSS tips I got from [Zen of CSS](http://bit.ly/19HYXY) was to put an id on the body tag of your html pages.&nbsp; This makes it really easy to use one CSS file for your entire site (a optimization trick) and allow you to target elements on specific page easily without creating a lot of unnecessary content wrappers or bogey class names.&nbsp; 

It is also very simple thing to do on MVC sites. Using the convention of Controller+Action give an easy identifier (if you&rsquo;re using areas or something else you will need to tweak this a little).&nbsp; This simple extension method does all the work for you.

&nbsp;

<div style="padding: 5px;width: 859px;float: none;margin-left: auto;margin-right: auto" class="wlWriterEditableSmartContent">
  <div style="border: #000080 1px solid;font-family: 'Courier New', Courier, Monospace;font-size: 10pt">
    <div style="background-color: #ffffff;overflow: scroll;padding: 2px 5px">
      <p>
        <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">class</span> <span style="color: #2b91af">MasterPageExtensions</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;{<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">string</span> BuildPageIdentifier(<span style="color: #0000ff">this</span> <span style="color: #2b91af">ViewMasterPage</span> masterPage,&nbsp;&nbsp;<span style="color: #2b91af">ViewContext</span> context)<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{
      </p>
      
      <p>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">return</span> <span style="color: #0000ff">string</span>.Format(<span style="color: #a31515">&#8220;{0}-{1}&#8221;</span>, context.RouteData.Values[<span style="color: #a31515">&#8220;controller&#8221;</span>],context.RouteData.Values[<span style="color: #a31515">&#8220;action&#8221;</span>]);<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br /> &nbsp;&nbsp;&nbsp;&nbsp;
      </p>
    </div>
  </div>
</div>

Now just add this to your MasterPage. 

&nbsp;

<div style="padding: 5px;width: 859px;float: none;margin-left: auto;margin-right: auto" class="wlWriterEditableSmartContent">
  <div style="border: #000080 1px solid;font-family: 'Courier New', Courier, Monospace;font-size: 10pt">
    <div style="background-color: #ffffff;overflow: scroll;padding: 2px 5px">
      <p>
        <span style="color: #0000ff"><</span><span style="color: #a31515">body</span> <span style="color: #ff0000">id</span><span style="color: #0000ff">=&#8221;</span><span style="background:#ffee62"><%</span><span>= this.BuildPageIdentifier(this.ViewContext)</span><span style="background:#ffee62">%></span><span style="color: #0000ff">&#8220;><br /> </span>
      </p>
    </div>
  </div>
</div>

It will create html that looks like this.

<body id=&rdquo;Resident-Edit&rdquo;>

Now you can write CSS like this to target specific pages on your site.

&nbsp;

&nbsp;

<div style="padding: 5px;width: 859px;float: none;margin-left: auto;margin-right: auto" class="wlWriterEditableSmartContent">
  <div style="border: #000080 1px solid;font-family: 'Courier New', Courier, Monospace;font-size: 10pt">
    <div style="background-color: #ffffff;overflow: scroll;padding: 2px 5px">
      <p>
        <span style="color: #a31515">#Resident-Edit</span> <span style="color: #a31515">#VolumeLevel</span> { <span style="color: #ff0000">display</span>:<span style="color: #0000ff">block</span>; <span style="color: #ff0000">margin-bottom</span>:<span style="color: #0000ff">.8em</span>; }
      </p>
    </div>
  </div>
</div>