---
wordpress_id: 268
title: Extension methods and a plea for mixins
date: 2009-01-03T02:35:59+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/01/02/extension-methods-and-a-plea-for-mixins.aspx
dsq_thread_id:
  - "264716009"
categories:
  - ASPNETMVC
  - 'C#'
---
I was having a spot of trouble the other day trying to get my extension methods to show up in my ASP.NET MVC Views.&#160; One of the issues we’ve run into is trying to make our Views (more) intelligent on the HTML they create.&#160; Our Views still _only_ work off of a Model, but they can be much more intelligent on creating the HTML for a single property, or group of properties.&#160; However, if we’re trying to extend our Views (and not that crazy HtmlHelper), there are at least 6 View types we have to deal with:

  * ViewUserControl
  * ViewUserControl<TModel>
  * ViewPage
  * ViewPage<TModel>
  * ViewMasterPage
  * ViewMasterPage<TModel>

Now, at least the generic types inherit from their counterpart (ViewPage<TModel> inherits ViewPage).&#160; However, no real correlation exists between the six types, other than IViewDataContainer for the most part (which the ViewMasterPages do NOT implement).&#160; We noticed quite a bit of duplication in our common base behavior for each of these types.&#160; Since we couldn’t make all of these inherit from the same type, making extension methods off of a common interface seemed to make sense:

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">ViewBaseExtensions
</span>{
    <span style="color: blue">public static string </span>HtmlFor&lt;TModel&gt;(<span style="color: blue">this </span><span style="color: #2b91af">IViewBase </span>view, 
        <span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;TModel, <span style="color: blue">object</span>&gt;&gt; modelExpression)
    {
        <span style="color: green">// Zomething interesting
    </span>}
}</pre>

[](http://11011.net/software/vspaste)

Since I was working in the View, I expected my HtmlFor method to show up as an extension method.&#160; Even after some helpful tweets [from folks](http://blog.lozanotek.com/), nothing seemed to work; my extension methods simply did not show up.&#160; What was my problem?&#160; Here’s a simplified example:

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">FooExtensions
</span>{
    <span style="color: blue">public static void </span>Bar(<span style="color: blue">this </span><span style="color: #2b91af">Foo </span>foo)
    {
    }
}

<span style="color: blue">public class </span><span style="color: #2b91af">Foo
</span>{
    <span style="color: blue">public void </span>PrettyPlease()
    {
        Bar(); <span style="color: green">// Does not compile
        </span><span style="color: blue">this</span>.Bar(); <span style="color: green">// Not so magic :(
    </span>}
}</pre>

[](http://11011.net/software/vspaste)

I defined an extension method for the Foo type, but tried to use it inside Foo.&#160; Well, that doesn’t work unless I call the extension method directly on an instance of Foo, which leads me to use the “this” keyword.&#160; Which is why you see [examples like these](http://lunaverse.wordpress.com/2008/11/24/mvcfluenthtml-fluent-html-interface-for-ms-mvc/) that make prodigious use of the “this” keyword.

Duplication be damned, all that “this” nonsense just isn’t worth it.&#160; Especially when you realize that it’s only there to initiate the extension method compiler magic.

In the end, this is just another example that extension methods aren’t [mixins](http://en.wikipedia.org/wiki/Mixin), and I seriously doubt the new C# 4.0 “dynamic” keyword will do the trick.&#160; I’m starting to believe that if I want a dynamic language, I should stop looking for a static language to bend yoga-style backwards to be one.