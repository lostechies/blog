---
wordpress_id: 39
title: Making JavaScript APIs Easier to Use
date: 2009-09-16T04:21:00+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2009/09/16/proper-javascript-api-design.aspx
dsq_thread_id:
  - "262055730"
categories:
  - Uncategorized
---
Todd Anglin presented some of the AJAX functionality available in ASP.Net 4.0 at this months [ADNUG](http://adnug.org) meeting.&nbsp; One of the things he demonstrated was the Client Side binding, which is really cool (I&rsquo;ll have more on this later).&nbsp; In one of his code samples, he showed how the MS AJAX library call to bind an element to a datasource.&nbsp; It looked odd to me at first and and I couldn&rsquo;t figure out why at first.&nbsp; Then on the way home, I realized that it designed completely wrong for a JavaScript function.&nbsp; The function call looked something like this (I may not get this syntax completely right,it&rsquo;s just an example, please don&rsquo;t sweat the details).

<div style="padding: 5px;width: 779px;float: none;margin-left: auto;margin-right: auto" class="wlWriterEditableSmartContent">
  <div style="border: #000080 1px solid;font-family: 'Courier New', Courier, Monospace;font-size: 10pt">
    <div style="background-color: #000000;overflow: scroll;padding: 2px 5px">
      <p>
        <span style="background: #000000 none repeat scroll 0% 0%;color: #ffffff">$create(Sys.Data.DataView, {}, {}, $get(</span><span style="color: #00ff00">&#8216;identifier&#8217;</span><span style="color: #ffffff">));</span>
      </p>
    </div>
  </div>
</div>

It&rsquo;s a fairly simple method call. I haven&rsquo;t studied the details, so I don&rsquo;t know exactly what all of the parameters do.&nbsp; It looks like the first parameter is the data type, the second and third are a set of options we don&rsquo;t need in this example, and the last parameter is the id of the element we want to databind.&nbsp; So what is wrong with this?&nbsp; I am needing to declare a lot of function parameters I don&rsquo;t need for normal operations.&nbsp; It looks like an overload with just the element to databind would be what I would use for common usage.&nbsp; 

One of the cool parts in JavaScript is that I don&rsquo;t need to actually overload the method.&nbsp; I can call the method with just the first paramter and the others will be null.&nbsp; I can deal with this possibility be creating aliases that have default values if they are null.&nbsp; The shortcut syntax looks like this. 

<div style="padding: 5px;width: 779px;float: none;margin-left: auto;margin-right: auto" class="wlWriterEditableSmartContent">
  <div style="border: #000080 1px solid;font-family: 'Courier New', Courier, Monospace;font-size: 10pt">
    <div style="background-color: #000000;overflow: scroll;padding: 2px 5px">
      <p>
        <span style="background: #000000 none repeat scroll 0% 0%;color: #ff8000">function</span><span style="color: #ffffff"> create(element, datatype, options1, options2) {<br /> &nbsp;&nbsp;&nbsp;&nbsp;</span><span style="color: #ff8000">var</span><span style="color: #ffffff"> dt = datatype || Sys.Data.DataView;<br /> &nbsp;&nbsp;&nbsp;&nbsp;</span><span style="color: #ff8000">var</span><span style="color: #ffffff"> op1 = options1 || {};<br /> &nbsp;&nbsp;&nbsp;&nbsp;</span><span style="color: #ff8000">var</span><span style="color: #ffffff"> op2 = options2 || {};<br /> &nbsp;&nbsp;&nbsp;&nbsp;</span><span style="color: #00ff00">//do something with variables now<br /> </span><span style="color: #ffffff">&nbsp;&nbsp;<br /> &nbsp; }</span>
      </p>
    </div>
  </div>
</div>

What this code is doing is setting the private variables to default values when the parameters are null.

Now I could use the function like this and get the same results:

<div style="padding: 5px;width: 779px;float: none;margin-left: auto;margin-right: auto" class="wlWriterEditableSmartContent">
  <div style="border: #000080 1px solid;font-family: 'Courier New', Courier, Monospace;font-size: 10pt">
    <div style="background-color: #000000;overflow: scroll;padding: 2px 5px">
      <p>
        <span style="background: #000000 none repeat scroll 0% 0%;color: #ffffff">$create($get(</span><span style="color: #00ff00">&#8216;identifier&#8217;</span><span style="color: #ffffff">));</span>
      </p>
    </div>
  </div>
</div>

I could go further and make it even easier to on the developer by testing to see if the element is either a string or an object .

&nbsp;

<div style="padding: 5px;width: 779px;float: none;margin-left: auto;margin-right: auto" class="wlWriterEditableSmartContent">
  <div style="border: #000080 1px solid;font-family: 'Courier New', Courier, Monospace;font-size: 10pt">
    <div style="background-color: #000000;overflow: scroll;padding: 2px 5px">
      <p>
        <span style="background: #000000 none repeat scroll 0% 0%;color: #ff8000">function</span><span style="color: #ffffff"> create(element, datatype, options1, options2) {<br /> &nbsp;&nbsp;&nbsp;&nbsp;</span><span style="color: #ff8000">var</span><span style="color: #ffffff"> dt = datatype || Sys.Data.DataView;<br /> &nbsp;&nbsp;&nbsp;&nbsp;</span><span style="color: #ff8000">var</span><span style="color: #ffffff"> op1 = options1 || {};<br /> &nbsp;&nbsp;&nbsp;&nbsp;</span><span style="color: #ff8000">var</span><span style="color: #ffffff"> op2 = options2 || {};<br /> &nbsp;&nbsp;&nbsp;&nbsp;</span><span style="color: #ff8000">var</span><span style="color: #ffffff"> el = </span><span style="color: #ff8000">typeof</span><span style="color: #ffffff"> (element) === </span><span style="color: #00ff00">&#8216;string&#8217;</span><span style="color: #ffffff"> ? $get(element) : element;<br /> &nbsp;&nbsp;&nbsp;&nbsp;</span><span style="color: #00ff00">//do something with variables now<br /> </span><span style="color: #ffffff">&nbsp;&nbsp;<br /> &nbsp; }</span>
      </p>
    </div>
  </div>
</div>

&nbsp;

Now I could also use the method like this, even further reducing my cognitive load 

<div style="padding: 5px;width: 779px;float: none;margin-left: auto;margin-right: auto" class="wlWriterEditableSmartContent">
  <div style="border: #000080 1px solid;font-family: 'Courier New', Courier, Monospace;font-size: 10pt">
    <div style="background-color: #000000;overflow: scroll;padding: 2px 5px">
      <p>
        <span style="background: #000000 none repeat scroll 0% 0%;color: #ffffff">$create(</span><span style="color: #00ff00">&#8216;identifier&#8217;</span><span style="color: #ffffff">);</span>
      </p>
    </div>
  </div>
</div>

JavaScript has tons of little features like these that can make really fun to use when the API designers take full advantage of what it has to offer.&nbsp; Of course it does have it&rsquo;s share of &ldquo;[bad](http://bit.ly/U4pJw)&rdquo; features too.&nbsp; A great API is one that knows the differences.