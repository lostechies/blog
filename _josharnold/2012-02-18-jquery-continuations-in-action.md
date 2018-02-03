---
wordpress_id: 153
title: jQuery.continuations In Action
date: 2012-02-18T06:20:02+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=153
dsq_thread_id:
  - "580545992"
categories:
  - general
tags:
  - conventions
  - fubu
  - jquery-continuations
---
I’ve been getting quite a few questions about jQuery.continuations after my last round of posts and the lightning round I gave at ADNUG last month. I have this horrible habit of pretending that I’m a lot more articulate than I really am. Obviously my last few posts didn’t do this library any justice.

I think [Jimmy](http://lostechies.com/jimmybogard/) put it the best when he said: “Yeah, I read your posts but there just wasn’t a whole lot of code”. So this time I’m going to write a post that’s mostly code and see if it helps.

## Show me something concrete

Let’s start with an example and then I’ll explain what’s going on:



If you run this example, you’ll be shown a dialog. Clicking “Success” or “Failure” will demonstrate the behavior of a successful or failed http post (respectively).

> NOTE:
  
> I’ve noted this in the code several times but here it is again: don’t bother with the “Server” stuff. It’s just a helper to mock the ajax calls since we’re not using a server here.

### Custom options

We are making use of the correlatedSubmit method here (an extension to jquery.forms). Notice that we’re passing in the custom “closeDialog” property.

Passing in a hash to correlatedSubmit or as the “options” property of the hash to $.ajax provides a local set of custom options that are made available during the processing of the clientside continuation.

Great, what does that mean? Well, here’s how this works:



Whenever a continuation is received (via the success callback from $.ajax), this custom dialog policy will be inspected. Notice that we’re matching against “continuation.options.closeDialog”. The options property of the continuation contains the same options that you passed in so in this case, “closeDialog” would be true.

> Note:
  
> My first pass at this didn’t have these custom options and our conventions were ALWAYS global. You should ask [Jeremy](https://twitter.com/#!/jeremydmiller) what he thought about that.

In case you missed the point here, our policy conventionally closes a jquery ui dialog when the response was successful.

### Reusable conventions

Conventions are only “conventions” when they’re reusable. Reusable pieces of code really strut their value when they’re reusable in more than one project.

The “Failure” button demonstrates a failed continuation response from the server. fubuvalidation-js has a built-in convention for detecting those errors and rendering them into the form that originated the request. So simply including fubuvalidation-js into this jsfiddle was enough to get that to work.

### From client to server

The validation and “close dialog” policies are pretty useful. For us, they’re very useful because we use them throughout our app. These are just two simple examples of what can be done here. Let’s brainstorm a few more to make sure I’m articulating the power of this correctly:

  * Refresh the page (force a full refresh on certain conditions)
  * Redirect to a new url
  * Display errors (“something went terribly wrong”)
  * Keep track of pending ajax requests

The list goes on and on but let’s talk about this “redirect to a new url” idea.

### APIs and Continuations

A common technique found in HTTP-based APIs is to provide a set of information regarding a resource when it is created. For example, “POST /users/create” may return things like:

  * The ID of the User
  * Some urls (e.g., “go here to view the details”, “go here to edit the user”

If you design your endpoints to follow a similar technique, you can plugin policies that use the response and orchestrate the behavior of your system from a central block of code. Of course, in small applications this doesn’t pay off but in large and complex systems the value starts to shine.

## Wrapping it up

Hopefully the code speaks for itself and this sparks a few ideas.