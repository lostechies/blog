---
wordpress_id: 392
title: 'Strengthening your domain: Encapsulated collections'
date: 2010-03-10T14:19:16+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/03/10/strengthening-your-domain-encapsulated-collections.aspx
dsq_thread_id:
  - "264716419"
categories:
  - DomainDrivenDesign
redirect_from: "/blogs/jimmy_bogard/archive/2010/03/10/strengthening-your-domain-encapsulated-collections.aspx/"
---
Previous posts in this series:

  * [A Primer](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/02/03/strengthening-your-domain-a-primer.aspx)
  * [Aggregate Construction](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/02/23/strengthening-your-domain-aggregate-construction.aspx)

One of the common themes throughout the [DDD book](http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215) is that much of the nuts and bolts of structural domain-driven design is just plain good use of object-oriented programming.&#160; This is certainly true, but DDD adds some direction to OOP, along with roles, stereotypes and patterns.&#160; Much of the direction for building entities at the class level can, and should, come from test-driven development.&#160; TDD is a great tool for building OO systems, as we incrementally build our design with only the behavior that is needed to pass the test.&#160; Our big challenge then is to write good tests.

To fully harness TDD, we need to be highly attuned to the design that comes out of our tests.&#160; For example, suppose we have our traditional Customer and Order objects.&#160; In our world, an Order has a Customer, and a Customer can have many Orders.&#160; We have this directionality because we can navigate this relationship from both directions in our application.&#160; In the last post, we worked to satisfy invariants to prevent an unsupported and nonsensical state for our objects.

We can start with a fairly simple test:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_add_the_order_to_the_customers_order_lists_when_an_order_is_created()
{
    <span style="color: blue">var </span>customer = <span style="color: blue">new </span><span style="color: #2b91af">Customer</span>();
    <span style="color: blue">var </span>order = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>(customer);

    customer.Orders.ShouldContain(order);
}</pre>

