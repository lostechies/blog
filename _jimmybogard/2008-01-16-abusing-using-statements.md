---
wordpress_id: 129
title: Abusing using statements
date: 2008-01-16T04:04:16+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/01/15/abusing-using-statements.aspx
dsq_thread_id:
  - "264715503"
categories:
  - ASPdotNET
  - 'C#'
  - MVC
redirect_from: "/blogs/jimmy_bogard/archive/2008/01/15/abusing-using-statements.aspx/"
---
I&#8217;ve always thought that the [using statement](http://msdn2.microsoft.com/en-us/library/yh598w02.aspx) was one of the most useful features included in C#.&nbsp; It&#8217;s easy to use:

<pre><span style="color: blue">public string </span>GetFileTextForParsing(<span style="color: blue">string </span>path)
{
    <span style="color: blue">string </span>contents = <span style="color: blue">null</span>;

    <span style="color: blue">using</span>(<span style="color: #2b91af">StreamReader </span>reader = <span style="color: #2b91af">File</span>.OpenText(path))
    {
        contents = reader.ReadToEnd();
    }

    <span style="color: blue">return </span>contents;
}
</pre>

[](http://11011.net/software/vspaste)

The using statement allows me to create scope for a variable, ensuring any expensive resources are cleaned up at the end of the using block.&nbsp; To be able to take advantage of the using statement, the variable created inside the &#8220;using (<object instantiated>)&#8221; must implement the [IDisposable](http://msdn2.microsoft.com/en-us/library/aax125c9.aspx) interface.

At a recent presentation of the new ASP.NET MVC framework, I saw a rather strange use of the using statement that bordered on abuse.&nbsp; It&#8217;s from the [MVC Toolkit](http://go.microsoft.com/fwlink/?LinkID=106001&clcid=0x409), which [Rob Conery](http://blog.wekeroad.com/) introduced [a while back](http://blog.wekeroad.com/2007/12/05/aspnet-mvc-preview-using-the-mvc-ui-helpers/).&nbsp; The UI helpers are very nice, but it introduced a rather interesting way of creating HTML form elements:

<pre><span style="background: #ffee62">&lt;%</span> <span style="color: blue">using </span>(Html.Form&lt;HomeController&gt;(action=&gt;action.Index())) { <span style="background: #ffee62">%&gt;

</span><span style="color: blue">&lt;</span><span style="color: #a31515">input </span><span style="color: red">type</span><span style="color: blue">="text" </span><span style="color: red">id</span><span style="color: blue">="search" /&gt;

&lt;</span><span style="color: #a31515">input </span><span style="color: red">type</span><span style="color: blue">="button" </span><span style="color: red">value</span><span style="color: blue">="Submit" /&gt;

</span><span style="background: #ffee62">&lt;%</span> } <span style="background: #ffee62">%&gt;
</span></pre>

[](http://11011.net/software/vspaste)

When this code executes, it creates the proper HTML form tags.&nbsp; The using statement is used because it can create both the beginning form tag at the beginning of the using block and the end form tag at the end of the using block.

I&#8217;m seen some [pretty creative uses of the using statement](http://grabbagoft.blogspot.com/2007/06/example-of-creating-scope-with-using.html) (that&#8217;s actually my very first blog post, ever), but this one rubbed me the wrong way.&nbsp; The traditional usage of the using statement is simply to provide an easy syntax to properly use IDisposable instances.&nbsp; IDisposable has a rather specialized description in MSDN documentation:

> Defines a method to release allocated unmanaged resources.

I don&#8217;t think the Form method above has unmanaged resources.&nbsp; That isn&#8217;t to say that IDisposable should only be used to for objects with unmanaged resources, like database connections, file handles, etc, as the using statement makes it such a palatable feature.&nbsp; Some common uses for IDisposable include:

  * Cleaning up resources (database connections)
  * Creating scope for an operation (RhinoMocks record and playback)
  * Creating a context for a certain state (security impersonation)

The problem with the proliferation of IDisposable is we&#8217;ve reached the point where the IDisposable interface has no meaning in and of itself.&nbsp; It&#8217;s morphed into a convenient way to allow use of the using statement.&nbsp; What&#8217;s made the using statement so popular is that it provides a convenient syntax to encapsulate

  1. Code to be executed at the beginning of a block (the constructor)
  2. Code to be executed at the end of a block (the Dispose method)

Figuring out if I can use the using statement with a given object or method call is a deductive process.&nbsp; Unless the class or method is named in a manner that makes it obvious that I&#8217;m creating a scope block, like &#8220;CreateContext&#8221;, I have to rely on documentation, examples, or Reflector to know that I&#8217;m supposed to use IDisposable.

Additionally, there&#8217;s nothing stopping me from _not_ using the using statement.&nbsp; For example, in the ASP.NET example above, let&#8217;s try removing the using statement:

<pre><span style="background: #ffee62">&lt;%</span> Html.Form&lt;<span style="color: #2b91af">HomeController</span>&gt;(action=&gt;action.Index()); <span style="background: #ffee62">%&gt;

</span><span style="color: blue">&lt;</span><span style="color: #a31515">input </span><span style="color: red">type</span><span style="color: blue">="text" </span><span style="color: red">id</span><span style="color: blue">="search" /&gt;

&lt;</span><span style="color: #a31515">input </span><span style="color: red">type</span><span style="color: blue">="button" </span><span style="color: red">value</span><span style="color: blue">="Submit" /&gt;
</span></pre>

[](http://11011.net/software/vspaste)

This results in the end form tag **never getting generated**.&nbsp; This means that we&#8217;re absolutely relying on developers to either call the Dispose method or use the using statement.

### 

### A new interface?

It used to be easy to know which objects needed to be disposed of properly, as these objects used unmanaged resources or had the explicit purpose of creating a context.&nbsp; Since the using statement is such a convenient language feature, the IDisposable interface is used in a much wider variety of scenarios.&nbsp; All these extra scenarios have made the existence of the IDisposable interface little more than a mechanism to take advantage of the IDisposable interface.

The name doesn&#8217;t make much sense anymore, as a fraction of the implementations of IDisposable are actually to clean up unmanaged resources.&nbsp; A more appropriate name for IDisposable might be &#8220;IScopeable&#8221; or &#8220;IContext&#8221;, anything that better describes what its use has become.

Changing the name isn&#8217;t feasible, but what I&#8217;d really like to see are compiler warnings or Resharper code analysis warnings telling me when I&#8217;m using an IDisposable instance without calling the Dispose method or including it with the using statement.&nbsp; It&#8217;s just too much work to check every single type I run into to see if it implements IDisposable.

So as fun as the using statement might be, I&#8217;d like to see it either more obvious to discover that I need to use the using statement, or a little more restraint on slapping IDisposable on anything with two legs.