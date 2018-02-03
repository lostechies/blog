---
wordpress_id: 17
title: 'Unobtrusive JavaScript Part 2 &#8212; Separating Content, Style and Behavior'
date: 2008-11-03T14:39:44+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2008/11/03/unobtrusive-javascript-part-2-separating-content-style-and-behavior.aspx
dsq_thread_id:
  - "262055564"
categories:
  - Uncategorized
---
In my first post, I described some of the major principles that drive UJS style of development.&nbsp; In this article, I&#8217;m going into more detail about separating content from markup.

## The Bad Old Days

If you have been around long enough, you&#8217;ll remember the days when your only choices for making a web page look half way decent required using Font tags and inline attributes (and don&#8217;t forget my personal favorite, the Blink tag) to change the appearance of your content.&nbsp; If you wanted to have all of your headers to look the same, each one had to be styled manually.&nbsp; This also meant if you wanted to make a change, every one had to be updated.

The only real tool available for creating a layout was to abuse the <TABLE>.&nbsp; Nesting tables inside tables inside tables was the really only way to achieve anything more than text and images on the page.&nbsp; I&#8217;m not sure how many times I lost entire sections of content due to missing a closing row or cell tag.

Now that all of the major browser are CSS compliant-ish, these hacks are no longer necessary (I know there now a whole new set of CSS hacks).&nbsp; You can now remove all styling information from the HTML markup, leaving it to what is good at.&nbsp; Providing semantic meaning and structure to your documents and putting the style into a separate document that can be applied to all pages on your site.

## Semantic Markup

Now it is possible to remove everything from the html markup except for what is needed to fully describe the semantic meaning of the content.&nbsp; When using html for semantic purposes, you are describing the _function_ of the content, not it&#8217;s style or behavior.&nbsp; Here is an example of appearance driven markup:

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">&lt;</span><span style="color: #800000">br</span><span style="color: #0000ff">&gt;&lt;</span><span style="color: #800000">br</span><span style="color: #0000ff">&gt;</span>
<span style="color: #0000ff">&lt;</span><span style="color: #800000">b</span><span style="color: #0000ff">&gt;&lt;</span><span style="color: #800000">font</span> <span style="color: #ff0000">size</span><span style="color: #0000ff">="2"</span><span style="color: #0000ff">&gt;</span>Widget X<span style="color: #0000ff">&lt;/</span><span style="color: #800000">font</span><span style="color: #0000ff">&gt;&lt;/</span><span style="color: #800000">b</span><span style="color: #0000ff">&gt;</span>
<span style="color: #0000ff">&lt;</span><span style="color: #800000">br</span><span style="color: #0000ff">&gt;&lt;</span><span style="color: #800000">br</span><span style="color: #0000ff">&gt;</span>
<span style="color: #0000ff">&lt;</span><span style="color: #800000">font</span> <span style="color: #ff0000">size</span><span style="color: #0000ff">="1"</span><span style="color: #0000ff">&gt;</span>Widget X is the greatest things since sliced bread.<span style="color: #0000ff">&lt;/</span><span style="color: #800000">font</span><span style="color: #0000ff">&gt;</span></pre>
</div>

This looks something from circa 1998, when these were our only options for putting any kind of design on our web sites.&nbsp; Hard Line breaks are being created using the <br> tags, and the <font> tag is being used for styling the text.

Moving to a semantic only would look something like this:

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">&lt;</span><span style="color: #800000">div</span> <span style="color: #ff0000">id</span><span style="color: #0000ff">="widgetXContainter"</span><span style="color: #0000ff">&gt;</span>
<span style="color: #0000ff">&lt;</span><span style="color: #800000">h3</span><span style="color: #0000ff">&gt;</span>Widget X<span style="color: #0000ff">&lt;/</span><span style="color: #800000">h3</span><span style="color: #0000ff">&gt;</span>
<span style="color: #0000ff">&lt;</span><span style="color: #800000">p</span><span style="color: #0000ff">&gt;</span>Widget X is the greatest things since sliced bread.<span style="color: #0000ff">&lt;/</span><span style="color: #800000">p</span><span style="color: #0000ff">&gt;</span>
<span style="color: #0000ff">&lt;/</span><span style="color: #800000">div</span><span style="color: #0000ff">&gt;</span></pre>
</div>

