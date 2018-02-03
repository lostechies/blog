---
wordpress_id: 36
title: 'NBehave Experiment: MonoRail Controllers &#038; Rhino Mocks'
date: 2007-09-19T15:17:11+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/09/19/nbehave-experiment-monorail-controllers-amp-rhino-mocks.aspx
categories:
  - BDD
  - MonoRail
  - NBehave
  - Patterns
  - TDD
  - Tools
---
> _&#8230;whoever keeps His word, truly the love of God is perfected in him. By this we know that we are in Him. &#8212; [1 John 2:5](http://www.blueletterbible.org/cgi-bin/tools/printer-friendly.pl?book=1Jo&chapter=002&version=nkjv#5)_

Well I decided it was finally time I took a look at NBehave as another one of those tools to have in my toolbox.&nbsp; NBehave&#8217;s primary use seems to be in the domain model for implementing stories from the user&#8217;s perspective, which obviously sounds very powerful.&nbsp; 

But I specifically wanted to see how NBehave would &#8220;behave&#8221; (sorry&#8230;) for driving out my MonoRail controllers along with mock objects for mocking out the back-end services as I do now.&nbsp; In other words, making the controller itself, the &#8220;person&#8221; interacting with the system using controller-specific terminology.

So I thought I would take one of my existing controller tests and convert it to a NBehave-type story/scenario.&nbsp; Here is my original old-school test:

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   1:</span> [Test]</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_load_pending_order_and_shopping_cart_and_list_of_acceptable_credit_card_types()</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   3:</span> {</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   4:</span>     CheckoutOrderDTO checkoutOrderDTO = <span style="color: #0000ff">new</span> CheckoutOrderDTO();</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   5:</span>     ShoppingCartDTO shoppingCartDTO = <span style="color: #0000ff">new</span> ShoppingCartDTO();</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   6:</span>     IList&lt;LookupDTO&gt; listOfCreditCards = <span style="color: #0000ff">new</span> List&lt;LookupDTO&gt;();</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   7:</span> &nbsp;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   8:</span>     <span style="color: #0000ff">using</span> (mockery.Record())</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   9:</span>     {</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  10:</span>         PrepareController(controller, <span style="color: #006080">"checkout"</span>, <span style="color: #006080">"index"</span>);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  11:</span>         Expect.Call(mockCheckoutService.GetOrderForCheckout()).Return(checkoutOrderDTO);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  12:</span>         Expect.Call(mockBasketService.GetShoppingCart()).Return(shoppingCartDTO);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  13:</span>         Expect.Call(mockCreditCardLookupService.GetAllCreditCardTypes()).Return(listOfCreditCards);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  14:</span>     }</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  15:</span> &nbsp;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  16:</span>     <span style="color: #0000ff">using</span> (mockery.Playback())</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  17:</span>     {</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  18:</span>         controller.Index();</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  19:</span>         Assert.AreEqual(checkoutOrderDTO, controller.PropertyBag[PB.CheckoutOrder]);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  20:</span>         Assert.AreEqual(shoppingCartDTO, controller.PropertyBag[PB.ShoppingCart]);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  21:</span>         Assert.AreEqual(listOfCreditCards, controller.PropertyBag[PB.AllCreditCardTypes]);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  22:</span>     }</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  23:</span> }</pre>
  </div>
</div>

&nbsp;

Since I tend to be very verbose in my test naming, sometimes they can become unwieldy.&nbsp; Of course every time my test names get too long, I start questioning whether the unit of code I&#8217;m testing is trying to do too much, thus&nbsp;violating SRP.&nbsp; But in this case, I&#8217;m simply loading up 3 pieces of data from various services.&nbsp; (Yes, I realize the service communication here is becoming a bit chatty, and a refactoring task is definitely on the radar, but that&#8217;s not really the focus for this post).&nbsp; 🙂

Anyway, I wanted to see what this test would look like as a NBehave story.&nbsp; Here goes&#8230;

