---
wordpress_id: 1121
title: 'End-to-End Hypermedia: Making the Leap'
date: 2015-05-19T15:26:40+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1121
dsq_thread_id:
  - "3777079405"
categories:
  - REST
---
REST, a term that few people understand and fewer know how to implement, has become a blanket term for any sort of Web API. That&#8217;s unfortunate, because the underlying foundation of REST has a lot of benefits. So much so that I&#8217;ve started talking about regular Web APIs not as &#8220;RESTful&#8221; but just as a &#8220;Web API&#8221;. The value of REST for me has come from the hypermedia aspect of REST.

REST and hypermedia aren&#8217;t free &#8211; they significantly complicate both the building of the server API and the clients. But they are useful in certain scenarios, as I laid out in talking about the [value proposition of hypermedia](https://lostechies.com/jimmybogard/2014/09/23/the-value-proposition-of-hypermedia/ "The value proposition of Hypermedia"):

  * Native mobile apps
  * Disparate client deployments talking to a single server
  * Clients talking to disparate server deployments

I&#8217;ve only put one hypermedia-driven API into production (which, to be frank, is one more than most folks who talk about REST). I&#8217;ve attempted to build many other hypermedia APIs, only to find hypermedia was complete overkill.

If your client is deployed at the same time as your server, lives in the same source control repository, hypermedia doesn&#8217;t provide much value at all.

Hypermedia is great at decoupling client from server, allowing the client to adjust according to the server. In most apps I build, I happily couple client to server, taking advantage of the metadata I find on the server to build highly intelligent clients:

{% gist 01d088ea56ee763f0d52 %}

In this case, my client is the browser, but my view is intelligently built up so that labels, text inputs, drop downs, checkboxes, date pickers and so on are created using metadata from a variety of sources. I can even employ this mechanism in SPAs, where my templates are [pre-rendered using server metadata](https://lostechies.com/jimmybogard/2014/08/14/conventional-html-in-asp-net-mvc-client-side-templates/ "Conventional HTML in ASP.NET MVC: Client-side templates").

I don&#8217;t really build APIs for clients I can&#8217;t completely control, so those have completely different considerations. Building an API for public consumption means you want to enable as many clients as possible, balancing coupling with flexibility. The APIs I&#8217;ve built for clients I don&#8217;t own, I&#8217;ve never used hypermedia. It just put too much burden on my clients, so I just left it as plain old JSON objects (POJSONOs).

So if you&#8217;ve found yourself in a situation where you&#8217;ve convinced yourself you do need hypermedia, primarily based on coupling decisions, you&#8217;ll need to do a few things to get a full hypermedia solution end-to-end:

  * Choose a hypermedia-rich media type
  * Build the server API
  * Build the client consumer

In the next few posts, I&#8217;ll walk through end-to-end hypermedia from my experiences of shipping a hypermedia API server and a client consumer.

&nbsp;