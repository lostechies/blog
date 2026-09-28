---
wordpress_id: 410
title: 'Caveats of C# 4.0 optional parameters'
date: 2010-05-18T13:01:01+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/05/18/caveats-of-c-4-0-optional-parameters.aspx
dsq_thread_id:
  - "264716487"
categories:
  - 'C#'
redirect_from: "/blogs/jimmy_bogard/archive/2010/05/18/caveats-of-c-4-0-optional-parameters.aspx/"
---
C# 4.0 includes lots of shiny new hammers for us to bang away at every new and existing development problem we face.&#160; One of the more interesting features is the concept of named and optional parameters.&#160; Consider this rather cryptic bit of code:

<pre><span style="color: blue">var </span>match = <span style="color: #2b91af">Regex</span>.IsMatch(<span style="color: #a31515">"abcde"</span>, <span style="color: #a31515">"cd"</span>);</pre>

[](http://11011.net/software/vspaste)

So which argument is the pattern, and which is the input to match against?&#160; With named parameters, this becomes much easier to understand:

<pre><span style="color: blue">var </span>match = <span style="color: #2b91af">Regex</span>.IsMatch(input: <span style="color: #a31515">"abcde"</span>, pattern: <span style="color: #a31515">"cd"</span>);</pre>

It’s now immediately clear which method parameter is which. That’s fantastic, this feature alone saves me tons of headaches when I order parameters incorrectly to a function that accepts objects of the same type.&#160; 

Also part of C# 4.0 are optional parameters, which can save quite a bit of typing by reducing the number of overloads to a function.&#160; However, optional parameters come with a few caveats worth noting.

### 

### Expressions not supported

Let’s look at this typical controller action:

<pre><span style="color: blue">public </span><span style="color: #2b91af">ViewResult </span>Index(<span style="color: blue">int</span>? minSessions)
{
    minSessions = minSessions ?? 0;

    <span style="color: blue">var </span>list = <span style="color: blue">from </span>conf <span style="color: blue">in </span>_repository.Query()
               <span style="color: blue">where </span>conf.SessionCount &gt;= minSessions
               <span style="color: blue">select </span>conf;</pre>

[](http://11011.net/software/vspaste)

I have a list view of conferences, that optionally filters on the minimum number of sessions.&#160; In my screen, the user has a drop-down to select this minimum session count filter.&#160; Since I don’t require this in the UI, I make that parameter a nullable int.

However, I still have to deal with the user not applying the filter, so I have some code to deal with this.&#160; I could instead try to take advantage of optional parameters:

<pre><span style="color: blue">public </span><span style="color: #2b91af">ViewResult </span>Index(<span style="color: blue">int </span>minSessions = 0)
{
    <span style="color: blue">var </span>list = <span style="color: blue">from </span>conf <span style="color: blue">in </span>_repository.Query()
               <span style="color: blue">where </span>conf.SessionCount &gt;= minSessions
               <span style="color: blue">select </span>conf;</pre>

[](http://11011.net/software/vspaste)

With the optional parameter syntax, I set the default value of minSessions to 0, removing that annoying cruft in the body of the controller action.&#160; The action becomes much more readable.&#160; However, I immediately run into problems when I try and compile the rest of my code base, and find that this no longer compiles:

<pre><span style="color: blue">return this</span>.RedirectToAction(c =&gt; c.Index());</pre>

[](http://11011.net/software/vspaste)

I don’t get any errors from ReSharper, but when I compile, I get a compile error:

<pre>error CS0854: An expression tree may not contain a call or invocation that uses optional arguments</pre>

[](http://11011.net/software/vspaste)

Well that stinks!&#160; I use expressions all the time to reference controller actions, as it gives me a strongly-typed links and URLs, instead of loose-typed, string-based versions.&#160; It seems like the compiler should be able to build the correct expression tree, because the normal compiler can!&#160; It could generate a regular Expression.Constant as if I passed in the default argument value.

But it doesn’t, and I get this compiler error instead.&#160; So just be aware, if you want your code to be consumed by expressions, you cannot use optional arguments.

### Default value localization

Another caveat C# folks might not know about is that the C# version of optional parameters suffers from the same limitations of the VB version (which, by the way, has been in VB since VS 2002).&#160; Namely, the optional parameter value is a compiler trick, where the optional parameter value is not compiled into the method called, but instead into the caller.&#160; Here’s an example, from a unit test:

<pre><span style="color: blue">var </span>controller = <span style="color: blue">new </span><span style="color: #2b91af">ConferenceController</span>(repository, mapper);

<span style="color: blue">var </span>result = controller.Index();

result.ViewData.Model.ShouldEqual(viewModel);</pre>

[](http://11011.net/software/vspaste)

I call the Index action method, which includes an optional argument.&#160; If we open the compiled code from here, we see that the optional parameter value is baked in to the call site:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_2561E477.png" width="742" height="61" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_784CF7A8.png) 

So what does this mean for us?&#160; If we change the value of the optional argument from 0 to 1, we have to recompile all calling code for the calling code to get the updated value!

For folks shipping assemblies for a living, this means that optional argument values don’t version well, as callers have to recompile.&#160; When I used to work for a company whose product included a DLL, we avoided optional method arguments for just this reason.&#160; It’s not a reason _not_ to use optional arguments, but it’s important to understand how they work so that you don’t run into headaches later.