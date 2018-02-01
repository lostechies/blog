---
id: 3955
title: FubuMVC – Define your actions your way
date: 2010-01-18T19:41:14+00:00
author: Joshua Flanagan
layout: post
guid: /blogs/joshuaflanagan/archive/2010/01/18/fubumvc-define-your-actions-your-way.aspx
dsq_thread_id:
  - "262113193"
categories:
  - FubuMVC
---
In this post I’m going to try and demonstrate the flexibility that <a href="http://fubumvc.com/" target="_blank">FubuMVC</a> allows in how you build your web applications. While FubuMVC is opinionated about some things (lean on your container as much as possible), it mostly gets out of your way to let you work the way you want. We know how valuable it can be to work with an opinionated framework that allows you to move quickly as long as you follow its conventions, but we also know how painful it can be when you find yourself fighting established conventions at every step. With FubuMVC, _you_ define the conventions and build your own opinionated framework, on top of which you build your applications. But don’t let the sound of building your own framework scare you off, as I’m going to demonstrate how little effort that requires.

## The sample application

I’ve built a very simple application that will help me illustrate the process. The application allows the user to make a list of movies they want to see.

[<img style="border-width: 0px;" src="http://lostechies.com/joshuaflanagan/files/2011/03/mymovies_thumb_5645EFC7.png" border="0" alt="mymovies" width="484" height="354" />](http://lostechies.com/joshuaflanagan/files/2011/03/mymovies_5CD96F57.png)

There are three actions that the application handles:

<table border="0" cellspacing="0" cellpadding="2" width="400">
  <tr>
    <td width="200" valign="top">
      <strong>Url (route)</strong>
    </td>
    
    <td width="200" valign="top">
      <strong>Description</strong>
    </td>
  </tr>
  
  <tr>
    <td width="200" valign="top">
      /movies/list
    </td>
    
    <td width="200" valign="top">
      show the list of movies
    </td>
  </tr>
  
  <tr>
    <td width="200" valign="top">
      /movies/add
    </td>
    
    <td width="200" valign="top">
      add a movie to the list
    </td>
  </tr>
  
  <tr>
    <td width="200" valign="top">
      /movies/remove
    </td>
    
    <td width="200" valign="top">
      remove a movie from the list
    </td>
  </tr>
</table>

I built three different implementations of the same application. All of the code is available in the <a href="http://github.com/DarthFubuMVC/fubumvc-examples/tree/db3770dfe028e09f10a0867a33b361130f590b0d/src/Actions" target="_blank">src/Actions</a> folder of the <a href="http://github.com/DarthFubuMVC/fubumvc-examples" target="_blank">fubumvc-examples</a> repository.

## Controller/Action

The first version of the application (<a href="http://github.com/DarthFubuMVC/fubumvc-examples/tree/db3770dfe028e09f10a0867a33b361130f590b0d/src/Actions/ControllerActionStyle" target="_blank">ControllerActionStyle</a>) uses the familiar “controller/action” approach, where multiple actions are defined on a single controller. The first part of the route identifies the controller class, and the second part is the name of a method to call on that class. This convention is fairly easy to declare, since FubuMVC already does a lot of it by default.

> Sidebar: Your conventions are declared by defining a class that derives from FubuRegistry and then passing it to a FubuBootstrapper (like FubuStructureMapBootstrapper) at application startup. FubuRegistry exposes a DSL for you to use to describe things like: how to identify methods that should be treated as actions, what the routes for those actions should be, how to decide the output for those actions, and if the output is rendered from a view, which view should it use.

The relevant parts in our <a href="http://github.com/DarthFubuMVC/fubumvc-examples/blob/db3770dfe028e09f10a0867a33b361130f590b0d/src/Actions/ControllerActionStyle/SimpleWebsite/SimpleWebsiteFubuRegistry.cs" target="_blank">registry</a> are:

<div class="wlWriterEditableSmartContent" style="margin: 0px; float: none; padding: 0px;">
  <pre class="brush: csharp; gutter:false; wrap-lines:false; tab-size:2;">Actions.IncludeTypesNamed(x =&gt; x.EndsWith("Controller"));

Routes.IgnoreControllerNamespaceEntirely();</pre>
</div>

This tells FubuMVC to look at all available types whose name ends with the word “Controller”. By default, all public methods (with, at most, 1 input parameter) are treated as actions, so nothing further needs to be specified. It also tells FubuMVC to ignore the namespace on controller classes when building routes. By default, routes are defined as parts/of/namespace/classname/methodname (and the “controller” suffix of the classname is removed by default). By stating we want to ignore the namespace, our routes will look like classname/methodname.

Following this convention, I built a <a href="http://github.com/DarthFubuMVC/fubumvc-examples/blob/db3770dfe028e09f10a0867a33b361130f590b0d/src/Actions/ControllerActionStyle/SimpleWebsite/Controllers/MoviesController.cs" target="_blank">MoviesController</a> class which contains methods for List(), Add(), and Remove().

&nbsp;

<div class="wlWriterEditableSmartContent" style="margin: 0px; float: none; padding: 0px;">
  <pre class="brush: csharp; gutter:false; wrap-lines:false; tab-size:2;">public class MoviesController
{
    public ListMoviesViewModel List()
    {
		//
    }

    public AjaxResponse Add(AddMovieInput model)
    {
		//
    }

    public AjaxResponse Remove(RemoveMovieInput model)
    {
		//
    }
}</pre>
</div>

To verify that everything is configured correctly, I open my browser to http://localhost/myapp/_fubu/ to view the list of routes and what actions they will call:

| Route         | Action(s)                 | Output(s)                                          |
| ------------- | ------------------------- | -------------------------------------------------- |
| movies/add    | MoviesController.Add()    | Json                                               |
| movies/list   | MoviesController.List()   | WebForm View &#8216;~/Controllers/List.aspx&#8217; |
| movies/remove | MoviesController.Remove() | Json                                               |

## Controller-less Actions

The second version of the application (<a href="http://github.com/DarthFubuMVC/fubumvc-examples/tree/db3770dfe028e09f10a0867a33b361130f590b0d/src/Actions/HandlerStyle" target="_blank">HandlerStyle</a>) defines each action within its own handler class. This is sometimes referred to as the “controller-less action” approach. I started with the code from the ControllerActionStyle and pulled all of the actions out of MoviesController into their own classes ListHandler, AddHandler, and RemoveHandler in a Movies subfolder. They all have a single public method named “Execute” which does all of the work for that action. You might think that with such a drastic change in how actions are organized that I would need to write a lot of code to wire everything up again. But since I’m still following a convention, I just need to describe it to FubuMVC in my <a href="http://github.com/DarthFubuMVC/fubumvc-examples/blob/db3770dfe028e09f10a0867a33b361130f590b0d/src/Actions/HandlerStyle/SimpleWebsite/SimpleWebsiteFubuRegistry.cs" target="_blank">registry</a>:

<div class="wlWriterEditableSmartContent" style="margin: 0px; float: none; padding: 0px;">
  <pre class="brush: csharp; gutter:false; wrap-lines:false; tab-size:2;">Actions
    .IncludeTypes(t =&gt; t.Namespace.StartsWith(typeof(HandlerUrlPolicy).Namespace) && t.Name.EndsWith("Handler"))
    .IncludeMethods(action =&gt; action.Method.Name == "Execute");

Routes.UrlPolicy&lt;HandlerUrlPolicy&gt;();</pre>
</div>

This states that actions are located by looking for public methods named “Execute” on types in the Handlers namespace whose name ends with “Handler”. Since my routes no longer follow the usual classname/methodname pattern, I defined a custom URL policy in <a href="http://github.com/DarthFubuMVC/fubumvc-examples/blob/db3770dfe028e09f10a0867a33b361130f590b0d/src/Actions/HandlerStyle/SimpleWebsite/Handlers/HandlerUrlPolicy.cs" target="_blank">HandlerUrlPolicy</a>:

<div class="wlWriterEditableSmartContent" style="margin: 0px; float: none; padding: 0px;">
  <pre class="brush: csharp; gutter:false; wrap-lines:false; tab-size:2;">public class HandlerUrlPolicy : IUrlPolicy {
    public bool Matches(ActionCall call)
    {
        return call.HandlerType.Name.EndsWith("Handler");
    }

    public IRouteDefinition Build(ActionCall call)
    {
        var routeDefinition = call.ToRouteDefinition();
        routeDefinition.Append(call.HandlerType.Namespace.Replace(GetType().Namespace + ".", string.Empty).ToLower());
        routeDefinition.Append(call.HandlerType.Name.Replace("Handler", string.Empty).ToLower());
        return routeDefinition;
    }
}</pre>
</div>

The Matches method states that this policy only applies to actions whose type name ends with “Handler”. This allows us to have different URL conventions for different parts of an application. The Build method is where we state what the route should look like for each action.

> Side note: If you are coming from ASP.NET MVC, you may have picked up on a difference in how routes are defined. With ASP.NET MVC, you define route patterns at application startup (ex: {controller}/{action}), and then as a request comes in, a route pattern is matched, and the MvcRouteHandler object uses the parameter values to try and locate an action (which may not exist). In FubuMVC, each route has its own IRouteHandler in the container which is tied directly its action up front. Every addressable action has an entry in the route table, so if a route is matched, we know exactly which action to execute. FubuMVC routes can still have parameters, but they are only used to provides inputs to the action – not to determine the action.

We build the first part of the route by taking the namespace of our action types (SimpleWebsite.Handlers.Movies) and chopping off the beginning part (SimpleWebsite.Handlers), which is the namespace of the HandlerUrlPolicy. The second part of the route is determined by taking the name of the type where the action is defined and chopping off the “Handler” suffix. Now when we browse to _fubu we see that our routes are still the same as they were in the ControllerActionStyle, but they map to our new actions:

| Route         | Action(s)               | Output(s)                                              |
| ------------- | ----------------------- | ------------------------------------------------------ |
| movies/add    | AddHandler.Execute()    | Json                                                   |
| movies/list   | ListHandler.Execute()   | WebForm View &#8216;~/Handlers/Movies/List.aspx&#8217; |
| movies/remove | RemoveHandler.Execute() | Json                                                   |

## REST-like

The final version of the application (<a href="http://github.com/DarthFubuMVC/fubumvc-examples/tree/db3770dfe028e09f10a0867a33b361130f590b0d/src/Actions/EndPointStyle" target="_blank">EndPointStyle</a>) defines each action in a REST_ish_ manner (I’m not brave enough to claim REST_ful_). It is similar to the HandlerStyle approach in that each route is handled by a single class, but instead of a single “Execute” method, there is a method for each HTTP method (GET, POST, etc) that is valid for the endpoint. Once again, the convention is defined in our <a href="http://github.com/DarthFubuMVC/fubumvc-examples/blob/db3770dfe028e09f10a0867a33b361130f590b0d/src/Actions/EndPointStyle/SimpleWebsite/SimpleWebsiteFubuRegistry.cs" target="_blank">registry</a>:

<div class="wlWriterEditableSmartContent" style="margin: 0px; float: none; padding: 0px;">
  <pre class="brush: csharp; gutter:false; wrap-lines:false; tab-size:2;">var httpVerbs = new HashSet&lt;string&gt;(StringComparer.InvariantCultureIgnoreCase)
    {"GET", "POST", "PUT", "HEAD"};

Actions
    .IncludeTypes(t =&gt; t.Namespace.StartsWith(typeof(EndPointUrlPolicy).Namespace) && t.Name.EndsWith("Endpoint"))
    .IncludeMethods(action =&gt; httpVerbs.Contains(action.Method.Name));

httpVerbs.Each(verb =&gt; Routes.ConstrainToHttpMethod(action =&gt; action.Method.Name.Equals(verb, StringComparison.InvariantCultureIgnoreCase), verb));

Routes.UrlPolicy&lt;EndPointUrlPolicy&gt;();</pre>
</div>

Actions are located by searching all types with the “Endpoint” suffix in the Endpoint namespace for methods named after an HTTP method. Routes are constructed in a custom URL policy (<a href="http://github.com/DarthFubuMVC/fubumvc-examples/blob/db3770dfe028e09f10a0867a33b361130f590b0d/src/Actions/EndPointStyle/SimpleWebsite/EndPoints/EndPointUrlPolicy.cs" target="_blank">EndPointUrlPolicy</a>) that has the same logic we used in the HandlerStyle example (namespace/classnamewithoutsuffix). In line 24, I add a policy that constrains the acceptable HTTP method for a route based on the name of the class method that handles it (ex: the Get() method should only respond to HTTP GETs). This enables us to tie the same route pattern to multiple actions, based on how the request is made.

To demonstrate this functionality, I added a new feature to the sample application: the ability to sort your movies in your order of preference, and have the system remember that order. When the movies are sorted (using the very cool <a href="http://www.jqueryui.com/demos/sortable/" target="_blank">jQuery sortable</a>), a message is posted to movies/list endpoint with the new order. The Post() method on the <a href="http://github.com/DarthFubuMVC/fubumvc-examples/blob/db3770dfe028e09f10a0867a33b361130f590b0d/src/Actions/EndPointStyle/SimpleWebsite/EndPoints/Movies/ListEndpoint.cs" target="_blank">ListEndpoint</a> is invoked to save the order in the repository, as opposed to the Get() method on ListEndpoint which displays the current list of movies.

<div class="wlWriterEditableSmartContent" style="margin: 0px; float: none; padding: 0px;">
  <pre class="brush: csharp; gutter:false; wrap-lines:false; tab-size:2;">public class ListEndpoint
{
    public ListMoviesViewModel Get()
    {
		// show the current list of movies
    }

    public AjaxResponse Post(UpdateMovieListOrder input)
    {
		// save the order in which the movies should be displayed
    }</pre>
</div>

Another visit to the _fubu diagnostics page confirms the routes are wired up as we intended (note that movies/list shows up twice, with 2 different actions):

| Route                | Action(s)             | Output(s)                                               |
| -------------------- | --------------------- | ------------------------------------------------------- |
| [POST] movies/add    | AddEndpoint.Post()    | Json                                                    |
| [GET] movies/list    | ListEndpoint.Get()    | WebForm View &#8216;~/EndPoints/Movies/List.aspx&#8217; |
| [POST] movies/list   | ListEndpoint.Post()   | Json                                                    |
| [POST] movies/remove | RemoveEndpoint.Post() | Json                                                    |

### Wrap Up

If you compare the three implementations of the movie application, you will notice that very little had to change as far as FubuMVC is concerned. By changing a couple lines in my FubuRegistry and creating a custom IUrlPolicy with 5 lines of logic, I was able to establish conventions to let me build my application in my preferred style (controllers, handlers, or endpoints). Other .NET web frameworks may have the extension points to allow each of these styles, but I’d be willing to bet you would have to write a lot more custom code and possibly have to give up some of the out of the box functionality the framework provides (if you prove me wrong, leave a comment and I’ll update the post to link to your example).