---
id: 812
title: 'Conventional HTML in ASP.NET MVC: Building tags'
date: 2013-08-13T01:47:12+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=812
dsq_thread_id:
  - "1602315362"
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

In order to provide conventional HTML, you have to build on a solid foundation. Because most of the time I want to tweak my rules in C#, it’s important that I’m able to tweak the output of HTML programmatically. This is where ASP.NET and Fubu MVC start to diverge.

In ASP.NET MVC, all of the HtmlHelper methods return a single type – the MvcHtmlString. It’s really only concerned with making sure that a raw string that contains HTML is only encoded for output once.

But if you actually want to _modify_ that output, you’re in a bit of a spot. For example, you might want Html.ActionLink, but slightly modify the output. You can pass parameters to modify it, but only through an anonymous object/dictionary thingy:

[gist id=6215611]

It’s a bit clumsy, and difficult to modify after the fact. Once ActionLink is called, you only have the opaque, raw string to work with. Underneath the covers, MVC does use an object to build up the HTML – the TagBuilder object. Unfortunately, none of the existing HtmlHelper methods allow you to talk about things in terms of a TagBuilder object, it’s all internal.

Enter HtmlTags – the [Fubu MVC HtmlTags](http://htmltags.fubu-project.org/) library. It allows us to talk about an HTML tag in terms of a model of a tag, programmatically modifying/extending/replacing and waiting until the _last possible moment_ to take that and turn it into HTML.

### Programmatic HTML

Instead of using the existing HtmlHelper extensions, let’s create our own. We’ll come back to form/input/display methods later, but what about something like a link?

First, our own link method:

[gist id=6216980]

A couple of things we see here. First, instead of string building, we’re dealing with an actual object. We instantiate the tag with its element, then initialize with a couple of values. We could have also done:

[gist id=6216996]

HtmlTags uses a syntax similar to jQuery, where we chain methods to continuously manipulate the object. In our view, we then use it just like our normal ActionLink methods:

[gist id=6217003]

Those extra parenthesis are there because we’re using explicit generic parameters, and those pesky less than/greater than characters confuse our Razor parser.

At runtime, Razor automatically calls .ToString() on any expression. That’s when our HtmlTag object is converted to properly escaped/encoded HTML, but not before. This allows us to manipulate the HtmlTag however we like:

[gist id=6217030]

Because our HtmlTag is an object and not a string, we can programmatically manipulate tag, add children tags, add a wrapper tag, perform smart attribute manipulation (data attributes, CSS classes etc).

Additionally, because we’re building up objects, we can easily build up more HtmlHelper extensions:

[gist id=6217039]

Finally, because our HtmlTags are objects, we can

\*drumroll\*

Test our HtmlHelper extension methods! Well, as long as we figure out how to build up an HtmlHelper object ourselves (not horrible, but not easy) (actually it’s horrible. sorry).

The nice thing about HtmlTags are they’re just a simple library for creating HTML tags, that’s it. You can replace your usage of the existing HtmlHelper extension methods whenever you need to build a custom HtmlHelper extension.

With HtmlTags in place, we’re ready to build on top of this solid foundation and create more interesting conventions with the full Fubu MVC goodness.