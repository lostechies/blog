---
id: 180
title: 'LINQ query operators: lose that foreach already!'
date: 2008-05-09T22:11:31+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/05/09/linq-query-operators-lose-that-foreach-already.aspx
dsq_thread_id:
  - "264715668"
categories:
  - 'C#'
  - LINQ
---
Now that .NET 3.5 is out with all its LINQ query operator goodness, I feel like going on a mean streak of trashing a lot of our (now) pointless foreach loops.&nbsp; Some example operations include:

  * Transformations
  * Aggregations
  * Concatenations
  * Filtering

As I mentioned in [my last post](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/05/08/enhancing-mappers-with-linq.aspx), temporary list creation is a great pointer to find opportunities for losing the foreach statements.&nbsp; I keep the foreach statement when the readability and understandability of the code drops with the LINQ change, but otherwise, a lot less temporary objects are floating around.&nbsp; Personally, the jury is still out for me whether it&#8217;s clearer to return &#8220;IEnumerable<LineItem>&#8221; over &#8220;LineItem[]&#8221;, but the temporary array creation doesn&#8217;t seem to have much of a point.

### Transformations

Transformations are easy to spot. You&#8217;ll create a new List<Something>, then loop through some other List<OtherThing> and create a Something from the OtherThing:

<pre><span style="color: blue">public </span><span style="color: #2b91af">OrderSummary</span>[] FindOrdersFor(<span style="color: blue">int </span>customerId)
{
    <span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">Order</span>&gt; orders = GetOrdersForCustomer(customerId);
    <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">OrderSummary</span>&gt; orderSummaries = <span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">OrderSummary</span>&gt;();

    <span style="color: blue">foreach </span>(<span style="color: #2b91af">Order </span>order <span style="color: blue">in </span>orders)
    {
        orderSummaries.Add(<span style="color: blue">new </span><span style="color: #2b91af">OrderSummary
                            </span>{
                                CustomerName = order.Customer.Name,
                                DateSubmitted = order.DateSubmitted,
                                OrderTotal = order.GetTotal()
                            });
    }

    <span style="color: blue">return </span>orderSummaries.ToArray();
}
</pre>

