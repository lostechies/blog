---
wordpress_id: 759
title: Scaling NServiceBus Sagas
date: 2013-03-26T13:57:28+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=759
dsq_thread_id:
  - "1165974967"
categories:
  - Messaging
  - NServiceBus
  - SOA
---
When looking at NServiceBus sagas ([process managers](http://www.eaipatterns.com/ProcessManager.html)), especially at high volume of messages, we often run into two main problems:

  * Deadlocks 
      * Starvation</ul> 
    This is because of the fundamental (default) design of sagas is that:
    
      * A single saga shares a single saga entity (causing deadlocks) 
          * All messages handled by a saga are delivered to the same endpoint (causing a bottleneck)</ul> 
        Two very different problems, with very different solutions. But, as per usual, we’ll look at how we might handle these situations in the real life to see how our virtual world should behave. Both of these problems (amongst others) are called out in the Enterprise Integration Patterns book, so it shouldn’t be a surprise if you run into these issues. Not as clear, however, is how to deal with them.
        
        ### Deadlocks
        
        Deadlocks in sagas are pretty easy to run into if we start pumping up the concurrency on our sagas. Back in our McDonald’s example, we published a message out and waited for all of the stations to report back:
        
        [<img title="image" style="border-left-width: 0px; border-right-width: 0px; background-image: none; border-bottom-width: 0px; padding-top: 0px; padding-left: 0px; display: inline; padding-right: 0px; border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2013/03/image_thumb7.png" width="471" height="407" />](http://lostechies.com/content/jimmybogard/uploads/2013/03/image7.png)
        
        In our restaurant, there’s only room for one person to examine a single tray at a time. When someone finishes a food item, they have to go look at all the trays. But what if someone is putting food on my tray? Do I push them out of the way?
        
        Probably not, I need to wait for them to finish. It turns out that this is what happens in our sagas – we can only really allow one person at a time to affect a saga instance. The way NServiceBus can handle this by default is by adjusting the isolation level for Serializable transactions. This ensures that only one person looks at a tray at any given time.
        
        What we don’t want to have happen is the fries person look at the tray, see a missing sandwich, and decide that the order isn’t done. The sandwich person does the same thing in reverse – look at the tray, see missing fries, and decide the order isn’t done.
        
        It turns out that our Serializable isolation level has unintended consequences – we might lock more trays (or ALL of the trays) unintentionally. If there are more than one message that can start our saga, then effectively every employee has to look at all the trays to see if our tray is already on the counter, or we’re the first one and need to put a new one out. But if someone is also doing the same thing – multiple trays for the same order might go out!
        
        We don’t want to block the entire counter for our order, so we can adjust our scheme slightly. If we implement a simple versioning scheme, we can simply have the employees look at a version number on the receipt, make their changes, and bump the version number with a little tally mark. If the tally mark has gone up since we last looked at the tray, we’ll just re-do our work – something has changed, so let’s reevaluate our decisions.
        
        To get around the problem of too many trays for the same order, we can rely on a third party to ensure we don’t have too many trays. If when anyone places a tray down, the supervisor enforces this rule that only one tray per order can exist, they’ll ask us to put our tray back up and redo our work.
        
        Two things we want to do then:
        
          * Introduce a unique constraint on the correlation identifier to prevent duplicates 
              * Use optimistic concurrency to allow us to isolate just our own tray (and not affect anyone else)</ul> 
            This is a rather straightforward fix – and in fact, NServiceBus defaults to using optimistic concurrency in 4.0 (now in beta). This was a rather easy fix, but what about our other problem of the bottleneck?
            
            ### Starvation and bottlenecks
            
            Back in my early days of school, I worked at a fast food restaurant during breaks (surprise, surprise). I worked the graveyard shift of a 24-hour burger joint, and it was just me and one other person manning the entire place. From 10PM to 6AM, just two of us.
            
            One thing that I found pretty early was that we had quite a few “regulars”. These were folks that every morning, came in and ordered the same thing at around the same time. Because it was quite early, they could rely on little to no contention for resources, and the queue was more or less empty.
            
            Most of the time.
            
            But every once in a while, we would get someone ordering food for a large group of people. We didn’t do catering, but we did sell breakfast tacos. Handling one or two at a time wasn’t a problem, but someone coming in and ordering 50 tacos – that’s a problem. Our process looked something like this:
            
            [<img title="image" style="border-left-width: 0px; border-right-width: 0px; background-image: none; border-bottom-width: 0px; padding-top: 0px; padding-left: 0px; display: inline; padding-right: 0px; border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2013/03/image_thumb8.png" width="607" height="257" />](http://lostechies.com/content/jimmybogard/uploads/2013/03/image8.png)
            
            The problem was, because there were only two of us, most messages flowed through exactly one channel. In NServiceBus Sagas, this is what happens as well – all messages for a saga are delivered to a single endpoint. We might have the situation like this:
            
            <table cellspacing="0" cellpadding="2" width="133" border="1">
              <tr>
                <td valign="top" width="131">
                  <strong>Saga Queue</strong>
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Prep Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Prep Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Prep Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Prep Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Prep Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Prep Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Prep Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Prep Pancakes – #2
                </td>
              </tr>
            </table>
            
            My cook has dozens of tacos to go through before getting to that second order, and because that person packs all the food _and_ preps all the food, all items from the first order must be both prepped and packed before order #2 is complete:
            
            <table cellspacing="0" cellpadding="2" width="133" border="1">
              <tr>
                <td valign="top" width="131">
                  <strong>Saga Queue</strong>
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Pack Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Pack Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Pack Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Pack Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Pack Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Pack Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Pack Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Pack Pancakes – #2
                </td>
              </tr>
            </table>
            
            That’s not a huge problem, except we have both packing and prepping done by a single person. Another order comes in, the prepping for that one interferes with the others. Additionally, items are sitting in the saga queue waiting to get packed while prepping finishes.
            
            In many NServiceBus sagas, the sagas themselves don’t perform the actual work. They’re instead the controllers/coordinators, making decisions about next steps. But all the messages are delivered to the exact same queue, effectively creating a bottleneck. I’m waiting for _all_ prepping to be done before moving on to _any_ packing. The time it takes to this entire set of orders is basically the time it takes to prep all items plus the time it takes to pack all items.
            
            The problem is our saga is modeled rather strangely. In the real world, long-running business processes, split into multiple activities/steps, are performed many times by different people. Effectively, different channels/endpoints/queues. But our saga shoved everyone back into one queue!
            
            What we did in our taco tragedy above was that I came off the line from taking orders and performed the prep stage. For N items, we took a total time of N+1 or so. We had two queues going for the one saga:
            
            <table cellspacing="0" cellpadding="2" width="133" border="1">
              <tr>
                <td valign="top" width="131">
                  <strong>Prep Queue</strong>
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Prep Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Prep Pancakes – #2
                </td>
              </tr>
            </table>
            
            <table cellspacing="0" cellpadding="2" width="133" border="1">
              <tr>
                <td valign="top" width="131">
                  <strong>Pack Queue</strong>
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Pack Taco – #1
                </td>
              </tr>
              
              <tr>
                <td valign="top" width="131">
                  Pack Taco – #1
                </td>
              </tr>
            </table>
            
            The total number of items in the Pack queue was always small – packing was easy and quick. By splitting the saga handling into separate queues, we ensured that an overload in one type of message didn’t choke out all the others. This isn’t the default way of managing long-running processes in NServiceBus though, we have to set this up ourselves.
            
            When dealing with the Process Manager pattern, it’s important to keep in mind what this pattern brings to the table. We’re able to support complex message flow, but at the price of potential bottlenecks and deadlocks.
            
            Next time – a better pattern for linear processes that doesn’t bring in deadlocks and bottlenecks, the routing slip pattern.