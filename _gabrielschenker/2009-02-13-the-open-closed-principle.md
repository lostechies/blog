---
id: 14
title: The open closed principle
date: 2009-02-13T12:30:00+00:00
author: Gabriel Schenker
layout: post
guid: /blogs/gabrielschenker/archive/2009/02/13/the-open-closed-principle.aspx
dsq_thread_id:
  - "263908860"
categories:
  - Design
  - Patterns
  - practices
  - SOLID
---
{% raw %}
[<img style="border-right: 0px;border-top: 0px;margin-left: 0px;border-left: 0px;margin-right: 0px;border-bottom: 0px" alt="wall_thumb4" src="//lostechies.com/gabrielschenker/files/2011/03/wall_thumb4_3A8C0CF7.jpg" align="right" border="0" width="185" height="244" />](/Users/Administrator/AppData/Local/Temp/WindowsLiveWriter1286139640/supfiles34414B9/wall6.jpg) In the previous two posts I discussed the **S** of S.O.L.I.D. which is the [Single Responsibility Principle](/blogs/gabrielschenker/archive/2009/01/21/real-swiss-don-t-need-srp-do-they.aspx) (SRP) and the D of S.O.L.I.D. which corresponds to the [Dependency Inversion](/blogs/gabrielschenker/archive/2009/01/30/the-dependency-inversion-principle.aspx) Principle (DI). This time I want to continue this series with the second letter of S.O.L.I.D. namely the O which represents the **Open Close Principle** (OCP).

## Introduction

In object-oriented programming the open/closed principle states

> _Software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification._

That is such an entity can allow its behavior to be altered without altering its source code.

