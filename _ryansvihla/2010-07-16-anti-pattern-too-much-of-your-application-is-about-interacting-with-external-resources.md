---
wordpress_id: 46
title: 'Anti-Pattern: Too much of your application is about interacting with external resources'
date: 2010-07-16T02:24:00+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2010/07/15/anti-pattern-too-much-of-your-application-is-about-interacting-with-external-resources.aspx
dsq_thread_id:
  - "1069937824"
categories:
  - Anti-Patterns
redirect_from: "/blogs/rssvihla/archive/2010/07/15/anti-pattern-too-much-of-your-application-is-about-interacting-with-external-resources.aspx/"
---
Firstly, what am I talking about? Applications that meet some of the following descriptions:

  1. Stored procedures with a fair amount of conditional logic or complicated business rules buried in a sub-query (some would argue sprocs at all).
  2. Web pages with lots of conditional output again encoding business rules in snippets of view logic. if else checks that display the latest price for something if before and certain date or a default price.
  3. The majority of ‘unit tests’ require a database, or web and application server to be up and running.
  4. The majority of code files make reference to language default I/O or database libraries.
  5. Hours are spent trying to determine if differences in version of infrastructure are the cause of certain bugs.
  6. Changing database schema results in hours of refactoring, as hundreds of querys and sprocs are hunted through to see if this index or that index is being properly hit.

Why is this an anti-pattern? First before I bore you with endless reasoning behind SOLID principles, proper OO etc if you’re reading this and you’re of a bent that disagrees with me so far entirely..none of that will mean anything to you, and none of it will mean anything to your customers so let me put this in the most practical terms I can. 

_**It is not testable in the slightest in any practical sense**_. You will be counter with well that with that sort of application and making everything a front to back test that you KNOW when things are working, _**yes but you RARELY if EVER know in a quick sense why things are not working.**_ If i can reliably eliminate any chance that my actual code or business logic is the cause of a problem, if all of my fancy business rules are in something that can be run thousands of times a second, then I can throw all sorts of corner cases at my code base and not increase my verification time. If the majority of my application is business logic and plain old code then I can save my slow manual testing to the areas that are so bullet proof and only have a slice of my application doing front to back testing to yes, make sure things really work.