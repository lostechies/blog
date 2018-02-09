---
wordpress_id: 179
title: Enhancing mappers with LINQ
date: 2008-05-08T11:49:53+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/05/08/enhancing-mappers-with-linq.aspx
dsq_thread_id:
  - "264715727"
categories:
  - 'C#'
  - DomainDrivenDesign
  - LINQ
redirect_from: "/blogs/jimmy_bogard/archive/2008/05/08/enhancing-mappers-with-linq.aspx/"
---
The &#8220;big 3&#8221; higher-order functions in functional programming are Filter, Map and Reduce.&nbsp; When looking at the new C# 3.0 LINQ query operators, we find that [all three have equivalents](http://diditwith.net/2007/06/27/AHigherCallingRevisited.aspx):

  * Filter = Where
  * Map = Select
  * Reduce = Aggregate

Whenever you find yourself needing one of these three higher-order functions, just translate them into the correct query operator.&nbsp; &#8220;Select&#8221; doesn&#8217;t have the same dictionary meaning as &#8220;Map&#8221;, but the signature is exactly the same.

The trick to knowing you can use these higher order functions is to look out for situations where you:

  1. Create a new collection
  2. Iterate through some other collection
  3. Add items from the other collection to the new collection

Any time you see this general algorithm, there&#8217;s a much terser syntax available with LINQ.

### 

### Mapper patter example

For example, consider the Mapper pattern:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IMapper</span>&lt;TInput, TOutput&gt;
{
    TOutput Map(TInput input);
}
</pre>

[](http://11011.net/software/vspaste)

A common scenario to map is when I&#8217;m creating DTOs or message objects from Domain objects.&nbsp; Serializing domain objects generally isn&#8217;t a concern of the domain object, as DTOs tend to be flattened out somewhat.&nbsp; I might have the following domain objects:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Customer
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">Guid </span>Id  { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>Name { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}
<span style="color: blue">public class </span><span style="color: #2b91af">SalesOrder
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">Customer </span>Customer { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public decimal </span>Total { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}
</pre>

[](http://11011.net/software/vspaste)

I&#8217;d like to send a Sales Order over the wire for display in some client application.&nbsp; But suppose the Customer object contains dozens of properties, perhaps things like a billing address, a shipping address, and so on.&nbsp; The service I&#8217;m creating only needs a summary of customer information, so I create a SalesOrderSummary message class:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">SalesOrderSummary
</span>{
    <span style="color: blue">public string </span>CustomerName { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">Guid </span>CustomerId { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
    <span style="color: blue">public decimal </span>Total { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }

    <span style="color: green">// For serialization
    </span><span style="color: blue">private </span>SalesOrderSummary() { }

    <span style="color: blue">public </span>SalesOrderSummary(<span style="color: blue">string </span>customerName, <span style="color: #2b91af">Guid </span>customerId, <span style="color: blue">decimal </span>total)
    {
        CustomerName = customerName;
        CustomerId = customerId;
        Total = total;
    }
}</pre>

[](http://11011.net/software/vspaste)

The corresponding mapper would look like:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">SalesOrderSummaryMapper </span>: <span style="color: #2b91af">IMapper</span>&lt;<span style="color: #2b91af">SalesOrder</span>, <span style="color: #2b91af">SalesOrderSummary</span>&gt;
{
    <span style="color: blue">public </span><span style="color: #2b91af">SalesOrderSummary </span>Map(<span style="color: #2b91af">SalesOrder </span>input)
    {
        <span style="color: blue">return new </span><span style="color: #2b91af">SalesOrderSummary</span>(input.Customer.Name, input.Customer.Id, input.Total);
    }
}
</pre>

[](http://11011.net/software/vspaste)

Nothing too exciting so far, right?&nbsp; Well, suppose now I need to return an array of SalesOrderSummary, perhaps for display in a grid.&nbsp; In that case, I&#8217;ll need to build up a list of SalesOrderSummary objects based on a list of SalesOrder objects:

<pre><span style="color: blue">public </span><span style="color: #2b91af">SalesOrderSummary</span>[] FindSalesOrdersByMonth(<span style="color: #2b91af">DateTime </span>date)
{
    <span style="color: green">// get the sales orders from the repository first
    </span><span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">SalesOrder</span>&gt; salesOrders = GetSalesOrders();

    <span style="color: blue">var </span>salesOrderSummaries = <span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">SalesOrderSummary</span>&gt;();
    <span style="color: blue">var </span>mapper = <span style="color: blue">new </span><span style="color: #2b91af">SalesOrderSummaryMapper</span>();

    <span style="color: blue">foreach </span>(<span style="color: blue">var </span>salesOrder <span style="color: blue">in </span>salesOrders)
    {
        salesOrderSummaries.Add(mapper.Map(salesOrder));
    }

    <span style="color: blue">return </span>salesOrderSummaries.ToArray();
}
</pre>

[](http://11011.net/software/vspaste)

This isn&#8217;t too bad, but the creation of a second list just to build up an array seems rather pointless.&nbsp; But by borrowing [some ideas from JP](http://www.jpboodhoo.com/blog/IMapper.aspx), we can make this a lot easier.

### Using LINQ

We can already see the higher order function we need, it&#8217;s in the name of the mapper!&nbsp; Instead of &#8220;Map&#8221;, we&#8217;ll use &#8220;Select&#8221; to do the transforming.&nbsp; But since we have the interface, we can create an extension method to do the Map function:

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">MapperExtensions
</span>{
    <span style="color: blue">public static </span><span style="color: #2b91af">IEnumerable</span>&lt;TOutput&gt; MapAll&lt;TInput, TOutput&gt;(<span style="color: blue">this </span><span style="color: #2b91af">IMapper</span>&lt;TInput, TOutput&gt; mapper, 
        <span style="color: #2b91af">IEnumerable</span>&lt;TInput&gt; input)
    {
        <span style="color: blue">return </span>input.Select(x =&gt; mapper.Map(x));
    }
}
</pre>

[](http://11011.net/software/vspaste)

This new MapAll function is the functional programming Map function, where it takes an input list and returns a new IEnumerable with the mapped values.&nbsp; Internally, the Select LINQ query operator will loop through our input, calling the lambda function we passed in (mapper.Map).&nbsp; This is the exact same operation in our original example, but now our service method now becomes much smaller:

<pre><span style="color: blue">public </span><span style="color: #2b91af">SalesOrderSummary</span>[] FindSalesOrdersByMonth(<span style="color: #2b91af">DateTime </span>date)
{
    <span style="color: green">// get the sales orders from the repository first
    </span><span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">SalesOrder</span>&gt; salesOrders = GetSalesOrders();
    <span style="color: blue">var </span>mapper = <span style="color: blue">new </span><span style="color: #2b91af">SalesOrderSummaryMapper</span>();

    <span style="color: blue">return </span>mapper.MapAll(salesOrders).ToArray();
}
</pre>

[](http://11011.net/software/vspaste)

Much nicer, our service method is reduced to just a handful of lines.&nbsp; The nice thing about this syntax is that it removes all of the unnecessary cruft of a temporary list creation that clouded the intent of this method.

So any time you find yourself creating a temporary list just to build up some filtered, mapped or reduced values, stop yourself.&nbsp; There&#8217;s a higher calling available with functional programming and LINQ.