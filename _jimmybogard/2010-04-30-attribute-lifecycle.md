---
wordpress_id: 404
title: Attribute lifecycle
date: 2010-04-30T13:00:49+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/04/30/attribute-lifecycle.aspx
dsq_thread_id:
  - "264716472"
categories:
  - 'C#'
---
For some reason, I had this assumption that the lifecycle of System.Attribute instances was singleton.&#160; Javier Lozano wrote a quick test to prove me wrong after I looked at ways to inject services into attribute instances.&#160; I really should have read the [CLR via C#](http://www.amazon.com/CLR-via-Dev-Pro-Jeffrey-Richter/dp/0735627045/) book a little more closely, as it states (emphasis mine):

> If you want to construct an attribute object, you must call either GetCustomAttributes or GetCustomAttribute.&#160; **Every time one of these methods is called, it constructs new instances of the specified attribute type** and sets each of the instance’s fields and properties based on the values specified in the code.

To test this, first let’s define a simple attribute:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">BarAttribute </span>: <span style="color: #2b91af">Attribute
</span>{
    <span style="color: blue">public </span>BarAttribute()
    {
        Now = <span style="color: #2b91af">DateTime</span>.Now;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">DateTime </span>Now { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
}

[<span style="color: #2b91af">Bar</span>]
<span style="color: blue">public class </span><span style="color: #2b91af">Foo
</span>{
    
}</pre>

[](http://11011.net/software/vspaste)

I capture the construction date in a property, which I can then assert on with a simple test:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>AttrTester()
{
    <span style="color: blue">var </span>attrs = <span style="color: blue">typeof </span>(<span style="color: #2b91af">Foo</span>).GetCustomAttributes(<span style="color: blue">typeof </span>(<span style="color: #2b91af">BarAttribute</span>), <span style="color: blue">false</span>);

    <span style="color: blue">var </span>first = (<span style="color: #2b91af">BarAttribute</span>)attrs[0];

    <span style="color: #2b91af">Thread</span>.Sleep(1000);

    attrs = <span style="color: blue">typeof </span>(<span style="color: #2b91af">Foo</span>).GetCustomAttributes(<span style="color: blue">typeof </span>(<span style="color: #2b91af">BarAttribute</span>), <span style="color: blue">false</span>);

    <span style="color: blue">var </span>second = (<span style="color: #2b91af">BarAttribute</span>)attrs[0];

    first.ShouldNotBeTheSameAs(second);
    first.Now.ShouldNotEqual(second.Now);
}</pre>

[](http://11011.net/software/vspaste)

Sure enough, this test passes.&#160; Lesson for today: validate assumptions with a test.