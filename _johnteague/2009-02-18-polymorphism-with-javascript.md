---
wordpress_id: 24
title: Polymorphism with JavaScript
date: 2009-02-18T05:20:12+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2009/02/18/polymorphism-with-javascript.aspx
dsq_thread_id:
  - "262055598"
categories:
  - JavaScript
---
I don’t know if I picked this line up in a book or somewhere else, but the best way to describe the JavaScript language is schizophrenic.&#160; The language itself (regardless of the hosting environment) doesn’t know if it’s Object Oriented or Functional.&#160; It’s always been my opinion that the functional aspects of the language are more powerful than the OO features, yet the least used.&#160; This is probably my most classically trained OOP developers don’t really like JavaScript. The other reason is because most classically trained OOP developers coming from .Net and Java ( myself included) also forget that JavaScript is also a _dynamic_ language.&#160; So we try to get the language do things statically as we would expect other “grown up” languages to do.

This is why a lot JavaScript libraries try to add additional layers on top of the language to make it feel more like a static language.&#160;&#160; Polymorphism is one of those features we expect from an Object Oriented language, yet the language itself doesn’t directly support this the way we expect it to (there are workarounds, but I’m not going into those).&#160; But when you remember that JavaScript is dynamic, it become remarkably easy.

In our current project, we are using JQuery to make modifications to a legacy web application, where we REALLY don’t want to work on the server-side logic.&#160; In this app we have two form that are exactly the same (for our purposes at least) except for one little detail.&#160; On one page, a critical piece of information is in a drop down list, while on the other page, it just static html content.&#160; So we need a little polymorphic behavior here, to retrieve this information differently.

To start with, we are using the [Module Pattern](http://yuiblog.com/blog/2007/06/12/module-pattern/) to both contain our public methods in a single scope and to hide some of our methods from the public api.&#160; So we exposed a method in our return object that we expect to override.

&#160;

<div>
  <pre><span style="color: #0000ff">var</span> module = <span style="color: #0000ff">function</span>(){
 <span style="color: #008000">// private methods</span>
 <span style="color: #008000">//return object that has our public methods</span>
 <span style="color: #0000ff">return</span>{
   getImportantField: <span style="color: #0000ff">function</span>(){ alert(<span style="color: #006080">"this method is not implement, write your own"</span>}
 }
}();</pre>
</div>

&#160;

On the page where we need to get this from the drop down list, we include these script files:

&#160;

<pre><span class="kwrd">&lt;</span><span class="html">script</span> <span class="attr">type</span><span class="kwrd">="text/javascript"</span> <span class="attr">src</span><span class="kwrd">="Module.js"</span><span class="kwrd">&gt;&lt;/</span><span class="html">script</span><span class="kwrd">&gt;</span>
&lt;script type=<span class="str">"text/javascript"</span> src=<span class="str">"GetImportantFieldFromDropDown.js"</span>&gt;<span class="kwrd">&lt;/</span><span class="html">script</span><span class="kwrd">&gt;</span></pre>

Now we can change the behavior of our method my replacing it at runtime.

<div>
  <pre>module.getImportantField = <span style="color: #0000ff">function</span>(){
    <span style="color: #008000">//access the field via the drop down</span>
}</pre>
</div>

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

And on the page where we need it from the text, we’ll include another file that changes the behavior of the method in question

<pre><span class="kwrd">&lt;</span><span class="html">script</span> <span class="attr">type</span><span class="kwrd">="text/javascript"</span> <span class="attr">src</span><span class="kwrd">="Module.js"</span><span class="kwrd">&gt;&lt;/</span><span class="html">script</span><span class="kwrd">&gt;</span> 
&lt;script type=<span class="str">"text/javascript"</span> src=<span class="str">"GetImportantFieldFromDropDown.js"</span>&gt;<span class="kwrd">&lt;/</span><span class="html">script</span><span class="kwrd">&gt;</span> </pre></p> 

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

And of course change the behavior appropriately:

&#160;

<div>
  <pre>module.getImportantField = <span class="kwrd">function</span>(){
    <span class="rem">//access the field via the html text</span>
}</pre>
</div>

This approach takes advantage of the fact that browsers load source files in the order in which they are listed.&#160; Also the fact that JavaScript treats methods like variables and you can replace their value at any time.&#160; This opens up many new opportunities for structuring your code in dynamic languages that are not possible with static languages. Yes I know you can do similar things with delegates in C#, but you get my point.&#160; I’m still learning what is possible with dynamic languages and utilize that to its fullest extent.&#160;