---
id: 414
title: 'Dependency Injection in ASP.NET MVC: Final Look'
date: 2010-06-02T02:17:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2010/06/01/dependency-injection-in-asp-net-mvc-final-look.aspx
dsq_thread_id:
  - "264789207"
categories:
  - ASPNETMVC
  - DependencyInjection
---
Other posts in this series:

  * [Controllers](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/04/26/dependency-injection-in-asp-net-mvc-controllers.aspx) 
  * [Contextual controller injection](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/04/28/dependency-injection-in-asp-net-mvc-contextual-controller-injection.aspx) 
  * [Filters](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/05/03/dependency-injection-in-asp-net-mvc-filters.aspx) 
  * [Action Results](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/05/04/dependency-injection-in-asp-net-mvc-action-results.aspx) 
  * [Views](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/05/19/dependency-injection-in-asp-net-mvc-views.aspx) 

In this series, we’ve looked on how we can go beyond the normal entry point for dependency injection in ASP.NET MVC (controllers), to achieve some very powerful results by extending DI to filters, action results and views.&#160; We also looked at using the modern IoC container feature of nested containers to provide injection of contextual items related to both the controller and the view.

In my experience, these types of techniques prove to be invaluable over and over again.&#160; However, not every framework I use is built for dependency injection through and through.&#160; That doesn’t stop me from getting it to work, in as many places as possible.

Why?

It’s really amazing how much your design changes once you remove the responsibility of locating dependencies from components.&#160; But instead of just talking about it, let’s take a closer look at the alternatives, from the ASP.NET MVC 2 source code itself.

### ViewResult: Static Gateways

One of my big beefs with the design of the ActionResult concept is that there are two very distinct responsibilities going on here:

  * Allow an action method to describe WHAT to do 
  * The behavior of HOW to do it 

Controller actions are testable because of the ActionResult concept.&#160; I can return a ViewResult from a controller action method, and simply test its property values.&#160; Is the right view name chosen, etc.

The difficulty comes in to play when it becomes harder to understand what is needed for the HOW versus the pieces describing the WHAT.&#160; From looking at this picture, can you tell me which is which?

