---
wordpress_id: 201
title: 'Separation of Concerns by example: Part 3'
date: 2008-06-27T03:14:16+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/06/26/separation-of-concerns-by-example-part-3.aspx
dsq_thread_id:
  - "264715808"
categories:
  - LINQ2SQL
  - Patterns
  - Refactoring
redirect_from: "/blogs/jimmy_bogard/archive/2008/06/26/separation-of-concerns-by-example-part-3.aspx/"
---
We made quite a bit of progress separating out the concerns in Part 2, but there are still some issues with our current design.&nbsp; Other parts in this series include:

  * [Separation of Concerns &#8211; how not to do it](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/06/17/separation-of-concerns-how-not-to-do-it.aspx)
  * [Separation of Concerns by example: Part 1](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/06/19/separation-of-concerns-by-example-part-1.aspx) &#8211; Refactoring away from static class
  * [Separation of Concerns by example: Part 2](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/06/24/separation-of-concerns-by-example-part-2.aspx) &#8211; Specialized interface for Cache

To review, here&#8217;s our CustomerFinder so far, after refactoring away from the static class and creating the specialized ICustomCache interface:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerFinder
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICustomCache </span>_customCache;

    <span style="color: blue">public </span>CustomerFinder(<span style="color: #2b91af">ICustomCache </span>customCache)
    {
        _customCache = customCache;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; FindAllCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
    {
        <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; customers = <span style="color: blue">null</span>;
        <span style="color: blue">string </span>key = <span style="color: #a31515">"Customers_Customers_" </span>+ startRowIndex + <span style="color: #a31515">"_" </span>+ maximumRows;

        <span style="color: blue">if </span>(_customCache.Contains(key))
        {
            customers = _customCache.GetItem&lt;<span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt;&gt;(key);
        }
        <span style="color: blue">else
        </span>{
            customers =
                (
                    <span style="color: blue">from
                        </span>c <span style="color: blue">in </span><span style="color: #2b91af">DataGateway</span>.Context.Customers
                    <span style="color: blue">orderby
                        </span>c.CustomerID <span style="color: blue">descending
                    select
                        </span>c
                ).Skip(startRowIndex).Take(maximumRows).ToList();

            <span style="color: blue">if </span>((customers != <span style="color: blue">null</span>) && (customers.Count &gt; 0))
                _customCache.AddItemExpringTomorrow(key, customers);
        }

        <span style="color: blue">return </span>customers;
    }

}
</pre>

[](http://11011.net/software/vspaste)

Although we refactored away from the HttpContext.Current.Cache dependency, we still have one nagging issue: the DataGateway.Context dependency.&nbsp; The DataGateway.Context class is just a wrapper around LINQ to SQL:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DataGateway
</span>{
    <span style="color: blue">public static </span><span style="color: #2b91af">NorthwindDataContext </span>Context
    {
        <span style="color: blue">get
        </span>{
            <span style="color: blue">return new </span><span style="color: #2b91af">NorthwindDataContext</span>(<span style="color: #a31515">""</span>);
        }
    }
}
</pre>

[](http://11011.net/software/vspaste)

If we created a unit test against CustomerFinder as-is, it would run, but only if I had access to the database.&nbsp; Since the unit test calls out-of-process, it&#8217;s no longer a unit test.&nbsp; It&#8217;s just a regular automated test, running in a unit test framework.

Our goal is not only to increase testability, but readability and usability as well.&nbsp; Encapsulation is great for information hiding, but not dependency hiding.&nbsp; We&#8217;d like to be as explicit as possible, telling users of the CustomerFinder exactly what is needed to get it to work properly.&nbsp; We want to develop not only for users of the application, but future maintainers of the system as well.

We have quite a few options to extract the DataGateway dependency, each of which has its benefits and issues.

### Designing the dependency

This dependency looks like a plain static dependency at first, but on closer inspection, it looks like our other HttpContext.Current.Cache dependency, where we&#8217;re poking deep inside a static property to get the &#8220;real&#8221; dependency, the Customers property.

Given the same arguments as the previous part in this series, it looks like we&#8217;ll choose &#8220;create a specialized interface&#8221;.&nbsp; But what should the interface look like?&nbsp; What should its responsibilities be?

One really interesting thing to look at is paging.&nbsp; Should our extracted dependency be responsible for paging, or should it just return everything?&nbsp; What should the return type be, still List<T>?&nbsp; We could make our Application layer responsible for paging, and the Data Access layer be paging-ignorant.&nbsp; After all, paging is dependent on who is looking at the data, some parts of the application might care less about it.&nbsp; Paging is something that matters strictly to the user interface.

However, we don&#8217;t want to sacrifice performance at the sake of our lofty goals.&nbsp; What if there are something like 100K products, or a million?&nbsp; That can be a typical number on some established systems.&nbsp; We don&#8217;t want to pull back a million records if only ten are going to be displayed.

To balance these concerns, we&#8217;ll need to take a closer look on the existing behavior to determine the right way to go.

### A peek behind the curtains

First, I&#8217;d like to examine what happens in the existing system.&nbsp; To do so, I created a simple test:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Check_out_the_profiling()
{
    <span style="color: blue">var </span>finder = <span style="color: blue">new </span><span style="color: #2b91af">CustomerFinder</span>(<span style="color: blue">new </span><span style="color: #2b91af">FakeCache</span>());
    <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; customers = finder.FindAllCustomers(1, 10);
    customers.Count.ShouldBeGreaterThan(0);
}

<span style="color: blue">private class </span><span style="color: #2b91af">FakeCache </span>: <span style="color: #2b91af">ICustomCache
</span>{
    <span style="color: blue">public void </span>AddItemExpringTomorrow&lt;T&gt;(<span style="color: blue">string </span>key, T item)
    {
        
    }

    <span style="color: blue">public bool </span>Contains(<span style="color: blue">string </span>key)
    {
        <span style="color: blue">return false</span>;
    }

    <span style="color: blue">public </span>T GetItem&lt;T&gt;(<span style="color: blue">string </span>key)
    {
        <span style="color: blue">return default</span>(T);
    }
}
</pre>

[](http://11011.net/software/vspaste)

I just used a fake cache, that&#8217;s always empty to force the CustomerFinder to go against the DataContext.&nbsp; I purposefully get back the second page (it&#8217;s zero-based indexed), to see if the Skip and Take are smart enough in LINQ to SQL.&nbsp; Here&#8217;s what came back from the profiler:

<pre>exec sp_executesql N'SELECT [t1].[CustomerID], [t1].[CompanyName], [t1].[ContactName], [t1].[ContactTitle], [t1].[Address], [t1].[City], [t1].[Region], [t1].[PostalCode], [t1].[Country], [t1].[Phone], [t1].[Fax]
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY [t0].[CustomerID] DESC) AS [ROW_NUMBER], [t0].[CustomerID], [t0].[CompanyName], [t0].[ContactName], [t0].[ContactTitle], [t0].[Address], [t0].[City], [t0].[Region], [t0].[PostalCode], [t0].[Country], [t0].[Phone], [t0].[Fax]
    FROM [dbo].[Customers] AS [t0]
    ) AS [t1]
WHERE [t1].[ROW_NUMBER] BETWEEN @p0 + 1 AND @p0 + @p1
ORDER BY [t1].[ROW_NUMBER]',N'@p0 int,@p1 int',@p0=1,@p1=10</pre>

[](http://11011.net/software/vspaste)

Now this is VERY interesting.&nbsp; LINQ to SQL is smart enough to turn the Skip and Take into actual server-side paging.&nbsp; Looking at the query, I wouldn&#8217;t really want to write this query, but it works very well.&nbsp; Which reminds me:

**Stop writing custom data access code.&nbsp; This is a problem that has been solved.**

I&#8217;ve had to write custom dynamic paging logic, and it was not fun.&nbsp; Paging gets very, very complicated when doing sub queries, arbitrary sorting, filtering and grouping.

Anyway, it looks like paging works well on the database side, so we&#8217;d like to preserve that behavior.&nbsp; But we&#8217;d also like the paging logic to be where we want, in the Application Layer.&nbsp; One feature of LINQ will help us out on this side &#8211; deferred execution.&nbsp; Remember, the SQL isn&#8217;t actually executed until you iterate over the results, which happens with the .ToList() method call.&nbsp; It will also happen in a foreach loop or the ToArray() method call.

So it looks like we&#8217;ll be able to have the best of both worlds.

### Extracting our dependency

Although it was a long discussion, this is something that usually happens in our teams pretty regularly.&nbsp; After extracting lots of dependencies, or doing TDD for some time, you start to get a good feel for how the behavior should be laid out.

First, we&#8217;ll need to Extract Method on the LINQ query part, except for the paging and ToList() part:

<pre><span style="color: blue">public </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; FindAllCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
{
    <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; customers = <span style="color: blue">null</span>;
    <span style="color: blue">string </span>key = <span style="color: #a31515">"Customers_Customers_" </span>+ startRowIndex + <span style="color: #a31515">"_" </span>+ maximumRows;

    <span style="color: blue">if </span>(_customCache.Contains(key))
    {
        customers = _customCache.GetItem&lt;<span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt;&gt;(key);
    }
    <span style="color: blue">else
    </span>{
        customers =
            FindAllCustomers()
                .Skip(startRowIndex)
                .Take(maximumRows)
                .ToList();

        <span style="color: blue">if </span>((customers != <span style="color: blue">null</span>) && (customers.Count &gt; 0))
            _customCache.AddItemExpringTomorrow(key, customers);
    }

    <span style="color: blue">return </span>customers;
}

<span style="color: blue">private </span><span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">Customer</span>&gt; FindAllCustomers()
{
    <span style="color: blue">return from
               </span>c <span style="color: blue">in </span><span style="color: #2b91af">DataGateway</span>.Context.Customers
           <span style="color: blue">orderby
               </span>c.CustomerID <span style="color: blue">descending
           select
               </span>c;
}
</pre>

[](http://11011.net/software/vspaste)

Our extracted method only returns IEnumerable<T>, and not List<T>.&nbsp; Returning List<T> before paging means we&#8217;d lose the server-side paging goodness that LINQ to SQL provides.

Another benefit to returning IEnumerable<T> is that it better communicates the intent of our code: **we&#8217;re giving you a read-only collection of customers, don&#8217;t even try to change it**.

Next, we&#8217;ll perform Extract Class on the FindAllCustomers method we just extracted to a new class, a CustomerRepository class.&nbsp; Why the [Repository](http://martinfowler.com/eaaCatalog/repository.html) name?&nbsp; It comes from Martin Fowler&#8217;s excellent [Patterns of Enterprise Application Architecture](http://www.amazon.com/Enterprise-Application-Architecture-Addison-Wesley-Signature/dp/0321127420) book.&nbsp; Here&#8217;s the new CustomerRepository class:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerRepository
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">Customer</span>&gt; FindAllCustomers()
    {
        <span style="color: blue">return from
                   </span>c <span style="color: blue">in </span><span style="color: #2b91af">DataGateway</span>.Context.Customers
               <span style="color: blue">orderby
                   </span>c.CustomerID <span style="color: blue">descending
               select
                   </span>c;
    }
}
</pre>

[](http://11011.net/software/vspaste)

For those that read part 2, our next steps should seem familiar.&nbsp; We&#8217;ll now use Extract Interface, so that our CustomerFinder class only deals with the interface and not the concrete class.&nbsp; This will allow us to swap out implementations for testing or debugging purposes.&nbsp; Our new interface will be ICustomerRepository:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">ICustomerRepository
</span>{
    <span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">Customer</span>&gt; FindAllCustomers();
}
</pre>

[](http://11011.net/software/vspaste)

Of course, our CustomerFinder class no longer compiles, so we&#8217;ll change the class to get the ICustomerRepository from the constructor through Constructor Injection.&nbsp; The FindAllCustomers method that uses paging will use this instance instead:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerFinder
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICustomerRepository </span>_customerRepository;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICustomCache </span>_customCache;

    <span style="color: blue">public </span>CustomerFinder(<span style="color: #2b91af">ICustomerRepository </span>customerRepository, <span style="color: #2b91af">ICustomCache </span>customCache)
    {
        _customerRepository = customerRepository;
        _customCache = customCache;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; FindAllCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
    {
        <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; customers = <span style="color: blue">null</span>;
        <span style="color: blue">string </span>key = <span style="color: #a31515">"Customers_Customers_" </span>+ startRowIndex + <span style="color: #a31515">"_" </span>+ maximumRows;

        <span style="color: blue">if </span>(_customCache.Contains(key))
        {
            customers = _customCache.GetItem&lt;<span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt;&gt;(key);
        }
        <span style="color: blue">else
        </span>{
            customers =_customerRepository
                        .FindAllCustomers()
                        .Skip(startRowIndex)
                        .Take(maximumRows)
                        .ToList();

            <span style="color: blue">if </span>((customers != <span style="color: blue">null</span>) && (customers.Count &gt; 0))
                _customCache.AddItemExpringTomorrow(key, customers);
        }

        <span style="color: blue">return </span>customers;
    }

}
</pre>

[](http://11011.net/software/vspaste)

One annoying thing left is that the return value of the FindAllCustomers betrays its intent: a read-only view of a single page of customers.&nbsp; It makes zero sense that a user of this class will add new customers to a single page of customers.&nbsp; We want to be as explicit as possible in our interface, so I&#8217;m going to change the return type to an array instead of a List<T>:

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

This a much clearer interface to those using the CustomerFinder, as they know exactly what the class depends on, and the Customer[] array indicates that we&#8217;re looking for a read-only, immutable collection of Customers.

Of course, our original CustomerManager class no longer compiles, so we&#8217;ll need to fix the method by changing the return type and fixing the constructor call:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerManager
</span>{
    [<span style="color: #2b91af">DataObjectMethod</span>(<span style="color: #2b91af">DataObjectMethodType</span>.Select, <span style="color: blue">false</span>)]
    <span style="color: blue">public static </span><span style="color: #2b91af">Customer</span>[] GetCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
    {
        <span style="color: blue">var </span>finder = <span style="color: blue">new </span><span style="color: #2b91af">CustomerFinder</span>(<span style="color: blue">new </span><span style="color: #2b91af">CustomerRepository</span>(), <span style="color: blue">new </span><span style="color: #2b91af">CustomCache</span>());
        <span style="color: blue">return </span>finder.FindAllCustomers(startRowIndex, maximumRows);
    }
}
</pre>

[](http://11011.net/software/vspaste)

Our ASP.NET page, with its data source control, does not need to change.&nbsp; It works just as well with arrays as it does with List<T>.&nbsp; Executing our original profile test with the new CustomerRepository and checking the profiler confirms that&#8230;oh wait, server-side paging is broken.&nbsp; Here&#8217;s what the profiler says:

<pre>SELECT [t0].[CustomerID], [t0].[CompanyName], [t0].[ContactName], [t0].[ContactTitle], [t0].[Address], [t0].[City], [t0].[Region], [t0].[PostalCode], [t0].[Country], [t0].[Phone], [t0].[Fax]
FROM [dbo].[Customers] AS [t0]
ORDER BY [t0].[CustomerID] DESC</pre>

[](http://11011.net/software/vspaste)

So what happened?&nbsp; I&#8217;m still doing deferred query execution, but now it&#8217;s forgotten how to do server side paging?&nbsp; The culprit lies in our return type in ICustomerRepository.&nbsp; The LINQ query actually returns IOrderedQueryable<T>, which ReSharper originally did for me before I changed it.&nbsp; Bad me.

So, I&#8217;ll change ICustomerRepository.FindAllCustomers to return the IOrderedQueryable interface instead of IEnumerable:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">ICustomerRepository
</span>{
    <span style="color: #2b91af">IOrderedQueryable</span>&lt;<span style="color: #2b91af">Customer</span>&gt; FindAllCustomers();
}

<span style="color: blue">public class </span><span style="color: #2b91af">CustomerRepository </span>: <span style="color: #2b91af">ICustomerRepository
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">IOrderedQueryable</span>&lt;<span style="color: #2b91af">Customer</span>&gt; FindAllCustomers()
    {
        <span style="color: blue">return from
                   </span>c <span style="color: blue">in </span><span style="color: #2b91af">DataGateway</span>.Context.Customers
               <span style="color: blue">orderby
                   </span>c.CustomerID <span style="color: blue">descending
               select
                   </span>c;
    }
}
</pre>

[](http://11011.net/software/vspaste)

The LINQ query doesn&#8217;t change, but my profiling confirms that the changes worked.&nbsp; So was this a good change?&nbsp; **Yes**.&nbsp; In fact, I&#8217;d argue that the IOrderedQueryable _better_ expresses the intent of what we&#8217;re returning.&nbsp; In effect, we&#8217;re telling users of the ICustomerRepository that we&#8217;re returning a smart collection, that you can do paging and all sorts of things on it in an efficient manner.

And that&#8217;s what we&#8217;re really trying to do here, communicate the intent of our classes and interfaces to the users of these, without forcing them to look at the code in the class.&nbsp; If another developer understands intent based solely on the names and signatures of our methods and types, we&#8217;ve done our job.

### Quick review

To get rid of our dependency on the static DataContext class, we performed similar refactorings as we did in part 2:

  * Extract Method
  * Extract Class
  * Extract Interface

We picked another specialized interface, ICustomerRepository, to house our data access code, borrowing the name from the pattern in Fowler&#8217;s book.&nbsp; We also saw that LINQ to SQL requires IOrderedQueryable to effectively take advantage of server-side paging.&nbsp; In doing so, we created a very explicit interface, describing exactly what we intend to support (and nothing more).

Our CustomerFinder no longer contains any opaque dependencies.&nbsp; Which is good, because in the next part, we&#8217;ll see how dependency inversion saves the day when a bug report comes in and we need to add some unit tests to ensure our bug doesn&#8217;t get un-fixed.