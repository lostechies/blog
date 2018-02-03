---
wordpress_id: 834
title: 'Put your controllers on a diet: redux'
date: 2013-10-10T13:03:27+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=834
dsq_thread_id:
  - "1842872863"
categories:
  - ASPNETMVC
---
A few years back, I put together a talk on [putting your controllers on a diet](http://www.viddler.com/v/b568679c) using&nbsp; variety of techniques and extension points inside MVC. Well, [a lot has changed in four years](http://lostechies.com/jimmybogard/2013/07/17/how-we-do-mvc-4-years-later/), and with the lessons learned from the drawbacks of some of my original approaches, putting your controllers on a diet needs some revisiting.

The original goals of slim controller actions are still valid:

  * Controller is a lousy place for business logic
  * Actions should be almost declarative in nature (though I’m not using controller-less actions or the like)
  * Simplicity and consistency is paramount
  * ASP.NET MVC Controller unit tests are dumb

As before, we found that in our controller actions, there is a stark contrast between GET and POST actions. This shouldn’t be new – GET actions get data, and POST actions modify data. It’s not my opinion – it’s the spec! I already talked about what has changed in my “four years later” post, but I got quite a few questions to revisit that original talk on putting controller on a diet. Evidently some folks think I actually know what I’m doing.

Before we start looking at our changes, let’s look back on what we want to actually fix:

[gist id=6917851]

There’s nothing horrible about this controller, each action isn’t too bad. However, if GETs or POSTs get any more complex than this, I’d want to start isolating that behavior outside of things like ModelState and ActionResults. In the next series of posts, we’ll cover building concepts around GETs and POSTs, moving all business logic outside of the controller into pieces isolated from the UI, without resorting to as many somewhat esoteric tricks of custom action results and inflexible model binding extensions.

Next up: mediator pattern enlightenment.