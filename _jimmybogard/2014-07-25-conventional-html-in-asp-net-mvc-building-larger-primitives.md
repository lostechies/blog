---
wordpress_id: 926
title: 'Conventional HTML in ASP.NET MVC: Building larger primitives'
date: 2014-07-25T14:52:12+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=926
dsq_thread_id:
  - "2872593705"
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

We’ve taken our individual form elements quite far now, adopting a variety of conventions in our output to remove the boring, duplicated code around deciding how to display those individual elements. We have everything we need to extend and alter the conventions around those single elements.

And that’s a good thing – we want to keep using those primitives around individual elements. But what if we peeked a little bit larger? Are there larger common patterns in play that we can start incorporating? Let’s look at the basic input template, from Bootstrap:

{% gist fa436ab24798147c83d5 %}

Starting with the most basic element, the input tag, let’s look at gradually increasing scope of our building block:

  * Input
  * Input and validation
  * Input, validation in a div
  * Label and the div input
  * Form group

The tricky part here is that at each level, I want to be able to affect the resulting tags, some or all. Our goal here is to create building blocks for each level, so that we can establish a set of reusable components with sensible defaults along the way. This is a similar exercise as building a React class or Angular directive – establish patterns early and standardize your approach.

From the above list of items, I’ll likely only want to create blocks around increasing scopes of DOM elements, so let’s whittle this down to 3 elements:

  * Input
  * Input Block
  * Form Block

We already have our original Input method, let’s create the first input block.

### Basic input block

Because we have our HtmlTag primitive, it’s trivial to combine elements together. This is a lot easier than working with strings or MvcHtmlStrings or the less powerful TagBuilder primitive. We’ll return the outer div tag, but we still need ways of altering the inner tags. This includes the Label, the Input, and Validator. Here’s our input block:

{% gist fb93ff284d0630af99e3 %}

We create an Action<HtmlTag> for the input/validator tags. If someone wants to modify those two elements directly, instead of wonky anonymous-objects-as-dictionaries, we allow them full access to the tag via a callback, similar to jQuery. Next, we default those two modifiers to no-op if they are not supplied.

We then build up our input block, which consists of the outer div with the input tag and validator tag as children. In our view, we can replace the input block:

{% gist ede72d9730b8b5ea3b89 %}

Just to contrast, I included the non-input-blocked version. Now that we have this piece, let’s look at building the largest primitive, the form block.

### Form input block

In the same tradition of Angular directives, React classes and Ember views, we can build larger components out of smaller ones, reusing the smaller components as necessary. This also ensures our larger component automatically picks up changes from the smaller ones. Here’s our FormBlock method:

{% gist 8b53aff35ddf043b5b5f %}

It’s very similar to our input block method, where we provide defaults for our initializers, create the outer div tag, build the child tags, apply child modifiers, and append those child tags to the outer div. Going back to our view, it becomes quite simplified:

{% gist 6192e6af2da176c0c0c9 %}

We have one outlier, our “remember me” checkbox, which I try to avoid at all costs. Let’s look at a couple of other examples. Here’s our register view:

{% gist 4b36c24e7d95aa9b87ec %}

And here’s our reset password view:

{% gist 5c7f1b07ab93e1eb4332 %}

Much more simplified, with conventions around the individual input elements and HtmlHelper extensions around larger blocks. I would likely go an additional step and create an HtmlHelper extension around the buttons as well, since Bootstrap buttons have a very predictable, standardized set of HTML to build out.

We’ve removed a lot of our boilerplate HTML, but still allowed customization as needed. We also still expose the smaller components through InputBlock and Input, so that if the HTML varies a lot we can still keep the smaller building blocks. There’s still a bit of magic going on, but it’s only a click away to see what “FormBlock” actually does. Finally, what conventions really allow us to do is stop focusing on the minutiae of the HTML we have to include on every display/input block of HTML.

We remove bike shedding arguments and standardize our approach, allowing us to truly hone in on what is interesting, challenging or different. This is the true power of conventions – stop pointless and wasteful arguments about things that truly don’t matter through a standardized, but extensible, approach built on conventions.

In our next (and final) post, we’ll look at how we can extend these approaches for client-side templates built in Angular, Ember and more.