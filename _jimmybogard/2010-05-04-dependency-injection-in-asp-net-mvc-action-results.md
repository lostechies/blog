---
wordpress_id: 406
title: 'Dependency Injection in ASP.NET MVC: Action Results'
date: 2010-05-04T21:01:54+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/05/04/dependency-injection-in-asp-net-mvc-action-results.aspx
dsq_thread_id:
  - "264740650"
categories:
  - ASPNETMVC
  - DependencyInjection
---
On a recent, very large project, we started to notice a distinct trend in our controllers.&#160; All of our “POST” actions started to look very similar.&#160; Check form validation, run business rule validation.&#160; If validation succeeds, execute the actual business logic.&#160; If it fails, just show the view with the original form.

The problem we ran into was how to encapsulate this common behavior.&#160; We first went with some abomination of a base, CRUD controller.&#160; I should have listened to the OO luminaries, “Favor composition over inheritance”.

Our solution was to instead capture the common paths in a custom ActionResult, passing in the pieces of behavior that change into our ActionResult.&#160; The outcome was that we needed a way to inject services into our action results.&#160; The ExecuteResult method needed external services, which needed to be injected.

But that brought us to one of the fundamental problems with the design of an ActionResult.&#160; If you examine its responsibilities, it comes down to two things:

  * WHAT to do
  * HOW to do it

Unfortunately for us, these two responsibilities are intertwined on ActionResult.&#160; For example, in the ViewResult object, I set up the ViewName to render and so on.&#160; This makes it great for testing purposes, I only need to test the WHAT for controller actions.

However, the HOW for ActionResults usually winds up opening a huge can o’ worms.&#160; Taking ViewResult, the ExecuteResult method has a metric ton of behavior around it, choosing a view engine, finding the view, rendering the view and so on.&#160; Quite a lot for an object that just had a ViewName property on it.

We could go the route of filters, and perform property injection for the pieces needed in the ExecuteResult method.&#160; But property injection is mostly a hack, and should only be reserved in extreme cases.

Instead, I’ll take a route similar to the “[Better Action Result](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/12/12/enabling-ioc-in-asp-net-actionresults-or-a-better-actionresult.aspx)” post, and clearly separate the WHAT of an action result from the HOW.&#160; The result solidifies the controller’s responsibility as a traffic controller, solely directing traffic.

### The WHAT: an action method result

What I’m shooting for here is a POCO action method result.&#160; It has zero behavior, and only holds a representation of what I want to happen as the result of an action.&#160; If you took all of the existing action results and subtracted their “ExecuteResult” method, this is what I’m going for.

To make it sane, I’ll just create a new representation of an action method result in the form of a marker interface.&#160; Although it’s not completely POCO, a marker interface helps later on when integrating into the ControllerActionInvoker pipeline:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IActionMethodResult
</span>{
}</pre>

