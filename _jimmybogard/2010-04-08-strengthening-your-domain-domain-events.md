---
wordpress_id: 398
title: 'Strengthening your domain: Domain Events'
date: 2010-04-08T18:55:19+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/04/08/strengthening-your-domain-domain-events.aspx
dsq_thread_id:
  - "264716450"
categories:
  - DomainDrivenDesign
---
Previous posts in this series:

  * [A primer](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/02/03/strengthening-your-domain-a-primer.aspx)
  * [Aggregate Construction](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/02/23/strengthening-your-domain-aggregate-construction.aspx)
  * [Encapsulated Collections](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/03/10/strengthening-your-domain-encapsulated-collections.aspx)
  * [Encapsulated Operations](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/03/24/strengthening-your-domain-encapsulating-operations.aspx)
  * [Double Dispatch Pattern](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/03/30/strengthening-your-domain-the-double-dispatch-pattern.aspx)
  * [Avoiding Setters](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/03/31/strengthening-your-domain-avoiding-setters.aspx)

In the last post, we rounded out fully encapsulated domain models by encapsulating certain state information that requires certain restrictions in how that information can change.&#160; In our model of customers, fees and payments, we started recording fee balance on the Fee object.&#160; Once we did this, we started to lock down the public interface of our Fee and Payment objects, so that only operations supported and validated by our domain experts can be executed.&#160; The side benefit of this sort of design is that **our domain model now strongly reinforces the ubiquitous language**.

In an anemic domain model, the ubiquitous language only reflects state information.&#160; In our conversations with the domain experts, we are very likely to hear behavioral information as well.&#160; We can talk about our model in a more cogent manner now that we have methods like “Customer.ChargeFee” and “Fee.RecordPayment”.&#160; Merely having public setters for state information loses the context of why that information changed, and in what context it is valid for that information to change.

As we move towards a fully encapsulated domain model, we may start to encounter a very critical word in our conversations with the domain experts: **When**.&#160; One of the features requested for our Customer object is: 

> We need to know if a customer has an outstanding balance on more than 3 fees. If a Customer has more than 3 fees with an outstanding balance, we flag them as AtRisk.&#160; When a customer pays off a fee and they no longer have more than 3 fees outstanding, they are no longer at risk.

Note that final sentence and the implied interaction.&#160; When a fee as been paid off, the customer needs to be notified that to update their AtRisk flag.&#160; Whenever we hear the word “When”, that should be a **signal to us that there is a potential event in our system**.&#160; We would like to **model this event explicitly** in our system and to have our model reflect this kind of relationship between Fee and Customer.&#160; In our case, we’re going to use a design from [Udi Dahan](http://www.udidahan.com/), [Domain Events](http://www.udidahan.com/2009/06/14/domain-events-salvation/).

### 

### Introducing Domain Events

So what are domain events?&#160; Domain events are similar to messaging-style eventing, with one key difference.&#160; With true messaging and a [service bus](http://www.eaipatterns.com/MessageBus.html), a message is fired and handled to asynchronously.&#160; With domain events, the response is synchronous.&#160; Using domain events is rather straight forward.&#160; In our system, we just need to know when a Fee has been paid off.&#160; Luckily, our design up to this point has already captured the explicit operation in the Fee object, the RecordPayment method. In this method, we’ll raise an event if the Balance is zero:

<pre><span style="color: blue">public </span><span style="color: #2b91af">Payment </span>RecordPayment(<span style="color: blue">decimal </span>paymentAmount, <span style="color: #2b91af">IBalanceCalculator </span>balanceCalculator)
{
    <span style="color: blue">var </span>payment = <span style="color: blue">new </span><span style="color: #2b91af">Payment</span>(paymentAmount, <span style="color: blue">this</span>);

    _payments.Add(payment);

    Balance = balanceCalculator.Calculate(<span style="color: blue">this</span>);

    <span style="color: blue">if </span>(Balance == 0)
        <span style="color: #2b91af">DomainEvents</span>.Raise(<span style="color: blue">new </span><span style="color: #2b91af">FeePaidOff</span>(<span style="color: blue">this</span>));

    <span style="color: blue">return </span>payment;
}</pre>

