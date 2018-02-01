---
id: 37
title: NBehave + NSpec
date: 2007-09-19T16:22:39+00:00
author: Joey Beninghove
layout: post
guid: /blogs/joeydotnet/archive/2007/09/19/nbehave-nspec.aspx
categories:
  - BDD
  - NBehave
  - nspec
  - Tools
---
So, quickly, I decided to go ahead and throw [NSpec](http://nspec.tigris.org/) into the mix on top of [NBehave](http://www.codeplex.com/NBehave).&nbsp; Why not!&nbsp; 🙂

Here is what the example from my previous post would look like&nbsp;using NSpec:

<div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">[Test, Story]
        <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Load_checkout_information()
        {
            CheckoutOrderDTO checkoutOrderDTO = <span style="color: #0000ff">new</span> CheckoutOrderDTO();
            ShoppingCartDTO shoppingCartDTO = <span style="color: #0000ff">new</span> ShoppingCartDTO();
            IList&lt;LookupDTO&gt; listOfCreditCards = <span style="color: #0000ff">new</span> List&lt;LookupDTO&gt;();

            Story story = <span style="color: #0000ff">new</span> Story(<span style="color: #006080">"Load checkout information"</span>);

            story
                .AsA(<span style="color: #006080">"controller that is responsible for performing the checkout process"</span>)
                .IWant(<span style="color: #006080">"to load the checkout information based on the current user's pending order"</span>)
                .SoThat(<span style="color: #006080">"I can edit the customer's information before submitting the order"</span>);

            story
                .WithScenario(<span style="color: #006080">"Order is ready to be checked out"</span>)

                    .Given(<span style="color: #006080">"controller is prepared"</span>, <span style="color: #0000ff">delegate</span> { PrepareController(controller, <span style="color: #006080">"checkout"</span>, <span style="color: #006080">"index"</span>); })
                        .And(<span style="color: #006080">"pending order is retrieved from checkout service"</span>,
                            <span style="color: #0000ff">delegate</span> { Expect.Call(mockCheckoutService.GetOrderForCheckout()).Return(checkoutOrderDTO); })
                        .And(<span style="color: #006080">"shopping cart is retrieved from shopping cart service"</span>,
                            <span style="color: #0000ff">delegate</span> { Expect.Call(mockBasketService.GetShoppingCart()).Return(shoppingCartDTO); })
                        .And(<span style="color: #006080">"list of acceptable credit card types are retrieved from credit card lookup service"</span>,
                            <span style="color: #0000ff">delegate</span> { Expect.Call(mockCreditCardLookupService.GetAllCreditCardTypes()).Return(listOfCreditCards); })
                        .And(<span style="color: #006080">"mock object framework has stopped recording"</span>, <span style="color: #0000ff">delegate</span> { mockery.ReplayAll(); })

                    .When(<span style="color: #006080">"the index action is executed"</span>, <span style="color: #0000ff">delegate</span> { controller.Index(); })

                    .Then(<span style="color: #006080">"the pending order should exist in the property bag with key of"</span>, PB.CheckoutOrder,
                            <span style="color: #0000ff">delegate</span>(<span style="color: #0000ff">string</span> key) { Specify.That(controller.PropertyBag[key]).ShouldEqual(checkoutOrderDTO); })
                        .And(<span style="color: #006080">"the shopping cart should exist in the property bag with key of"</span>, PB.ShoppingCart,
                            <span style="color: #0000ff">delegate</span>(<span style="color: #0000ff">string</span> key) { Specify.That(controller.PropertyBag[key]).ShouldEqual(shoppingCartDTO); })
                        .And(<span style="color: #006080">"the list of accepted credit card types should exist in the property bag with key of"</span>, PB.AllCreditCardTypes,
                            <span style="color: #0000ff">delegate</span>(<span style="color: #0000ff">string</span> key) { Specify.That(controller.PropertyBag[key]).ShouldEqual(listOfCreditCards); });
        }</pre>
</div>

&nbsp;

Of course I know that the use of NSpec here&nbsp;is basically just syntactic sugar over the Assert statement, but it definitely reads better.