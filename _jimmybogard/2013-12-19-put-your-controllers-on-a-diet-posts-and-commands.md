---
wordpress_id: 844
title: 'Put your controllers on a diet: POSTs and commands'
date: 2013-12-19T04:24:35+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=844
dsq_thread_id:
  - "2059948100"
categories:
  - Architecture
  - ASPNETMVC
  - Patterns
---
Previous posts in this series: 

  * [Redux](https://lostechies.com/jimmybogard/2013/10/10/put-your-controllers-on-a-diet-redux/) 
      * [Defactoring](https://lostechies.com/jimmybogard/2013/10/22/put-your-controllers-on-a-diet-defactoring/) 
          * [A survey](https://lostechies.com/jimmybogard/2013/10/23/put-your-controllers-on-a-diet-a-survey/)
          * [GETs and queries](https://lostechies.com/jimmybogard/2013/10/29/put-your-controllers-on-a-diet-gets-and-queries/)</ul> 
        In the last post, we looked at encapsulating the interesting part of GET actions (taking request parameters and building a model) into individual encapsulated query objects and handlers. Not surprisingly, we’ll be using similar techniques on our POST side to handle form POSTs and actually…doing something with those results.
        
        There are a couple of things we need to deal with before we get to looking at going all the way to handlers. First, let’s review our POST action:
        
        {% gist 8016839 %}
        
        Ugh, what awful code! Well, not really. There’s nothing particularly smelly about this controller action in isolation. It’s got a few concerns going on:
        
          * Validation checking
          * Form handling
          * Success redirection
        
        Again, nothing really pushing us to refactor this code. If I had many of these actions, I might be inclined not to copy that “ModelState.IsValid” check all over the place. There are other things I’d like to not copy around, things like:
        
          * Authorization
          * Logging
          * Auditing
          * Eventing (i.e., processing side-effects or ancillary actions)
        
        The above controller action doesn’t look bad, but I often have to do activities across all my actions. So what are our options?
        
        First, we might look at filters. Authorization is built in to MVC as a filter, so that knocks that off the list. What about the others? Logging, auditing, and ancillary actions? Those all work well when I have a fully-built model , and some knowledge of what activity is being performed. Those are the kinds of activities that benefit by flowing through a common pinch-point, and the UI layer just doesn’t have the right hooks for us.
        
        But first, let’s get rid of that validation piece.
        
        ### 
        
        ### Client/server validation
        
        I’ve never really been a fan of client-side validation. It works well for simple cases, but I never want to be in the spot of writing my validation rules twice. At most, I want to write them once and have them perhaps generated to client-side rules.
        
        Luckily, a teammate already blogged [on a fantastic approach](http://timgthomas.com/2013/09/simplify-client-side-validation-by-adding-a-server/) where the general idea is to create an action filter that performs validation on the server side, and returns a JSON model (just ModelState as JSON) with the model properties and validation errors. Even redirects are returned as JSON instructions, so that the client only loses the form’s information on a successful POST.
        
        The end result is that any validation/ModelState/returning of a View goes away. More important, any concerns of having to rehydrate a model that went through the form POST cycle. The first model was built in our GET action, the query handler, but there’s no guarantee that the model bound from POST form variables can just be passed to the view. This technique skips all that messiness of model rehydration and lets us only focus on success.
        
        ### 
        
        ### Towards commands
        
        At this point, once I’ve removed all orthogonal concerns, I’m left with the “meat” of the action:
        
        {% gist 8034065 %}
        
        I could stop here as I’ve mentioned before, and most of the time, I do. But if I have even more things going on:
        
        {% gist 8034088 %}
        
        _And_ this sort of orthogonal code is spread across many actions, not refactorable into filters, then I really would rather have this sort of thing more easily composable. That’s exactly what a mediator and command pattern will give me. First, let’s define what a command and its handler are:
        
        {% gist 8034112 %}
        
        It might seem rather strange that commands always have a result, but it’s much, much easier to deal with side effects of commands through return parameters than through some other means (global registry, static field, re-querying some object, collecting parameter, etc.). For commands that create an item, I usually want to redirect to a screen showing that item, very easily accomplished when I can get the created item and as for its ID.
        
        This is a bit controversial, but don’t frankly care, as it’s the simplest thing that could possibly work. If I want to have a command that returns Void, I could steal a page from F# and have a Command base class that returns a Unit type:
        
        {% gist 8034139 %}
        
        Where the Unit type simply represents “Void” (which unfortunately in C# is “special”. The Action/Func divide is the result.)
        
        Our handler just moves the code out of the controller action into a handler:
        
        {% gist 8034260 %}
        
        The mediator now needs an additional method to be able to process commands:
        
        {% gist 8034270 %}
        
        Again, very similar to the Query method. I’ll leave out the implementation of our actual mediator implementation – it’s nearly identical to the Query example. So why two methods? Fairly simple – it’s a bit easier to deal with separate pipelines for queries and commands, as the potential extensions for these two pipelines might be different. I also might have different rules applied and so on.
        
        Finally, our controller in its entirety:
        
        {% gist 8034310 %}
        
        All very uniform, and completely pointless to test. In fact, my tests now focus on handlers, with simple model in/model out semantics. I don’t have to deal with action results, validation and so on. Each concern is separated into its own unit, composed together at runtime.
        
        Simpler? For many apps, no. For larger apps, this sort of pattern is extremely valuable, as adding features to an application results only in adding files (except for some links and that shared controller). It’s not an architecture I put into all my applications, far from it, but it’s worth keeping in mind when you want to keep those controllers lean.
        
        ### Where to from here
        
        That controller looks awfully pointless, no? Yes, and no. I still want somewhere where I can deal with actual UI concerns, and sometimes building out ActionResults is complicated. Doing something like “controller-less actions” doesn’t really help there.
        
        Otherwise, it’s worth looking at frameworks that directly support this sort of model of development, such as:
        
          * [Fubu MVC](http://mvc.fubu-project.org/)
          * [ServiceStack](https://servicestack.net/)
          * [NancyFx](http://nancyfx.org/)
          * [Simple.Web](https://github.com/markrendle/Simple.Web)
          * Others?
        
        If there’s one thing I want to leave readers with it’s this – this series of posts isn’t about a single pattern to rule them all. I only use these techniques when the code’s shape dictates it, but not before. Pay attention to those code smells, keep your design flat, and be very, very judicious with abstractions.