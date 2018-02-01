---
id: 924
title: 'Conventional HTML in ASP.NET MVC: Validators'
date: 2014-07-24T18:33:29+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=924
dsq_thread_id:
  - "2870340219"
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

We’re marching towards our goal of creating conventional components, similar to React classes or Angular directives, but there’s one last piece we need to worry about before we get there: validators.

Validators can be a bit tricky, since they largely depend on the validation framework you’re trying to use. My validation framework of choice is still [Fluent Validation](http://fluentvalidation.codeplex.com/), but you can use others as well. Since the data annotation validators are fairly popular, this example will use that as the starting point.

First, we have to figure out what our validation HTML should look like, and how it should affect the rest of our output. But we don’t have a “Validator” convention, we only have “Label”, “Editor”, and “Display” as our possibilities.

Luckily, underneath the covers these Label etc. conventions are only categories of elements, and we can easily create a new category of conventions for our own purposes. The Label/Editor/Display properties are only convenience methods. In our base convention class, let’s create a new category of conventions via a similar property:

[gist id=b0bed78e02d02ec59390]

This will allow us to append additional conventions to a Validator category of element requests. With a custom builder, we can create a default version of our validator span (without any validation messages):

[gist id=7cbd62af8271a9dca3bf]

And add it to our default conventions:

[gist id=2147b2a257fdd5c01787]

The last part is actually generating the HTML. We need to do two things &#8211;

  * Determine if the current field has any validation errors
  * If so, build out the tag with the correct error text

The first part is actually fairly straightforward – ha ha just kidding, it’s awful. Getting validation messages out of ASP.NET MVC isn’t easy, but the source is available so we can just copy what’s there.

[gist id=f0a45e58e1f691c3ca1e]

Ignore what’s going on in the first section – I just grabbed it from the MVC source. The interesting part is at the bottom, where I grab a tag generator factory, create a tag generator, and build an HtmlTag using the Validator category for the given ElementRequest. This is what our Label/Editor/Display methods do underneath the covers, so I’m just emulating their logic. It’s a bit clunkier than I want, but I’ll amend that later.

Finally, after building the base validator tag, we set the inner text to the error message we determined earlier. We only use the first error message – too many and it becomes difficult to read. The validation summary can still be used for multiple errors. Our view is now:

[gist id=4577dbf5c0b6f5af5ae9]

Since we know that every validation message will need that “text-danger” class applied, applying it once to our conventions means that we’ll never have to copy-paste that portion around ever again. And much easier to develop against than the MVC templates, which quite honestly, are quite difficult to develop against.

We could go a step further and modify our Label conventions to pick up on the “Required” attribute and show an asterisk or bold required field labels.

Now that we have quite a bit of consistency in our groups of form elements, in the next post we’ll look at tackling grouping multiple tags into a single input/form component.