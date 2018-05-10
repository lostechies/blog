---
wordpress_id: 707
title: 'Composite JS Apps: Regions And Region Managers'
date: 2011-12-12T11:33:20+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=707
dsq_thread_id:
  - "502152476"
categories:
  - Backbone
  - Composite Apps
  - JavaScript
  - Marionette
---
In my previous post on [Composite JavaScript Apps](https://lostechies.com/derickbailey/2011/11/17/introduction-to-composite-javascript-apps/), I introduced a few of the high level design ideas and implementation details that I have been using in an application that I&#8217;m building. Since then, the requirements for that app have grown significantly and I&#8217;ve made more progress toward a better composite application design.

## Content Swapping

My simple item management application started out with nothing more than these three regions on the screen:

<img title="NewImage.png" src="https://lostechies.com/content/derickbailey/uploads/2011/12/NewImage.png" border="0" alt="NewImage" width="574" height="536" />

Once this was in place, though, a new requirement came along… a complex search with search results. To implement this, I needed to modify the application&#8217;s interface to swap the grid and add/edit form out and put in a search results screen instead. The idea is that when the user does a search, the main content area will show the search results. The user can then go back to the location management aspect of the app whenever they need to. After a bit of searching, I found a high level pattern that made this easy, and also realized that I had previously implemented the core of this pattern without knowing it.

## Microsoft Prism: Regions and Region Managers

Several years ago, Microsoft released a framework for it&#8217;s WPF and Silverlight runtimes, called [Prism](http://msdn.microsoft.com/en-us/library/gg406140.aspx). This was essentially the big composite app framework that people used to build well structured and decoupled apps in XAML. I never had a chance to use this framework directly, but I worked with a team of developers that did use it.

One of the things that I liked about what I saw in Prism was the way it used the idea of &#8220;regions&#8221; and &#8220;region managers&#8221; to [compose the user interface](http://msdn.microsoft.com/en-us/library/ff921098(v=PandP.40).aspx). The gist of it is that you could define a visible area of the screen and build out the most basic layout for it without knowing what content was going to be displayed in it at runtime. Then at runtime, your application modules could register themselves to have content displayed in the various regions of the screen.

This pattern fits perfectly with the direction that my Backbone app is heading, so I decided to borrow the names and build my own version in JavaScript.

## A Simple Region Manager

In Prism, a region is defined in the XAML markup. In web applications, it&#8217;s defined in HTML markup. Similarly, in XAML a region manager is code that you write in C# or other .NET languages, while a region manager in a web app is going to be JavaScript. Backbone.js provides a good separation between the markup and the code to run that markup through it&#8217;s Views, so I initially thought about going down this path for my region manager. After a bit of thinking, though, I realized that I didn&#8217;t necessarily need a Backbone view. What I really need, at the very core, is a JavaScript object that do the following:

  * Represent an existing DOM node
  * Change out the contents of that DOM node
  * Call any required rendering and initialization for content views that will be displayed
  * Call any required cleanup for content views when they are removed

What I came up with as an initial pass at handling these needs, is the following (hard coded specifically to use a &#8220;#mainregion&#8221; element from the DOM):

{% gist 1468250 regionmanager.js %}

Does that look familiar? It certainly does to me. I&#8217;ve written this same code dozens of times and blogged about it in my [Zombies! RUN!](https://lostechies.com/derickbailey/2011/09/15/zombies-run-managing-page-transitions-in-backbone-apps/) post. So, it turns out that I&#8217;ve been using what I&#8217;m now calling a &#8220;region manager&#8221; for a while &#8211; I just didn&#8217;t realize it, previously. Oh, happy day! I&#8217;m just formalizing a concept I had introduced somewhere else, instead of having to create something new and unknown. 🙂

## Using The Region Manager

An in-depth use of the region manager has been covered in my Zombies post already. As a refresher, though, you only need to provide a Backbone view to the \`show\` method and the region manager will take over from there.

{% gist 1468250 view.js %}

The usual \`close\` method exists so we can handle our zombie problems. I&#8217;ve also added a bit more to the API that the region manager can handle, making it more robust and allowing it to handle more complex UI needs. Specifically, an \`onShow\` method fires on your view if you&#8217;ve provided one, just after the view&#8217;s \`el\` has been added to the DOM. This method will let you call into code that expects the DOM elements to exist, to manipulate them.

In this simple example, I&#8217;m using the \`onShow\` to fade the contents of the view in to view, using jQuery&#8217;s \`.show\` method and giving it a 500 milliseconds (1/2 of 1 second) time to do the fade. It&#8217;s a simple idea, but one that I&#8217;ve found is needed when using some libraries, such as the jQuery layout plugin. Again, this isn&#8217;t an idea that I came up with, either. I took this directly from my experience in working with WinForms applications. \`onShow\` is a standard event in the lifecycle of a Windows form, in .NET. It works well there, and it works well here in JavaScript, too.

## But Wait! There&#8217;s More!

Well, maybe there isn&#8217;t anything more at this point in time. But there will be soon. As I&#8217;m traveling down the composite application path, I&#8217;m starting to extract the useful bits into a library so that I don&#8217;t have to rebuild the same things over and over again. If you&#8217;re interested in watching this grow over time, checkout my [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette) repository on Github. It&#8217;s nearly empty at the time of writing this blog post, as it&#8217;s a work in progress. I plan on making a large announcement about it when I have more to share, sometime in the future.
