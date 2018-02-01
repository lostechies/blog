---
id: 241
title: Encapsulation and thinking behaviorally
date: 2008-10-21T11:58:42+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/10/21/encapsulation-and-thinking-behaviorally.aspx
dsq_thread_id:
  - "264715968"
categories:
  - BDD
  - BehaviorDrivenDevelopment
---
I’ve been reading quite a bit lately about [setters and encapsulation](http://codebetter.com/blogs/david_laribee/archive/2008/07/08/super-models-part-2-avoid-mutators.aspx), but for whatever reason, it never really “clicked” for me.&#160; I _thought_ I was developing behaviorally, as I’ve been using the Context/Specification style of BDD specifications for a while.&#160; I even go outside-in, starting from the outermost layer of the application, writing specs towards the inner parts of the application.&#160; The outer clients dictate the inner behavior.

Aaron summed it up as well, as [BDD specs should consider the audience](http://codebetter.com/blogs/aaron.jensen/archive/2008/10/19/bdd-consider-your-audience.aspx) of who is reading the specs.&#160; Looking back at specs I have written over the past year, far too many focus on the technical motivations behind the behavior, rather than the business/domain motivations.&#160; Ubiquitous language belongs not only in the Entity and Service names, but in the names of the tasks/operations in the model.&#160; But if all I’m doing is setting a bunch of properties on my model, in many cases I’ve completely lost the business motivation on _why_ those properties should be set the way they are.

In one domain I’ve worked on, quotes always need to be created before an order can be placed.&#160; Once an order is created, the original quote needs to be updated.&#160; Here’s one spec we had to verify this behavior:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">When_executing_the_quote_completion_step </span>: <span style="color: #2b91af">SpecBase
</span>{
    <span style="color: blue">private </span><span style="color: #2b91af">Quote </span>_quote;
    <span style="color: blue">private </span><span style="color: #2b91af">Order </span>_order;

    <span style="color: blue">protected override void </span>Before_each_spec()
    {
        <span style="color: blue">var </span>quoteCompletionStep = <span style="color: blue">new </span><span style="color: #2b91af">QuoteCompletionStep</span>();
        
        _quote = <span style="color: blue">new </span><span style="color: #2b91af">Quote </span>{Status = <span style="color: #2b91af">QuoteStatus</span>.InProgress};
        _order = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>();

        quoteCompletionStep.Execute(_quote, _order);
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Should_set_the_status_to_completed()
    {
        _quote.Status.ShouldEqual(<span style="color: #2b91af">QuoteStatus</span>.Completed);
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Should_set_the_order_property()
    {
        _quote.Order.ShouldNotBeNull();
        _quote.Order.ShouldEqual(_order);
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Should_set_the_order_date()
    {
        _quote.DateOrderPlaced.ShouldBeLessThan(<span style="color: #2b91af">DateTime</span>.Now);
    }
}</pre>

[](http://11011.net/software/vspaste)

We have a quote completion step as part of a larger order submission pipeline.&#160; Unfortunately, nothing in the context description nor the behavior descriptions provide any clue to what the business motivation behind “completing a quote” might be.&#160; Or what “completing” a quote means other than setting a bunch of properties.&#160; Because our specifications focused on the technical implementation, it’s no surprise that the implementation is just a bunch of property setters:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">QuoteCompletionStep
</span>{
    <span style="color: blue">public void </span>Execute(<span style="color: #2b91af">Quote </span>quote, <span style="color: #2b91af">Order </span>order)
    {
        quote.Status = <span style="color: #2b91af">QuoteStatus</span>.Completed;
        quote.DateOrderPlaced = <span style="color: #2b91af">DateTime</span>.Now;
        quote.Order = order;
    }
}</pre>

[](http://11011.net/software/vspaste)

There are a few problems with the lack of state encapsulation here.&#160; We’ve set properties on the Quote, but **we’ve lost all context on why those values changed, or when they should change**.&#160; At Udi Dahan’s class this week, one of the concepts we focused on were the business tasks, operations and events.&#160; Customer added, product deleted, contract expired.&#160; Looking at our domain model, we’ve encapsulated the _implementation_ of state, but **not the reasons why that state should change**.&#160; We’re treating our Entities as components, which aren’t too interesting.

Suppose instead, we wrote our specs with the business behavior in mind:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">When_completing_a_quote_from_an_order_placed </span>: <span style="color: #2b91af">SpecBase
</span>{
    <span style="color: blue">private </span><span style="color: #2b91af">Quote </span>_quote;
    <span style="color: blue">private </span><span style="color: #2b91af">Order </span>_order;

    <span style="color: blue">protected override void </span>Before_each_spec()
    {
        <span style="color: blue">var </span>quoteCompletionStep = <span style="color: blue">new </span><span style="color: #2b91af">QuoteCompletionStep</span>();
        
        _quote = <span style="color: blue">new </span><span style="color: #2b91af">Quote </span>{Status = <span style="color: #2b91af">QuoteStatus</span>.InProgress};
        _order = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>();

        quoteCompletionStep.Execute(_quote, _order);
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Should_mark_the_quote_as_completed()
    {
        _quote.Status.ShouldEqual(<span style="color: #2b91af">QuoteStatus</span>.Completed);
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Should_correlate_the_corresponding_order_with_the_quote()
    {
        _quote.Order.ShouldNotBeNull();
        _quote.Order.ShouldEqual(_order);
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Should_note_the_time_the_order_was_placed()
    {
        _quote.DateOrderPlaced.ShouldBeLessThan(<span style="color: #2b91af">DateTime</span>.Now);
    }
}</pre>

[](http://11011.net/software/vspaste)

Looking at the context and behavioral descriptions now, it wouldn’t be that much different than a person describing the quote and order process _without_ computers.&#160; This description could match the quote completion process of 100 years ago.&#160; Once our specs become more business-centric, we’re shifting our mind away from technical implementations.&#160; This shift can lead to more task or operation-based domain models:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Quote
</span>{
    <span style="color: blue">public </span>Quote()
    {
        Status = <span style="color: #2b91af">QuoteStatus</span>.New;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">QuoteStatus </span>Status { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">Order </span>Order { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">DateTime </span>DateOrderPlaced { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }

    <span style="color: blue">public void </span>CorrelateOrderPlaced(<span style="color: #2b91af">Order </span>order)
    {
        Order = order;
        Status = <span style="color: #2b91af">QuoteStatus</span>.Completed;
        DateOrderPlaced = <span style="color: #2b91af">DateTime</span>.Now;
    }
}</pre>

[](http://11011.net/software/vspaste)

Instead of users of Quote needing to worry about what the valid state of a Completed quote is, the operation or task of correlating an Order placed will ensure that the Quote’s state is valid.&#160; Which is where this type of logic belongs, I believe.&#160; Once we start thinking in a business-oriented, behavioral mindset, we can start seeing the business tasks, operations and events that work on our entities.&#160; As properties encapsulate merely the implementation of state, it’s still up to the client of the entity to figure out what is valid.&#160; DateOrderPlaced should only have a value when a correlated Order is submitted.&#160; With our new implementation of our domain model and specification descriptions, this motivation is captured explicitly.