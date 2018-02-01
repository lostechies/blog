---
id: 4195
title: Functional Construction for ASP.NET Web Forms
date: 2009-09-13T08:59:00+00:00
author: Keith Dahlby
layout: post
guid: /blogs/dahlbyk/archive/2009/09/13/functional-construction-for-asp-net-web-forms.aspx
dsq_thread_id:
  - "264826946"
categories:
  - ASP.NET
  - Functional Construction
---
System.Xml.Linq (a.k.a. LINQ to XML) introduces a nifty approach to creating XML elements called [functional construction](http://msdn.microsoft.com/en-us/library/bb387019.aspx "Functional Construction (LINQ to XML)").
  
I&#8217;m not entirely sure why they call it functional given that
  
constructing an object graph is a decidedly non-functional task in the
  
traditional sense of the word, but I digress.

Functional construction has three key features:

  1. Constructors accept arguments of various types, handling them appropriately.
  2. Constructors accept a `params` array of type `Object` to enable creation of complex objects.
  3. If an argument implements `IEnumerable`, the objects within the sequence are added.

If you haven&#8217;t seen it in action, I encourage you to take a look at
  
the examples on MSDN and elsewhere&mdash;it really is pretty slick. This post
  
will show how a similar technique can be used to build control trees in
  
ASP.NET web forms (and probably WinForms with minimal adjustment).

Basic functional construction can be implemented using two relatively simple extension methods:

<pre>public static void Add(this ControlCollection @this, object content)<br />{<br />    if (content is Control)<br />        @this.Add((Control)content);<br />    else if (content is IEnumerable)<br />        foreach (object c in (IEnumerable)content)<br />            @this.Add(c);<br />    else if (content != null)<br />        @this.Add(new LiteralControl(content.ToString()));<br />}<br /><br />public static void Add(this ControlCollection @this, params object[] args)<br />{<br />    @this.Add((IEnumerable)args);<br />}</pre>

We handle four cases:

  1. Control? Add it.
  2. Sequence? Add each.
  3. Other value? Add literal.
  4. Null? Ignore.

And our `params` overload just calls its arguments a sequence and defers to the other.

In the time-honored tradition of contrived examples:

<pre>Controls.Add(<br />    new Label() { Text = "Nums:" },<br />    "&nbsp;",<br />    from i in Enumerable.Range(1, 6)<br />    group i by i % 2<br />);</pre>

This would render &#8220;Nums: 135246&#8221;. Note that the result of that LINQ
  
expression is a sequence of sequences, which is flattened automatically
  
and converted into literals. For comparison, here&#8217;s an equivalent set
  
of statements:

<pre>Controls.Add(new Label() { Text = "Nums:" });<br />Controls.Add(new LiteralControl("&nbsp;"));<br />foreach (var g in from i in Enumerable.Range(1, 6)<br />                  group i by i % 2)<br />    foreach (var i in g)<br />        Controls.Add(new LiteralControl(i.ToString()));</pre>

Hopefully seeing them side by side makes it clear why this new method of construction might have merit. But we&#8217;re not done yet.

## Expressions, Expressions, Expressions

Many language features introduced in C# 3.0 and Visual Basic 9 make
  
expressions increasingly important. By expressions I mean a single
  
&#8220;line&#8221; of code that returns a value. For example, an object initializer
  
is a single expression&#8230;

<pre>var tb = new TextBox()<br />{<br />    ID = "textBox1",<br />    Text = "Text"<br />};</pre>

&#8230; that represents several statements &#8230;

<pre>var tb = new TextBox()<br />tb.ID = "textBox1";<br />tb.Text = "Text";</pre>

That single TextBox expression can then be used in a number of
  
places that its statement equivalent can&#8217;t: in another object
  
initializer, in a collection initializer, as a parameter to a method,
  
in a .NET 3.5 expression tree, the list goes on. Unfortunately, many
  
older APIs simply aren&#8217;t built to work in an expression-based world. In
  
particular, initializing subcollections is a considerable pain.
  
However, we can extend the API to handle this nicely:

<pre>public static T WithControls&lt;T&gt;(this T @this, params object[] content) where T : Control<br />{<br />    if(@this != null)<br />        @this.Controls.Add(content);<br />    return @this;<br />}</pre>

The key is the return value: Control in, Control out. We can now
  
construct and populate a container control with a single expression.
  
For example, we could build a dictionary list (remember those?) from
  
our groups:

<pre>Controls.Add(<br />    new HtmlGenericControl("dl")<br />    .WithControls(<br />        from i in Enumerable.Range(1, 6)<br />        group i by i % 2 into g<br />        select new [] {<br />            new HtmlGenericControl("dt")<br />            { InnerText = g.Key == 0 ? "Even" : "Odd" },<br />            new HtmlGenericControl("dd")<br />            .WithControls(g)<br />        }<br />    )<br />);</pre>

Which would render this:

> Odd
> :   135
> 
> Even
> :   246

Without the ability to add controls within an expression, this
  
result would require nested loops with local variables to store
  
references to the containers. The actual code produced by the compiler
  
would be nearly identical, but I find the expressions much easier to
  
work with. Similarly, we can easily populate tables. Let&#8217;s build a cell
  
per number:

<pre>Controls.Add(<br />    new Table().WithControls(<br />        from i in Enumerable.Range(1, 6)<br />        group i by i % 2 into g<br />        select new TableRow().WithControls(<br />            new TableCell()<br />            { Text = g.Key == 0 ? "Even" : "Odd" },<br />            g.Select(n =&gt; new TableCell().WithControls(n))<br />        )<br />    )<br />);</pre>

In a future post I&#8217;ll look at some other extensions we can use to
  
streamline the construction and initialization of control hierarchies.