[](http://11011.net/software/vspaste)

After the Balance has been updated, we raise a domain event using the DomainEvents static class.&#160; The name of the event is very explicit and comes from the ubiquitous language, “FeePaidOff”.&#160; We include the Fee that was paid off as part of the event message:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">FeePaidOff </span>: <span style="color: #2b91af">IDomainEvent
</span>{
    <span style="color: blue">public </span>FeePaidOff(<span style="color: #2b91af">Fee </span>fee)
    {
        Fee = fee;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">Fee </span>Fee { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

When it comes to testing the events, we have two kinds of tests we want to write.&#160; First, we want to write a test that ensures that our Fee raised the correct event:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_notify_when_the_balance_is_paid_off()
{
    <span style="color: #2b91af">Fee </span>paidOffFee = <span style="color: blue">null</span>;

    <span style="color: #2b91af">DomainEvents</span>.Register&lt;<span style="color: #2b91af">FeePaidOff</span>&gt;(e =&gt; paidOffFee = e.Fee);

    <span style="color: blue">var </span>customer = <span style="color: blue">new </span><span style="color: #2b91af">Customer</span>();

    <span style="color: blue">var </span>fee = customer.ChargeFee(100m);

    fee.RecordPayment(100m, <span style="color: blue">new </span><span style="color: #2b91af">BalanceCalculator</span>());

    paidOffFee.ShouldEqual(fee);
}</pre>

[](http://11011.net/software/vspaste)

We’re not checking the Customer “IsAtRisk” flag in this case, as we’re only testing the Fee object in isolation.&#160; In an integration test, we’ll have our IoC container in the mix, and we’ll test the handlers as part of the complete operation.&#160; Some might argue that the complete model now includes the container, and we want to test the complete operation, events and all in our unit test.&#160; I can’t really argue against that, as you might define “unit” to now include the entire domain model, not just one entity.

### Handling the event

To handle the event, we want to update the Customer’s AtRisk status for the Customer charged for the paid-off Fee.&#160; Our handler then becomes:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">FeePaidOffHandler </span>: <span style="color: #2b91af">IHandler</span>&lt;<span style="color: #2b91af">FeePaidOff</span>&gt;
{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICustomerRepository </span>_customerRepository;

    <span style="color: blue">public </span>FeePaidOffHandler(<span style="color: #2b91af">ICustomerRepository </span>customerRepository)
    {
        _customerRepository = customerRepository;
    }

    <span style="color: blue">public void </span>Handle(<span style="color: #2b91af">FeePaidOff </span>args)
    {
        <span style="color: blue">var </span>fee = args.Fee;

        <span style="color: blue">var </span>customer = _customerRepository.GetCustomerChargedForFee(fee);

        customer.UpdateAtRiskStatus();
    }
}</pre>

[](http://11011.net/software/vspaste)

Because our handlers are pulled from the container, we can use normal dependency injection to process the event.&#160; If we were going the transaction script route, we would likely see this updating in some sort of application service.&#160; With our event handler, we ensure that our model stays consistent.&#160; The UpdateAtRiskStatus on Customer now can apply our original business logic:

<pre><span style="color: blue">public bool </span>IsAtRisk { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }

<span style="color: blue">public void </span>UpdateAtRiskStatus()
{
    <span style="color: blue">var </span>totalWithOutstandingBalance = Fees.Count(fee =&gt; fee.HasOutstandingBalance());

    IsAtRisk = totalWithOutstandingBalance &gt; 3;
}</pre>

[](http://11011.net/software/vspaste)

With our domain event in place, we can ensure that our entire domain model stays consistent with the business rules applied, even when we need to notify other aggregate roots in our system when something happens.&#160; We’ve also locked down all the ways the risk status could change (charged a new fee), so we can keep our Customer aggregate consistent even in the face of changes in a separate aggregate (Fee).

This pattern isn’t always applicable.&#160; If I need to do something like send an email, notify a web service or any other potentially blocking tasks, I should revert back to normal asynchronous messaging.&#160; But for synchronous messaging across disconnected aggregates, **domain events are a great way to ensure aggregate root consistency across the entire model**.&#160; The alternative would be transaction script design, where consistency is enforced not by the domain model but by some other (non-intuitive) layer.

### Strengthening your domain: conclusion

Creating consistent aggregate root boundaries with a fully encapsulated domain model isn’t that hard, if you know what code smells to look for.&#160; You can run into issues with less-mature ORMs that do not truly support a POCO domain model.&#160; **Having a fully encapsulated domain model represents the entirety of the ubiquitous language: state AND behavior**.&#160; Anemic domain models only tell half the picture in representing only the state.

Fully encapsulated domain models ensure that my domain model remains self-consistent, and that all invariants are satisfied at the completion of an operation.&#160; Anemic domain models do not enforce consistency rules, and rely on reams of services to keep the model valid.

For many, many applications, a domain model is more trouble than it is worth, as the behavior of these services can be quite simple.&#160; However, much of DDD is just plain good OOP, and a well-crafted domain model can be realized simply by paying attention to code smells and refactoring.