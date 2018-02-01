---
id: 153
title: 'Advanced mocking: anonymous test spy'
date: 2008-03-07T03:43:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/03/06/advanced-mocking-anonymous-test-spy.aspx
dsq_thread_id:
  - "264715589"
categories:
  - TDD
  - Testing
---
When practicing TDD, I create interfaces to abstract away the ugly stuff, like databases, file I/O, web service calls, email messages, and other external systems.&nbsp; I can run tests now that don&#8217;t have to interact with real implementations of these external components, which may or may not be available all the time or may take a long time to run in practice.

But when testing a class that uses these components, I often want to verify messages or objects passed to these fake components.&nbsp; Unfortunately, these messages are created internally in the method, and I don&#8217;t have a way to access them directly.&nbsp; For example, consider the OrderFulfillmentService, which needs to send emails when orders are fulfilled:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">OrderFulfillmentService<br /></span>{<br />    <span style="color: blue">private readonly </span><span style="color: #2b91af">IMailSender </span>_mailSender;<br /><br />    <span style="color: blue">public </span>OrderFulfillmentService(<span style="color: #2b91af">IMailSender </span>mailSender)<br />    {<br />        _mailSender = mailSender;<br />    }<br /><br />    <span style="color: blue">public void </span>ProcessOrder(<span style="color: #2b91af">Order </span>order)<br />    {<br />        <span style="color: green">// hit database, whatever<br /><br />        //send email<br />        </span><span style="color: blue">string </span>body = <span style="color: #a31515">"Your order is ready!rnOrder #:" </span>+ order.OrderNumber;<br /><br />        <span style="color: #2b91af">MailMessage </span>message =<br />            <span style="color: blue">new </span><span style="color: #2b91af">MailMessage</span>(<span style="color: #a31515">"sender@email.com"</span>, <span style="color: #a31515">"recipient@email.com"</span>,<br />                            <span style="color: #a31515">"Order processed"</span>, body);<br /><br />        _mailSender.SendMessage(message);<br />    }<br />}<br /></pre>

