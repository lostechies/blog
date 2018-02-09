---
wordpress_id: 36
title: 'Proactive vs Reactive Validation: Don’t We Need Both?'
date: 2009-02-15T18:49:55+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/02/15/proactive-vs-reactive-validation-don-t-we-need-both.aspx
dsq_thread_id:
  - "262053102"
categories:
  - .NET
  - 'C#'
  - Domain Driven Design
  - Principles and Patterns
redirect_from: "/blogs/derickbailey/archive/2009/02/15/proactive-vs-reactive-validation-don-t-we-need-both.aspx/"
---
**Update:** There’s a wealth of knowledge out there that I just haven’t been aware of until now. Thanks to the many commenters of this post, other posts, and other conversations for the links and info. Here is a list of items that I’m finding to be very helpful in understanding what is only a surface level “validation” problem:

  * <a href="http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/02/15/validation-in-a-ddd-world.aspx" target="_blank">Validation in a DDD World</a> 
  * <a href="http://devlicious.com/blogs/billy_mccafferty/archive/2009/02/17/a-response-to-validation-in-a-ddd-world.aspx" target="_blank">A response to Validation in a DDD world</a> 
  * <a href="http://jonathan-oliver.blogspot.com/2009/02/ddd-entity-validation-and-commandquery.html" target="_blank">DDD: Entity Validation and Command/Query Separation</a> 
  * <a href="http://jonathan-oliver.blogspot.com/2009/02/ddd-cqs-and-bounded-contexts.html" target="_blank">DDD: CQS and Bounded Contexts</a> 
  * <a href="http://www.infoq.com/interviews/greg-young-ddd" target="_blank">Greg Young Discusses State Transitions in Domain-Driven Design and DDD Best Practices</a> (InfoQ Video interview) 
  * <a href="http://devlicio.us/blogs/casey/archive/2009/02/12/ddd-command-query-separation-as-an-architectural-concept.aspx" target="_blank">DDD: Command Query Separation as an Architectural Concept</a> 

**Update 3/3/2009** – additional info in the continuing conversation.

  * <a href="http://www.codethinked.com/post/2009/02/23/Who-Knew-Domain-Validation-Was-So-Hard.aspx" target="_blank">Who Knew Domain Validation Was So Hard?</a> 
  * <a href="http://www.nichesoftware.co.nz/blog/200902/validation-and-domain-driven-design" target="_blank">Validation and Domain Driven Design</a> 

**Update 3/11/2009** 

  * <a href="http://dddstepbystep.com/blogs/dddstepbystep/archive/2009/03/04/ddd-validity-consistency-and-immutability.aspx" target="_blank">DDD: Validity, Consistency and Immutability</a>
  * <a href="http://devlicio.us/blogs/casey/archive/2009/03/11/ddd-invariants-or-contextual-validation.aspx" target="_blank">DDD: Invariants or Contextual Validation?</a>

&#160;

There’s a whole host of stuff out there linked from these articles and posts, as well. It’s obvious now that I have a lot to learn and think about, and I think I have a better sense of where I need to start looking. I also think that the ideas Sean Biefeld expressed about never letting an entity be in an invalid state are more reachable than I previously thought. 

****

&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;-

This post started as a comment in Sean’s post on <a href="http://www.lostechies.com/blogs/seanbiefeld/archive/2009/02/14/entity-validation-ideation.aspx" target="_blank">Entity Validation Ideation</a> but quickly grew. I’m hesitant to post separately because I believe the conversation should continue along the lines of what he was originally saying. There’s just so much junk tossing around in my head, though, I didn’t think it would be appropriate to post a 50 page diatribe in a comment. 🙂

&#160;

A while back, I asked the question “<a href="http://www.lostechies.com/blogs/derickbailey/archive/2008/10/15/ddd-question-where-does-input-validation-belong.aspx" target="_blank">Where does required info validation belong for an entity?</a>” There were a lot of good answers to that question and my team and I took some very interesting directions based on those answers. However, I still haven’t had the ‘validation’ question completely answered in my mind. Fortunately, I’ve got the brains of my fellow Los Techies (and coworker in this case), to keep me from giving in to the entropy that wants to keep me mediocre.

I love the theory that Sean is talking about &#8211; especially when stated as &#8216;proactive&#8217; vs &#8216;reactive&#8217;. I&#8217;ve had a hard time with this in practice, though. In the last few weeks – days, really &#8211; it seems to me that we need to have both proactive and reactive validation in our applications. 

### Being Proactive

The domain model that I create wants to prevent an object from being invalid, so I require a minimum set of information in my constructors, etc etc. This helps me prevent an object from ever being created in an invalid state. this is the proactive approach. I love this approach and I use it a lot.

### Oh Wait, I Need Reactive

The proactive recently failed me, though. I had ‘the perfect’ domain model with the all the validation and rules composed in my entities, preventing the information from being added to the model if it was not valid. However, when I got to the user interface, I realized that I had a major design problem. The user interface is not &#8216;all or nothing&#8217; scenario. The user is allowed (expected, really) to only provide one field of information at a time. After all, you can&#8217;t type into more than one text box at a time &#8211; unless you have multiple keyboards and multi-input capable systems. So, when a user is adding information to the inputs of the form, we need to have a reactive approach. We need to provide real time validation of what the user is putting into the system, so that they can be immediately notified of any errors in what they are providing. This reactive approach is needed because the user interface is entirely reactive to the user&#8217;s actions. 

### Proactive AND Reactive?

At the same time that we need both a proactive and a reactive solution, we want to adhere to the "<a href="http://en.wikipedia.org/wiki/Don%27t_repeat_yourself" target="_blank">Don&#8217;t Repeat Yourself</a>" principle, encapsulating the validation logic into the appropriate location(s). If we require reactive validation in the user interface, and proactive validation in the domain model, how do we avoid breaking DRY? 

On the surface, proactive and reactive validation seem to be at odds with each other – at least, they do in my mind. I don&#8217;t think they need to be, or should be, though. We just need to find the higher level order in which we can enable both. Unfortunately, I haven&#8217;t been able to do this yet – at least not in a way that really seems to satisfy me. I&#8217;m curious to know how others approach this situation. How do we balance this triad of need: Proactive, Reactive, and DRY? 

I need some fresh perspectives on this, and I think Sean is starting out with some great ideas. Now if I can just learn to throw away my own bias to how I’ve already been handling this, maybe I’ll be able to learn something. 🙂