---
id: 164
title: Stop creating custom delegate types
date: 2008-03-26T14:03:11+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/03/26/stop-creating-custom-delegate-types.aspx
dsq_thread_id:
  - "264715631"
categories:
  - 'C#'
---
Note to OSS and framework developers:

**Please stop creating custom delegate types.&nbsp; Use the Action and Func delegates instead.**

The problem is that delegate types with the same signature are _not_ convertible to each other.&nbsp; For example, none of these assignments will work:

<pre><span style="color: blue">public delegate bool </span><span style="color: #2b91af">CustomMatchingFunction</span>(<span style="color: blue">string </span>value);

<span style="color: blue">public void </span>Custom_delegates_are_bad()
{
    <span style="color: #2b91af">Predicate</span>&lt;<span style="color: blue">string</span>&gt; match1 = value =&gt; value == <span style="color: #a31515">"Blarg"</span>;
    <span style="color: #2b91af">Func</span>&lt;<span style="color: blue">string</span>, <span style="color: blue">bool</span>&gt; match2 = value =&gt; value == <span style="color: #a31515">"Blarg"</span>;
    <span style="color: #2b91af">CustomMatchingFunction </span>match3 = value =&gt; value == <span style="color: #a31515">"Blarg"</span>;

    match1 = match2;
    match1 = (<span style="color: #2b91af">Predicate</span>&lt;<span style="color: blue">string</span>&gt;)match2;
    match1 = match3;
}
</pre>

[](http://11011.net/software/vspaste)

Although all of the delegate types shown have the same _signature,_ this does not mean that they&#8217;re the same _type_.&nbsp; They&#8217;re neither implicitly nor explicitly convertible from each other.&nbsp; One of the [preliminary LINQ framework design guidelines](http://blogs.msdn.com/mirceat/archive/2008/03/13/linq-framework-design-guidelines.aspx) states:

> ******<u>Do</u>** use the new LINQ types &#8220;Func<>&#8221; and &#8220;Expression<>&#8221; instead of custom delegates and predicates, when defining new APIs.

There are Action delegates for void methods and Func delegates for methods that return values.&nbsp; If something needs a delegate, use either the generic or specific versions of these delegate types.&nbsp; Instead of &#8220;Predicate<T>&#8221;, use &#8220;Func<T, bool>&#8221;.&nbsp; Instead of creating a custom void delegate, use &#8220;Action&#8221;.

By creating custom delegate types, you&#8217;re forcing people using your API to either force your custom type into their code, or force them to use a bunch of &#8220;wrapper methods&#8221; that wrap, convert and call your custom delegate type.

If you declare even a _single_ delegate type in your code (and you&#8217;re using .NET 3.5), stop and make sure there isn&#8217;t already an Action or Func delegate that works for you.