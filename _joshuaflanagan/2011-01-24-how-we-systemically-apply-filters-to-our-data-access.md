---
wordpress_id: 3969
title: How we systemically apply filters to our data access
date: 2011-01-24T14:34:08+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2011/01/24/how-we-systemically-apply-filters-to-our-data-access.aspx
dsq_thread_id:
  - "262098816"
categories:
  - FubuMVC
redirect_from: "/blogs/joshuaflanagan/archive/2011/01/24/how-we-systemically-apply-filters-to-our-data-access.aspx/"
---
I wrote about <a href="http://blogs.dovetailsoftware.com/blogs/jflanagan/archive/2011/01/24/limiting-access-to-sensitive-information-in-dovetail-support-center" target="_blank">limiting access to sensitive information in Dovetail Support Center</a> on the company blog, but didn&#8217;t get too deep into the technical implementation. Since that feature development relied heavily on the capabilities of our open source web framework, <a href="http://fubumvc.com/" target="_blank">FubuMVC</a> (and the related FubuFastPack), I figured it would be worthwhile to document how it all works. This post will describe how we filter data retrieved from the database.

### RestrictedQuery

We wanted an easy way to systemically apply rules to filter out data, without every bit of client code having to know about those rules. Consider the "sensitive cases" feature I discussed in my Dovetail post &#8211; we needed to make sure that a user without the "View Sensitive Cases" permission would never see a case marked as sensitive. However, there are a number of places throughout the application where lists of cases are displayed: custom case queries, full-text search results, "heads up" widgets like "Cases opened by this contact in the past 30 days", etc. We do not want to embed the logic for sensitive cases in each of these call sites for a few reasons: 

  * it would be repetitive 
  * we would have to remember to include the logic in every future piece of code that queried for cases 
  * if we wanted to add a new rule, we would have to modify all of the call sites once again 

We added a `RestrictedQuery<T>()` method to <a href="https://github.com/DarthFubuMVC/fubumvc/blob/d54e4c0462107e9df6a8ede12f63080249e3b644/src/FubuFastPack/Persistence/Repository.cs" target="_blank">FubuFastPack&#8217;s Repository</a> which can add additional criteria to&#160; database queries. It is similar to our `Query<T>()` method, which is a lightweight wrapper around NHibernate LINQ, but it alters the query based on data restrictions defined in the application. A data restriction is defined by implementing the `<a href="https://github.com/DarthFubuMVC/fubumvc/blob/3344dee1bfb5ccfa14cee5092bb283484bbbcd20/src/FubuFastPack/Querying/IDataRestriction.cs" target="_blank">IDataRestriction<T></a>` interface:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>public interface IDataRestriction&lt;T&gt; : IDataRestriction where T : DomainEntity
{
    void Apply(IDataSourceFilter&lt;T&gt; filter);
}</pre>
</div>

For example, to make sure sensitive cases are only shown to users with the necessary permission, we wrote this data restriction:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>public class SensitiveCaseDataRestriction : IDataRestriction&lt;Case&gt;
{
    public void Apply(IDataSourceFilter&lt;Case&gt; filter)
    {
        if (!PrincipalRoles.IsInRole(DomainActions.ViewSensitiveCases))
        {
            filter.WhereEqual(x =&gt; x.IsSensitive, false);
        }
    }
}</pre>
</div>

### Example

Consider a customer support system where support cases are&#160; placed into a triage queue so that someone can prioritize them. In the application, you want to display a list of all cases in triage. For simplicity, &#8216;I&#8217;ll print the list to the console:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>private void showCasesInTriageQueue(IQueryable&lt;Case&gt; allCases, string heading)
{
    Console.WriteLine();
    Console.WriteLine("=== {0} ===", heading);

    var foundCases = allCases.Where(c =&gt; c.Queue.Name == "Triage").ToArray();

    Console.WriteLine(foundCases.Length + " cases found");
    foreach (var foundCase in foundCases)
    {
        Console.WriteLine(foundCase.Title);
    }
}</pre>
</div>

The key logic is in line 6 where the list of cases is narrowed down to just the cases in the triage queue. Notice that the method is not clouded with other concerns like filtering out sensitive cases, or any other data restriction that may apply. We can call this method by passing in an `IQueryable<Case>` from `Query<T>()` or `RestrictedQuery<T>()`:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>// demonstrate that the current user does not have rights to view sensitive cases
PrincipalRoles.IsInRole(DomainActions.ViewSensitiveCases).ShouldBeFalse();

showCasesInTriageQueue(repository.Query&lt;Case&gt;(), "Query");

showCasesInTriageQueue(repository.RestrictedQuery&lt;Case&gt;(), "Restricted Query");</pre>
</div>

We first assert that the current user does not have rights to view sensitive cases. We then perform a regular Query, followed by a RestrictedQuery. The only difference is that RestrictedQuery applies all of the data restrictions that have been registered with the repository (via dependency injection). The output confirms that the sensitive case (regarding someone&#8217;s paycheck) was filtered out by the restricted query:

<pre>=== Query ===
3 cases found
Alert! Air temperature sensor not detected
Paycheck shows wrong 401k amount
Extra vacation days request

=== Restricted Query ===
2 cases found
Alert! Air temperature sensor not detected
Extra vacation days request</pre>

What&#8217;s extra nice is that the filtering happens at the database. The <a href="https://github.com/DarthFubuMVC/fubumvc/blob/3344dee1bfb5ccfa14cee5092bb283484bbbcd20/src/FubuFastPack/Querying/IDataSourceFilter.cs" target="_blank"><code>IDataSourceFilter&lt;T&gt;</code></a> used in RestrictedQuery is implemented as a wrapper around NHibernate&#8217;s Criteria API. A quick look at <a href="http://www.nhprof.com/" target="_blank">NHibernate Profiler</a> shows the two calls to the database:

[<img style="border-right-width: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px;padding-top: 0px" border="0" alt="restricted_query_nhprof" src="http://lostechies.com/joshuaflanagan/files/2011/03/restricted_query_nhprof_thumb_3DED833A.png" width="644" height="129" />](http://lostechies.com/joshuaflanagan/files/2011/03/restricted_query_nhprof_1EAADC67.png)

Summary

Creating additional system-wide filters is as easy as creating a new implementation of `IDataRestriction<T>` and making sure it gets registered in our <a href="http://structuremap.net/structuremap/" target="_blank">inversion of control tool</a> (most likely through automatic scanning). And since data restrictions do not contain any data access code, they can also be used in other contexts, such as authorizing access to pages (a post for another day).