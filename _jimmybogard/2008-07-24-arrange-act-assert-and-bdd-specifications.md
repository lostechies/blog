---
wordpress_id: 210
title: Arrange Act Assert and BDD specifications
date: 2008-07-24T12:18:04+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/07/24/arrange-act-assert-and-bdd-specifications.aspx
dsq_thread_id:
  - "264715841"
categories:
  - BDD
  - BehaviorDrivenDevelopment
  - Tools
---
With Rhino Mocks 3.5 just around the corner, I&#8217;ve started using it to create much more readable tests.&nbsp; One of the things that always bothered me with Expect.Call, constraints and the like was that it mixed in the Arrange with Assert.&nbsp; For those that haven&#8217;t heard of AAA, it&#8217;s a pattern for authoring unit tests:

  * Arrange &#8211; set up the unit under test
  * Act &#8211; exercise the unit under test, capturing any resulting state
  * Assert &#8211; verify the behavior through assertions

As I moved towards BDD context/specification style tests, working with Rhino Mocks didn&#8217;t fit the picture very well.&nbsp; But with the new AAA syntax of Rhino Mocks 3.5, I can very cleanly separate out the behavior I want to observe from the mechanics of setting up the test.

Here&#8217;s a normal unit test, as I would have written it about a year ago:

<pre>[<span style="color: #2b91af">Fact</span>]
<span style="color: blue">public void </span>Should_send_email_when_order_is_over_200()
{
    <span style="color: #2b91af">MockRepository </span>repo = <span style="color: blue">new </span><span style="color: #2b91af">MockRepository</span>();

    <span style="color: green">//Arrange
    </span><span style="color: #2b91af">ISmtpClient </span>mockClient = repo.DynamicMock&lt;<span style="color: #2b91af">ISmtpClient</span>&gt;();
    <span style="color: #2b91af">IOrderSpec </span>stubSpec = repo.DynamicMock&lt;<span style="color: #2b91af">IOrderSpec</span>&gt;();
    <span style="color: #2b91af">MailMessage </span>actual = <span style="color: blue">null</span>;

    <span style="color: #2b91af">Order </span>order = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>();
    order.Total = 201.0m;

    <span style="color: blue">using </span>(repo.Record())
    {
        mockClient.Send(<span style="color: blue">null</span>);

        <span style="color: green">// Also assert?
        </span><span style="color: #2b91af">LastCall
            </span>.IgnoreArguments()
            .Do(<span style="color: blue">new </span><span style="color: #2b91af">Action</span>&lt;<span style="color: #2b91af">MailMessage</span>&gt;(message =&gt; actual = message));

        <span style="color: #2b91af">SetupResult
            </span>.For(stubSpec.IsMatch(order))
            .Return(<span style="color: blue">true</span>);
    }

    <span style="color: #2b91af">OrderProcessor </span>pr = <span style="color: blue">new </span><span style="color: #2b91af">OrderProcessor</span>(mockClient, stubSpec);

    <span style="color: green">// Act
    </span>pr.PlaceOrder(order);

    <span style="color: green">// Assert
    </span>actual.ShouldNotBeNull();
    actual.To.Count.ShouldEqual(1);
    actual.To[0].Address.ShouldEqual(<span style="color: #a31515">"salesdude@email.com"</span>);

    repo.VerifyAll();
}
</pre>

[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)

It&#8217;s a really long test, but the basic idea is that an email needs to be sent out to the sales guy when big orders get placed.&nbsp; The sales guy wanted to follow up immediately, to try and sell more (we think).&nbsp; I see many issues with this test:

  * It&#8217;s frickin&#8217; huge
  * I can&#8217;t tell what the point of it is at first glance
  * It&#8217;s really hard to tell what&#8217;s being tested

Moving towards the context/specification style, but still with Rhino Mocks improved things somewhat, but it&#8217;s still quite awkward:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">When_placing_a_large_order 
    </span>: <span style="color: #2b91af">ContextSpecification