Now the html is used purely to denote the differences in the meaning of the text.&nbsp; Using a <h3> and <p> tags to describe function, not it&#8217;s visual appearance.&nbsp; You know have free reign or the layout and appearance of the content.

## Separating Behavior from Content

When describing the behavior of web pages in the bad old days, we had the same problem.&nbsp; The only way to really safely attach an event was to do it on the the event attributes on the html itself.&nbsp; For instance, if you wanted to open a new window, it would look something like this:

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">&lt;</span><span style="color: #800000">a id="terms"</span> <span style="color: #ff0000">href</span><span style="color: #0000ff">="javascript:window.open('terms.html','popup‘,'height=500,width=400,toolbar=no’);"</span><span style="color: #0000ff">&gt;</span>
terms and conditions
<span style="color: #0000ff">&lt;/</span><span style="color: #800000">a</span><span style="color: #0000ff">&gt;</span></pre>
</div>

We are again mixing functionality within our html markup.&nbsp; We can clean this up a little bit by using the onclick event to denote what action should take place.

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">&lt;</span><span style="color: #800000">a <span style="color: #800000">id="terms"</span> </span> <span style="color: #ff0000">href</span><span style="color: #0000ff">="#"</span> <span style="color: #ff0000">onclick</span><span style="color: #0000ff">="window.open('terms.html','popup‘,'height=500,width=400,toolbar=no’);"</span><span style="color: #0000ff">&gt;</span>
terms and conditions
<span style="color: #0000ff">&lt;/</span><span style="color: #800000">a</span><span style="color: #0000ff">&gt;</span></pre>
</div>

This is better, but we still do not go anywhere without JavaScript and we are still embedding the functionality directly into the markup, mixing semantics with behavior and removing any chance of reuse and maintainability. We can take this one step further&nbsp; by removing the JavaScript from markup entirely and wire up the click event in the page onload event.&nbsp; I&#8217;ll use jQuery for wiring up the event.&nbsp; Also, by defining a url for the link, you ensure that functionality will work regardless of the availability of JavaScript.

&nbsp;

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">&lt;</span><span style="color: #800000">a</span> <span style="color: #ff0000">id</span><span style="color: #0000ff">="terms"</span> <span style="color: #ff0000">href</span><span style="color: #0000ff">="terms.html"</span><span style="color: #0000ff">&gt;</span>terms and conditions<span style="color: #0000ff">&lt;/</span><span style="color: #800000">a</span><span style="color: #0000ff">&gt;</span>
</pre>
</div>

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;height: 252px;background-color: #f4f4f4">
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;height: 227px;background-color: #f4f4f4;border-bottom-style: none">&lt;script&gt;
<span style="color: #008000">//onload event</span>
$(document).ready(<span style="color: #0000ff">function</span>(){
    <span style="color: #008000">//get a reference to the link using the css id selector syntax </span>
    <span style="color: #008000">//and attach the click event</span>
    $(<span style="color: #006080">'#terms'</span>).click(<span style="color: #0000ff">function</span>(){
        window.open(<span style="color: #006080">'terms.html'</span>,<span style="color: #006080">'popup‘,'</span>height=500,width=400,toolbar=no’);
        <span style="color: #008000">// keep the link from firing</span>
        <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>;
    })
});

&lt;/script&gt;</pre>
</div>

&nbsp;

Now we have achieved our goals.&nbsp; We separated the behavior from the markup, allowing us to create more modular, reusable scripts (with a little refactoring).&nbsp; The behavior of the link will work regardless of the functionality of the browser and user configuration. You can also take this one step further by putting the behavior in a separate JavaScript file, allowing the browser to cache the content and further speed up the page load time.

In the next part, I&#8217;ll talk more about [progressive enhancement](http://en.wikipedia.org/wiki/Progressive_enhancement) and how to incorporate that into your web pages.