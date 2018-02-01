---
id: 3972
title: Applying data restrictions to route authorization
date: 2011-02-06T21:30:30+00:00
author: Joshua Flanagan
layout: post
guid: /blogs/joshuaflanagan/archive/2011/02/06/applying-data-restrictions-to-route-authorization.aspx
dsq_thread_id:
  - "262115864"
categories:
  - FubuMVC
---
I introduced our concept of data restrictions in the context of <a href="http://www.lostechies.com/blogs/joshuaflanagan/archive/2011/01/24/how-we-systemically-apply-filters-to-our-data-access.aspx" target="_blank">filtering out entities from data access queries</a>. I then had to <a href="http://www.lostechies.com/blogs/joshuaflanagan/archive/2011/01/24/a-quick-follow-up-about-data-restrictions.aspx" target="_blank">clarify that data restrictions are not tied to data access</a> &#8211; they are part of the domain logic. In this post I will demonstrate how we use those same data restrictions to protect web pages, using the same example of <a href="http://blogs.dovetailsoftware.com/blogs/jflanagan/archive/2011/01/24/limiting-access-to-sensitive-information-in-dovetail-support-center" target="_blank">sensitive cases in Dovetail Support Center</a>.

In our application, we have standard CRUD endpoints for each of our top level entities: New/Create/View. The view endpoint for a case is _case/GUID_. To properly implement the sensitive cases feature, we had to make sure that a user without the "View Sensitive Cases" would get an access denied error if they attempted to load the page for a sensitive case.

### A side note about FubuMVC authorization

FubuMVC has a very powerful configuration model for declaring and decorating endpoints (routes/web pages). I&#8217;m not going to dive deep into the configuration, but you can read <a href="http://codebetter.com/jeremymiller/2011/01/10/fubumvcs-configuration-strategy/" target="_blank">Jeremy Miller&#8217;s introduction</a>. When configuring an endpoint, if you attach any authorization policies (`IAuthorizationPolicy`), an authorization behavior will be added to the endpoint to execute your policies at runtime. When a request comes in to the endpoint, each policy gets a chance to vote on whether the request can continue. If the policies do not vote to Allow, the request is interrupted and an HTTP 403 is returned to the client.

### RestrictedDataAuthorizationPolicy

We already have a class that defines whether a user can view a case &#8211; <a href="https://gist.github.com/790361" target="_blank">SensitiveCaseDataRestriction</a>, which I introduced in my post about filtering at the data access level. In the context of a web request to view a Case, we have a single Case instance. If we could execute the data restrictions against the given Case, we could determine if the request should continue or return a 403. That is exactly what the <a href="https://github.com/DarthFubuMVC/fubumvc/blob/3344dee1bfb5ccfa14cee5092bb283484bbbcd20/src/FubuFastPack/Security/RestrictedDataAuthorizationPolicy.cs" target="_blank">RestrictedDataAuthorizationPolicy</a> does:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre class="brush:csharp; gutter:false; wrap-lines:false; tab-size:2;">public class RestrictedDataAuthorizationPolicy&lt;T&gt; : IAuthorizationPolicy where T : DomainEntity
{
    private readonly IEnumerable&lt;IDataRestriction&lt;T&gt;&gt; _dataRestrictions;

    public RestrictedDataAuthorizationPolicy(IEnumerable&lt;IDataRestriction&lt;T&gt;&gt; dataRestrictions)
    {
        _dataRestrictions = dataRestrictions;
    }

    public AuthorizationRight RightsFor(IFubuRequest request)
    {
        var entityFilter = new SingleEntityFilter&lt;T&gt;(request.Get&lt;T&gt;());
        _dataRestrictions.Each(entityFilter.ApplyRestriction);
        return entityFilter.CanView ? AuthorizationRight.None : AuthorizationRight.Deny;
    }
}</pre>
</div>

It takes advantage of the fact that IDataRestrictions operate against the <a href="https://github.com/DarthFubuMVC/fubumvc/blob/3344dee1bfb5ccfa14cee5092bb283484bbbcd20/src/FubuFastPack/Querying/IDataSourceFilter.cs" target="_blank"><code>IDataSourceFilter&lt;T&gt;</code></a> interface. In the data access context, the IDataSourceFilter implementation would build a SQL WHERE clause. In this context, we already have an entity instance (the call to `request.Get<T>()` in line 12 above), so we just need to see if it "passes" all of the rules. The <a href="https://github.com/DarthFubuMVC/fubumvc/blob/3344dee1bfb5ccfa14cee5092bb283484bbbcd20/src/FubuFastPack/Querying/SingleEntityFilter.cs" target="_blank">SingleEntityFilter</a> class is an implementation of IDataSourceFilter that keeps track of a single boolean value: CanView. It is set to `true` initially, but successive calls to `ApplyRestriction()` could set it to `false` if the entity does not meet the requirements of an IDataRestriction. After all of the data restrictions are applied, the CanView property tells us if we need to deny access to the current web request.

### Applying the policy

The final step is to wire it all up together. We need to attach the RestricedDataAuthorizationPolicy to the appropriate endpoints (the "View" routes for our entities). FubuMVC allows us to define a convention so that all of the appropriate endpoints have the policy applied automatically. The implementation details of a FubuMVC convention are beyond the scope of this post, but I&#8217;ll include the code to give you a hint at the possibilities. It isn&#8217;t the most succinct code, but it should give you an idea of how powerful it is to be able to query and modify the composition of your endpoints at startup time.

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre class="brush:csharp; gutter:false; wrap-lines:false; tab-size:2;">public class AuthorizeByDataRestrictionsConvention : IConfigurationAction
{
    public void Configure(BehaviorGraph endpoints)
    {
        // "view" actions are declared on classes that implement CrudController interface
        // ex: CaseController : CrudController&lt;Case&gt;
        var viewEntityActions = endpoints.Behaviors.Select(x =&gt; x.FirstCall())
            .Where(x =&gt; x.HandlerType.IsCrudController())
            .Where(x =&gt; x.Method.Name == "View");

        foreach (var action in viewEntityActions)
        {
            var entityType = action.HandlerType.FindInterfaceThatCloses(typeof(CrudController&lt;&gt;)).GetGenericArguments()[0];
            var endpoint = action.ParentChain();

            var policyType = typeof(RestrictedDataAuthorizationPolicy&lt;&gt;).MakeGenericType(entityType);
            endpoint.Authorization.AddPolicy(policyType);
        }
    }
}</pre>
</div>