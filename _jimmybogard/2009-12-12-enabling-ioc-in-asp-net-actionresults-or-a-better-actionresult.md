---
wordpress_id: 376
title: Enabling IoC in ASP.NET ActionResults (or, a better ActionResult)
date: 2009-12-12T16:25:42+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/12/12/enabling-ioc-in-asp-net-actionresults-or-a-better-actionresult.aspx
dsq_thread_id:
  - "264716386"
categories:
  - ASPNETMVC
redirect_from: "/blogs/jimmy_bogard/archive/2009/12/12/enabling-ioc-in-asp-net-actionresults-or-a-better-actionresult.aspx/"
---
One of the more interesting abstractions in ASP.NET MVC is the concept of an action result.&#160; Instead of calling a method to direct the result of calling an action, such as frameworks like Rails allows:

> <pre>def create
      @book = Book.new(params[:book])
      if @book.save
            redirect_to :action =&gt; 'list'
      else
            @subjects = Subject.find(:all)
            render :action =&gt; 'new'
      end
   end</pre>

Instead, the return value of an action directs the MVC pipeline on what to do next:

<pre><span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Index()
{
    ViewData[<span style="color: #a31515">"Message"</span>] = <span style="color: #a31515">"Welcome to ASP.NET MVC!"</span>;

    <span style="color: blue">return </span>View();
}</pre>