(sorry for the code wrappage)

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   1:</span> [Test, Story]</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Load_checkout_information()</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   3:</span> {</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   4:</span>     CheckoutOrderDTO checkoutOrderDTO = <span style="color: #0000ff">new</span> CheckoutOrderDTO();</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   5:</span>     ShoppingCartDTO shoppingCartDTO = <span style="color: #0000ff">new</span> ShoppingCartDTO();</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   6:</span>     IList&lt;LookupDTO&gt; listOfCreditCards = <span style="color: #0000ff">new</span> List&lt;LookupDTO&gt;();</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   7:</span> &nbsp;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">   8:</span>     Story story = <span style="color: #0000ff">new</span> Story(<span style="color: #006080">"Load checkout information"</span>);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">   9:</span> &nbsp;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  10:</span>     story</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  11:</span>         .AsA(<span style="color: #006080">"controller that is responsible for performing the checkout process"</span>)</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  12:</span>         .IWant(<span style="color: #006080">"to load the checkout information based on the current user's pending order"</span>)</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  13:</span>         .SoThat(<span style="color: #006080">"I can edit the customer's information before submitting the order"</span>);</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  14:</span> &nbsp;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  15:</span>     story</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  16:</span>         .WithScenario(<span style="color: #006080">"Order is ready to be checked out"</span>)</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  17:</span> &nbsp;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  18:</span>             .Given(<span style="color: #006080">"controller is prepared"</span>, <span style="color: #0000ff">delegate</span> { PrepareController(controller, <span style="color: #006080">"checkout"</span>, <span style="color: #006080">"index"</span>); })</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  19:</span>                 .And(<span style="color: #006080">"pending order is retrieved from checkout service"</span>,</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  20:</span>                     <span style="color: #0000ff">delegate</span> { Expect.Call(mockCheckoutService.GetOrderForCheckout()).Return(checkoutOrderDTO); })</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  21:</span>                 .And(<span style="color: #006080">"shopping cart is retrieved from shopping cart service"</span>,</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  22:</span>                     <span style="color: #0000ff">delegate</span> { Expect.Call(mockBasketService.GetShoppingCart()).Return(shoppingCartDTO); })</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  23:</span>                 .And(<span style="color: #006080">"list of acceptable credit card types are retrieved from credit card lookup service"</span>,</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  24:</span>                     <span style="color: #0000ff">delegate</span> { Expect.Call(mockCreditCardLookupService.GetAllCreditCardTypes()).Return(listOfCreditCards); mockery.ReplayAll(); })</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  25:</span> &nbsp;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  26:</span>             .When(<span style="color: #006080">"the index action is executed"</span>, <span style="color: #0000ff">delegate</span> { controller.Index(); })</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  27:</span> &nbsp;</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  28:</span>             .Then(<span style="color: #006080">"the pending order should exist in the property bag with key of"</span>, PB.CheckoutOrder,</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  29:</span>                     <span style="color: #0000ff">delegate</span>(<span style="color: #0000ff">string</span> key) { Assert.AreEqual(checkoutOrderDTO, controller.PropertyBag[key]); })</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  30:</span>                 .And(<span style="color: #006080">"the shopping cart should exist in the property bag with key of"</span>, PB.ShoppingCart,</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  31:</span>                     <span style="color: #0000ff">delegate</span>(<span style="color: #0000ff">string</span> key) { Assert.AreEqual(shoppingCartDTO, controller.PropertyBag[key]); })</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  32:</span>                 .And(<span style="color: #006080">"the list of accepted credit card types should exist in the property bag with key of"</span>, PB.AllCreditCardTypes,</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060">  33:</span>                     <span style="color: #0000ff">delegate</span>(<span style="color: #0000ff">string</span> key) { Assert.AreEqual(listOfCreditCards, controller.PropertyBag[key]); });</pre>
    
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #606060">  34:</span> }</pre>
  </div>
</div>

&nbsp;

But the real beauty is the generated output:

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
    <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #606060"> 

Theme: Checkout Process

    Story: Load checkout information
    
    Narrative:
        As a controller that is responsible for performing the checkout process
        I want to load the checkout information based on the current user's pending order
        So that I can edit the customer's information before submitting the order
    
        Scenario 1: Order is ready to be checked out
            Given controller is prepared
                And pending order is retrieved from checkout service
                And shopping cart is retrieved from shopping cart service
                And list of acceptable credit card types are retrieved from credit card lookup service
            When the index action is executed
            Then the pending order should exist in the property bag with key of: order
                And the shopping cart should exist in the property bag with key of: shoppingCart
                And the list of accepted credit card types should exist in the property bag with key of: allCreditCardTypes

</pre>
</div>
</div>


<p>
  <font color="#000000"></font>&nbsp;
</p>


<p>
  <font color="#000000">As the title of this post&nbsp;states, this is merely an experiment at this point.&nbsp; But I do think it better expresses exactly what the controller is doing vs the non-NBehave test above.&nbsp; </font>
</p>


<p>
  <font color="#000000">One extension I would like to add to the NBehave framework is some built-in support for mock object frameworks.&nbsp; I don&#8217;t necessarily think a specific mock object framework should be integrated into NBehave, but for my own purposes, I&#8217;m thinking about adding support for the <strong>Given</strong> scope to implicitly signal to Rhino Mocks to stop recording.&nbsp; As you can see, for now I had to include it in my last <strong>Given</strong> block like this:</font>
</p>


<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">.And(<span style="color: #006080">"list of acceptable credit card types are retrieved from credit card lookup service"</span>,
                            <span style="color: #0000ff">delegate</span> { Expect.Call(mockCreditCardLookupService.GetAllCreditCardTypes()).Return(listOfCreditCards); mockery.ReplayAll(); })</pre>
  
</div>


<p>
  <font color="#000000"></font>&nbsp;
</p>


<p>
  <font color="#000000">I suppose I could do something silly like this:</font>
</p>


<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">.And(<span style="color: #006080">"mock object framework has stopped recording"</span>, <span style="color: #0000ff">delegate</span> { mockery.ReplayAll(); })</pre>
  
</div>


<p>
  &nbsp;
</p>


<p>
  <font color="#000000">But that would litter the nicely generated output with &#8220;test&#8221; specific terminology which I&#8217;m not very cool with.&nbsp; This extension could probably be achieved using a simple decorator/interceptor, but won&#8217;t know for sure until I peek at the source.&nbsp; 🙂</font>
</p>


<p>
  <font color="#000000"><strong>What do you think?&nbsp; Is this over-complicating things? Or could it be&nbsp;an elegant way for expressing what is actually going on in the controllers?</strong></font>
</p>