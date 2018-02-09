---
wordpress_id: 308
title: How we do MVC
date: 2009-04-24T04:09:06+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/04/24/how-we-do-mvc.aspx
dsq_thread_id:
  - "264716142"
categories:
  - ASPNETMVC
redirect_from: "/blogs/jimmy_bogard/archive/2009/04/24/how-we-do-mvc.aspx/"
---
Our team has been using the ASP.NET MVC framework on a production application for about 9 months now, and in that time, we’ve crafted a number of opinions on how we want to design MVC applications.&#160; Much of this design is inspired by the concepts from FubuMVC, and in particular, [Jeremy’s post on their MVC opinions](http://codebetter.com/blogs/jeremy.miller/archive/2008/10/23/our-opinions-on-the-asp-net-mvc-introducing-the-thunderdome-principle.aspx).&#160; Our approach is rather similar, but deviates in a few places.

I’ll elaborate on many of these concepts in future posts, but for now, in no particular order, our opinions:

  * Controllers are thin and light, only responsible for communicating an action result back to the MVC pipeline.&#160; All major request-handling belongs in application-level services, that communicate operation results back up to the UI layer (controller), that then decides what to do with that result.&#160; In many cases, the “service layer” is a simple repository call.
  * Strongly-typed views, and discouraging the dictionary part of ViewData.&#160; There are edge cases where we have to use it, but we try very hard not to use magic dictionary keys.&#160; It usually crops up around orthogonal view concerns, where we don’t want to pollute our “main” ViewModel with that information.
  * Distinct ViewModels separate from the domain.&#160; Our entities aren’t built well for binding, whether it’s in a ViewModel (read-only) that throws NullReferenceExceptions in a “Something.Other.Foo.Bar” call, or in an EditModel (form) that uses a ModelBinder with very specific design requirements.&#160; The View puts very real requirements on your ViewModel.&#160; For many classes of applications, this is acceptable.&#160; For others, with more complex domains, this influence is unwanted.&#160; Creating a separated ViewModel provides a clean separation of concerns between View and Domain.
  * No magic strings.&#160; None of this Html.TextBox(“Surprise.I.Am.Actually.A.Property”) business, expression-based syntax for _everything_ that refers to a 1) class 2) method or 3) property.&#160; This means:
  * Using expression-based form generation (Html.InputFor(order => order.Customer.Name)
  * Using expression-based URL generation (Url.Action<ProductController>(c => c.Index()))
  * Using expression-based RedirectToAction methods, similar to Url.Action

I can’t stress enough that last point.&#160; If you have a string referring to a member on a type, **use expressions!**&#160; String-based reflections leads to subtle runtime errors, where refactoring screws up your views and controllers.

  * [Smart model binding](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/03/17/a-better-model-binder.aspx).&#160; Our model binders can bind:
  * Entities
  * Forms
  * [Enumeration classes](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/08/12/enumeration-classes.aspx)

  * Validation on your EditModel.&#160; We use Castle Validators on our EditModel to do the rote “OMG this is totally not a number type lol” validation, range validation, required field validation, and so on.&#160; Our validation occurs inside our model binder, **before our action method gets called**.&#160; This isn’t done in any filter or anything like that.&#160; We had to jump through a few hoops to merge the two concepts, as you have to match up Castle’s error summary with MVC’s concept of Model State, as well as taking care of nested levels of access (that Customer.Name example).
  * AutoMapper to go from Domain –> ViewModel and Domain –> EditModel.&#160; This is again because the view and controller put constraints on our model that we didn’t want in our domain.&#160; AutoMapper flattened our domain into very discrete ViewModel objects, containing only the data for our view, and only in the shape we want.
  * Very smart HTML generation.&#160; We have exactly 1 method call for generating a form element, “Html.InputFor”.&#160; As part of that “InputFor”, it examines an input specification, that collects the PropertyInfo, any attributes, the type, any modifiers called, and selects an appropriate InputBuilder.&#160; Call InputFor(p => p.Id) and Id is a GUID?&#160; That creates a hidden input element.&#160; Call InputFor(p => p.Customer.Address) and Address is a complex type?&#160; That looks for a partial with the same name of the type.&#160; With all InputFor’s expression based and going through the exact same method, we can:
  * Create classes of inputs, such as radio buttons for enumerations, drop-downs for enumerations, date-time pickers for DateTimes, and so on
  * Automatically include standardized output for label elements and error information
  * Extend new input builders for specialized cases (plugged in through our IoC container), which matches based on a simple IsMatch(inputSpecification)
  * Standardized look and feel for all classes of inputs

We originally extended HtmlHelper for every new thing, but it got confusing what the right builder for what situation was.&#160; Instead, we used exactly one method and stuck to easily discoverable modifiers (InputFor().AsDropDown()) or metadata on our EditModel (RequiredFieldAttribute automatically outputs a little asterisk next to the input).&#160; It got rid of TONS of duplicated logic, and we had lots of flexibility in the granularity of our input elements, from a single textbox to a complex form that used a partial. The partials were especially nice to be tagged based on type, as things like an AddressForm required no new View work.&#160; We just made sure our EditModel had an AddressForm as its type for any address (which is filled in by AutoMapper).

  * Standardized action method names.&#160; RESTful, but not REST, which we don’t need in our context.
  * UI testing with WatiN and Gallio.&#160; WatiN executes through Gallio, which is parallelizable (our quad-core build server executes 4 test classes, and therefore browsers at a time).&#160; We use Gallio’s concept of test steps to output meaningful information about our tests.&#160; We transform the Gallio output into an HTML report, which becomes part of our deliverables.&#160; People paying us for our services want assurances that our application works, and want to know in a nice pretty way.&#160; When a test fails, WatiN takes a screenshot, and we attach it to the failing test, **which then shows up in our build report**.&#160; Let me repeat: our automated UI testing includes screenshots of failures, all in the background, with no human intervention.
  * UI tests use our ViewModel and EditModel types, along with expressions, to locate and validate elements.&#160; We do things like ForSection<ProductDto>.LocateRowWith(p => p.ProductName, “SomeName”).CheckValue(p =>p.Total, 15.6m).&#160; It’s all strongly-typed, and refactoring-friendly.&#160; All ViewModel data is wrapped in SPAN tags with predictable CLASS attributes based on the expression.&#160; All INPUT element IDs and NAMEs are generated from the expression as well.&#160; WatiN uses the exact same mechanism to generate a string name, ID or class from an expression, resulting in compile-safe UI testing.&#160; When we delete a field from a view, we remove it from our ViewModel, so our UI test won’t even compile.&#160; It’s all very refactoring-friendly.
  * Actions receiving a POST receive the EditModel as an action parameter, not some collection object.&#160; This isn’t ASP 3.0 anymore, we don’t need Request.Form.
  * Use partials when you have common markup, and the data is in your top-level ViewModel object.
  * Use RenderAction when you have common markup, but the information is orthogonal to the main concern of your view.&#160; Think like the “login widget” at the top of every screen.&#160; A filter is too much indirection for that scenario, RenderAction is very explicit.
  * No behavior in filter attributes.&#160; Attributes are for **Metadata**, not **Metabehavior**.&#160; Delegate the real work of the filter attribute to a filter class.&#160; You can’t control the instantiation of a filter attribute, and that gets annoying if you want do to dependency injection.
  * jQuery.&#160; Nothing else to say here, except it really helps to do some actual JavaScript and jQuery learning here.

Like many of the frameworks coming out of Redmond, MVC is not an opinionated framework.&#160; Rather, it is a framework that enables you to form your own opinions (good or bad).&#160; It’s taken quite a long way, with a very stable result at the end.&#160; It’s certainly not perfect, and there are a few directions we’d like to go differently given the chance.&#160; In the next few posts, I’ll elaborate with real examples on the big examples here, otherwise, I’d love to have people poke holes in our approach.