---
id: 446
title: Putting mocks in their place
date: 2011-01-07T04:28:53+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2011/01/06/putting-mocks-in-their-place.aspx
dsq_thread_id:
  - "264716630"
categories:
  - TDD
---
Awhile back, I talked about [3 simple rules for Rhino Mocks](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/10/05/three-simple-rhino-mocks-rules.aspx):

  1. Use the static MockRepository.GenerateMock method.&#160; Don’t use an instance of a MockRepository, and don’t use the GenerateStub method. 
  2. If the mocked instance method returns a value, use the Stub method to set up a result for that value.&#160; This is an indirect input. 
  3. If the mocked instance method does not return a value (void), use the AssertWasCalled/AssertWasNotCalled methods.&#160; This is an indirect output. 

This can be simplified even further – if we’re following command-query separation, then it really comes down to having two types of methods:

  * Commands – these are Action-based delegates.&#160; They perform an action, but return nothing (void) 
  * Queries – these are Func-based delegates.&#160; They answer a question, but they do NOT modify state 

If we follow this rule, then our Rhino Mocks rules become:

  * Use Stub for Queries 
  * Use AssertWasCalled for Commands 

After using flavors of TDD, BDD and so on for a few years, I’ve had a bit of an epiphany.&#160; **Mocks, stubs, fakes and the like are most valuable when they replace external dependencies**.

Why?

Unit tests with mocks and stubs leak implementation details into the test, leading to a test that’s coupled to the internal implementation of how the tested class does its job.&#160; Tests coupled to the implementation of the class under test are a barrier to refactoring.&#160; If our tests become a barrier to refactoring, it kills one of the purported benefits of refactoring – providing a safety net for refactoring!

So where do mocks belong?

Where things are hard to test, like databases, web services, configuration files, and so on.&#160; Components outside the core logic of our application, that we don’t have control over.

### An example

Back in the original post, we looked at an order processor:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">OrderProcessor
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ISmtpClient </span>_client;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IOrderSpec </span>_spec;

    <span style="color: blue">public </span>OrderProcessor(<span style="color: #2b91af">ISmtpClient </span>client, <span style="color: #2b91af">IOrderSpec </span>spec)
    {
        _client = client;
        _spec = spec;
    }

    <span style="color: blue">public void </span>PlaceOrder(<span style="color: #2b91af">Order </span>order)
    {
        <span style="color: blue">if </span>(_spec.IsMatch(order))
        {
            <span style="color: blue">string </span>body = <span style="color: #a31515">"Huge frickin' order alert!!!rnOrder #:" </span>+ order.OrderNumber;

            <span style="color: #2b91af">MailMessage </span>message =
                <span style="color: blue">new </span><span style="color: #2b91af">MailMessage</span>(<span style="color: #a31515">"sender@email.com"</span>, <span style="color: #a31515">"salesdude@email.com"</span>,
                                <span style="color: #a31515">"Order processed"</span>, body);

            _client.Send(message);
        }

        order.Status = <span style="color: #2b91af">OrderStatus</span>.Submitted;
    }
}</pre>

Suppose that we don’t like how we chose how the OrderProcessor matched on the specification, and decided to go a completely different direction.&#160; Yes, we can’t test email, but let’s look at the implementation details in our test:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_send_an_email_when_the_order_spec_matches()
{
    <span style="color: green">// Arrange
    </span><span style="color: blue">var </span>client = <span style="color: #2b91af">MockRepository</span>.GenerateMock&lt;<span style="color: #2b91af">ISmtpClient</span>&gt;();
    <span style="color: blue">var </span>spec = <span style="color: #2b91af">MockRepository</span>.GenerateMock&lt;<span style="color: #2b91af">IOrderSpec</span>&gt;();
    <span style="color: blue">var </span>order = <span style="color: blue">new </span><span style="color: #2b91af">Order </span>{Status = <span style="color: #2b91af">OrderStatus</span>.New, Total = 500m};

    spec.Stub(x =&gt; x.IsMatch(order)).Return(<span style="color: blue">true</span>);

    <span style="color: blue">var </span>orderProcessor = <span style="color: blue">new </span><span style="color: #2b91af">OrderProcessor</span>(client, spec);

    <span style="color: green">// Act
    </span>orderProcessor.PlaceOrder(order);

    <span style="color: green">// Assert
    </span>client.AssertWasCalled(x =&gt; x.Send(<span style="color: blue">null</span>), opt =&gt; opt.IgnoreArguments());
    order.Status.ShouldEqual(<span style="color: #2b91af">OrderStatus</span>.Submitted);
}</pre>

The whole need for an OrderProcessor to need an IOrderSpec, or that the IsMatch method is called is an implementation detail.&#160; If we want to make large, interesting changes to this class, we’ll need to just ditch these tests altogether.&#160; And if we have to delete tests every time an implementation changes, how is that a safety net?&#160; It’s not.

Instead, I’ll write my tests quite a bit differently, ones where dependencies don’t show up unless they truly cannot be used, and even then, I’ll try and build out fake implementations that are easily re-usable.&#160; In the next post, I’ll go through this style of test that allows refactoring much more easily than the implementation leaks of the above test.