---
wordpress_id: 1174
title: When Do You Set The URL, In A BackboneJS App?
date: 2013-11-15T08:39:49+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1174
dsq_thread_id:
  - "1968475888"
categories:
  - Backbone
  - Design Patterns
  - JavaScript
  - Marionette
  - Principles and Patterns
---
[Oscar Godson](https://twitter.com/oscargodson) recently [asked a question](https://gist.github.com/OscarGodson/239bc11a4e8c2b46faad) about when to set the URL in a Single Page App (Backbone, specifically):

> <span style="font-family: Helvetica, arial, freesans, clean, sans-serif;font-size: 15px;line-height: 25px">I have a sidebar that pops in with form. It has a URL for it since it&#8217;s so commonly used. Going to app.com/foo/add would load the page and open the sidebar. Another view, </span><code style="font-family: Consolas, 'Liberation Mono', Courier, monospace;font-size: 12px;margin: 0px 2px;padding: 0px 5px;border: 1px solid #dddddd;background-color: #f8f8f8">TopMenu</code><span style="font-family: Helvetica, arial, freesans, clean, sans-serif;font-size: 15px;line-height: 25px">, has a button to open the sidebar. My question: who triggers the URL change? Should </span><code style="font-family: Consolas, 'Liberation Mono', Courier, monospace;font-size: 12px;margin: 0px 2px;padding: 0px 5px;border: 1px solid #dddddd;background-color: #f8f8f8">RightSidebar</code><span style="font-family: Helvetica, arial, freesans, clean, sans-serif;font-size: 15px;line-height: 25px"> change the URL with</span><code style="font-family: Consolas, 'Liberation Mono', Courier, monospace;font-size: 12px;margin: 0px 2px;padding: 0px 5px;border: 1px solid #dddddd;background-color: #f8f8f8">Backbone.navigate</code><span style="font-family: Helvetica, arial, freesans, clean, sans-serif;font-size: 15px;line-height: 25px"> (w/o trigger) or should the button change the URL and call the </span><code style="font-family: Consolas, 'Liberation Mono', Courier, monospace;font-size: 12px;margin: 0px 2px;padding: 0px 5px;border: 1px solid #dddddd;background-color: #f8f8f8">RightSidebar</code><span style="font-family: Helvetica, arial, freesans, clean, sans-serif;font-size: 15px;line-height: 25px">&#8216;s </span><code style="font-family: Consolas, 'Liberation Mono', Courier, monospace;font-size: 12px;margin: 0px 2px;padding: 0px 5px;border: 1px solid #dddddd;background-color: #f8f8f8">open</code><span style="font-family: Helvetica, arial, freesans, clean, sans-serif;font-size: 15px;line-height: 25px">method?</span>

There are a lot of possibilities for an answer, here. Oscar already alluded to several different options and there are potentially more. In my reply, I bring up a subject that I&#8217;ve talked about a lot &#8211; how to effectively use a router in a SPA. This topic is relevant to the question, but only one angle from which to view the problem. Ultimately, we&#8217;re looking for a single place in the code that can be in control of the application&#8217;s context and/or state &#8211; one place to rule them all, and in the router bind them &#8230; or something like that.

## My Reply (With A Bit Of Formatting)

Any time you have multiple points of entry for the same behavior, you need to encapsulate that behavior&#8217;s kick-off in to a single thing&#8230; an object, a function, a single line of code&#8230; whatever that thing is, it needs to be the one thing that is called in order to produce the desired behavior and state of the application. This often means you have to do a lot of prep work to [get the application in to a state where that one thing can be called](https://lostechies.com/derickbailey/2012/02/06/3-stages-of-a-backbone-applications-startup/). But, once you&#8217;re there you just call that one thing and the application puts itself in to the expected state with the expected behavior.

Here is a simple example:

{% gist 7485056 1.js %}

In both cases (using the router or clicking the DOM element), the code all comes back to the doFoo function. This is the one place in the application that knows how to put the app in to the &#8220;foo&#8221; state. In your case, this puts sidebar in place and puts the route in the URL as expected.

At this point, it doesn&#8217;t matter what code kicks off the \`doFoo\` process / app state. It could be a router, a button in a menu, a websockets event, image recognition technology from a webcam or anything else. When the doFoo function is called, the app moves in to the right state and does it&#8217;s thing, including setting the URL.

Of course this gets complicated when you start talking about very large apps. In very large apps, you need to partition your apps based on context to keep things sane. Sometimes it will make sense for a button click to just call a method on an object and the app is good to go. But, sometimes the feature being requested is in a completely different context with a completely different layout in the app. In these cases, it&#8217;s often easier to have a button click call router.navigate(&#8220;foo&#8221;, true)&#8221; to force the route handler to fire, or just use a link with the real url in the link.

In the end, the principle still applies: no matter how many entry points there are, you only want to call the \`doFoo\` function in order to get the app into the right state, with the right URL in the address bar.

## Further Reading

I&#8217;ve alluded to a lot of things in this reply, and a handful of assumptions about application architecture. There is a lot of information that you may want to read up on, some of which is free and some of which is not. But if you&#8217;re interested in seeing how this works out, in the end, it&#8217;s worth your time and money.

  * <https://lostechies.com/derickbailey/2011/08/28/dont-execute-a-backbone-js-route-handler-from-your-code/> &#8211; a less-than-clear attempt at explaining my position on routers
  * <http://www.kendoui.com/blogs/teamblog/posts/13-05-30/to-navigate-or-not-to-navigate-.aspx> &#8211; a much better explanation of my position on routers (specifics are about Kendo UI&#8217;s router, but it is very similar to Backbone&#8217;s, and the principles still apply)
  * <https://lostechies.com/derickbailey/2012/02/06/3-stages-of-a-backbone-applications-startup/> &#8211; getting your app from nothing to the point where you can call a router and get the app in to a specific context / state
  * <https://lostechies.com/derickbailey/2011/08/03/stop-using-backbone-as-if-it-were-a-stateless-web-server/> &#8211; general principles about building stateful applications, not stateless web servers with backbone
  * <http://www.backbonerails.com/> &#8211; a screencast series on building scalable Backbone / Marionette apps. well worth the money, for the architecture discussions
  * <https://leanpub.com/marionette-gentle-introduction> &#8211; an e-book on useful patterns for getting started with Backbone + Marionette, including architectural guidelines
  * <https://leanpub.com/marionetteexpose> &#8211; an e-book that covers advanced design patterns with Backbone + Marionette

There are probably dozens or hundreds more resources that I could list here, but that would be a very long list to compile. 
