---
wordpress_id: 329
title: How we do MVC – View models
date: 2009-06-30T03:06:36+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/06/29/how-we-do-mvc-view-models.aspx
dsq_thread_id:
  - "264716207"
categories:
  - ASPNETMVC
  - AutoMapper
redirect_from: "/blogs/jimmy_bogard/archive/2009/06/29/how-we-do-mvc-view-models.aspx/"
---
A while back, I went over a few of the patterns and opinions we’ve gravitated towards on our current large-ish ASP.NET MVC project, or, [how we do MVC](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/04/24/how-we-do-mvc.aspx).&#160; Many of these opinions were forged the hard way, by doing the wrong thing many times until we found the “right” opinion.&#160; Of course, many of these opinions are only really valid in the constraints of our project.&#160; While the domain of this project isn’t important, here are some key aspects to consider:

  * AJAX is used very, very sparingly.&#160; Section 508 compliance is required
  * XHTML compliance is also required
  * XHTML DTD validation is also required
  * All (well, 99%) operations revolve a single uber-entity.&#160; Think customer relationship management, where everything you do deals with exactly one customer
  * Snippets of information repeated across many screens
  * Screens are either edit, or view, but never both.&#160; (99% never)

Given these constraints, these opinions may or may not apply to the project you work on.&#160; Again, patterns are all about tradeoffs, benefits and liabilities.&#160; But, opinionated software is like building a bullet train.&#160; It goes extremely fast, but only in the direction you build it.

That said, I’m going to go over some of the main aspects of our MVC usage in a series of posts – starting with ViewModels.

### ViewModel design

For our application, the ViewModel is a central aspect of our MVC architecture.&#160; One of the first dilemmas facing MVC developers is to decide what the “M” in MVC means in ASP.NET MVC.&#160; In Rails, this is fairly clear, the M is ActiveRecord (by default).&#160; But in ASP.NET MVC, the “M” is silent!&#160; Its out-of-the-box architecture offers no guidelines nor advice on what the M should be.&#160; Should it be an entity?&#160; Data access object?&#160; DTO?&#160; Something else?

> Sidenote – the term DTO is far overused.&#160; DTO is a [Data Transfer Object](http://martinfowler.com/eaaCatalog/dataTransferObject.html).&#160; The pattern describes the usage, not the shape of a type.&#160; Just because an object is all properties and no methods does NOT mean it’s a DTO.

For us, the ViewModel is inextricably linked to Views, which leads us to our first rule:

**Rule #1 – All Views are strongly-typed**

I think I’ve gone over this one enough, as I really can’t stand magic strings and loose contracts.&#160; A dictionary as ViewModel is a very loose contract between the Controller and View.&#160; While on rare occasions we still need to pass information in the dictionary part, we’ve limited this to supporting information to help render some of the lower-level pieces of the View, and are used for some “plumbing” pieces, these pieces do not show up in our Controller action nor are they visible when you design the view.

**Rule #2 – For each ViewModel type, there is defined exactly one strongly typed View**

We’ll get into how we do this soon, but this rule has a lot of implications:

  * ViewModel types are distinct from our Domain Model types
  * The choice of what View to show can be decided strictly on the shape of your ViewModel
  * Re-used pieces in a View (through Partials) can be decided through re-using ViewModel types

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="153" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_6C664A18.png" width="425" border="0" />](http://lostechies.com/content/jimmybogard/uploads/2011/03/image_05CE4D53.png) 

On the first point, we never pass an Domain Model entity straight into the view.&#160; Most of the time, we only show a slice of information from a single entity.&#160; And many other times, the same snippet is shown in many places.

**Rule #3 – The View dictates the design of the ViewModel.&#160; Only what is required to render a View is passed in with the ViewModel.**

If a Customer object has fifty properties, but one component only shows their name, then we create a custom ViewModel type with _only those two properties_.&#160; Because we only have one ViewModel type per View, we shape our ViewModel around only what is displayed (or used) in that View.&#160; Why is this a Good Thing?

For one, just having a ViewModel points us to the right View.&#160; We need any other information other than your ViewModel type to pick the correct View.&#160; This also means we no longer need to concern ourselves with locating views by some arbitrary name, as the ViewModel _is_ the View.&#160; Things like RenderPartial, which I have to select a name, become rather pointless at that point.

**Rule #4 – The ViewModel contains only data and behavior related to the View**

For the most part, our ViewModel contains only data.&#160; Most, if not all aggregations/calculations or shaping is done through our Domain Model.&#160; But occasionally, we have View-specific behavior or information, and that rightly belongs on our ViewModel.

We’ve looked at how we design our ViewModel and what it looks like, but how does it get there?&#160; If we create all these distinct ViewModel types separate from our Domain Model, didn’t we just create a bunch of work for ourselves?&#160; We thought so too, which is why we developed [AutoMapper](http://automapper.codeplex.com/) on this project.

### Building the ViewModel

When we introduced AutoMapper into our MVC pipeline, we had a real problem.&#160; Do Controllers need to do the mapping between Domain Model and ViewModel in each action method?&#160; That becomes rather annoying for unit testing, as the mapping operation could warp things to a state that it becomes difficult to pull things back out.&#160; For example, or EditModels (ViewModels for forms) are very string-y, where DateTimes, Ints, Decimals etc are represented as strings.&#160; This comes from us using Castle Validators (future post, I promise) for validation.&#160; 

