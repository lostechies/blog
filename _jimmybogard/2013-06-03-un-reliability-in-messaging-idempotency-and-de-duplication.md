---
wordpress_id: 786
title: '(Un) Reliability in messaging: idempotency and de-duplication'
date: 2013-06-03T14:01:35+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=786
dsq_thread_id:
  - "1355492578"
categories:
  - Messaging
  - SOA
---
In my post on [ditching two-phase commits](http://lostechies.com/jimmybogard/2013/05/09/ditching-two-phased-commits/), I introduced the problem of trying to listen and talk at the same time. Essentially, people typically do two-phased commits in messaging systems because they want to deal with messages “exactly once”. But this sort of coordination is hard, and if we want to achieve higher performance/throughput, we need to take a different approach. Luckily, people much smarter than me have [already identified ways of dealing](http://queue.acm.org/detail.cfm?id=2187821) with (un)reliable messaging.

Instead of having “exactly once” messaging, a more relaxed and scalable approach would be to do “at least once” messaging. Instead of locking resources everywhere, we can assume that messages will arrive at least once (and maybe twice, three times etc.) Now we have the burden on the client side – how should we deal with these duplicates?

### Option 1: Every message is idempotent

Idempotency is by far the easiest way to deal with duplicate messages. There are a couple of different approaches we can take in this option, dealing with them on the client side.

The first way is conditional on our message. If there is a natural idempotency to the outcome of our message, then we really don’t need to do anything special. If our message is to affect state, and doing the same thing twice achieves the same result, then no need to do any sort of special checking:

{% gist 5627789 %}

If your recipient can process the message multiple times and have the same result every time, we can just rely on that. For objects that represent state machines, or operations that alter state without side effects, this can work quite nicely for us. But what about something that isn’t naturally idempotent?

{% gist 5627812 %}

If I ask to credit this account $1000, and I receive this message twice, my resulting balance is now $2000 higher! Not exactly what I want. A simple approach here would be to attach some sort of correlation identifier to my request (i.e., your checks have a check number):

{% gist 5627831 %}

Now I keep track of the transfer requests, and only process ones that I see are new. This is similar to receiving payment in the form of a check, that might have been both mailed and faxed. The check can only get cashed once, so I just keep track of what checks I’ve cashed on my side to determine if this check is “new” or not.

If I don’t have natural idempotency nor do you have a correlation identifier that you can rely on, you might have to invent one. One approach could be to hash the message coming in and store those (sort of like Git commit hashes). In the transfer case, we might include something like a timestamp to correlate.

If we can’t implement idempotency at the entity level, then our entity can only handle at-most-once messages. When our entities can only handle at-most-once, then something else needs to handle detecting duplicates and tossing out any detected extras.

### Option 2: Messages are de-duplicated

If we can’t (or won’t) rely our entities to enforce idempotency, but our messaging infrastructure still allows at-least-once messages, then we’ll need to have someone liaison between the receiving and delivery of messages:

[<img title="image" style="border-left-width: 0px; border-right-width: 0px; background-image: none; border-bottom-width: 0px; padding-top: 0px; padding-left: 0px; display: inline; padding-right: 0px; border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2013/06/image_thumb.png" width="412" height="231" />](http://lostechies.com/jimmybogard/files/2013/06/image.png)

When a message is received, it’s checked against a message store. If the message already appears in our message store, then we can safely discard it. Only when we’ve confirmed that it’s new do we forward the message on to our consumer.

Storing all these messages since the beginning of time can be burdensome, both for general storage and for checking. We might have a garbage collection process that removes messages from our store past a certain expiration, assuming that we never receive duplicates after a certain amount of time. This lets our message store not get unreasonably large.

Another option is to handle de-duplication on the sender side. If the producer sends the message twice because of failures, we might introduce a slight delay in sending messages along the wire:

[<img title="image" style="border-left-width: 0px; border-right-width: 0px; background-image: none; border-bottom-width: 0px; padding-top: 0px; padding-left: 0px; display: inline; padding-right: 0px; border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2013/06/image_thumb1.png" width="407" height="152" />](http://lostechies.com/jimmybogard/files/2013/06/image1.png)

Instead of sending messages immediately to their destination, we could set them aside in a buffer and delay their actual deliver. If we receive the same message twice in quick succession (for any definition of “quick”), we can prevent duplicates from getting sent in the first place. In this case, we assume that sending to our buffer is highly successful, but sometimes we send the message twice. We tune the buffering period (maybe 10 seconds, maybe an hour) based on our SLAs and so on.

This does introduce delays in getting messages to their intended recipient, so it would take some profiling to see what our buffer times should be. It turns out that this is what Azure provides out of the box.

We might provide a mixture of these two, buffering messages for non-idempotent, non-undoable operations like sending emails, but provide idempotency for the rest.

Of the two approaches, idempotency is the approach that provides the greatest long-term value, as a lot of other problems tend to go away once our system exhibits idempotency. In the messiness of the real world, most of the time us as humans pick the idempotency approach, simply because it’s the least expensive approach with regards to our transport mechanism. If we remove burdens of transactions and such from our transports to our application layer, our transport can be as speedy as possible.