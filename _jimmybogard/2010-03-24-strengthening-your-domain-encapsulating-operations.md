---
wordpress_id: 394
title: 'Strengthening your domain: Encapsulating operations'
date: 2010-03-24T14:50:24+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/03/24/strengthening-your-domain-encapsulating-operations.aspx
dsq_thread_id:
  - "264716466"
categories:
  - DomainDrivenDesign
redirect_from: "/blogs/jimmy_bogard/archive/2010/03/24/strengthening-your-domain-encapsulating-operations.aspx/"
---
Other posts in this series:

  * [A primer](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/02/03/strengthening-your-domain-a-primer.aspx)
  * [Aggregate Construction](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/02/23/strengthening-your-domain-aggregate-construction.aspx)
  * [Encapsulated Collections](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/03/10/strengthening-your-domain-encapsulated-collections.aspx)

In previous posts, we walked through the journey from an intentionally anemic domain model (one specifically designed with CRUD in mind), towards a design of a stronger domain model design.&#160; Many of the comments on twitter and in the posts noted that many of the design techniques are just plain good OO design.&#160; Yes!&#160; That’s the idea.&#160; If we have behavior in our system, it might not be in the right place.&#160; The DDD domain design techniques are in place to help move that behavior from services surrounding the domain back into the domain model where it belongs.

Besides managing the creation of aggregates and relationships inside and between aggregate roots, there comes the point where we need to actually…update information in our domain model.&#160; One of the tipping points from moving from a CRUD model to a DDD model is emergent complexity in updating information in our model.

### Fees and Payments

Let’s suppose that in our domain we can levy Fees against Customers.&#160; Later, Customers can make Payments on those Fees.&#160; At any time, I can look up a Fee and determine the Fee’s balance.&#160; Or, I can look up all the Customer’s Fees, and see a list of all the Fee’s balances.&#160; Based on the previous posts, I might end up with something like this:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_apply_the_fee_to_the_customer_when_charging_a_customer_a_fee()
{
    <span style="color: blue">var </span>customer = <span style="color: blue">new </span><span style="color: #2b91af">Customer</span>();
    
    <span style="color: blue">var </span>fee = customer.ChargeFee(100m);

    fee.Amount.ShouldEqual(100m);

    customer.Fees.ShouldContain(fee);
}</pre>

