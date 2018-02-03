---
wordpress_id: 396
title: 'Strengthening your domain: Avoiding setters'
date: 2010-03-31T13:52:17+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/03/31/strengthening-your-domain-avoiding-setters.aspx
dsq_thread_id:
  - "264789208"
categories:
  - DomainDrivenDesign
---
Previous posts in this series:

  * [A primer](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/02/03/strengthening-your-domain-a-primer.aspx)
  * [Aggregate Construction](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/02/23/strengthening-your-domain-aggregate-construction.aspx)
  * [Encapsulated Collections](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/03/10/strengthening-your-domain-encapsulated-collections.aspx)
  * [Encapsulated Operations](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/03/24/strengthening-your-domain-encapsulating-operations.aspx)
  * [Double Dispatch Pattern](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/03/30/strengthening-your-domain-the-double-dispatch-pattern.aspx)

As we start to move our domain model from an anemic existence towards one with richer behavior, we start to see the aggregate root boundary become very well defined.&#160; **Instead of throwing a bunch of data at an entity, we start interacting with it**, issuing commands through closed, well-defined operations.&#160; The surface of our domain model becomes shaped by the actual operations available in our application, instead of exposing a dumb data object that lets anyone do anything, and consistency and validity are a pipe dream.

With more and more of a behavioral model in place, something begins to look out of place.  **We locked down behavioral entry points into our domain model, yet left open back doors that would render all of our effort completely moot**.&#160; We forgot to address that last vestige of domain anemia in our model: **property setters**.

### Encapsulation Violated (Again)

In our Fee, Customer and Payment example, we ended with an operation on Fee that allowed us to record a payment.&#160; Part of the operation of recording a payment is to update the Fee’s balance.&#160; In the last post, we added the double dispatch pattern, creating a separate BalanceCalculator to contain the responsibility of calculating a Fee’s balance:

<pre><span style="color: blue">public </span><span style="color: #2b91af">Payment </span>RecordPayment(<span style="color: blue">decimal </span>paymentAmount, <span style="color: #2b91af">IBalanceCalculator </span>balanceCalculator)
{
    <span style="color: blue">var </span>payment = <span style="color: blue">new </span><span style="color: #2b91af">Payment</span>(paymentAmount, <span style="color: blue">this</span>);

    _payments.Add(payment);

    Balance = balanceCalculator.Calculate(<span style="color: blue">this</span>);

    <span style="color: blue">return </span>payment;
}</pre>