So more moving parts, a dependency across _all_ controllers?&#160; No, mapping in our Controller action just won’t do.&#160; Instead, we’ll use an Action Filter to do the work for us:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="209" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_1D1951C4.png" width="744" border="0" />](http://lostechies.com/content/jimmybogard/uploads/2011/03/image_2510F426.png) 

A request comes in, handled by an Action.&#160; The Action does its thing, ultimately deciding how to respond to the request.&#160; In many cases, this means rendering a view (ViewResult).&#160; From there, our Action Filter comes into play.&#160; On our Action method, we decorate it with an AutoMap attribute to configure the source/destination type pair to be mapped:

<pre>[<span style="color: #2b91af">AutoMap</span>(<span style="color: blue">typeof</span>(<span style="color: #2b91af">Product</span>), <span style="color: blue">typeof</span>(<span style="color: #2b91af">ShowProduct</span>))]
<span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Details(<span style="color: blue">int </span>id)
{
    <span style="color: blue">var </span>product = _productRepository.GetById(id);

    <span style="color: blue">return </span>View(product);
}</pre>

[](http://11011.net/software/vspaste)

Very trivial, yes, but here we see that we still use the strongly-typed version of the View method, so that means that our model on the Action side, which I call the Presentation Model (feel free to pick a better name), is the strongly-typed ViewModel _for the moment_.&#160; The Presentation Model, which the Action creates, can be an entity, an aggregate root, or some other [custom aggregate component](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/02/04/ddd-aggregate-component-pattern-in-action.aspx) that we build up.

From there, we decorated our action with a filter that specified we need to map from Product to ShowProduct.&#160; Why do we have to specify the source type?&#160; Well, many ORMs, including NHibernate, rely on proxy types for things like lazy loading.&#160; Instead of relying on the runtime type, we’ll explicitly specify our source type directly.&#160; This also helps us later in testing, as we can whip through all of our controller actions using reflection, and test to make sure the source/destination type specified is actually configured.

The filter attribute is very simple:

<pre>[<span style="color: #2b91af">AttributeUsage</span>(<span style="color: #2b91af">AttributeTargets</span>.Method, AllowMultiple = <span style="color: blue">false</span>)]
<span style="color: blue">public class </span><span style="color: #2b91af">AutoMapAttribute </span>: <span style="color: #2b91af">ActionFilterAttribute
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">Type </span>_sourceType;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">Type </span>_destType;

    <span style="color: blue">public </span>AutoMapAttribute(<span style="color: #2b91af">Type </span>sourceType, <span style="color: #2b91af">Type </span>destType)
    {
        _sourceType = sourceType;
        _destType = destType;
    }

    <span style="color: blue">public override void </span>OnActionExecuted(<span style="color: #2b91af">ActionExecutedContext </span>filterContext)
    {
        <span style="color: blue">var </span>filter = <span style="color: blue">new </span><span style="color: #2b91af">AutoMapFilter</span>(SourceType, DestType);

        filter.OnActionExecuted(filterContext);
    }

    <span style="color: blue">public </span><span style="color: #2b91af">Type </span>SourceType
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>_sourceType; }
    }

    <span style="color: blue">public </span><span style="color: #2b91af">Type </span>DestType
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>_destType; }
    }
}</pre>

[](http://11011.net/software/vspaste)

We simply capture the types and delegate to the real action filter for the work.&#160; This is again because I believe in separating metadata in attributes from the behavior they perform.&#160; Attributes just don’t work well for behavior.&#160; Instead, I’ll create a separate action filter:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">AutoMapFilter </span>: <span style="color: #2b91af">BaseActionFilter
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">Type </span>_sourceType;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">Type </span>_destType;

    <span style="color: blue">public </span>AutoMapFilter(<span style="color: #2b91af">Type </span>sourceType, <span style="color: #2b91af">Type </span>destType)
    {
        _sourceType = sourceType;
        _destType = destType;
    }

    <span style="color: blue">public override void </span>OnActionExecuted(<span style="color: #2b91af">ActionExecutedContext </span>filterContext)
    {
        <span style="color: blue">var </span>model = filterContext.Controller.ViewData.Model;

        <span style="color: blue">object </span>viewModel = <span style="color: #2b91af">Mapper</span>.Map(model, _sourceType, _destType);

        filterContext.Controller.ViewData.Model = viewModel;
    }
}</pre>

[](http://11011.net/software/vspaste)

The BaseActionFilter is just a class that implements the various filter methods as virtual members, so I can override just the ones I need to use.&#160; The AutoMapFilter pulls the original PresentationModel out of ViewData, performs the mapping operation, and puts the mapped ViewModel into the ViewData.Model property.&#160; From there, the strongly-typed view for our specified ViewModel type is rendered.

Because AutoMapper can flatten source types, we often find our ViewModel to simply follow a property chain for various pieces of information.&#160; Again, we let our View shape that piece.&#160; If we decide not to flatten, it’s usually because we’re creating a partial that re-uses a ViewModel type across other parent ViewModel types.

### 

### Wrapping it up

Designing ViewModels is quite ambiguous with MVC, as the shipped platform doesn’t offer any guidance or opinions in that area.&#160; But by forming rules around our ViewModel, we can create a path and direction for our innovation.&#160; Our rules are designed to strengthen the relationship between the View and the Model, with a concept of ViewModel – a Model designed exclusively for exactly one View.

In the next post, we’ll look at designing our views – for both viewing and editing data, and how we’ve crafted opinionated HTML builders to eliminate a lot of duplication and enforce standardization.