---
id: 1102
title: CQRS with MediatR and AutoMapper
date: 2015-05-05T15:15:41+00:00
author: Jimmy Bogard
layout: post
guid: https://lostechies.com/jimmybogard/?p=1102
dsq_thread_id:
  - "3738402572"
categories:
  - Architecture
  - AutoMapper
  - CQRS
  - MediatR
---
[CQRS](http://martinfowler.com/bliki/CQRS.html) is a simple pattern &#8211; two objects for command/queries where once there was one. These days just about every system I build utilizes CQRS, as it&#8217;s a natural progression from refactoring your apps around the patterns arising from reads and writes. I&#8217;ve been refactoring a [Microsoft sample app](https://www.asp.net/mvc/overview/getting-started/getting-started-with-ef-using-mvc/creating-an-entity-framework-data-model-for-an-asp-net-mvc-application) to techniques I use on my apps (mainly because I want something public to look at for new projects) at [my github](https://github.com/jbogard/contosouniversity).

Remember, CQRS is not an architecture, it&#8217;s a pattern, which makes it very easy to introduce into your applications. You can use CQRS in some, most, or all of your application and it&#8217;s easy to move towards or away from.

Even in simple apps, I like to keep my read models separate from my write models, mainly because the demands for each are drastically different. Since CQRS is just a pattern, we can introduce it just by refactoring.

First, let&#8217;s look at refactoring a complex GET/read scenario.

### Read model

My initial controller action for a complex read is&#8230;well, complex:

[gist id=d809583b03588d7346d7]

In order to derive our read models, I center around building query objects and result objects. The Query model represents the &#8220;inputs&#8221; to the query and the Result model represents the &#8220;outputs&#8221; from the query. This also fits very well into the &#8220;one-model-in-one-model-out&#8221; concept I use in my apps these days.

Looking at our controller, the inputs are pretty obvious &#8211; it&#8217;s the parameters to the controller action!

[gist id=2c8bf619c85fa2d32432]

To make my life easier with this pattern, I&#8217;ll use [MediatR](https://github.com/jbogard/MediatR) as a simple means of providing a way to have &#8220;one model in goes to something to get one model out&#8221; without creating bloated service layers. Uniform interfaces are great!

The next piece I need are the output &#8211; the result. I take \*all\* the results, including those &#8220;ViewBag&#8221; pieces as the Result object from my query:

[gist id=c502586faa615f88da51]

Finally, I take the inside part of that controller action and place it in a handler that takes in a Query and returns a Result:

[gist id=aec78a82d3b563039338]

My handler now completely encapsulates the work to take the input and build the output, making it very easy to test the logic of my system. I can refactor the contents of this handler as much as I want and the external interface remains input/output. In fact, if I wanted to make this a view or stored procedure, my input/output and tests don&#8217;t change at all!

One slight change was to switch to AutoMapper projection at the bottom with the ProjectToPagedList method:

[gist id=d8dd8ad849c694e056df]

I build a few helper methods to project from a queryable to my read model. The [AutoMapper projections](https://github.com/AutoMapper/AutoMapper/wiki/Queryable-Extensions) completely bypass my write model and craft a query that only reads in the information I need for this screen:

[gist id=5274d054891faff12e9e]

Some folks prefer to create SQL Views for their &#8220;Read&#8221; models, but that seems like a lot of work. AutoMapper projections have the same concept of a SQL View, except it&#8217;s defined as a projected C# class instead of a SQL statement with joins. The result is the same, except I now define the projection once (in my read model) instead of twice in my model and in a SQL view.

My controller action becomes quite a bit slimmed down as a result:

[gist id=a1ae1deb98215699a81c]

Slimmed down to the point where my controller action is really just a placeholder for defining a route (though helpful when my actions do more interesting things like Toastr popups etc).

Now that we&#8217;ve handled reads, what about writes?

### Write models

Write models tend to be a bit easier, however, many of my write models tend to have a read component to them. The page with the form of data is still a GET, even if it&#8217;s followed by a POST. This means that I have some duality between GET/POST actions, and they&#8217;re a bit intertwined. That&#8217;s OK &#8211; I can still handle that with MediatR. First, let&#8217;s look at what we&#8217;re trying to refactor:

[gist id=9484ddb98e8fd69b7a26]

Ah, the notorious &#8220;Bind&#8221; attribute with magical request binding to entities. Let&#8217;s not do that. First, I need to build the models for the GET side, knowing that the result is going to be my command. I create an input for the GET action with the POST model being my result:

[gist id=acfd914107d6f39ff1c2]

One nice side effect of building around queries/commands is it&#8217;s easy to layer on tools like [FluentValidation](https://github.com/JeremySkinner/FluentValidation). The command itself is based on exactly what information is needed to process the command, and nothing more. My views are built around this model, projected from the database as needed:

[gist id=c7084b77d0d538fd7add]

Again, I skip the write model and go straight to SQL to project to my write model&#8217;s read side.

Finally, for the POST, I just need to build out the handler for the command:

[gist id=2559ed65a9b803407da4]

Okay so this command handler is very, very simple. Simple enough I can use AutoMapper to map values back in. Most of the time in my systems, they&#8217;re not so simple. Approving invoices, notifying downstream systems, keeping invariants satisfied. Unfortunately Contoso University is a simple application, but I could have something more complex like updating course credits:

[gist id=0d6efb06204b179501f9]

I have no idea why I&#8217;d need to do this action, but you get the idea. However complex my write side becomes, it&#8217;s scoped to this. In fact, I can often refactor my domain model to handle its own command handling:

[gist id=b3470afcf78167c3d845]

All the logic in processing the command is inside my domain model, fully encapsulated and unit-testable. My handler just acts as a means to get the domain model out of the persistent store. The advantage to my command handler now is that I can refactor towards a fully encapsulated, behavioral domain model without changing anything else in my application. My controller is none the wiser:

[gist id=36cc5ffae74307f17e01]

That&#8217;s why I don&#8217;t worry too much about behavioral models up front &#8211; it&#8217;s just a refactoring exercise when I see code smells pop up inside my command handlers. When command handlers get gnarly (NOT BEFORE), just push the behavior down to the domain objects as needed using decades-old [refactoring](http://refactoring.com/) [techniques](http://industriallogic.com/xp/refactoring/).

That&#8217;s it! MediatR and AutoMapper together to help refactor towards CQRS, encapsulating logic and behavior together into command/query objects and handlers. Our domain model on the read side merely becomes a means to derive projections, just as Views are means to build SQL projections. We have a common interface with one model in, one model out to center around and any cross-cutting concerns like validation can be defined around those models.