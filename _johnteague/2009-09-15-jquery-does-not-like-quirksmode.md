---
id: 38
title: JQuery Does Not Like QuirksMode
date: 2009-09-15T03:21:26+00:00
author: John Teague
layout: post
guid: /blogs/johnteague/archive/2009/09/14/jquery-does-not-like-quirksmode.aspx
dsq_thread_id:
  - "262055728"
categories:
  - JavaScript
  - JQuery
---
I was helping a client out today with a JQuery issue. They were well into the development of an applications that heavily uses the JQuery UI dialog widget to show information.&#160; Like most web developers they were using Firefox/Firebug for day-to-day development (because trying to develop complicated apps with IE is painful).&#160; All of their dialog windows were working normally with an acceptable load time.

However, when they started testing in IE, the dialogs screens were painfully slow.&#160; Less than a second in Firefox was now 4+ seconds on IE.&#160; We stripped it down to just a simple dialog, do nothing but displaying a div with some text and still taking a long time.&#160; At this point I knew it was something inside JQuery that was causing it.&#160; I didn’t think it was a bug because I’ve used them plenty of times cross browser with not problems.&#160; The team further drilled into the jQuery code that was taking so long using a profiler.&#160; There was some code that looked like this (not all of it)

<div style="padding-bottom: 5px;padding-left: 5px;width: 779px;padding-right: 5px;float: none;margin-left: auto;margin-right: auto;padding-top: 5px" class="wlWriterEditableSmartContent">
  <div style="border: #000080 1px solid;font-family: 'Courier New', Courier, Monospace;font-size: 10pt">
    <div style="background-color: #000000;overflow: scroll;padding: 2px 5px">
      <p>
        <span style="background:#000000;color:#ff8000">return</span><span style="color:#ffffff"> </span><span style="color:#ff8000">this</span><span style="color:#ffffff">[0] == window ?<br />             </span><span style="color:#00ff00">// Everyone else use document.documentElement or document.body depending on Quirks vs Standards mode<br /> </span><span style="color:#ffffff">            document.compatMode == </span><span style="color:#00ff00">&#8220;CSS1Compat&#8221;</span><span style="color:#ffffff"> && document.documentElement[ </span><span style="color:#00ff00">&#8220;client&#8221;</span><span style="color:#ffffff"> + name ] ||<br />             document.body[ </span><span style="color:#00ff00">&#8220;client&#8221;</span><span style="color:#ffffff"> + name ] :</span>
      </p>
    </div>
  </div>
</div>

document.CompatMode returns two values: “CSS1Compat” when in compatibility mode and “BackCompat” when in quirks mode. 

So, jQuery does something different in quirksmode than compatibility mode.&#160; A quick check determined the page was being rendered in quirks mode, which forced jQuery to use some less than optimal approaches to modifying the dome elements.&#160; I always knew this was the case, but I didn’t expect it to be 4 seconds of difference!!

This can be avoided by specifying the [DOCTYPE](http://www.w3schools.com/Xhtml/xhtml_dtd.asp) for your pages.&#160; Apparently the team did look into this, but they had a comment before the doctype declaration and it **must be the first line** or it will be ignored by the browser, guaranteeing quirks mode in IE.

I’m sure that jQuery makes this type of check all over the place, so if you are targeting Internet Explorer I would stay in compatibility mode.