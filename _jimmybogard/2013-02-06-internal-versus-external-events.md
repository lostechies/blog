---
wordpress_id: 727
title: Internal versus external events
date: 2013-02-06T14:15:32+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=727
dsq_thread_id:
  - "1068599056"
categories:
  - DomainDrivenDesign
  - SOA
---
Inevitably, for those building event-driven architectures (or even message-based architectures), the need arises to publish events to some outside consumer. This consumer could be another solution built by the same team, an adjacent team, or consumers outside the firewall boundary.

Since these systems often already use messaging and events internally, the question is posed: **Are the events we publish internally the same as publishing externally?**

**The answer is no.**

**External message contracts need to have their own life cycles**. They have different constraints, different rates of change, and different abilities to from clients consume changes.

Internally, since we own the place, we can make changes to messages at typically much higher rates than for external clients. External clients have their own priorities, teams, goals and so on that we can’t just rock the boat because it feels right. Migrating internal consumers might be a cinch for new messages. But external ones, we need to think about their needs.

Instead, we need to build gateways as to prove an anti-corruption layer (from the Domain-Driven Design terminology) to broker our internal events to external ones:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2013/02/image_thumb.png" width="567" height="307" />](https://lostechies.com/content/jimmybogard/uploads/2013/02/image.png)

The messages flowing from internal publisher to the gateways may even look exactly the same, but we can’t treat them as _being_ the same. In order to preserve our own internal autonomy and shield ourselves from the constraints of the outside world, we need to maintain separation between our internal and external messages.

### External message design

The nice thing about this approach is that we can allow our external events to grow on their own. External events often need a bit of “translation” from internal events, as the ubiquitous language internal to a bounded context is not the same ubiquitous language used between bounded contexts. A “customer” to billing is not the same as a “customer” to support, for example.

Even the stimuli for publishing external events can differ. We might use push mechanisms, pull mechanisms, events, or polling to determine how, when and why external events get published. We might need to de-duplicate events published, to not force the idempotency issue on our clients.

We might design the shape of these events to include aggregate information that wouldn’t exist internally. External clients may be too burdened to call back for additional details, so these external events may be “fatter” than our internal ones.

In short, our external events often have reasons for change and requirements for design completely orthogonal than our internal events. To mitigate this problem, **use anti-corruption layers along with gateways to shield both you and your consumers from the natural evolution of your internal system.**