[](http://11011.net/software/vspaste)

At first, this test does not compile, as Customer does not yet contain an Orders member.&#160; To make this test compile (and subsequently fail), we add an Orders list to Customer:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Customer
</span>{
    <span style="color: blue">public string </span>FirstName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>LastName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>Province { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Order</span>&gt; Orders { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

    <span style="color: blue">public string </span>GetFullName()
    {
        <span style="color: blue">return </span>LastName + <span style="color: #a31515">", " </span>+ FirstName;
    }
}</pre>

[](http://11011.net/software/vspaste)

With the Orders now exposed on Customer, we can make our test pass from the Order constructor:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Order
</span>{
    <span style="color: blue">public </span>Order(<span style="color: #2b91af">Customer </span>customer)
    {
        Customer = customer;
        customer.Orders.Add(<span style="color: blue">this</span>);
    }</pre>

[](http://11011.net/software/vspaste)

And all is well in our development world, right?&#160; Not quite.&#160; This design exposes quite a bit of functionality that I don’t think our domain experts need, or want.&#160; The design above allows some very interesting and very wrong scenarios:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Not_supported_situations()
{
    <span style="color: green">// Removing orders?
    </span><span style="color: blue">var </span>customer1 = <span style="color: blue">new </span><span style="color: #2b91af">Customer</span>();
    <span style="color: blue">var </span>order1 = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>(customer1);

    customer1.Orders.Remove(order1);

    <span style="color: green">// Clearing orders?
    </span><span style="color: blue">var </span>customer2 = <span style="color: blue">new </span><span style="color: #2b91af">Customer</span>();
    <span style="color: blue">var </span>order2 = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>(customer1);

    customer2.Orders.Clear();

    <span style="color: green">// Duplicate orders?
    </span><span style="color: blue">var </span>customer3 = <span style="color: blue">new </span><span style="color: #2b91af">Customer</span>();
    <span style="color: blue">var </span>customer4 = <span style="color: blue">new </span><span style="color: #2b91af">Customer</span>();
    <span style="color: blue">var </span>order3 = <span style="color: blue">new </span><span style="color: #2b91af">Order</span>(customer3);

    customer4.Orders.Add(order3);
}</pre>

[](http://11011.net/software/vspaste)

With the API I just created, I allow a number of rather bizarre scenarios, most of which make absolutely no sense to the domain experts:

  * Clearing orders
  * Removing orders
  * Adding an order from one customer to another
  * Inserting orders
  * Re-arranging orders
  * Adding an order without the Order’s Customer property being correct

This is where we have to be a little more judicious in the API we expose for our system.&#160; All of these scenarios are _possible_ in the API we created, but now we have some confusion on whether we should support these scenarios or not.&#160; If I’m working in a similar area of the system, and I see that I can do a Customer.Orders.Remove operation, it’s not immediately clear that this is a scenario not actually coded for.&#160; Worse, I don’t have the ability to correctly handle these situations if the collection is exposed directly.

Suppose I want to clear a Customer’s Orders.&#160; It logically follows that each Order’s Customer property would be null at that point.&#160; But I can’t hook in easily to the List<T> methods to handle these operations.&#160; **Instead of exposing the collection directly, I will expose only those operations which I support through my domain.**

### Moving towards intention-revealing interfaces

Let’s fix the Customer object first.&#160; It exposes a List<T> directly, and allows wholesale replacement of that collection.&#160; This is the complete antithesis of intention-revealing interfaces.&#160; I will now only expose the sequence of Orders on Customer:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Customer
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IList</span>&lt;<span style="color: #2b91af">Order</span>&gt; _orders = <span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Order</span>&gt;();

    <span style="color: blue">public string </span>FirstName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>LastName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>Province { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">Order</span>&gt; Orders { <span style="color: blue">get </span>{ <span style="color: blue">return </span>_orders; } }

    <span style="color: blue">public string </span>GetFullName()
    {
        <span style="color: blue">return </span>LastName + <span style="color: #a31515">", " </span>+ FirstName;
    }
}</pre>

[](http://11011.net/software/vspaste)

This interface explicitly tells users of Customer two things:

  * Orders are readonly, and cannot be modified through this aggregate
  * Adding orders are done somewhere else

I now have the issue of the Order constructor needing to add itself to the Customer’s Order collection.&#160; I want to do this:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Order
</span>{
    <span style="color: blue">public </span>Order(<span style="color: #2b91af">Customer </span>customer)
    {
        Customer = customer;
        customer.AddOrder(<span style="color: blue">this</span>);
    }</pre>

[](http://11011.net/software/vspaste)

Instead of exposing the Orders collection directly, I work through a specific method to add an order.&#160; But, I don’t want that AddOrder available everywhere, I want to only support the enforcement of the Order-Customer relationship through this explicitly defined interface.&#160; I’ll do this by exposing an AddOrder method, but exposing it as internal:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Customer
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IList</span>&lt;<span style="color: #2b91af">Order</span>&gt; _orders = <span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Order</span>&gt;();

    <span style="color: blue">public string </span>FirstName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>LastName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>Province { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">Order</span>&gt; Orders { <span style="color: blue">get </span>{ <span style="color: blue">return </span>_orders; } }

    <span style="color: blue">internal void </span>AddOrder(<span style="color: #2b91af">Order </span>order)
    {
        _orders.Add(order);
    }</pre>

There are many different ways I could enforce this relationship, from exposing an AddOrder method publicly on Customer or through the approach above.&#160; But either way, I’m moving towards an intention-revealing interface, and only exposing the operations I intend to support through my application.&#160; Additionally, I’m ensuring that all invariants of my aggregates are satisfied at the completion of the Create Order operation.&#160; When I create an Order, the domain model takes care of the relationship between Customer and Order without any additional manipulation.

If I publicly expose a collection class, I’m opening the doors for confusion and future bugs as I’ve now allowed my system to tinker with the implementation details of the relationship.&#160; It’s my belief that the API of my domain model should explicitly support the operations needed to fulfill the needs of the application and interaction of the UI, **but nothing more**.