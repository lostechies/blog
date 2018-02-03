---
wordpress_id: 12
title: Re-throwing exceptions
date: 2007-04-25T13:08:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/04/25/re-throwing-exceptions.aspx
dsq_thread_id:
  - "265539498"
categories:
  - 'C#'
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/re-throwing-exceptions.html)._

If this hasn&#8217;t happened to you already, it will in the future.&nbsp; And when it does, you&#8217;ll tear your hair out.&nbsp; You&#8217;re reading a defect report, an error log, or a message in an event log that tells you an exception was thrown.&nbsp; The log tells you&nbsp;what type of exception was thrown, the message, and a stack trace.&nbsp; Here&#8217;s my exception message:

<pre>System.Exception: Something went wrong.<br />
at WindowsApp.Form1.DoWork() in C:WindowsAppForm1.cs:line 47<br />
at WindowsApp.Form1..ctor() in C:WindowsAppForm1.cs:line 12<br />
at WindowsApp.App.Main() in C:WindowsAppApp.cs:line 30
</pre>

I&#8217;m feeling good, since I have some good information about where things went wrong.&nbsp; Let&#8217;s look at the code:

<div class="CodeFormatContainer">
  <div class="csharpcode">
    <pre><span class="lnum">34: </span><span class="kwrd">public</span> <span class="kwrd">void</span> DoWork()</pre>
    
    <pre><span class="lnum">35: </span>{</pre>
    
    <pre><span class="lnum">36: </span>    DoSomething();</pre>
    
    <pre><span class="lnum">37: </span>&nbsp;</pre>
    
    <pre><span class="lnum">38: </span>    <span class="kwrd">try</span></pre>
    
    <pre><span class="lnum">39: </span>    {</pre>
    
    <pre><span class="lnum">40: </span>        DoSomethingElse();</pre>
    
    <pre><span class="lnum">41: </span>&nbsp;</pre>
    
    <pre><span class="lnum">42: </span>        DoAnotherThing();</pre>
    
    <pre><span class="lnum">43: </span>    }</pre>
    
    <pre><span class="lnum">44: </span>    <span class="kwrd">catch</span> (Exception ex)</pre>
    
    <pre><span class="lnum">45: </span>    {</pre>
    
    <pre><span class="lnum">46: </span>        LogException(ex);</pre>
    
    <pre><span class="lnum">47: </span>        <span class="kwrd">throw</span> ex;</pre>
    
    <pre><span class="lnum">48: </span>    }</pre>
    
    <pre><span class="lnum">49: </span>&nbsp;</pre>
    
    <pre><span class="lnum">50: </span>    FinishUp();</pre>
    
    <pre><span class="lnum">51: </span>}</pre>
    
    <pre><span class="lnum">52: </span>&nbsp;</pre>
  </div>
</div>

Looking back at the exception message, it says that the error occurred at line 47.&nbsp; But line 47 is just the line that re-throws the exception!&nbsp; Now I&#8217;m in big trouble, because I have no idea if it was the DoSomething or the DoAnotherThing that threw the exception.&nbsp; I could dive in to each method, but who knows how big that rabbit hole goes.&nbsp; I probably don&#8217;t have a choice, so down the rabbit hole we go.

The real issue was that I completely lost the stack trace from the exception.&nbsp; It looks like the CLR created a new stack trace starting at line 47, instead of somewhere inside the try block.&nbsp; If I&#8217;m debugging or fixing code from an exception message, I **really** need that stack trace.&nbsp; So how do we prevent this problem?

### Re-throwing exceptions

It&#8217;s actually a very minor change.&nbsp; See if you can spot the difference:

