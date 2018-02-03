---
wordpress_id: 321
title: Reflecting reality
date: 2009-06-08T03:18:09+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/06/07/reflecting-reality.aspx
dsq_thread_id:
  - "264716188"
categories:
  - TDD
---
Reading over the latest MSDN magazine issue, I’m always encouraged when I see something that I consider important on the cover, [Test-Driven Design](http://msdn.microsoft.com/en-us/magazine/dd882516.aspx).&#160; It covers one of the more difficult technical aspects of TDD, which is mock objects.&#160; It took me a couple of years before I really understood the “right” way to use mocks as a design tool, and it wasn’t until I read the [Meszaros book](http://www.amazon.com/xUnit-Test-Patterns-Refactoring-Addison-Wesley/dp/0131495054) that the concept of direct and indirect inputs and outputs laid down simple rules for mock objects.

The really strange thing about this article is that it uses NMock as its mock object library.&#160; NMock?&#160; Nothing against the library, but I can count at least two mocking frameworks that are more popular, Rhino Mocks and Moq.&#160; From folks I talk to in the ALT.NET circles, it’s the vast majority of folks using Rhino Mocks, with a healthy following of Moq.&#160; Folks using NMock are those stuck on older codebases, as NMock is (as far as I can tell) the earliest mocking framework for .NET.&#160; It’s all well and good to show one mocking framework, if that’s the one you’re accustomed to, but to not even _mention_ the most popular mocking framework in .NET?&#160; A little strange.

So what’s the real issue?&#160; Here’s some example code from the article:

<pre>[Test]
<span style="color: blue">public void </span>ReceiptTotalForASaleWithNoItemsShouldBeZero()
{
    <span style="color: blue">var </span>receiptReceiver = mockery.NewMock&lt;IReceiptReceiver&gt;();
    <span style="color: blue">var </span>register = <span style="color: blue">new </span>Register();
    register.NewSaleInitiated();

    Expect.Once.On(receiptReceiver).Method(<span style="color: #a31515">"ReceiveTotalDue"</span>).With(0.00);

    register.SaleCompleted();
} </pre>

[](http://11011.net/software/vspaste)

This is frustrating, string-based mocks?&#160; Here’s a fun TDD exercise, rename the ReceiveTotalDue method, and watch how many tests break for the wrong reason.&#160; Tests should fail because of assertion failures, not because I renamed a method.&#160; Additionally, the Arrange-Act-Assert syntax is nowhere to be found.&#160; The AAA syntax made mocking fun, and for me, useful, as the record-replay model led to brittle, difficult to read tests.

Digging deeper, it turns out that the article was written by a ThoughtWorker, and ThoughtWorks sponsors the development of NMock.&#160; I’m glad that mocks got some love in MSDN, but I’d rather the article reflect today’s reality of using mocking frameworks.