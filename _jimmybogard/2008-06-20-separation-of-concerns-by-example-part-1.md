---
wordpress_id: 197
title: 'Separation of Concerns by example: Part 1'
date: 2008-06-20T02:12:08+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/06/19/separation-of-concerns-by-example-part-1.aspx
dsq_thread_id:
  - "264715788"
categories:
  - Refactoring
redirect_from: "/blogs/jimmy_bogard/archive/2008/06/19/separation-of-concerns-by-example-part-1.aspx/"
---
In the prelude to this series, I looked at a snippet of code that took the kitchen sink approach to concerns.&nbsp; Here&#8217;s what we started out with:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerManager
</span>{
    [<span style="color: #2b91af">DataObjectMethod</span>(<span style="color: #2b91af">DataObjectMethodType</span>.Select, <span style="color: blue">false</span>)]
    <span style="color: blue">public static </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; GetCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
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

Before we can even think about separating the concerns out, we already have the design working against us.&nbsp; I prefer a dependency inversion approach to separate concerns, as opposed to having the class or method instantiate them all at once.

When we have a static method, how can we give the dependencies to the class?&nbsp; I can think of some clever ways, but clever is rarely simple.&nbsp; I&#8217;d like to err on the side of simple.

Additionally, we don&#8217;t want our domain services mixed in with presentation concerns, such as the DataObjectMethod attribute.&nbsp; That is in place for the ObjectDataSource control, a presentation object.

So, first order of business, let&#8217;s make this a plain old class, instead of a static class.

### Refactoring away from static methods

Now, presentation-specific classes are just fine.&nbsp; If our presentation layer needs static methods and some crazy attributes, good for them.

But I don&#8217;t want those concerns bleeding down into my <strike>BLL</strike> domain layer.

To fix this, first we&#8217;ll need to extract method and get all of the contents out of that method ([Ctrl+Alt+M](http://www.jetbrains.com/resharper/) ftw):

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerManager
</span>{
    [<span style="color: #2b91af">DataObjectMethod</span>(<span style="color: #2b91af">DataObjectMethodType</span>.Select, <span style="color: blue">false</span>)]
    <span style="color: blue">public static </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; GetCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
    {
        <span style="color: blue">return </span>FindAllCustomers(startRowIndex, maximumRows);
    }

    <span style="color: blue">private static </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; FindAllCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
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

Now that we have a private method, we can use Move Method to move this method to a whole new class.&nbsp; If this method used any other private (or public) methods, we&#8217;d have to deal with them one at a time.&nbsp; For now, we&#8217;ll have a new CustomerFinder application-level service class:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerFinder
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

Now, we don&#8217;t have any tests in place (this is a full-blown legacy app), so we&#8217;re just focusing on dependency-breaking techniques.&nbsp; These techniques preserve existing behavior, which is what we need when we don&#8217;t have a safety net of unit tests in place.

The existing CustomerManager now needs to change, as it needs to use our new class.&nbsp; No matter, we&#8217;ll just instantiate a new CustomerFinder and use that:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerManager
</span>{
    [<span style="color: #2b91af">DataObjectMethod</span>(<span style="color: #2b91af">DataObjectMethodType</span>.Select, <span style="color: blue">false</span>)]
    <span style="color: blue">public static </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; GetCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
    {
        <span style="color: blue">return new </span><span style="color: #2b91af">CustomerFinder</span>().FindAllCustomers(startRowIndex, maximumRows);
    }
}
</pre>

[](http://11011.net/software/vspaste)

Now our presentation layer is just a very thin layer on top of our application and domain layer.&nbsp; Which is good, as the presentation layer is the hardest layer to test (and the absolute slooooooowest).

### Quick review

We want to change the CustomerManager, but it&#8217;s a presentation layer class that we still need to service our user interface.&nbsp; To get around this, we applied a series of refactorings to move the behavior to an application layer service, which we can now work against for future enhancements.&nbsp; These refactorings included:

  * [Extract Method](http://www.refactoring.com/catalog/extractMethod.html)
  * [Move Method](http://www.refactoring.com/catalog/moveMethod.html)

We did these in a way such the existing behavior of CustomerManager remained unchanged, but its responsibilities were moved to the CustomerFinder service.

Next time, we&#8217;ll look at the CustomerFinder to see how we can remove some of the static dependencies (I think I saw a [screencast somewhere](https://lostechies.com/blogs/jimmy_bogard/archive/2008/05/06/pablotv-eliminating-static-dependencies-screencast.aspx) on that one&#8230;)