<div class="CodeFormatContainer">
  <div class="csharpcode">
    <pre><span class="lnum">34: </span><span class="kwrd">public</span> <span class="kwrd">void</span> DoWork()</pre>
    
    <pre><span class="lnum">35: </span>{</pre>
    
    <pre><span class="lnum">36: </span>    DoSomething();</pre>
    
    <pre><span class="lnum">37: </span>&nbsp;</pre>
    
    <pre><span class="lnum">38: </span>    <span class="kwrd">try</span></pre>
    
    <pre><span class="lnum">39: </span>    {</pre>
    
    <pre><span class="lnum">40: </span>        DoSomethingElse();</pre>
    
    <pre><span class="lnum">41: </span>&nbsp;</pre>
    
    <pre><span class="lnum">42: </span>        DoAnotherThing();</pre>
    
    <pre><span class="lnum">43: </span>    }</pre>
    
    <pre><span class="lnum">44: </span>    <span class="kwrd">catch</span> (Exception ex)</pre>
    
    <pre><span class="lnum">45: </span>    {</pre>
    
    <pre><span class="lnum">46: </span>        LogException(ex);</pre>
    
    <pre><span class="lnum">47: </span>        <span class="kwrd">throw</span>;</pre>
    
    <pre><span class="lnum">48: </span>    }</pre>
    
    <pre><span class="lnum">49: </span>&nbsp;</pre>
    
    <pre><span class="lnum">50: </span>    FinishUp();</pre>
    
    <pre><span class="lnum">51: </span>}</pre>
    
    <pre><span class="lnum">52: </span>&nbsp;</pre>
  </div>
</div>

Now let&#8217;s look at the exception message:

<pre>System.Exception: Something went wrong.<br />
at WindowsApp.Form1.DoAnotherThing() in C:WindowsAppForm1.cs:line 65<br />
at WindowsApp.Form1.DoWork() in C:WindowsAppForm1.cs:line 47<br />
at WindowsApp.Form1..ctor() in C:WindowsAppForm1.cs:line 12<br />
at WindowsApp.App.Main() in C:WindowsAppApp.cs:line 30
</pre>

Now I get the full stack trace.&nbsp; The exception actually occurred down in the DoAnotherThing method.&nbsp; I can debug&nbsp;this error with ease, all because I used this:

<div class="CodeFormatContainer">
  <div class="csharpcode">
    <pre><span class="lnum">47: </span><span class="kwrd">throw</span>;<br /></pre>
  </div>
</div>

instead of this:

<div class="CodeFormatContainer">
  <div class="csharpcode">
    <pre><span class="lnum">47: </span><span class="kwrd">throw</span> ex;<br /></pre>
  </div>
</div>

### Wrapping exceptions

Often times we don&#8217;t want specific exceptions showing up in the user interface.&nbsp; Other times we detect an exception and want to throw a more general exception.&nbsp; This is called wrapping exceptions, which is catching an exception and throwing a different one:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">void</span> DoWork()<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;DoSomething();<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">try</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DoSomethingElse();<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DoAnotherThing();<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">catch</span> (Exception ex)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LogException(ex);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">throw</span> <span class="kwrd">new</span> ApplicationSpecificException(<span class="str">"Something bad happened"</span>, ex);<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;FinishUp();<br />
}<br />
</pre>
</div>

Note that when I threw a different exception, I passed in the original exception into the constructor.&nbsp; This preserves the stack trace, and exception messages will display the full stack of the inner exception.&nbsp; If I didn&#8217;t pass in the exception, I&#8217;d be in the exact same boat as before, not having any idea where to look to debug exceptions because the stack trace would be&nbsp;incorrect.&nbsp; Since I used the constructor that uses an inner exception, I get to keep my hair.&nbsp; Of course, the developer who wrote ApplicationSpecificException knows how to correctly implement custom exceptions because they&#8217;ve read [Framework Design Guidelines](http://www.amazon.com/Framework-Design-Guidelines-Conventions-Development/dp/0321246756/ref=pd_bbs_sr_1/002-0878740-0508014?ie=UTF8&s=books&qid=1177528109&sr=8-1), so we don&#8217;t have to worry whether or not&nbsp;the ApplicationSpecificException has the constructor we need.&nbsp; I hope.

### And the moral of the story is&#8230;

Without a proper stack trace, you can be absolutely lost in trying to debug an exception.&nbsp; To keep your sanity and potentially your health (from getting thrashed by other developers), just follow a couple easy guidelines:

  * When re-throwing exceptions, use &#8220;throw;&#8221; instead of &#8220;throw ex;&#8221; 
      * When wrapping exceptions, use a constructor that takes the inner exception</ul> 
    I didn&#8217;t get into swallowing exceptions, that&#8217;s an even worse nightmare.&nbsp; I&#8217;ll save that one for a future post.
    
    ### For IL buffs
    
    The difference between &#8220;throw;&#8221; and &#8220;throw ex;&#8221; is actually in the IL.&nbsp; Two different IL instructions are used, &#8220;rethrow&#8221; and &#8220;throw&#8221; respectively.&nbsp; This functionality isn&#8217;t magic, it&#8217;s built into the Framework at the IL level.