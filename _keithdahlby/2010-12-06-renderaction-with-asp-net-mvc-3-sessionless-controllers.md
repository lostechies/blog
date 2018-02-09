---
wordpress_id: 4219
title: RenderAction with ASP.NET MVC 3 Sessionless Controllers
date: 2010-12-06T14:54:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2010/12/06/renderaction-with-asp-net-mvc-3-sessionless-controllers.aspx
dsq_thread_id:
  - "262493359"
categories:
  - ASP.NET MVC
  - ControllerSessionState
  - ControllerSessionStateAttribute
  - mvc 3
  - RenderAction
  - SessionStateAttribute
redirect_from: "/blogs/dahlbyk/archive/2010/12/06/renderaction-with-asp-net-mvc-3-sessionless-controllers.aspx/"
---
One of the new features of ASP.NET MVC 3 is a controller-level
  
attribute to control the availability of session state. In the RC the
  
attribute, which lives in the `System.Web.SessionState` namespace, is `[ControllerSessionState]`; for RTM [ScottGu says](http://twitter.com/scottgu/status/6086923391082496) it will be renamed simply `[SessionState]`. The attribute accepts a [`SessionStateBehavior`](http://msdn.microsoft.com/en-us/library/system.web.sessionstate.sessionstatebehavior.aspx "System.Web.SessionState.SessionStateBehavior on MSDN") argument, one of `Default`, `Disabled`, `ReadOnly` or `Required`. A question that came up during a Twitter discussion a few weeks back is how the different behaviors affect `Html.RenderAction()`, so I decided to find out.

### The Setup

I started with an empty MVC 3 project and the Razor view engine.
  
We&#8217;ll let a view model figure out what&#8217;s going on with our controller&#8217;s `Session`:

<pre>public class SessionModel<br />{<br />    public SessionModel(Controller controller, bool delaySession = false)<br />    {<br />        SessionID = delaySession ? "delayed" : GetSessionId(controller.Session);<br />        Controller = controller.GetType().Name;<br />    }<br /><br />    public string SessionID { get; private set; }<br />    public string Controller { get; private set; }<br /><br />    private static string GetSessionId(HttpSessionStateBase session)<br />    {<br />        try<br />        {<br />            return session == null ? "null" : session.SessionID;<br />        }<br />        catch (Exception ex)<br />        {<br />            return "Error: " + ex.Message;<br />        }<br />    }<br />}</pre>

The model is rendered by two shared views. `Index.cshtml` gives us some simple navigation and renders actions from our various test controllers:

<pre>@model SessionStateTest.Models.SessionModel<br />@{<br />    View.Title = Model.Controller;<br />    Layout = "~/Views/Shared/_Layout.cshtml";<br />}<br />&lt;h2&gt;Host: @Model.Controller (@Model.SessionID)&lt;/h2&gt;<br />&lt;ul&gt;<br />    &lt;li&gt;@Html.ActionLink("No Attribute", "Index", "Home")&lt;/li&gt;<br />    &lt;li&gt;@Html.ActionLink("Exception", "Index", "Exception")&lt;/li&gt;<br />    &lt;li&gt;@Html.ActionLink("Default", "Index", "DefaultSession")&lt;/li&gt;<br />    &lt;li&gt;@Html.ActionLink("Disabled", "Index", "DisabledSession")&lt;/li&gt;<br />    &lt;li&gt;@Html.ActionLink("ReadOnly", "Index", "ReadOnlySession")&lt;/li&gt;<br />    &lt;li&gt;@Html.ActionLink("Required", "Index", "RequiredSession")&lt;/li&gt;<br />&lt;/ul&gt;<br />@{<br />    Html.RenderAction("Partial", "Home");<br />    Html.RenderAction("Partial", "Exception");<br />    Html.RenderAction("Partial", "DefaultSession");<br />    Html.RenderAction("Partial", "DisabledSession");<br />    Html.RenderAction("Partial", "ReadOnlySession");<br />    Html.RenderAction("Partial", "RequiredSession");<br />}</pre>

`Partial.cshtml` just dumps the model:

<pre>@model SessionStateTest.Models.SessionModel<br />&lt;div&gt;Partial: @Model.Controller (@Model.SessionID)&lt;/div&gt;</pre>

Finally, we need a few test controllers which will all inherit from a simple `HomeController`:

<pre>public class HomeController : Controller<br />{<br />    public virtual ActionResult Index()<br />    {<br />        return View(new SessionModel(this));<br />    }<br /><br />    public ActionResult Partial()<br />    {<br />        return View(new SessionModel(this));<br />    }<br />}<br /><br />[ControllerSessionState(SessionStateBehavior.Default)]<br />public class DefaultSessionController : HomeController { }<br /><br />[ControllerSessionState(SessionStateBehavior.Disabled)]<br />public class DisabledSessionController : HomeController { }<br /><br />[ControllerSessionState(SessionStateBehavior.ReadOnly)]<br />public class ReadOnlySessionController : HomeController { }<br /><br />[ControllerSessionState(SessionStateBehavior.Required)]<br />public class RequiredSessionController : HomeController { }</pre>

And finally, a controller that uses the `SessionModel` constructor&#8217;s optional `delaySession` parameter. This parameter allows us to test `RenderAction`&#8216;s `Session` behavior if the host controller doesn&#8217;t use `Session`:

<pre>public class ExceptionController : HomeController<br />{<br />    public override ActionResult Index()<br />    {<br />        return View(new SessionModel(this, true));<br />    }<br />}</pre>

### The Reveal

So what do we find? Well the short answer is that the host controller&#8217;s `SessionStateBehavior` takes precedence. In the case of `Home`, `Default`, `ReadOnly`, and `Required`, we have access to `Session` information in all rendered actions:[
  
<img class="alignnone size-full wp-image-887" src="http://solutionizing.files.wordpress.com/2010/12/sessionless-renderaction-home.png" alt="Sessionless Controller: RenderAction with SessionState" border="0" height="233" width="610" />](http://solutionizing.files.wordpress.com/2010/12/sessionless-renderaction-home.png)

If the host controller is marked with `SessionStateBehavior.Disabled`, all the rendered actions see `Session` as `null`:
  
[<img class="alignnone size-full wp-image-885" src="http://solutionizing.files.wordpress.com/2010/12/sessionless-renderaction-disabled.png" alt="Sessionless Controller: RenderAction with Disabled SessionState" border="0" height="238" width="610" />](http://solutionizing.files.wordpress.com/2010/12/sessionless-renderaction-disabled.png)

I see this is the key finding to remember: an action that depends on `Session`, even if its controller is marked with `SessionStateBehavior.Required`,
   
will be in for a nasty NullRef surprise if it&#8217;s rendered by controller
  
without. It would be nice if the framework either gave some sort of
  
warning about this, or if they used a Null Object pattern instead of
  
just letting `Session` return `null`.

Finally, things get really weird if a `Session`-dependent action is rendered from a host controller that doesn&#8217;t reference `Session`, _even if `SessionState` is enabled_:

[<img class="alignnone size-full wp-image-886" src="http://solutionizing.files.wordpress.com/2010/12/sessionless-renderaction-exception.png" alt="Sessionless Controller Exception: Session state has created a session id, but cannot save it because the response was already flushed by the application." border="0" height="362" width="610" />](http://solutionizing.files.wordpress.com/2010/12/sessionless-renderaction-exception.png)

It&#8217;s pretty clear the issue has something to do with where `RenderAction()` happens in the request lifecycle, but it&#8217;s unclear how to resolve it short of accessing `Session` in the host controller.

So there we have it&#8230;a comprehensive testing of sessionless controllers and `RenderAction`
   
for the ASP.NET MVC 3 Release Candidate. Hopefully the inconsistencies
  
of the latter two cases will be resolved or at least documented before
  
RTM.