[](http://11011.net/software/vspaste)

The ChargeFee method is rather straightforward:

<pre><span style="color: blue">public </span><span style="color: #2b91af">Fee </span>ChargeFee(<span style="color: blue">decimal </span>amount)
{
    <span style="color: blue">var </span>fee = <span style="color: blue">new </span><span style="color: #2b91af">Fee</span>(amount, <span style="color: blue">this</span>);

    _fees.Add(fee);

    <span style="color: blue">return </span>fee;
}</pre>

[](http://11011.net/software/vspaste)

Next, we want to be able to apply a payment to a fee:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_be_able_to_record_a_payment_against_a_fee()
{
    <span style="color: blue">var </span>customer = <span style="color: blue">new </span><span style="color: #2b91af">Customer</span>();

    <span style="color: blue">var </span>fee = customer.ChargeFee(100m);

    <span style="color: blue">var </span>payment = fee.AddPayment(25m);
    fee.RecalculateBalance();

    payment.Amount.ShouldEqual(25m);

    fee.Balance.ShouldEqual(75m);
}</pre>

[](http://11011.net/software/vspaste)

We store a calculated balance, as this gives us much better performance, querying abilities and so on.&#160; It’s rather easy to make this test pass:

<pre><span style="color: blue">public </span><span style="color: #2b91af">Payment </span>AddPayment(<span style="color: blue">decimal </span>paymentAmount)
{
    <span style="color: blue">var </span>payment = <span style="color: blue">new </span><span style="color: #2b91af">Payment</span>(paymentAmount, <span style="color: blue">this</span>);

    _payments.Add(payment);

    <span style="color: blue">return </span>payment;
}

<span style="color: blue">public void </span>RecalculateBalance()
{
    <span style="color: blue">var </span>totalApplied = _payments.Sum(payment =&gt; payment.Amount);
    
    Balance = Amount - totalApplied;
}</pre>

[](http://11011.net/software/vspaste)

However, our test looks rather strange at this point.&#160; We have a method to establish the relationship between Fee and Payment (the AddPayment method), which acts as a simple facade over the internal list.&#160; But what’s with that extra “RecalculateBalance” method?&#160; In many codebases, that RecalculateBalance method would be in a BalanceCalculationService, reinforcing an anemic domain.

But we can do one better.&#160; Isn’t the act of recording a payment a complete operation?  **In the real physical world, when I give a person money, the entire transaction is completed as a whole**.&#160; Either it all completes successfully, or the transaction is invalid.&#160; In our example, how can I add a payment and the balance _not_ be immediately updated?&#160; It’s rather confusing to have to “remember” to use these extra calculation services and helper methods, just because our domain objects are too dumb to handle it themselves.

### Thinking with commands

When we called the AddPayment method, we left our Fee aggregate root in an in-between state.&#160; It had a Payment, yet its balance was incorrect.&#160; If Fees are supposed to act as consistency boundaries, we’ve violated that consistency with this invalid state.&#160; Looking strictly through a code smell standpoint, this is the [Inappropriate Intimacy](http://c2.com/cgi/wiki?InappropriateIntimacy) code smell.&#160; **Inappropriate Intimacy is one of the biggest indicators of an anemic domain model**.&#160; The behavior is there, but just in the wrong place.

But we can help ourselves to enforce those aggregate boundaries with **encapsulation**.&#160; Not just encapsulation like properties encapsulate fields, but **encapsulating the operation** of recording a fee.&#160; Even the name of “AddPayment” could be improved, to “RecordPayment”.&#160; The act of recording a payment in the Real World involves adding the payment to the ledger and updating the balance book.&#160; If the accountant solely adds the payment to the ledger, but does not update the balance book, they haven’t yet finished recording the payment.&#160; Why don’t we do the same?&#160; Here’s our modified test:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_be_able_to_record_a_payment_against_a_fee()
{
    <span style="color: blue">var </span>customer = <span style="color: blue">new </span><span style="color: #2b91af">Customer</span>();

    <span style="color: blue">var </span>fee = customer.ChargeFee(100m);

    <span style="color: blue">var </span>payment = fee.RecordPayment(25m);

    payment.Amount.ShouldEqual(25m);

    fee.Balance.ShouldEqual(75m);
}</pre>

[](http://11011.net/software/vspaste)

We got rid of that pesky, strange extra “Recalculate” call, and now encapsulated the entire command of “Record this payment” to our aggregate root, the Fee object.&#160; The RecordPayment method now encapsulates the complete operation of recording a payment, ensuring that the Fee root is self-consistent at the completion of the operation:

<pre><span style="color: blue">public </span><span style="color: #2b91af">Payment </span>RecordPayment(<span style="color: blue">decimal </span>paymentAmount)
{
    <span style="color: blue">var </span>payment = <span style="color: blue">new </span><span style="color: #2b91af">Payment</span>(paymentAmount, <span style="color: blue">this</span>);

    _payments.Add(payment);

    RecalculateBalance();

    <span style="color: blue">return </span>payment;
}

<span style="color: blue">private void </span>RecalculateBalance()
{
    <span style="color: blue">var </span>totalApplied = _payments.Sum(payment =&gt; payment.Amount);
    
    Balance = Amount - totalApplied;
}</pre>

[](http://11011.net/software/vspaste)

Notice that we’ve also made the Recalculate method private, as this is an implementation detail of how the Fee object keeps the balance consistent.&#160; From someone using the Fee object, we don’t care **how** the Fee object keeps itself consistent, we only want to care that it is consistent.

The public contour of the Fee object is simplified as well.&#160; We only expose operations that we want to support, captured in the names of our ubiquitous language.&#160; The “How” is encapsulated behind the aggregate root boundary.

### Wrapping it up

We again see that a consistent theme in DDD is good OO and attention to code smells.&#160; DDD helps us by giving us patterns and direction, towards placing more and more logic inside our domain.&#160; The difference between an intentionally anemic domain model (a [persistence model](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/12/03/persistence-model-and-domain-anemia.aspx)) and an anemic domain model is the presence of these code smells.&#160; If you don’t have a legion of supporting services propping up the state of your domain model, then there’s no problem.

However, it’s these external domain services where we are likely to find the bulk of domain model smells.&#160; Through attention to the code smells and refactorings [Fowler laid out](http://www.amazon.com/exec/obidos/ASIN/0201485672), we can move towards the concepts of self-consistent aggregate roots with strongly-enforced boundaries.