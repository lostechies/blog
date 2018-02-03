---
wordpress_id: 3970
title: A quick follow up about data restrictions
date: 2011-01-25T03:35:46+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2011/01/24/a-quick-follow-up-about-data-restrictions.aspx
dsq_thread_id:
  - "262153150"
categories:
  - FubuMVC
---
A comment on <a href="http://www.lostechies.com/blogs/joshuaflanagan/archive/2011/01/24/how-we-systemically-apply-filters-to-our-data-access.aspx" target="_blank">my last post</a> caused me to re-read it, and realize that I didn&#8217;t do a good job of emphasizing the role of data restrictions (implementations of `IDataRestriction<T>`) in our application. Since I introduced them in the context of the `RestrictedQuery` method on our Repository class, it gave the impression that they were just helpers for data access. The reality is that RestrictedQuery was actually a usage we discovered very late in the design of data restrictions. The data restriction classes simply encapsulate rules for determining access to an entity.

The key to its flexibility is the `IDataSourceFilter<T>` parameter passed to the data restriction at runtime. For a quick reminder, look at the implementation of the "sensitive case" data restriction:

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

The data restriction performs actions on the filter passed to it. What effect that filter ultimately has on the system is not known, nor a concern of the data restriction itself. That is the role of the data restriction consumer, who determines which type of implementation of IDataSourceFilter<T> to provide. Think of it like LINQ &#8211; there are a set of operations (the extension methods on `IEnumerable`) which can be transparently applied to a number of sources (the LINQ data providers). In fact, we considered passing in an `IQueryable<T>` as the parameter to the `Apply()` method, but quickly realized that opened up way more operations than we intended to support. Like LINQ, we have one implementation of IDataSourceFilter that alters SQL queries (as I demonstrated in the last post), and we have another implementation that simply operates on objects in memory (which I intend to demonstrate in a future post).

The bottom line is that data restrictions represent behavior of the domain (like _"only users with the "view sensistive cases" privilege should see cases marked as sensitive"_), and live in the domain. The fact that we were able to easily leverage these rules in our data access code is a pleasant bonus.