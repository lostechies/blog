---
id: 203
title: 'Separation of Concerns by example: Part 4'
date: 2008-07-10T11:57:27+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/07/10/separation-of-concerns-by-example-part-4.aspx
dsq_thread_id:
  - "264715818"
categories:
  - BDD
  - BehaviorDrivenDevelopment
  - Refactoring
---
In the last part, we finally broke out the caching and data access concerns from our original class.&nbsp; The series so far includes:

  * [Separation of Concerns &#8211; how not to do it](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/06/17/separation-of-concerns-how-not-to-do-it.aspx)
  * [Separation of Concerns by example: Part 1](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/06/19/separation-of-concerns-by-example-part-1.aspx) &#8211; Refactoring away from static class
  * [Separation of Concerns by example: Part 2](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/06/24/separation-of-concerns-by-example-part-2.aspx) &#8211; Specialized interface for Cache
  * [Separation of Concerns by example: Part 3](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/06/26/separation-of-concerns-by-example-part-3.aspx) &#8211; Creating the repository

Things are looking up, we&#8217;ve broken out the dependencies into distinct concerns, including caching, data access and finding/paging.&nbsp; Unfortunately, our high-volume site has run into some intermittent issues.&nbsp; Every now and then, especially during peak hours, the application experiences NullReferenceExceptions, coming from our new and (hopefully) improved CustomerFinder.

### 

### Finding the defect

Let&#8217;s review the current CustomerFinder to see how we might run into a NullReferenceException:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerFinder
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICustomerRepository </span>_customerRepository;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICustomCache </span>_customCache;

    <span style="color: blue">public </span>CustomerFinder(<span style="color: #2b91af">ICustomerRepository </span>customerRepository, <span style="color: #2b91af">ICustomCache </span>customCache)
    {
        _customerRepository = customerRepository;
        _customCache = customCache;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">Customer</span>[] FindAllCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
    {
        <span style="color: #2b91af">Customer</span>[] customers = <span style="color: blue">null</span>;
        <span style="color: blue">string </span>key = <span style="color: #a31515">"Customers_Customers_" </span>+ startRowIndex + <span style="color: #a31515">"_" </span>+ maximumRows;

        <span style="color: blue">if </span>(_customCache.Contains(key))
        {
            customers = _customCache.GetItem&lt;<span style="color: #2b91af">Customer</span>[]&gt;(key);
        }
        <span style="color: blue">else
        </span>{
            customers =_customerRepository
                        .FindAllCustomers()
                        .Skip(startRowIndex)
                        .Take(maximumRows)
                        .ToArray();

            <span style="color: blue">if </span>((customers != <span style="color: blue">null</span>) && (customers.Length &gt; 0))
                _customCache.AddItemExpringTomorrow(key, customers);
        }

        <span style="color: blue">return </span>customers;
    }

}
</pre>

[](http://11011.net/software/vspaste)

Somehow, our FindAllCustomers method is returning a null Customer array, causing us to break our contract with callers of this class.&nbsp; Anything that returns an array should never return null, only an empty array if no items are returned.

So how could the return value be null?&nbsp; Look at the CustomerFinder class, we see it&#8217;s initialized to null, and assigned twice.&nbsp; Once in the caching scenario, and once in the repository scenario.&nbsp; The repository scenario doesn&#8217;t seem to fit, as the ToArray extension method never returns null.

Looking at the caching scenario, combined with our knowledge of when the bug happens, it looks like we might have our culprit. Suppose that under heavy load, the cache item expires _between_ the Contains and GetItem call?&nbsp; GetItem could certainly return null in that case.&nbsp; Looking at the Cache documentation, getting an expired (and therefore non-existing) item does not throw any exception, and returns null.

Let&#8217;s look at changing the behavior so that we take this scenario into account.

### Making the change (safely)

Since we&#8217;d like to minimize the risk of change to this piece of code (after all, we have a high volume website to keep going), we&#8217;ll add a test to cover the behavior we want to see, before we make the change.&nbsp; After all, if the behavior we specify should exist, already does, then either our assumptions are wrong or our code already works.

First, let&#8217;s think of the context of when this bug happens.&nbsp; It occurred when the cache item expired after I checked the cache.&nbsp; Let&#8217;s create our specification with that as the description:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">When_finding_customers_and_the_cache_expires_after_checking_the_cache 
    </span>: <span style="color: #2b91af">ContextSpecification
</span>{
    
}
</pre>

[](http://11011.net/software/vspaste)

This is basically a [Testcase Class per Feature](http://xunitpatterns.com/Testcase%20Class%20per%20Fixture.html) xUnit pattern, with a BDD-style naming.&nbsp; Basically, I&#8217;m describing the context/scenario where the behavior I want to observe is valid.&nbsp; The ContextSpecification is similar version of [JP&#8217;s base specification class](http://blog.jpboodhoo.com/BDDAAAStyleTestingAndRhinoMocks.aspx) that I&#8217;m using from my pet project, NBehave.

Now we need to describe the behavior we want to see.&nbsp; I&#8217;d like to see a few things happen:

  * The customers returned shouldn&#8217;t be null
  * It should use the repository to find the customers (as the cache didn&#8217;t work)
  * It should push the results back into the cache

All of these I might write down in an index card or something.&nbsp; It&#8217;s something that helps me think through the behaviors I&#8217;m trying to specify.&nbsp; Here&#8217;s the test class with the behaviors specified:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">When_finding_products_and_the_cache_expires_after_checking_the_cache 
    </span>: <span style="color: #2b91af">ContextSpecification
</span>{
    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Customers_returned_should_not_be_null()
    {
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>It_should_use_the_repository_to_find_the_customers()
    {
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Customers_returned_should_be_stored_in_the_cache()
    {
    }
}
</pre>

[](http://11011.net/software/vspaste)

With Rhino Mocks 3.5, testing these indirect inputs and outputs is a snap.&nbsp; Now that we have our specifications, let&#8217;s establish the context, the reason for the behaviors, and fill out our verification of the desired behaviors:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">When_finding_products_and_the_cache_expires_after_checking_the_cache 
    </span>: <span style="color: #2b91af">ContextSpecification
</span>{
    <span style="color: blue">private </span><span style="color: #2b91af">CustomerFinder </span>_customerFinder;
    <span style="color: blue">private </span><span style="color: #2b91af">Customer</span>[] _actualCustomers;
    <span style="color: blue">private </span><span style="color: #2b91af">ICustomerRepository </span>_customerRepository;
    <span style="color: blue">private </span><span style="color: #2b91af">ICustomCache </span>_customCache;

    <span style="color: blue">protected override void </span>EstablishContext()
    {
        _customCache = Dependency&lt;<span style="color: #2b91af">ICustomCache</span>&gt;();
        _customerRepository = Dependency&lt;<span style="color: #2b91af">ICustomerRepository</span>&gt;();

        _customerFinder = <span style="color: blue">new </span><span style="color: #2b91af">CustomerFinder</span>(_customerRepository, _customCache);

        <span style="color: blue">var </span>customer1 = <span style="color: blue">new </span><span style="color: #2b91af">Customer </span>{CustomerID = <span style="color: #a31515">"1"</span>};
        <span style="color: blue">var </span>customer2 = <span style="color: blue">new </span><span style="color: #2b91af">Customer </span>{CustomerID = <span style="color: #a31515">"2"</span>};

        <span style="color: blue">var </span>foundCustomers = <span style="color: blue">new</span>[]
                                 {
                                     customer1,
                                     customer2
                                 }
                                 .AsQueryable()
                                 .OrderBy(cust =&gt; cust.CustomerID);

        _customCache.Stub(cache =&gt; cache.Contains(<span style="color: #a31515">"Customers_Customers_1_1"</span>)).Return(<span style="color: blue">true</span>);
        _customCache.Stub(cache =&gt; cache.GetItem&lt;<span style="color: #2b91af">Customer</span>[]&gt;(<span style="color: #a31515">"Customers_Customers_1_1"</span>)).Return(<span style="color: blue">null</span>);
        _customerRepository.Stub(repo =&gt; repo.FindAllCustomers()).Return(foundCustomers);
    }

    <span style="color: blue">protected override void </span>Because()
    {
        _actualCustomers = _customerFinder.FindAllCustomers(1, 1);
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Customers_returned_should_not_be_null()
    {
        _actualCustomers.ShouldNotBeNull();
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>It_should_use_the_repository_to_find_the_customers()
    {
        _customerRepository.AssertWasCalled(repo =&gt; repo.FindAllCustomers());
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Customers_returned_should_be_stored_in_the_cache()
    {
        _customCache.AssertWasCalled(cache =&gt; cache.AddItemExpringTomorrow&lt;<span style="color: #2b91af">Customer</span>[]&gt;(<span style="color: blue">null</span>, <span style="color: blue">null</span>),
            option =&gt; option.Constraints(<span style="color: #2b91af">Is</span>.Equal(<span style="color: #a31515">"Customers_Customers_1_1"</span>), 
                                         <span style="color: #2b91af">Is</span>.Matching&lt;<span style="color: #2b91af">Customer</span>[]&gt;(item =&gt; item.Length == 1)));
    }

}
</pre>

[](http://11011.net/software/vspaste)

With Rhino Mocks new Arrange Act Assert syntax, it&#8217;s much easier to separate the specifications into the context, reason, and verification of the behavior.&nbsp; In TDD terms, I&#8217;ve separated the Setup, Exercise, and Assert into three different parts.&nbsp; Each behavior is verified independently of the other.

Running my specification through TestDriven.NET tells me that all three behaviors don&#8217;t work yet, and I need to modify my CustomerFinder to get them green again.&nbsp; Here&#8217;s my CustomerFinder after the changes:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerFinder
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICustomerRepository </span>_customerRepository;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICustomCache </span>_customCache;

    <span style="color: blue">public </span>CustomerFinder(<span style="color: #2b91af">ICustomerRepository </span>customerRepository, <span style="color: #2b91af">ICustomCache </span>customCache)
    {
        _customerRepository = customerRepository;
        _customCache = customCache;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">Customer</span>[] FindAllCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
    {
        <span style="color: #2b91af">Customer</span>[] customers = <span style="color: blue">null</span>;
        <span style="color: blue">string </span>key = <span style="color: #a31515">"Customers_Customers_" </span>+ startRowIndex + <span style="color: #a31515">"_" </span>+ maximumRows;

        <span style="color: blue">if </span>(_customCache.Contains(key))
        {
            customers = _customCache.GetItem&lt;<span style="color: #2b91af">Customer</span>[]&gt;(key);
        }

        <span style="color: blue">if </span>(customers == <span style="color: blue">null</span>)
        {
            customers =_customerRepository
                        .FindAllCustomers()
                        .Skip(startRowIndex)
                        .Take(maximumRows)
                        .ToArray();

            <span style="color: blue">if </span>((customers != <span style="color: blue">null</span>) && (customers.Length &gt; 0))
                _customCache.AddItemExpringTomorrow(key, customers);
        }

        <span style="color: blue">return </span>customers;
    }

}
</pre>

[](http://11011.net/software/vspaste)

Here, I broke out the if/else into two if statements, where the repository search would still occur if the cache retrieval fails.&nbsp; Going back to my specification, I see that all behaviors are working now.&nbsp; It looks like our fix is ready to go into production.

### 

### Quick Review

In the original CustomerFinder, this kind of behavioral specification would have been impossible because of the coupling with ASP.NET Cache and LINQ to SQL.&nbsp; By breaking out dependencies, I was able to make changes safely to the existing behavior by creating specifications that could mock and stub out any test doubles.&nbsp; To do so, we:

  * Created a test fixture, naming it after the context of our bug
  * Added specification methods for the behavior we wanted to observe
  * Filled out the context, reason, and verification of the desired behavior

If the dependencies hadn&#8217;t been broken out, I would have been in the &#8220;Edit and Pray&#8221; mode of changing code.&nbsp; This kind of bug only shows up in production, so it could be quite expensive if I had to make a blind change (and I was wrong).&nbsp; Breaking the dependencies out allows me to use Test Doubles in place of the real dependencies, allowing me to tweak the indirect inputs and outputs to my CustomerFinder.

Next time, we&#8217;ll look at how we can better manage the creation and dependency lookup of our CustomerFinder through an Inversion of Control container.