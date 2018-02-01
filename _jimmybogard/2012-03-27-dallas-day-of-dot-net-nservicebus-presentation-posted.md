---
id: 605
title: Dallas Day of Dot Net NServiceBus presentation posted
date: 2012-03-27T14:18:08+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2012/03/27/dallas-day-of-dot-net-nservicebus-presentation-posted/
dsq_thread_id:
  - "625908440"
categories:
  - NServiceBus
---
About a week ago or so I presented at [Dallas Day of .NET](http://www.dallasdayofdotnet.com/) on Keeping Integration Sane with [NServiceBus](http://www.nservicebus.com/). I talked about the three main ways I’ve had to integrate with other systems I don’t control, including:

  * Sending files
  * Receiving files
  * Web services

And how each of those ways of integrating can be rife with failures. I walked through a scenario of using an [NServiceBus Saga](http://www.nservicebus.com/sagas.aspx) to help manage a process that communicates with multiple web services that each depend on each other. The code and slides can be found on my github here:

<https://github.com/jbogard/presentations>

Check it out!