---
wordpress_id: 298
title: MVC Beta to RTW upgrade issue – AddModelError and NullReferenceExceptions
date: 2009-03-27T03:51:04+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/03/26/mvc-beta-to-rtw-upgrade-issue-addmodelerror-and-nullreferenceexceptions.aspx
dsq_thread_id:
  - "264716123"
categories:
  - ASPNETMVC
---
Since we use quite a lot of the MVC extension points on our current project, we knew that we’d suffer some upgrade pains going from release to release of MVC.&#160; This isn’t that new for us, as we use a variety of open source projects.&#160; But for a Beta product, it’s almost guaranteed that you’ll run into some issues with upgrades.

Our upgrade has been…less than fun.&#160; Besides the heinous Visual Studio crashing issues, we were bitten by a wide variety of API changes.&#160; One in particular gave me the fits for about two weeks, a multi-headed hydra that I couldn’t quite fix.

In our applications, we use ModelState errors to bubble up validation errors to the UI.&#160; Most of these aren’t manually pushed in, but rather done through model binding.&#160; We use a variety of validation in our application, including Castle Validators, as well as custom business rules that still bubble up to the UI.&#160; From “Start Date is required” to “Start Date cannot be a future date” to “Start Date cannot come before the first contract start date”.

We hid all this behind a few classes, but at some point, we had to add something like this:

<pre><span style="color: blue">public void </span>SomeAction()
{
    ModelState.AddModelError(<span style="color: #a31515">"SomeKey"</span>, <span style="color: #a31515">"I am a required field."</span>);
}</pre>

[](http://11011.net/software/vspaste)

Very innocuous.&#160; We had a required field, it wasn’t submitted as part of the form (and didn’t even come across the request), and we added a model error.&#160; The problem shows it ugly head if you try and use MVC’s built-in HtmlHelper to generate HTML.&#160; Its input element generators are “aware” of ModelState and ViewState, and will try and use these pieces to do things like populate the value of an HTML element.&#160; What we wound up getting was an error something like this:

<pre>[NullReferenceException: Object reference not set to an instance of an object.]
   System.Web.Mvc.HtmlHelper.GetModelStateValue(String key, Type destinationType) +63
   System.Web.Mvc.Html.InputExtensions.InputHelper(HtmlHelper htmlHelper, InputType inputType, String name, Object value, Boolean useViewData, Boolean isChecked, Boolean setId, Boolean isExplicitValue, IDictionary`2 htmlAttributes) +519
   System.Web.Mvc.Html.InputExtensions.TextBox(HtmlHelper htmlHelper, String name, Object value, IDictionary`2 htmlAttributes) +34
   System.Web.Mvc.Html.InputExtensions.TextBox(HtmlHelper htmlHelper, String name, Object value) +61</pre>

[](http://11011.net/software/vspaste)

The fix wound up being for us to create a “SafeAddModelError” extension method.&#160; The HtmlHelpers expect some ModelState ValueProviderResult to exist, but it doesn’t because we do our own custom validation.&#160; Long, long story short, here was our fix:

<pre><span style="color: blue">public static void </span>SafeAddModelError(<span style="color: blue">this </span><span style="color: #2b91af">ModelStateDictionary </span>state, <span style="color: blue">string </span>key, <span style="color: blue">string </span>errorMessage)
{
    state.AddModelError(key, errorMessage);
    <span style="color: blue">if </span>(state[key].Value == <span style="color: blue">null</span>)
    {
        state[key].Value = <span style="color: blue">new </span><span style="color: #2b91af">ValueProviderResult</span>(<span style="color: blue">null</span>, <span style="color: blue">null</span>, <span style="color: blue">null</span>);
    }
}</pre>

[](http://11011.net/software/vspaste)

I have no idea if this error helps anyone but me, but hey, I enjoy sharing my pain.