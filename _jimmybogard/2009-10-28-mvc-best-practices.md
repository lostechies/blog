---
wordpress_id: 364
title: MVC Best Practices
date: 2009-10-28T12:45:26+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/10/28/mvc-best-practices.aspx
dsq_thread_id:
  - "264716326"
categories:
  - ASPNETMVC
---
Simone has a great post (as usual) on [12 ASP.NET MVC Best Practices](http://codeclimber.net.nz/archive/2009/10/27/12-asp.net-mvc-best-practices.aspx):

> **Controller:**
> 
> 1 &#8211; Delete the AccountController
> 
> 2 &#8211; Isolate controllers from the outside world
> 
> 3 &#8211; Use an IoC Container
> 
> 4 &#8211; So NO to “magic strings”
> 
> 5 &#8211; Build your own personal conventions
> 
> 6 &#8211; Pay attention to the verbs
> 
> **Model:**
> 
> 7 – Domain Model != ViewModel
> 
> 8 – Use ActionFilters for “shared” data
> 
> **View:**
> 
> 9 – NEVER use code-behind
> 
> 10 – Write HTML each time you can
> 
> 11 – If there is an if, write an HtmlHelper extension
> 
> 12 – Choose your ViewEngine carefully

This is a fantastic list, and of course I have my own additions/suggestions :)&#160; First, I’m not a fan of action filters for shared data.&#160; If we’re doing strongly-typed views, using action filters for shared data puts us back into the magic string land, where we have to either use inheritance in our ViewModels, or the dictionary part of ViewData.&#160; I don’t like either approach, I’d [rather go with something like RenderAction](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/06/18/the-filter-viewdata-anti-pattern.aspx) to truly enforce SRP in my ViewModels.&#160; Not everyone appreciates the elegance of this approach, but I’m sure they’ll agree eventually.

I also don’t like writing an HtmlHelper extension just because I have logic in the view.&#160; For a half-decent view engine, it shouldn’t be that problematic to have view logic in the view.&#160; HtmlHelper extensions enforce the Helper object anti-pattern – a bunch of procedural logic hanging off one static class.&#160; Instead, we went the route of building intelligent input builders for input elements, and only really using HtmlHelper when we want to eliminate duplication between multiple views.&#160; I see these constructs:

  * HtmlHelper
  * Partials
  * Master Pages

All as means of eliminating duplication in our views, but not much more.&#160; If there’s logic in a view, that’s fine by me as long as it’s not duplicated.&#160; It’s not my fault that C# looks downright bizarre mixed in with HTML markup, but that’s what [other view engines are for](http://sparkviewengine.com/).

Finally, if there was an award for How Not to Design a Controller, the AccountController would be the runaway champ.&#160; I still can’t imagine why it’s necessary, and the idea of [portable areas](http://jeffreypalermo.com/blog/mvccontrib-working-on-portable-areas/) would be a better fit for its functionality than the Thing We Always Delete with Extreme Prejudice.