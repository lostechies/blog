---
wordpress_id: 778
title: 'Saga patterns: wrap up'
date: 2013-05-14T14:08:29+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=778
dsq_thread_id:
  - "1287829077"
categories:
  - Messaging
  - NServiceBus
---
Posts in this series:

  * [Observer pattern](https://lostechies.com/jimmybogard/2013/03/11/saga-implementation-patterns-observer/)
  * [Controller pattern](https://lostechies.com/jimmybogard/2013/03/14/saga-implementation-patterns-controller/)
  * [Pattern variations](https://lostechies.com/jimmybogard/2013/03/21/saga-implementation-patterns-variations/)
  * [Scaling sagas](https://lostechies.com/jimmybogard/2013/03/26/scaling-nservicebus-sagas/)
  * [Routing slips](https://lostechies.com/jimmybogard/2013/04/26/saga-alternatives-routing-slips/)

NServiceBus sagas are a simple yet flexible tool to achieve a variety of end goals. Whether it’s orchestration, choreography, business activity monitoring, or just other long-running business transaction variants, the uses of an NServiceBus saga are pretty much endless.

When choosing to go with a centralized workflow, we also saw that there is a cost to centralization with the introduction of a bottleneck. With the routing slip pattern, we can include instructions with our message in a header so that each recipient only needs to reference the attached instructions. In a routing slip, flow is linear, but there’s nothing stopping us from including more advanced instructions for state machines, compensations and so on.

I tend to think of the NServiceBus saga as more of a facility, than a specific pattern, because it doesn’t force us to go in any one direction. Rather than assume a specific role or function for a saga, I like to keep things a bit more flexible, and choose one of the many [conversation](http://www.eaipatterns.com/docs/IEEE_IC_Conversations.pdf)/[messaging](http://www.eaipatterns.com/) patterns available for each given scenario.

In the end, sagas are a useful tool (and one that can be over-used, not every workflow deserves central management), but a nice one to have. Every time I introduce NServiceBus sagas to folks that spent time with other messaging tools, whether it’s big orchestration with ESBs or bare-metal messaging tools, the simplicity and code-centric nature of NServiceBus sagas either excites or depresses, depending on the possibility of switching or introducing new tools.