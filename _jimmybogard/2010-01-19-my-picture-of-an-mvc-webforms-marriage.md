---
wordpress_id: 384
title: My picture of an MVC-WebForms marriage
date: 2010-01-19T01:25:25+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/01/18/my-picture-of-an-mvc-webforms-marriage.aspx
dsq_thread_id:
  - "264716404"
categories:
  - ASPdotNET
  - ASPNETMVC
redirect_from: "/blogs/jimmy_bogard/archive/2010/01/18/my-picture-of-an-mvc-webforms-marriage.aspx/"
---
Like it or not, WebForms is not going away.&#160; Fortune 50 companies use it for their public facing, mission critical websites, and I can’t really see many of these folks tossing away years of work simply because MVC is the new shiny.&#160; Talking with some industry folks, I see a lot of fear/misunderstanding around the MVC/WebForms story going forward.

One thing that [Jeffrey](http://jeffreypalermo.com/) at [Headspring](http://www.headspring.com) has convinced me of recently is that there should be a convergence of these two models at some point in the future.&#160; On a recent large project, we’ve had areas where it just made sense to use WebForms.&#160; For us, it was a 3rd party reporting control.&#160; Making the transition there was tough, however, as many things I counted on in MVC just weren’t there any more.&#160; However, recent strides in ASP.NET 4.0 have eliminated many of the existing headaches.

My vision of an MVC-WebForms marriage is one of a seamless harmony, one where I can go back and forth between MVC and WebForms without much issue between the two.&#160; So what is needed to make this marriage last?

### Model Binding/Strongly-Typed pages

One of the big pains going from MVC to WebForms is the lack of model binding.&#160; I don’t like poking into controls to get values, nor do I enjoy poking into the querystring/forms collections to manually munge dictionaries.

In addition to model binding would be pages where I could strongly-type the Page class, so that I didn’t have to manually pull junk out of controls.&#160; I could see this done in a variety of ways, whether it’s an overloaded Page_Load event, a different Page base class or whatever.

### Shared HtmlHelpers and MasterPages

I’d like to easily generate links from MVC to WebForms, and vice-versa.&#160; Additionally, I don’t want to create a new Master Page for WebForms pages.&#160; I haven’t tried to mix both, but it would be nice to be able to share a common template for both sets of pages.&#160; If I get HtmlHelpers, then I can easily use Url.Action, Html.ActionLink and so on.

### Routing

This is already in ASP.NET 4.0, nothing else needed here.&#160; Since I can create routes for WebForms, I can use the route-based URL generators in MVC land to generate a link from an MVC to WebForms page.&#160; Of course, I can always hard-code the .ASPX URL.

There are still situations in every-day work that WebForms is the right way to go.&#160; I like MVC as a pattern more than the presenter/front controller of WebForms, and that’s a conscious choice I make.&#160; But for those wanting to mix technologies, it’s still a little ways off before these can both live together in harmony, if only for those times when I absolutely must use both.