---
wordpress_id: 62
title: 'Handlers &#8211; A useful FubuMVC Convention'
date: 2011-07-26T21:08:01+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=62
dsq_thread_id:
  - "369346413"
categories:
  - general
tags:
  - conventions
  - fubumvc
---
> ## Update
> 
> These conventions have been pulled into FubuMVC.Core and are no longer in a separate repository.

## Background

One of the little known treasures of FubuMVC is its highly extensible route generation mechanism. The [default policy](http://lostechies.com/josharnold/2011/07/09/patterns-of-compositional-architecture-policies/#real-world) is great for most cases. But when it falls short, you get a chance to make use of this fantastic little gem: [IUrlPolicy](http://lostechies.com/josharnold/2011/07/09/patterns-of-compositional-architecture-policies/#urlpolicy).

So if the default policy (configured through the DSL) is great, where does it fall short? It’s not there’s anything wrong with using the DSL-based configuration for your routes. I just like to approach things a little differently.

## Routing by Feature/Story

Let me see if I can get point across nice and strong:

> I don’t like separating files that are closely related to each other. Period.

#### The Bad

First, I’ll give you an example of how I don’t like to do things:

[<img style="background-image: none; margin: 0px auto 24px; padding-left: 0px; padding-right: 0px; display: block; float: none; padding-top: 0px; border-width: 0px;" title="No Bueno" src="http://clayvessel.org/clayvessel/wp-content/uploads/2011/07/no-bueno_thumb.png" border="0" alt="No Bueno" width="234" height="142" />](http://clayvessel.org/clayvessel/wp-content/uploads/2011/07/no-bueno.png)

I’m not sure where this comes from – though my suspicions tell me that they stem from the understanding of separation of concerns as they relate to MVC. The idea here is that you have your controller in one folder, models in another folder, and views in yet another folder. This way you can run around your solution trying to find your files.

#### The Ugly

That isn’t even the core of the issue, though. Look at the Account directory under Views:

  * ForgotPassword
  * LogIn
  * PasswordReset
  * Verified

We can assume here that each one of those views has a corresponding GET and an optional POST method in the AccountController. These are related, yes, I’ll give you that. However, let me ask you this:

> If the logic of how passwords are reset changes, should you have to change anything for how you login?

Well, that’s debatable. I can see how you may have to change some logic to accommodate those logic changes. However, should be FORCED to if the logic remains the same?

My whole point is: why are these in the same class? And what’s the use of putting them into these arbitrary folders?

#### The Good

As I mentioned, I don’t like separating files. So what do I like? Let’s use the following url as an example:

> posts/2011/7/hello-world

Now let’s consider a new structure:

[<img style="background-image: none; margin: 0px auto 24px; padding-left: 0px; padding-right: 0px; display: block; float: none; padding-top: 0px; border: 0px;" title="all-good" src="http://clayvessel.org/clayvessel/wp-content/uploads/2011/07/all-good_thumb.png" border="0" alt="all-good" width="244" height="140" />](http://clayvessel.org/clayvessel/wp-content/uploads/2011/07/all-good.png)

#### The HandlersUrlPolicy:

Now we’ll walk through the important things here from the above diagram:

1. Handlers namespace and HandlersMarker

The HandlersMarker is a static type used to indicate the root of the Handlers namespace.

2. get\_Year\_Month\_Title\_handler class

This class exists within the Posts namespace. The HandlersUrlPolicy starts by building up routes based on namespacing (stripping away the root namespace as marked by the HandlersMarker). So for the Posts namespace, we start with “posts”.

The name of the handler is very important here and there are two ways to name your handlers: 1) Basic names or 2) Route-constrained names.

For both of these, the following rule is applicable:

> Your handlers must start with the HTTP verb they apply to (e.g., GET, POST)

#### Basic Names

<HTTP VERB>Handler (e.g., GetHandler)

The basic handler convention uses the current route definition and applies the appropriate HTTP constraint. So if you had a GetHandler under the Posts namespace, you would have: “posts/ (GET)”. Not helpful in this situation, but useful in others.

#### Route-contrained Names

<HTTP VERB>\_<PropertyName>\_handler (e.g., get\_Year\_Month\_Title\_handler)

When using this naming scheme, the HandlersUrlPolicy will apply route inputs and constraints to your route to build up pretty urls like our example from above:

> posts/2011/7/hello-world

The idea now is to have a Handler, input model, output model, and a view within the same namespace. Since the namespaces are used to make up the routes, you should be able to find these fairly easily.

## How do I use this?

This is part of FubuMVC.Core. As I mentioned earlier, the convention uses static types as a basis for determining the root namespaces for the routes. The extension method for applying this convention takes in a params Type[] markerTypes which allows you to pass in the types used to indicate these roots. You can take a look at the tests to see it in action.

Of course, an example would be (from within your FubuRegistry):

> ApplyHandlerConventions<MyHandlerMarker>()