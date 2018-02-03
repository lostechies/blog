---
wordpress_id: 893
title: Using AutoMapper to perform LINQ aggregations
date: 2014-04-08T16:41:57+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=893
dsq_thread_id:
  - "2596399875"
categories:
  - AutoMapper
  - EntityFramework
  - NHibernate
---
In the last post I showed how [AutoMapper and its LINQ projection can prevent SELECT N+1 problems](http://lostechies.com/jimmybogard/2014/04/03/using-automapper-to-prevent-select-n1-problems/) and other lazy loading problems. That was pretty cool, but wait, there’s more! What about complex aggregation? LINQ can support all sorts of interesting queries, that when done in memory, could result in really inefficient code.

Let’s start small, what if in our model of courses and instructors, we wanted to display the number of courses an instructor teaches and the number of students in a class. This is easy to do in the view:

[gist id=10147003]

But at runtime this will result in another SELECT for each row to count the items:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2014/04/image_thumb.png" width="527" height="155" />](http://lostechies.com/jimmybogard/files/2014/04/image.png)

We could eager fetch those rows ahead of time, but this is also less efficient than just performing a SQL correlated subquery to calculate that SUM. With AutoMapper, we can just declare this property on our ViewModel class:

[gist id=10149138]

AutoMapper can recognize extension methods, and automatically looks for System.Linq extension methods. The underlying expression created looks something like this:

[gist id=10149617]

LINQ providers can recognize that aggregation and use it to alter the underlying query. Here’s what that looks like in SQL Profiler:

[gist id=10150014]

That’s pretty cool, just create the property with the right name on your view model and you’ll get an optimized query built for doing an aggregation.

But wait, there’s more! What about more complex operations? It turns out that we can do whatever we like in MapFrom as long as the [query provider supports it](http://msdn.microsoft.com/en-us/library/bb738550(v=vs.110).aspx).

### Complex aggregations

Let’s do something more complex. How about counting the number of students whose name starts with the letter “A”? First, let’s create a property on our view model to hold this information:

[gist id=10151823]

Because AutoMapper can’t infer what the heck this property means, since there’s no match on the source type even including extension methods, we’ll need to create a [custom mapping projection using MapFrom](https://github.com/AutoMapper/AutoMapper/wiki/Projection):

[gist id=10152221]

At this point, I need to make sure I select the overloads for the aggregation methods that are supported by my LINQ query provider. There’s another overload of Count() that takes a predicate to filter items, but it’s not supported. Instead, I need to chain a Where then Count. The SQL generated is now efficient:

[gist id=10152788]

This is a lot easier than me pulling back _all_ students and looping through them in memory. I can go pretty crazy here, but as long as those query operators are supported by your LINQ provider, AutoMapper will pass through your MapFrom expression to the final outputted Select expression. Here’s the equivalent Select LINQ projection for the above example:

[gist id=10153174]

As long as you can LINQ it, AutoMapper can build it. This combined with preventing lazy loading problems is a compelling reason to go the view model/AutoMapper route, since we can rely on the power of our underlying LINQ provider to build out the correct, efficient SQL query better than we can. That, I think, is wicked awesome.