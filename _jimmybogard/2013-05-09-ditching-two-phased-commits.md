---
wordpress_id: 776
title: Ditching two-phased commits
date: 2013-05-09T01:47:34+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=776
dsq_thread_id:
  - "1273771032"
categories:
  - Messaging
  - SOA
---
I’ve had a love-hate relationship with [two-phased commits](https://en.wikipedia.org/wiki/Two-phase_commit_protocol) during my years with messaging. Even if [MSDTC](http://en.wikipedia.org/wiki/Microsoft_Distributed_Transaction_Coordinator) was free to set up, it doesn’t come free in terms of throughput. Most people run into 2PC in messaging because because queueing systems and databases are two different resources, and therefore don’t participate in the same transaction. Ideally, I’d have all three participants either succeed or fail together:

[<img title="image" style="border-top: 0px; border-right: 0px; background-image: none; border-bottom: 0px; padding-top: 0px; padding-left: 0px; border-left: 0px; display: inline; padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2013/05/image_thumb1.png" width="499" height="379" />](http://lostechies.com/content/jimmybogard/uploads/2013/05/image1.png)

Since the queues in this picture are different resources than the database, I need to involve a third party, or transaction manager, to coordinate transactions between these three resources.

DTC, when it works, works really well. It’s much, much easier to not care about the consequences of a lack of coordination. In fact, I’d recommend not caring until you actually do care, because ditching two-phased commits does require work. Luckily for us, there are a [ton of resources](http://dancres.org/reading_list.html) on how to do exactly that!

Most of the time, literature around avoiding 2PC is concerned about an entirely different situation, where I have two separate databases:

[<img title="image" style="border-top: 0px; border-right: 0px; background-image: none; border-bottom: 0px; padding-top: 0px; padding-left: 0px; border-left: 0px; display: inline; padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2013/05/image_thumb2.png" width="459" height="347" />](http://lostechies.com/content/jimmybogard/uploads/2013/05/image2.png)

We’re doing messaging, which means that it’s typically the consumer of the message that does something against other data stores. So even though we’re avoiding communicating with two databases, it’s still two resources, and thus a need to coordinate!

But again, that coordination comes with a cost. A fairly large cost, in some recent testing we found that overall throughput dropped 80%, or to put it another way, ditching DTC saw a 5X increase in throughput. Five fold!

For some systems, that throughput doesn’t matter much, but for those that have a reasonably high volume of messages, or sensitive SLAs, it’s worth investigating alternative approaches.

### General rules of thumb

Like most messaging approaches, the ways of avoiding coordination are right in front of our faces. In Gregor Hohpe’s excellent [paper on Starbucks](http://www.enterpriseintegrationpatterns.com/docs/IEEE_Software_Design_2PC.pdf), he points out any real-world system that values throughput over absolute consistency avoids distributed transactions. The basic ideas are:

  * Idempotency is king. Get this and you’re halfway home
  * Strategies for dealing with downstream effects is a business decision

[Idempotency](http://en.wikipedia.org/wiki/Idempotence) is absolutely required, but it’s not that hard to apply. For some operations, we can rely on natural idempotency. If I’m asked to turn on the light, receiving the request twice means the same outcome – the light is on! For state machine-like systems, idempotency is a bit easier.

For operations that aren’t naturally idempotent (launch the nuclear missile), we’ll need to get a little creative. If we can identify some correlating information from a request (The president called at 9:15 to launch the missile) or just assign some correlation information (The president has issued request #132 to launch the missile), we can simply keep a journal on the receiving side. If it’s expensive to keep a journal around, we can recycle/trim our journals if they get too big.

Downstream effects become more interesting. If throughput is a high concern, we can rely on compensating actions (customer didn’t have enough money, cancel the order) or more journaling. Instead of sending a message immediately, shouting out messages to downstream systems, we can instead just write down in the same persistent store as our other data another journal for outgoing messages.

Once our local DB transaction is complete, it’s just a matter of sending the messages we’ve written down to send out down the line, and crossing them off our list of “sent” messages. And since downstream systems can deal with at-least-once messages through our idempotency guarantees.

### How I learned to stop worrying and ditch 2PC

In some current systems, we’re deciding on a service-by-service basis whether or not we want to enlist or not enlist in distributed transactions. It’s still annoying to try and build a system-wide solution (though the event sourcing guys have this more or less in the bag), so until then, I can just use business decisions to guide me one way or the other.

But it is time to let go and stop worrying so much. Honestly, unless your services have downstream side effects, you can safely turn off DTC if your work is idempotent. If you have downstream side effects, there’s a number of paths to choose from. While I’m not saying goodbye forever (still the best solution if it were absolutely free to use), it is time to shop around.