[](http://11011.net/software/vspaste)

As an aside, I think some were thrown off in the last post that I pass in an interface, rather than a concrete class, making this a bit of a Strategy pattern.&#160; I don’t like getting bogged down in names, but the whole “double dispatch” piece comes into play here because the Fee’s RecordPayment method passes itself into the BalanceCalculator.&#160; The implementation then inspects the Fee object (and whatever else it needs) to perform the calculation.

If we zoom out a bit on our Fee object, we can see that we’ve encapsulated the Payments collection:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Fee
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">Customer </span>_customer;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IList</span>&lt;<span style="color: #2b91af">Payment</span>&gt; _payments = <span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Payment</span>&gt;();

    <span style="color: blue">public </span>Fee(<span style="color: blue">decimal </span>amount, <span style="color: #2b91af">Customer </span>customer)
    {
        Amount = amount;
        _customer = customer;
    }

    <span style="color: blue">public decimal </span>Amount { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public decimal </span>Balance { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

    <span style="color: blue">public </span><span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">Payment</span>&gt; GetPayments()
    {
        <span style="color: blue">return </span>_payments;
    }</pre>

[](http://11011.net/software/vspaste)

And the BalanceCalculator then uses the Fee object to do its calculation:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">BalanceCalculator </span>: <span style="color: #2b91af">IBalanceCalculator
</span>{
    <span style="color: blue">public decimal </span>Calculate(<span style="color: #2b91af">Fee </span>fee)
    {
        <span style="color: blue">var </span>payments = fee.GetPayments();

        <span style="color: blue">var </span>totalApplied = payments.Sum(payment =&gt; payment.Amount);

        <span style="color: blue">return </span>fee.Amount - totalApplied;
    }
}</pre>

[](http://11011.net/software/vspaste)

So what does the BalanceCalculator need to do its job properly?&#160; From the Fee object, it needs:

  * List of payments
  * Fee amount

And from each Payment object, the Amount.&#160; But because we’ve exposed Amount and Balance with public setters, we can do completely nonsensical, non-supported operations such as this:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_be_able_to_modify_a_fee_and_payment_amount()
{
    <span style="color: blue">var </span>customer = <span style="color: blue">new </span><span style="color: #2b91af">Customer</span>();

    <span style="color: blue">var </span>fee = customer.ChargeFee(100m);

    <span style="color: blue">var </span>payment = fee.RecordPayment(25m, <span style="color: blue">new </span><span style="color: #2b91af">BalanceCalculator</span>());

    fee.Amount = 50m;
    payment.Amount = 10m;

    fee.Balance.ShouldEqual(40m); <span style="color: green">// Do we even support this?!?
</span>}</pre>

[](http://11011.net/software/vspaste)

I have these nice operations in ChargeFee and RecordPayment, yet I can just go in and straight up modify the Amount of the Fee and Payment.&#160; The Balance is no longer correct at this point, because I’ve exposed a back door around my aggregate root boundary.&#160; **We have again violated the encapsulation of our domain model by exposing the ability to modify state directly**, instead of allowing modifications through commands.&#160; But this is an easy fix for us!

### Ditching the mutators

**The simplest fix here is to hide the setters** for Balance and Amount on our Fee and Payment objects:

<pre><span style="color: blue">public </span>Fee(<span style="color: blue">decimal </span>amount, <span style="color: #2b91af">Customer </span>customer)
{
    Amount = amount;
    _customer = customer;
}

<span style="color: blue">public decimal </span>Amount { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
<span style="color: blue">public decimal </span>Balance { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }</pre>

[](http://11011.net/software/vspaste)

Our RecordPayment method still compiles just fine, as it has access to this private setter for updating the balance.&#160; Because we only want to allow modification of Balance through the Fee maintaining its own consistency, there’s no reason to expose Balance’s setter publicly.&#160; The only place we’ll run into potential issues is in our persistence tests, and only then if we decide that we want to start with the database first when building features.&#160; We’ll also modify the Payment object accordingly:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Payment
</span>{
    <span style="color: blue">public </span>Payment(<span style="color: blue">decimal </span>amount, <span style="color: #2b91af">Fee </span>fee)
    {
        Amount = amount;
        Fee = fee;
    }

    <span style="color: blue">public decimal </span>Amount { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">Fee </span>Fee { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

Payment had an even _bigger_ issue earlier – it exposed the Fee property setter.&#160; That would lead to extremely bizarre behavior, where I could switch the Payment’s associated Fee at any time.&#160; Not exactly desirable behavior, nor behavior we ever, ever want to think about if it’s not a supported operation.

If our application does not contain a single screen where we can _change_ a Fee’s or Payment’s Amount, then why do we allow this ability in our domain model?&#160; We shouldn’t.&#160; **We should only expose the operations, data and behavior supported by our application, and nothing more**.

Suppose there is a screen that allows modification of a Payment’s Amount.&#160; In that case, we’ll want to design an encapsulated operation on Fee (most likely) that allows us to keep the Balance correct and our aggregate root boundary intact.

### Finding the balance

In many applications I work with, **operations can be generally divided into two categories: data operations and behavioral operations**.&#160; For data operations, where Fee has a Comments property, there’s no inherent need to encapsulate changing the Comments behind a method, simply because there’s no behavior there.&#160; Anyone can change the Fee’s comments at any time, and it won’t affect the consistency of the Fee aggregate root.&#160; For data operations, I personally leave the setters in place.&#160; The trick is to find what operations are behavioral in nature, and what operations are data-centric in nature.

If we start from the UI/interaction perspective, we’ll find that the design of our model pretty much imitates the design of the UI.  **If we have a data-centric interaction, we’ll have a data-centric model**.&#160; If we have a task-based, behavioral interaction, the domain model will follow.&#160; What I’ve found is that not many applications are entirely in one camp or the other, and often have pockets and areas where it falls more into one camp or the other.&#160; If you get rid of ALL your setters, but have data-centric screens, you’ll run into friction.&#160; And if you have behavioral screens but an anemic, data-centric model, you’ll also run into friction.

In any case, the clues to where the design lies often come from conversations with the domain experts.&#160; While our domain experts might talk about charging fees and recording payments, they’ll also talk about editing comments.&#160; Behavioral in the former, data-centric in the latter.

### Wrapping it up

Aggregate root boundaries are fun to talk about in theory, but many domain models you might look at only have boundaries in name only.&#160; **If a domain model exposes operations and commands only to also expose bypassing these operations by going straight to property setters, then there really isn’t a boundary at all**.&#160; Through crafting intention-revealing interfaces that allow only the operations and behavior we support through interaction of our application, we can avoid wonky half-baked scenarios and confusion later.&#160; This confusion arises where our domain models expose one set of behaviors that our UI needs, and another set of behaviors that are not supported, nonsensical and lead to an invalid state in our model.

The justification for leaving public setters in place is often expressed in terms of “easier testing”.&#160; From experience, **invalid domain objects are more confusing and harder to test**, simply because you can’t know that you’ve set up a context that is actually valid when using your application.

We can avoid this confusion and likely extra defensive coding by **removing public setters for data that should only be changed through operations and commands executed on our domain model**.&#160; Once again, this is what encapsulation is all about.&#160; Our model only exposes what is supported, and disallows what is not.