[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="ClassDiagram1" src="http://lostechies.com/jimmybogard/files/2011/03/ClassDiagram1_thumb_58324789.png" width="455" height="277" />](http://lostechies.com/jimmybogard/files/2011/03/ClassDiagram1_44192B00.png) 

Offhand, I have no idea.&#160; The ViewName member I’m familiar with, but what about MasterName in the ViewResult class?&#160; Then you have a “FindView” method, which seems like a rather important method.&#160; The other pieces are all mutable, that is, read and write.&#160; Poring over the source code, none of these describe the WHAT, that’s just the ViewName and MasterName.&#160; Those are the pieces the ViewEngineCollection uses to find a view.

Then you have the View property which can EITHER be set in a controller action, or is dynamically found by looking at the ViewEngineCollection.&#160; So let’s look at that property on the ViewResultBase class:

<pre>[<span style="color: #2b91af">SuppressMessage</span>(<span style="color: #a31515">"Microsoft.Usage"</span>, <span style="color: #a31515">"CA2227:CollectionPropertiesShouldBeReadOnly"</span>,
    Justification = <span style="color: #a31515">"This entire type is meant to be mutable."</span>)]
<span style="color: blue">public </span><span style="color: #2b91af">ViewEngineCollection </span>ViewEngineCollection {
    <span style="color: blue">get </span>{
        <span style="color: blue">return </span>_viewEngineCollection ?? <span style="color: #2b91af">ViewEngines</span>.Engines;
    }
    <span style="color: blue">set </span>{
        _viewEngineCollection = <span style="color: blue">value</span>;
    }
}</pre>

[](http://11011.net/software/vspaste)

Notice the static gateway piece.&#160; I’m either returning the internal field, OR, if that’s null, a static gateway to a “well-known” location.&#160; Well-known, that is, if you look at the source code of MVC, because otherwise, you won’t really know where this value can come from.

So why this dual behavior?

Let’s see where the setter is used:

[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_733AF0CA.png" width="876" height="380" />](http://lostechies.com/jimmybogard/files/2011/03/image_7055B1E4.png) 

**The setter is used only in tests**.&#160; All this extra code to expose a property, this null coalescing behavior for the static gateway (referenced in 7 other places), all just for testability.&#160; Testing is supposed to IMPROVE design, not make it more complicated and confusing!

I see this quite a lot in the MVC codebase.&#160; Dual responsibilities, exposition of external services through lazy-loaded properties and static gateways.&#160; It’s a lot of code to support this role of exposing things JUST for testability’s sake, but is not actually used under the normal execution flow.

So what you wind up happening is a single class that can’t really make up its mind on what story it’s telling me.&#160; I see a bunch of things that seem to help it find a view (ViewName, MasterName), as well as the ability to just supply a view directly (the View property).&#160; I also see exposing through properties things I shouldn’t set in a controller action.&#160; I can swap out the entire ViewEngineCollection for something else, but really, is that what I would ever want to do?&#160; You have pieces exposed at several different conceptual levels, without a very clear idea on how the end result will turn out.

How can we make this different?

### 

### Separating the concerns

First, let’s separate the concepts of “I want to display a view, and HERE IT IS” versus “I want to display a view, and here’s its name”.&#160; There are also some redundant pieces that tend to muddy the waters.&#160; If we look at the actual work being done to render a view, the amount of information actually needed becomes quite small:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">NamedViewResult </span>: <span style="color: #6897bb">IActionMethodResult
</span>{
    <span style="color: blue">public string </span>ViewName { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
    <span style="color: blue">public string </span>MasterName { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }

    <span style="color: blue">public </span>NamedViewResult(<span style="color: blue">string </span>viewName, <span style="color: blue">string </span>masterName)
    {
        ViewName = viewName;
        MasterName = masterName;
    }
}

<span style="color: blue">public class </span><span style="color: #2b91af">ExplicitViewResult </span>: <span style="color: #6897bb">IActionMethodResult
</span>{
    <span style="color: blue">public </span><span style="color: #6897bb">IView </span>View { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }

    <span style="color: blue">public </span>ExplicitViewResult(<span style="color: #6897bb">IView </span>view)
    {
        View = view;
    }
}</pre>

[](http://11011.net/software/vspaste)

Already we see much smaller, much more targeted classes.&#160; And if I returned one of these from a controller action, there’s absolutely zero ambiguity on what these class’s responsibilities are.&#160; They merely describe what to do, but it’s something else that does the work.&#160; Looking at the invoker that handles this request, we wind up with a signature that now looks something like:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">NamedViewResultInvoker </span>: <span style="color: #2b91af">IActionResultInvoker</span>&lt;<span style="color: #2b91af">NamedViewResult</span>&gt;
    {
        <span style="color: blue">private readonly </span><span style="color: #2b91af">RouteData </span>_routeData;
        <span style="color: blue">private readonly </span><span style="color: #2b91af">ViewEngineCollection </span>_viewEngines;

        <span style="color: blue">public </span>NamedViewResultInvoker(<span style="color: #2b91af">RouteData </span>routeData, <span style="color: #2b91af">ViewEngineCollection </span>viewEngines)
        {
            _routeData = routeData;
            _viewEngines = viewEngines;
        }

        <span style="color: blue">public void </span>Invoke(<span style="color: #2b91af">NamedViewResult </span>actionMethodResult)
        {
            <span style="color: green">// Use action method result
            // and the view engines to render a view
</span></pre>

[](http://11011.net/software/vspaste)

Note that we only use the pieces we need to use.&#160; We don’t pass around context objects, whether they’re needed or not.&#160; Instead, we depend only on the pieces actually used.&#160; I’ll leave the implementation alone as-is, since any more improvements would require creation of more fine-grained interfaces.

What’s interesting here is that I can control how the ViewEngineCollection is built, however I need it built.&#160; Because I can now use my container to build up the view engine collection, I can do things like build the list dynamically per request, instead of the singleton manner it is now.&#160; I could of course build a singleton instance, but it’s now my choice.

The other nice side effect here is that my invokers start to have much finer-grained interfaces.&#160; You know exactly what this class’s responsibilities are simply by looking at its interface.&#160; You can see what it does and what it uses.&#160; With broad interfaces like ControllerContext, it’s not entirely clear what is used, and why.

For example, the underlying ViewResultBase only uses a small fraction of ControllerContext object, but how would you know?&#160; Only by investigating the underlying code.

### New Design Guidelines

I think a lot of the design issues I run into in my MVC spelunking excursions could be solved by:

  1. Close attention to SOLID design
  2. Following the Tell, Don’t Ask principle
  3. Favoring composition over inheritance
  4. Favoring fine-grained interfaces

So why doesn’t everyone just do this?&#160; Because design is _hard_.&#160; I still have a long ways to go, as my current AutoMapper configuration API rework has shown me.&#160; However, I do feel that careful practice of driving design through behavioral specifications realized in code (AKA, BDD) goes the farthest to achieving good, flexible, clear design.