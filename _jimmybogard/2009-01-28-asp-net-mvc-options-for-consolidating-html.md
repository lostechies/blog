---
wordpress_id: 275
title: ASP.NET MVC options for consolidating HTML
date: 2009-01-28T02:31:50+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/01/27/asp-net-mvc-options-for-consolidating-html.aspx
dsq_thread_id:
  - "264849374"
categories:
  - ASPNETMVC
redirect_from: "/blogs/jimmy_bogard/archive/2009/01/27/asp-net-mvc-options-for-consolidating-html.aspx/"
---
It comes up very early in any ASP.NET MVC application: duplicated HTML.&#160; Bits and pieces of final rendered page may appear on two or more different pages, and that’s duplication we would like to eliminate.&#160; In WebForms land, we had quite a few options to consolidate and refactor that common HTML: Master Pages, custom controls, user controls, composite controls and so on.&#160; In ASP.NET MVC, the potential for duplicate HTML is still close to a guarantee, so we’ll need to explore different options for common HTML.&#160; This time around, our options are a little more straightforward than in WebForms land.

Off the top of my head, we have at least five options for consolidating HTML:

  * Master Pages
  * Partial
  * RenderAction
  * PartialRequests/Subcontroller
  * Extending HtmlHelper (or similar)

Each of these has its plusses and minuses, and each has a specific scenarios where they work best.&#160; When it comes to the point where we need to consolidate HTML, it’s important to understand the strengths of each solution, so let’s go through each and examine them carefully.

### Option 1: Master Pages

In ASP.NET MVC, we have exactly the same options for organizing HTML as we did in WebForms, that is, Pages (.aspx), Master Pages (.master) and User Controls (.ascx).&#160; However, unlike WebForms, none of these has any code associated with them, they are merely a way to organize views.&#160; They don’t handle requests, they just render a model.&#160; As such, we can move a lot of the common layout HTML, common scripts, CSS, etc.

#### Strengths

  * Individual ViewPages (.aspx) can define their Master Page, as in WebForms
  * ViewPages decide what their Master Page is
  * Render information that doesn’t need input from a Controller

#### Weaknesses

  * Controllers have no knowledge of Master Pages (nor should they)
  * Master Pages can’t really use any View Data (nor should they)

#### When to use it

Master Pages are great for common HTML that doesn’t need any direction from a Controller for what to do or what data to show.&#160; A Master Page is _strictly_ a View concern, for consolidating HTML that the Controller does not care about.&#160; For example, we wouldn’t want a Controller to pass down anything in a ViewModel that a Master Page would use, because, at any time, the View could decide it needs to use a different Master Page for whatever reason.&#160; This isn’t obvious from the Controller side, so we don’t really want to rely on it.&#160; There are special cases to this rule, with nested Master Pages, dynamic components and so on, but it’s just not nearly as obvious or discoverable as other options.

Ideally, our Master Page would have next to zero code in it, used merely to create layouts for the actual Views being rendered.&#160; The Master Page would have zero or very, very little input from the Controller, ideally zero, just to keep our concerns separate and our architecture sound.&#160; Master pages should be strictly used for common layouts, and nothing more.

### Option 2: Partials

Partials are what I consider the “Extract Method” refactoring of a View.&#160; We see common HTML in many Views, each using the same ViewModel type to render the same HTML.&#160; When we see the same HTML working off of the same ViewModel (or one that _looks_ the same and we can consolidate), we can extract that common HTML to a Partial, and use the RenderPartial method in our View to render this common HTML from many different Views.

#### Strengths

  * Testable, as you can make sure the Controller passes the right ViewModel to the View
  * Can show dynamic data, as the Controller controls what ViewModel data the Partial gets
  * Nestable and composable as much as a ViewModel can be
  * Partial Views aren’t tied to any parent View that uses them

#### Weaknesses

  * Controllers must be aware of all Partials used – as they must supply the data in the right format
  * Because Controllers supply the data, disparate Controllers become implicitly bound by the Partial’s ViewModel they need
  * A Partial’s ViewModel is often supplied through ActionFilters, which works, but can be a little too “behind the scenes voodoo” for some

#### 

#### When to use it

The big choice for going with a Partial is deciding who is going to responsible for supplying an HTML snippet its ViewModel.&#160; If you want the top-level Controller supplying the ViewModel data, explicitly in the Action or implicitly in an ActionFilter, then a Partial is the way to go.&#160; Partial are easily testable, as you can directly query the ViewModel that the Action provides.&#160; Even with an ActionFilter, you can independently test both the ActionFilter _and_ make sure it’s applied to the right Controllers and Actions through reflection.&#160; Where Partials become troublesome is where you have widgets, banners or other common areas in your screen that have really nothing at all to do with what your action is doing and are not part of the logical whole of a View.

### Option 3: RenderAction

In ASP.NET MVC, we have the option of creating a “mini-pipeline” from a View through RenderAction.&#160; With RenderAction, you’ll supply the Controller, Action, and any routing information from inside a view, allowing for complete separation of the parent Controller being responsible for supplying a child ViewModel.&#160; A full-blown Controller executes from a RenderAction call, rendering its own View, its own ViewModel (however it decided to build it), and any other child Partials or the like.&#160; Underneath the covers, RenderAction constructs an entirely new RequestContext, allowing the child Controller to have its own ActionFilters and anything else a Controller might want.

