---
wordpress_id: 368
title: A better Model Binder addendum
date: 2009-11-20T02:31:19+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/11/19/a-better-model-binder-addendum.aspx
dsq_thread_id:
  - "265384218"
categories:
  - ASPNETMVC
redirect_from: "/blogs/jimmy_bogard/archive/2009/11/19/a-better-model-binder-addendum.aspx/"
---
A while back, I wrote about a [ModelBinder enhancement](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/03/17/a-better-model-binder.aspx) we use to do arbitrary filtering on types.&#160; The underlying matching algorithm only matches on one type, but we like to use layer supertypes for a lot of our domain objects, so we want to use a single model binder for every Entity or Enumeration type in our system.

However, I missed an important piece in our model binding story: ModelState.&#160; In the original implementation:

<pre><span style="color: blue">public override object </span>BindModel(
    <span style="color: #2b91af">ControllerContext </span>controllerContext, 
    <span style="color: #2b91af">ModelBindingContext </span>bindingContext)
{
    <span style="color: blue">foreach </span>(<span style="color: blue">var </span>filteredModelBinder <span style="color: blue">in </span>_filteredModelBinders)
    {
        <span style="color: blue">if </span>(filteredModelBinder.IsMatch(bindingContext.ModelType))
        {
            <span style="color: blue">return </span>filteredModelBinder.BindModel(controllerContext, bindingContext);
        }
    }

    <span style="color: blue">return base</span>.BindModel(controllerContext, bindingContext);
}</pre>

[](http://11011.net/software/vspaste)

I didn’t address ModelState.&#160; It turns out that this may lead to problems later on when I use the built-in HtmlHelper methods.&#160; These helper methods use ModelState to do things like set error message indicators, fill in values and so on.&#160; But if one of the IFilteredModelBinder implementations binds a value but _doesn’t_ do the ModelState piece, I start to get some weird behavior in certain scenarios.

If you start to dig pretty deeply in the DefaultModelBinder code, you’ll find that the base implementation of BindModel will set the ModelState values for certain scenarios.&#160; In our case, we need to allow the IFilteredModelBinders to do something similar.

### Our slight fix

First, we’ll need to fix the IFilteredModelBinder interface to return not just an object, but something that includes the ValueProviderResult object (used by ModelState).&#160; Why not just do object?&#160; Well, we can’t make an assumption on what the underlying model binder implementations need to do with a BindResult, it’s rather custom for each implementation.&#160; So, our IFilteredModelBinder interface becomes:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IFilteredModelBinder
</span>{
    <span style="color: blue">bool </span>IsMatch(<span style="color: #2b91af">ModelBindingContext </span>bindingContext);
    <span style="color: #2b91af">BindResult </span>BindModel(
        <span style="color: #2b91af">ControllerContext </span>controllerContext, 
        <span style="color: #2b91af">ModelBindingContext </span>bindingContext);
}</pre>

That BindResult object is not in MVC, it’s something we have to define:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">BindResult
</span>{
    <span style="color: blue">public object </span>Value { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">ValueProviderResult </span>ValueProviderResult { <span style="color: blue">get</span>; <span style="color: blue">private set</span>; }

    <span style="color: blue">public </span>BindResult(<span style="color: blue">object </span>value, <span style="color: #2b91af">ValueProviderResult </span>valueProviderResult)
    {
        Value = value;
        ValueProviderResult = valueProviderResult ?? 
            <span style="color: blue">new </span><span style="color: #2b91af">ValueProviderResult</span>(<span style="color: blue">null</span>, <span style="color: blue">string</span>.Empty, <span style="color: #2b91af">CultureInfo</span>.CurrentCulture);
    }
}</pre>

[](http://11011.net/software/vspaste)

All object adds is the ValueProviderResult, providing a default null-object implementation if the implementing filtered model binder doesn’t support ValueProviderResults.&#160; With this in place, we need to fix our SmartBinder:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">SmartBinder </span>: <span style="color: #2b91af">DefaultModelBinder
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IFilteredModelBinder</span>[] _filteredModelBinders;

    <span style="color: blue">public </span>SmartBinder(<span style="color: #2b91af">IFilteredModelBinder</span>[] filteredModelBinders)
    {
        _filteredModelBinders = filteredModelBinders;
    }

    <span style="color: blue">public override object </span>BindModel(
        <span style="color: #2b91af">ControllerContext </span>controllerContext, 
        <span style="color: #2b91af">ModelBindingContext </span>bindingContext)
    {
        <span style="color: blue">foreach </span>(<span style="color: blue">var </span>filteredModelBinder <span style="color: blue">in </span>_filteredModelBinders)
        {
            <span style="color: blue">if </span>(filteredModelBinder.IsMatch(bindingContext))
            {
                <span style="color: blue">var </span>result = filteredModelBinder.BindModel(controllerContext, bindingContext);

                bindingContext.ModelState.SetModelValue(
                    bindingContext.ModelName, 
                    result.ValueProviderResult);

                <span style="color: blue">return </span>result.Value;
            }
        }

        <span style="color: blue">return base</span>.BindModel(controllerContext, bindingContext);
    }
}</pre>

[](http://11011.net/software/vspaste)

It’s pretty much like the original, except that piece that does the SetModelValue part.&#160; That fills in the necessary pieces for the input HtmlHelper methods to do their thing.&#160; Interestingly, this made another problem go away, around [ModelState.AddModelError](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/03/26/mvc-beta-to-rtw-upgrade-issue-addmodelerror-and-nullreferenceexceptions.aspx).&#160; It turns out I just missed a piece in the custom model binding code.

So just a note to custom model binder implementors – don’t forget to populate the appropriate ModelState values, especially if the results of the binding operation will be used in conjunction with the HtmlHelper extensions.