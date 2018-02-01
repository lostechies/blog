---
id: 540
title: Event Sourcing as a strategic advantage
date: 2011-10-11T13:31:19+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2011/10/11/event-sourcing-as-a-strategic-advantage/
dsq_thread_id:
  - "440146339"
categories:
  - DomainDrivenDesign
---
Very often you hear Domain-Driven Design recommended as an approach that should not be applied except in a few key strategic scenarios. The reasons for this are quite simple: DDD is expensive. Not in the time it takes to code the patterns (typing is cheap), but in the time it takes to build an understanding of the domain, form a model, and refine that model over time. The code is cheap, the conversations leading up to the code are expensive.

That said, DDD is an effective approach when the system you’re building is part of the strategic advantage of the business. If the system is important to the company because its revenue depends on how well the system aligns with the company’s short- and long-term objectives, then it will probably (hopefully) receive enough investment to realize that strategic advantage.

If you’re already going the DDD route, you’ll eventually come to a choice on what mechanism you’d like to use to model your domain. Currently, you have two major choices:

  * Persisting current state
  * Persisting as a stream of events

The first approach is the “traditional” DDD approach, most thoroughly explained in the “[Applying Domain-Driven Design and Patterns](http://www.informit.com/store/product.aspx?isbn=0321268202)” book. This is where you’ll find technical discussions on entities, aggregates, repositories and so on.

If you’ve already taken the plunge to “do DDD”, then [Event Sourcing](http://cqrsinfo.com/documents/events-as-storage-mechanism/) as a means of enhancing the strategic advantage that DDD brings is something that should be seriously considered.

### 

### Strategic advantages of event sourcing

Event sourcing is simply a mechanism of realizing state by capturing a stream of events. The final picture of state is available by replaying sequence of events that led to that final state.

In television crime drama shows, the investigators walk into a crime scene, which represents the final state of a system. Then there’s some sort of flashback where the crime is replayed as the series of events that led to that final result. Without the television magic of replaying the events, it’s difficult to deduce why the current state is where it is. **But if you’re trying to understand _why_ the current state is what it is, the final state is not nearly as useful as the series of events that led to that endpoint.**

In critical business systems, state is often not nearly as important as the behavior that led to that current state. This behavior could be users purchasing items, orders being shipped, etc. These events are what reflect the health of the business, as they represent activities that actually result in revenue for the business.

As a business matures, you often see that in order to promote growth of the business, their strategic advantage lies in how well they understand the _why_ of where their revenue comes from. It’s not enough that we sold 10000 widgets. Why did we sell that many? How can we sell more? **Events provide insight into how the system came to be in its current state**. It’s replaying the crime scene to determine the guilty. Without replaying, we can only make an educational guess.

Because businesses care so much about why the current state is what it is, explicitly modeling state as a stream of events aligns with the business’s goals.

### Event sourcing in the enterprise

As the business grows, more and more areas want to react more quickly to changes happening in the system. Instead of being fed a daily feed of data, they want to be fed events. Don’t give me a feed of users every day, give me a list of new users, users who have moved, users who have cancelled their account. Don’t force me to reverse-engineer the crime scene, just tell me what happened.

In order for ancillary services in the enterprise to most effectively react to changes, they need to be aware of the business-level events that have happened. Just having access to data doesn’t describe what has happened. With events, individual services can determine how they want to react to business-scoped events, like “UserRegistered” or “AccountCancelled”. **A single feed that tries to capture all this information in a single stream then puts the burden on the consumer to try to figure out what actually happened.**

With event sourcing, our events are explicit in the system, and much more easily exposed to the enterprise. Furthermore, for historical purposes, it’s also much easier to perform data mining of business events when we capture events explicitly.

### 

### Event sourcing as an investment

Modeling state as a stream of events means you’re committing to capturing behavior explicitly, instead of capturing state. It’s an investment, not because it’s hard to capture events, but because of the conversations required to surface what the events and behavior should be. **State is easy to figure out. Behavior is not.**

However, if the business isn’t making an investment in a system that you believe needs event sourcing/DDD, it’s likely because:

  * Ignorance of the strategic investment these approaches bring
  * Lack of capital to actually make the investment (cart before the horse scenario)
  * The system isn’t as important as you think it is

Be careful that you’re not falling into the last one. Sometimes the system you’re working on just isn’t a part of the business’s strategic goals, and it’s just a tactical response. Otherwise, it’s just a matter of having a conversation with the business to see if they’re more interested in the current picture, or the sequence of events and behaviors that led to the current state. Current state is easy with event sourcing, it just matters if the business is interested in how they got there.