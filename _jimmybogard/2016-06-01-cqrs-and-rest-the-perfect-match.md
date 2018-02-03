---
wordpress_id: 1190
title: 'CQRS and REST: the perfect match'
date: 2016-06-01T20:02:13+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1190
dsq_thread_id:
  - "4875967233"
categories:
  - CQRS
  - DomainDrivenDesign
  - Microservices
  - REST
---
In many of my applications, the UI and API gravitate towards task-oriented UIs. Instead of “editing an invoice”, I “approve an invoice”, with specialized models, behaviors and screens just for accomplishing that task. But what happens when we move from a server-side application to one more distributed, to be accessed via an API?

In a [previous post](https://lostechies.com/jimmybogard/2016/05/12/entities-arent-resources-resources-arent-representations/), I talked about the difference between entities, resources, and representations. It turns out that by removing the constraint around entities and resources, it opens the door to REST APIs that more closely match how we’d build the UI if it were a completely server-side application.

With a server side application, taking the example of invoices, I’d likely have a page to view invoices:

<pre>GET /invoices</pre>

This page would return the table of invoices, with links to view invoice details (or perhaps buttons to approve them). If I viewed invoice details, I’d click a link to view a page of invoice details:

<pre>GET /invoices/684</pre>

Because I prefer task-based UIs, this page would include links to specific activities you could request to perform. You might have an Approve link, a Deny link, comments, modifications etc. All of these are different actions one could take with an invoice. To approve an invoice, I’d click the link to see a page or modal:

<pre>GET /invoices/684/approve</pre>

The URLs aren’t important here, I could be on some crazy CMS that makes my URLs “GET /fizzbuzzcms/action.aspx?actionName=approve&entityId=684”, the important thing is it’s a distinct URL, therefore a distinct resource and a specific representation.

To actually approve the invoice, I fill in some information (perhaps some comments or something) and click “Approve” to submit the form:

<pre>POST /invoices/684/approve</pre>

The server will examine my form post, validate it, authorize the action, and if successful, will return a 3xx response:

<pre>HTTP/1.1 303 See Other<br />Location: /invoices/684</pre>

The POST, instead of creating a new resource, returned back with a response of “yeah I got it, see this other resource over here”. This is called the “Post-Redirect-Get” pattern. And it’s REST.

### 

### CQRS and REST

Not surprisingly, we can model our REST API exactly as we did our HTML-based web app. Though technically, our web app was already RESTful, it just served HTML as its representation.

Back to our API, let’s design a CQRS-centric set of resources. First, the collection resource:

[gist id=f110119ca3477dfb080e1182d8c3022f]

I’m intentionally not using any established media type, just to illustrate the basics. No HAL or Siren or JSON-API etc.

Just like the HTML page, my collection resource could join in 20 tables to build out this representation, since we’ve already established there’s no connection between entities/tables and resources.

In my client, I can then follow the link to see more details about the invoice (or, alternatively, included links directly to actions). Following the details link:

[gist id=117b40caae49ca0433f4dd8726a79583]

I now include links to additional resources, which in the CQRS world, those additional resources are commands. And just like our HTML version of things, these resources can return hypermedia controls, or, in the case of a modal dialog, I could have embedded the hypermedia controls inside the original response. Let’s go with the non-modal example:

[gist id=e2aaefcf96fcd06e5c968d1205d3779a]

In my command resource, I include enough information to instruct clients how to build a response (given they have SOME knowledge of our protocol). I even include some display information, as I would have in my HTML version. I have an array of fields, only one in my case, with enough information to instruct something to render it if necessary. I could then POST information up, perhaps with my JSON structure or form encoded if I liked, then get a response:

[gist id=d993626f5d7790aa9c7c2c4c67b12984]

Or, I could have my command return an immediate response and have its own data, because maybe approving an invoice kicks off its own workflow:

[gist id=a1b8cf79b826a49ed1c033ed143ed7be]

In that example I could follow the location or the body to the approve resource. Or maybe this is an asynchronous command, and approval acceptance doesn’t happen immediately and I want to model that explicitly:

[gist id=a6966aac8094091f95084ccf3d41730c]

I’ve received your approval request, and I’ve accepted it, but it’s not created yet so try this URL after 2 minutes. Or maybe approval is its own dedicated resource under an invoice, therefore I can only have one approval at a time, and my operation is idempotent. Then I can use PUT:

[gist id=0687fd9c9eff973c28f794cab35bdc05]

If I do this, my resource is stored in that URL so I can then do a GET on that URL to see the status of the approval, and an invoice only gets one approval. Remember, PUT is idempotent and I’m operating under the resource identified by the URL. So PUT is only reserved for when the client can apply the request to **that resource**, not to some other one.

In a nutshell, because I can create a CQRS application with plain HTML, it’s trivial to create a CQRS-based REST API. All I need to do is follow the same design guidelines on responses, pay attention to the HTTP protocol semantics, and I’ve created an API that’s both RESTful and CQRSful.