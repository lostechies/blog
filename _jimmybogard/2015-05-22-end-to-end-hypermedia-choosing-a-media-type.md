---
wordpress_id: 1124
title: 'End-to-End Hypermedia: Choosing a Media Type'
date: 2015-05-22T15:12:23+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1124
dsq_thread_id:
  - "3785488904"
categories:
  - REST
---
So you&#8217;ve decided to make the leap and build a hypermedia-rich API. Hopefully, this decision came from necessity and not boredom, but that&#8217;s a post for another day.

At this point, you&#8217;re presented with a bit of a problem. You have 3 main options for choosing/designing a media type:

  * Pick a standard
  * Design your own
  * Extend a standard

As much as possible, I&#8217;d try to go with a standards-based approach. People with much more time on their hands and much more passion for you have thought about these problems for years, and probably have thought about more scenarios than you&#8217;re thinking of right now.

Instead of choosing media types in a vacuum, how would one compare the capabilities and intentions of one media type versus another? One way is simply to look at the design goals of a media type. Another is to objectively measure the level of hypermedia support and sophistication of a media type, with [H Factor](http://amundsen.com/hypermedia/hfactor/):

> The H Factor of a media-type is a measurement of the level of hypermedia support and sophistication of a media-type. H Factor values can be used to compare and contrast media types in order to aid in selecting the proper media-type(s) for your implementation.

H-Factor looks at two types of support, links and control data, and different factors inside those.

<img class="alignnone" title="HTML H Factors" src="http://amundsen.com/images/hypermedia/hfactors-html.png" alt="" width="183" height="158" />

For example, HTML supports:

  * Embedding links
  * Outbound links
  * Templated queries (a FORM with GET)
  * Non-idempotent updates (a FORM with POST)
  * Control data for update requests
  * Control data for interface methods (POST vs GET)
  * Control data for links (link relations &#8211; rel attribute)

But doesn&#8217;t support:

  * Control data for read requests &#8211; links can&#8217;t contain accept headers, for example
  * Support for idempotent updates &#8211; you have to use XHR for PUT/DELETE

With the quantitative and qualitative aspects factored in with client needs, you&#8217;ll have what you need to pick a media type. Unless you&#8217;ve already decided that this is all way too complex and run back to POJSOs, which is still perfectly acceptable.

### Making the choice

There are a \*ton\* of popular, widely used, hypermedia-rich media types out there:

  * [HAL](http://stateless.co/hal_specification.html)
  * [Collection+JSON](http://amundsen.com/media-types/collection/)
  * [Siren](https://github.com/kevinswiber/siren)
  * [JSON API](https://github.com/kevinswiber/siren)
  * [Hydra and JSON-LD](http://www.markus-lanthaler.com/hydra/)

And probably a dozen others. At this point, just be warned, you&#8217;ll probably spend upwards of a week or so to decide which variant you like best based on your client&#8217;s needs. You also don&#8217;t need to decide a single media type &#8211; you can use collection+json for collections of things, and HAL for single entities if you like.

One other thing I found is no single media type had all the pieces I needed. In my real-world example, I chose collection+json because my client mainly displayed collections of things. Show a table, click an item, then display a single thing with a table of related things. It didn&#8217;t need PUT/DELETE support, or some of the other control data. I just needed control data for links and a way to distinguish queries versus forms.

But collection+json didn&#8217;t \*quite\* have all the things I needed, so I wound up extending it for my own purposes, which I&#8217;ll go into in the next post.