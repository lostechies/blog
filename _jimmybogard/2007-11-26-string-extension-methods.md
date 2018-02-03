---
wordpress_id: 106
title: String extension methods
date: 2007-11-26T20:54:20+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/11/26/string-extension-methods.aspx
dsq_thread_id:
  - "264715447"
categories:
  - 'C#'
---
I got really tired of the [IsNullOrEmpty](http://msdn2.microsoft.com/en-us/library/system.string.isnullorempty.aspx) static method, so I converted it into an extension method:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">class</span> StringExtensions
{
    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">bool</span> IsNullOrEmpty(<span class="kwrd">this</span> <span class="kwrd">string</span> <span class="kwrd">value</span>)
    {
        <span class="kwrd">return</span> <span class="kwrd">string</span>.IsNullOrEmpty(<span class="kwrd">value</span>);
    }
}
</pre>
</div>

Since that method was already static, I just put a simple wrapper around it.&nbsp; All scenarios pass:

<div class="CodeFormatContainer">
  <pre>[TestMethod]
<span class="kwrd">public</span> <span class="kwrd">void</span> Matches_existing_behavior()
{
    Assert.IsFalse(<span class="str">"blarg"</span>.IsNullOrEmpty());
    Assert.IsTrue(((<span class="kwrd">string</span>)<span class="kwrd">null</span>).IsNullOrEmpty());
    Assert.IsTrue(<span class="str">""</span>.IsNullOrEmpty());

    <span class="kwrd">string</span> <span class="kwrd">value</span> = <span class="kwrd">null</span>;

    Assert.IsTrue(<span class="kwrd">value</span>.IsNullOrEmpty());

    <span class="kwrd">value</span> = <span class="kwrd">string</span>.Empty;

    Assert.IsTrue(<span class="kwrd">value</span>.IsNullOrEmpty());

    <span class="kwrd">value</span> = <span class="str">"blarg"</span>;

    Assert.IsFalse(<span class="kwrd">value</span>.IsNullOrEmpty());
}
</pre>
</div>

The only rather strange thing about extension methods is that they can be called by null references, as shown in the test above.&nbsp; As long as everyone understands that extension methods are syntactic sugar and not actually extending the underlying types, I think it&#8217;s clear enough.

The extension method is more readable and lets me work with strings instead of having to remember that it&#8217;s a static method.&nbsp; Static methods that reveal information about instances of the same type seem to be prime candidates for extension methods.