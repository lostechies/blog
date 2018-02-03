---
wordpress_id: 86
title: Entity validation with visitors and extension methods
date: 2007-10-24T14:52:24+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/10/24/entity-validation-with-visitors-and-extension-methods.aspx
dsq_thread_id:
  - "264715383"
dsq_needs_sync:
  - "1"
categories:
  - 'C#'
  - Patterns
---
On the [Yahoo ALT.NET group](http://tech.groups.yahoo.com/group/altnetconf/), an interesting conversation sprung up around the topic of validation.&nbsp; Entity validation can be a tricky beast, as validation rules typically depend on the context of the operation (persistence, business rules, etc.).

In complex scenarios, validation usually winds up using the [Visitor pattern](http://www.dofactory.com/Patterns/PatternVisitor.aspx), but that pattern can be slightly convoluted to use from client code.&nbsp; With extension methods in C# 3.0, the Visitor pattern can be made a little easier.

#### Some simple validation

In our fictional e-commerce application, we have a simple Order object.&nbsp; Right now, all it contains are an identifier and the customer&#8217;s name that placed the order:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Order
{
    <span class="kwrd">public</span> <span class="kwrd">int</span> Id { get; set; }
    <span class="kwrd">public</span> <span class="kwrd">string</span> Customer { get; set; }
}
</pre>
</div>

Nothing too fancy, but now the&nbsp;business owner&nbsp;comes along and requests some validation rules.&nbsp;&nbsp;Orders need to have an&nbsp;ID and a customer to be valid for persistence.&nbsp; That&#8217;s not too hard, I can just add a couple of methods to the Order class to accomplish this.

The&nbsp;other requirement&nbsp;is to have a list of broken rules in case the object isn&#8217;t valid, so the end user can fix any issues.&nbsp; Here&#8217;s what we came up with:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Order
{
    <span class="kwrd">public</span> <span class="kwrd">int</span> Id { get; set; }
    <span class="kwrd">public</span> <span class="kwrd">string</span> Customer { get; set; }

    <span class="kwrd">public</span> <span class="kwrd">bool</span> IsValid()
    {
        <span class="kwrd">return</span> BrokenRules().Count() &gt; 0;
    }

    <span class="kwrd">public</span> IEnumerable&lt;<span class="kwrd">string</span>&gt; BrokenRules()
    {
        <span class="kwrd">if</span> (Id &lt; 0)
            <span class="kwrd">yield</span> <span class="kwrd">return</span> <span class="str">"Id cannot be less than 0."</span>;

        <span class="kwrd">if</span> (<span class="kwrd">string</span>.IsNullOrEmpty(Customer))
            <span class="kwrd">yield</span> <span class="kwrd">return</span> <span class="str">"Must include a customer."</span>;

        <span class="kwrd">yield</span> <span class="kwrd">break</span>;
    }
}
</pre>
</div>

Still fairly simple, though I&#8217;m starting to bleed other concerns into my entity class, such as persistence validation.&nbsp; I&#8217;d rather not have persistence concerns mixed in with my domain model, it should be another concern altogether.

#### Using validators

Right now I have one context for validation, but what happens when the business owner requests display validation?&nbsp;&nbsp;In addition to that,&nbsp;my business owner now has a black list of customers she won&#8217;t sell to, so now I need to have a black list validation, but that&#8217;s really separate from display or persistence validation.&nbsp; I don&#8217;t want to keep adding these different validation rules to Order, as some rules are only valid in certain contexts.

One common&nbsp;solution is to use a validation class together with the Visitor pattern to validate arbitrary business/infrastructure rules.&nbsp; First, I&#8217;ll need to define a generic validation interface, as I have lots of entity classes that need validation (Order, Quote, Cart, etc.):

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">interface</span> IValidator&lt;T&gt;
{
    <span class="kwrd">bool</span> IsValid(T entity);
    IEnumerable&lt;<span class="kwrd">string</span>&gt; BrokenRules(T entity);
}
</pre>
</div>

Some example validators might be &#8220;OrderPersistenceValidator : IValidator<Order>&#8221;, or &#8220;CustomerBlacklistValidator : IValidator<Customer>&#8221;, etc.&nbsp; With this interface in place, I modify the Order class to use the Visitor pattern.&nbsp; The Visitor will be the Validator, and the Visitee will be the entity class:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">interface</span> IValidatable&lt;T&gt;
{
    <span class="kwrd">bool</span> Validate(IValidator&lt;T&gt; validator, <span class="kwrd">out</span> IEnumerable&lt;<span class="kwrd">string</span>&gt; brokenRules);
}

<span class="kwrd">public</span> <span class="kwrd">class</span> Order : IValidatable&lt;Order&gt;
{
    <span class="kwrd">public</span> <span class="kwrd">int</span> Id { get; set; }
    <span class="kwrd">public</span> <span class="kwrd">string</span> Customer { get; set; }

    <span class="kwrd">public</span> <span class="kwrd">bool</span> Validate(IValidator&lt;Order&gt; validator, <span class="kwrd">out</span> IEnumerable&lt;<span class="kwrd">string</span>&gt; brokenRules)
    {
        brokenRules = validator.BrokenRules(<span class="kwrd">this</span>);
        <span class="kwrd">return</span> validator.IsValid(<span class="kwrd">this</span>);
    }
}
</pre>
</div>

I also created the &#8220;IValidatable&#8221; interface so I can keep track of what can be validated and what can&#8217;t.&nbsp; The original validation logic that was in Order is now pulled out to a separate class:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> OrderPersistenceValidator : IValidator&lt;Order&gt;
{
    <span class="kwrd">public</span> <span class="kwrd">bool</span> IsValid(Order entity)
    {
        <span class="kwrd">return</span> BrokenRules(entity).Count() &gt; 0;
    }

    <span class="kwrd">public</span> IEnumerable&lt;<span class="kwrd">string</span>&gt; BrokenRules(Order entity)
    {
        <span class="kwrd">if</span> (entity.Id &lt; 0)
            <span class="kwrd">yield</span> <span class="kwrd">return</span> <span class="str">"Id cannot be less than 0."</span>;

        <span class="kwrd">if</span> (<span class="kwrd">string</span>.IsNullOrEmpty(entity.Customer))
            <span class="kwrd">yield</span> <span class="kwrd">return</span> <span class="str">"Must include a customer."</span>;

        <span class="kwrd">yield</span> <span class="kwrd">break</span>;
    }
}
</pre>
</div>

This class can now be in a completely different namespace or assembly, and now my validation logic is completely separate from my entities.

#### Extension method mixins

Client code is a little ugly with the Visitor pattern:

<div class="CodeFormatContainer">
  <pre>Order order = <span class="kwrd">new</span> Order();
OrderPersistenceValidator validator = <span class="kwrd">new</span> OrderPersistenceValidator();

IEnumerable&lt;<span class="kwrd">string</span>&gt; brokenRules;
<span class="kwrd">bool</span> isValid = order.Validate(validator, <span class="kwrd">out</span> brokenRules);
</pre>
</div>

It still seems a little strange to have to know about the correct validator to use.&nbsp; [Elton](http://eltonomicon.blogspot.com/) wrote about a [nice trick](http://eltonomicon.blogspot.com/2007/10/extension-methods-and-visitor-pattern.html) with Visitor and extension methods that I could use here.&nbsp; I can use an extension method for the Order type&nbsp;to wrap the creation of the validator class:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">bool</span> ValidatePersistence(<span class="kwrd">this</span> Order entity, <span class="kwrd">out</span> IEnumerable&lt;<span class="kwrd">string</span>&gt; brokenRules)
{
    IValidator&lt;Order&gt; validator = <span class="kwrd">new</span> OrderPersistenceValidator();

    <span class="kwrd">return</span> entity.Validate(validator, brokenRules);
}
</pre>
</div>

Now my client code is a little more bearable:

<div class="CodeFormatContainer">
  <pre>Order order = <span class="kwrd">new</span> Order();

IEnumerable&lt;<span class="kwrd">string</span>&gt; brokenRules;
<span class="kwrd">bool</span> isValid = order.ValidatePersistence(<span class="kwrd">out</span> brokenRules);
</pre>
</div>

My Order class doesn&#8217;t have any persistence validation logic, but with extension methods, I can make the client code unaware of which specific Validation class it needs.

#### A generic solution

Taking this one step further, I can use a [Registry](http://martinfowler.com/eaaCatalog/registry.html) to register validators based on types, and create a more generic extension method that relies on constraints:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Validator
{
    <span class="kwrd">private</span> <span class="kwrd">static</span> Dictionary&lt;Type, <span class="kwrd">object</span>&gt; _validators = <span class="kwrd">new</span> Dictionary&lt;Type, <span class="kwrd">object</span>&gt;();

    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">void</span> RegisterValidatorFor&lt;T&gt;(T entity, IValidator&lt;T&gt; validator)
        <span class="kwrd">where</span> T : IValidatable&lt;T&gt;
    {
        _validators.Add(entity.GetType(), validator);
    }

    <span class="kwrd">public</span> <span class="kwrd">static</span> IValidator&lt;T&gt; GetValidatorFor&lt;T&gt;(T entity)
        <span class="kwrd">where</span> T : IValidatable&lt;T&gt;
    {
        <span class="kwrd">return</span> _validators[entity.GetType()] <span class="kwrd">as</span> IValidator&lt;T&gt;;
    }

    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">bool</span> Validate&lt;T&gt;(<span class="kwrd">this</span> T entity, <span class="kwrd">out</span> IEnumerable&lt;<span class="kwrd">string</span>&gt; brokenRules)
        <span class="kwrd">where</span> T : IValidatable&lt;T&gt;
    {
        IValidator&lt;T&gt; validator = Validator.GetValidatorFor(entity);

        <span class="kwrd">return</span> entity.Validate(validator, <span class="kwrd">out</span> brokenRules);
    }
}
</pre>
</div>

Now I can use the extension method on any type that implements IValidatable<T>, including my Order, Customer, and Quote classes.&nbsp; In my app startup code, I&#8217;ll register all the appropriate validators needed.&nbsp; If types use more than one validator, I can modify my registry to include some extra location information.&nbsp; Typically, I&#8217;ll keep all of this information in my IoC container so it can all get wired up automatically.

Visitor patterns are useful when they&#8217;re really needed, as in the case of entity validation, but can be overkill sometimes.&nbsp; With extension methods in C# 3.0, I can remove some of the difficulties that Visitor pattern introduces.