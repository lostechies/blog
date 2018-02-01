---
id: 395
title: 'Strengthening your domain: The double dispatch pattern'
date: 2010-03-30T12:37:58+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2010/03/30/strengthening-your-domain-the-double-dispatch-pattern.aspx
dsq_thread_id:
  - "264716430"
categories:
  - DomainDrivenDesign
---
Previous posts in this series:

  * [A primer](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/02/03/strengthening-your-domain-a-primer.aspx)
  * [Aggregate Construction](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/02/23/strengthening-your-domain-aggregate-construction.aspx)
  * [Encapsulated Collections](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/03/10/strengthening-your-domain-encapsulated-collections.aspx)
  * [Encapsulated Operations](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/03/24/strengthening-your-domain-encapsulating-operations.aspx)

It looks like there’s a pattern emerging here around encapsulation, and **that’s not an accident**.&#160; Many of the code smells in the Fowler or Kerievsky refactoring books deal with proper encapsulation of both data _and_ behavior.&#160; In the previous post, we looked at closure of operations, that when an operation is completed, the aggregate root’s state is consistent.

In many anemic domain models, **the behavior is there but in the wrong place**.&#160; For the DDD-literate, this is usually in a lot of domain services all poking at the state of the domain model.&#160; We can refactor these services to enforce consistency through closed operations on our model, but there are cases where this sort of domain behavior _doesn’t_ belong in the model.

This now begins to be difficult to reconcile.&#160; We want to have a consistent model, but now we want to bring in services to the mix.&#160; Do we now forgo the concept of Command/Query Separation in our model, and just expose state?&#160; Or can we have our cake and eat it too?

### 

### Bringing in services

The last example looked at fees, payments and customers.&#160; When a payment is recorded against a fee, we re-calculate the balance:

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

The problem comes in when calculating the balance becomes more difficult.&#160; We might have a rather complex method for calculating payments, we might have recurring payments, transfers, debits, credits and so on.&#160; This might become too much responsibility for the Fee object.&#160; In fact, it could be argues that the Fee shouldn’t be responsible for _how_ the balance is calculated, but instead only ensure that when a payment is recorded, the balance is updated.

We have several options here:

  * Update the Balance outside the RecordPayment method, with the caller “remembering”
  * Use a BalanceCalculator service as part of the RecordPayment method

**I never like a solution that requires a user of the domain to “remember” to call a method after another one**.&#160; It’s not intention-revealing, and tends to leave the domain model in a wacky in-between state.&#160; For many domains, this might be acceptable.&#160; But with more complexity comes the issue of trying to sort out what scenarios are valid or not.&#160; When a test breaks because an invariant is not satisfied, that’s a clear message that something broke the domain.

But if we leave our domain in half-baked states, it becomes much more difficult to decipher what to do when we change the behavior of our model and tests start to break.&#160; Are the existing scenarios supported, or are they just around?&#160; In the case of the latter, that’s where you start to see more defensive coding practices, throwing exceptions, gut-check asserts and so on.

So we decide to go with the Aggregate Root relying on a Domain Service for balance calculation.&#160; Now we have to decide _where_ the service comes from.

For those using a DI container, you might try to inject the dependencies into the aggregate root.&#160; That leads to a whole host of problems, which are so numerous I won’t derail a perfectly good post by getting into it.&#160; Instead, there’s another, more intention-revealing option: the double dispatch pattern.

### Services and the double dispatch pattern

The double dispatch pattern is quite simple.&#160; It involves passing an object to a method, and the method body calls another method on the passed in object, usually passing in itself as an argument.&#160; In our case, we’ll first create an interface that represents our balance calculator domain service:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IBalanceCalculator
</span>{
    <span style="color: blue">decimal </span>Calculate(<span style="color: #2b91af">Fee </span>fee);
}</pre>

[](http://11011.net/software/vspaste)

The signature of the method is important.&#160; It accepts a Fee object, but returns the total directly.&#160; It doesn’t try to modify the Fee, allowing for a side-effect free function.&#160; I can call the calculator as many times as I like with a given Fee, and **I can be assured that the Fee object won’t be changed**.&#160; From the Fee side, I now need to use this service as part of recording a payment:

<pre><span style="color: blue">public </span><span style="color: #2b91af">Payment </span>RecordPayment(<span style="color: blue">decimal </span>paymentAmount, <span style="color: #2b91af">IBalanceCalculator </span>balanceCalculator)
{
    <span style="color: blue">var </span>payment = <span style="color: blue">new </span><span style="color: #2b91af">Payment</span>(paymentAmount, <span style="color: blue">this</span>);

    _payments.Add(payment);

    Balance = balanceCalculator.Calculate(<span style="color: blue">this</span>);

    <span style="color: blue">return </span>payment;
}</pre>

[](http://11011.net/software/vspaste)

The intent of the RecordPayment method remains the same: it records a payment, and updates the balance.&#160; The balance on the Fee object will always be correct.&#160; The wrinkle we added is that our RecordPayment method now delegates to a domain service, the IBalanceCalculator, for calculation of the balance.&#160; However, **the Fee object is still responsible for maintaining a correct balance**.&#160; We just call the Calculate method on the balance calculator, passing in “this”, to figure out what the actual correct balance can be.

### Wrapping it up

When a domain object begins to contain _too many_ responsibilities, we start to break out those extra responsibilities into things like value objects and domain services.&#160; This does not mean we have to give up consistency and closure of operations, however.&#160; **With the use of the double dispatch pattern, we can avoid anemic domain models**, as well as the forlorn attempt to inject services into our domain model.&#160; Our methods stay very intention-revealing, showing exactly what is needed to fulfill a request of recording a payment.