---
id: 108
title: Hall of shame
date: 2007-11-29T22:05:11+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/11/29/hall-of-shame.aspx
dsq_thread_id:
  - "264715448"
categories:
  - 'C#'
  - LegacyCode
  - People
---
We keep a &#8220;Hall of Shame&#8221; of [WTF-level](http://worsethanfailure.com/) code snippets&nbsp;to remind us that however bad we might think things get, it could always be worse.&nbsp; It also serves as a reminder to us that we can&#8217;t be complacent with ignorance, and lack of strong technical leadership in critical applications can have far-reaching negative consequences.&nbsp; Here are a few fun examples.

### Runtime obsolescence

I&#8217;ve seen this when we have members that we don&#8217;t want anyone to use anymore.&nbsp; Unfortunately, it didn&#8217;t quite come out right:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">bool</span> Authenticate(<span class="kwrd">string</span> username, <span class="kwrd">string</span> password)
{
    <span class="kwrd">throw</span> <span class="kwrd">new</span> Exception(<span class="str">"I'm obsolete, don't call me, bro!"</span>);
}
</pre>
</div>

Nobody knows not to call this method until their codebase actually executes this code at runtime, which could be at any phase in development.&nbsp; If it&#8217;s an obscure method, it might not get called at all until production deployment if test&nbsp;coverage is low.

We want to communicate to developers at _compile-time_ that members are obsolete, and we can do this we the [ObsoleteAttribute](http://msdn2.microsoft.com/en-us/library/system.obsoleteattribute.aspx):

<div class="CodeFormatContainer">
  <pre>[Obsolete(<span class="str">"Please use the SessionContext class instead."</span>, <span class="kwrd">true</span>)]
<span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">bool</span> Authenticate(<span class="kwrd">string</span> username, <span class="kwrd">string</span> password)
{
}
</pre>
</div>

Both the IDE and compilers support this attribute to give feedback to developers when a member should no longer be used.

### Exception paranoia

I&#8217;ve seen exception paranoia mostly when developers don&#8217;t have a thorough understanding of the .NET Framework.&nbsp; A try&#8230;catch block is placed around code that can absolutely never fail, but juuuuuust in case it does:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">static</span> MyIdentity Ident
{
    get
    {
        <span class="kwrd">if</span> (((HttpContext.Current != <span class="kwrd">null</span>) && (HttpContext.Current.User != <span class="kwrd">null</span>)) && (HttpContext.Current.User.Identity != <span class="kwrd">null</span>))
        {
            <span class="kwrd">try</span>
            {
                <span class="kwrd">return</span> (HttpContext.Current.User.Identity <span class="kwrd">as</span> MyIdentity);
            }
            <span class="kwrd">catch</span> (Exception exception)
            {
                ExceptionManager.Publish(exception);
                <span class="kwrd">return</span> <span class="kwrd">null</span>;
            }
        }
        <span class="kwrd">return</span> <span class="kwrd">null</span>;
    }
}
</pre>
</div>

This is also another case of [TCPS](http://grabbagoft.blogspot.com/2007/11/stop-madness.html).&nbsp; The &#8220;if&#8221; block already takes care of any failures of the &#8220;try&#8221; block, and as we&#8217;re using the &#8220;as&#8221; operator, the downcasting can never fail either.&nbsp; The 13 lines of code above were reduced to only one:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">static</span> MyIdentity Ident
{
    get
    {
        <span class="kwrd">return</span> HttpContext.Current.User.Identity <span class="kwrd">as</span> MyIdentity;
    }
}
</pre>
</div>

If HttpContext.Current is null, I&#8217;d rather throw the exception, as my ASP.NET app _probably_ won&#8217;t work without ASP.NET up and running.

### Clever debug switches

This is probably my favorite Hall of Shame example. &nbsp;So much so that we named an award at my previous employer after the pattern.&nbsp; Sometimes I like to insert a block of code for debugging purposes.&nbsp; If I want my debug statements to live on in source control, I have a variety of means to do so, including [compiler directives](http://msdn2.microsoft.com/en-us/library/4y6tbswk(VS.80).aspx), the [ConditionalAttribute](http://msdn2.microsoft.com/en-us/library/system.diagnostics.conditionalattribute.aspx),&nbsp;or even source control to look at history.&nbsp; A not-so-clever approach we found was:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">void</span> SubmitForm()
{
    <span class="kwrd">if</span> (<span class="kwrd">false</span>)
    {
        MessageBox.Show(<span class="str">"Submit button was clicked."</span>);
    }
}
</pre>
</div>

To make the code run, you&nbsp;change the block to&nbsp;&#8220;if (true)&#8221;.&nbsp; This had us cracking up so much we named our Hall of Shame award after it, calling it the &#8220;If False Award&#8221;.&nbsp; Whenever we found especially heinous or corner-cutting code, they deserved the &#8220;If False Award&#8221;.&nbsp; We never awarded ignorance, only laziness.

### Opportunities to improve

It&#8217;s easy to let a &#8220;Hall of Shame&#8221; create negative and unconstructive views towards the codebase.&nbsp; We always used it as a teaching tool to show that we would fix ignorance, but we would not tolerate laziness.

Every developer starts their career writing bad code.&nbsp; Unfortunately, some never stop.