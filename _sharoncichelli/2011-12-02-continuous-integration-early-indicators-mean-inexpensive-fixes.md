---
id: 175
title: 'Continuous Integration: Early indicators mean inexpensive fixes'
date: 2011-12-02T16:27:07+00:00
author: Sharon Cichelli
layout: post
guid: http://lostechies.com/sharoncichelli/?p=175
dsq_thread_id:
  - "1001969836"
categories:
  - Agile
  - Unit Testing
tags:
  - Continuous Integration
---
Earlier this year, I bought a car&mdash;my first _new_ car. Although it fills me with sanctimonious hybrid glee (it really does), it&#8217;s making me neurotic with instrument panel indicator lights. The low-tire-pressure indicator after the weather turned cold. The insistent exclamation point from the airbag computer in my seat. The glaring amber beacon from the Integrated Motor Assist battery. I&#8217;ve never had so many things go wrong with a car!

Or have I?

Incorporating automated tests into your Continuous Integration build process can feel similar. You&#8217;re suddenly presented with all these errors. Your product seems to be broken all the time. You liked it better when things were quiet and you didn&#8217;t know how bad it was.

There are two reasons I&#8217;m getting so many warnings from my car: It has more systems, more features, more _computers_ than any car I&#8217;ve owned before; and it has more health sensors and warning lights. It&#8217;s better at knowing when it&#8217;s a little unhappy, and better at letting me know. I take care of these little maintenance tasks, and all is well. It never reaches the big, blow-up, throw-a-rod, leave-you-stranded, heartache-on-the-interstate meltdown that results from years of indifferent neglect.

Continuously run unit tests are an army of little health sensors. CI feels painful at first, but it pays off quickly. When the system under test wavers, even minutely, the tests catch it promptly and summon your attention while it is still a small, containable, inexpensive problem. (Provided they&#8217;re running frequently. Once a day is pretty infrequent. Strive to make them fast enough that you&#8217;re willing to run them every time you commit to source control.) Continuous Integration tests keep your problems on the scale of oil changes and tire pressure, instead of engine blocks and radiators.