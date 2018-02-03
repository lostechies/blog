---
wordpress_id: 279
title: DDD Aggregate Component pattern in action
date: 2009-02-05T04:46:48+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/02/04/ddd-aggregate-component-pattern-in-action.aspx
dsq_thread_id:
  - "264716050"
categories:
  - DomainDrivenDesign
---
In my last post, I went on a long-winded rant on how the composition and the Aggregate Component pattern can ease the burden of the interaction between Entities and Services.&#160; The question comes up often on DDD or IoC forums:

**How do I inject/use a Service/Repository inside an Entity?**

You can get really fancy with your ORM or really fancy with your IoC Container to try and make your Entities join in an unholy matrimony.&#160; But there are other, better ways of skinning this OO cat.

### 

### The hard way

We may try to get these services injected through our ORM or IoC container, or we could try and do a static, opaque or service located dependency directly inside our entity:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Order
</span>{
    <span style="color: blue">public decimal </span>CalculateTotal()
    {
        <span style="color: blue">decimal </span>itemTotal = GetSubTotal();
        <span style="color: blue">decimal </span>taxTotal = <span style="color: #2b91af">TaxService</span>.CalculateTax(<span style="color: blue">this</span>);
        <span style="color: blue">decimal </span>discount = <span style="color: #2b91af">DiscountCalculator</span>.FindDiscount(<span style="color: blue">this</span>);

        <span style="color: blue">return </span>itemTotal + taxTotal - discount;
    }</pre>

[](http://11011.net/software/vspaste)

In this snippet, we have an Order entity that is apparently responsible for calculating up-to-date tax and discount information.&#160; We’ll get back to that cluster in a second.&#160; First order of business, how do we deal with these two dependencies, the TaxService and DiscountCalculator?&#160; A few options include:

  * Static, opaque dependencies (seen above)
  * Use service location, through a container or other means (ServiceLocator.GetInstance<ITaxService>())
  * Pass dependencies in through the method, still using double-dispatch (CalculateTotal(ITaxService, IDiscountCalculator)

Each of these has its merits, but still becomes quite annoying.&#160; In the first approach, we’re back to just plain bad code, opaque, static, hard dependencies with tight coupling and no visibility from the outside of side effects or potential gotchas.

In the second approach, we’ve removed the tight coupling, but not the opaqueness.&#160; If it’s not plainly obvious to users of this class what it’s responsible for, that’s just more boring debugging and manual analysis on the developer’s side when things go wrong or we need to make a change.&#160; In the final option, we’ve now made our dependencies transparent, but now the burden of locating the dependencies is on the caller.

If we’re using dependency injection, no problem, but in this case we’re not injecting dependencies, we’re just passing them along.&#160; Do we really want our callers to have to figure out how the heck to locate an ITaxService or IDiscountCalculator?&#160; Probably not.&#160; Now, callers of Order not only need to know about what Order needs to do its work, but have to have these dependencies available somehow.&#160; We have better options, such as dependency injection for callers, but it’s still rather annoying that dependencies of Order are now affecting callers.

Studying our original domain model, I see a much larger issue – something’s wonky with our domain.

### Fixing the model

When I was in e-commerce, we had a lot of prior art in looking at ordering and processing systems.&#160; In the above example, we have an Entity that has a moving target on what you would think would be one of its core attributes – its Total.&#160; An order with a changing total is bad news in the e-commerce world, as an Order is usually something that is placed and locked down.&#160; So what is this Order that we have here?&#160; Is it an OrderPlaced, or does it simply represent a _request_ to place an order?

If we have a moving Total target, it’s far more likely that this is simply a request to place an order, not a placed order.&#160; Once an order is saved or processed, it usually enters into a larger saga/workflow/process, where the order moves from system to system (processing, payment, fulfillment, etc.).&#160; Maybe our company isn’t that complex, but we’d still not want customer complaining that the discount they saw when they placed the order yesterday is for some reason gone when the order is fulfilled today.

For these reasons, and others, we’re often not working with an Order on the customer side, but a Cart, an OrderRequest, or even a PotentialOrder.&#160; In those cases, it’s far more likely that these Entities, or something very close to them, will have the responsibility for calculating and displaying discounts and tax information.

But what exactly is an PotentialOrder?&#160; Does it have an identity?&#160; Is it ever persisted?&#160; Oftentimes, no.&#160; An PotentialOrder may be persisted, but more likely in a separate, locked-down model where totals and discounts can’t change the same way.

### In comes the Aggregate Component

A PotentialOrder is a one-time only view of a _potential_ order, built from a Cart (in our case, just a container of Products with quantities and a Customer), along with a snapshot of the tax and discount calculation at the time of request.&#160; The customer can view a PotentialOrder, then decide if they would like to continue the order and create an actual Order, where other tax and discount rules may come into play.&#160; Other names for PotentialOrder might be Quote, but the idea is still the same.&#160; An Order implies a request on the Customer side to make a transaction.

With this in mind, our PotentialOrder still has to do tax and discount calculations.&#160; In simple cases, we can just give the PotentialOrder the results of calculations, but in our case, we needed additional information about the tax and discounts, notably where they came from.&#160; Our PotentialOrder became an immutable Aggregate Component (looking like a Value Object, but bigger):

<pre><span style="color: blue">public class </span><span style="color: #2b91af">PotentialOrder
</span>{
    <span style="color: blue">public </span>PotentialOrder(Cart cart,
        <span style="color: #2b91af">ITaxProvider </span>taxProvider,
        <span style="color: #2b91af">IDiscountFinder </span>discountFinder)
    {</pre>

[](http://11011.net/software/vspaste)

Our PotentialOrder takes exactly what it needs to run – the Cart, a tax provider and a discount finder.&#160; All transparent dependencies, each used for the PotentialOrder to do its job.&#160; I don’t have to look very far to find the real total calculations:

<pre><span style="color: blue">public decimal </span>CalculateTotal()
{
    <span style="color: blue">decimal </span>itemTotal = _cart.GetTotal();
    <span style="color: blue">decimal </span>taxTotal = _taxProvider.Calculate(<span style="color: blue">this</span>);
    <span style="color: blue">decimal </span>discount = _discountFinder.SumDiscounts(<span style="color: blue">this</span>);

    <span style="color: blue">return </span>itemTotal + taxTotal - discount;
}</pre>

[](http://11011.net/software/vspaste)

We’re still using the same double-dispatch system from our opaque dependencies, but now we have a lot more leniency in how we can represent our calculations.&#160; Typically, we’ll combine some sort of Composite and Strategy pattern, such that we can combine many complex calculation algorithms into one interface, to be consumed by our PotentialOrder.

So how does our PotentialOrder get created?&#160; Not from a container, but through a specialized Factory instead:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">PotentialOrderFactory
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">PotentialOrder </span>Create(<span style="color: #2b91af">Cart </span>cart)
    {
        <span style="color: #2b91af">ITaxProvider </span>taxman = _taxLocator.Find(cart);
        <span style="color: #2b91af">IDiscountFinder </span>discounter = _discountBuilder.Build(cart);

        <span style="color: blue">return new </span><span style="color: #2b91af">PotentialOrder</span>(cart, taxman, discounter);
    }</pre>

[](http://11011.net/software/vspaste)

The TaxLocator and DiscountBuilder encapsulate the potential complexities of resolving the correct tax and discount algorithms.&#160; Once built, the TaxProvider and DiscountFinder are immutable Value Objects, returning the same result every single time.&#160; One TaxLocator might be Texas Sales Tax, which is a percentage of the subtotal of a Cart.&#160; I do know that once my PotentialOrder is built, all of its algorithms are locked in and won’t change, no matter how complex they might get.

So why didn’t we just give the PotentialOrder its total?&#160; Personally, I like keeping behavior associated with an object, defined on that object.&#160; Putting the total calculations, as well as what’s needed to do so, on the PotentialOrder gets away from an anemic domain model.&#160; Before the Aggregate Component concept, behavior about a PotentialOrder was scattershot around the system, making it harder to grasp and talk about what a PotentialOrder was with the domain experts.

### 

### Keeping our model smart

I absolutely detest dumb domain models.&#160; The behavior is out there, I promise, but it’s probably in the wrong place.&#160; When we start seeing scenarios where we want our persistent entities calling out to services and repositories to do additional work, I see an opportunity to explore a larger, aggregate component model that pulls all these concepts into one cohesive place.&#160; DDD can lead to service-itis, with anemic domain models and a barrel full of services who seem awfully concerned about one or more entities.

Object-oriented design and modeling was refined and clarified with Evans’ book.&#160; But that doesn’t mean we’re supposed to be constrained to solely the patterns and names we found in the book.