---
id: 766
title: Saga alternatives – routing slips
date: 2013-04-26T19:49:38+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=766
dsq_thread_id:
  - "1237795896"
categories:
  - Messaging
  - NServiceBus
---
In the last few posts on sagas, we looked at a variety of patterns of modeling long-running business transactions. However, the general problem of message routing doesn’t always require a central point of control, such as is provided with the saga facilities in NServiceBus. Process managers offer a great deal of flexibility in modeling complex business processes and splitting out concerns. They come at a cost though, with the shared state and single, centralized processor.

Back in our sandwich shop example, we had a picture of an interaction starting a process and moving down the line until completion:

[<img title="image" style="border-top: 0px; border-right: 0px; background-image: none; border-bottom: 0px; padding-top: 0px; padding-left: 0px; border-left: 0px; display: inline; padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2013/04/image_thumb.png" width="607" height="257" />](http://lostechies.com/jimmybogard/files/2013/04/image.png)

Not quite clear in this picture is that if we were to model this process as a saga, we’d have a central point in which all messages must flow to for decisions to be made on the next step. But is there really any decision to be made in the picture above? In a true saga, we have a sequence of steps and a set of compensating actions (in a very simplistic case). Many times, however, there’s no need to worry about compensations in case of failures. Nor does the order in which we do things change much.

Humans have already found that assembly lines are great ways of breaking down a long process into individual steps, and performing those steps one at a time. Henry Ford’s Model T rolled off the assembly line every 3 minutes. If only one centralized worker coordinated all steps, it’s difficult to imagine how this level of throughput could be achieved.

The key differentiator is that there’s nothing really to coordinate – the process of steps is well-defined and known up front, and individual steps shouldn’t need to make decisions about what’s next. Nor is there a need for a central controller to figure out the next step – we already know the steps up front!

In our sandwich model, we need to tweak our picture to represent the reality of what’s going on. Once I place my order, the sequence of steps to fulfill my order are known up front, based on simply examining my order. The only decision to be made is to inspect the order and write the steps down. My order then flows through the system based on the pre-defined steps:

[<img title="image" style="border-top: 0px; border-right: 0px; background-image: none; border-bottom: 0px; padding-top: 0px; padding-left: 0px; border-left: 0px; display: inline; padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2013/04/image_thumb1.png" width="607" height="242" />](http://lostechies.com/jimmybogard/files/2013/04/image1.png)

&nbsp;

Each step doesn’t change the order, nor do they decide what the next step is (or even care who the next step is). Each step’s job is to simply perform its operation, and once completed, pass the order to the next step.

Not all orders have the same set of steps, but that’s OK. As long as the steps don’t deviate from the plan once started, we don’t need to have any more “smarts” in our steps.

It turns out this pattern is a well-known pattern in the messaging world (which, in turn, borrowed its ideas from the real world): the [routing slip pattern](http://www.enterpriseintegrationpatterns.com/RoutingTable.html).

### Routing slips in NServiceBus

Routing slips don’t exist in NServiceBus, but it turns out it’s not too difficult to implement. A routing slip represents the list of steps (and the progress), as well as a place for us to stash any extra information needed further down the line:

[gist id=5469268]

We can attach our routing slip to the original message, so that each step can inspect the slip for the next step. We’ll kick off the process when we first send out the message:

[gist id=5469353]

Each handler handles the message, but doesn’t really need to do anything to pass it down the line, we can do this at the NServiceBus infrastructure level.

[gist id=5469381]

The nice aspect of this model is that it eliminates any centralized control. The message flows straight through the set of queues – leaving out any potential bottleneck our saga implementation would introduce. Additionally, we don’t need to resort to things like pub-sub – since this would still force our steps to be aware of the overall order, hard-coding who is next in the chain. If a customer doesn’t toast their sandwich – it doesn’t go through the oven, but we know this up front! No need to have each step to know both what to do and what the next step is.

I put the message routing implementation up on [NuGet](http://nuget.org/packages/nservicebus.messagerouting) and [GitHub](https://github.com/jbogard/NServiceBus.MessageRouting), you just need to enable it on each endpoint via configuration:

[gist id=5469796]

If you need to process a message in a series of steps (known up front), and want to keep individual steps from knowing what’s next (or introduce a central controller), the routing slip pattern could be a good fit.