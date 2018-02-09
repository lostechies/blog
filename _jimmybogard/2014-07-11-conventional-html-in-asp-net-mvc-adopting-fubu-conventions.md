---
wordpress_id: 916
title: 'Conventional HTML in ASP.NET MVC: Adopting Fubu conventions'
date: 2014-07-11T15:42:18+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=916
dsq_thread_id:
  - "2835651407"
categories:
  - ASPNETMVC
---
Other posts in this series:

  * [A primer](http://lostechies.com/jimmybogard/2013/07/18/conventional-html-in-asp-net-mvc-a-primer/)
  * [Building tags](http://lostechies.com/jimmybogard/2013/08/13/conventional-html-in-asp-net-mvc-building-tags/)
  * [Adopting Fubu conventions](http://lostechies.com/jimmybogard/2014/07/11/conventional-html-in-asp-net-mvc-adopting-fubu-conventions/)
  * [Baseline behavior](http://lostechies.com/jimmybogard/2014/07/17/conventional-html-in-asp-net-mvc-baseline-behavior/)
  * [Replacing form helpers](http://lostechies.com/jimmybogard/2014/07/22/conventional-html-in-asp-net-mvc-replacing-form-helpers/)
  * [Data-bound elements](http://lostechies.com/jimmybogard/2014/07/23/conventional-html-in-asp-net-mvc-data-bound-elements/)
  * [Validators](http://lostechies.com/jimmybogard/2014/07/24/conventional-html-in-asp-net-mvc-validators/)
  * [Building larger primitives](http://lostechies.com/jimmybogard/2014/07/25/conventional-html-in-asp-net-mvc-building-larger-primitives/)
  * [Client-side templates](http://lostechies.com/jimmybogard/2014/08/14/conventional-html-in-asp-net-mvc-client-side-templates/)

Now that we’ve established a base for programmatically building out HTML, we can start layering on top more intelligent model-centric conventions for both displaying and editing data. Eventually, I want to get to the point of not just supporting simple conventions like “DateTime = date picker” and “bool = checkbox” but much more powerful ones. Things like “a property named ‘Comments’ should be a textarea” or “a property of an entity type should make its dropdown options the list of items from the database”. These are all things that are universal to the metadata found on those properties.

On top of that, I still want to enable customization, but at the HTML tag level. Ultimately, these builders build one or more tags, but nothing bigger than that. I don’t want to use templating for this – complex logic inside a template is difficult to do, which is why you have concepts like Ember views or Angular directives. I want to build an equivalent to those, but for MVC.

I built a rather lousy, but functional version, years ago, but missed the concept of an object model to build HTML tags. That lousy version was ported to MVC Contrib, and should not be used by anybody under any circumstances. Instead, I’ll pull in what [FubuMVC](http://mvc.fubu-project.org/) already built, which turns out is built on top of the [HtmlTags](http://htmltags.fubu-project.org/) library.

I’m not going to use any of the other pieces of FubuMVC – just the part that conventionally builds HTML tags. First things first, we’ll need to get the Fubu MVC conventions and related packages up and running in our app.

### Integrating Fubu Conventions

First, we’ll need to install the correct packages. For this, we’ll just need a couple:

  * FubuMVC.Core.UI
  * FubuMVC.StructureMap3

These two pull down a number of other packages. To make things easier on ourselves, we’ll also install the StructureMap package for integrating with MVC 5:

  * StructureMap.MVC5

Once that’s done, we have StructureMap plugged in to MVC, and the components ready for plugging FubuMVC into ASP.NET MVC. We’ll need to make sure that the correct assemblies are loaded into StructureMap for scanning:

{% gist a2c524f5f4e3b3a6b5e6 %}

We just make sure we add the default conventions (IFoo –> Foo) for the Fubu assemblies we referenced as part of the NuGet packages. Next, we need to configure the pieces that normally are done through FubuMVC configuration, but because we’re not pulling all of Fubu, we need to do through container configuration:

{% gist 705f956ffc7fbb9ca1bb %}

There’s a bit here. First, we create an HtmlConventionLibrary, import default conventions, and register this instance with the controller. We’re going to modify this in the future but for now we’ll use the defaults. This class tells FubuMVC how to generate HtmlTag instances based on element requests (more on that soon). Next, we register a value source, which is analogous to a ValueProvider in MVC. The ITagRequestActivator is for filling in extra details around a tag request (again, normally filled in with FubuMVC configuration).

Since FubuMVC still has pieces that bridge into ASP.NET, we need to register the HttpContext/Request classes based on HttpContext.Current. In the future ASP.NET version, this registration would go away in favor of Web API’s RequestContext.

The ITypeResolverStrategy determines how to resolve a type based on an instance. I included this because, well, something required it so I registered it. Much of this configuration was a bit of trial-and-error until pieces worked. Not a knock on Fubu, since this is what you deal with bridging two similar frameworks together. Still much cleaner than bridging validation frameworks together \*shudder\*.

The IElementNamingConvention we’re using tells Fubu to use the MVC-style notation for HTML element names (foo[0].FirstName). Finally, we register the open generic tag/element generators. Even though the naming convention is IFoo->Foo, StructureMap doesn’t automatically register open generics.

This is the worst, ugliest part of integrating Fubu into ASP.NET MVC. If you can get past this piece, you’re 100 yards from the marathon finish line.

Now that we have Fubu MVC configured for our application, we need to actually use it!

### Supplanting the helpers

Because the EditorFor and DisplayFor are impossible to completely replace, we need to come up with our own methods. FubuMVC exposes similar functionality in InputFor/DisplayFor/LabelFor methods. We need to build HtmlHelper extensions that call into FubuMVC element generators instead:

{% gist 9842d07bd7dfcfcadf27 %}

We build an extension method for HtmlHelper that accepts an expression for the model member you’re building an input for. Next, we use the dependency resolver (service location because MVC) to request an instance of an IElementGenerator based on the model type. Finally, we call the InputFor of IElementGenerator to generate an HtmlTag based our expression and model. Notice there’s no ModelState involved (yet). We’ll get to validation in the future.

Finally, we need to use these Label and Input methods in our forms. Here’s one example from the Register.cshtml view from the default MVC template:

{% gist e1cac762559e2c9f6dcd %}

I left the second alone to contrast our version. So far not much is different. We do get a more elegant way of modifying the HTML, instead of weird anonymous classes, we get targeted, explicit methods. But more than that, we now have a hook to add our own conventions. What kinds of conventions? That’s what we’ll go into the next few posts.

Ultimately, our goal is not to build magical, self-assembling views. That’s not possible or desirable. What we’re trying to achieve is standardization and intelligence around building model-driven input, display, and label elements. If you’re familiar with Angular directives or Ember views, that’s effectively what our conventions are doing – encapsulating, with intelligent, metadata-driven HTML elements.

Next up: applying our own conventions.