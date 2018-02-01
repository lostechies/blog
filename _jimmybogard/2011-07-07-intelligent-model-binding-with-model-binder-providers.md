---
id: 500
title: Intelligent model binding with model binder providers
date: 2011-07-07T00:45:56+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2011/07/07/intelligent-model-binding-with-model-binder-providers/
dsq_thread_id:
  - "351572695"
categories:
  - ASPNETMVC
---
So that [better model binder](http://lostechies.com/jimmybogard/2009/03/18/a-better-model-binder/) I built a couple of years ago to address conditional model binding in ASP.NET MVC 1-2 is obsolete with the release of ASP.NET MVC 3. Instead, the concept of a [model binder provider](http://bradwilson.typepad.com/blog/2010/10/service-location-pt9-model-binders.html) allows this same functionality, fairly easily. Back in my [Put Your Controllers on a Diet](http://www.viddler.com/explore/mvcconf/videos/1/) talk at MVCConf, I showed how we can get rid of all those pesky “GetEntityById” calls out of our controller actions. We wanted to turn this:

<pre class="code"><span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Show(<span style="color: #2b91af">Guid </span>id)
{
    <span style="color: blue">var </span>conf = _repository.GetById(id);

    <span style="color: blue">return </span>AutoMapView&lt;<span style="color: #2b91af">ConferenceShowModel</span>&gt;(View(conf));
}
</pre>

Into this:

<pre class="code"><span style="color: blue">public </span><span style="color: #2b91af">ActionResult </span>Show(<span style="color: #2b91af">Conference </span>conf)
{
    <span style="color: blue">return </span>AutoMapView&lt;<span style="color: #2b91af">ConferenceShowModel</span>&gt;(View(conf));
}
</pre>

We can use a custom model binder to achieve this result. However, our original implementation used model binders per concrete entity type, not too efficient:

<pre class="code"><span style="color: #2b91af">ModelBinders</span>.Binders
    .Add(<span style="color: blue">typeof</span>(<span style="color: #2b91af">Conference</span>), <span style="color: blue">new </span><span style="color: #2b91af">ConferenceModelBinder</span>());
</pre>

The problem here is that we’d have to add a model binder for each concrete entity type. In the old solution from my post for a better model binder, we solved this problem with a model binder that also included a condition on whether or not the model binder applies:

<pre class="code"><span style="color: blue">public interface </span><span style="color: #2b91af">IFilteredModelBinder
    </span>: <span style="color: #2b91af">IModelBinder
</span>{
    <span style="color: blue">bool </span>IsMatch(<span style="color: #2b91af">ModelBindingContext </span>bindingContext);
}
</pre>

However, this is exactly what model binder providers can do for us. Let’s ditch the filtered model binder and go for the model binder provider route instead.

### Custom model binder provider

Before we get to the model binder provider, let’s first build out a generic model binder. We want this model binder to not just accept a single concrete Entity type, but any Entity type we supply:

<pre class="code"><span style="color: blue">public class </span><span style="color: #2b91af">EntityModelBinder</span>&lt;TEntity&gt; 
    : <span style="color: #2b91af">IModelBinder
    </span><span style="color: blue">where </span>TEntity : <span style="color: #2b91af">Entity
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IRepository</span>&lt;TEntity&gt; _repository;

    <span style="color: blue">public </span>EntityModelBinder(<span style="color: #2b91af">IRepository</span>&lt;TEntity&gt; repository)
    {
        _repository = repository;
    }

    <span style="color: blue">public object </span>BindModel(<span style="color: #2b91af">ControllerContext </span>controllerContext, 
        <span style="color: #2b91af">ModelBindingContext </span>bindingContext)
    {
        <span style="color: #2b91af">ValueProviderResult </span>value = bindingContext
            .ValueProvider.GetValue(bindingContext.ModelName);

        <span style="color: blue">var </span>id = <span style="color: #2b91af">Guid</span>.Parse(value.AttemptedValue);

        <span style="color: blue">var </span>entity = _repository.GetById(id);

        <span style="color: blue">return </span>entity;
    }
}
</pre>

We took the model binder used from the original “controllers on a diet” talk, and extended it to be able to handle any kind of entity. In the example above, all entities derive from a common base class, “Entity”. Our entity repository implementation (although it could be any common data access gateway) allows us to retrieve the specific kind of entity (Customer, Order, Conference, whatever) by filling in the type. It’s just another example of using type information as a means of altering behavior in our system.

In our previous incarnation, we would create either our IFilteredModelBinder to be able to handle any base entity type. If we didn’t have that kind of abstraction in place, we’d have to register concrete implementations for each concrete entity type. Not ideal. Instead, let’s build a model binder provider:

<pre class="code"><span style="color: blue">public class </span><span style="color: #2b91af">EntityModelBinderProvider
    </span>: <span style="color: #2b91af">IModelBinderProvider
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">IModelBinder </span>GetBinder(<span style="color: #2b91af">Type </span>modelType)
    {
        <span style="color: blue">if </span>(!<span style="color: blue">typeof</span>(<span style="color: #2b91af">Entity</span>).IsAssignableFrom(modelType))
            <span style="color: blue">return null</span>;

        <span style="color: #2b91af">Type </span>modelBinderType = <span style="color: blue">typeof</span>(<span style="color: #2b91af">EntityModelBinder</span>&lt;&gt;)
            .MakeGenericType(modelType);

        <span style="color: blue">var </span>modelBinder = <span style="color: #2b91af">ObjectFactory</span>.GetInstance(modelBinderType);

        <span style="color: blue">return </span>(<span style="color: #2b91af">IModelBinder</span>) modelBinder;
    }
}
</pre>

First, we create a class implementing IModelBinderProvider. This interface has one member, “GetBinder”, and the parameter is the type of the model attempting to be bound.&nbsp; Model binder providers return a model binder instance if it’s able to bind based on the model type, and null otherwise. That allows the IModelBinderProviders to have the same function in our IFilteredModelBinder, but just in a slightly modified form.

If it does match our condition, namely that the model type is derived from Entity, we can then use some generics magic to build up the closed generic type of the EntityModelBinder, build it from our IoC container of choice, and return that as our model binder.

Finally, we need to actually register the custom model binder provider:

<pre class="code"><span style="color: blue">protected void </span>Application_Start()
{
    <span style="color: #2b91af">AreaRegistration</span>.RegisterAllAreas();

    <span style="color: #2b91af">ModelBinderProviders</span>.BinderProviders
        .Add(<span style="color: blue">new </span><span style="color: #2b91af">EntityModelBinderProvider</span>());

    RegisterGlobalFilters(<span style="color: #2b91af">GlobalFilters</span>.Filters);
    RegisterRoutes(<span style="color: #2b91af">RouteTable</span>.Routes);
}
</pre>

We now have just one model binder provider that can handle any bound entity in our incoming model in our controller actions. Whereas MVC 1-2 forced us to either come up with a new abstraction or register specific types, the IModelBinderProvider allows us to make intelligent decisions on what to bind, without incurring a lot of duplication costs.

Yet another set of code to delete when moving to ASP.NET MVC 3!