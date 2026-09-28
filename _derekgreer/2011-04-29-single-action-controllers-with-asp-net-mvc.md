---
wordpress_id: 286
title: Single Action Controllers with ASP.Net MVC
date: 2011-04-29T01:40:16+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=286
dsq_thread_id:
  - "290982506"
dsq_needs_sync:
  - "1"
categories:
  - Uncategorized
tags:
  - ASP.NET MVC
---
While I’ve enjoyed working with the ASP.Net MVC Framework, one thing I wish that it provided is the ability to create controller-less actions. Why you ask? Because I’d rather my controllers only have one reason to change. While this isn’t provided out-of-the-box with ASP.Net MVC, single action controllers can be facilitated pretty easy with ASP.Net Routing.

Let’s say that we have a single CustomerController that has several actions for adding and retrieving customers which we’d like to split up. We could simply move these actions to separate controllers and register routes for each action to maintain the existing URL structure, but this could pose a maintenance issue down the road if you end up with many small controllers. There are some clever things we could do with dependency injection to provide a pretty nice solution, but I’m going to show you a really simple way of achieving this without a lot of extra wiring.

First, create a new class which extends System.Web.Routing.Route. Next, override the GetRouteData() method and paste in the following code:

<pre class="prettyprint">public override RouteData GetRouteData(HttpContextBase httpContext)
{
	RouteData routeData = base.GetRouteData(httpContext);

	if (routeData != null)
	{
		var controller = routeData.Values["controller"] as string;
		var action = routeData.Values["action"] as string;
		string controllerAction = string.Format("{0}{1}", controller, action);
		routeData.Values["controller"] = controllerAction;
		routeData.Values["action"] = "Execute";	}

	return routeData;
}
</pre>



Next, define a new route using your new custom Route class. To match the registration API provided by the framework, you can use the following extension method:

<pre class="prettyprint">public static class RouteCollectionExtensions
{
	public static Route MapActionRoute(this RouteCollection routes, string name, string url, object defaults, object constraints)
	{
		var route = new ActionRoute(url, new MvcRouteHandler())
		{
			Defaults = new RouteValueDictionary(defaults),
			Constraints = new RouteValueDictionary(constraints)
		};

		routes.Add(name, route);
		return route;
	}
}
</pre>



With this in place, the path “~/Customer/Get/1” will route to the following controller:

<pre class="prettyprint">public class CustomerGetController : Controller
{
	public ActionResult Execute(string id)
	{
		var customer = CustomerRepository.Get(id);
		return View("CustomerView", customer);
	}
}
</pre>



To see a full working example, I’ve provided a source-only NuGet package [here](http://nuget.org/List/Packages/ActionControllerExampleSource). If you have the [NuGet Command Line tool](http://nuget.codeplex.com/releases), open up a shell and run the following where you want the source:

<pre>>nuget install ActionControllerExampleSource
</pre>



If you have NuGet.exe in your path, you should be able to just build the solution. Otherwise, you’ll need to edit the batch file in the script directory to set the NuGet path so it can grab a few dependencies it uses. Enjoy.
