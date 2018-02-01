---
id: 17
title: Dynamic View Page, MVC without a View Model
date: 2010-06-23T05:04:00+00:00
author: Sean Biefeld
layout: post
guid: /blogs/seanbiefeld/archive/2010/06/23/dynamic-view-page-mvc-without-a-view-model.aspx
dsq_thread_id:
  - "449608171"
categories:
  - .NET
  - ASP.NET MVC
  - 'C#'
  - DTO
  - dynamic
  - model
  - MVC
  - View
---
Hello fellow techies on this roller coaster called life. It has been a while since my last post, I have been focusing on some other more important aspects of my life.

What I want to talk about in this post is the idea of a dynamic view page which removes the need for a View Model data transfer object. I have started to try this out on project that I am working on, for views that are essentially read only. All these views are concerned about is displaying data/information. &nbsp;I do not yet know how useful this is but I thought it was novel and will be exploring it&#8217;s usefulness. Plus, the lazy side of me likes the idea of not creating data transfer objects if possible.

Two side effects of this approach are the loss of the strongly typed Model on your view, which is a non-issue for a page without inputs. &nbsp;The second is the loss of intellisense (the very first time a member is used on a dynamic) when working with the Model in the view, which could be a minor loss in that you wont know something is wrong until you run it, but thats the way it goes.

To accomplish this you start off by creating a DynamicViewPage that inherits ViewPage. &nbsp;Have some overrides and new up some properties and you should be set.

<pre style="background-color: #141414;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #BEBEC8;font-size: 10pt"><span style="color: #cda869">public class</span> <span style="color: #7386a5">DynamicViewPage</span> : <span style="color: #7386a5">ViewPage</span>
{
	<span style="color: #cda869">private</span> <span style="color: #7386a5">ViewDataDictionary</span><span style="color: #cda869">&lt;dynamic&gt;</span> _viewData;

	<span style="color: #cda869">public override void</span> InitHelpers()
	{
		<span style="color: #cda869">base.</span>InitHelpers();
		Ajax = <span style="color: #cda869">new</span> <span style="color: #7386a5">AjaxHelper</span><span style="color: #cda869">&lt;dynamic&gt;</span>(ViewContext, this);
		Html = <span style="color: #cda869">new</span> <span style="color: #7386a5">HtmlHelper</span><span style="color: #cda869">&lt;dynamic&gt;</span>(ViewContext, this);
	}

	<span style="color: #cda869">protected override void</span> SetViewData(<span style="color: #7386a5">ViewDataDictionary</span> viewData)
	{
		_viewData = new <span style="color: #7386a5">ViewDataDictionary</span><span style="color: #cda869">&lt;dynamic&gt;</span>(viewData);
		<span style="color: #cda869">base.</span>SetViewData(_viewData);
	}

	<span style="color: #cda869">public new</span> <span style="color: #7386a5">AjaxHelper</span><span style="color: #cda869">&lt;dynamic&gt;</span> Ajax { get; set; }

	<span style="color: #cda869">public new</span> <span style="color: #7386a5">HtmlHelper</span><span style="color: #cda869">&lt;dynamic&gt;</span> Html { get; set; }

	<span style="color: #cda869">public new dynamic</span> Model
	{
		<span style="color: #cda869">get</span>
		{
			<span style="color: #cda869">return</span> ViewData.Model;
		}
	}

	<span style="color: #cda869">public new</span> <span style="color: #7386a5">ViewDataDictionary</span><span style="color: #cda869">&lt;dynamic&gt;</span> ViewData
	{
		<span style="color: #cda869">get</span>
		{
			<span style="color: #cda869">if</span> (_viewData <span style="color: #cda869">== null</span>)
			{
				SetViewData(new <span style="color: #7386a5">ViewDataDictionary</span><span style="color: #cda869">&lt;dynamic&gt;</span>());
			}
			<span style="color: #cda869">return</span> _viewData;
		}
		<span style="color: #cda869">set</span>
		{
			SetViewData(<span style="color: #cda869">value</span>);
		}
	}
}</pre>

Now your view needs to inherit from DynamicViewPage.

<pre style="background-color: #141414;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #BEBEC8;font-size: 10pt">Inherits="Web.Views.DynamicViewPage"</pre>

In your controller you can ask your persistence abstraction of choice for some data and return it to the view.

<pre style="background-color: #141414;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #BEBEC8;font-size: 10pt"><span style="color: #cda869">public</span> <span style="color: #7386a5">ActionResult</span> Index()
{
	<span style="color: #d0da90">IEnumerable</span><span style="color: #cda869">&lt;dynamic&gt;</span> foos <span style="color: #cda869">=</span> FooQueries.GetAll();
	<span style="color: #cda869">return</span> View(foos);
}</pre>

Where this can get interesting is when you have a linq provider that returns dynamic objects. Then essentially your domain model is king and you eliminate a lot of DTOs. That&#8217;s all I&#8217;ve got for now. I attached a sample application that demonstrates the dynamic view, enjoy!