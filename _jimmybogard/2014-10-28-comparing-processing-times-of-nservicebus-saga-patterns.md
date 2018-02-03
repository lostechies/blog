---
wordpress_id: 965
title: Comparing processing times of NServiceBus saga patterns
date: 2014-10-28T17:16:42+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=965
dsq_thread_id:
  - "3165975225"
categories:
  - NServiceBus
---
A few weeks ago I gave a talk at [NSBCon NYC](https://skillsmatter.com/conferences/6223-nsbcon-nyc-2014) on scaling NServiceBus, and one of the pieces I highlighted were various saga/processing patterns and how they can affect performance. It was difficult to give real numbers as part of the discussion, mostly because how long it takes to do something is highly variable in the work being done and environmental constraints.

I compared three styles of performing a set of distributed work:

  * [Observer-style saga](http://lostechies.com/jimmybogard/2013/03/11/saga-implementation-patterns-observer/)
  * [Controller-style saga](http://lostechies.com/jimmybogard/2013/03/14/saga-implementation-patterns-controller/)
  * [Routing slip](http://lostechies.com/jimmybogard/2013/04/26/saga-alternatives-routing-slips/)

And highlighted the performance differences between them all. Andreas from the Particular team mentioned that some work had been done to improve saga performance, so I wanted to revisit my assumptions to see if the performance numbers still hold.

I wanted to look at a lot of messages – say, 10K, and measure two things:

  * How long it took for an individual item to complete
  * How long it took for the entire set of work to complete

Based on this, I built a prototype that consisted of a process of 4 distinct steps, and each variation of process control to track/control/observe progress. You can find the entire set of code on [my GitHub](https://github.com/jbogard/NSBPerf).

Here’s what I found:

<table cellspacing="0" cellpadding="2" width="374" border="0">
  <tr>
    <td valign="top" width="99">
      <strong>Process</strong>
    </td>
    
    <td valign="top" width="95">
      <strong>Total Time</strong>
    </td>
    
    <td valign="top" width="91">
      <strong>Average</strong>
    </td>
    
    <td valign="top" width="87">
      <strong>Median</strong>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="105">
      Observer
    </td>
    
    <td valign="top" width="100">
      6:28
    </td>
    
    <td valign="top" width="95">
      0.1 sec
    </td>
    
    <td valign="top" width="90">
      <0.1 sec
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="107">
      Controller
    </td>
    
    <td valign="top" width="100">
      6:25
    </td>
    
    <td valign="top" width="97">
      3:25
    </td>
    
    <td valign="top" width="91">
      3:37
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="108">
      Routing Slip
    </td>
    
    <td valign="top" width="99">
      2:57
    </td>
    
    <td valign="top" width="98">
      2.6 sec
    </td>
    
    <td valign="top" width="92">
      <0.1 sec
    </td>
  </tr>
</table>

Both the observer and controller styles took roughly the same total amount of time. This is mostly because they have to process the same total amount of messages. The observer took slightly longer in my tests, because the observer is more likely to get exceptions for trying to start the same saga twice. But once an item began in the observer, it finished very quickly.

On the controller side, because all messages get funneled to the same queue, adding more messages meant that each individual item of work would have to wait for all previous items to complete.

Finally, the routing slip took less than half the time, with higher total average but comparable median to the observer. On the routing slip side, what I found was that the process sped up over time as the individual steps “caught up” with the rate of incoming messages to start the process.

This was all on a single laptop, so no network hops needed to be made. In practice, we found that each additional network hop from a new message or a DB call for the saga entity added latency to the overall process. By eliminating network hops and optimizing the total flow, we’ve seen in production total processing times decrease by an order of magnitude based on the deployment topology.

This may not matter for small numbers of messages, but for many of my systems, we’ll have 100s of thousands to millions of messages dropped on our lap, all at once, every day. When you have this situation, more efficient processing patterns can alleviate pressure in completing the work to be processed.