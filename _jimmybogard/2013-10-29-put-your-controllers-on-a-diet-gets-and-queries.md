---
wordpress_id: 840
title: 'Put your controllers on a diet: GETs and queries'
date: 2013-10-29T13:37:57+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=840
dsq_thread_id:
  - "1914653903"
categories:
  - Architecture
  - ASPNETMVC
  - Design
---
Previous posts in this series:

  * [Redux](http://lostechies.com/jimmybogard/2013/10/10/put-your-controllers-on-a-diet-redux/)
  * [Defactoring](http://lostechies.com/jimmybogard/2013/10/22/put-your-controllers-on-a-diet-defactoring/)
  * [A survey](http://lostechies.com/jimmybogard/2013/10/23/put-your-controllers-on-a-diet-a-survey/)

In the last post, we surveyed the field to determine the path forward. Looking at our controller (and others), our controllers aren’t _too_ messy, but they’re well on their way. On top of that, testing is going to start to get annoying if I have any more things going on.

It was also clear once we defactored that there is a clear delineation between our GET and POST actions. This is natural, as GETs are a browser asking a server for information and a POST is a request to modify information or do something. Let’s take these one at a time.

### GETs to queries

Our GET actions are almost identical:

[gist id=7213782]

I take in some parameter from the action, use it to query the database, then map that result into a View Model. Finally, I pass that View Model into a ViewResult, and I’m done. As far as items I control, I see three distinct steps:

  1. Query database
  2. Build View Model
  3. Create ViewResult

If I were to pull things out of the controller action, which of these steps should I remove? Step 1 feels obvious, it has nothing to do with UI concerns. Step 3 seems like it should stay in the controller, since a ViewResult is a UI concern (and the method to easily build one resides in a base Controller class). What about Step 2?

For more complex models, I often have to compose several pieces together into one model. I might need to make more than one query to the database, or compose data from different services. Ultimately, this all results in one View Model. Since the View Model building can get complex and touch one or more backend services, I’ll also pull that out.

Let’s pull that piece out into a separate class, called “ShowHandler”, since it handles the bulk of the work of the Show action:

[gist id=7213918]

My controller action is now quite small and manageable:

[gist id=7213937]

The “_showHandler” variable is just a constructor injected instance of the ShowHandler class created above.

I like what we have so far, but I do foresee one problem here. If I get more parameters to my controller action, I’ll have to modify the signature of the Handle method. That can get annoying, so why don’t we create a class to represent the parameters of that call? And since we’re looking at “requests” of information, that pattern is typically called a Query. Our ShowQuery class now encapsulates that request for information:

[gist id=7213980]

The controller action can now take this query object as a parameter (also helping with refactoring efforts when we use parameter objects):

[gist id=7214007]

All my URLs still look the same, I’ve simply encapsulated all action parameters into a single type. This type is then passed all the way down to my handler:

[gist id=7214048]

I now have the querying to build a View Model completely encapsulated in a handler, and my controller is now responsible for delegation and ActionResult creation.

### Obligatory AutoMapper refactoring

Most folks probably guessed this, but let’s get rid of those calls to build up a View Model. I can use [AutoMapper](http://automapper.org/) and the [LINQ projection capabilities](https://github.com/AutoMapper/AutoMapper/wiki/Queryable-Extensions) to eliminate nearly all of the mapping code. After creating maps between my source/destination types, my handler starts to become pretty small:

[gist id=7214158]

After creating handlers for my other controller actions, they also become fairly small:

[gist id=7214211]

And my edit handler:

[gist id=7214283]

Queryable extensions project at the LINQ level, meaning it alters the actual query at the ORM layer (and eventually the SQL layer). I don’t return tracked entities, I project directly from SQL into a DTO. The Project().To<Foo> methods alter the expression tree created by IQueryable to include AutoMapper projections. Cool stuff!

Our controller actions are now small, and somewhat uniform:

[gist id=7214327]

However, something’s still a bit off. We have to take all these handlers as constructor arguments, and that will get annoying. What I’d rather do is not depend directly on handlers, but instead shoot the query off to…something…and have that something return my result. I want something to mediate between my request for information and the handler getting the result. Sounds like the [Mediator pattern](http://www.oodesign.com/mediator-pattern.html)!

### Mediators and diminutive buses

If we want to pull all our queries behind a common abstraction, we first need to make sure all of our query handlers “look the same”. With our introduction of a query object, they all have the basic form of “class with one public method, one input and one output”. For the lazy, this pattern is already abstracted into the [ShortBus](https://github.com/mhinze/ShortBus) project from [Matt Hinze](http://lostechies.com/matthinze/). I don’t feel lazy, so let’s just build this from scratch. We’ll first create an interface representing our queries:

[gist id=7214493]

This is the interface our query objects will use, with a generic parameter annotating what result this query will represent. Next, an interface to represent our query handlers:

[gist id=7214522]

Finally, our mediator interface:

[gist id=7214547]

I’ll leave it as an exercise to the reader to implement our mediator, or just grab the ShortBus code/NuGet goodness. Our ShowQuery becomes:

[gist id=7214582]

And the handler doesn’t change except for an interface implementation:

[gist id=7214595]

Repeating this exercise for all of my queries/handlers, our controller starts to look pretty darn good:

[gist id=7214645]

That’s pretty much it! I might have other UI concerns going in my controller action, but the work to actually take the request and build a model is behind a uniform interface, mediated through our mediator, and easily testable in isolation from any UI work that needs to happen.

At this point, I’d likely give a hard look at [feature folders in ASP.NET MVC](http://timgthomas.com/2013/10/feature-folders-in-asp-net-mvc/). This class explosion is necessary to decompose my application into distinct, well-defined parts, but having too many “EditQuery” objects in one folder is annoying. Putting each view/query/handler/view model in a common controller folder is a path to sanity.

Next up: POST actions.