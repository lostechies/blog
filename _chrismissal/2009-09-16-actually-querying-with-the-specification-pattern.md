---
wordpress_id: 3367
title: Actually Querying with the Specification Pattern
date: 2009-09-16T13:25:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/09/16/actually-querying-with-the-specification-pattern.aspx
dsq_thread_id:
  - "262122323"
categories:
  - Design Patterns
  - DRY
  - Moq
  - Testing
redirect_from: "/blogs/chrismissal/archive/2009/09/16/actually-querying-with-the-specification-pattern.aspx/"
---
In my previous post, I talked about [using the specification pattern for querying](/blogs/chrismissal/archive/2009/09/10/using-the-specification-pattern-for-querying.aspx) collections. I didn&#8217;t actually show any code that does what I was talking about, I just showed the set-up and creation of specifications. The following is how you can put this into practice.

## Setting Up Some Tests

These examples are going to be using [Moq](http://code.google.com/p/moq/) as an isolation/mocking framework. I find that the new Linq to Mocks syntax works pretty well for creating the scenarios. The first step I used is to create an InMemoryRepository. This will hold some pre-set customers that I can use in my tests to ensure that my Specifications get the expected number of Customers based on what the repository is holding.

<pre style="font-size:135%">public class InMemoryCustomerRepository : Repository&lt;Customer&gt;
    {
        private readonly IList&lt;Customer&gt; customers = new List&lt;Customer&gt;();

        public InMemoryCustomerRepository()
        {
            customers.Add(new Customer().WithTwentyOrders());
            customers.Add(new Customer().WithTwentyOrders());
            customers.Add(new Customer().WithTwentyOrders()<br />                .WithLifetimeValueOf(8888m));
            customers.Add(new Customer().WithTwentyOrders()<br />                .WithLifetimeValueOf(10001m));
            customers.Add(new Customer().WithLifetimeValueOf(4000m));
            customers.Add(new Customer().WithLifetimeValueOf(5000m));
            customers.Add(new Customer().WithLifetimeValueOf(6000m));
            customers.Add(new Customer().WithLifetimeValueOf(7000m));
            customers.Add(new Customer().WithLifetimeValueOf(8000m));
            customers.Add(new Customer().WithLifetimeValueOf(9000m));
            customers.Add(new Customer().WithTwentyOrders()<br />                .WithLifetimeValueOf(3000m).AsDiscountMember());
            customers.Add(new Customer().WithTwentyOrders()<br />                .WithLifetimeValueOf(6000m).AsDiscountMember());
            customers.Add(new Customer().WithTwentyOrders()<br />                .WithLifetimeValueOf(9000m).AsDiscountMember());
        }

        protected override IEnumerable&lt;Customer&gt; GetAllEntities()
        {
            return customers;
        }
    }
</pre>

This class only provides some sample data that we&#8217;re going to use in our tests. I used some extension methods and chaining to build up some customers to add to our list.

## Using Linq to Mocks

[Moq](http://code.google.com/p/moq/) has recently introduced [Linq to Mocks](http://www.clariusconsulting.net/blogs/kzu/archive/2009/08/13/164978.aspx) where you can use Linq to query for an object you want to create. Basically, you&#8217;re saying:

<p style="padding-left: 30px">
  <i>Give me one customer that is a discount member, has an order count of 13 and a lifetime customer value of $5,555.</i>
</p>

When there is a lot of setup involved with creating some fake objects, you&#8217;ll want move that into some sort of method so you don&#8217;t have to repeat yourself all over the place. Here&#8217;s how I did this with my customers:

&nbsp;

<pre style="font-size:135%">private static Customer GetPlatinumCustomer()<br />{<br />&nbsp;&nbsp; &nbsp;return (from customer in Mocks.Query&lt;Customer&gt;()<br />&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;where customer.IsDiscountMember == true &&<br />&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;customer.OrderCount == 13 &&<br />&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;customer.LifetimeCustomerValue == 5555m<br />&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;select customer).First();<br />}<br />private static Customer GetPreferredCustomer()<br />{<br />&nbsp;&nbsp; &nbsp;return (from customer in Mocks.Query&lt;Customer&gt;()<br />&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;where customer.LifetimeCustomerValue == 5555m<br />&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;select customer).First();<br />}<br />private static Customer GetGoldCustomer()<br />{<br />&nbsp;&nbsp; &nbsp;return (from customer in Mocks.Query&lt;Customer&gt;()<br />&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;where customer.OrderCount == 13 &&<br />&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;customer.LifetimeCustomerValue == 5555m<br />&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;select customer).First();<br />}</pre>

If you need to build up some complex mocks/fakes, this method works fairly well, as [demonstrated by Daniel Cazzulino](http://www.clariusconsulting.net/blogs/kzu/archive/2009/08/13/164978.aspx), creator of Moq.

The tests that I wrote were very straightforward. Most were something along these lines:

<pre style="font-size:135%">[Fact]
public void GoldCustomer_should_also_meet_PreferredCustomer_requirements()
{
    var goldCustomer = GetGoldCustomer();

    var result = new PreferredCustomerSpecification().IsSatisfiedBy(goldCustomer);

    Assert.True(result);
}
</pre>

I&#8217;m a big fan of using the Arrange/Act/Assert (AAA) syntax in unit tests, here I&#8217;m using the AAA syntax by doing the following:

  * **Arrange:** Getting a &#8220;Gold&#8221; customer
  * **Act:** Passing the customer into a specification
  * **Assert:** Ensuring that the result of the specification is false.

## Implementing the Repository

Now it&#8217;s time to make sure this test passes, let&#8217;s implement the Get method of the CustomerRepository that takes an ISpecification<Customer>. Here&#8217;s how the abstract class is set up:

<pre style="font-size:135%">public abstract class Repository&lt;T&gt;<br />{<br />&nbsp;&nbsp; &nbsp;public IEnumerable&lt;T&gt; Get(ISpecification&lt;T&gt; specification)<br />&nbsp;&nbsp; &nbsp;{<br />&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;foreach (var customer in GetAllEntities().Where(specification.IsSatisfiedBy))<br />&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;yield return customer;<br />&nbsp;&nbsp; &nbsp;}<br />&nbsp;<br />&nbsp;&nbsp; &nbsp;protected abstract IEnumerable&lt;T&gt; GetAllEntities();<br />}</pre>

This is all I did for these examples. The abstract class above does all the work. Given a repository of type T, and a specification of type T, it will return all objects of T that match the specification.