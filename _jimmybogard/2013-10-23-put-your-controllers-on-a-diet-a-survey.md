---
wordpress_id: 838
title: 'Put your controllers on a diet: a survey'
date: 2013-10-23T20:43:24+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=838
dsq_thread_id:
  - "1892350010"
categories:
  - Architecture
  - ASPNETMVC
  - Design
---
Previous posts in this series:

  * [Redux](http://lostechies.com/jimmybogard/2013/10/10/put-your-controllers-on-a-diet-redux/)
  * [Defactoring](http://lostechies.com/jimmybogard/2013/10/22/put-your-controllers-on-a-diet-defactoring/)

In the last post, I removed all the abstractions and layers from my application in order to provide a better view on what my next steps should be. This is like climbing to the top of a mountain or climbing a tree, you have to move to a higher elevation to increase your purview. I’m not interested in just this one controller, but all my controllers. I want to build a consistent architecture across my system, as every new controller/action shouldn’t require a new decision on how it should be built.

So what are our goals here? Why do any refactoring at all?

Looking at just this one controller, I don’t currently see any reason to go any further. I wouldn’t even write tests for this necessarily, there’s so little going on.

But maybe I do, and testing these controllers isn’t really a big deal. It’s an integration test, one that would exercise the database. We already know how to do that, so there’s not much point in refactoring these controllers any in the goal of “testability”. It’s already testable. I can control all the pieces I need to in this picture:

[gist id=7118873]

Back to our goals, why go further? What about complexity? Is this complex?

[gist id=7118902]

Again, not really. I’ve got a few things going on (validation, querying, mutation and then redirection) covering various layers (UI/DB/Domain) all in one method. Is this fundamentally wrong?

Well, _it depends_.

If I just have a small application, who cares, additional abstraction only detracts. If I’m erecting a backyard shed, I don’t need steel piers driven into the ground for stability. A treehouse doesn’t need central heating and air or running water. The beauty of software is that unlike construction, we can pivot and refactor our design to an architecture suited to the complexity of our system.

Where will our complexity lie? I’m not entirely sure yet, but one thing I do know – controllers can get messy, sloppy, muddled and disheveled. Looking over the entire controller class&nbsp; (<https://gist.github.com/jbogard/7102870>) there’s a clear pattern here:

  * GET actions query the database and return a view model to the view
  * POST actions validate, load an entity, mutate it, and redirect to a success page

Whatever direction we go, these two kinds of activities (GET/POST, read/write) are very, very different. Controllers make me put all that code in one place, but what if things get a little crazy? What if our validation for conference names require a unique name (subtle, but it’s implied in this design). What about caching? What if building my view screens require data from multiple locations, and can’t be done with one query? What if editing successfully results in sending an email out to attendees?

It’s these complexities that lead me down a direction of clear separation of GET/POST concerns. Whatever abstractions I build, I’m going to make sure that I don’t cross the GET/POST boundary (or for those paying attention, the Command/Query boundary).

Next up: commands and queries.