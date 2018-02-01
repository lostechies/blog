---
id: 657
title: Busting some CQRS myths
date: 2012-08-22T13:35:36+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2012/08/22/busting-some-cqrs-myths/
dsq_thread_id:
  - "814478004"
categories:
  - CQRS
  - DomainDrivenDesign
---
CQRS, while a relatively simple concept, still brings a lot of assumptions about what CQRS is and should be. So what is CQRS? Simply put, [CQRS is two objects where there was once one](http://cqrs.wordpress.com/documents/cqrs-introduction/). We’re splitting code infrastructure down to the data layers between commands and queries.

But the assumptions around what a CQRS _should_ be lead folks I’ve seen down paths of unnecessary complexity. Complexity around the architecture, and especially around the UI.

### Myth #1 – CQRS = Event Sourcing and vice versa

[Event sourcing](http://martinfowler.com/eaaDev/EventSourcing.html) often fits well with CQRS, as it makes building and updating read stores over time a bit more straightforward in eventually consistent models. Additionally, the aggregates living in the command side for behavior-heavier systems and task-based UIs more obvious.

However, **event sourcing is a completely orthogonal concept to CQRS**. While they fit well together, doing CQRS does not require event sourcing, and doing event sourcing does not automatically mean we’re doing CQRS.

For me, the bar for event sourcing is rather high and targeted (only inside a bounded context, for one), but that’s a story for another day.

### Myth #2 – CQRS requires an eventual consistent read store

No, it does not. You can make your read store immediately consistent. That is, your read store can be updated when your command side succeeds (in the same transaction).

For many legacy/existing apps, transitioning to eventually consistent read stores will either force you to go through bogus hoops of mimicking synchronous calls. **Users will bang down on your door with pitchforks and torches if you try and transition to an asynchronous model if you don’t change their business process first.**

Instead, you can start with immediate consistency and transition where and when it’s needed. Unless a user expects a confirmation page, making every command page have a series of confirmations of “your request was received” is going to annoy the snot out of your users.

### Myth #3 – CQRS requires a bus/queues/asynchronous messaging

See above myth. Nothing about CQRS says “thou shalt use NServiceBus”. It’s just not there. You’re merely separating infrastructure between handling commands and queries, but the _how_ is quite varied. Don’t start with a bus until you prove you need eventual consistency.

**Consistency models are a business decision because it directly impacts user experience**. An eventually consistent model requires a different user experience than an immediate one, and this is not something you can just “slip in” to your users, or try to emulate. If you’re attempting to emulate immediate consistency in an eventually consistent model, you’re doing something wrong.

### Myth #4 – Commands are fire-and-forget

How many business processes in your line of work are truly fire and forget? You typically need at least a synchronous acknowledgement that the command was received and accepted. If you’re doing an async send of the command, how do you notify the user? Email? Are they OK with this?

Instead, with commands that need heavy lifting to fulfill the request, we really have two things going on:

  * Accepting the request 
      * Fulfilling the request</ul> 
    **Accepting the request should be synchronous**. **Fulfilling need not be**. But for the model of an asynchronous fulfillment, we still will likely need ways of correlating requests etc., and this is where you often see workflows/processes/sagas come into play.
    
    ### Myth #5 – Read model needs to be built in an eventually consistent manner
    
    Only when the business needs require eventual consistency does it need to be eventually consistent. How do we find this out? Probing and questioning. But not of the kind of “hey mr. business dood, can the read model be eventually consistent?”
    
    Instead, we have to dig down on why we would need eventual consistency, and track those back to actual business needs. This is where **imagining worlds without computers really helps**. Human systems are inherently failure-prone, asynchronous and massively parallel. We just need to match our systems to how they actually work, not necessarily match human systems to how we built our applications.
    
    Remember, as soon as you move to eventual consistency, your user experience must now deal with that fact that the operation the user just performed will not have its effects show up immediately. Additionally, you have to deal with failures in that area. What happens if your mechanism to build your read model fails or is slow? Does your user experience support those situations? If not, I don’t think you’re going to enjoy the support calls.
    
    ### Myth #6 – CQRS lets you escape consistency problems and eliminate concurrency violations
    
    Decidedly no on both counts. I’ve seen CQRS/ES systems scale horribly, mainly because in order to skip the problems of concurrency all commands and denormalization requests were flowed through a single-file line. Yes, forcing all commands to execute in single-file will eliminate concurrency problems. But now we’ve just forced ourselves into a serializable transaction isolation level.
    
    On the read side, you can make your event handlers idempotent, but can they operate if items arrive out-of-order? Or arrive twice? De-duplicating events helps the latter, but I’ve seen teams miss out-of-order events again and again.
    
    Denormalizing event handlers _can_ be simple, but they are not the brain-dead code that I originally thought they would be. You just can’t escape concurrency.
    
    ### Myth #7 – CQRS is easy
    
    If it were easy, I wouldn’t see so many people with failed attempts to roll out a CQRS system. CQRS does not eliminate the need to understand what our business needs are. It might make it easier to realize those needs, but it’s just as easy to build the wrong system in a CQRS architecture as it is with n-tier.
    
    **Understanding business requirements are the hard part.** Sure, we all have technical challenges. But for the CQRS sweet spot of task-based UIs and behavioral domains, that requires us to understand what the heck the business actually needs (versus wants).
    
    Things get even more difficult with CQRS systems replacing legacy applications. In these situations, a wholesale rewrite is the most risky option you can take, and just having CQRS in your corner does not eliminate these risks.
    
    ### The Silver Lining
    
    All this being said, CQRS is a lovely architecture for separating two wildly different concerns. But don’t just throw every related CQRS concept at your application – **defer these decisions until you’ve proven their need**. You might just end up with something that actually fits the business needs!