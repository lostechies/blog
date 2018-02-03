---
wordpress_id: 16
title: How-To add a custom validation method to the jQuery validator plug-in
date: 2009-03-10T06:53:35+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2009/03/10/how-to-add-a-custom-validation-method-to-the-jquery-validator-plug-in.aspx
dsq_thread_id:
  - "264788330"
dsq_needs_sync:
  - "1"
categories:
  - JQuery
  - Validation
---
For my current project I needed a custom **validator** method for the **[jQuery](http://jquery.com/)** [validator](http://bassistance.de/jquery-plugins/jquery-plugin-validation/) plug-in. I wanted to validate that a user has chosen a value from a combo box where the value is of type **Guid**.

First I implemented a **JavaScript** function which tests whether a given value represent a valid Guid but not an empty Guid (An empty Guid has the following form: 00000000-0000-0000-0000-000000000000). To achieve this result I use regular expressions

<div>
  <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #0000ff">var</span> isValidGuid = <span style="color: #0000ff">function</span>(value) {</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">  <span style="color: #0000ff">var</span> validGuid = /^({|()?[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}(}|))?$/;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">  <span style="color: #0000ff">var</span> emptyGuid = /^({|()?0{8}-(0{4}-){3}0{12}(}|))?$/;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">  <span style="color: #0000ff">return</span> validGuid.test(value) && !emptyGuid.test(value);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">}</pre>
  </div>
</div>

The above function returns true for a valid Guid and false for every thing else.

Now I have to add this validation method to the [validator](http://bassistance.de/jquery-plugins/jquery-plugin-validation/) plug-in as follows

<div>
  <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">$.validator.addMethod(<span style="color: #006080">"isValidGuid"</span>, <span style="color: #0000ff">function</span>(value, element) {</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">  <span style="color: #0000ff">return</span> isValidGuid(value);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">}, <span style="color: #006080">'Please select a valid and non empty Guid value.'</span>);</pre>
  </div>
</div>

Finally I can use this custom validation method on any form element by assigning it the class **isValidGuid**, e.g.

<div>
  <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">&lt;select id=<span style="color: #006080">"title"</span> <span style="color: #0000ff">class</span>=<span style="color: #006080">"isValidGuid"</span> title=<span style="color: #006080">"Please select a title!"</span>&gt;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">  &lt;option value=<span style="color: #006080">"00000000-0000-0000-0000-000000000000"</span> selected=<span style="color: #006080">"selected"</span>&gt;(select)&lt;/option&gt;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">  &lt;option value=<span style="color: #006080">"33a1eb15-cdbc-4c85-be01-dcb4f393c0a5"</span>&gt;Engineer&lt;/option&gt;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">  &lt;option value=<span style="color: #006080">"43b5d0f7-4915-41f1-b3b9-d6335299cc22"</span>&gt;Physicist&lt;/option&gt;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">  &lt;option value=<span style="color: #006080">"d80322f2-bb76-447c-a6ac-77f145bac70d"</span>&gt;Technician&lt;/option&gt;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">&lt;/select&gt;          </pre>
  </div>
</div>

when applied we have the following outcome

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="94" alt="image" src="http://lostechies.com/gabrielschenker/files/2011/03/image_thumb_1.png" width="346" border="0" />](http://lostechies.com/gabrielschenker/files/2011/03/image_4.png)