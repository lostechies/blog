---
wordpress_id: 156
title: 'Advanced mocking: mocks and stubs'
date: 2008-03-13T02:16:11+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/03/12/advanced-mocking-mocks-and-stubs.aspx
dsq_thread_id:
  - "264715591"
categories:
  - TDD
---
[Test Spies](http://xunitpatterns.com/Test%20Spy.html) can help us verify the indirect outputs of a system under test.&nbsp; If an OrderProcessor needs to send an email, we don&#8217;t want that test sending real emails, so we set up a Test Spy to capture that indirect output so we can verify it inside our test.

Sometimes a Test Spy isn&#8217;t enough, as our test might have **indirect inputs** as well as indirect outputs.&nbsp; An indirect input is an input variable or value that a method uses that doesn&#8217;t appear in any object passed in to the method.

In the [previous Test Spy example](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/03/06/advanced-mocking-anonymous-test-spy.aspx), our business partners requested that an email be sent out for each order processed.&nbsp; That was yesterday, and today, they have another request.&nbsp; Sometimes, orders are sufficiently large that they would like a sales agent to also be notified by email, so that they might follow up with that customer and try to wring some more sales out of the customer&#8217;s pockets.

Two conditions arise: the order maximum might change, and it might depend on the customer placing the order.&nbsp; After some more conversation, it turns out that the logic behind whether an Order should be emailed to a Sales Rep or not is fairly complex.

So instead of embedded this complex logic inside our order processor, we&#8217;ll extract it into a Specification:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">ISpecification</span>&lt;T&gt;
{
    <span style="color: blue">bool </span>IsSatisfiedBy(T value);
}
</pre>

[](http://11011.net/software/vspaste)

That Specification provides the indirect input that necessitates using a full-blown Mock Object.

### Examining the class under test

With a Mock Object, we want to test both indirect inputs and outputs.&nbsp; To do this, we can modify our original Test Spy to capture the input and provide a canned output.&nbsp; To put this all in context, let&#8217;s take a look at our OrderProcessor:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">OrderFulfillmentService
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IMailSender </span>_mailSender;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ISpecification</span>&lt;<span style="color: #2b91af">Order</span>&gt; _salesSpec;

    <span style="color: blue">public </span>OrderFulfillmentService(<span style="color: #2b91af">IMailSender </span>mailSender, <span style="color: #2b91af">ISpecification</span>&lt;<span style="color: #2b91af">Order</span>&gt; salesSpec)
    {
        _mailSender = mailSender;
        _salesSpec = salesSpec;
    }

    <span style="color: blue">public void </span>ProcessOrder(<span style="color: #2b91af">Order </span>order)
    {
        <span style="color: green">// hit database, whatever

        //send email
        </span><span style="color: blue">if </span>(_salesSpec.IsSatisfiedBy(order))
        {
            <span style="color: blue">string </span>body = <span style="color: #a31515">"Huge frickin' order alert!!!rnOrder #:" </span>+ order.OrderNumber;

            <span style="color: #2b91af">MailMessage </span>message =
                <span style="color: blue">new </span><span style="color: #2b91af">MailMessage</span>(<span style="color: #a31515">"sender@email.com"</span>, <span style="color: #a31515">"salesdude@email.com"</span>,
                                <span style="color: #a31515">"Order processed"</span>, body);

            _mailSender.SendMessage(message);
        }

    }
}
</pre>

[](http://11011.net/software/vspaste)

When the Order satisfies the SalesSpec, the OrderProcessor should send an email to our Sales Rep.&nbsp; Normally, I&#8217;d write the tests before modifying the class under test, but it&#8217;s a little easier to see the scope of the change after it&#8217;s already made.

### Here come the mocks!

As with all Test Doubles, we have a motivation to supply an imposter dependency to our class under test.&nbsp; In this case, the real IMailSender will send emails (which we don&#8217;t want) and the real ISpecification has complicated logic (which we want to keep separate).

For the ISpecification, not only do I want to test the indirect outputs (the Order passed in), but I want to verify the behavior of the system from its indirect outputs.&nbsp; Going back to the original context and specification, &#8220;When the Order satisfies the SalesSpecification, it should send an email to the SalesRep&#8221;.&nbsp; Note the &#8220;should&#8221; part, we want to make sure that the IMailSender was actually called.

#### The manual way

When we care that the interaction between two components, we capture both the messages going back and forth and the number of times the interaction was used.&nbsp; Our IMailSender mock will capture these two pieces of information and expose them for examination later:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">MailSenderMock </span>: <span style="color: #2b91af">IMailSender
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">MailMessage </span>Message = <span style="color: blue">null</span>;
    <span style="color: blue">public int </span>SendMessageCallCount = 0;

    <span style="color: blue">public void </span>SendMessage(<span style="color: #2b91af">MailMessage </span>message)
    {
        Message = message;
        SendMessageCallCount++;
    }
}
</pre>

[](http://11011.net/software/vspaste)

Looking at the ISpecification, I&#8217;m only verifying the interaction between the OrderProcessor and the IMailSender, so I&#8217;ll just hard-code a specific result into a [Test Stub](http://xunitpatterns.com/Test%20Stub.html):

<pre><span style="color: blue">public class </span><span style="color: #2b91af">OrderSpecificationStub </span>: <span style="color: #2b91af">ISpecification</span>&lt;<span style="color: #2b91af">Order</span>&gt;
{
    <span style="color: blue">private readonly bool </span>_result;

    <span style="color: blue">public </span>OrderSpecificationStub(<span style="color: blue">bool </span>result)
    {
        _result = result;
    }
    
    <span style="color: blue">public bool </span>IsSatisfiedBy(<span style="color: #2b91af">Order </span>value)
    {
        <span style="color: blue">return </span>_result;
    }
}
</pre>

[](http://11011.net/software/vspaste)

Note that I always give very intentional names to my Test Doubles.&nbsp; Folks coming back and looking at my tests should be able to understand what I&#8217;m testing by the name of my fixtures, test methods, and variable names.&nbsp; It never hurts to be as explicit and clear as possible.

With these two Test Doubles in place, I&#8217;m ready to create my test:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_send_sales_email_when_order_satisfies_sales_spec_manually()
{
    <span style="color: blue">bool </span>result = <span style="color: blue">true</span>;
    <span style="color: #2b91af">MailSenderMock </span>mailSenderMock = <span style="color: blue">new </span><span style="color: #2b91af">MailSenderMock</span>();
    <span style="color: #2b91af">OrderSpecificationStub </span>orderSpecStub = <span style="color: blue">new </span><span style="color: #2b91af">OrderSpecificationStub</span>(result);

    <span style="color: #2b91af">OrderFulfillmentService </span>service = 
        <span style="color: blue">new </span><span style="color: #2b91af">OrderFulfillmentService</span>(mailSenderMock, orderSpecStub);

    <span style="color: #2b91af">Order </span>order = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>();
    order.OrderNumber = <span style="color: #a31515">"8574-PO8468371"</span>;

    service.ProcessOrder(order);

    <span style="color: #2b91af">MailMessage </span>message = mailSenderMock.Message;

    <span style="color: green">//Verify expectations
    </span><span style="color: #2b91af">Assert</span>.AreEqual(1, mailSenderMock.SendMessageCallCount);

    <span style="color: green">//Verify outputs
    </span><span style="color: #2b91af">Assert</span>.IsNotNull(message);
    <span style="color: #2b91af">Assert</span>.AreEqual(<span style="color: #a31515">"sender@email.com"</span>, message.From.Address);
    <span style="color: #2b91af">Assert</span>.AreEqual(1, message.To.Count);
    <span style="color: #2b91af">Assert</span>.AreEqual(<span style="color: #a31515">"salesdude@email.com"</span>, message.To[0].Address);
    <span style="color: #2b91af">StringAssert</span>.Contains(order.OrderNumber, message.Body);
}
</pre>

[](http://11011.net/software/vspaste)

I test both the expectations (the number of times the method was called) as well as the indirect outputs (the MailMessage).&nbsp; With this test, I know with absolute certainty that when the Order satisfies the SalesSpecification, the MailSender is used to send an email to the sales rep.

When this test passes, I&#8217;ll create an additional test to cover the scenario where the Order _doesn&#8217;t_ meet the SalesSpec specification.&nbsp; In that case, I&#8217;ll just make sure that the SendMessageCallCount is zero and be done.

Again, all these little classes can get annoying to maintain over time.&nbsp; Although they&#8217;re very explicit in their scope, if each fixture has 3-5 TestDouble implementations, they can really add up when your tests get into the thousands.

#### Enter Rhino Mocks

With Rhino Mocks, I can create both Test Stubs and Mocks.&nbsp; It&#8217;s pretty important to understand the different types of Test Doubles before jumping into a tool like Rhino Mocks, as excessive Mock Objects can lead to very brittle tests.&nbsp; I rarely create more than one Mock Object in a single test, although I might have several different Test Doubles going on.

Although the name is deceiving, Rhino Mocks can create all sorts of Test Doubles, including Test Stubs and Mock Objects (obviously).&nbsp; With Rhino Mocks:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_send_sales_email_when_order_satisfies_sales_spec()
{
    <span style="color: #2b91af">MockRepository </span>mocks = <span style="color: blue">new </span><span style="color: #2b91af">MockRepository</span>();
    <span style="color: #2b91af">ISpecification</span>&lt;<span style="color: #2b91af">Order</span>&gt; salesSpec = mocks.Stub&lt;<span style="color: #2b91af">ISpecification</span>&lt;<span style="color: #2b91af">Order</span>&gt;&gt;();
    <span style="color: #2b91af">IMailSender </span>sender = mocks.CreateMock&lt;<span style="color: #2b91af">IMailSender</span>&gt;();

    <span style="color: #2b91af">MailMessage </span>message = <span style="color: blue">null</span>;

    <span style="color: #2b91af">Order </span>order = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>();
    order.OrderNumber = <span style="color: #a31515">"8574-PO8468371"</span>;

    <span style="color: blue">using </span>(mocks.Record())
    {
        <span style="color: #2b91af">SetupResult</span>.For(salesSpec.IsSatisfiedBy(order)).Return(<span style="color: blue">true</span>);

        sender.SendMessage(<span style="color: blue">null</span>);

        <span style="color: #2b91af">LastCall
            </span>.IgnoreArguments()
            .Do(<span style="color: blue">new </span><span style="color: #2b91af">Action</span>&lt;<span style="color: #2b91af">MailMessage</span>&gt;(actual =&gt; message = actual));
    }

    <span style="color: #2b91af">OrderFulfillmentService </span>service = <span style="color: blue">new </span><span style="color: #2b91af">OrderFulfillmentService</span>(sender, salesSpec);

    service.ProcessOrder(order);

    mocks.VerifyAll();

    <span style="color: #2b91af">Assert</span>.IsNotNull(message);
    <span style="color: #2b91af">Assert</span>.AreEqual(<span style="color: #a31515">"sender@email.com"</span>, message.From.Address);
    <span style="color: #2b91af">Assert</span>.AreEqual(1, message.To.Count);
    <span style="color: #2b91af">Assert</span>.AreEqual(<span style="color: #a31515">"salesdude@email.com"</span>, message.To[0].Address);
    <span style="color: #2b91af">StringAssert</span>.Contains(order.OrderNumber, message.Body);
}</pre>

[](http://11011.net/software/vspaste)

In the first part, I create the Stub using the Stub<T> method on the MockRespository.&nbsp; The Rhino Mocks stubs are nice as they provide out-of-the box property implementation.&nbsp; Next, I create the Mock Object using the CreateMock method.&nbsp; This creates the proxy class that will intercept my calls for verification later.&nbsp; It performs much of the same functionality of my manually created Mock Object, but much more flexible.

In the Record section (mocks.Record() part), I set up all of the results and expectations of my Test Doubles:

  * Setup a result for the Test Stub
  * Set up an expectation for the Mock Object
  * Capture the input of the Mock Object (the indirect output of the OrderProcessor)

In the exercise portion, I create the OrderProcessor and pass in the Test Double implementations from Rhino Mocks.&nbsp; To get the ball rolling, I call the ProcessOrder method, and I&#8217;m ready to start verifying.

Finally, in the verification section, I first call the VerifyAll method on the MockRepository.&nbsp; This call verifies all the expectations have been met, such as all methods were called that I set up, and no extra ones were called that I didn&#8217;t set up.&nbsp; I finish up the verification by performing assertions on the indirect output MailMessage I captured earlier.

#### Small sidenote on expectations and verifications

When using Mock Objects, your tests have a distinct pattern to them:

  * Set expectations
  * Verify expectations

In the first section, I set up all the results and method call expectations I expect to be called when exercising the class under test.&nbsp; In the verification section, Rhino Mocks examines the expectations versus what actually happened, and fails my test if it doesn&#8217;t match up.

### So why not use the real implementations?

Most of the backlash against Mock Objects is misdirected against Test Doubles.&nbsp; Test Doubles are absolutely vital in narrowing the scope of failures when something goes wrong.&nbsp; If a test fails but it calls into a hierarchy of a dozen components, how much time do I waste in trying to hunt down the real cause of failure?&nbsp; More than 30 seconds figuring out a test failure is too long.

Mock Objects can be too powerful and overkill in most situations.&nbsp; If my test fails because something was called and I didn&#8217;t set up the expectation, this tends to lead to tests that exactly match implementations.&nbsp; That&#8217;s a test smell of an over-specified test.&nbsp; While tests are supposed to make it easy to change code, if a removing a method call causes an entire fixture and a dozen tests to fail, I haven&#8217;t really gained anything.

The trick is to know the different types of Test Doubles out there, and test what you mean to test.&nbsp; Accidental verifications and assertions by making every Test Double a Mock Object leads to brittleness.&nbsp; Pick the right Test Double for the situation, and your tests will be giving you the value they&#8217;re supposed to.