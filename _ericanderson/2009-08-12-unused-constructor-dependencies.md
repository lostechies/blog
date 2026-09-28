---
wordpress_id: 7
title: Unused Constructor Dependencies
date: 2009-08-12T18:55:00+00:00
author: Eric Anderson
layout: post
wordpress_guid: /blogs/eric/archive/2009/08/12/unused-constructor-dependencies.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/eric/archive/2009/08/12/unused-constructor-dependencies.aspx/"
---
<span style="font-size: medium">Some classes simply require multiple dependencies that don&rsquo;t always get used.&nbsp; When testing such a class, there are several options for supplying the constructor parameters that will not be used.&nbsp; I prefer to write tests that are as intention-revealing as possible.&nbsp; </span>

<span style="font-size: medium"></span>

<span style="font-size: medium">To demonstrate, here is a simple example of a payment processing class.&nbsp; Think of the credit card machines that are found at the local grocery store.&nbsp; The basic flow is for the customer to approve the charge amount, then swipe their credit card or debit card and complete the transaction.&nbsp; Below, the PaymentProcessor is responsible for displaying the current charge amount to a user, verifying that they accept the amount, and then sending transaction information to the bank to request funds.&nbsp; Here is an example implementation:</span>

&nbsp;

<div>
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> PaymentProcessor</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">   3:</span>   <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IBankInformationReader _bankInformationReader;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">   4:</span>   <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IBankService _bankService;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">   5:</span>   <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IUserVerification _ui;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">   6:</span>&nbsp; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">   7:</span>   <span style="color: #0000ff">public</span> PaymentProcessor(</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">   8:</span>     IBankInformationReader bankInformationReader, </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">   9:</span>     IBankService bankService, </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  10:</span>     IUserVerification ui)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  11:</span>   {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  12:</span>     _bankInformationReader = bankInformationReader;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  13:</span>     _bankService = bankService;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  14:</span>     _ui = ui;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  15:</span>   }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  16:</span>&nbsp; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  17:</span>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> ProcessPayment(<span style="color: #0000ff">double</span> amount)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  18:</span>   {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  19:</span>     <span style="color: #0000ff">if</span> (!_ui.VerifyAmount(amount))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  20:</span>       <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  21:</span>&nbsp; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  22:</span>     var bankInfo = _bankInformationReader.GetBankInformation();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  23:</span>&nbsp; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  24:</span>     <span style="color: #0000ff">return</span> _bankService.RequestFunds(amount, bankInfo);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  25:</span>   }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  26:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        &nbsp;
      </p>
      
      <p>
        <span style="font-size: medium">The PaymentProcessor depends on IBankInformationReader, IBankService, and IUserVerification.&nbsp; If the user declines the payment amount, then processing should stop immediately.&nbsp; You can see this behavior above in lines 19-20.</span>
      </p>
      
      <p>
        <span style="font-size: medium"></span>
      </p>
      
      <p>
        <span style="font-size: medium">Under this scenario, then PaymentProcessor should never interact with either the IBankInformationReader (used for reading the credit card swipe) or the IBankService (used for submitting the transaction).&nbsp; My preference is to pass null for the dependencies that shouldn&rsquo;t be used, but to do so in an intention-revealing way.&nbsp; Here is an example:</span>
      </p>
      
      <p>
        &nbsp;
      </p>
      
      <div>
        <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left">
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">   1:</span> [Test]</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> should_not_charge_if_the_user_declines_the_amount()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">   3:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">   4:</span>   <span style="color: #0000ff">double</span> amount = 4.50;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">   5:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">   6:</span>   IBankInformationReader cardReaderShouldNotBeUsed = <span style="color: #0000ff">null</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">   7:</span>   IBankService bankServiceShouldNotBeUsed = <span style="color: #0000ff">null</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">   8:</span>   </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">   9:</span>   var ui = Stub&lt;IUserVerification&gt;();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  10:</span>   ui.Stub(x =&gt; x.VerifyAmount(amount)).Return(<span style="color: #0000ff">false</span>);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  11:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  12:</span>   var processor = <span style="color: #0000ff">new</span> PaymentProcessor(</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  13:</span>     cardReaderShouldNotBeUsed, bankServiceShouldNotBeUsed, ui);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  14:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  15:</span>   processor.ProcessPayment(amount).ShouldBeFalse();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  16:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              &nbsp;
            </p>
            
            <p>
              <span style="font-size: medium">Rather than simply passing the value null to the constructor in lines 12-13, I&rsquo;ve used some local variables.&nbsp; This allows the test to clearly show intent.&nbsp; In this case, the test states that PaymentProcessor should never use the bank service or the card reader when the user declines the transaction.&nbsp; And, by using a null, we know that the test will fail if the PaymentProcessor tries to use those dependencies.&nbsp; </span>
            </p>
            
            <p>
              <span style="font-size: medium"></span>
            </p>
            
            <p>
              <span style="font-size: medium">There is another option which is equally intention revealing but somewhat more noisy.&nbsp; We could use a mocking framework to generate the dependencies and then verify at the end of the test that they have never been used:</span>
            </p>
            
            <p>
              &nbsp;
            </p>
            
            <div>
              <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left">
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">   1:</span> [Test]</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> should_not_charge_if_the_user_declines_the_amount()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">   3:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">   4:</span>   <span style="color: #0000ff">double</span> amount = 4.50;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">   5:</span>&nbsp; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">   6:</span>   var cardReader = Stub&lt;IBankInformationReader&gt;();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">   7:</span>   var bankService = Stub&lt;IBankService&gt;();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">   8:</span>   </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">   9:</span>   var ui = Stub&lt;IUserVerification&gt;();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  10:</span>   ui.Stub(x =&gt; x.VerifyAmount(amount)).Return(<span style="color: #0000ff">false</span>);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  11:</span>&nbsp; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  12:</span>   var processor = <span style="color: #0000ff">new</span> PaymentProcessor(</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  13:</span>     cardReader, bankService, ui);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  14:</span>&nbsp; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  15:</span>   processor.ProcessPayment(amount).ShouldBeFalse();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  16:</span>   cardReader.AssertWasNotCalled(x =&gt; x.GetBankInformation());</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  17:</span>   bankService.AssertWasNotCalled(x =&gt; x.RequestFunds(0, <span style="color: #0000ff">null</span>), </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: #f4f4f4;text-align: left"><span style="color: #606060">  18:</span>     o =&gt; o.IgnoreArguments());</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;direction: ltr;line-height: 12pt;font-family: 'Courier New',courier,monospace;background-color: white;text-align: left"><span style="color: #606060">  19:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    <span style="font-size: medium">The problem that I have with this test is all the noise on lines 16-17.&nbsp; I would rather reveal this intention through some well-named variables.</span>
                  </p>