---
wordpress_id: 3381
title: Working With Assertions Made on Arguments in Rhino Mocks
date: 2010-03-18T02:44:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2010/03/17/working-with-assertions-made-on-arguments-in-rhino-mocks.aspx
dsq_thread_id:
  - "262175191"
dsq_needs_sync:
  - "1"
categories:
  - Best Practices
  - NUnit
  - RhinoMocks
  - Testing
redirect_from: "/blogs/chrismissal/archive/2010/03/17/working-with-assertions-made-on-arguments-in-rhino-mocks.aspx/"
---
&nbsp;

Today when modifying what we call an &ldquo;order notifier&rdquo; (essentially observers that are notified when an order is placed), I was having trouble figuring out why my test was failing. The project is written in C# and this test was using Rhino Mocks to isolate the EmailService class. We obviously don&rsquo;t want to test our code with an actual email implementation, so a mocking/isolation framework is a perfect tool for abstracting this out and making testing easier.

### The TestFixture and Test I Wrote

Below is a very verbose version of the test class using NUnit. The actual tests use some shared methods for setting up the order and making assertions on the email service. I opted to show more code just so it&rsquo;s easier to see all the setup and verification that was going on.

<div style="border: 1px solid silver;text-align: left;padding: 4px;line-height: 12pt;background-color: #f4f4f4;margin: 20px 0px 10px;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;overflow: auto;cursor: text">
  <div style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">[TestFixture]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Tests</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">{</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    <span style="color: #0000ff">private</span> IEmailService emailService;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">&nbsp;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    [SetUp]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SetUp()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        emailService = MockRepository.GenerateMock&lt;IEmailService&gt;();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">&nbsp;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    [Test]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Notify_should_contain_OrderNumber_and_CustomerNumber_if_Order_NeedsShippingQuote()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        <span style="color: #0000ff">const</span> <span style="color: #0000ff">int</span> customerNumber = 1337;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        <span style="color: #0000ff">const</span> <span style="color: #0000ff">int</span> orderNumber = 2401;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        var order = MockRepository.GenerateMock&lt;IOrder&gt;();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        order.Stub(x =&gt; x.OrderNumber).Return(orderNumber);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        order.Stub(x =&gt; x.CustomerNumber).Return(customerNumber);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        order.Stub(x =&gt; x.NeedsShippingQuote).Return(<span style="color: #0000ff">true</span>);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">&nbsp;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        var notifier = GetNotifier();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">&nbsp;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        notifier.Notify(order);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">&nbsp;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        emailService.AssertWasCalled(x =&gt; x.SendOrderReceived(</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">            Arg&lt;<span style="color: #0000ff">string</span>&gt;.Is.Anything, </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">            Arg&lt;<span style="color: #0000ff">string</span>&gt;.Matches(body =&gt; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">                body.Contains(<span style="color: #006080">"This order needs a shipping quote."</span>) &&</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">                body.Contains(customerNumber.ToString()) &&</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">                body.Contains(orderNumber.ToString())</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">            )));</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">&nbsp;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    <span style="color: #0000ff">public</span> CustomerServiceNotifier GetNotifier()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> CustomerServiceNotifier(emailService);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">}</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        The only additions to this test were those asserting that the email&rsquo;s message body contained the customer number and the order number. With these new expectations set up on the CustomerServiceNotifier, it was time to write the code to make that expectation valid.
      </p>
      
      <h3>
        The Notifier Code
      </h3>
      
      <p>
        Some of this code was removed because it&rsquo;s either not important to this post, or just too lengthy. This is a trimmed down version of the actual implementation.
      </p>
      
      <div style="border: 1px solid silver;text-align: left;padding: 4px;line-height: 12pt;background-color: #f4f4f4;margin: 20px 0px 10px;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;overflow: auto;cursor: text">
        <div style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> CustomerServiceNotifier</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">{</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IEmailService emailService;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    <span style="color: #0000ff">private</span> <span style="color: #0000ff">const</span> <span style="color: #0000ff">string</span> ORDER_NOTES_FORMAT = <span style="color: #006080">"{0}{1}"</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    <span style="color: #0000ff">private</span> <span style="color: #0000ff">const</span> <span style="color: #0000ff">string</span> SHIPPING_QUOTE_FORMAT = </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        <span style="color: #006080">"&lt;br /&gt;This order needs a shipping quote:&lt;br /&gt;Order #: {0}&lt;br /&gt;Cust #:{1}"</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">&nbsp;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    <span style="color: #0000ff">public</span> CustomerServiceNotifier(IEmailService emailService)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        <span style="color: #0000ff">this</span>.emailService = emailService;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">&nbsp;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Notify(IOrder order)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        var emailBuilder = <span style="color: #0000ff">new</span> StringBuilder();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">&nbsp;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        <span style="color: #0000ff">if</span> (order.HasNotes)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">            emailBuilder.AppendFormat(ORDER_NOTES_FORMAT, order.OrderNumber, order.OrderNotes);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">&nbsp;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        <span style="color: #0000ff">if</span> (order.NeedsShippingQuote)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">            emailBuilder.AppendFormat(SHIPPING_QUOTE_FORMAT, order.OrderNumber, order.CustomerNumber);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">&nbsp;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        <span style="color: #0000ff">if</span>(emailBuilder.Length &gt; 0)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">            emailService.SendOrderReceived(order.EmailAddress, emailBuilder.ToString());</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">}</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              The notifier was changed to format the &ldquo;needs shipping quote&rdquo; message to contain the order number and the customer number. If you&rsquo;ve already spotted the mistake, nice work, I didn&rsquo;t find it so fast.
            </p>
            
            <p>
              The failure stated the following:
            </p>
            
            <blockquote>
              <p>
                <span style="font-family: Courier New">IEmailService.SendOrderReceived(anything, body => ((body.Contains(&#8220;This order needs a shipping quote.&#8221;) && body.Contains(1337.ToString())) && body.Contains(2401.ToString()))); Expected #1, Actual #0.</span>
              </p>
            </blockquote>
            
            <p>
              I knew that the method was being called. I couldn&rsquo;t figure out why it was giving me the error message at first. I decided to take advantage of Rhino Mocks&rsquo;s WhenCalled method. This allows you to provide a delegate to do some fancy stuff when that method is called. I just decided to use some simple output so I could see the actual string that was being passed to the mock email service. That was done pretty easily:
            </p>
            
            <div style="border: 1px solid silver;text-align: left;padding: 4px;line-height: 12pt;background-color: #f4f4f4;margin: 20px 0px 10px;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;overflow: auto;cursor: text">
              <div style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">[SetUp]</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SetUp()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">{</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    emailService = MockRepository.GenerateMock&lt;IEmailService&gt;();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    emailService.Stub(x =&gt; x.SendOrderReceived(<span style="color: #0000ff">null</span>, <span style="color: #0000ff">null</span>)).IgnoreArguments()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        .WhenCalled(x =&gt; Console.WriteLine(x.Arguments[1]));</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">}</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    After I generate my mock, I just stub out the method, ignoring any arguments, and output the second argument to the console. I re-ran the test and it gave me the output like so:
                  </p>
                  
                  <blockquote>
                    <p>
                      <span style="font-family: Courier New"><br />This order needs a shipping quote:<br />Order #: 2401<br />Cust #:1337</span>
                    </p>
                  </blockquote>
                  
                  <p>
                    It only took me one look to see the problem and <span style="text-decoration: line-through">scream</span> think: Doh!! The actual text contains a colon character after &ldquo;quote&rdquo; instead of my test which was expecting a period character. The character was changed, I removed the WhenCalled delegate set up and I was back to good. This idea seemed like a nice way to do some debugging without having to slowly step through the code.
                  </p>
                  
                  <h3>
                    Some Thoughts on the Problem
                  </h3>
                  
                  <p>
                    I&rsquo;m all for writing good tests and adhering to best practices and while my unit test above <i>technically</i> only contains only one assertion from Rhino Mocks (a good idea), it&rsquo;s actually making 3 assertions total (not so good). I&rsquo;m checking that the email body contains some text, an order number and a customer number. I really should break this up into 3 separate tests since it&rsquo;s checking 3 requirements within the email body. I guess I have something to do tomorrow morning. 🙂
                  </p>
                  
                  <h3>
                    Some Thoughts on Rhino Mocks WhenCalled Method
                  </h3>
                  
                  <p>
                    I&rsquo;ve found myself using this more and more lately when stubbing out test setup. Primarily when using the WhenCalled method I&rsquo;ve been thinking of it in my head as a &ldquo;pass-through&rdquo;. I want to ask for an object given some specific data and get back a fake object of that type that matches on the value I passed in. I&rsquo;m not sure if the thought in my head is making sense, so I&rsquo;ll give some sample code.
                  </p>
                  
                  <p>
                    The following IScheduleResolver interface is meant to provide an ISchedule back when called. I don&rsquo;t really want to set up a new fake object for all the variations passed in, I just want to return a schedule that is valid (or possibly invalid) for that time I provided. Here&rsquo;s the setup of this idea:
                  </p>
                  
                  <div style="border: 1px solid silver;text-align: left;padding: 4px;line-height: 12pt;background-color: #f4f4f4;margin: 20px 0px 10px;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;overflow: auto;cursor: text">
                    <div style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">
                      <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">scheduleResolver.Stub(x =&gt; x.GetCurrentSchedule(<span style="color: #0000ff">null</span>))</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">    .IgnoreArguments().WhenCalled(a =&gt;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">            var fakeSchedule = MockRepository.GenerateMock&lt;ISchedule&gt;();</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">            fakeSchedule.Stub(x =&gt; x.IsValid((IClock) a.Arguments[0]));</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">            a.ReturnValue = fakeSchedule;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">        });</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          Essentially what this is saying:
                        </p>
                        
                        <blockquote>
                          <p>
                            No matter what IClock value you pass into GetCurrentSchedule, I&rsquo;m going to return a fake ISchedule that is valid for that IClock.
                          </p>
                        </blockquote>
                        
                        <p>
                          You could do the opposite of this too, of course. This has been very helpful in reducing some extra set up I might have otherwise endured during testing.
                        </p>