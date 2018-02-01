---
id: 198
title: 'Separation of Concerns by example: Part 2'
date: 2008-06-24T12:17:22+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/06/24/separation-of-concerns-by-example-part-2.aspx
dsq_thread_id:
  - "264715807"
categories:
  - Refactoring
---
Separation of concerns is one of the fundamental tenets of good object-oriented design.&nbsp; Anyone can throw a bunch of code in a method and call it a day, but that&#8217;s not the most maintainable approach.&nbsp; So far, we&#8217;ve looked at:

  * [Separation of Concerns &#8211; how not to do it](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/06/17/separation-of-concerns-how-not-to-do-it.aspx) 
      * [Separation of Concerns by example: Part 1](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/06/19/separation-of-concerns-by-example-part-1.aspx) &#8211; Refactoring away from static class</ul> 
    In this part, I&#8217;d like to look at removing the dependency on HttpContext.&nbsp; Here&#8217;s what our classes look like thus far:
    
    <pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerManager
</span>{
    [<span style="color: #2b91af">DataObjectMethod</span>(<span style="color: #2b91af">DataObjectMethodType</span>.Select, <span style="color: blue">false</span>)]
    <span style="color: blue">public static </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; GetCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
    {
        <span style="color: blue">var </span>finder = <span style="color: blue">new </span><span style="color: #2b91af">CustomerFinder</span>();
        <span style="color: blue">return new </span><span style="color: #2b91af">CustomerFinder</span>().FindAllCustomers(startRowIndex, maximumRows);
    }
}

<span style="color: blue">public class </span><span style="color: #2b91af">CustomerFinder
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; FindAllCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
    {
        <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; customers = <span style="color: blue">null</span>;
        <span style="color: blue">string </span>key = <span style="color: #a31515">"Customers_Customers_" </span>+ startRowIndex + <span style="color: #a31515">"_" </span>+ maximumRows;

        <span style="color: blue">if </span>(<span style="color: #2b91af">HttpContext</span>.Current.Cache[key] != <span style="color: blue">null</span>)
        {
            customers = (<span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt;) <span style="color: #2b91af">HttpContext</span>.Current.Cache[key];
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
                <span style="color: #2b91af">HttpContext</span>.Current.Cache.Insert(key, customers, <span style="color: blue">null</span>, <span style="color: #2b91af">DateTime</span>.Now.AddDays(1), <span style="color: #2b91af">TimeSpan</span>.Zero);
        }

        <span style="color: blue">return </span>customers;
    }
}
</pre>
    
    [](http://11011.net/software/vspaste)
    
    The CustomerManager class is our presentation-layer service, and is only a very thin wrapper on top of the domain and application services.&nbsp; We want to push the important business logic down into the heart of the domain as much as possible, where it belongs.
    
    The goal is to write a single passing test for the CustomerFinder class.&nbsp; Right now, that isn&#8217;t possible because of the dependencies on HttpContext and DataGateway.
    
    For now, the immediate concern has to be HttpContext.&nbsp; Having a dependency directly on Linq to SQL is bad, but at least the test can run without it.&nbsp; It&#8217;s not so simple to remove the HttpContext dependency, as we have quite a few choices on how to do so.
    
    ### Designing the dependency
    
    We know we&#8217;re going to use constructor injection for this dependency.&nbsp; What that means is that we&#8217;ll use an interface to act as a facade, and the CustomerFinder will use that interface to do its work.
    
    Under test, we&#8217;ll pass a fake instance to test the indirect inputs and outputs to the test, while at runtime, the &#8220;real&#8221; instance will be used.
    
    So the basic idea will be to hide the caching part behind an interface.&nbsp; But what should we hide?&nbsp; We have three options:
    
      * Create an IHttpContext interface to hide HttpContext.Current 
          * Create an ICache interface to hide the HttpContext.Current.Cache property 
              * Create a specialized interface to hide the entire cache calls</ul> 
            #### Abstracting HttpContext.Current
            
            This is a huge rabbit hole we don&#8217;t want to go down.&nbsp; HttpContext is a very large class with a ton of methods and properties.&nbsp; We could create an IHttpContext interface that only has one property for Cache, but that has its own issues, too.
            
            The Cache class is sealed, meaning we can&#8217;t subclass it to create a fake instance.&nbsp; So we&#8217;d have to create an ICache implementation anyway to get around this limitation.&nbsp; And at this point, what is IHttpContext giving us other than a window to the Cache?&nbsp; Nothing.
            
            Some MVC frameworks opt to hide the entire HttpContext behind an interface or an abstract class.&nbsp; These still violate the Interface Segregation Principle, as implementers of the interface have to provide implementations of Request, Response, Session, Cookies, etc etc.
            
            This isn&#8217;t a good choice, but what about a targeted Cache implementation?
            
            #### Abstracting Cache
            
            This looks like a better choice, as the Cache class is much smaller and lighter and HttpContext.&nbsp; However, it still suffers from similar problems as the IHttpContext, where implementers have to know a great deal about hows and whys of Cache to get it to work properly.
            
            One other issue an ICache implementation won&#8217;t solve is the non-intention-revealing interface the Cache.Insert method contains. It&#8217;s difficult to read the code inside CustomerFinder to see what the caching strategy is.
            
            With that strategy out, we&#8217;re down to our final option.
            
            #### Specialized interface
            
            Specialized interface entails creating an interface that only hides what we use, and providing use-specific names for the methods.&nbsp; Instead of Cache.Insert, we might have Cache.InsertItemExpiringTomorrow.&nbsp; It&#8217;s a much more explicit interface, describing the intent of what our caching logic is doing.
            
            ### Creating the specialized interface
            
            As always, we&#8217;ll first want to extract our methods out of the CustomerFinder class, providing good names for each of the methods.&nbsp; We&#8217;ll need to extract both the section that peeks inside Cache, retrieves an item from Cache, and inserts an item.&nbsp; Along the way, we want to make sure we use the same names as what our interface will provide, which will save a rename step later.
            
            After the [Extract Method](http://www.refactoring.com/catalog/extractMethod.html) refactorings, our class now looks like this:
            
            <pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerFinder
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; FindAllCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
    {
        <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; customers = <span style="color: blue">null</span>;
        <span style="color: blue">string </span>key = <span style="color: #a31515">"Customers_Customers_" </span>+ startRowIndex + <span style="color: #a31515">"_" </span>+ maximumRows;

        <span style="color: blue">if </span>(Contains(key))
        {
            customers = GetItem(key);
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
                AddItemExpringTomorrow(key, customers);
        }

        <span style="color: blue">return </span>customers;
    }

    <span style="color: blue">private void </span>AddItemExpringTomorrow(<span style="color: blue">string </span>key, <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; customers)
    {
        <span style="color: #2b91af">HttpContext</span>.Current.Cache.Insert(key, customers, <span style="color: blue">null</span>, <span style="color: #2b91af">DateTime</span>.Now.AddDays(1), <span style="color: #2b91af">TimeSpan</span>.Zero);
    }

    <span style="color: blue">private </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; GetItem(<span style="color: blue">string </span>key)
    {
        <span style="color: blue">return </span>(<span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt;) <span style="color: #2b91af">HttpContext</span>.Current.Cache[key];
    }

    <span style="color: blue">private bool </span>Contains(<span style="color: blue">string </span>key)
    {
        <span style="color: blue">return </span><span style="color: #2b91af">HttpContext</span>.Current.Cache[key] != <span style="color: blue">null</span>;
    }
}
</pre>
            
            [](http://11011.net/software/vspaste)
            
            But this isn&#8217;t quite right, is it?&nbsp; We have some problems already:
            
              * The Insert and Get methods are coupled to the List<Customer> type.&nbsp; We&#8217;re not making an ICustomersCache, so generics will help here.
            
            After fixing the changes above, our extracted methods now look like this:
            
            <pre><span style="color: blue">private void </span>AddItemExpringTomorrow&lt;T&gt;(<span style="color: blue">string </span>key, T item)
{
    <span style="color: #2b91af">HttpContext</span>.Current.Cache.Insert(key, item, <span style="color: blue">null</span>, <span style="color: #2b91af">DateTime</span>.Now.AddDays(1), <span style="color: #2b91af">TimeSpan</span>.Zero);
}

<span style="color: blue">private </span>T GetItem&lt;T&gt;(<span style="color: blue">string </span>key)
{
    <span style="color: blue">return </span>(T) <span style="color: #2b91af">HttpContext</span>.Current.Cache[key];
}

<span style="color: blue">private bool </span>Contains(<span style="color: blue">string </span>key)
{
    <span style="color: blue">return </span><span style="color: #2b91af">HttpContext</span>.Current.Cache[key] != <span style="color: blue">null</span>;
}
</pre>
            
            [](http://11011.net/software/vspaste)
            
            That&#8217;s much better.&nbsp; Now that we have a group of methods with our Cache logic we need, we can perform [Extract Class](http://www.refactoring.com/catalog/extractClass.html) to create our specialized Cache implementation.&nbsp; All we&#8217;ll need to do is create a CustomCache class and move these methods to that class:
            
            <pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomCache
</span>{
    <span style="color: blue">public void </span>AddItemExpringTomorrow&lt;T&gt;(<span style="color: blue">string </span>key, T item)
    {
        <span style="color: #2b91af">HttpContext</span>.Current.Cache.Insert(key, item, <span style="color: blue">null</span>, <span style="color: #2b91af">DateTime</span>.Now.AddDays(1), <span style="color: #2b91af">TimeSpan</span>.Zero);
    }

    <span style="color: blue">public </span>T GetItem&lt;T&gt;(<span style="color: blue">string </span>key)
    {
        <span style="color: blue">return </span>(T)<span style="color: #2b91af">HttpContext</span>.Current.Cache[key];
    }

    <span style="color: blue">public bool </span>Contains(<span style="color: blue">string </span>key)
    {
        <span style="color: blue">return </span><span style="color: #2b91af">HttpContext</span>.Current.Cache[key] != <span style="color: blue">null</span>;
    }
}
</pre>
            
            [](http://11011.net/software/vspaste)
            
            Our CustomerFinder class isn&#8217;t compiling, but we have one more step for the CustomCache class before it&#8217;s ready for prime time.&nbsp; We need to [Extract Interface](http://www.refactoring.com/catalog/extractInterface.html) so that our CustomerFinder implementation has something less concrete to work with.&nbsp; ReSharper lets us extract the interface easily, which leaves us with our final CustomCache implementation:
            
            <pre><span style="color: blue">public interface </span><span style="color: #2b91af">ICustomCache
</span>{
    <span style="color: blue">void </span>AddItemExpringTomorrow&lt;T&gt;(<span style="color: blue">string </span>key, T item);
    T GetItem&lt;T&gt;(<span style="color: blue">string </span>key);
    <span style="color: blue">bool </span>Contains(<span style="color: blue">string </span>key);
}

<span style="color: blue">public class </span><span style="color: #2b91af">CustomCache </span>: <span style="color: #2b91af">ICustomCache
</span>{
    <span style="color: blue">public void </span>AddItemExpringTomorrow&lt;T&gt;(<span style="color: blue">string </span>key, T item)
    {
        <span style="color: #2b91af">HttpContext</span>.Current.Cache.Insert(key, item, <span style="color: blue">null</span>, <span style="color: #2b91af">DateTime</span>.Now.AddDays(1), <span style="color: #2b91af">TimeSpan</span>.Zero);
    }

    <span style="color: blue">public </span>T GetItem&lt;T&gt;(<span style="color: blue">string </span>key)
    {
        <span style="color: blue">return </span>(T)<span style="color: #2b91af">HttpContext</span>.Current.Cache[key];
    }

    <span style="color: blue">public bool </span>Contains(<span style="color: blue">string </span>key)
    {
        <span style="color: blue">return </span><span style="color: #2b91af">HttpContext</span>.Current.Cache[key] != <span style="color: blue">null</span>;
    }
}
</pre>
            
            [](http://11011.net/software/vspaste)
            
            Now the ICustomCache is something that the CustomerFinder can deal with.&nbsp; Since we&#8217;re using constructor injection, we&#8217;ll want to create a constructor that takes an ICustomCache implementation.&nbsp; Our CustomerFinder will now look like:
            
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
            
            Our CustomerFinder now has no opaque dependency on the Cache or HttpContext classes.&nbsp; We only deal with our wrapper, which has more explicit names about what we&#8217;re trying to do.
            
            But now our CustomerManager class isn&#8217;t compiling, as we removed the no-argument constructor for CustomerFinder.&nbsp; In this case, I&#8217;ll just allow the CustomerManager to instantiate the correct implementations of ICustomCache:
            
            <pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerManager
</span>{
    [<span style="color: #2b91af">DataObjectMethod</span>(<span style="color: #2b91af">DataObjectMethodType</span>.Select, <span style="color: blue">false</span>)]
    <span style="color: blue">public static </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; GetCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
    {
        <span style="color: blue">var </span>finder = <span style="color: blue">new </span><span style="color: #2b91af">CustomerFinder</span>(<span style="color: blue">new </span><span style="color: #2b91af">CustomCache</span>());
        <span style="color: blue">return </span>finder.FindAllCustomers(startRowIndex, maximumRows);
    }
}
</pre>
            
            [](http://11011.net/software/vspaste)
            
            We could have gone several ways on that one, from a creation method, to a factory, all the way to an IoC container like Spring or StructureMap.&nbsp; We&#8217;ll wait on any changes like that.
            
            ### Quick review
            
            Our CustomerFinder class had an opaque dependency on HttpContext.Current and Cache.&nbsp; We looked at a few options at making that dependency explicit through constructor injection, settling on a specialized implementation that contained intention-revealing names for only the operations we support.&nbsp; To do so, we performed a number of refactorings:
            
              * [Extract Method](http://www.refactoring.com/catalog/extractMethod.html) 
                  * [Extract Class](http://www.refactoring.com/catalog/extractClass.html) 
                      * [Extract Interface](http://www.refactoring.com/catalog/extractInterface.html)</ul> 
                    Finally, we fixed the CustomerManager class to use our new constructor with the appropriate dependency.&nbsp; The maintainability of the CustomerFinder class has improved significantly, as well as usability, as both users and maintainers of this class can see immediately the explicit dependencies this class requires.
                    
                    Next time, we&#8217;ll look at getting rid of that pesky Linq to SQL dependency.