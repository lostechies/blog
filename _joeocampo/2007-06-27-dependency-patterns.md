---
id: 28
title: Dependency Patterns
date: 2007-06-27T13:26:24+00:00
author: Joe Ocampo
layout: post
guid: /blogs/joe_ocampo/archive/2007/06/27/dependency-patterns.aspx
dsq_thread_id:
  - "262089166"
categories:
  - Uncategorized
---
<a href="http://codebetter.com/blogs/scott.bellware/default.aspx" target="_blank">Scott Bellware</a> has an excellent post on <a href="http://codebetter.com/blogs/scott.bellware/archive/2007/06/26/164729.aspx" target="_blank">dependency injection patterns</a>.&nbsp; By far this has been a concept that I struggle with in explaining to other developers.

When I first heard of frameworks such as <a href="http://www.springframework.net/" target="_blank">Sprint.Net</a>, <a href="http://www.castleproject.org/container/index.html" target="_blank">Windsor</a>, <a href="http://structuremap.sourceforge.net/Default.htm" target="_blank">StructureMap</a>, it took me a while to grasp their usefulness.&nbsp; I simply saw them as a strategy for making testing easier.&nbsp; I had know idea the benefit they would lend to my architecture.&nbsp; The ability for an <a href="http://en.wikipedia.org/wiki/Inversion_of_control" target="_blank">IoC</a> container to resolve my dependencies automatically, simply from a configuration file is&nbsp;genius.&nbsp; 

The difficult part is wrapping your head around the intended behavior of the &#8220;transparent&#8221; dependency.&nbsp; As you&nbsp;inject a transparent dependency into class, you must expect it to behave a certain way when the consuming class acts upon it.&nbsp; By using Mock objects in place of the physical dependent class you can evolve an interfaces intention upon the acting class through proper TDD testing. I know, I know show us the code.&nbsp; I will, just really busy right now with work!&nbsp; I struggle to find how <a href="http://www.ayende.com/default.aspx" target="_blank">Ayende</a> is able to find the time in the day to work and blog.&nbsp; I am truly not a blog Jedi yet.

I posed the following question to Scott as a joke but he gave and excellent response.

> &#8221;&nbsp;I was wondering what a property injection would be called. Perhaps “Translucent Dependency” &#8220;

Scott&#8217;s reply

> &#8220;Joe,
> 
> Property injection is still a transparent dependency. &nbsp;Properties are typically used for lessor and infrastructural dependencies, like logging, if they&#8217;re used at all. 
> 
> They&#8217;re good for the things that don&#8217;t have to do with the class&#8217;s main concern. The dependencies that are property-injected would muddy the constructor signature with ancillary plumbing and cloud the principal purpose of creating an instance of the class. 
> 
> If the dependency isn&#8217;t something that&#8217;s key to solving the concrete business scenario that the class serves, it likely shouldn&#8217;t be a constructor argument. &nbsp;By making it a property, it can still be assigned (like an instance of ILogger, for example), but it doesn&#8217;t obscure the primal intension of an instance. 
> 
> Setter dependencies are optional.&nbsp; Their types should have a Null Object pattern implementation, and if not it&#8217;s often a good idea to decorate them with one.&nbsp; For example, if an optional dependency hasn&#8217;t been set, it might not be desirable to have a null reference exception when a method is invoked on it.&nbsp; Optional dependencies reserve the right to not be assigned to by the very nature of them not being mandatory or primal constructor arguments.&#8221;