---
wordpress_id: 808
title: 'How we do MVC &#8211; 4 years later'
date: 2013-07-17T14:59:11+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=808
dsq_thread_id:
  - "1506647413"
categories:
  - ASPNETMVC
---
I’ve taken something like a 3 year hiatus from web applications to work mostly on SOA/messaging systems using NServiceBus, and am recently back on an MVC project. Lots of things have changed, but a lot is still the same.

Most of what we were trying to do in MVC made it in to the core (strongly-typed views, input/output helpers, metadata-driven output etc.) I get lot of questions around AutoMapper – do we still use it and so on. Short answer is yes, long answer is “it depends”. Since AutoMapper is intended to remove code we would have already written, I find my usage of it to be the same, if that’s the code I’m intending to write.

So, in no particular order, some items that stood the test of time:

  * ViewModel pattern and 1:1 ratio from views to view models. It’s getting to the point where I’d rather have a view named after its view model than the action method
  * Display/Editor templated helpers. Though I don’t use MVC’s built-in model any more – they’re just not flexible enough. I’ll detail what we’re using instead.
  * Thin, light controllers. We refactor concepts mercilessly. It’s not just copy-paste duplication that kills – it’s pattern/concept duplication too.
  * No magic strings. Anywhere. No strings referring to controllers/actions/properties/anything that “actually” represents a type. We get 90% of the way there from MVC proper, and the rest comes from MVC futures (expression-based URL generation, including parameter evaluation)
  * Validation on your edit model&nbsp; &#8211; not your domain model. Unless your app is CRUD, having edit models represent activities/operations/commands and attaching validation to those is a big win. We’re using FluentValidation right now for that – more on that in a future post
  * Smart HTML generation. Using metadata – not the weird ModelMetadata, but type metadata to generate HTML. Testing for existence of validation attributes, getting values out of the attribute, and using that to display a jQuery mask. More on that soon.
  * Vertical slice testing by modeling via queries and commands. I don’t always go all the way up to the UI, but by modeling commands and queries explicitly, we can isolate behavior into what really matters and not worry about ActionResults and the like in our tests.
  * Child actions are your friend. Don’t smash too much into a single model, don’t use dictionary-based ViewData access etc. Don’t alter ViewData from an action filter, use a child action. If you use an action filter/ViewData approach, you basically give up the ability to cache automatically.
  * Template generation from metadata. FubuMVC has a great example of this – using model metadata to generate the JS templates. If you’re altering CSS classes manually (class=”datepicker”) you’re doing something wrong. Don’t make me think, you have the information in metadata, use it!
  * AutoMapper – we use it pretty extensively still. We’re starting to use reverse mapping for simple cases (which now has some support out of the box). What we’re not doing is ignoring what SQL is getting spit out on the other side. AutoMapper and lazy loading can be a hazardous combination – but honestly no more so than not using it.

Things that didn’t stand the test of time:

  * Subcontrollers, and to a much lesser extent, portable areas. Not bad ideas, but better solutions came along (child actions and NuGet)
  * Customizing pipeline in the action results. We had a project where we really, really wanted Fubu MVC’s concept of behavior pipelines. Limit what actually happens in the ActionResult’s ExecuteResult method. It should be simple. We switched to a mediator pattern, and our lives improved
  * Model binding that hits a database. Your controller action takes a domain object, bound automatically from the GUID passed in. It’s not composable, customizable and so on. Instead, a Query object works a lot better and plays nicely with your existing toolbelt.

That’s the short list at least. I want to go into more detail on some tooling choice changes, but that’ll wait until the next few posts.

What you don’t see here is any JavaScript stuff – to be honest, 4 years away from JS is a LONG LONG LONG time. This app isn’t JS-heavy, so I’m really not going to say anything one way or the other.

What’s on your list for how you’ve changed how you build MVC applications since the release of MVC 2?