---
wordpress_id: 195
title: 'Separation of Concerns &#8211; how not to do it'
date: 2008-06-17T12:00:16+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/06/17/separation-of-concerns-how-not-to-do-it.aspx
dsq_thread_id:
  - "264715805"
categories:
  - LINQ2SQL
  - Refactoring
redirect_from: "/blogs/jimmy_bogard/archive/2008/06/17/separation-of-concerns-how-not-to-do-it.aspx/"
---
In a recent article on layered LINQ applications in the latest ASP.NET PRO magazine (no link, you have to pay), the author proposes separating your application into three distinct layers:

  * User Interface (UI) layer
  * Business Logic Layer (BLL)
  * Data Access Layer (DAL)

I certainly would have agreed, at least back in 2004 or so.&nbsp; Many of the sample applications coming out of MSDN have a similar architecture, with namespaces like Northwind.DAL to reinforce that architecture.

While separating out concerns into these layers is a good first step, it&#8217;s only the first step.&nbsp; Layered architecture and separation of concerns goes well beyond splitting your code into three classes.&nbsp; Our code itself gives hints for when a class is concerned with too much going on.

### 

### Too many concerns

A snippet of the BLL class looked something like this:

<pre><span style="color: blue">using </span>System;
<span style="color: blue">using </span>System.Collections.Generic;
<span style="color: blue">using </span>System.ComponentModel;
<span style="color: blue">using </span>System.Linq;
<span style="color: blue">using </span>System.Web;

<span style="color: blue">public class </span><span style="color: #2b91af">CustomerManager
</span>{
    [<span style="color: #2b91af">DataObjectMethod</span>(<span style="color: #2b91af">DataObjectMethodType</span>.Select, <span style="color: blue">false</span>)]
    <span style="color: blue">public static </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; GetCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
    {
        <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; customers = <span style="color: blue">null</span>;
        <span style="color: blue">string </span>key = <span style="color: #a31515">"Customers_Customers_" </span>+ startRowIndex + maximumRows;

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

This CustomerManager class would also have methods for all of the CRUD operations, delegating to LINQ to SQL for the heavy lifting.&nbsp; Already we have some inconsistencies and pain points with this class:

  * It manages CRUD operations, yet is situated in the BLL.&nbsp; Is it data access or not?
  * The name is nebulous.&nbsp; It Manages Customers, but how?&nbsp; What aspects?&nbsp; Persistence?&nbsp; Caching?&nbsp; Business Rules?&nbsp; It might as well implement IKitchenSink.
  * Persistence and caching concerns are mixed together
  * Customer management and UI concerns are mixed together (i.e., the DataObjectMethod attribute)
  * Not an intention-revealing interface &#8211; List<Customer> allows me to add, remove and insert items to the list.&nbsp; This should be a read-only affair.

Outside of these issues, there are other problems we can see off-hand:

  * Potential for InvalidCastException &#8211; anyone can stick something in Cache with that key.&nbsp; Use the &#8220;as&#8221; operator instead
  * The &#8220;customers&#8221; variable is never null.&nbsp; No need to check it.
  * Several static dependencies &#8211; the DataGateway.Context and HttpContext.Current static properties
  * **The whole CustomerManager class is impossible to unit test**

Or test in any way possible.&nbsp; For me to add an automated test, the whole HttpContext needs to be up and running.&nbsp; I&#8217;ll get an immediate NullReferenceException as soon as any piece of code hits HttpContext.Current.

Layering applications is a great step in the right direction to removing concerns from the ASP.NET codebehind.&nbsp; But it&#8217;s only the first step.&nbsp; Next time, we&#8217;ll see how we can split out the many concerns from this CustomerManager.