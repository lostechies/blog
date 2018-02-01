---
id: 411
title: 'Dependency Injection in ASP.NET MVC: Views'
date: 2010-05-19T15:18:01+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2010/05/19/dependency-injection-in-asp-net-mvc-views.aspx
dsq_thread_id:
  - "264716516"
categories:
  - ASPNETMVC
  - DependencyInjection
---
Other posts in this series:

  * [Controllers](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/04/26/dependency-injection-in-asp-net-mvc-controllers.aspx)
  * [Contextual controller injection](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/04/28/dependency-injection-in-asp-net-mvc-contextual-controller-injection.aspx)
  * [Filters](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/05/03/dependency-injection-in-asp-net-mvc-filters.aspx)
  * [Action Results](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/05/04/dependency-injection-in-asp-net-mvc-action-results.aspx)

And now for a bit more controversial shift.&#160; While most folks doing DI in ASP.NET MVC see the benefit of the ability to provide injection around the controller-side of things (filters, action results, controllers etc.), I’ve also seen a lot of benefit from injection on the view side.&#160; But before delve into the _how_, let’s first look at the _why_.

The responsibility of a view is to render a model.&#160; Pretty cut and dry, until you start to try and do more interesting things in the view.&#160; Up until now, the CODE extensibility points of a view included:

  * XyzHelper extensions (UrlHelper, AjaxHelper, HtmlHelper)
  * Custom base view class with custom services

I’m leaving out markup extensibility points such as MVC 2 templated helpers, master pages, partials, render action and so on.&#160; If we want our custom helper extension method to use a service, such as a custom Url resolver, localization services, complex HTML builders and so on, we’re left with service location, looking something like this:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">MvcHtmlString </span>Text&lt;TModel&gt;(<span style="color: blue">this </span><span style="color: #2b91af">HtmlHelper</span>&lt;TModel&gt; helper, <span style="color: blue">string </span>key)
{
    <span style="color: blue">var </span>provider = <span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">ILocalizationProvider</span>&gt;();

    <span style="color: blue">var </span>text = provider.GetValue(key);

    <span style="color: blue">return </span><span style="color: #2b91af">MvcHtmlString</span>.Create(text);
}</pre>