[](http://11011.net/software/vspaste)

What I&#8217;d like to do is verify the MailMessage being sent to the IMailSender has the correct sender and recipient email addresses, and maybe that the body contains the OrderNumber.&nbsp; But the creation of the MailMessage is internal to the method, and I really don&#8217;t feel like extracting all of that out to a different public method or class if I don&#8217;t need to.

All I really care about is that when the OrderFulfillmentService processes an order, the correct email gets sent out.&nbsp; If I extract the email creation to a separate class, I still have to write additional tests to ensure that the correct email message gets sent out, so I&#8217;m not that much better off going that route.

If I could somehow intercept or catch the message being sent to the IMailSender in a test, I could verify its contents.&nbsp; That&#8217;s where the [Test Spy pattern](http://xunitpatterns.com/Test%20Spy.html) can help out.&nbsp; Both with and without Rhino Mocks, I can intercept this indirect output.

### Here come the mocks!

Since we don&#8217;t want real emails being sent out during testing, we&#8217;ll create a test double to stand in the IMailSender&#8217;s place.&nbsp; But the test double we use will be special, as we want to create a test to check the contents of the indirect outputs of the MailMessage.

To do this, we&#8217;ll create a Test Spy that snags the MailMessage and sticks the result into a local field that we can look at later in the test:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">MailSenderTestSpy </span>: <span style="color: #2b91af">IMailSender<br /></span>{<br />    <span style="color: blue">public </span><span style="color: #2b91af">MailMessage </span>Message = <span style="color: blue">null</span>;<br /><br />    <span style="color: blue">public void </span>SendMessage(<span style="color: #2b91af">MailMessage </span>message)<br />    {<br />        Message = message;<br />    }<br />}<br /></pre>

[](http://11011.net/software/vspaste)

Pretty simple little class, I just stick whatever gets passed in to a local field.&nbsp; So what will the test look like?&nbsp; Here&#8217;s what I came up with:

<pre>[<span style="color: #2b91af">Test</span>]<br /><span style="color: blue">public void </span>Should_create_order_details_email_manually()<br />{<br />    <span style="color: #2b91af">MailSenderTestSpy </span>sender = <span style="color: blue">new </span><span style="color: #2b91af">MailSenderTestSpy</span>();<br />    <span style="color: #2b91af">OrderFulfillmentService </span>service = <span style="color: blue">new </span><span style="color: #2b91af">OrderFulfillmentService</span>(sender);<br /><br />    <span style="color: #2b91af">Order </span>order = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>();<br />    order.OrderNumber = <span style="color: #a31515">"8574-PO8468371"</span>;<br /><br />    service.ProcessOrder(order);<br /><br />    <span style="color: #2b91af">MailMessage </span>message = sender.Message;<br /><br />    <span style="color: #2b91af">Assert</span>.IsNotNull(message);<br />    <span style="color: #2b91af">Assert</span>.AreEqual(<span style="color: #a31515">"sender@email.com"</span>, message.From.Address);<br />    <span style="color: #2b91af">Assert</span>.AreEqual(1, message.To.Count);<br />    <span style="color: #2b91af">Assert</span>.AreEqual(<span style="color: #a31515">"recipient@email.com"</span>, message.To[0].Address);<br />    <span style="color: #2b91af">StringAssert</span>.Contains(order.OrderNumber, message.Body);<br />}<br /></pre>

[](http://11011.net/software/vspaste)

The setup of the OrderFulfillmentService is normal, except I pass in an instance of my test spy (soooo sneaky).&nbsp; After calling the ProcessOrder method, I grab out the MailMessage.&nbsp; Finally, I verify the contents of the MailMessage according to the customer&#8217;s specifications.

Creating the Test Spy manually is all well and good, so how might we create one in Rhino Mocks?

### Enter Rhino Mocks

In most mocking scenarios, I set expectations that methods will get called, and later verify these expectations.&nbsp; In the Test Spy case, I not only want to set expectation that the method will get called, but I want to additionally grab the MailMessage when the mock gets called.&nbsp; Luckily, I can supply extra behavior with the [Do() method](http://www.ayende.com/Wiki/Rhino+Mocks+The+Do()+Handler.ashx) in Rhino Mocks.&nbsp; Let&#8217;s take a look at the test:

<pre>[<span style="color: #2b91af">Test</span>]<br /><span style="color: blue">public void </span>Should_create_order_details_email()<br />{<br />    <span style="color: #2b91af">MockRepository </span>mocks = <span style="color: blue">new </span><span style="color: #2b91af">MockRepository</span>();<br />    <span style="color: #2b91af">IMailSender </span>sender = mocks.CreateMock&lt;<span style="color: #2b91af">IMailSender</span>&gt;();<br /><br />    <span style="color: #2b91af">MailMessage </span>message = <span style="color: blue">null</span>;<br /><br />    <span style="color: blue">using </span>(mocks.Record())<br />    {<br />        sender.SendMessage(<span style="color: blue">null</span>);<br /><br />        <span style="color: #2b91af">LastCall<br />            </span>.IgnoreArguments()<br />            .Do(<span style="color: blue">new </span><span style="color: #2b91af">Action</span>&lt;<span style="color: #2b91af">MailMessage</span>&gt;(actual =&gt; message = actual));<br />    }<br /><br />    <span style="color: #2b91af">OrderFulfillmentService </span>service = <span style="color: blue">new </span><span style="color: #2b91af">OrderFulfillmentService</span>(sender);<br /><br />    <span style="color: #2b91af">Order </span>order = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>();<br />    order.OrderNumber = <span style="color: #a31515">"8574-PO8468371"</span>;<br /><br />    service.ProcessOrder(order);<br /><br />    mocks.VerifyAll();<br /><br />    <span style="color: #2b91af">Assert</span>.IsNotNull(message);<br />    <span style="color: #2b91af">Assert</span>.AreEqual(<span style="color: #a31515">"sender@email.com"</span>, message.From.Address);<br />    <span style="color: #2b91af">Assert</span>.AreEqual(1, message.To.Count);<br />    <span style="color: #2b91af">Assert</span>.AreEqual(<span style="color: #a31515">"recipient@email.com"</span>, message.To[0].Address);<br />    <span style="color: #2b91af">StringAssert</span>.Contains(order.OrderNumber, message.Body);<br />}<br /></pre>

[](http://11011.net/software/vspaste)

Instead of creating my custom little Test Spy class, I use RhinoMocks and the CreateMock method to create a mock implementation of the IMailSender.&nbsp; Rhino Mocks creates an implementation at runtime, so I never have to worry about managing this extra test double class.

In the Record phase, I call the SendMessage method on the IMailSender, but I pass in null.&nbsp; This looks strange, don&#8217;t I actually want something sent in?&nbsp; In normal mocking scenarios where I&#8217;m verifying the arguments, I would pass the real arguments I expect would be used by the class under test.&nbsp; But since the MailMessage is created **inside the ProcessOrder method**, I don&#8217;t know what the MailMessage is.

In the next part, I use LastCall to get at the last method call to a mock object (in this case the SendMessage) and start applying expectations and options.&nbsp; I IgnoreArguments, as I don&#8217;t want Rhino Mocks to care about the null that was passed in.&nbsp; That&#8217;s why the null doesn&#8217;t matter, I explicitly tell Rhino Mocks not to care.&nbsp; Finally, I use the Do method to supply a custom [Action<MailMessage>](http://msdn2.microsoft.com/en-us/library/018hxwa8.aspx), giving it a [lambda expression](http://msdn2.microsoft.com/en-us/library/bb397687.aspx) that creates a [closure](http://diditwith.net/PermaLink,guid,235646ae-3476-4893-899d-105e4d48c25b.aspx) and captures the MailMessage that got passed in.

#### 

#### Quick sidenote on the magic

Yes, I know that was a mouthful, but the basic idea is I want to create a [Delegate object](http://msdn2.microsoft.com/en-us/library/system.delegate(VS.80).aspx) that matches the signature of the method I just called (SendMessage).&nbsp; The signature of this method is:

<pre><span style="color: blue">void </span>SendMessage(<span style="color: #2b91af">MailMessage </span>message);</pre>

[](http://11011.net/software/vspaste)

Since Rhino Mocks expects an instance of a Delegate object (and not just any old delegate), I can&#8217;t pass in the lambda directly.&nbsp; Instead, I have to create an instance of a delegate type and pass that in.&nbsp; I can create a delegate type directly:

<pre><span style="color: blue">public delegate void </span><span style="color: #2b91af">SendMessageDelegate</span>(<span style="color: #2b91af">MailMessage </span>message);</pre>

[](http://11011.net/software/vspaste)

But instead, I&#8217;ll use the built-in generic delegates (Action<T>) that match my method.&nbsp; For void methods, I use the Action delegates, and for methods that return values, I use the Func delegates.

Finally, I create the lambda expression (I could have used an anonymous delegate, or just the name of a local method that matches that signagture).&nbsp; This is a special lambda expression that has access to the local scope, so I can snag the MailMessage sent in to the lambda and set it to a local variable (this is the closure part).

#### 

#### Back to the test

Skipping past the first part, we can see from the OrderFulfillmentService instantiation on down, the test looks much of the same as the first one.&nbsp; The lamdba part can be strange to look at the first time, but it&#8217;s a succinct way to pass in a custom snippet of behavior.&nbsp; When the SendMessage method gets called by the ProcessOrder method, Rhino Mocks will route that call to the lambda expression I gave it.&nbsp; This lambda expression takes the MailMessage passed in and assigns it to a local variable.

I finish up the test by checking the MailMessage contents, and the test passes just as well as the first example.&nbsp; This time, no extra test spy class hangs around.

### Wrapping it up

Test spys are great for capture indirect outputs of operations.&nbsp; The MailMessage created above couldn&#8217;t be observed directly as I didn&#8217;t return it out of the method, so I had to create a special class to snag the MailMessage that got passed in.&nbsp; Later, I could examine the MailMessage capture and verify its contents to my hearts desire.

I did this with both a custom Test Spy class and with Rhino Mocks.&nbsp; Use whatever one is most clear to the reader of the test, but Rhino Mocks can be helpful in reducing the number of test double classes that can pile up.&nbsp; Since each test in one fixture might use a different kind of test double, using Rhino Mocks eliminates the extra overhead of the test double implementations.