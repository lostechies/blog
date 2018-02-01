---
id: 260
title: Attributes are lousy decorators
date: 2008-12-09T04:07:10+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/12/08/attributes-are-lousy-decorators.aspx
dsq_thread_id:
  - "264715993"
categories:
  - ASPNETMVC
---
Attributes allow developers to provide a mechanism to add metadata to types, assemblies, type members, method parameters, and just about anything else under the sun.&#160; One of the first trends I noticed in my early days of combing the BCL with Reflector was that without fail, no attribute type provided any behavior.&#160; The only information an attribute provided was its type and its properties, but I never found a method that did any work.&#160; Which makes sense, as attributes define metadata, not behavior.

But in ASP.NET MVC, this pattern is broken with the ActionFilterAttribute.&#160; Because a single controller can have many actions, it’s difficult to create a mechanism that executes code before or after any single action and not any other.&#160; Since attributes can be placed on both method and class declarations, this would seem like an ideal candidate to specify before/after behavior on a controller action.

The problem is that attributes aren’t designed to have behavior, and are a lousy implementation of the [decorator pattern](http://www.dofactory.com/Patterns/PatternDecorator.aspx).&#160; It’s important to remember that developers have little to zero control over when attribute instances are created, which is why you [never want an exception to be thrown in an attribute constructor](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/11/22/beware-exceptions-in-attribute-constructors.aspx).

Since you don’t have control over the construction, and can’t provide an alternative construction method like an IoC container to do the instantiation, you wind up having to do things like this:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">BadBadFilterAttribute </span>: <span style="color: #2b91af">ActionFilterAttribute
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICustomerRepository </span>_customerRepository;

    <span style="color: blue">public </span>BadBadFilterAttribute() : <span style="color: blue">this</span>(<span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">ICustomerRepository</span>&gt;())
    {
    }

    <span style="color: blue">private </span>BadBadFilterAttribute(<span style="color: #2b91af">ICustomerRepository </span>customerRepository)
    {
        _customerRepository = customerRepository;
    }

    <span style="color: blue">public override void </span>OnActionExecuting(<span style="color: #2b91af">ActionExecutingContext </span>filterContext)
    {
        <span style="color: green">// Fetch the customer or something
    </span>}
}</pre>

[](http://11011.net/software/vspaste)

We’re attempting to use StructureMap to locate the dependency for this attribute, a Customer repository.&#160; However, since I don’t control when that constructor is called, I can get some weird behavior and exceptions when doing simple things like reflection.&#160; But since reflection triggers attribute constructors, often I’ll see StructureMap spinning up trying to locate dependencies, when all I wanted to do was inspect the metadata.

Since attributes are the built-in mechanism for adding decorator behavior to an action, you can borrow the MonoRail method of providing action filters.&#160; In addition to the MVC way, MonoRail allows you to simply specify the type of the IFilter, and it will create and execute that filter for you.&#160; This way, you don’t need to create an attribute class, but instead just an implementation of IFilter.&#160; This is easy to do in MVC as well:

<pre>[<span style="color: #2b91af">AttributeUsage</span>(<span style="color: #2b91af">AttributeTargets</span>.Class | <span style="color: #2b91af">AttributeTargets</span>.Method)]
<span style="color: blue">public sealed class </span><span style="color: #2b91af">ContainerLocatedActionFilterAttribute </span>: <span style="color: #2b91af">FilterAttribute</span>, <span style="color: #2b91af">IActionFilter
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">Type </span>_actionFilter;

    <span style="color: blue">public </span>ContainerLocatedActionFilterAttribute(<span style="color: #2b91af">Type </span>actionFilter)
    {
        _actionFilter = actionFilter;
    }

    <span style="color: blue">public void </span>OnActionExecuting(<span style="color: #2b91af">ActionExecutingContext </span>filterContext)
    {
        <span style="color: blue">var </span>instance = (<span style="color: #2b91af">IActionFilter</span>)<span style="color: #2b91af">ObjectFactory</span>.GetInstance(_actionFilter);
        instance.OnActionExecuting(filterContext);
    }

    <span style="color: blue">public void </span>OnActionExecuted(<span style="color: #2b91af">ActionExecutedContext </span>filterContext)
    {
        <span style="color: blue">var </span>instance = (<span style="color: #2b91af">IActionFilter</span>)<span style="color: #2b91af">ObjectFactory</span>.GetInstance(_actionFilter);
        instance.OnActionExecuted(filterContext);
    }
}</pre>

[](http://11011.net/software/vspaste)

Our filter can simply be an IActionFilter (or some other interface, at this point, it really doesn’t matter), without worrying about thread safety and other issues with attribute instances.&#160; Although attributes are nice in that they’re declarative and defined at the point of most usefulness (on the action or controller), attributes in general weren’t designed with behavior in mind.&#160; It’s possible to get yourself into threading trouble if you don’t understand how attributes are instantiated and allocated, which usually requires a good read in the CLR via C# book.

There are other ways to provide decorators for actions, which I’ll look at in <strike>the next</strike> a future post.