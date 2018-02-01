---
id: 391
title: 'Strengthening your domain: Aggregate Construction'
date: 2010-02-24T04:12:10+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2010/02/23/strengthening-your-domain-aggregate-construction.aspx
dsq_thread_id:
  - "264716415"
categories:
  - DomainDrivenDesign
---
Our application complexity has hit its tipping point, and we decide to move past [anemic domain models](http://martinfowler.com/bliki/AnemicDomainModel.html) to rich, behavioral models.&#160; But what is this anemic domain model?&#160; Let’s look at Fowler’s definition, now over 6 years old:

> The basic symptom of an Anemic Domain Model is that at first blush it looks like the real thing. There are objects, many named after the nouns in the domain space, and these objects are connected with the rich relationships and structure that true domain models have. The catch comes when you look at the behavior, and you realize that there is hardly any behavior on these objects, making them little more than bags of getters and setters. Indeed often these models come with design rules that say that you are not to put any domain logic in the the domain objects. Instead there are a set of service objects which capture all the domain logic. These services live on top of the domain model and use the domain model for data.

For CRUD applications, these “domain services” should number very few.&#160; But as the number of domain services begins to grow, it should be a signal to us that we need richer behavior, in the form of Domain-Driven Design.&#160; Building an application with DDD in mind is quite different than [Model-Driven Architecture](http://en.wikipedia.org/wiki/Model-driven_architecture).&#160; In MDA, we start with database table diagrams or ERDs, and build objects to match.&#160; In DDD, we start with interactions and behaviors, and build models to match.&#160; But one of the first issues we run into is, how do we create entities in the first place?&#160; Our first unit test needs to create an entity, so where should it come from?

### Creating Valid Aggregates

Validation can be a tricky beast in applications, as we often see validation has less to do with _data_ than it does with _commands_.&#160; For example, a Person might have a required “BirthDate” field on a screen.&#160; But we then have the requirement that legacy, imported Persons might not have a BirthDate.&#160; So it then becomes clear that the requirement of a BirthDate depends on who is doing the creation.

But beyond validation are the invariants of an entity.&#160; Invariants are the essence of what it means for an entity to be an entity.&#160; We may ask our customers, can a Person be a Person (in our system) without a BirthDate?&#160; Yes, sometimes.&#160; How about without a Name?&#160; No, a Person in our system must have some identifying features, that together define this “Person”.&#160; An Order needs an OrderNumber and a Customer.&#160; If the business got a paper order form without customer information, they’d throw it out!&#160; Notice this is not _validation_, but something else entirely.&#160; We’re asking now, what does it mean for an Order to be an Order?&#160; Those are its invariants.

Suppose then we have a rather simple set of logic.&#160; We indicate our Orders as “local” if the billing province is equal to the customer’s province.&#160; Rather easy method:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Order
</span>{
    <span style="color: blue">public bool </span>IsLocal()
    {
        <span style="color: blue">return </span>Customer.Province == BillingProvince;
    }</pre>

[](http://11011.net/software/vspaste)

I simply interrogate the Customer’s province against the Order’s BillingProvince.&#160; But now I can get myself into rather odd situations:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_be_a_local_customer_when_provinces_are_equal()
{
    <span style="color: blue">var </span>order = <span style="color: blue">new </span><span style="color: #2b91af">Order
    </span>{
       BillingProvince = <span style="color: #a31515">"Ontario"
    </span>};
    <span style="color: blue">var </span>customer = <span style="color: blue">new </span><span style="color: #2b91af">Customer
    </span>{
        Province = <span style="color: #a31515">"Ontario"
    </span>};

    <span style="color: blue">var </span>isLocal = order.IsLocal();

    isLocal.ShouldBeTrue();
}</pre>

[](http://11011.net/software/vspaste)

Instead of a normal assertion pass/fail, I get a NullReferenceException!&#160; I forgot to set the Customer on the Order object.

But wait – how was I able to create an Order without a Customer?&#160; An Order isn’t an Order without a Customer, as our domain experts explained to us.&#160; We could go the slightly ridiculous route, and put in null checks.

But wait – this will _never_ happen in production.&#160; We should just fix our test code and move on, right?&#160; Yes, I’d agree if you were building a transaction-script based CRUD system (the 90% case).&#160; However, if we’re doing DDD, we want to satisfy that requirement about aggregate roots, that its invariants must be satisfied with all operation.&#160; Creating an aggregate root is an operation, and therefore in our code “new” is an operation.&#160; Right now, invariants are decidedly _not_ satisfied.

Let’s modify our Order class slightly:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Order
</span>{
    <span style="color: blue">public </span>Order(<span style="color: #2b91af">Customer </span>customer)
    {
        Customer = customer;
    }</pre>

[](http://11011.net/software/vspaste)

We added a constructor to our Order class, so that when an Order is created, all invariants are satisfied.&#160; Our test now needs to be modified with our new invariant in place:

<pre>[<span style="color: #2b91af">TestFixture</span>]
<span style="color: blue">public class </span><span style="color: #2b91af">Invariants
</span>{
    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Should_be_a_local_customer_when_provinces_are_equal()
    {
        <span style="color: blue">var </span>customer = <span style="color: blue">new </span><span style="color: #2b91af">Customer
        </span>{
            Province = <span style="color: #a31515">"Ontario"
        </span>};
        <span style="color: blue">var </span>order = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>(customer)
        {
            BillingProvince = <span style="color: #a31515">"Ontario"
        </span>};

        <span style="color: blue">var </span>isLocal = order.IsLocal();

        isLocal.ShouldBeTrue();
    }
}</pre>

[](http://11011.net/software/vspaste)

And now our test passes!

### 

### Summary and alternatives

Going from a data-driven approach, this will cause pain.&#160; If we write our persistence tests first, we run into “why do I need a Customer just to test Order persistence?”&#160; Or, why do we need a Customer to test order totalling logic?&#160; The problem occurs further down the line when you start writing code against a domain model that doesn’t enforce its own invariants.&#160; If invariants are only satisfied through domain services, it becomes quite tricky to understand what a true “Order” is at any time.&#160; Should we always code assuming the Customer is there?&#160; Should we code it only when we “need” it?

If our entity always satisfies its invariants because its design doesn’t allow invariants to be violated, the violated invariants can never occur.&#160; We no longer need to even _think_ about the possibility of a missing Customer, and can build our software under that enforced rule going forward.&#160; In practice, I’ve found this approach actually requires _less_ code, as we don’t allow ourselves to get into ridiculous scenarios that we now have to think about going forward.

But building entities through a constructor isn’t the only way to go.&#160; We also have:

  * [Builder pattern](http://martinfowler.com/bliki/ExpressionBuilder.html)
  * [Creation method](http://www.industriallogic.com/xp/refactoring/constructorCreation.html)
  * [Through existing aggregate roots](http://www.udidahan.com/2009/06/29/dont-create-aggregate-roots/)

The bottom line is – if our entity needs certain information for it to be considered an entity in its essence, then don’t let it be created without its invariants satisfied!