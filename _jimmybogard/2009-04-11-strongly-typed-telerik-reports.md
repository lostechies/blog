---
id: 304
title: Strongly-typed Telerik reports
date: 2009-04-11T18:43:05+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/04/11/strongly-typed-telerik-reports.aspx
dsq_thread_id:
  - "264716110"
categories:
  - 'C#'
---
I absolutely loathe magic strings, especially if all they’re used for is pointing to a member on a type.&#160; Using strings to reference a type member is ridiculously brittle, as any change in the source type member, rename or remove, will not cause a compile-time error, but a runtime error.&#160; This is unacceptable.

The reporting tools I’ve used (SSRS, Crystal Reports, Telerik, Dundas) all assume that you’d like to report straight off a database.&#160; If not a database, then a DataSet.&#160; For many types of reports, this works fine, as we’d create a separate reporting database, views, and in some cases, an SSAS cube.&#160; But in other cases, all the report is trying to show is a nice, printable PDF version of the domain model.&#160; It’s in these cases that reporting tools fall flat.

For these non-aggregate reports, we like to create a flattened view of our domain model, optimized for viewing in a report, using AutoMapper.&#160; Fortunately, our reporting tool of choice ([Telerik Reports](http://www.telerik.com/products/reporting.aspx)) lets us use objects as data sources.&#160; We can do things like:

<pre>report.DataSource = <span style="color: #2b91af">Mapper</span>.Map&lt;<span style="color: #2b91af">Customer</span>, <span style="color: #2b91af">CustomerOrderReportModel</span>&gt;(customer);</pre>

[](http://11011.net/software/vspaste)

Where CustomerOrderReportModel is a flattened version of our Customer (plus their orders, etc.).&#160; When it comes to configuring a text box value to be bound from the CustomerOrderReportModel data source, you’ll find some fun code:

<pre><span style="color: blue">this</span>.txtCustomerName.Value = <span style="color: #a31515">"=Fields.Name"</span>;</pre>

[](http://11011.net/software/vspaste)

Ugh.&#160; A magic string to point to a type member, a property on a class.&#160; Which means that renaming the member will kill my report, and that’s something that’s not only difficult to remember to do, but you’ll have to rely on text searches or running all your reports to ensure you didn’t break anything.&#160; Again, this is unacceptable.&#160; But we have a trick up our sleeve – strongly-typed reflection with expressions.

### Putting expressions into the mix

The first thing I had to find was _where_ I could configure the expressions.&#160; Since reports are very designer heavy (as they should be), I found that any trick I used still had to work with the designer.&#160; At the very least, it couldn’t break the designer.

In the Telerik case, the best I could do was to override a method used during report generation, but not viewing.&#160; This is the OnNeedDataSource method for Telerik, it’s not called during designing.&#160; I tried to put all of the expression code into the normal designer code location (InitializeComponent), but this broke the designer.

To create expressions, it’s a lot easier of the type you’re creating expressions for is already part of some generic context.&#160; For example, I could inherit from a base generic class, and my generic type could be inferred easily.&#160; It’s not much fun having to specify the generic argument for every field in a report, so I’d like to have that specified just once.&#160; In my case, I created a marker interface:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IReport</span>&lt;TReportModel&gt;
{
}</pre>

[](http://11011.net/software/vspaste)

I had to use a marker interface instead of a base class as the base class broke the designer.&#160; Next, an extension method to generate the string Telerik needs for reports from an expression I’d rather use.&#160; I can’t change Telerik to use expressions, but I can at least generate what it needs from an expression:

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">ReportExtentions
</span>{
    <span style="color: blue">public static string </span>Field&lt;TReportModel&gt;(<span style="color: blue">this </span><span style="color: #2b91af">IReport</span>&lt;TReportModel&gt; report, <span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;TReportModel, <span style="color: blue">object</span>&gt;&gt; expression)
    {
        <span style="color: blue">return </span><span style="color: #a31515">"=Fields." </span>+ UINameHelper.BuildNameFrom(expression);
    }

    <span style="color: blue">public static string </span>PartialField&lt;TReportModel&gt;(<span style="color: blue">this </span><span style="color: #2b91af">IReport</span>&lt;TReportModel&gt; report, <span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;TReportModel, <span style="color: blue">object</span>&gt;&gt; expression)
    {
        <span style="color: blue">return </span><span style="color: #a31515">"Fields." </span>+ UINameHelper.BuildNameFrom(expression);
    }
}</pre>

[](http://11011.net/software/vspaste)

That Expression<Func<TReportModel, object>> piece should start to look awfully familiar for anyone doing strongly-typed reflection.&#160; The UINameHelper is just a utility class used throughout our system to output expression strings from real expressions.&#160; Next, I just need to mark my report as an IReport, and configure the textboxes through expressions:

<pre><span style="color: blue">public partial class </span><span style="color: #2b91af">TestReport </span>: <span style="color: #2b91af">Report</span>, <span style="color: #2b91af">IReport</span>&lt;<span style="color: #2b91af">CustomerOrderReportModel</span>&gt;
{
    <span style="color: blue">public </span>TestReport()
    {
        InitializeComponent();
    }

    <span style="color: blue">public </span>TestReport(<span style="color: #2b91af">CustomerOrderReportModel </span>model)
        : <span style="color: blue">this</span>()
    {
        DataSource = model;
    }

    <span style="color: blue">protected override void </span>OnNeedDataSource(<span style="color: blue">object </span>sender, System.<span style="color: #2b91af">EventArgs </span>e)
    {
        <span style="color: blue">base</span>.OnNeedDataSource(sender, e);

        txtCustomerName.Value = <span style="color: blue">this</span>.Field(m =&gt; m.Name);
    }
}</pre>

[](http://11011.net/software/vspaste)

Although I have to use “this.” to get the extension method to show up, it’s a lot easier than having to specify the generic argument every single time.&#160; The “Field” method merely generates the correct configuration that Telerik needs, and Telerik is none the wiser.

With strongly-typed reflection in my reports, I’m able to eliminate the magic strings that are the source of so many runtime bugs we often don’t catch until production.&#160; Magic strings are maintainability grenades, and I like to squash them wherever they show up.