</span>{
    <span style="color: blue">private </span><span style="color: #2b91af">MockRepository </span>_repo;
    <span style="color: blue">private </span><span style="color: #2b91af">OrderProcessor </span>_orderProcessor;
    <span style="color: blue">private </span><span style="color: #2b91af">Order </span>_order;
    <span style="color: blue">private </span><span style="color: #2b91af">MailMessage </span>_actual;

    <span style="color: blue">protected override void </span>EstablishContext()
    {
        _repo = <span style="color: blue">new </span><span style="color: #2b91af">MockRepository</span>();

        <span style="color: #2b91af">ISmtpClient </span>mockClient = _repo.DynamicMock&lt;<span style="color: #2b91af">ISmtpClient</span>&gt;();
        <span style="color: #2b91af">IOrderSpec </span>stubSpec = _repo.DynamicMock&lt;<span style="color: #2b91af">IOrderSpec</span>&gt;();
        _actual = <span style="color: blue">null</span>;

        _order = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>();
        _order.Total = 201.0m;

        <span style="color: blue">using </span>(_repo.Record())
        {
            mockClient.Send(<span style="color: blue">null</span>);

            <span style="color: green">// Also assert?
            </span><span style="color: #2b91af">LastCall
                </span>.IgnoreArguments()
                .Do(<span style="color: blue">new </span><span style="color: #2b91af">Action</span>&lt;<span style="color: #2b91af">MailMessage</span>&gt;(message =&gt; _actual = message));

            <span style="color: #2b91af">SetupResult
                </span>.For(stubSpec.IsMatch(_order))
                .Return(<span style="color: blue">true</span>);
        }

        _orderProcessor = <span style="color: blue">new </span><span style="color: #2b91af">OrderProcessor</span>(mockClient, stubSpec);
    }

    <span style="color: blue">protected override void </span>Because()
    {
        _orderProcessor.PlaceOrder(_order);
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Should_send_the_email_out()
    {
        _actual.ShouldNotBeNull();
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Email_sent_should_be_addressed_to_the_sales_guy()
    {
        _actual.To.Count.ShouldEqual(1);
        _actual.To[0].Address.ShouldEqual(<span style="color: #a31515">"salesdude@email.com"</span>);
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Should_verify_all_expectations()
    {
        _repo.VerifyAll();
    }
}
</pre>

[](http://11011.net/software/vspaste)

Again, I have to do some strange things to capture the output, and the record/replay model doesn&#8217;t jive well with BDD-style specifications.&nbsp; I always had this one observation that said, &#8220;Should verify all expectations&#8221;.&nbsp; Not very interesting, and not descriptive of the behavior I want to observe.&nbsp; It doesn&#8217;t describe any behavior, just some cleanup assertion for the MockRepository.

Finally, let&#8217;s see how the AAA syntax of Rhino Mocks 3.5 clears things up:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">When_placing_a_large_order 
    </span>: <span style="color: #2b91af">ContextSpecification
</span>{
    <span style="color: blue">private </span><span style="color: #2b91af">OrderProcessor </span>_orderProcessor;
    <span style="color: blue">private </span><span style="color: #2b91af">Order </span>_order;
    <span style="color: blue">private </span><span style="color: #2b91af">ISmtpClient </span>_mockClient;

    <span style="color: blue">protected override void </span>EstablishContext()
    {
        _mockClient = Dependency&lt;<span style="color: #2b91af">ISmtpClient</span>&gt;();
        <span style="color: #2b91af">IOrderSpec </span>stubSpec = Stub&lt;<span style="color: #2b91af">IOrderSpec</span>&gt;();

        _order = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>();
        _order.Total = 201.0m;

        stubSpec.Stub(x =&gt; x.IsMatch(_order)).Return(<span style="color: blue">true</span>);

        _orderProcessor = <span style="color: blue">new </span><span style="color: #2b91af">OrderProcessor</span>(_mockClient, stubSpec);
    }

    <span style="color: blue">protected override void </span>Because()
    {
        _orderProcessor.PlaceOrder(_order);
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Should_send_the_email_to_the_sales_guy()
    {
        _mockClient.Expect(x =&gt; x.Send(<span style="color: #2b91af">Arg</span>&lt;<span style="color: #2b91af">MailMessage</span>&gt;.Matches(msg =&gt; msg.To[0].Address == <span style="color: #a31515">"salesdude@email.com"</span>)));
    }
}
</pre>

[](http://11011.net/software/vspaste)

That&#8217;s a lot smaller!&nbsp; I clearly separate the Arrange (EstablishContext) from Act (Because) and the Assert, which is my actual observation.&nbsp; To stub the indirect input of the IOrderSpec, I can use the Stub extension method provided by Rhino Mocks 3.5.

But the best aspect of the new AAA syntax is that I can finally create readable specifications that use Rhino Mocks.&nbsp; Before, all of the noise of the Record/Replay and the MockRepository obscured the intention of the specification.&nbsp; I had to rely on test spies earlier to capture the output of the ISmtpClient.Send call, as the old constraint model would have mixed in the Assert with the Arrange (i.e., I would have to put the constraints in the record section.&nbsp; Not pretty.)

I&#8217;ve found that without the distractions of the old Rhino Mocks syntax, I can better focus on the behavior I&#8217;m trying to observe.&nbsp; It&#8217;s now just one line to set up indirect inputs with stubs, and one line to verify interactions and indirect outputs.