[](http://11011.net/software/vspaste)

Instead of displaying the view when the View method is called, the command to render a view is packaged up into a ViewResult object, containing all of the information needed to render a view.&#160; This is the basic command pattern, and each derived ActionResult is a different command.&#160; There are quite a few subclasses of ActionResult, each representing a different command for the MVC pipeline:

  * JsonResult
  * ViewResult
  * RedirectResult
  * FileResult
  * etc

If you want custom processing of the result of an action, a custom ActionResult is what you’re looking for.&#160; We have quite a few in our applications, including:

  * Streaming a CSV version of the current screen
  * Executing a domain command
  * Executing a delete

And a few more.&#160; While the abstraction of a parameter object to represent a command is a fantastic idea, the design of the ActionResult type is hindered by too many responsibilities.&#160; Namely, an ActionResult is responsible for:

  * Representing the parameter object of a command
  * Executing the command

It’s that second responsibility that can hinder some more interesting scenarios.&#160; Because the controller action needs to instantiate a parameter object as the result of an action, I’m often reduced to sub-optimal service location to do the actual work of the executing action.&#160; For example, the delete action result might look something like:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DeleteRequestResult</span>&lt;TModel&gt; : <span style="color: #2b91af">ActionResult
</span>{
    <span style="color: blue">private readonly </span>TModel _model;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">ActionResult</span>&gt; _successRedirect;

    <span style="color: blue">public </span>DeleteRequestResult(TModel model, <span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">ActionResult</span>&gt; successRedirect)
    {
        _model = model;
        _successRedirect = successRedirect;
    }

    <span style="color: blue">public </span>TModel Model { <span style="color: blue">get </span>{ <span style="color: blue">return </span>_model; } }
    <span style="color: blue">public </span><span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">ActionResult</span>&gt; SuccessRedirect { <span style="color: blue">get </span>{ <span style="color: blue">return </span>_successRedirect; } }
    
    <span style="color: blue">public override void </span>ExecuteResult(<span style="color: #2b91af">ControllerContext </span>context)
    {
        <span style="color: green">// Service location, boooooo!
        </span><span style="color: blue">var </span>repository = <span style="color: #2b91af">IoC</span>.GetInstance&lt;<span style="color: #2b91af">IRepository</span>&lt;TModel&gt;&gt;();
        <span style="color: blue">var </span>logger = <span style="color: #2b91af">IoC</span>.GetInstance&lt;<span style="color: #2b91af">IDomainLogger</span>&gt;();

        repository.Delete(Model);
        logger.LogDelete(Model);

        <span style="color: blue">var </span>redirectResult = SuccessRedirect();

        redirectResult.ExecuteResult(context);
    }
}</pre>

[](http://11011.net/software/vspaste)

I have to resort to service location (blech) to load up the right dependencies to do the actual work of processing a delete request.&#160; However, instead of relying on the ActionResult to be responsible for executing the command, I’ll instead allow _something else_ take over that responsibility.

### Separating the ActionResult concerns

First, I need to define an abstraction of something that can execute an ActionResult.&#160; That sounds like an IActionResultInvoker to me:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IActionResultInvoker</span>&lt;TActionResult&gt;
    <span style="color: blue">where </span>TActionResult : <span style="color: #2b91af">ActionResult
</span>{
    <span style="color: blue">void </span>ExecuteResult(TActionResult actionResult, <span style="color: #2b91af">ControllerContext </span>context);
}</pre>

[](http://11011.net/software/vspaste)

The signature is very similar to ActionResult, but this time, it’s a separate object that receives the parameter object (the ActionResult), the ControllerContext, and actually performs the work.&#160; Next, I need to now direct the default action invoker to invoke action results through my abstraction, instead of going through the regular action result itself.&#160; However, because all of the built-in action results aren’t going to change, I need to handle that scenario.&#160; To accomplish this, I’ll create a new ActionResult type:

<pre><span style="color: blue">public abstract class </span><span style="color: #2b91af">BetterActionResult </span>: <span style="color: #2b91af">ActionResult
</span>{
    <span style="color: blue">public override void </span>ExecuteResult(<span style="color: #2b91af">ControllerContext </span>context)
    {
        <span style="color: blue">throw new </span><span style="color: #2b91af">NotImplementedException</span>(<span style="color: #a31515">"Should be executed with an IActionResultInvoker"</span>);
    }
}</pre>

[](http://11011.net/software/vspaste)

That should be enough to provide some notification when we’re developing if we haven’t hooked things up correctly.&#160; Next, I’ll need the default action invoker overrides:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">IoCActionInvoker </span>: <span style="color: #2b91af">ControllerActionInvoker
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IContainer </span>_container;

    <span style="color: blue">public </span>IoCActionInvoker(<span style="color: #2b91af">IContainer </span>container)
    {
        _container = container;
    }

    <span style="color: blue">protected override void </span>InvokeActionResult(<span style="color: #2b91af">ControllerContext </span>controllerContext, <span style="color: #2b91af">ActionResult </span>actionResult)
    {
        <span style="color: blue">if </span>(actionResult <span style="color: blue">is </span><span style="color: #2b91af">BetterActionResult</span>)
        {
            <span style="color: green">// Close the IActionResultInvoker&lt;&gt; open generic type
            </span><span style="color: blue">var </span>actionResultInvokerType = <span style="color: blue">typeof </span>(<span style="color: #2b91af">IActionResultInvoker</span>&lt;&gt;).MakeGenericType(actionResult.GetType());

            <span style="color: green">// Get the invoker from the container
            </span><span style="color: blue">var </span>actionResultInvoker = _container.GetInstance(actionResultInvokerType);

            <span style="color: green">// Get the generic ExecuteResult method
            </span><span style="color: blue">var </span>executeResultMethod = actionResultInvokerType.GetMethod(<span style="color: #a31515">"ExecuteResult"</span>);

            <span style="color: green">// Call the ExecuteResult method
            </span>executeResultMethod.Invoke(actionResultInvoker, <span style="color: blue">new object</span>[] { actionResult, controllerContext });
        }
        <span style="color: blue">else
        </span>{
            <span style="color: blue">base</span>.InvokeActionResult(controllerContext, actionResult);
        }
    }
}</pre>

[](http://11011.net/software/vspaste)

It’s a lot of code, but what I’m basically doing here is looking for derived BetterActionResult action results, and using my StructureMap container to load up the correct IActionResultInvoker for that derived ActionResult type.&#160; In the example above, I use just basic reflection for calling the ExecuteResult method, but in practice, I’ll use caching and an optimized mechanism for reflection.

### 

### Connecting the action invoker to the MVC pipeline

Now, I could have used a looser-typed signature for IActionResultInvoker, and not needed to do this reflection business.&#160; However, it’s critical that I load up the _correct_ IActionResultInvoker for my derived BetterActionResult.&#160; Using generics is a great way to use the type system for routing to the correct handler.&#160; To replace the existing action invoker, I have a couple of choices.&#160; One simple way of doing so is to modify the controller factory (that I’m already overriding for using IoC to instantiate my controllers):

<pre><span style="color: blue">public class </span><span style="color: #2b91af">ControllerFactory </span>: <span style="color: #2b91af">DefaultControllerFactory
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IContainer </span>_container;

    <span style="color: blue">public </span>ControllerFactory(<span style="color: #2b91af">IContainer </span>container)
    {
        _container = container;
    }

    <span style="color: blue">protected override </span><span style="color: #2b91af">IController </span>GetControllerInstance(<span style="color: #2b91af">Type </span>controllerType)
    {
        <span style="color: blue">if </span>(controllerType == <span style="color: blue">null</span>)
            <span style="color: blue">return null</span>;

        <span style="color: blue">var </span>controller = (<span style="color: #2b91af">Controller</span>)_container.GetInstance(controllerType);

        controller.ActionInvoker = _container.GetInstance&lt;<span style="color: #2b91af">IoCActionInvoker</span>&gt;();

        <span style="color: blue">return </span>controller;
    }
}</pre>

[](http://11011.net/software/vspaste)

My custom controller factory is already hooked up using a technique [like this one](http://codeclimber.net.nz/archive/2009/02/05/how-to-use-ninject-with-asp.net-mvc.aspx), I don’t have to do anything extra to make sure my action invoker gets executed.&#160; I just overrode the method I needed, hooked up the action invoker on controller construction time, and I’m ready to go.

The next piece is to actually define my custom action invoker, and refactor my existing DeleteRequestResult type.

### Defining a new invoker and action result

First, I’ll need a new ActionResult type for my original representation of a delete request.&#160; This time, I’ll only have the parameters needed to perform the action, and my action invoker will take care of the rest.&#160; The custom action result type now becomes very simple:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DeleteRequestResult</span>&lt;TModel&gt; : <span style="color: #2b91af">BetterActionResult
</span>{
    <span style="color: blue">public </span>DeleteRequestResult(TModel model, <span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">ActionResult</span>&gt; successRedirect)
    {
        Model = model;
        SuccessRedirect = successRedirect;
    }

    <span style="color: blue">public </span>TModel Model { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">ActionResult</span>&gt; SuccessRedirect { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

I’m no longer mixing the concerns of parameter object and command execution any more.&#160; Instead, I’ll define a new custom action invoker:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DeleteRequestResultInvoker</span>&lt;TModel&gt; 
    : <span style="color: #2b91af">IActionResultInvoker</span>&lt;<span style="color: #2b91af">DeleteRequestResult</span>&lt;TModel&gt;&gt;
{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IRepository</span>&lt;TModel&gt; _repository;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IDomainLogger </span>_logger;

    <span style="color: blue">public </span>DeleteRequestResultInvoker(<span style="color: #2b91af">IRepository</span>&lt;TModel&gt; repository, <span style="color: #2b91af">IDomainLogger </span>logger)
    {
        _repository = repository;
        _logger = logger;
    }

    <span style="color: blue">public void </span>ExecuteResult(<span style="color: #2b91af">DeleteRequestResult</span>&lt;TModel&gt; actionResult, <span style="color: #2b91af">ControllerContext </span>context)
    {
        _repository.Delete(actionResult.Model);
        _logger.LogDelete(actionResult.Model);

        <span style="color: blue">var </span>redirectResult = actionResult.SuccessRedirect();

        redirectResult.ExecuteResult(context);
    }
}</pre>

[](http://11011.net/software/vspaste)

Now, when my IoCActionInvoker looks for an action invoker for DeleteRequestResult<TModel>, it will find my custom action invoker, instantiate it with IoC, and use its ExecuteResult method.&#160; The controller action becomes pretty small now:

<pre><span style="color: blue">public </span><span style="color: #2b91af">DeleteRequestResult</span>&lt;<span style="color: #2b91af">Product</span>&gt; Delete(<span style="color: #2b91af">Product </span>productId)
{
    <span style="color: blue">return new </span><span style="color: #2b91af">DeleteRequestResult</span>&lt;<span style="color: #2b91af">Product</span>&gt;(productId, () =&gt; RedirectToAction(<span style="color: #a31515">"Index"</span>));
}</pre>

[](http://11011.net/software/vspaste)

When I go to test this action now, I only need to make sure that the product supplied is correct and the success redirect is correct.&#160; Because deletions don’t really change in our domain, we abstracted deletions into a separate ActionResult and IActionResultInvoker.

### Wrapping it up

The piece I didn’t show here is how to hook up your IoC container to tell it that when it looks for an IActionResultInvoker<DeleteRequestResult<TModel>>, it loads up the DeleteRequestResultInvoker<TModel>.&#160; That code is different for every container, so I’ll go into that piece in a future post.

The interesting part about this pattern is that I’m able to separate the concerns of a parameter object representing the results of an action, and the actual processing of that parameter object.&#160; These two concerns usually have different reasons for change, and I’d rather not rely on things like service location for opaque dependency resolution in the execution of the ActionResult.&#160; Because our IoC registration discovers new invokers quite easily, I never really need to add any new code for new action result invokers.&#160; I merely need to create a new BetterActionResult type, define an invoker, and my IoC container does the rest.

The custom ActionResult made it easy to represent common execution patterns, in a way that doesn’t pollute my controllers with duplication and enables much easier testing.&#160; Just as I don’t test a ViewResult for the contents of a view, in my example, I just make sure the custom ActionResult gets the correct parameters.&#160; While many areas in MVC are designed for IoC scenarios in mind, others are not.&#160; However, with some creative changes, we can enable places like ActionResult execution pipeline for powerful IoC scenarios.