#### Strengths

  * Parent Controllers do not have to populate multiple disparate child View widgets with their ViewData
  * No performance penalty, as these internal micro-requests are cheap to create
  * Individual child controllers are testable

#### Weaknesses

  * RenderAction is in the View, which makes it immediately harder to test
  * Because nothing in the Controller indicates there is a shared widget component, it’s not quite as obvious
  * Care must be taken to organize these widget Controllers away from regular ones, as you don’t often want them to be publicly accessible

#### When to use it

For those that believe RenderAction in a View violates some kind of separation of concerns, in [Steve Sanderson’s](http://blog.codeville.net/2008/10/14/partial-requests-in-aspnet-mvc/) words, “just bite them on the face immediately”.&#160; As he points out, internal subrequests are a natural phenomena in HTML and today’s web.&#160; AJAX, IMG, CSS links all are subrequests for additional pieces of a View.&#160; RenderAction is perfect for cases where you have **independent** widgets on a screen, and are not part of a logical whole.&#160; That Login component at the top?&#160; Perfect for RenderAction.&#160; Putting a Login component as a Partial just puts more moving parts in your main MVC pipeline.

Bottom line, RenderAction promotes separation of concerns when applied properly.

### Option 4: Partial Requests/Subcontroller

Partial Requests came from Steve Sanderson, and the Subcontroller is part of MVCContrib.&#160; Recognizing the “testable” issue of RenderAction, both of these pass…something to the View that represents a complete request.&#160; Because the request container object is passed to the View through ViewData, it becomes inherently testable.&#160; The final call in the View looks very similar to a RenderAction, except it operates off of a well-known location in the View.

#### Strengths

  * Provides a testable version of RenderAction
  * Puts the responsibility of choosing the child Controller/Action on the parent Controller instead of the View
  * Supports AJAX easily (as individual pieces can handle requests)

#### Weaknesses

  * More moving parts than either RenderAction or Partials
  * Parent Controller again responsible for setting up child widgets, in an Action Filter or in an Action

#### When to use it

Partial Requests and Subcontrollers are both basically variations on a theme – passing something that represents a request down to a View, giving control back to the Controller on how widgets are rendered.&#160; Since both Partial Requests and Subcontrollers resolve to Controllers, they can have dependencies, rely on services, use model binding, contain Action Filters, and just about everything else interesting dealing with a Controller.&#160; They can even be instantiated through your regular Controller factory (as long as you plug the correct context items in).&#160; If testability is a top concern, these options will work well as they combine the power of RenderAction with the testability of Partials.&#160; One piece that still isn’t testable is whether or not the View does anything with the request model passed down to it.&#160; Of course, this is an issue with anything passed to the View, you’ll still probably need some automated UI tests in place to cover all of your bases.

In many cases, Partial Requests are more than you need, and just a straight up RenderAction will work just fine.&#160; If it’s some kind of purity issue with the View deciding what to render…bollocks!&#160; Don’t pick this option if you want to remain “pure”, pick it because it gives you an edge in testability and a little more separation of concerns on the View side.&#160; Since the View can’t decide what widget to render in a RenderAction call, the parent Controller can take more liberty in the request model passed down, so you’ll get more control of widgets with this option.

### Option 5: Extending HtmlHelper (or similar)

On the View side, ASP.NET has what I see as micro-code generation, to help generate individual HTML elements in a type-safe manner.&#160; Input elements, links, forms and so on are often easier to create with a helper method to generate them.&#160; You don’t have to use the built-in HtmlHelper methods, defining extension methods allow generation of new or specialized elements.&#160; In the case of CodeCampServer (and our current production applications), we have intelligent input builders that reflect over an Expression, looking for property types, attributes, and other information to select an input builder to output completely consistent form elements, site-wide.

#### Strengths

  * All the necessary pieces to create small fragments of HTML
  * Easy to extend and add new functionality
  * Small footprint for extensions
  * Individually testable

#### Weaknesses

  * Can get complicated, quickly
  * Not suited for anything more than an HTML element or two
  * Restricted to what you would want to do in one method

#### When to use it

Creating little helpers are great for creating little bits of HTML, where a Partial is too much.&#160; If you have a common small snippet of HTML fragments, where you want to enforce a convention on how that snippet is generated, HtmlHelper extensions are perfect.&#160; You’re not limited to HtmlHelper, as you can create base View classes to attach different HTML builders.&#160; If you try to get too clever with micro-generation, it can come back to bite you, so keep an eye on when you should move up to one of the more appropriate View “widget” generators, such as Partials or RenderAction.&#160; Generally, if you’re generating three or fewer HTML elements in one helper extension, you’re in the right ballpark.

### Wrapping it up

One thing to keep in mind is that all of these options covered here are just that, **options**.&#160; Each is appropriate in their own scenarios, and there is some overlap between them.&#160; But having all the options available gives you the choice to pick the right one for each scenario.&#160; In one recent project, we’ve used all of these options all over the place, because each has their own strengths and weaknesses.&#160; By using each option in the sweet spot they were designed for, we’re able to grow our application without succumbing to the complexity of duplication or the complexity of eliminating duplication incorrectly.