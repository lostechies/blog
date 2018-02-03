---
wordpress_id: 13
title: Swallowing exceptions is hazardous to your health
date: 2007-04-30T13:12:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/04/30/swallowing-exceptions-is-hazardous-to-your-health.aspx
dsq_thread_id:
  - "266774441"
categories:
  - 'C#'
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/swallowing-exceptions-is-hazardous-to.html)._

In my [last entry](http://www.lostechies.com/blogs/jimmy_bogard/archive/2007/04/25/re-throwing-exceptions.aspx), I set some guidelines for re-throwing exceptions.&nbsp; The flip side from re-throwing exceptions is swallowing exceptions.&nbsp; In nearly all cases I can think of, swallowing exceptions is a Very Bad Idea &#8482;.&nbsp; So what am I talking about when I say &#8220;swallowing exceptions&#8221;?&nbsp; Check out the following code snippet:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">void</span> ProcessRequest()<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;Message msg = <span class="kwrd">null</span>;<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">try</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;msg = ReadMessage();<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">catch</span> (Exception ex)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LogException(ex);<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;ProcessMessage(msg);<br />
}<br />
</pre>
</div>

This code is fairly straightforward.&nbsp; I declare a Message, try and read the message, and if something messes up while reading the message, I log the exception.&nbsp; Finally, I&#8217;ll process the message I read.

### There&#8217;s a monster lurking about&#8230;

Astute code readers will notice that even&nbsp;if there is a problem in ReadMessage, this function will **always** process the message.&nbsp; The &#8220;try&#8221; block has caught an exception, but did not re-throw the exception, so the rest of the execution context in this method is basically unaware of the exception.

**Swallowing exceptions is when a Catch block does not re-throw the exception.**

ProcessMessage might throw&nbsp;a NullReferenceException, or even an ArgumentNullException.&nbsp; Now we&#8217;ve left it up to the&nbsp;code following the &#8220;try&#8221; block&nbsp;to handle error cases, invalid states, etc.&nbsp; We&#8217;ve just made our lives _that_ much more difficult.

### Effect on maintainability

So Bob coded the above snippet, shipped it, then moved on to bigger and better things.&nbsp; Joe comes along six months later, needing to change the message processing, and notices he gets very strange behavior when ReadMessage doesn&#8217;t work.&nbsp; When Joe looks at the code, he&#8217;s a little baffled.&nbsp; Hoping to find clear, intention-revealing code, what he found was exception swallowing choking the system.&nbsp; Joe doesn&#8217;t know if the original author intended to process bad messages or not.&nbsp; Joe doesn&#8217;t know if ProcessMessage is able to handle&nbsp;bad messages.&nbsp; If Joe has to add a lot of pre- and post-processing to the message, now his life is harder since he has to worry about bad messages.&nbsp; Why should I process a message if I wasn&#8217;t able to read it?

Since Joe knows that 99 times out of 100, you shouldn&#8217;t swallow exceptions, he has to take time to figure out if this was one of those times, or if this is just a bug.&nbsp; Either way, Joe is wasting time trying to figure out **what the system does** rather than **delivering business value**.&nbsp; Whenever you spend most of your&nbsp;time in the former rather than the latter, that&#8217;s a clear sign that you don&#8217;t have a maintainable codebase.

### A better solution

So we have a requirement to log exceptions.&nbsp; That&#8217;s a good thing.&nbsp; Ideally, our codebase should be largely unaware of having to catch and log exceptions, since this extra code tends to clutter up what we&#8217;re working on.&nbsp; I believe I have two options, either re-throwing the exception or removing the try-catch block and applying it on a higher level.&nbsp; Here&#8217;s the former:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">void</span> ProcessRequest()<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;Message msg = <span class="kwrd">null</span>;<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">try</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;msg = ReadMessage();<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">catch</span> (Exception ex)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LogException(ex);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">throw</span>;<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;ProcessMessage(msg);<br />
}<br />
</pre>
</div>

Now it&#8217;s fairly clear to Joe that&nbsp;there is&nbsp;a requirement to log exceptions, but&nbsp;this function show never&nbsp;continue its message processing if it encountered problems reading the message.

### Some guidelines

So when should we swallow exceptions?

  * When execution needs to continue despite an error 
      * The expected behavior of the system is to continue operating and not to crash</ul> 
    By following these guidelines, you&#8217;d probably notice that 99 times out of 100, you&#8217;ll always re-throw the exception.&nbsp; And when you do swallow exceptions, it&#8217;s&nbsp;usually in the top level modules of a system.&nbsp; So be kind, don&#8217;t swallow exceptions, and some day Joe will thank you for it.