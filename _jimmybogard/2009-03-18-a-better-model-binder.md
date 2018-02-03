---
wordpress_id: 297
title: A better Model Binder
date: 2009-03-18T02:07:21+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/03/17/a-better-model-binder.aspx
dsq_thread_id:
  - "264716102"
categories:
  - ASPNETMVC
---
One of the more interesting extension points in ASP.NET MVC are the Model Binders.&#160; Model Binders are tasked with transforming the HTTP Form and Querystring information and coercing real .NET types out of them.&#160; A normal POST is merely a set of string key-value pairs, which isn’t that fun to work with.

Back in the ASP 3.0 days, where I cut my teeth, we did a lot of “Request.Form(“CustFirstName”)” action, and just dealing with the mapping from HTTP to strong types manually.&#160; That wasn’t very fun.

ASP.NET MVC supplies the DefaultModelBinder, which is able to translate HTTP request information into complex models, including nested types and arrays.&#160; It does this through a naming convention, which is supported at both the HTML generation (HTML helpers) and the consumption side (model binders).

Reconstituting complex model objects works great, especially in form posting scenarios.&#160; But there are some scenarios where we want more complex binding, and for these scenarios, we can supply custom model binders.

### Quick glance at custom model binders

ASP.NET MVC allows us to override both the default model binder, as well as add custom model binders, through the ModelBinders static class:

<pre><span style="color: #2b91af">ModelBinders</span>.Binders.DefaultBinder = <span style="color: blue">new </span><span style="color: #2b91af">SomeCustomDefaultBinder</span>();
<span style="color: #2b91af">ModelBinders</span>.Binders.Add(<span style="color: blue">typeof</span>(<span style="color: #2b91af">DateTime</span>), <span style="color: blue">new </span><span style="color: #2b91af">DateTimeModelBinder</span>());</pre>

[](http://11011.net/software/vspaste)

The custom binders are bound by destination type.&#160; We can also use the Bind attribute to supply the type of the custom binder directly on our complex model type.&#160; The resolution code (from CodePlex) is:

<pre><span style="color: blue">private </span><span style="color: #2b91af">IModelBinder </span>GetBinder(<span style="color: #2b91af">Type </span>modelType, <span style="color: #2b91af">IModelBinder </span>fallbackBinder)
{
    <span style="color: green">// Try to look up a binder for this type. We use this order of precedence:
    // 1. Binder registered in the global table
    // 2. Binder attribute defined on the type
    // 3. Supplied fallback binder

    </span><span style="color: #2b91af">IModelBinder </span>binder;
    <span style="color: blue">if </span>(_innerDictionary.TryGetValue(modelType, <span style="color: blue">out </span>binder))
    {
        <span style="color: blue">return </span>binder;
    }

    binder = <span style="color: #2b91af">ModelBinders</span>.GetBinderFromAttributes(modelType,
        () =&gt; <span style="color: #2b91af">String</span>.Format(<span style="color: #2b91af">CultureInfo</span>.CurrentUICulture, MvcResources.ModelBinderDictionary_MultipleAttributes, modelType.FullName));

    <span style="color: blue">return </span>binder ?? fallbackBinder;
}</pre>

[](http://11011.net/software/vspaste)

Very nice, they even commented the order of precedence!

This is all well and good, but the custom model binding resolution leaves me wanting.&#160; It only works if the destination type matches _exactly_ with a type registered in the custom binder collection.&#160; That’s great, unless you want to use something like binding against a base class, such as a layer super type of Entity or similar.&#160; Suppose I want to bind all Entities by fetching them out of a Repository automatically?&#160; That would allow me to just put our entity types as action parameter types, instead of GUIDs littered all over the place.&#160; It gets even worse as some ORMs (NHibernate being one) use proxies to do lazy loading, and the runtime type is some crazy derived type you’ve never heard of.

But we can do better.

### A new default binder

Instead of using the ModelBinders.Binders.Add method, let’s put all of our matching in our default binder, a new binder, a SmartBinder.&#160; This SmartBinder can still have all the default binding logic, but this time, it will attempt to match individual custom binders themselves.&#160; To do this, let’s define a new IModelBinder interface:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IFilteredModelBinder </span>: <span style="color: #2b91af">IModelBinder
</span>{
    <span style="color: blue">bool </span>IsMatch(<span style="color: #2b91af">Type </span>modelType);
}</pre>

[](http://11011.net/software/vspaste)

Instead of our ModelBinderDictionary containing the matching logic, let’s put this where _I_ believe it belongs – with each individual binder.&#160; Model binders make a ton of assumptions about what the model information posted looks like, it makes sense that it’s their decision on whether or not they can handle the model type trying to be bound.&#160; We created a new IFilteredModelBinder type, inheriting from IModelBinder, and added an IsMatch method that individual binders can use to match up their type.

The new SmartBinder becomes very simple:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">SmartBinder </span>: <span style="color: #2b91af">DefaultModelBinder
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IFilteredModelBinder</span>[] _filteredModelBinders;

    <span style="color: blue">public </span>SmartBinder(<span style="color: #2b91af">IFilteredModelBinder</span>[] filteredModelBinders)
    {
        _filteredModelBinders = filteredModelBinders;
    }

    <span style="color: blue">public override object </span>BindModel(<span style="color: #2b91af">ControllerContext </span>controllerContext, <span style="color: #2b91af">ModelBindingContext </span>bindingContext)
    {
        <span style="color: blue">foreach </span>(<span style="color: blue">var </span>filteredModelBinder <span style="color: blue">in </span>_filteredModelBinders)
        {
            <span style="color: blue">if </span>(filteredModelBinder.IsMatch(bindingContext.ModelType))
            {
                <span style="color: blue">return </span>filteredModelBinder.BindModel(controllerContext, bindingContext);
            }
        }

        <span style="color: blue">return base</span>.BindModel(controllerContext, bindingContext);
    }            
}</pre>

[](http://11011.net/software/vspaste)

Our new SmartBinder depends on an array of IFilteredModelBinders.&#160; This array is configured by our IoC container of choice (StructureMap in my case), so our SmartBinder doesn’t need to concern itself on how to find the right IFilteredModelBinders.

The BindModel method is overridden, and simply loops through the configured filtered model binders, asking each of them if they are a match to the model type attempting to be resolved.&#160; If one is a match, its BindModel method is executed and the value returned.

If there are no matches, the logic defaults back to the built-in DefaultModelBinder progression, going through the commented steps laid out before.

I’ve found that our custom model binders can decide to bind a certain model for quite a variety of reasons, whether it’s a specific layer supertype and the types are assignable, or maybe the type is decorated with a certain attribute, it’s really up to each individual filtered model binder.

That’s the strength of this design – it puts the decision of what to bind into each individual model binder, providing as much flexibility as we need, instead of relying specifically on only one matching strategy, on concrete type.&#160; Now _testing_ custom model binders – that’s another story altogether.