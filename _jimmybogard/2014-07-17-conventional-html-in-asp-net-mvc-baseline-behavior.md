---
wordpress_id: 918
title: 'Conventional HTML in ASP.NET MVC: Baseline behavior'
date: 2014-07-17T14:11:29+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=918
dsq_thread_id:
  - "2851182171"
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

Now that we’ve got the pieces in place for building input/display/label conventions, it’s time to circle back and figure out what exactly we want our default behaviors to be for each of these components. Because it’s so easy to modify the tags generated programmatically, we can establish some pretty decent site-wide behavior for our system.

First, in order to establish a baseline, we need to examine what our current implicit standards are. Right now I’m solely focused on only the input/label/display elements, and not how these elements are typically composed together (label + input etc.). Looking at several of our inputs, we see a prevalent pattern. All of the input elements (ALL of them) have a CSS class appended to them for Bootstrap, “form-control”. Appending this in our normal method of the MVC templated helpers is actually quite difficult and esoteric. For us, it’s a snap.

First, let’s create our own HtmlConventions class that inherits from the default:

[gist id=178a3afb6a9345f07b54]

We’ll then redirect our container configuration to use this convention library instead:

[gist id=939d0de004cb6763f31f]

The OverrideHtmlConventions class is where we’ll apply our own conventions on top of the existing ones. The base conventions class lets us apply conventions to several classes of items:

  * Displays
  * Editors
  * Labels

And a couple of things I won’t cover as I’ve never used them:

  * Forms
  * Templates

There’s no real difference between the Displays/Editors/Templates conventions – it’s just a way to segregate strategies and conventions for building different kinds of HTML elements.

Conventions work by pairing a filter and a behavior. The filter is “whom to apply” and the behavior is “what to do”. You have many different levels of applying filters:

  * Always (global)
  * Attribute existence (w/ filtering on value)
  * Property metadata

The last one is interesting – you have the entire member metadata to work with. You can look at the property name, the property type and so on.

From there, your behaviors can be as simple or complex as you need. You can:

  * Add/remove CSS classes
  * Add/remove HTML attributes
  * Add/remove data attributes
  * Replace the entire HTML tag with a new, ground-up version
  * Modify the HTML tag and its children

You have a lot of information to work with, the original value, new value, containing model and more. It’s pretty crazy, and a lot easier to work with than the MVC metadata (which goes through this ModelMetadata abstraction).

I want to set up our “Always” conventions first, which means really only adding CSS classes. The input elements are easy:

[gist id=eab71767ab785b0739d8]

Our input elements become a bit simpler now:

[gist id=8ba7b259f007af25d26f]

Our labels are a bit more interesting. Looking across the app, it appears that all labels have two CSS classes applied, one pertaining to styling a label, and one pertaining to width. At this point we need to make a judgment call. Do we standardize that all labels are a certain width? Or do we force all of our views to explicitly set this class?

Luckily, we can still adopt a site-wide convention and replace this CSS class as necessary. Personally, I’d rather standardize on how screens should look rather than each new screen becoming a point of discussion on how wide/narrow things are. Standardize, but allow deviation. Our label configuration now becomes:

[gist id=d21effc640964932794c]

Then in our HTML, we can replace our labels with our convention-based version:

[gist id=a053b78ea94f30005959]

It turns out in this app so far we’re not using display elements, but we could go a similar path (surrounding the element with a span tag etc).

So what about those other methods, the “PasswordFor” and so on? In the next article, we’ll look at replacing _all_ of the form helpers with our version, based solely on metadata that already exists on our view models.