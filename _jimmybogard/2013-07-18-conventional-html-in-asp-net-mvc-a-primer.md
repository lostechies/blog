---
id: 810
title: 'Conventional HTML in ASP.NET MVC: A Primer'
date: 2013-07-18T14:10:42+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=810
dsq_thread_id:
  - "1509775558"
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

I hinted last post that I wasn’t a fan of the Display/Editor templates in ASP.NET MVC. I really liked the idea of opinionated, metadata driven input and output builders – in fact, I wound up building this concept in a really large MVC project (that eventually spawned the MVC Contrib InputBuilders).

I had hoped that this concept would be effectively replaced by templated helpers in MVC, but unfortunately, it just hasn’t been the case. I’ve used templated helpers in a lot of simple scenarios, but for highly customized scenarios, or anything off the happy path, they just don’t work very well.

Instead, we’ve gone with integrating [Fubu MVC](http://mvc.fubu-project.org/) HTML conventions into our project, and it’s a complete breath of fresh air. But before I dive in to the nuts and bolts of integrating Fubu into ASP.NET MVC, it’s important to understand my motivations and concerns. If you don’t have these problems or concerns, then by all means, stay with ASP.NET MVC templated helpers! But if you don’t like the defaults or hard-coded opinions, Fubu’s conventions could be a great fit.

So in no particular order, let’s look at my gripes of templated helpers.

### Model metadata madness

At its core, templated helpers are a way of using model metadata to build HTML. To achieve this, we need some way of providing the builders of HTML with the metadata about which they are building. We’ll have this in our view:

[gist id=6029039]

And we need to pass the metadata from the “FirstName” expression to whatever builds our HTML, because it will use all that information when deciding what to build. Dates? Do something special. Guids? Do something special, and so on. Our model is rather simple:

[gist id=6029064]

You might think that model metadata would include the PropertyInfo item plus perhaps some context and the model value. You’d be wrong though, we instead have another object serving as the encapsulation of our model metadata, without actually giving us access to things we really need, ModelMetadata:

[http://msdn.microsoft.com/en-us/library/system.web.mvc.modelmetadata.aspx](http://msdn.microsoft.com/en-us/library/system.web.mvc.modelmetadata.aspx "http://msdn.microsoft.com/en-us/library/system.web.mvc.modelmetadata.aspx")

To understand how this object gets filled, we need to understand the ModelMetadataProvider. Quick – what value does the attribute Display above populate on our ModelMetadata? What about the Hidden attribute?

What if we have a custom attribute? What if we decide to use some other validation framework, like Castle validations or Fluent Validation? We now need to augment these models to populate this model, because we have no way of getting back to the original property with its full metadata.

I have no idea what half these properties mean or what they do on ModelMetadata. However, I do know reflection, and it’s very easy to go from actual metadata objects (System.Type etc.) and build HTML. Everything I need to know is already on the Type objects, there’s no need to jump through extra hoops of ModelMetadata to get at it. In some cases, it’s not even possible to get back to the original type metadata.

### Do as I say, not as I do

In order to create custom templates in ASP.NET MVC, you’re required to create Razor templates. That’s not horrible – but it’s not how the built-in templates are created! If you want to override the existing templates, you’ll likely want to just augment the existing output slightly. That’s just not possible, it’s really all-or-nothing.

You might expect to see the default templates implemented as Razor as well, but instead, it’s a static class with a bunch of methods, with a dictionary pointing to the templates. Of course this class is internal, and it takes a bit of spelunking to even find it, our [DefaultEditorTemplates](http://aspnetwebstack.codeplex.com/SourceControl/latest#src/System.Web.Mvc/Html/DefaultEditorTemplates.cs) class.

If you want to something even more interesting – say include a label element with each input element, we need to override the object template (which oddly enough, isn’t used in our string template).

None of the methods in the DefaultEditorTemplates class are meant to be copy-pasted into Razor code, so we’re essentially starting from scratch. How can we be assured that Razor as templates is viable when not even the built-in templates are implemented in this fashion?

### Razor templates and real logic

This brings us back to my biggest frustration of editor/display templates. We only have one way of providing them – through Razor. However, in practice, I’ve found that my need to use Razor in templates is by far the minority. It’s only in things like showing an editor for a generic “Address” or “Phone Number” that might have multiple fields in a single model property.

In my original Input Builder design was 100% code-based, but it had a fundamental flaw (well, several). It build on top of strings, which is a lousy abstraction of HTML. I did allow for actual view templates as a last resort, but the 99% case was completely code-driven.

But in our Razor template, if we want to do anything interesting, conditionally build up HTML based on certain criteria, our Razor templates become ugly fast. Interestingly enough, the MVC Contrib input builders have the same problem, being 100% view-driven.

Views are great for composing multiple HTML elements, but code is best for modifying/customizing individual blocks of HTML. It’s why we have both partials and HTML Helper extensions in MVC.

### Resolving and extending templates

Another major limitation in templated helpers is you can’t modify the pipeline in how a template is chosen. There is an explicit list of built-in templates, and an explicit resolution mechanism. This mechanism drives either off of the property type or a template name, but that’s it.

This leads to things like a “UIHint” attribute, where we’re hard-coding the template to use inside our view models.

I’m typically doing one of two things when customizing my templates: replacing or extending. With replacing, I can only replace based on the existing hierarchy, but not more interesting things like “every property called ‘Comments’ needs to be a textarea”. Or even more interesting, being able to augment the templates on my views. I might want to tweak the resulting HTML by adding additional styling for layout or widths. None of this is possible because there’s so much distance between my model and the resulting template.

Resolving a template could be complex, depending on what’s going on. There’s simple type-based behaviors (Guids, bools, etc.) but other times I simply want to modify the default, perhaps with data attributes and so on. I don’t want to push this all onto my models explicitly, most of it can simply be inferred by looking at our model with a keen eye.

Fubu has the concept of both builders and modifiers, of actual HTML objects (not strings). It’s far more powerful and extensible – I get to choose exactly how my templates are chosen and built.

There are some other problems – resolving dependencies are another issue (drop-down list using lookup table from database for one), but you get the idea. If you’re going full on into metadata-driven HTML, you’ll likely get frustrated with display/editor templates.

In the next few posts, I’ll look at integrating Fubu MVC’s HTML conventions into an existing MVC application, and customizing them to build some truly powerful conventions.