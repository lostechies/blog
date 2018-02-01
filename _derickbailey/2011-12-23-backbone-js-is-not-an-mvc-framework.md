---
id: 732
title: Backbone.js Is Not An MVC Framework
date: 2011-12-23T13:13:42+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=732
dsq_thread_id:
  - "514141305"
categories:
  - Backbone
  - Design Patterns
  - JavaScript
  - Model-View-Controller
  - Model-View-Presenter
---
I&#8217;ve seen [this question / statement / argument](https://twitter.com/#!/tbranyen/status/149673338275512321) more than a few dozen times. I don&#8217;t particularly care whether or not people try to understand Backbone in terms of MVC frameworks, because that&#8217;s how we learn. We adapt new ideas based on existing knowledge experience, before we fully understand the new idea. However, I do care that people continue to say Backbone is an MVC framework, because it confuses people when they don&#8217;t see a &#8220;Controller&#8221; and see things like &#8220;[Routers/Views are sort of a controller](http://backbonejs.org/#FAQ-mvc)&#8220;.

I&#8217;m not going to &#8220;set the record straight&#8221; or try to offer the definitive answer on this, though. I&#8217;m not a core contributor to Backbone. I didn&#8217;t build it and I don&#8217;t have any say in how it&#8217;s truly architected and designed. So, none of what I say is official. I am going to offer my opinion, though. I feel my years of experience in working with MV* family applications at least gives me enough knowledge to do that… which, honestly, is only going to muddy the waters more because I seem to be in the minority on this opinion.

## There Are No Controllers In Backbone

There simply aren&#8217;t. In spite of the documentation saying that routers or view may be sort of maybe almost kind of close to some of what a controller might do, there are no controllers. It&#8217;s not a construct that exists in the backbone namespace, and there&#8217;s no implementation that represents what a controller does, architecturally.

A router is not a controller. It&#8217;s a router. A view is not a controller. It&#8217;s a view. Yes, both routers and views share some of what a modern web-server MVC framework, such as Ruby on Rails, would call a controller. But neither of these is a controller.

## More MVP Than MVC

I&#8217;ve spent 5+ years building MV* family applications in thick-client / GUI systems (Windows / WinForms / WinMobile) and on the web (Rails, ASP.NET, ASP.NET MVC, etc). Backbone clearly fits in to this family, but it&#8217;s also clearly not MVC. My opinion says that it&#8217;s closer to MVP, where the backbone view is closer to a P (presenter) and the HTML/DOM is the V (view).

Consider this picture of an MVC process flow ([from Wikipedia](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)):

<img title="NewImage.png" src="http://lostechies.com/derickbailey/files/2011/12/NewImage1.png" alt="NewImage" width="350" height="160" border="0" />

Here, the models contain data which is used to populate views. Actions that a user initiates are handled by the controller which processes the request and updates the models. The models are then fed back to the views and the cycle starts over. It&#8217;s cyclical in nature.

And now consider this picture of an MVP process flow ([from LessThanDot.com](http://blogs.lessthandot.com/index.php/Architect/DesigningSoftware/model-view-presenter-looking-at-passive)):

<img title="NewImage.png" src="http://lostechies.com/derickbailey/files/2011/12/NewImage2.png" alt="NewImage" width="267" height="219" border="0" />

Notice the difference? Right &#8211; it&#8217;s not circular. That&#8217;s the big difference between MVC and plain-jane MVP (a.k.a. &#8220;[passive view](http://martinfowler.com/eaaDev/PassiveScreen.html)&#8220;). MVP does not work in a circular fashion the way MVC does. Instead, it relies on a presenter (the &#8220;P&#8221; in MVP) to be the coordinating brains of the operation. The presenter in an MVP app is responsible for taking the data from the models and stuffing it in to the views. Then when an action is taken on the view, the presenter intercepts it and coordinates the work with the other services, resulting in changes to models. The presenter then takes those model changes and pushes them back out to the view, and the elevator of moving data up and down the architectural stack begins again.

Does the idea and responsibility of a presenter sound familiar when thinking about Backbone? It should… it fits almost concept for concept with Backbone&#8217;s views, in my mind. But that doesn&#8217;t mean Backbone is an MVP implementation, either. It only means that views should be thought of as presenters, not controllers.

## Neither MVP, Nor MVC, Nor MVVM, Nor &#8230;

Ultimately, trying to cram Backbone in to a pattern language that doesn&#8217;t fit is a bad idea. We end up in useless arguments and overblown, wordy blog posts like this one, because no one can seem to agree on which cookie-cutter pattern name something fits in to.

Backbone, in my opinion, is not MVC. It&#8217;s also not MVP, nor is it MVVM (like Knockout.js) or any other specific, well-known name. It takes bits and pieces from different flavors of the MV* family and it creates a very flexible library of tools that we can use to create amazing websites.

So, I say we toss MVC/MVP/MVVM out the window and just call it part of the MV* family. Or better yet, let&#8217;s just call it &#8220;The Backbone Way&#8221; and forget about trying to fit some cookie cutter mold around a fluid and flexible library.Then we can focus on what Backbone actually provides and how these pieces should work together to create our apps.