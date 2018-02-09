---
wordpress_id: 327
title: The Filter-ViewData anti-pattern
date: 2009-06-19T03:08:30+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/06/18/the-filter-viewdata-anti-pattern.aspx
dsq_thread_id:
  - "264716197"
categories:
  - ASPNETMVC
redirect_from: "/blogs/jimmy_bogard/archive/2009/06/18/the-filter-viewdata-anti-pattern.aspx/"
---
In just about every website you go to these days, its layout follows a very similar pattern:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="362" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_55425A8C.png" width="521" border="0" />](http://lostechies.com/jimmybogard/files/2011/03/image_5A250E48.png) 

You have some static resource logo, a large main section with information that our controller action supplies.&#160; But we also have some other stuff, those green sections.&#160; Things like breadcrumbs, shopping carts, login widgets, smart menus and so on.&#160; It’s all still data driven, but its information has absolutely _nothing_ to do with what’s going on in my main section.&#160; This is some of the first kinds of duplication we see in MVC applications – common, data-driven sections across many pages in our application.

The usual way to get rid of this duplication is through ActionFilters.&#160; We decorate our main section action with filters:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">ProductController </span>: <span style="color: #2b91af">Controller
</span>{
    [<span style="color: #2b91af">LoginInfo</span>]
    <span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Index()
    {
        <span style="color: blue">var </span>products = _productRepository.FindAll();

        <span style="color: blue">return </span>View(products);
    }</pre>

[](http://11011.net/software/vspaste)

We don’t have that duplicated login information code in all of our controllers, and we can even go so far as to decorating our controller class or layer supertype to apply our filter to a broad set of controllers.&#160; But looking at our filter, it looks like we took a step backwards:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">LoginInfoAttribute </span>: <span style="color: #2b91af">ActionFilterAttribute
</span>{
    <span style="color: blue">public override void </span>OnActionExecuted(<span style="color: #2b91af">ActionExecutedContext </span>filterContext)
    {
        <span style="color: blue">var </span>currentUser = _userSession.GetCurrentUser();

        filterContext.Controller.ViewData.Add(<span style="color: #a31515">"currentUser"</span>, currentUser);
    }</pre>

[](http://11011.net/software/vspaste)

Back again to magic strings!&#160; With [MVC Contrib](http://www.codeplex.com/MVCContrib), it looks a little better as we can skip the key part, and just pass the current user object in.&#160; But beyond the magic strings issue here is the problem of linking what is essentially a view concern (how I organize the different pieces of information on a given page) with my controller structure.&#160; What if that widget isn’t shown on all actions for a controller?&#160; What if I have four widgets, and not all are shown on every screen?&#160; It begins to break down the normal, filters-on-layersupertypes-pattern.&#160; I’d rather not let my view structure, with master pages and what not, influence my main-line controller design in any way.

The other issue I run into is figuring out where the heck the information comes from if I’m looking at a view.&#160; I see a piece being pulled out of ViewData, but not any clear indication of where that information came from:

<pre><span style="background: #ffee62">&lt;%</span> Html.RenderPartial(<span style="color: #a31515">"loginView"</span>, ViewData[<span style="color: #a31515">"currentUser"</span>]); <span style="background: #ffee62">%&gt;

</span>    <span style="color: blue">&lt;</span><span style="color: #a31515">h2</span><span style="color: blue">&gt;</span>View Products<span style="color: blue">&lt;/</span><span style="color: #a31515">h2</span><span style="color: blue">&gt;
</span></pre>

[](http://11011.net/software/vspaste)

Yes, we can put this in a master page.&#160; But now we’ve coupled the requirements of our view structure with the structure of our controllers, not always a good thing.&#160; In my (not-so) humble opinion, **an action should be responsible for generating exactly one model**.&#160; Things like action filters fiddling with view data are three layers of indirection to get around this rule.&#160; But in the [MVC Futures](http://aspnet.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=24471#DownloadId=61773) assembly, we have a different option.

### Tangential concerns with RenderAction

In our original view, if we dissected each piece, we had a main section and other, orthogonal sections.&#160; The main section’s information is handled by our main action handling the request.&#160; The other pieces are needed, but those concerns aren’t really related to the main section.&#160; Does showing a login widget have anything to do with showing a product list?&#160; No.&#160; But I don’t want to couple all the different concerns in completed view with the main action.&#160; Because those widgets, and where they’re located is a view concern, we can initiate the rendering of those pieces from the view using RenderAction.

RenderAction works like a mini-request, exercising the MvcHandler, but re-using the existing HttpContext.&#160; It simulates a request, but writes out to the exact same response stream, at the exact right place:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="267" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_3780CFCD.png" width="721" border="0" />](http://lostechies.com/jimmybogard/files/2011/03/image_267CA1EA.png) 

Our view doesn’t look much different, it looks like a cross between a Url.Action call and RenderPartial:

<pre><span style="background: #ffee62">&lt;%</span> Html.RenderAction&lt;<span style="color: #2b91af">LoginController</span>&gt;(c =&gt; c.Widget()); <span style="background: #ffee62">%&gt;

</span>    <span style="color: blue">&lt;</span><span style="color: #a31515">h2</span><span style="color: blue">&gt;</span>View Products<span style="color: blue">&lt;/</span><span style="color: #a31515">h2</span><span style="color: blue">&gt;
</span></pre>

[](http://11011.net/software/vspaste)

What you _don’t_ see is any data or model passed to RenderAction.&#160; The LoginController is a plain controller, with a regular action on it.&#160; The action now can be concerned with both finding the data for the model and choosing the view to render:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">LoginController </span>: <span style="color: #2b91af">Controller
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">ViewResult </span>Widget()
    {
        <span style="color: blue">var </span>currentUser = _userSession.GetCurrentUser();

        <span style="color: blue">return </span>View(currentUser);
    }</pre>

[](http://11011.net/software/vspaste)

I don’t have to jump through hoops to find where my information came from, as I only need to follow the link from the RenderAction call to the Widget action method.&#160; Additionally, my original ProductController now has absolutely zero logic for all of the orthogonal concerns, whether it’s hidden in an action filter or not.&#160; For each view, I can decide what master page to use, and place those RenderAction calls there.&#160; I let my view decide what layout is correct.

Wherever I see action filters poking around with ViewData, I see a very clear path to using RenderAction instead.&#160; It’s a much more cohesive and flexible model, and straightforward to understand where each individual piece comes from.&#160; Controllers have enough responsibility as it is, why do they need to be burdened with the additional responsibility of organizing data for tangential concerns?&#160; RenderAction has zero performance penalty, as it’s not a real, external request.&#160; ViewData can be abused as a bag-o’-stuff for views to consume, but that won’t lead to maintainable, understandable markup.&#160; Instead, we can utilize the RenderAction method and create very cohesive controllers and strongly-typed views, with explicit concerns.