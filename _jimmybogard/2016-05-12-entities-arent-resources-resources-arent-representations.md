---
wordpress_id: 1184
title: Entities aren’t resources, resources aren’t representations
date: 2016-05-12T16:29:28+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1184
dsq_thread_id:
  - "4821207594"
categories:
  - REST
---
One of the easy mistakes in building a REST API is trying to take your rows out of the database and expose them directly as JSON. Such technology exists, where you can [directly expose stored procedures as SOAP web services](https://docs.oracle.com/cd/B28359_01/java.111/b31225/chtwelve.htm), or protocols like [OData](http://www.odata.org/).&nbsp; You can also just expose your entities directly as JSON through a web service, but you’re missing out on some big distinctions of resources and representations.

So first, what is a resource? That’s actually quite easy – a resource is anything with a URL. The converse is not true, a URL is not a resource, mainly because the URL is the Uniform Resource Locator. If you can locate a resource, then it exists. And Fielding was pleased.

The representation is a bit different – it describes the **current** state of the resource (when requested).

So what does this have to do with entities? Well, nothing. There is no relationship between entities and resources. And that’s a good thing, it’s exactly how the web works.

When you navigate to a web page, an online retailer, and look at a list of products, what is the resource? From the client’s perspective, we don’t know. We have no idea of the implementation details of the resource, other than a way to locate it and request a representation. Again, Fielding was pleased, as this decoupled us from the implementation details of the resource.

So where does this leave us when building APIs?

### A decoupled API

In APIs that serve the client according to their needs, the resource often includes details from many different data sources, combined together to build a representation to the end user. A REST API builds all this together:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/jimmybogard/files/2016/05/image_thumb.png" width="642" height="251" />](https://lostechies.com/jimmybogard/files/2016/05/image.png)

In hypermedia APIs I build, the resource state combines multiple entities together from one or more data sources into the state of the resource. This plus links, forms a queries makes a “resource”, though it’s still a bit more abstract than that. Finally I build out the representation, perhaps JSON API, HAL, Siren etc.

If I made my entities equivalent to resources, I’m likely forcing clients to make many round trips to all the entities they need, but even more, I’m directly exposing the implementation details of my service to the world. Perhaps I’m removing some fields here and there, but in reality this is only one step above handing clients a connection string to my database. Sure, it’s easy and convenient to expose entities directly as resources and representations, but there’s some serious coupling that comes with that choice that you must accept.

In my experience, if I approach the API design strictly from the client perspective, on what they’re trying to achieve and why, it’s actually quite rare that I arrive at an API design that is simply database CRUD exposed as HTTP. And Fielding was pleased, as this design most closely matches the everyday use of the web. Makes sense. That’s what REST is about – a set of architectural constraints describing basically, the web.