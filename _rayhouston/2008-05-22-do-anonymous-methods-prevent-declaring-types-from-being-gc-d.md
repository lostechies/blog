---
id: 22
title: 'Do Anonymous Methods Prevent Declaring Types from Being GC&#8217;d?'
date: 2008-05-22T01:57:02+00:00
author: Ray Houston
layout: post
guid: /blogs/rhouston/archive/2008/05/21/do-anonymous-methods-prevent-declaring-types-from-being-gc-d.aspx
categories:
  - Uncategorized
---
It seems that they do if they reference members of the declaring type. This makes perfect sense now that I think about it, but I didn&#8217;t think about it earlier and wrote some code that caused a memory leak. I had an object acting as a singleton and referencing a delegate instance that was created from an object acting as a non singleton. Bam! Memory Leak.

I setup a little test to demonstrate. Here is a class that has two methods which return delegate instances:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> TestSource
{
    <span style="color: #0000ff">private</span> <span style="color: #0000ff">string</span> internalValue = <span style="color: #006080">"test"</span>;

    <span style="color: #0000ff">public</span> Func&lt;<span style="color: #0000ff">bool</span>&gt; GetFunc1()
    {
        <span style="color: #0000ff">return</span> () =&gt; 1 == 1;
    }

    <span style="color: #0000ff">public</span> Func&lt;<span style="color: #0000ff">string</span>&gt; GetFunc2()
    {
        <span style="color: #0000ff">return</span> () =&gt; internalValue;
    }
}
</pre>
</div>

Notice that GetFunc1() doesn&#8217;t have any references to internal members, but GetFunc2() does. Here&#8217;s the test class:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">class</span> Program
{
    <span style="color: #0000ff">static</span> <span style="color: #0000ff">void</span> Main(<span style="color: #0000ff">string</span>[] args)
    {
        <span style="color: #008000">// hold no references to TestSource</span>
        TestFuncInstance(<span style="color: #0000ff">new</span> TestSource().GetFunc1());
        TestFuncInstance(<span style="color: #0000ff">new</span> TestSource().GetFunc2());

        Console.WriteLine(<span style="color: #006080">"Press Enter to continue."</span>);
        Console.ReadLine();
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">void</span> TestFuncInstance(Delegate func)
    {
        Thread.Sleep(1000);<span style="color: #008000">// give some time for GC</span>

        Console.WriteLine(<span style="color: #0000ff">string</span>.Format(<span style="color: #006080">"Method: {0}"</span>,func.Method));
        Console.WriteLine(<span style="color: #0000ff">string</span>.Format(<span style="color: #006080">"DeclaringType: {0}"</span>, func.Method.DeclaringType));
        Console.WriteLine(<span style="color: #0000ff">string</span>.Format(<span style="color: #006080">"Target: {0}"</span>, func.Target ?? <span style="color: #006080">"null"</span>));

        Console.WriteLine();
    }
}
</pre>
</div>

This creates two separate instances of TestSource and passes the result of the two GetFunc methods to a test method. Notice that there are no declared variable references to the TestSource object. Here&#8217;s the output of the test:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">Method: Boolean <span style="color: #0000ff">&lt;</span><span style="color: #800000">GetFunc1</span><span style="color: #0000ff">&gt;</span>b__0()
DeclaringType: TestingDelegates.TestSource
Target: null 

Method: System.String <span style="color: #0000ff">&lt;</span><span style="color: #800000">GetFunc2</span><span style="color: #0000ff">&gt;</span>b__2()
DeclaringType: TestingDelegates.TestSource
Target: TestingDelegates.TestSource 

Press Enter to continue.
</pre>
</div>

I know this test isn&#8217;t very scientific, but you&#8217;ll see that Func1&#8217;s target is null while Func2&#8217;s target is not. Func2 has to hold a reference to the declaring object so that it can do it&#8217;s job when invoked. Func1 does not need a reference, and seems to free up the declaring object to be garbage collected. This is definitely something to keep in mind when passing around delegates.

<div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  Technorati Tags: <a href="http://technorati.com/tags/.NET" rel="tag">.NET</a>,<a href="http://technorati.com/tags/delegates" rel="tag">delegates</a>,<a href="http://technorati.com/tags/GC" rel="tag">GC</a>
</div>