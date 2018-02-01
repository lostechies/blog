---
id: 425
title: Realtime User Interface Design
date: 2013-08-20T09:10:06+00:00
author: Chris Missal
layout: post
guid: http://lostechies.com/chrismissal/?p=425
dsq_thread_id:
  - "1620757578"
categories:
  - HTML5
  - JavaScript
  - JQuery
  - Open Source
---
By [Brad Carleton](http://twitter.com/techpines)

This is the third installment in a series on _Building Realtime HTML5 Apps_. Most of the thoughts and ideas from these articles stem from my experience building [bone.io](http://bone.io), a realtime javascript framework. The previous articles focused on [Websockets vs AJAX](http://lostechies.com/chrismissal/2013/08/06/browser-wars-websockets-vs-ajax/) and [Single Page Apps & Realtime](http://lostechies.com/chrismissal/2013/08/13/single-page-apps-realtime-a-love-story/). This article will focus primarily on understanding Realtime User Interface Design as opposed to MVC for browser-based applications.

## The Evolution of the Browser

As web applications have moved from the server to the browser, there have been a few important milestones in how we think about browser-based applications. Now obviously this evolution has been complex with many actors, organizations, and open source projects, but I&#8217;m going to try and condense it down a bit for clarity&#8217;s sake.

The first major advancement was the introduction of [jQuery](http://jquery.com/) and other cross-browser DOM manipulation libraries. This allowed developers to program functionality into the browser with relative confidence that their code would work across the Web. A proliferation of plugins and other goodies soon popped up which made the Web a fertile playground for interactivity.

The next major advancement in front-end development was the MVC-based frameworks that were able to abstract DOM manipulation and data retrieval into a broader structure. This gave developers the opportunity to build larger more complex browser-based applications, and was brought about mainly by libraries such as [Backbone](http://backbonejs.org/) and [Angular](http://angularjs.org/).

As the HTML5 specification grows in features and complexity, what are the paradigms and philosophies that will help deliver the next generation of applications?

## The Case against MVC in the Browser

I don&#8217;t believe that MVC is the best paradigm for understanding and structuring browser-based applications. The usefulness of the &#8220;Model&#8221; as a first class concept in the browser doesn&#8217;t make sense in many circumstances, especially when the data involved is _transient_ in nature. If your main goal is to get &#8220;hot&#8221; data to the DOM, then the added abstraction layer of a &#8220;Model&#8221; often gets in the way of what you want to do.

For instance, let&#8217;s take a real life example, &#8220;Google&#8221; search.

Does the MVC architecture really describe this model of user interaction well?

![google-search](http://cdn.techpines.io/google-search.png)

If I had to break this &#8220;Google&#8221; search box into its separate concerns, here is how I would describe it:

  1. **[DOM Event]**: A user interacts with the Search Box by Pressing Keys on the Keyboard
  2. **[Data Out]**: When a Keyboard Interaction Occurs, contents of the Text Box are sent to the Server
  3. **[Data In]**: Receive Search Results from the Server
  4. **[DOM Manipulation]**: Render Search Results to the Search Results Box for the user to see

In this example, you don&#8217;t really &#8220;care&#8221; about the data for the Search Box, because the data itself is transient and volatile. You just care about rendering meaningful search results as fast as the user can type.

For this reason, I feel like the following diagram, the **view.io** pattern, provides a better framework for understanding the &#8220;Google&#8221; search box.

![view.io](http://cdn.techpines.io/view.io.png)

The &#8220;Google&#8221; search example can be generalized to be largely &#8220;data-agnostic&#8221;, maybe it&#8217;s a search for books, condos, web pages, whatever. &#8220;Modeling&#8221; the search results or the text box that generates them is largely irrelevant.

## How we access Data, Drives how we build Applications

In a lot of ways, how we access data drives how we build our applications. For example:

  * A search box is most likely powered by a Search Backend (maybe [Lucene](http://lucene.apache.org/) or [ElasticSearch](http://www.elasticsearch.org/))
  * A data table is likely powered by a SQL database (maybe [MySql](http://www.mysql.com/) or [Postgres](http://www.postgresql.org/))
  * An activity stream is likely powered by a NoSQL database (maybe [Cassandra](http://cassandra.apache.org/) or [Redis](http://redis.io/))

In all of these instances, a generic user interface component largely drives the selection of the underlying &#8220;database&#8221; technology. As long as the server can send data in a format that fits the &#8220;search box&#8221; model or the &#8220;data table&#8221; model, then it can easily be rendered onto the DOM.

Therefore, when working on realtime HTML5 applications, I believe it is a better approach to construct applications in terms of &#8220;data-agnostic&#8221; user interface components. Components that can be easily reused, regardless of the different types of data flowing through them.

I hope you enjoyed this article, and please read the next in the series on _Building Realtime HTML5 Apps_.

[<img class="alignleft  wp-image-403" title="Brad Carleton" src="http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot.jpg" alt="" width="156" height="156" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot.jpg 512w, http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot-150x150.jpg 150w, http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot-300x300.jpg 300w, http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot-100x100.jpg 100w" sizes="(max-width: 156px) 100vw, 156px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot.jpg)Brad is a badass JavaScript coder who enjoys building cool stuff and long walks on the beach. As the Founder/CTO at [TechPines](http://www.techpines.com "We Make Awesome Apps"), he has worked with large companies and startups to build cutting-edge applications based on HTML5 and Node.js. He is the creator of [Bone.io](http://bone.io "bone.io - Realtime Single Page HTML5 Apps"), a realtime HTML5 framework, and is the author of [Embracing Disruption: A Cloud Revolution Manifesto](http://embracingdisruption.com "embracing disruption a cloud revolution manifesto").