[](http://11011.net/software/vspaste)

We started seeing this sort of cruft all over the place.&#160; It became clear quite quickly that HtmlHelper extensions are only appropriate for small, procedural bits of code.&#160; But as we started building customized input builders (this was before MVC 2’s templated helpers and MVC Contrib’s input builders), the view started becoming much, much more **intelligent** about building HTML.&#160; Its responsibilities were still just “build HTML from the model”, but we took advantage of modern OO programming and conventions to drastically reduce the amount of duplication in our views.

But all of this was only possible if we could **inject services into the view**.&#160; Since MVC isn’t really designed with DI everywhere in mind, we have to use quite a bit of elbow grease to squeeze out the powerful designs we wanted.

### Building an injecting view engine

Our overall strategy for injecting services into the view was:

  * Create a new base view class layer supertype
  * Expose services as read/write properties
  * Utilize property injection to build up the view

Since we’re using the WebFormsViewEngine, we don’t really have any control over view instantiation.&#160; We have to use property injection instead.&#160; That’s not a big hurdle for us here as it was in other place.&#160; We’re not instantiating views in unit tests, which are a big source of confusion when doing property injection.

First, we need to subclass the existing view engine and plug in to its existing behavior:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">NestedContainerViewEngine </span>: <span style="color: #2b91af">WebFormViewEngine
</span>{
    <span style="color: blue">public override </span><span style="color: #2b91af">ViewEngineResult </span>FindView(
        <span style="color: #2b91af">ControllerContext </span>controllerContext, 
        <span style="color: blue">string </span>viewName, <span style="color: blue">string </span>masterName, <span style="color: blue">bool </span>useCache)
    {
        <span style="color: blue">var </span>result = <span style="color: blue">base</span>.FindView(controllerContext, viewName, masterName, useCache);

        <span style="color: blue">return </span>CreateNestedView(result, controllerContext);
    }

    <span style="color: blue">public override </span><span style="color: #2b91af">ViewEngineResult </span>FindPartialView(
        <span style="color: #2b91af">ControllerContext </span>controllerContext, 
        <span style="color: blue">string </span>partialViewName, <span style="color: blue">bool </span>useCache)
    {
        <span style="color: blue">var </span>result = <span style="color: blue">base</span>.FindPartialView(controllerContext, partialViewName, useCache);

        <span style="color: blue">return </span>CreateNestedView(result, controllerContext);
    }</pre>

[](http://11011.net/software/vspaste)

We’re going to use the base view engine to do all of the heavy lifting for locating views.&#160; When it finds a view, we’ll create our ViewEngineResult based on that.&#160; The CreateNestedView method becomes:

<pre><span style="color: blue">private </span><span style="color: #2b91af">ViewEngineResult </span>CreateNestedView(
    <span style="color: #2b91af">ViewEngineResult </span>result, 
    <span style="color: #2b91af">ControllerContext </span>controllerContext)
{
    <span style="color: blue">if </span>(result.View == <span style="color: blue">null</span>)
        <span style="color: blue">return </span>result;

    <span style="color: blue">var </span>parentContainer = controllerContext.HttpContext.GetContainer();

    <span style="color: blue">var </span>nestedContainer = parentContainer.GetNestedContainer();

    <span style="color: blue">var </span>webFormView = (<span style="color: #2b91af">WebFormView</span>)result.View;

    <span style="color: blue">var </span>wrappedView = <span style="color: blue">new </span><span style="color: #2b91af">WrappedView</span>(webFormView, nestedContainer);

    <span style="color: blue">var </span>newResult = <span style="color: blue">new </span><span style="color: #2b91af">ViewEngineResult</span>(wrappedView, <span style="color: blue">this</span>);

    <span style="color: blue">return </span>newResult;
}</pre>

[](http://11011.net/software/vspaste)

We want to create a nested container based on the calling controller’s nested container.&#160; Our previous controller factory used a static gateway to store the outermost nested container in HttpContext.Items.&#160; To make it visible to our view engine (which is SINGLETON), we have no choice but to build a little extension method in GetNestedContainer for HttpContextBase to retrieve our nested container.

Once we have the outermost nested container, we create a new, child nested container from it.&#160; Containers can nest as many times as we like, inheriting the parent container configuration.

From there, we then need to build up our own IView instance, a WrappedView object.&#160; Unfortunately, the extension points in the WebFormView class do not exist for us to seamlessly extend it to provide injection.&#160; However, since MVC is open source, we have a great starting point.

After we build our WrappedView, we create our ViewEngineResult and our custom view engine is complete.&#160; Before we look at the WrappedView class, let’s look at how our views will be built.

### Layer supertype to provide injection

To provide injection of services, we’ll need a layer supertype between our actual views and the normal MVC ViewPage and ViewPage<T>:

<pre><span style="color: blue">public abstract class </span><span style="color: #2b91af">ViewPageBase</span>&lt;TModel&gt; : <span style="color: #2b91af">ViewPage</span>&lt;TModel&gt;
{
    <span style="color: blue">public </span><span style="color: #2b91af">IHtmlBuilder</span>&lt;TModel&gt; HtmlBuilder { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}

<span style="color: blue">public abstract class </span><span style="color: #2b91af">ViewPageBase </span>: <span style="color: #2b91af">ViewPageBase</span>&lt;<span style="color: blue">object</span>&gt;
{
}</pre>

[](http://11011.net/software/vspaste)

Here, we include our custom IHtmlBuilder service that will do all sorts of complex HTML building.&#160; We can include any other service we please, but we just need to make sure that it’s a mutable property on our base view layer supertype.&#160; The HtmlBuilder implementation does nothing interesting, but includes a set of services we want to have injected:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">HtmlBuilder</span>&lt;TModel&gt; : <span style="color: #2b91af">IHtmlBuilder</span>&lt;TModel&gt;
{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">HtmlHelper</span>&lt;TModel&gt; _htmlHelper;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">AjaxHelper</span>&lt;TModel&gt; _ajaxHelper;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">UrlHelper </span>_urlHelper;

    <span style="color: blue">public </span>HtmlBuilder(
        <span style="color: #2b91af">HtmlHelper</span>&lt;TModel&gt; htmlHelper, 
        <span style="color: #2b91af">AjaxHelper</span>&lt;TModel&gt; ajaxHelper, 
        <span style="color: #2b91af">UrlHelper </span>urlHelper)
    {
        _htmlHelper = htmlHelper;
        _ajaxHelper = ajaxHelper;
        _urlHelper = urlHelper;
    }</pre>

[](http://11011.net/software/vspaste)

When we configure our container, we want any service used to be available.&#160; By configuring the various helpers, we allow our helpers to be injected instead of passed around everywhere in method arguments.&#160; This is MUCH MUCH cleaner than passing context objects around everywhere we go, regardless if they’re actually used or not. 

### Wrapping WebFormView to provide injection

As I mentioned before, we can’t subclass WebFormView directly, but we can instead wrap its behavior with our own.&#160; Composition over inheritance, but we still have to duplicate more behavior than I would have liked.&#160; But, it’s about the cleanest and lowest-impact implementation I’ve come up with, and gets around any kind of sub-optimal poor-man’s dependency injection.

First, our WrappedView definition:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">WrappedView </span>: <span style="color: #2b91af">IView</span>, <span style="color: #2b91af">IDisposable
</span>{
    <span style="color: blue">private bool </span>_disposed;

    <span style="color: blue">public </span>WrappedView(<span style="color: #2b91af">WebFormView </span>baseView, <span style="color: #2b91af">IContainer </span>container)
    {
        BaseView = baseView;
        Container = container;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">WebFormView </span>BaseView { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">IContainer </span>Container { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }

    <span style="color: blue">public void </span>Dispose()
    {
        Dispose(<span style="color: blue">true</span>);
        <span style="color: #2b91af">GC</span>.SuppressFinalize(<span style="color: blue">this</span>);
    }

    <span style="color: blue">protected virtual void </span>Dispose(<span style="color: blue">bool </span>disposing)
    {
        <span style="color: blue">if </span>(_disposed)
            <span style="color: blue">return</span>;

        <span style="color: blue">if </span>(Container != <span style="color: blue">null</span>)
            Container.Dispose();

        _disposed = <span style="color: blue">true</span>;
    }</pre>

[](http://11011.net/software/vspaste)

We accept the base view (a WebFormView created from the original WebFormsViewEngine), as well as our nested container.&#160; We need to dispose of our container properly, so we implement IDisposable properly.

Now, the next part is large, but only because I had to duplicate the existing MVC code to add in what I needed:

<pre><span style="color: blue">public void </span>Render(<span style="color: #2b91af">ViewContext </span>viewContext, <span style="color: #2b91af">TextWriter </span>writer)
{
    <span style="color: blue">if </span>(viewContext == <span style="color: blue">null</span>)
    {
        <span style="color: blue">throw new </span><span style="color: #2b91af">ArgumentNullException</span>(<span style="color: #a31515">"viewContext"</span>);
    }

    <span style="color: blue">object </span>viewInstance = <span style="color: #2b91af">BuildManager</span>.CreateInstanceFromVirtualPath(BaseView.ViewPath, <span style="color: blue">typeof</span>(<span style="color: blue">object</span>));
    <span style="color: blue">if </span>(viewInstance == <span style="color: blue">null</span>)
    {
        <span style="color: blue">throw new </span><span style="color: #2b91af">InvalidOperationException</span>(
            <span style="color: #2b91af">String</span>.Format(
                <span style="color: #2b91af">CultureInfo</span>.CurrentUICulture,
                <span style="color: #a31515">"The view found at '{0}' was not created."</span>,
                BaseView.ViewPath));
    }

    <span style="color: green">////////////////////////////////
    // This is where our code starts
    ////////////////////////////////
    </span><span style="color: blue">var </span>viewType = viewInstance.GetType();
    <span style="color: blue">var </span>isBaseViewPage = viewType.Closes(<span style="color: blue">typeof </span>(<span style="color: #2b91af">ViewPageBase</span>&lt;&gt;));

    Container.Configure(cfg =&gt;
    {
        cfg.For&lt;<span style="color: #2b91af">ViewContext</span>&gt;().Use(viewContext);
        cfg.For&lt;<span style="color: #2b91af">IViewDataContainer</span>&gt;().Use((<span style="color: #2b91af">IViewDataContainer</span>) viewInstance);

        <span style="color: blue">if </span>(isBaseViewPage)
        {
            <span style="color: blue">var </span>modelType = GetModelType(viewType);
            <span style="color: blue">var </span>builderType = <span style="color: blue">typeof </span>(<span style="color: #2b91af">IHtmlBuilder</span>&lt;&gt;).MakeGenericType(modelType);
            <span style="color: blue">var </span>concreteBuilderType = <span style="color: blue">typeof </span>(<span style="color: #2b91af">HtmlBuilder</span>&lt;&gt;).MakeGenericType(modelType);

            cfg.For(builderType).Use(concreteBuilderType);
        }
    });

    Container.BuildUp(viewInstance);
    <span style="color: green">////////////////////////////////
    // This is where our code ends
    ////////////////////////////////

    </span><span style="color: blue">var </span>viewPage = viewInstance <span style="color: blue">as </span><span style="color: #2b91af">ViewPage</span>;
    <span style="color: blue">if </span>(viewPage != <span style="color: blue">null</span>)
    {
        RenderViewPage(viewContext, viewPage);
        <span style="color: blue">return</span>;
    }

    <span style="color: #2b91af">ViewUserControl </span>viewUserControl = viewInstance <span style="color: blue">as </span><span style="color: #2b91af">ViewUserControl</span>;
    <span style="color: blue">if </span>(viewUserControl != <span style="color: blue">null</span>)
    {
        RenderViewUserControl(viewContext, viewUserControl);
        <span style="color: blue">return</span>;
    }

    <span style="color: blue">throw new </span><span style="color: #2b91af">InvalidOperationException</span>(
        <span style="color: #2b91af">String</span>.Format(
            <span style="color: #2b91af">CultureInfo</span>.CurrentUICulture,
            <span style="color: #a31515">"The view at '{0}' must derive from ViewPage, ViewPage&lt;TViewData&gt;, ViewUserControl, or ViewUserControl&lt;TViewData&gt;."</span>,
            BaseView.ViewPath));
}</pre>

[](http://11011.net/software/vspaste)

I’m going to ignore the other pieces except what’s between those comment blocks.&#160; We have our ViewPageBase<TModel>, and we need to configure various services for our views, including:

  * ViewContext
  * Anything needed by the helpers (IViewDataContianer)
  * Custom services, like IHtmlBuilder<TModel>

Just like our previous nested container usage, we take advantage of StructureMap’s ability to configure a container AFTER it’s been created.&#160; We first configure ViewContext and IViewDataContainer (needed for HtmlHelper).&#160; Finally, we determine the TModel model type of our view, and configure IHtmlBuilder<TModel> against HtmlBuilder<TModel>.&#160; If TModel is of type Foo, we configure IHtmlBuilder<Foo> to use HtmlBuilder<Foo>.

Finally, we use the BuildUp method to perform property injection.&#160; Just as we explicitly configured property injection for our filter’s services, we need to do the same for the view’s services:

<pre>SetAllProperties(c =&gt;
{
    c.OfType&lt;<span style="color: #2b91af">IActionInvoker</span>&gt;();
    c.OfType&lt;<span style="color: #2b91af">ITempDataProvider</span>&gt;();
    c.WithAnyTypeFromNamespaceContainingType&lt;<span style="color: #2b91af">ViewPageBase</span>&gt;();
    c.WithAnyTypeFromNamespaceContainingType&lt;<span style="color: #2b91af">LogErrorAttribute</span>&gt;();
});</pre>

[](http://11011.net/software/vspaste)

The view services are all contained in the namespace of the ViewPageBase class.&#160; With that in place, we just have one more piece to deal with: services in master pages.

### 

### Dealing with master pages

In the RenderViewPage method, we add a piece to deal with master pages and enable injection for them as well:

<pre><span style="color: blue">private void </span>RenderViewPage(<span style="color: #2b91af">ViewContext </span>context, <span style="color: #2b91af">ViewPage </span>page)
{
    <span style="color: blue">if </span>(!<span style="color: #2b91af">String</span>.IsNullOrEmpty(BaseView.MasterPath))
    {
        page.MasterLocation = BaseView.MasterPath;
    }

    page.ViewData = context.ViewData;

    page.PreLoad += (sender, e) =&gt; BuildUpMasterPage(page.Master);

    page.RenderView(context);
}</pre>

[](http://11011.net/software/vspaste)

Because master pages do not flow through the normal view engine, we have to hook in to their PreLoad event to do our property injection in a BuildUpMasterPage method:

<pre><span style="color: blue">private void </span>BuildUpMasterPage(<span style="color: #2b91af">MasterPage </span>master)
{
    <span style="color: blue">if </span>(master == <span style="color: blue">null</span>)
        <span style="color: blue">return</span>;

    <span style="color: blue">var </span>masterContainer = Container.GetNestedContainer();

    masterContainer.BuildUp(master);

    BuildUpMasterPage(master.Master);
}</pre>

[](http://11011.net/software/vspaste)

If we needed any custom configuration for master pages, this is where we could do it.&#160; In my example, I don’t, so I just create a new default nested container from the parent container.&#160; Also, master pages can have nesting, so we recursively build up all of the master pages in the hierarchy until we run out of parent master pages.

Finally, we need to hook up our custom view engine in the global.asax:

<pre><span style="color: blue">protected void </span>Application_Start()
{
    <span style="color: #2b91af">AreaRegistration</span>.RegisterAllAreas();

    RegisterRoutes(<span style="color: #2b91af">RouteTable</span>.Routes);

    <span style="color: #2b91af">StructureMapConfiguration</span>.Initialize();

    <span style="color: blue">var </span>controllerFactory = <span style="color: blue">new </span><span style="color: #2b91af">StructureMapControllerFactory</span>(<span style="color: #2b91af">ObjectFactory</span>.Container);

    <span style="color: #2b91af">ControllerBuilder</span>.Current.SetControllerFactory(controllerFactory);

    <span style="color: #2b91af">ViewEngines</span>.Engines.Clear();
    <span style="color: #2b91af">ViewEngines</span>.Engines.Add(<span style="color: blue">new </span><span style="color: #2b91af">NestedContainerViewEngine</span>());
}</pre>

[](http://11011.net/software/vspaste)

And that’s it!&#160; With our nested container view engine in place, we can now inject complex UI services in to our views, allowing us to create powerful UI content builders without resorting to gateways or service location.

### Conclusion

It was a bit of work, but we were able to inject services into not only views, but partials, master pages, even MVC 2 templated helpers!&#160; By using nested containers, we were able to configure all of the contextual pieces so that services built for each view got the correct contextual item (the right HtmlHelper, ViewContext, IViewDataContainer, etc.)

This is a quite powerful tool now, we don’t need to resort to ugly usage of static gateways or service location.&#160; We can now build UI services that depend on an HtmlHelper or ViewContext, and feel confident that our services get the correct instance.&#160; In the past, we’d need to pass around our ViewContext EVERYWHERE in order to get back at these values.&#160; Not very fun, especially when you start to see interfaces that accept everything under the sun “just in case”.

For those folks that don’t want to inject services in to their views, it’s all about responsibilities.&#160; I can create encapsulated, cohesive UI services that still only create HTML from a model, but I’m now able to use actual OO programming without less-powerful static gateways or service location to do so.

So looking back, we were able to inject services into our controllers, filters, action results and views.&#160; Using nested containers, we were able to provide contextual injection of all those context objects that MVC loves to use everywhere.&#160; But now we can let our services use them only when needed through dependency injection, providing a much cleaner API throughout.

You can find code for this example on my github:

<http://github.com/jbogard/blogexamples>