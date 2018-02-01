---
id: 110
title: ASP.NET Web API List Parameter Binding
date: 2012-10-04T22:49:42+00:00
author: Keith Dahlby
layout: post
guid: http://lostechies.com/keithdahlby/?p=110
dsq_thread_id:
  - "871977002"
categories:
  - ASP.NET Web API
tags:
  - model binding
  - modelbinder
  - web api
---
We chased our tails on this a bit today, so hopefully someone finds this useful.

### The Problem

Your action needs to accept a list of primitives but your list parameter (of type `T[]`, `IEnumerable<T>`, `List<T>`, etc) always comes back `null`. You&#8217;re pretty sure an identical parameter has always work fine for an MVC action.

### The Solution

Add [`[ModelBinder]`](http://msdn.microsoft.com/en-us/library/system.web.http.modelbinding.modelbinderattribute.aspx "System.Web.Http.ModelBinding.ModelBinderAttribute") to the parameter:

<pre>public class ValuesController : ApiController
{
    // GET api/values?id=Hello&id=%20world!
    public string Get([ModelBinder]List&lt;string&gt; id)
    {
        return string.Join(",", id);
    }
}</pre>

### Explanation

According to Mike Stall&#8217;s [detailed post on Web API parameter binding](http://blogs.msdn.com/b/jmstall/archive/2012/04/16/how-webapi-does-parameter-binding.aspx "How WebAPI does Parameter Binding"), Web API only uses model binding for &#8220;simple types&#8221;, falling back on formatters for everything else. Adding `[ModelBinder]` forces the complex types to use model binding anyway.

Related but not constructive: it feels weird naming a list parameter &#8220;id&#8221;, but even more weird using the API if it were named &#8220;ids&#8221;. Maybe just &#8220;x&#8221; instead?