---
wordpress_id: 379
title: UI Automation tools snake oil?
date: 2010-01-04T14:03:43+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/01/04/ui-automation-tools-snake-oil.aspx
dsq_thread_id:
  - "264716387"
categories:
  - Testing
redirect_from: "/blogs/jimmy_bogard/archive/2010/01/04/ui-automation-tools-snake-oil.aspx/"
---
Michael Feathers posted a thoughtful piece describing the [general problems of UI testing tools and the industry in general](http://blog.objectmentor.com/articles/2010/01/04/ui-test-automation-tools-are-snake-oil).&#160; In general, I’d agree here.&#160; Automation tool vendors, as with almost every tool vendor out there, are eager to solve perceived software development problems.&#160; Unfortunately, these tools usually only address symptoms of larger problems.

With UI testing tools, this is no different.&#160; When we started out authoring UI tests for a large MVC application, we had a few large goals in mind.&#160; The tests needed to be:

  * Stable
  * Understandable
  * Maintainable
  * Valuable

To achieve these goals, we needed to do exactly what we do when we write code using TDD, **design for testability**.&#160; I won’t go into everything we did, there’s already a [whole screencast on that](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/10/22/c4mvc-ui-testing-screencast-posted.aspx).&#160; However, Michael does bring up some key points:

  * UI tests should test the UI layer
  * Architect your system so that you can test all of your business logic separate from the UI layer

That’s what we’ve done, and it’s been very successful.&#160; We have UI tests, around 500 of them, and we’re not staying up until all hours of the night keeping them working.&#160; We also have subcutaneous tests, that work in a layer right below the UI layer, that allow us to send a UI message into our system and check what comes out on the other side, whether it’s business rule violations or entities modified.

All of our testability enhancements came from design for testability.&#160; We use strongly-typed views.&#160; We don’t have any business/domain logic in controllers, only UI controller logic.&#160; Separating your architecture into layers isn’t for portability, it’s for separation of concerns.&#160; Once we started designing for testability in the large, and not just the unit level, we were able to maximize the value of automated tests, both at the UI, integration and unit level.

If anything, this is another example of the need for a developer to work on their spidey sense for vendor product demos.&#160; We rail on MS for drag-and-drop demos, but it’s _every_ tool vendor that employs this technique.&#160; Just like every other product sold in the world, it’s up to the buyer to be critical of the true value a tool can bring.