The first person who mentioned this principle was [Bertrand Meyer](http://en.wikipedia.org/wiki/Bertrand_Meyer). He used inheritance to solve the apparent dilemma of the principle. His idea was that once completed, the implementation of a class could only be modified to correct errors, but new or changed features would require that a different class be created.

In contrast to Meyer&rsquo;s definition there is a second way to adhere to the principle. It&rsquo;s called the polymorphic open/close principle and refers to the use of abstract interfaces, where the implementation can be changed and multiple implementations could be created and polymorphically substitute for each other. A class is open for extension when it does not depend directly on concrete implementations. Instead it depends on abstract base classes or interfaces and remains agnostic about how the dependencies are implemented at runtime.

OCP is about arranging encapsulation in such a way that it&#8217;s effective, yet open enough to be extensible. This is a compromise, i.e. &#8220;expose only the moving parts that need to change, hide everything else&#8221;

There are several ways to extend a class:

  1. inheritance 
  2. composition 
  3. proxy implementation (special case for composition) 

### Sealed classes

Is a sealed class contradicting the OCP? What one needs to consider when facing a sealed class is whether one can extend its behavior in any other way than inheritance? If one injects all dependencies, and those are extendable, commonly they&#8217;re interfaces then the sealed class can very well be open for extension. One can plug in new behavior by swapping out collaborators/dependencies.

### What about inheritance? 

The ability to subclass provides an additional seam to accomplish that extension by putting the abstraction not to codified interfaces but to the concept captured in overridable behavior. 

Basically you can think of it a bit like this, given a class that have virtual methods if you put all of those into an interface and depended upon that you&#8217;d have an equivalent openness to extension but through another mechanism. **Template method** in the first case and **delegation** in the second.

Since inheritance gives a much stronger coupling than delegation the puritan view is to delegate when you can and inherit when you must. That often leads to composable systems and overall realizes more opportunities for reuse. Inheritance based extension is somewhat easier to grasp and more common since it&#8217;s what is usually thought.

## Samples

### [<img style="border-right: 0px;border-top: 0px;margin-left: 0px;border-left: 0px;margin-right: 0px;border-bottom: 0px" alt="composition_thumb3[4]" src="//lostechies.com/gabrielschenker/files/2011/03/composition_thumb3_5B00_4_5D005F00_3A4D3389.jpg" align="left" border="0" width="213" height="244" />](//lostechies.com/gabrielschenker/files/2011/03/composition5_411062D9.jpg)OCP by Composition

As stated above the OCP can be followed when a class does not depend on the concrete implementation of dependencies but rather on their abstraction. As a simple sample consider an authentication service that references a logging service to log who is trying to be authenticated and whether the authentications has succeeded or not.

&nbsp;

<div>
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> AuthenticationService</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">private</span> ILogger logger = <span style="color: #0000ff">new</span> TextFileLogger();</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">public</span> ILogger Logger { set{ logger = <span style="color: #0000ff">value</span>; }}</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> Authenticate(<span style="color: #0000ff">string</span> userName, <span style="color: #0000ff">string</span> password)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        logger.Debug(<span style="color: #006080">"Authentication '{0}'"</span>, userName);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">        <span style="color: #008000">// try to authenticate the user</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">}</pre>
  </div>
</div>

Since the the authentication service only depends on an (abstract) interface **ILogger** of the logging service 

&nbsp;

<div>
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> ILogger</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">void</span> Debug(<span style="color: #0000ff">string</span> message, <span style="color: #0000ff">params</span> <span style="color: #0000ff">object</span>[] args);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    <span style="color: #008000">// other methods omitted for brevity</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">}   </pre>
  </div>
</div>

and not on a concrete implementation the behavior of the component can be altered without changing the code of the authentication service. Instead of logging to e.g. a text file which might be the default we can implement another logging service that logs to the event log or to the database. The new logger service has to just implement the interface **ILogger**. At runtime we can inject a different implementation of the logger service into the authentication service, e.g.

<pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">var authService = <span style="color: #0000ff">new</span> AuthenticationService();</pre>

<pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">authService.Logger = <span style="color: #0000ff">new</span> DatabaseLogger();</pre>

There are some good examples publicly available of how a project can adhere to the OCP by using composition. One of my favorites is the OSS project [Fluent NHibernate](http://fluentnhibernate.org/). As an example there the auto-mapping can be modified and/or enhanced without changing the source code of the project. Let&rsquo;s have a look at the usage of the [AutoPersistenceModel](http://code.google.com/p/fluent-nhibernate/source/browse/trunk/src/FluentNHibernate/AutoMap/AutoPersistenceModel.cs) class for illustration.

<div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">var model = <span style="color: #0000ff">new</span> AutoPersistenceModel();</pre>
  
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">model.WithConvention(convention =&gt;</pre>
  
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        {</pre>
  
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">            convention.GetTableName = type =&gt; <span style="color: #006080">"tbl_"</span> + type.Name;</pre>
  
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">            convention.GetPrimaryKeyName = type =&gt; type.Name + <span style="color: #006080">"Id"</span>;</pre>
  
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">            convention.GetVersionColumnName = type =&gt; <span style="color: #006080">"Version"</span>;</pre>
  
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        }</pre>
  
  <p>
    &nbsp;&nbsp;&nbsp;&nbsp; );
  </p>
</div>

Without changing the source code of the **AutoPersistenceModel** class we can change the behavior of the auto mapping process significantly. In this case we have (with the aid of some lambda expression magic &ndash;> see [this post](http://gabrielschenker.lostechies.com/blogs/gabrielschenker/archive/2009/02/03/step-by-step-introduction-to-delegates-and-lambda-expressions.aspx)) changed some of the conventions used when auto-mapping the entities to database tables. We have declared that the name of the database tables should always be the same as the name of the corresponding entity and that the primary key of each table should have the name of the corresponding entity with a postfix &ldquo;Id&rdquo;. Finally the version column of each table should be named &ldquo;Version&rdquo;.

This modification of the (runtime) behavior is possible since the **AutoPersistenceModel** class depends on abstractions &ndash; in this case lambda expressions &ndash; and not on specific implementations. The signature of the **WithConvention** method is as follows

<pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> AutoPersistenceModel WithConvention(Action&lt;Conventions&gt; conventionAction)</pre>

### [<img style="border-right: 0px;border-top: 0px;margin-left: 0px;border-left: 0px;margin-right: 0px;border-bottom: 0px" alt="inheritance_thumb2[4]" src="//lostechies.com/gabrielschenker/files/2011/03/inheritance_thumb2_5B00_4_5D005F00_6CA0E13B.jpg" align="right" border="0" width="244" height="137" />](//lostechies.com/gabrielschenker/files/2011/03/inheritance4_6BF82B11.jpg)OCP by Inheritance

Let&rsquo;s assume we want to implement a little paint application which can draw different shapes in a window. At first we start with only one single kind of graphical shape namely lines. A line might me defined as follows

&nbsp;

<div>
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Line</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Draw(ICanvas canvas)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    { <span style="color: #008000">/* draw a line on the canvas */</span> }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">}</pre>
  </div>
</div>

It has a draw method which expects a canvas as parameter.

Now our paint application might contain a **Painter** class which is responsible to manage all line objects and which contains a method **DrawAll** which draws all lines on a canvas.

<div>
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Painter</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">private</span> IEnumerable&lt;Line&gt; lines;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> DrawAll()</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        ICanvas canvas = GetCanvas(); </pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">        <span style="color: #0000ff">foreach</span> (var line <span style="color: #0000ff">in</span> lines)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">            line.Draw(canvas);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    </pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    <span style="color: #008000">/* other code omitted for brevity */</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">}</pre>
  </div>
</div>

This application has been in use for a while. Now all of the sudden the users does not only want to paint lines but also rectangles. A naive approach would now be to first implement a new class **Rectangle** class similar to the line class which also has a **Draw** method

<div>
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Rectangle</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Draw(ICanvas canvas)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    { <span style="color: #008000">/* draw a line on the canvas */</span> }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">}</pre>
  </div>
</div>

and then modify the **Painter** class to account for the fact that now we also have to manage and paint rectangles

<div>
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Painter</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">private</span> IEnumerable&lt;Line&gt; lines;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    <span style="color: #0000ff">private</span> IEnumerable&lt;Rectangle&gt; rectangles;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> DrawAll()</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">        ICanvas canvas = GetCanvas(); </pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        <span style="color: #0000ff">foreach</span> (var line <span style="color: #0000ff">in</span> lines)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">        {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">            line.Draw(canvas);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">        }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        <span style="color: #0000ff">foreach</span> (var rectangle <span style="color: #0000ff">in</span> rectangles)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">        {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">            rectangle.Draw(canvas);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">        }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">}</pre>
  </div>
</div>

One can easily see that the **Painter** class is certainly not adhering to the open/closed principle. To be able to also manage and paint the rectangles we had to change its source code. As such the **Painter** class was not _closed for modifications_.

Now we can easily fix this problem by using inheritance. We just define a base class **Shape** from which all other concrete shapes (e.g. lines and rectangles) inherit. The **Painter** class then only deals with shapes. Let&rsquo;s first define the (abstract) **Shape** class

<div>
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">class</span> Shape</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">void</span> Draw(ICanvas canvas);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">}</pre>
  </div>
</div>

All concrete shapes have to inherit from this class. Thus we have to modify the **Line** and the **Rectangle** class like this (note the override keyword on the draw method)

<div>
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Line : Shape</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Draw(ICanvas canvas)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    { <span style="color: #008000">/* draw a line on the canvas */</span> }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">}</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Rectangle : Shape</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Draw(ICanvas canvas)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    { <span style="color: #008000">/* draw a line on the canvas */</span> }</pre>
    
    <p>
      }
    </p>
  </div>
</div>

Finally we we modify the **Painter** such as that it only references shapes and not lines or rectangles

<div>
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Painter</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">private</span> IEnumerable&lt;Shape&gt; shapes;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> DrawAll()</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        ICanvas canvas = GetCanvas(); </pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">        <span style="color: #0000ff">foreach</span> (var shape <span style="color: #0000ff">in</span> shapes)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">            shape.Draw(canvas);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">}</pre>
  </div>
</div>

If ever the user wants to extend the paint application and have other shapes like ellipses or Bezier curves the **Painter** class (and especially the **DrawAll** method) has not to be changed any more. Still the **Painter** can draw ellipses or Bezier curves since these new shapes will have to inherit from the (abstract) base class **Shape**. The **Painter** class is now _closed for modification_ but _open for extension_ since we can add other kinds of shapes.

### Conclusion

I&rsquo;d like to see OCP done in conjunction with &#8220;prefer composition over inheritance&#8221; and as such, I prefer classes that have no virtual methods and are possibly sealed, but depend on abstractions for their extension.&nbsp; I consider this to be the &ldquo;ideal&rdquo; way to do OCP, as you&#8217;ve enforced the &#8220;C&#8221; and provided the &#8220;O&#8221; simultaneously.&nbsp; Of course, please don&#8217;t construe this as meaning that there is no way to use inheritance properly or that inheritance somehow violates OCP.&nbsp; It doesn&#8217;t.&nbsp; It&#8217;s just that because of the way most of us learned OOP, we tend to think of inheritance first, when people talk about &#8220;extension of an object&#8221; .
{% endraw %}
