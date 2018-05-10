---
wordpress_id: 570
title: Formula for project success
date: 2012-01-03T13:50:09+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/01/03/formula-for-project-success/
dsq_thread_id:
  - "525120239"
categories:
  - Rant
---
In light of [recent](https://lostechies.com/chadmyers/2011/12/30/sweet-sweet-vindication/) [conversations](http://wekeroad.com/2012/01/03/rails-has-turned-me-into-a-cannibalizing-idiot/) around ActiveRecord and Rails, I thought it might be important to recognize the factors in a project success, in terms of the code produced:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2012/01/image_thumb.png" width="485" height="293" />](https://lostechies.com/content/jimmybogard/uploads/2012/01/image.png)

In order for a software project to be successful, two things matter. What you code (the features you choose to develop) and how you code it (what technology you use, how easy it is to change, etc.)

These two constraints balance against each other, and neither is really more important than the other. If you code crap relative to what you need to code, then what you deliver won’t be good. However, it’s also important to recognize what drives what:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2012/01/image_thumb1.png" width="583" height="135" />](https://lostechies.com/content/jimmybogard/uploads/2012/01/image1.png)

That is, what ever features/design/scope of what you’re building should drive the architecture/style/technology/patterns of how you code it. Picking the right before the left is putting the cart before the horse. Understand what you’re building, what the vectors of change will be, how large the application will be, how complex in which areas it will be, and let that drive your decisions on what framework/technology/patterns to use.

Once you know HOW to use a technology, the next step is to know WHEN to use that technology, and more importantly, when not to. Clients don’t care about code, but they do care about a bad product. Know what’s important here, and make sure that the code is merely the means (a very important means) to an end.