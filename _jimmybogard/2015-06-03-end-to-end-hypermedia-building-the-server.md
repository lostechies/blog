---
wordpress_id: 1127
title: 'End-to-End Hypermedia: Building the Server'
date: 2015-06-03T17:26:30+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1127
dsq_thread_id:
  - "3818340520"
categories:
  - REST
---
In the [last post](https://lostechies.com/jimmybogard/2015/05/22/end-to-end-hypermedia-choosing-a-media-type/ "End-to-End Hypermedia: Choosing a Media Type"), we looked at choosing a hypermedia type. This isn&#8217;t the easiest of things to do, and can take quite a bit of effort to settle on a choice. On top of that, you very often need validation from a client consumer that your choice was correct. Unfortunately, even tools like [Apiary.io](https://apiary.io/) aren&#8217;t sufficient, you really need to build your API to validate your API.

This isn&#8217;t completely unexpected. If I&#8217;m building any sort of software the only way of proving it is what I need is to actually use it.

In our case, we choose [collection+json](http://amundsen.com/media-types/collection/) as our media type since we were mainly showing lists of things. It&#8217;s a fairly straightforward format, with out of the box support for ASP.NET Web API. There are a few NuGet packages that help with collection+json support:

  * CollectionJson.Server &#8211; includes a base controller class
  * CollectionJson.Client &#8211; includes a formatter
  * CollectionJson &#8211; just the object model with no dependencies

We first explored using these out-of-the-box, with the controller base class Server version:

[gist id=c2424a333f433cd84862]

If we were implementing a very pure version of collection+json, this might be a good route. However, not all of the HTTP methods were supported for our operations, so we wound up not using this one.

Next, we looked at the Client package, which includes a formatter and some extensions around HttpResponseMessages and the like. That worked best for us &#8211; we didn&#8217;t really need to extend the model to support extra metadata. I had thought we did, but looking back, we went through several iterations and finally landed on the stock collection+json model.

When looking at Web API extensions for hypermedia, I tend to see three sets of extensions:

  * Object model that represents the media type and is easily serializable
  * Helpers for inside your controller
  * Base controller classes

The code inside of these isn&#8217;t that much, so you can always just grab code from GitHub for your media type or roll your own object models.

### Building your models

The CollectionJson.Client package deals with two-way model building &#8211; writing documents and reading documents. Writing a document involves taking a DTO and building a collection+json document. Reading a document involves taking a collection+json document and building a model.

In my plain ol&#8217; JSON APIs, building a web API endpoint looks almost exactly like an MVC one:

[gist id=488a313beaf177b37cb8]

With building out documents, I need to take those DTOs and build out my representations  (my collection+json documents). The collection+json client defines two interfaces to help make this possible:

[gist id=98bdfa07252c95443704]

To make my life a bit easier, I created a mediator just for collection+json readers/writers, as I like to have a single point in which to request read/write documents:

[gist id=f77bfdb5cda46c23022e]

Once again we see that the Mediator pattern is great for turning types with generic parameters into methods with generic parameters. Our mediator implementation is pretty straightforward:

[gist id=eeca8faf72a31726ba99]

In our controllers, building out the responses is fairly easy now, we just add a step before our MediatR mediator:

[gist id=5ca693cdb1e55c2354ba]

The MediatR part will be the same as we would normally have. What we&#8217;ve added is our collection+json step of taking the DTO from the MediatR step and routing this to our collection+json document mediator. The document writer is then pretty straightforward too:

[gist id=eff42ed364600bff9637]

If you&#8217;ve followed my [conventional HTML](https://lostechies.com/jimmybogard/2013/07/18/conventional-html-in-asp-net-mvc-a-primer/ "Conventional HTML in ASP.NET MVC: A Primer") series, you might notice that the kind of information we&#8217;re putting into our collection+json document is pretty similar to the metadata we read when building out intelligent views. This helps close a gap I&#8217;ve found when building SPAs &#8211; I was much less productive building these pages than regular server-side MVC apps since I lost all that nice metadata that only lived on the server. [Pre-compiling views](https://lostechies.com/jimmybogard/2014/08/14/conventional-html-in-asp-net-mvc-client-side-templates/ "Conventional HTML in ASP.NET MVC: Client-side templates") can work, but additional metadata in hypermedia-rich media types works too.

For the write side, I could build something similar, including templates and the like. In fact, you can borrow our ideas from conventional HTML to build out helpers for our collection+json models. Since we have models built around read/write items:

[gist id=dbe8e99cc92cba7088de]

We can intelligently build out templates and data items:

[gist id=848d0139d374c24a56a7]

Our document writers start to look somewhat similar to our Razor views. On the document reader side, it&#8217;s a similar exercise of pulling information out of the document, populating a DTO and sending down the MediatR pipeline. Just the reverse of our GET actions.

Altogether not too bad with the available extensions, but building the server API is just half the battle. In the next post, we&#8217;ll look at building a consuming client.