[](http://11011.net/software/vspaste)

Note the temporary list creation, just to return an array.&nbsp; With LINQ query operators, I can use the Select method to do the same transformation in less code:

<pre><span style="color: blue">public </span><span style="color: #2b91af">OrderSummary</span>[] FindOrdersFor(<span style="color: blue">int </span>customerId)
{
    <span style="color: blue">return </span>GetOrdersForCustomer(customerId)
        .Select(order =&gt; <span style="color: blue">new </span><span style="color: #2b91af">OrderSummary
                             </span>{
                                 CustomerName = order.Customer.Name,
                                 DateSubmitted = order.DateSubmitted,
                                 OrderTotal = order.GetTotal()
                             })
        .ToArray();
}
</pre>

[](http://11011.net/software/vspaste)

By chaining the methods together, it comes out much more readable.

### Aggregations

Aggregations can be found when you&#8217;re looping through some list for some kind of calculation.&nbsp; For example, the GetTotal method on Order loops to build up the total based on each item&#8217;s ItemPrice:

<pre><span style="color: blue">public decimal </span>GetTotal()
{
    <span style="color: blue">decimal </span>total = 0.0m;

    <span style="color: blue">foreach </span>(<span style="color: #2b91af">LineItem </span>lineItem <span style="color: blue">in </span>GetLineItems())
    {
        total += lineItem.ItemPrice;
    }

    <span style="color: blue">return </span>total;
}
</pre>

[](http://11011.net/software/vspaste)

Again, this can be greatly reduced using LINQ query operators and the Sum method:

<pre><span style="color: blue">public decimal </span>GetTotal()
{
    <span style="color: blue">return </span>GetLineItems()
        .Sum(item =&gt; item.ItemPrice);
}
</pre>

[](http://11011.net/software/vspaste)

Not only is the code much smaller, but the intent is much easier to discern.&nbsp; Sometimes a calculation can be tricky, and in those cases LINQ isn&#8217;t bringing anything to the table.&nbsp; As always, use good judgement and keep an eye on readability.

### Concatenations

Oftentimes I need to combine many lists into one flattened list.&nbsp; For example, suppose I need a list of OrderLineItem summary items, perhaps to display on a grid to the end user.&nbsp; However, I want to display all order line items for all orders, which is difficult to build up manually:

<pre><span style="color: blue">public </span><span style="color: #2b91af">LineItemSummary</span>[] FindLineItemsFor(<span style="color: blue">int </span>customerId)
{
    <span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">Order</span>&gt; orders = GetOrdersForCustomer(customerId);
    <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">LineItemSummary</span>&gt; lineItemSummaries = <span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">LineItemSummary</span>&gt;();

    <span style="color: blue">foreach </span>(<span style="color: #2b91af">Order </span>order <span style="color: blue">in </span>orders)
    {
        <span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">LineItemSummary</span>&gt; tempSummaries = TransformLineItems(order, order.GetLineItems());

        lineItemSummaries.AddRange(tempSummaries);
    }

    <span style="color: blue">return </span>lineItemSummaries.ToArray();
}
</pre>

[](http://11011.net/software/vspaste)

Note the two temporary lists: one to hold the concatenated list, and the other to hold each result as we loop through.&nbsp; With the SelectMany method, this becomes much shorter:

<pre><span style="color: blue">public </span><span style="color: #2b91af">LineItemSummary</span>[] FindLineItemsFor(<span style="color: blue">int </span>customerId)
{
    <span style="color: blue">return </span>GetOrdersForCustomer(customerId)
        .SelectMany(order =&gt; TransformLineItems(order, order.GetLineItems()))
        .ToArray();
}
</pre>

[](http://11011.net/software/vspaste)

No temporary lists are created, and all of the LineItemSummary objects are concatenated correctly.&nbsp; Nested foreach loops as well as the AddRange method are indicators that the SelectMany method could be used.

### Filtering

Filtering looks similar to transformations, except there&#8217;s an &#8220;if&#8221; statement that controls adding to the temporary list.&nbsp; Suppose we want only the expensive LineItemSummary items:

<pre><span style="color: blue">public </span><span style="color: #2b91af">LineItemSummary</span>[] FindExpensiveLineItemsFor(<span style="color: blue">int </span>customerId)
{
    <span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">Order</span>&gt; orders = GetOrdersForCustomer(customerId);
    <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">LineItemSummary</span>&gt; lineItemSummaries = <span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">LineItemSummary</span>&gt;();

    <span style="color: blue">foreach </span>(<span style="color: #2b91af">Order </span>order <span style="color: blue">in </span>orders)
    {
        <span style="color: blue">foreach </span>(<span style="color: #2b91af">LineItem </span>item <span style="color: blue">in </span>order.GetLineItems())
        {
            <span style="color: blue">if </span>(item.ItemPrice &gt; 100.0m)
                lineItemSummaries.Add(<span style="color: blue">new </span><span style="color: #2b91af">LineItemSummary
                                          </span>{
                                              CustomerName = order.Customer.Name,
                                              DateSubmitted = order.DateSubmitted,
                                              ItemPrice = item.ItemPrice,
                                              ItemName = item.ProductName
                                          });
        }
    }

    <span style="color: blue">return </span>lineItemSummaries.ToArray();
}
</pre>

[](http://11011.net/software/vspaste)

This example has both concatenation and filtering.&nbsp; The filtering can be taken care of with the Where method, and we&#8217;ll use the same technique earlier with the SelectMany method:

<pre><span style="color: blue">public </span><span style="color: #2b91af">LineItemSummary</span>[] FindExpensiveLineItemsFor(<span style="color: blue">int </span>customerId)
{
    <span style="color: blue">return </span>GetOrdersForCustomer(customerId)
        .SelectMany(order =&gt; TransformLineItems(order, order.GetLineItems()))
        .Where(item =&gt; item.ItemPrice &gt; 100.0m)
        .ToArray();
}
</pre>

[](http://11011.net/software/vspaste)

By adding the Where method, we can filter out only the expensive line items.&nbsp; The method chaining looks much better than the nested foreach loops coupled with the if statement, and got rid of the temporary list creation.

### Lose the foreach

With the new LINQ query operators, any temporary list creation and foreach loop should be considered suspect.&nbsp; By understanding the operations LINQ gives us, we can not only reduce the amount of code we create, but the end result matches the original intent far better.

Not every foreach or temporary list should be removed, as sometimes long chains and large lambdas tend to muddy rather than clear the picture.&nbsp; But for a great deal of scenarios, LINQ query operators can vastly improve the readability of transformation (Select), aggregation (Sum), concatenation (SelectMany) and filtering (Where) sections of your code.