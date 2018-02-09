---
wordpress_id: 412
title: The religion of dependency injection
date: 2010-05-20T13:02:19+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/05/20/the-religion-of-dependency-injection.aspx
dsq_thread_id:
  - "264716492"
categories:
  - DependencyInjection
  - Rant
redirect_from: "/blogs/jimmy_bogard/archive/2010/05/20/the-religion-of-dependency-injection.aspx/"
---
A quick way to explain a set of differing opinions is to label it as “a religious argument”.&#160; In a post about [using MEF on NerdDinner](http://www.hanselman.com/blog/ExtendingNerdDinnerAddingMEFAndPluginsToASPNETMVC.aspx), Scott Hanselman showed an example on using poor man’s DI versus regular DI.&#160; Now, the post wasn’t about that topic, but more on how to integrate MEF with ASP.NET MVC.&#160; I do get rather annoyed at comments like this however (emphasis mine):

> The second constructor takes an IDinnerRepository, allowing us to make different implementations, but the default constructor says, "well, here&#8217;s a concrete implementation if you don&#8217;t give one." It&#8217;s a slippery slope and by adding the default implementation I get to sidestep using dependency injection while making the controller testable, but I&#8217;ve tied my controller down with a direct dependency to the DinnersController. This is sometimes called "Poor Man&#8217;s IoC" and many would say that this is a very poor man. **That&#8217;s a religious argument**, but Hammett takes a stand by removing the default constructor.

I see a religious argument is an argument whose opposite positions aren’t based in facts, but opinions.&#160; It’s reasoning based on assumptions that are grounded in either faith, ignorance or a matter of opinion.

Something like poor man’s DI versus actual DI is different.&#160; Let’s compare the code.&#160; First, poor man’s DI:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DinnersController
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IDinnerRepository </span>dinnerRepository;

    <span style="color: blue">public </span>DinnersController() : <span style="color: blue">this</span>(<span style="color: blue">new </span><span style="color: #2b91af">DinnerRepository</span>())
    {
    }

    <span style="color: blue">public </span>DinnersController(<span style="color: #2b91af">IDinnerRepository </span>repository)
    {
        dinnerRepository = repository;
    }</pre>

[](http://11011.net/software/vspaste)

Now, regular DI:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DinnersController
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IDinnerRepository </span>dinnerRepository;

    <span style="color: blue">public </span>DinnersController(<span style="color: #2b91af">IDinnerRepository </span>repository)
    {
        dinnerRepository = repository;
    }</pre>

[](http://11011.net/software/vspaste)

In comparison, the poor man’s DI example:

  * Has more code
  * Is coupled to a specific implementation
  * Decides its component’s lifecycle

This isn’t just in the controller, every component used must use this technique.&#160; Anything that DinnerRepository uses also would have to employ this technique, as we’re using the no-argument constructor for DinnerRepository.

I don’t know about you, but **if I can write less code and gain the benefits of looser coupling and externalizing component lifecycle, that’s a win**.

Let’s review.

**Poor man’s DI: more code, more coupled, no flexibility**

**Regular DI: less code, less coupled, high flexibility**

It was a failure in teaching dependency injection that the argument was made based on testability.&#160; It only helps those already doing TDD to shape design, rather than just writing tests.

Instead, DI is about creating highly flexible components, both in lifecycle and component selection.&#160; DI removes component resolution responsibilities from classes, therefore removing code.&#160; And less code is ALWAYS a good thing.