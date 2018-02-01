---
id: 408
title: 'Browser Wars: Websockets vs. AJAX'
date: 2013-08-06T10:07:29+00:00
author: Chris Missal
layout: post
guid: http://lostechies.com/chrismissal/?p=408
dsq_thread_id:
  - "1574758009"
categories:
  - HTML5
  - JavaScript
---
This is the first in a series of articles on _Building Realtime HTML5 Apps_. I recently created a new framework called [bone.io](http://bone.io), and I wanted to share my thoughts and ideas on building realtime web applications.

This series is going to be less of a how-to guide, and more of a 30,000 foot view of the realtime web and the potential for the next generation of web applications.

### A Brief History of Websockets

Websockets is a new standard from 2011, that hopes to bring realtime (technically, &#8220;near-realtime&#8221;) communication to the web.

> Websockets provide full-duplex communication channels over a single TCP connection.

As of this writing, every major browser supports Websockets, except for Android. And thanks to some great open source libraries like [socket.io](http://socket.io), there are transparent fallback mechanisms for older browsers, like AJAX long-polling and Flash.

The fact that a Websocket is a fully bi-directional communication channel between the browser and server immediately opens up some very interesting opportunities for web applications. Because the connection is persistent, the _server_ can now _initiate communication with the browser_. The server can send alerts, updates, notifications. This adds a whole new dimension to the types of applications that can be constructed.

Outside the scope of browser-based applications, Websockets are a boon to the [Internet of Things](http://en.wikipedia.org/wiki/Internet_of_Things). End devices attached to the Internet now have a way of maintaining bi-directional communication channels to the their command and control servers, whether this is a thermometer that&#8217;s part of a connected home experience, or a fleet of nodecopters [terrorizing an apartment](http://vimeo.com/51826336).

The future is bright for Websockets technology, but the question remains, will it become the dominant mechanism for transporting data across the Internet? Will it replace AJAX?

### The Story of AJAX

The story of [AJAX](http://en.wikipedia.org/wiki/Ajax_%28programming%29) is more of a traditional web story, an accidental invention that has been used/abused beyond it&#8217;s original conception.

AJAX gives web browsers the ability to fetch data from the server without refreshing the entire page. It had its beginnings back in 1999 as a proprietary extension to Internet Explorer 5. Mozilla, following Internet Explorer&#8217;s lead, created a similar API for their browser, which soon made AJAX a de facto standard.

As web applications have moved from the server to the browser, AJAX has become the primary transport mechanism for data. This concept has been pushed further by browser-based application frameworks like [Backbone](http://backbonejs.org) and [Angular](http://angularjs.org) which rely heavily on AJAX for data communication.

Beyond the AJAX technology itself, a standardization has emerged in the industry around [REST](http://en.wikipedia.org/wiki/Representational_state_transfer) as the primary architectural style for developing browser-based applications (and web-based APIs). REST is based almost entirely on the semantics of the web, and it has helped usher in the resurgence of parts of the Web standard that had largely been abandoned or forgotten, for example the use of HTTP verbs `PUT`, `PATCH`, and `DELETE`.

### &#8220;Live&#8221; Applications, &#8220;Hot&#8221; Data

Largely, I think the question of Websockets vs. AJAX comes down to what types of applications and user interfaces we will be building in the future.

Most web applications currently operate by simply responding to user interaction. You click a button, called &#8220;Next&#8221;, and this causes the browser to fetch the next data set, and then render that to the page. This is great, but it&#8217;s still a very limiting model.

Websockets have the potential to not only connect end users to the server, but also to each other, the Cloud, and the entire [Internet of Things](http://en.wikipedia.org/wiki/Internet_of_Things) in ways not thought of before. As time goes on, the applications we build will literally come &#8220;alive&#8221; with data, and that connection via Websockets back to the server will help provide a stable platform for an endless array of interesting interactions.

The idea of having &#8220;hot&#8221; data streaming in and out of the browser will become the &#8220;norm&#8221; instead of the exception. Developers will be able to construct Gmail and Facebook-like functionality without a billion dollar investment. Thanks to open web standards, the power of Websockets will truly help bring application development to the next level.

### The Myth of the Request/Response Cycle

The request/response cycle that we are so heavily reliant on in the web development world is largely a myth. In reality, the browser and the server are two asynchronous nodes in a network. A request does not guarantee a response.

In point of fact, the entire AJAX protocol could be built using Websockets technology. This makes Websockets a literal superset of AJAX. So it makes sense that we might abandon a limiting technology for a broader technology.

### Embracing Bi-Directional Communication

I think that while REST/AJAX has served the web community well, it is probably time to start looking ahead to the future. And while it might be tempting at first to try to fit Websockets into the REST architecture that we are all so familiar with, I think that ultimately this will prove to be limiting. I think the best approach is to embrace realtime communication as a new development paradigm, and see what interesting ideas and patterns we can come up with based on this new concept.

I&#8217;m excited to post my first article on LosTechies! I know I am in the company of some truly incredible individuals, and much thanks to Chris for posting for me.

Also, when it comes out, checkout the next article in this series, _Building Realtime HTML5 Apps_!

[<img class="alignleft  wp-image-403" title="Brad Carleton" src="http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot.jpg" alt="" width="156" height="156" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot.jpg 512w, http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot-150x150.jpg 150w, http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot-300x300.jpg 300w, http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot-100x100.jpg 100w" sizes="(max-width: 156px) 100vw, 156px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot.jpg)Brad is a badass JavaScript coder who enjoys building cool stuff and long walks on the beach. As the Founder/CTO at [TechPines](http://www.techpines.com "We Make Awesome Apps"), he has worked with large companies and startups to build cutting-edge applications based on HTML5 and Node.js. He is the creator of [Bone.io](http://bone.io "bone.io - Realtime Single Page HTML5 Apps"), a realtime HTML5 framework, and is the author of [Embracing Disruption: A Cloud Revolution Manifesto](http://embracingdisruption.com "embracing disruption a cloud revolution manifesto").