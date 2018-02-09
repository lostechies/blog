---
wordpress_id: 366
title: Willed and forced design
date: 2009-11-13T02:32:19+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/11/12/willed-and-forced-design.aspx
dsq_thread_id:
  - "264716363"
categories:
  - TDD
redirect_from: "/blogs/jimmy_bogard/archive/2009/11/12/willed-and-forced-design.aspx/"
---
Roy Osherove, as a TypeMock employee, presents quite a dilemma from opinionated TDD blog posts simply because whether he has one or not, there’s always the question of agenda.&#160; Which is quite unfortunate, everyone has some sort of selfish agenda at some level.&#160; One of those posts came up in a commentary on [willed and forced design](http://weblogs.asp.net/rosherove/archive/2009/11/12/test-driven-design-willed-vs-forced-designs.aspx), with respect to the usage of mocking frameworks:

> **#1 Willed Design**
> 
> > By writing tests, you can observe the usability of your design from a consumer perspective, and can decide whether or not you like it, and change it accordingly
> 
> **#2 Forced Design**
> 
> > By using a subset of the available isolation frameworks(rhino, moq, nmock) or specific techniques *manual mocks and stubs) you discover cases that are not technically “mockable” or “fakeable” and use that as a sign for design change.

After about 2 seconds of playing around with dynamic languages such as Ruby and JavaScript, the idea that TypeMock is some how “impure” seemed rather silly.&#160; Yes, it bends the CLR in crazy ways, but in and of itself, I believe it has its place.

However, I highly disagree with Roy that #2 is bad, that a tool shouldn’t force my hand in a design.&#160; But there’s a bit of a straw man here – it’s not the _tool_ forcing my design, it’s the _test_ telling me where I need to change my design.&#160; Quite simply, if I run up against something hard to test, my first choice is to isolate that piece.&#160; Here’s an example:

<pre><span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Index()
{
    <span style="color: blue">var </span>user = Session[<span style="color: #a31515">"CurrentUser"</span>];

    <span style="color: blue">return </span>View(user);
}</pre>

[](http://11011.net/software/vspaste)

This piece is awkward to test, even though HttpSessionBase or whatever is a class with virtual methods, and it makes the test ugly.&#160; Yes, I could mock the crap out of this heavyweight object, but that’s not really helping me out, is it?&#160; Instead, I’ll isolate the ugly:

<pre><span style="color: blue">private readonly </span><span style="color: #2b91af">IUserSession </span>_userSession;

<span style="color: blue">public </span>HomeController(<span style="color: #2b91af">IUserSession </span>userSession)
{
    _userSession = userSession;
}

<span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Index()
{
    <span style="color: blue">var </span>user = _userSession.GetUser();

    <span style="color: blue">return </span>View(user);
}</pre>

[](http://11011.net/software/vspaste)

Instead of using a dictionary directly, I’ll hide that business behind a facade service, keeping the dictionary ugliness and duplication in one highly cohesive class.&#160; But it was the \_test\_ that led me to do this, because I’m tuned in to pieces that are hard to mock.&#160; File I/O?&#160; Facade.&#160; Web service proxies?&#160; Facade.&#160; Registry, HttpContext, etc. etc?&#160; All facade.&#160; I want to isolate my core application from the untestable pieces, not because they’re necessary untestable, but because I don’t want to couple my application directly to these external services.&#160; Putting these behind targeted facades eliminates all that duplication that directly using these APIs tends to encourage.

There are plenty of APIs that slapping a simple facade over tends to make things worse, not better, such as:

  * Workflow Foundation
  * SharePoint

And any other framework that requires you to tiiiiightly integrate with in order to be successful.&#160; So where does that leave me and TypeMock?&#160; Well, I don’t use any of those frameworks that require tight coupling, and I don’t have any pain with my current tool of choice in .NET (Rhino Mocks), so why switch exactly?&#160; For those rare occasions I might need TypeMock (DateTime.Now), I [already have a solution](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/11/09/systemtime-versus-isystemclock-dependencies-revisited.aspx) I quite like.&#160; Yes, TypeMock could be free, but the only compelling reason I’d switch would be to another free tool with a better, clearer to write, read and scan API.