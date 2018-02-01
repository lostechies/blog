---
id: 419
title: 'Single Page Apps &#038; Realtime, a Love Story'
date: 2013-08-13T08:51:58+00:00
author: Chris Missal
layout: post
guid: http://lostechies.com/chrismissal/?p=419
dsq_thread_id:
  - "1603524233"
categories:
  - HTML5
  - JavaScript
---
This is the second in a series of articles on _Building Realtime HTML5 Apps_. In the first article, we looked at the difference between [Websockets and AJAX](http://lostechies.com/chrismissal/2013/08/06/browser-wars-websockets-vs-ajax/) as transport mechanisms for data. In this article, I wanted to explore why single page apps fit in so well with the new realtime paradigm.

### What&#8217;s a Single Page App?

In its most basic form a single page HTML5 app is a browser-based application that doesn&#8217;t do a full page refresh as the user interacts with the page. I like to think of it as the Web&#8217;s version of a native application. Each web page is its own app, and when you start thinking about things this way, you make the leap that the browser is really a first class application platform, and not just some glorified HTML container.

With this understanding, it makes sense to think about the most natural separation of concerns for this type of environment. Currently, MVC seems to be the prevailing paradigm for understanding the browser environment, however I think it makes sense to look at the browser more in terms of inputs and outputs:

#### Inputs

  * Data Inbound &#8211; Websockets, AJAX, etc, received from the server/cloud.
  * User/Device Interaction &#8211; Clicks, Taps, Camera, Microphone and other events you can react to.
  * Routes &#8211; A way to recreate state in your application through bookmarkable, shareable URLs.

#### Outputs

  * Data Outbound &#8211; Websockets, AJAX, etc sent to the server/cloud.
  * View Manipulation &#8211; Programmatic manipulation of the DOM.

In my opinion, this conception of the most important aspects of the browser environment fits in well with realtime data flows. Realtime data is asynchronous, and it can come from either the server or the browser. And since you can&#8217;t rely on the request/response cycle as with AJAX, it makes sense to worry about data flowing in and out of your application separately. It also makes sense to think of those data flows as first class concerns, instead of automatically hiding them behind a &#8220;model&#8221; abstraction as with MVC.

Single page HTML5 applications can do just about anything that a normal &#8220;website&#8221; can do. A great example of this in case you are unaware, is the new [HTML5 PushState](https://developer.mozilla.org/en-US/docs/Web/Guide/DOM/Manipulating_the_browser_history) standard, which allows you to update the address bar and browser history without ever refreshing the page.

But the more important question is, can a single page HTML5 app do anything that a &#8220;truly native&#8221; application can do?

### Persistent Connections: The Realtime Lifeline

Part of what keeps any realtime application &#8220;alive&#8221; is its persistent connection back to the server.

Even though single page HTML5 apps are highly transient (downloaded and installed in seconds or milliseconds), the applications themselves should strive for persistence. That is they should be robust. Especially, when you start looking at things from the perspective of mobile HTML5 applications. Intermittent connections are commonplace in mobile environments as users switch between WiFi, 3G, 4G, etc.

Because the connection is persistent with realtime, it is easier for a single page HTML5 app to make a decision about whether or not it&#8217;s connected back to the server. There is usually only one persistent connection to keep track of, instead of a slew of isolated AJAX requests.

### You Can&#8217;t Do Realtime without Single Page Apps

Realtime and single page apps are a great match out of necessity.

A Websocket connection does not persist across page reloads, so to get any benefit out of persistent WebSocket connections you need to be designing and building your Realtime HTML5 applications to be single page from the ground up. A hodge podge of page reloads and AJAX is not going to cut it. To make the next generation of great realtime applications, it helps to start looking at the browser as a truly first class application platform.

I will be posting another article in this series, _Building Realtime HTML5 Apps_, soon.

[<img class="alignleft  wp-image-403" title="Brad Carleton" src="http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot.jpg" alt="" width="156" height="156" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot.jpg 512w, http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot-150x150.jpg 150w, http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot-300x300.jpg 300w, http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot-100x100.jpg 100w" sizes="(max-width: 156px) 100vw, 156px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/brad-headshot.jpg)Brad is a badass JavaScript coder who enjoys building cool stuff and long walks on the beach. As the Founder/CTO at [TechPines](http://www.techpines.com "We Make Awesome Apps"), he has worked with large companies and startups to build cutting-edge applications based on HTML5 and Node.js. He is the creator of [Bone.io](http://bone.io "bone.io - Realtime Single Page HTML5 Apps"), a realtime HTML5 framework, and is the author of [Embracing Disruption: A Cloud Revolution Manifesto](http://embracingdisruption.com "embracing disruption a cloud revolution manifesto").