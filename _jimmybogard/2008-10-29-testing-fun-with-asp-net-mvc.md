---
wordpress_id: 244
title: Testing fun with ASP.NET MVC
date: 2008-10-29T23:14:15+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/10/29/testing-fun-with-asp-net-mvc.aspx
dsq_thread_id:
  - "265617030"
categories:
  - ASPNETMVC
  - MonoRail
---
So I assumed that much like MonoRail, ASP.NET MVC would have created, at the very least, abstractions on top of HttpContext.&#160; Although HttpContext is an absolute beast of a god class, creating an abstraction is possible.&#160; Let’s look at MonoRail’s approach:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IRailsEngineContext </span>: <span style="color: #2b91af">IServiceContainer</span>, <span style="color: #2b91af">IServiceProvider
</span>{
    <span style="color: green">// Methods
    </span>T GetService&lt;T&gt;();
    <span style="color: blue">void </span>Transfer(<span style="color: blue">string </span>path, <span style="color: blue">bool </span>preserveForm);

    <span style="color: green">// Properties
    </span><span style="color: blue">string </span>ApplicationPath { <span style="color: blue">get</span>; }
    <span style="color: blue">string </span>ApplicationPhysicalPath { <span style="color: blue">get</span>; }
    <span style="color: #2b91af">ICacheProvider </span>Cache { <span style="color: blue">get</span>; }
    <span style="color: #2b91af">IServiceProvider </span>Container { <span style="color: blue">get</span>; }
    <span style="color: #2b91af">Controller </span>CurrentController { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: #2b91af">IPrincipal </span>CurrentUser { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: #2b91af">Flash </span>Flash { <span style="color: blue">get</span>; }
    <span style="color: #2b91af">IDictionary </span>Items { <span style="color: blue">get</span>; }
    <span style="color: #2b91af">Exception </span>LastException { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: #2b91af">NameValueCollection </span>Params { <span style="color: blue">get</span>; }
    <span style="color: #2b91af">IRequest </span>Request { <span style="color: blue">get</span>; }
    <span style="color: blue">string </span>RequestType { <span style="color: blue">get</span>; }
    <span style="color: #2b91af">IResponse </span>Response { <span style="color: blue">get</span>; }
    <span style="color: #2b91af">IServerUtility </span>Server { <span style="color: blue">get</span>; }
    <span style="color: #2b91af">IDictionary </span>Session { <span style="color: blue">get</span>; }
    <span style="color: #2b91af">ITrace </span>Trace { <span style="color: blue">get</span>; }
    <span style="color: #2b91af">HttpContext </span>UnderlyingContext { <span style="color: blue">get</span>; }
    <span style="color: blue">string </span>Url { <span style="color: blue">get</span>; }
    <span style="color: #2b91af">UrlInfo </span>UrlInfo { <span style="color: blue">get</span>; }
    <span style="color: blue">string </span>UrlReferrer { <span style="color: blue">get</span>; }
}</pre>

[](http://11011.net/software/vspaste)

Things are looking okay, most objects are hidden behind an interface.&#160; Those interfaces that have members that expose other classes, are interfaces as well.&#160; Only the items important to a Controller action are present, and the original HttpContext is still present.&#160; But ideally, you can go off of the interfaces, IResponse, IRequest, etc.&#160; This makes testing MonoRail items (controllers, filters, etc.) straightforward.

Now, let’s take a look at ASP.NET MVC:

<pre><span style="color: blue">public abstract class </span><span style="color: #2b91af">HttpContextBase </span>: <span style="color: #2b91af">IServiceProvider
</span>{
    <span style="color: green">// Methods
    </span><span style="color: blue">protected </span>HttpContextBase();
    <span style="color: blue">public virtual void </span>AddError(<span style="color: #2b91af">Exception </span>errorInfo);
    <span style="color: blue">public virtual void </span>ClearError();
    <span style="color: blue">public virtual object </span>GetGlobalResourceObject(<span style="color: blue">string </span>classKey, <span style="color: blue">string </span>resourceKey);
    <span style="color: blue">public virtual object </span>GetGlobalResourceObject(<span style="color: blue">string </span>classKey, <span style="color: blue">string </span>resourceKey, <span style="color: #2b91af">CultureInfo </span>culture);
    <span style="color: blue">public virtual object </span>GetLocalResourceObject(<span style="color: blue">string </span>virtualPath, <span style="color: blue">string </span>resourceKey);
    <span style="color: blue">public virtual object </span>GetLocalResourceObject(<span style="color: blue">string </span>virtualPath, <span style="color: blue">string </span>resourceKey, <span style="color: #2b91af">CultureInfo </span>culture);
    <span style="color: blue">public virtual object </span>GetSection(<span style="color: blue">string </span>sectionName);
    <span style="color: blue">public virtual object </span>GetService(<span style="color: #2b91af">Type </span>serviceType);
    <span style="color: blue">public virtual void </span>RewritePath(<span style="color: blue">string </span>path);
    <span style="color: blue">public virtual void </span>RewritePath(<span style="color: blue">string </span>path, <span style="color: blue">bool </span>rebaseClientPath);
    <span style="color: blue">public virtual void </span>RewritePath(<span style="color: blue">string </span>filePath, <span style="color: blue">string </span>pathInfo, <span style="color: blue">string </span>queryString);
    <span style="color: blue">public virtual void </span>RewritePath(<span style="color: blue">string </span>filePath, <span style="color: blue">string </span>pathInfo, <span style="color: blue">string </span>queryString, <span style="color: blue">bool </span>setClientFilePath);

    <span style="color: green">// Properties
    </span><span style="color: blue">public virtual </span><span style="color: #2b91af">Exception</span>[] AllErrors { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">HttpApplicationStateBase </span>Application { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">HttpApplication </span>ApplicationInstance { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">Cache </span>Cache { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">IHttpHandler </span>CurrentHandler { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">RequestNotification </span>CurrentNotification { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">Exception </span>Error { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">IHttpHandler </span>Handler { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public virtual bool </span>IsCustomErrorEnabled { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual bool </span>IsDebuggingEnabled { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual bool </span>IsPostNotification { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">IDictionary </span>Items { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">IHttpHandler </span>PreviousHandler { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">ProfileBase </span>Profile { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">HttpRequestBase </span>Request { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">HttpResponseBase </span>Response { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">HttpServerUtilityBase </span>Server { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">HttpSessionStateBase </span>Session { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual bool </span>SkipAuthorization { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">DateTime </span>Timestamp { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">TraceContext </span>Trace { <span style="color: blue">get</span>; }
    <span style="color: blue">public virtual </span><span style="color: #2b91af">IPrincipal </span>User { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

Still very similar, but this time it’s an abstract class.&#160; But a very strange abstract class – it has no abstract members!&#160; All members are virtual.&#160; Well that was nice of them, providing a default implementation that can be overridden for testing.&#160; Ah, but what’s the default implementation?&#160; “throw new NotImplementedException()”.&#160; For every. single. member.&#160; Brilliant!

Next, let’s try to actually test using this class.&#160; <strike>Abstract base classes</strike> minefield base classes (touch it and it asplodes!) are exposed for the various items we might care about, including Request, Response, Session, Server, Trace, Application.&#160; Wait, go back one.&#160; Trace exposes TraceContext.

Which is not abstract.

Which is sealed.

Kaboom!

I still like creating application-specific wrappers on all of these items.&#160; But when you have to create things like filters, it can be painful to work around these limitations.