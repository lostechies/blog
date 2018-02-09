---
wordpress_id: 959
title: The value proposition of Hypermedia
date: 2014-09-23T14:13:13+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=959
dsq_thread_id:
  - "3046113682"
categories:
  - Architecture
  - REST
---
REST is a [well-defined architectural style](http://en.wikipedia.org/wiki/Representational_state_transfer), and despite many misuses of the term towards general Web APIs, can be a very powerful tool. One of the constraints of a REST architecture is [HATEOAS](http://en.wikipedia.org/wiki/HATEOAS), which describes the use of [Hypermedia](http://en.wikipedia.org/wiki/Hypermedia) as a means of navigating resources and manipulating state.

It’s not a particularly difficult concept to understand, but it’s quite a bit more difficult to choose and implement a hypermedia strategy. The obvious example of hypermedia is HTML, but even it has its limitations.

But first, when is REST, and in particular, hypermedia important?

For the vast majority of Web APIs, hypermedia is not only inappropriate, but complete overkill. Hypermedia, as part of a self-descriptive message, includes descriptions on:

  * Who I am
  * What you can do with me
  * How you can manipulate my state
  * What resources are related to me
  * How those resources are related to me
  * How to get to resources related to me

In a typical web application, client (HTML + JavaScript + CSS) are developed and deployed at the same time as the server (HTTP endpoints). Because of this acceptable coupling, the client can “know” all the ways to navigate relationships, manipulate state and so on. There’s no downside to this coupling, since the entire app is built and deployed together, and the same application that serves the HTTP endpoints also serves up the client:

[<img style="padding-top: 0px; padding-left: 0px; padding-right: 0px; border: 0px;" src="http://lostechies.com/jimmybogard/files/2014/09/image_thumb.png" alt="image" width="244" height="219" border="0" />](http://lostechies.com/jimmybogard/files/2014/09/image.png)

For clients whose logic and behavior are served by the same endpoint as the original server, there’s little to no value in hypermedia. In fact, it adds a lot of work, both in the server API, where your messages now need to be self-descriptive, and in the client, where you need to build behavior around interpreting self-descriptive messages.

### 

### Disjointed client/server deployments

Where hypermedia really shines are in cases where clients and servers are developed and deployed separately. If client releases aren’t in line with server releases, we need to decouple our communication. One option is to simply build a well-defined protocol, and don’t break it.

That works well in cases where you can define your API very well, and commit to not breaking future clients. This is the approach the Azure Web API takes. It also works well when your API is not meant to be immediately consumed by human interaction – machines are rather lousy at understanding following links, relations and so on. Search crawlers can click links well, but when it comes to manipulating state through forms, they don’t work so well (or work too well, and we build CAPTCHAs).

No, hypermedia shines in cases where the API is built for immediate human interaction, and clients are built and served completely decoupled from the server. A couple of cases could be:

[<img style="padding-top: 0px; padding-left: 0px; padding-right: 0px; border: 0px;" src="http://lostechies.com/jimmybogard/files/2014/09/image_thumb1.png" alt="image" width="244" height="225" border="0" />](http://lostechies.com/jimmybogard/files/2014/09/image1.png)

Deployment to an app store can take days to weeks, and even then you’re not guaranteed to have all your clients at the same app version:

[<img style="padding-top: 0px; padding-left: 0px; padding-right: 0px; border: 0px;" src="http://lostechies.com/jimmybogard/files/2014/09/image_thumb2.png" alt="image" width="244" height="235" border="0" />](http://lostechies.com/jimmybogard/files/2014/09/image2.png)

Or perhaps it’s the actual API server that’s deployed to your customers, and you consume _their_ APIs at different versions:

[<img style="padding-top: 0px; padding-left: 0px; padding-right: 0px; border: 0px;" src="http://lostechies.com/jimmybogard/files/2014/09/image_thumb3.png" alt="image" width="244" height="226" border="0" />](http://lostechies.com/jimmybogard/files/2014/09/image3.png)

These are the cases where hypermedia shines. But to do so, you need to build generic components on the client app to interpret self-describing messages. Consider [Collection+JSON](http://amundsen.com/media-types/collection/format/):

{% gist 1b9aa1f35d78316e1006 %}

Interpreting this, I can build a list of links for this item, and build the text output and labels. Want to change the label shown to the end user? Just change the “prompt” value, and your text label is changed. Want to support internationalization? Easy, just handle this on the server side. Want to provide additional links? Just add new links in the “links” array, and your client can automatically build them out.

In one recent application, we built a client API that automatically followed first-level item collection links and displayed the results as a “master-detail” view. A newer version of the API that added a new child collection didn’t require any change to the client – the new table automatically showed up because we made the generic client controls hypermedia-aware.

This did require an investment in our clients, but it was a small price to pay to allow clients to react to the server API, instead of having their implementation coupled to an understanding of the API that could be out-of-date, or just wrong.

The rich hypermedia formats are quite numerous now:

  * Collection+JSON
  * [Siren](https://github.com/kevinswiber/siren)
  * [HAL](https://tools.ietf.org/html/draft-kelly-json-hal-06)
  * [JSON API](http://jsonapi.org/)

The real challenge is building clients that can interpret these formats. In my experience, we don’t really need a generic solution for interaction, but rather individual components (links, forms, etc.) The client still needs to have some “understanding” of the server, but these can instead be in the form of metadata rather than hard-coded understanding of raw JSON.

Ultimately, hypermedia matters, but in far fewer places than are today incorrectly labeled with a “RESTful API”, but is not entirely vaporware or astronaut architecture. It’s somewhere in the middle, and like many nascent architectures (SOA, Microservices, Reactive), it will take a few iterations to nail down the appropriate scenarios, patterns and practices.