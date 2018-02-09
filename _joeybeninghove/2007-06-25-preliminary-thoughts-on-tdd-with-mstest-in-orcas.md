---
wordpress_id: 19
title: Preliminary thoughts on TDD with MSTest in Orcas
date: 2007-06-25T02:46:01+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/06/24/preliminary-thoughts-on-tdd-with-mstest-in-orcas.aspx
categories:
  - mbunit
  - mstest
  - Productivity
  - Resharper
  - TDD
  - Tools
redirect_from: "/blogs/joeydotnet/archive/2007/06/24/preliminary-thoughts-on-tdd-with-mstest-in-orcas.aspx/"
---
[Naysawn](http://blogs.msdn.com/nnaderi/default.aspx), the PM for MSTest, asked that I take a look at the new unit testing features of Orcas, after he read [my thoughts on the (sad) current state of MSTest](http://joeydotnet.com/blog/archive/2006/12/25/15.aspx).&nbsp; Unfortunately, I haven&#8217;t yet had a chance to actually fire up the Orcas VPC to play with it, but Naysawn wrote up [a couple](http://blogs.msdn.com/nnaderi/archive/2007/05/11/new-unit-testing-features-in-orcas-part-1.aspx) [of posts](http://blogs.msdn.com/nnaderi/archive/2007/05/14/new-unit-testing-features-in-orcas-part-2.aspx) describing some of the new features coming to MSTest in Orcas.&nbsp; So I figured I&#8217;d post some initial feedback on his posts as it relates to TDD&#8230;

> [From Naysawn&#8217;s First Post](http://blogs.msdn.com/nnaderi/archive/2007/05/11/new-unit-testing-features-in-orcas-part-1.aspx)&nbsp;(with my comments below each item):
> 
> **1 – Better Execution Times**
> 
> Definitely a long time coming.&nbsp; Speed is a big thing to us serious TDD practitioners.&nbsp; Rapid feedback loops are key to staying productive using TDD.
> 
> **2 – Run Tests**
> 
> Hmm, sounds an awful lot like another tool&nbsp;of which I&#8217;m a huge fan; [Jamie&#8217;s TestDriven.NET](http://testdriven.net/).&nbsp; Of course [Microsoft doesn&#8217;t seem to be too much of a fan](http://weblogs.asp.net/nunitaddin/archive/2007/05/30/microsoft-vs-testdriven-net-express.aspx), but I&#8217;m not even getting into that mess in this post.&nbsp; Bottom line is that I&#8217;ve been using TestDriven.NET with Ctrl-T bound to the exact same commands Naysawn is talking about.&nbsp; So of course having this feature in MSTest is a good thing.
> 
> **3 – Short Cut Keys to Run Tests**
> 
> Being a [serious keyboard junkie](http://joeydotnet.com/blog/archive/2007/04/26/Some-mouseless-computing-tipstools.aspx), this of course would be pretty important to me.&nbsp; Nuff said&#8230;
> 
> **4 – Disable Deployment**
> 
> This one is a biggie for me and probably would be one of my biggest complaints about the current implementation of MSTest.&nbsp; It not only tremendously slows down the testing process in general, but for unsuspecting developers (hmm, as opposed to suspicious developers?&nbsp; 😛&nbsp; ), it can take up a huge amount of space over time.&nbsp; During some past engagements when trying to mentor TDD to folks using VSTS/MSTest, a couple months went by and they were wondering why they were running low on hard drive space.&nbsp; For a decent size application, doing a test run every 5-10 minutes, 5 days a week for a couple months can eat up a ton of space.&nbsp; Shadow copying is a decent idea and I understand what they were trying to accomplish, but at the very least, an option should exist to disable it.
> 
> **5 – Inheritance of Tests**
> 
> This is another important one for me.&nbsp; I&#8217;ve run into quite a few situations where test inheritance really leads to more maintainable tests and can cut down on the set up and customization of a suite of similar test fixtures.&nbsp; For instance, DB integration tests, where you need to refresh the database between tests, but you also need to **override** certain steps for **customization** of individual test fixtures.&nbsp; Of course favoring composition over inheritance is still preferrable, even in unit test code, but sometimes a simple base test class is simply all you need.
> 
> **6 – Directly go to the Point of Failure**
> 
> I actually really like the sound of this one (even though ReSharper has had [something very similar](http://www.jetbrains.com/resharper/documentation/help20/Navigation/stackTraceExplorer.html) for a while now).&nbsp; Just so long as I don&#8217;t have to move my hands _all the way_ over to my mouse to jump to the stack trace.&nbsp; It sounds like a keyboard shortcut could be wired up for that though, so sounds good to me.&nbsp;&nbsp;&nbsp;

> [From Naysawn&#8217;s Second Post](http://blogs.msdn.com/nnaderi/archive/2007/05/14/new-unit-testing-features-in-orcas-part-2.aspx)&nbsp;(with my comments below each item):
> 
> **Gaining Access to Private Code under test**
> 
> I can&#8217;t say I&#8217;m all that excited about this one because a) it starts sliding down that slippery slope of generating unit tests (more on that next) and b) frankly, I tend to not keep too many private&nbsp;methods around.&nbsp; Some of you may gasp at that, but I like to look for opportunities to extract logic out of private methods into separate public/internal&nbsp;classes hidden behind an interface that can be injected into the class under test.&nbsp; I won&#8217;t get too much into that right now, but let&#8217;s just say it can really make code more extensible.&nbsp; I like how [Scott Bellware](http://codebetter.com/blogs/scott.bellware/default.aspx) phrased it in his [Seams, Not Components](http://codebetter.com/blogs/scott.bellware/archive/2007/04/15/161875.aspx) post.&nbsp;&nbsp;In the end, I guess having the ability to test private methods may have a small place, but ideally your classes and methods would be small enough to be driven and tested through its public interface using private methods as minor support if needed (i.e. readability, etc.).
> 
> **Generating Unit Tests**
> 
> Repeat after me.&nbsp; **If I&#8217;m generating my unit tests, I&#8217;m not&nbsp;practicing Test-First Development.&nbsp;** Hope that&#8217;s not too harsh, but no matter how you slice it, you can&#8217;t claim to be driving your code design through tests, if you&#8217;re generating your unit tests from existing code.&nbsp; Sure, I&#8217;ve heard folks say they like to stub out their interfaces/classes first and then generate their unit tests stubs from that.&nbsp; IMO, you&#8217;re tackling too much of the problem at once with that approach.&nbsp; If you&#8217;re really trying to leverage TDD to help you **design** your code, then a lot of the time, you don&#8217;t even know what your interfaces/classes are going to look like until you see them from the **client&#8217;s perspective**.&nbsp; And that is best done from within a unit test where you can express exactly how you want clients of your code to use the public API.&nbsp; It can&#8217;t be stated enough that **TDD is supposed to be primarily a design tool**.
> 
> **Support for Device Projects**
> 
> Having never done any work on embedded devices, can&#8217;t say much about this one.&nbsp; Although it is nice to know that it will be supported.
> 
> **Automatic Cleanup of Test Results and Their Associated Deployments**
> 
> I pretty much covered this in the #4 item above regarding the ability to disable deployments.&nbsp; Again, nice to see some flexibility come to this area of the product.

I definitely think&nbsp;this is a pretty large leap forward for MSTest and I&#8217;m happy to see Naysawn and&nbsp;the developer teams at Microsoft reaching out to the community more and more, and even more important, actually incorporating our feedback into the products.&nbsp; Big kudos for that&#8230;

With that said, [as Jay Flowers points out](http://jayflowers.com/WordPress/?p=163), you&#8217;d be hard pressed to find anything better than [MbUnit](http://mbunit.com/) + [TestDriven.NET](http://testdriven.net/) + [ReSharper](http://jetbrains.com/resharper)&nbsp;right now.&nbsp; And frankly, I don&#8217;t really see that situation&nbsp;changing much even after Orcas is released.&nbsp; However, for those great many of organizations that have chosen or&nbsp;will end up choosing VSTS/MSTest (mostly for the wrong reasons, in my experience), these new features will bring them a little bit closer to the current ideal tools for TDD.