[](http://11011.net/software/vspaste)

Those wanting to create custom action method results just need to implement this interface, and add any data in the implementing class.

### The HOW: an action method result invoker

These custom action method results will still basically build up the regular action results.&#160; They will do whatever custom logic, and return an action result that will be consumed as normal by the MVC pipeline.&#160; The reasoning here is that all the custom action results I’ve ever needed to build always built up the existing action results.&#160; Staying with the eventual result of an ActionResult also lets me keep the concept of the ResultFilters in place.

Our action method result invoker will then take in an action method result, and return an ActionResult:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IActionMethodResultInvoker</span>&lt;T&gt;
    <span style="color: blue">where </span>T : <span style="color: #2b91af">IActionMethodResult
</span>{
    <span style="color: #2b91af">ActionResult </span>Invoke(T actionMethodResult, <span style="color: #2b91af">ControllerContext </span>context);
}

<span style="color: blue">public interface </span><span style="color: #2b91af">IActionMethodResultInvoker
</span>{
    <span style="color: #2b91af">ActionResult </span>Invoke(<span style="color: blue">object </span>actionMethodResult, <span style="color: #2b91af">ControllerContext </span>context);
}</pre>

[](http://11011.net/software/vspaste)

I defined two invokers, simple because it’s easier to perform the generic conversions of what’s all object-based to one that’s generic-based, through a simple facade:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">ActionMethodResultInvokerFacade</span>&lt;T&gt; 
    : <span style="color: #2b91af">IActionMethodResultInvoker 
    </span><span style="color: blue">where </span>T : <span style="color: #2b91af">IActionMethodResult
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IActionMethodResultInvoker</span>&lt;T&gt; _invoker;

    <span style="color: blue">public </span>ActionMethodResultInvokerFacade(<span style="color: #2b91af">IActionMethodResultInvoker</span>&lt;T&gt; invoker)
    {
        _invoker = invoker;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Invoke(<span style="color: blue">object </span>actionMethodResult, <span style="color: #2b91af">ControllerContext </span>context)
    {
        <span style="color: blue">return </span>_invoker.Invoke((T) actionMethodResult, context);
    }
}</pre>

[](http://11011.net/software/vspaste)

Implementers of an action method result invoker can use the generic interface, where I’ll wrap that generic version with a non-generic one and do the casting myself.

Finally, I need to override the CreateActionResult method in our custom action invoker:

<pre><span style="color: blue">protected override </span><span style="color: #2b91af">ActionResult </span>CreateActionResult(
    <span style="color: #2b91af">ControllerContext </span>controllerContext, 
    <span style="color: #2b91af">ActionDescriptor </span>actionDescriptor, 
    <span style="color: blue">object </span>actionReturnValue)
{
    <span style="color: blue">if </span>(actionReturnValue <span style="color: blue">is </span><span style="color: #2b91af">IActionMethodResult</span>)
    {
        <span style="color: blue">var </span>openWrappedType = <span style="color: blue">typeof</span>(<span style="color: #2b91af">ActionMethodResultInvokerFacade</span>&lt;&gt;);
        <span style="color: blue">var </span>actionMethodResultType = actionReturnValue.GetType();
        <span style="color: blue">var </span>wrappedResultType = openWrappedType.MakeGenericType(actionMethodResultType);

        <span style="color: blue">var </span>invokerFacade = (<span style="color: #2b91af">IActionMethodResultInvoker</span>) _container.GetInstance(wrappedResultType);

        <span style="color: blue">var </span>result = invokerFacade.Invoke(actionReturnValue, controllerContext);

        <span style="color: blue">return </span>result;
    }
    <span style="color: blue">return base</span>.CreateActionResult(controllerContext, actionDescriptor, actionReturnValue);
}</pre>

[](http://11011.net/software/vspaste)

Based on the action return value, I check to see if it’s an instance of our marker interface.&#160; If so, I’ll then construct the closed generic type of our invoker facade.&#160; This facade lets me call an “Invoke” method that accepts something of type “object”, instead of the “T” of the generic action method invoker interface.

Once I create the closed type of the invoker facade, I use the container to create an instance of this facade type.&#160; Since the facade also depends on the generic invoker, I’ll get the real invoker as well.&#160; Finally, I call the Invoke method, passing in the action return value (an IActionMethodResult), and return the result of that.

### Example: Executing commands

Now that I have an entry point for setting up external invokers that don’t have to rely on hokey property injection, or worse, service location, I can start to do really interesting invocation patterns in our controller actions.&#160; As I alluded earlier, our POST actions had the same pattern over and over again.&#160; I can now capture this in an action method result:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CommandMethodResult</span>&lt;TModel&gt; : <span style="color: #2b91af">IActionMethodResult
</span>{
    <span style="color: blue">public </span>CommandMethodResult(TModel model,
        <span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">ActionResult</span>&gt; successContinuation,
        <span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">ActionResult</span>&gt; failureContinuation)
    {
        Model = model;
        SuccessContinuation = successContinuation;
        FailureContinuation = failureContinuation;
    }

    <span style="color: blue">public </span>TModel Model { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">ActionResult</span>&gt; SuccessContinuation { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">ActionResult</span>&gt; FailureContinuation { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

This action method result represents the model of handling the form, plus what to on success and what to do on failure.&#160; The handler of this action method result can then contain the common path of validation, execution and success/failure:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CommandMethodResultInvoker</span>&lt;TModel&gt; 
    : <span style="color: #2b91af">IActionMethodResultInvoker</span>&lt;<span style="color: #2b91af">CommandMethodResult</span>&lt;TModel&gt;&gt; 
{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICommandMessageHandler</span>&lt;TModel&gt; _handler;

    <span style="color: blue">public </span>CommandMethodResultInvoker(<span style="color: #2b91af">ICommandMessageHandler</span>&lt;TModel&gt; handler)
    {
        _handler = handler;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Invoke(
        <span style="color: #2b91af">CommandMethodResult</span>&lt;TModel&gt; actionMethodResult, 
        <span style="color: #2b91af">ControllerContext </span>context)
    {
        <span style="color: blue">if </span>(!context.Controller.ViewData.ModelState.IsValid)
        {
            <span style="color: blue">return </span>actionMethodResult.FailureContinuation();
        }

        _handler.Handle(actionMethodResult.Model);

        <span style="color: blue">return </span>actionMethodResult.SuccessContinuation();
    }
}</pre>

[](http://11011.net/software/vspaste)

In the Invoke action, I first check to see if there are any validation errors.&#160; If so, then I’ll just return the failure result continuation (that Func<ActionResult>).&#160; It’s just a callback to the originating action on how to build up the failure ActionResult.

If there are no validation errors, then I hand off the form to an individual handler, an ICommandMessageHandler<T> that is responsible for \*only\* executing the success path of a POST.&#160; Finally, I execute the SuccessContinuation callback, and return the result of that.&#160; The command message handler is a rather simple interface:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">ICommandMessageHandler</span>&lt;T&gt;
{
    <span style="color: blue">void </span>Handle(T message);
}</pre>

[](http://11011.net/software/vspaste)

In this handler, I’ll have all the logic, services, etc. needed to process this form.&#160; Because I’m only responsible for the success path here, you won’t see any mixed responsibilities of creating ActionResults, checking ModelState and so on.&#160; To make it easier to build up the action method result, I’ll create a helper method on our controller layer supertype class:

<pre><span style="color: blue">protected </span><span style="color: #2b91af">CommandMethodResult</span>&lt;T&gt; Command&lt;T&gt;(
    T model, 
    <span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">ActionResult</span>&gt; successContinuation)
{
    <span style="color: blue">return new </span><span style="color: #2b91af">CommandMethodResult</span>&lt;T&gt;(
        model, 
        successContinuation, 
        () =&gt; View(model));
}</pre>

[](http://11011.net/software/vspaste)

Since the default of a failure action is just to show the same view with the same model, I pass that in as the default.&#160; Our controller action for POST then becomes very, very thin:

<pre>[<span style="color: #2b91af">HttpPost</span>]
<span style="color: blue">public </span><span style="color: #2b91af">CommandMethodResult</span>&lt;<span style="color: #2b91af">FooEditModel</span>&gt; Edit(<span style="color: #2b91af">FooEditModel </span>form)
{
    <span style="color: blue">return </span>Command(form, () =&gt; RedirectToAction(<span style="color: #a31515">"Index"</span>));
}</pre>

[](http://11011.net/software/vspaste)

One line!&#160; Testing this action also becomes a breeze, as I don’t need to set up some crazy failure/success paths, I only need to test the model property and the success/failure continuations in isolation.&#160; Finally, our handler for the form can do whatever it needs:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">FooEditModelHandler </span>: <span style="color: #2b91af">ICommandMessageHandler</span>&lt;<span style="color: #2b91af">FooEditModel</span>&gt;
{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IFooService </span>_service;

    <span style="color: blue">public </span>FooEditModelHandler(<span style="color: #2b91af">IFooService </span>service)
    {
        _service = service;
    }

    <span style="color: blue">public void </span>Handle(<span style="color: #2b91af">FooEditModel </span>message)
    {
        <span style="color: green">// handle this edit model somehow
    </span>}
}</pre>

[](http://11011.net/software/vspaste)

Because my handler has no responsibilities around ModelState, ViewData, ActionResults or anything else of that nature, it becomes very tightly focused and easy to maintain.

Finally, I need to configure StructureMap for all this new generic wiring:

<pre>Scan(scanner =&gt;
{
    scanner.TheCallingAssembly();
    scanner.WithDefaultConventions();
    scanner.ConnectImplementationsToTypesClosing(<span style="color: blue">typeof </span>(<span style="color: #2b91af">IActionMethodResultInvoker</span>&lt;&gt;));
    scanner.ConnectImplementationsToTypesClosing(<span style="color: blue">typeof </span>(<span style="color: #2b91af">ICommandMessageHandler</span>&lt;&gt;));
    scanner.Convention&lt;<span style="color: #2b91af">CommandMessageConvention</span>&gt;();
});</pre>

[](http://11011.net/software/vspaste)

I connect all closed implementations of the invokers and handlers, as well as add a custom convention to connection the pieces needed for the IActionMethodResultInvoker<CommandMethodResult<TModel>> interface to the CommandMethodResultInvoker<TModel> implementation:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CommandMessageConvention </span>: <span style="color: #2b91af">IRegistrationConvention
</span>{
    <span style="color: blue">public void </span>Process(<span style="color: #2b91af">Type </span>type, <span style="color: #2b91af">Registry </span>registry)
    {
        <span style="color: blue">if </span>(type.ImplementsInterfaceTemplate(<span style="color: blue">typeof</span>(<span style="color: #2b91af">ICommandMessageHandler</span>&lt;&gt;)))
        {
            <span style="color: blue">var </span>interfaceType = type.FindFirstInterfaceThatCloses(<span style="color: blue">typeof </span>(<span style="color: #2b91af">ICommandMessageHandler</span>&lt;&gt;));
            <span style="color: blue">var </span>commandMessageType = interfaceType.GetGenericArguments()[0];
            
            <span style="color: blue">var </span>openCommandMethodResultType = <span style="color: blue">typeof </span>(<span style="color: #2b91af">CommandMethodResult</span>&lt;&gt;);
            <span style="color: blue">var </span>closedCommandMethodResultType = openCommandMethodResultType.MakeGenericType(commandMessageType);

            <span style="color: blue">var </span>openActionMethodInvokerType = <span style="color: blue">typeof </span>(<span style="color: #2b91af">IActionMethodResultInvoker</span>&lt;&gt;);
            <span style="color: blue">var </span>closedActionMethodInvokerType =
                openActionMethodInvokerType.MakeGenericType(closedCommandMethodResultType);

            <span style="color: blue">var </span>openCommandMethodResultInvokerType = <span style="color: blue">typeof </span>(<span style="color: #2b91af">CommandMethodResultInvoker</span>&lt;&gt;);
            <span style="color: blue">var </span>closedCommandMethodResultInvokerType =
                openCommandMethodResultInvokerType.MakeGenericType(commandMessageType);

            registry.For(closedActionMethodInvokerType).Use(closedCommandMethodResultInvokerType);
        }
    }
}</pre>

[](http://11011.net/software/vspaste)

That last piece is a little crazy, but it can sometimes be a bit annoying to deal with open and closed generics with the reflection API.

### Wrapping it up

One of my biggest pet peeves in the MVC framework is the places where the WHAT is combined with the HOW.&#160; Filters and action results are two of these places.&#160; With filters, I opted for property injection to supply the needed services.&#160; With action results, I instead chose to separate those concerns.

The result is a much cleaner and extensible abstraction.&#160; I can modify the HOW of an action method result, without modifying the classes responsible for the WHAT.&#160; The action method results stay POCO, and the action method result invokers can get as complex as need be, but with the added power of dependency injection.&#160; My invokers can depend on whatever services they need to function, all completely orthogonal to pieces built from my controller actions.