---
id: 237
title: Three simple Rhino Mocks rules
date: 2008-10-06T02:13:48+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/10/05/three-simple-rhino-mocks-rules.aspx
dsq_thread_id:
  - "264800718"
categories:
  - RhinoMocks
  - TDD
---
In previous versions of Rhino Mocks, the Record/Replay model was the only way to create and verify mocks.&#160; You would have an area that set up expectations in a record mode, then the replay mode would verify your expectations.&#160; What was really strange about the Record/Replay model was that it didn’t vibe with the “Setup, Exercise, Verify” unit test pattern.&#160; It looked like you had verifications in the middle of your setup, and your verification was just one line of code, “VerifyAll”.&#160; In addition, you had to decide _what kind_ of test double you wanted when you created it.&#160; Last time I checked, there were at least four choices, and I’ll never get any of them straight on what exactly they did differently.

With the [new release of Rhino Mocks 3.5](http://ayende.com/Blog/archive/2008/10/05/rhino-mocks-3.5-rtm.aspx), which RTM’d today, the new Arrange, Act, Assert syntax makes it dirt simple to create test doubles for our unit tests.&#160; In fact, I only really abide by three rules for 99.99% of the mocking cases I run into.&#160; All I need to do is abide by three rules:

  1. Use the static MockRepository.GenerateMock method.&#160; Don’t use an instance of a MockRepository, and don’t use the GenerateStub method. 
  2. If the mocked instance method returns a value, use the Stub method to set up a result for that value.&#160; This is an indirect input.
  3. If the mocked instance method does not return a value (void), use the AssertWasCalled/AssertWasNotCalled methods.&#160; This is an indirect output. 

That’s it.&#160; I rarely, almost never, assert a method was called on a method that returns a value.&#160; The assumption is that indirect inputs should be used to alter the control flow in the application, or to be observed later in indirect or direct outputs.&#160; When I started using Rhino Mocks, I set expectations on _every single_ method call.&#160; This led to brittle tests, where the body of the test matched almost exactly the implementation.&#160; It was ridiculous.

Here’s an example of snippet of code we want to test (yes it was test-driven the first time I wrote it):

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

[](http://11011.net/software/vspaste)

Let’s create a test that ensures that when the order specification is a match, we send a message to the SmtpClient:

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

[](http://11011.net/software/vspaste)

I set up the IOrderSpec to return true for IsMatch.&#160; After exercising the OrderProcessor, I ensure that the Send method was called, ignoring any arguments set.&#160; I could have asserted individual parameters, but that’s beyond the scope of this discussion.&#160; What I _don’t_ assert is that the IsMatch method was called.&#160; I don’t care.&#160; If the IsMatch method isn’t called, the Send method won’t be called.&#160; I’ll have more tests to cover the other situations, which will cover all my behavioral specifications I want on the OrderProcessor.

I should also note that I could care less what the GenerateMock method was named.&#160; It could be called GenerateFloogle for all I care, all I’m interested in is how I use the Floogle.&#160; Or Test Double, it doesn’t matter.&#160; I just want a test double, I’ll decide how to use it.&#160; The nice thing about the Rhino Mocks AAA syntax is that I can explicitly setup and verify whatever I want, and the test will fail if I don’t.&#160; I don’t stub properties any more, as I don’t really have any interfaces with properties at this point.&#160; Interfaces are for the most part stateless services, so I don’t need any fancy auto-property behavior for stubs.

Sticking with these three rules for the 99% cases ensures I have good dependency interfaces that conform well to the command/query separation, that method should either perform an operation and return void, or query an object and not change anything.&#160; With the new AAA syntax and these rules, I’ve found my tests to be far less brittle, and much more expressive in describing the behavior I’m specifying.