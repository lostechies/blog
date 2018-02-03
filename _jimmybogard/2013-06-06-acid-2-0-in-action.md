---
wordpress_id: 788
title: ACID 2.0 in action
date: 2013-06-06T14:23:27+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=788
dsq_thread_id:
  - "1369910969"
categories:
  - Messaging
  - SOA
---
One of the comments in my last post on [message idempotency](http://lostechies.com/jimmybogard/2013/06/03/un-reliability-in-messaging-idempotency-and-de-duplication/) asked about message ordering. This is part of a larger issue that I’ve run into recently around turning two-phase commits off.

When looking at mutating state through interactions, typically we take the approach of:

  1. Receiving messages to change state
  2. Applying state changes and discarding the message

Those in the event sourcing world see the problems of this – it’s really hard to reconstruct the series of activities that led to the current state when all you have is the final picture. You can make an educated guess on how we got here, but that’s it. We have to be crime scene detectives, imagining scenarios that led to our current situation.

It’s this central state that can become a bottleneck. If two people are trying to affect change to the same entity at the same time, how can we effectively allow this to happen? We can look at concurrency models (moving from pure ACID in a Serializable isolation to a relaxed, Snapshot isolation), but that is still a preventative mode.

What if we did away with the need to lock _anything_? This is where switching to a different mode of thinking. That’s where ACID 2.0 comes into play.

### ACID 2.0

ACID 2.0, explained in detail by [Hohpe](http://www.eaipatterns.com/ramblings/68_acid.html) and expanded on by [Helland](https://database.cs.wisc.edu/cidr/cidr2009/Paper_133.pdf), focuses on achieving high throughput by altering our data model Our data model now exhibits the following characteristics in its interactions:

  * A – Associative
  * C – Commutative
  * I – Idempotent
  * D – Distributed

For our system, we are little “d” distributed in that we have multiple processes handling requests, but not multiple nodes in our database. We’re still on a big relational box, but we have change our model slightly.

In our system, we process daily transactions from point-of-sale systems from a nationwide retail chain for a loyalty program. You buy things and earn points. If you earn a coupon, you are deducted points.

Originally, we modeled this system with a list of transactions and a single balance:

  * Spend $10, balance now $10
  * Spent $50, balance now $60
  * Spend $75, balance now $135. Hit threshold, give coupon, balance now $35

That works decently for a reasonable throughput. It tends to fall down with higher throughput, because any operation has to both record the item and update the balance. Issuing coupons is a rather expensive operation, further decreasing throughput. Order mattered, too, as we couldn’t let the running balance ever be “wrong”.

In order to achieve higher throughput, we simply needed to model our system differently. We instead modeled these interactions as a ledger:

<table cellspacing="0" cellpadding="2" width="309" border="1">
  <tr>
    <td valign="top" width="52">
      Txn ID
    </td>
    
    <td valign="top" width="68">
      Date
    </td>
    
    <td valign="top" width="91">
      Type
    </td>
    
    <td valign="top" width="96">
      Amt
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="52">
      1234
    </td>
    
    <td valign="top" width="68">
      2/1/2012
    </td>
    
    <td valign="top" width="91">
      Spend
    </td>
    
    <td valign="top" width="96">
      $10
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="52">
      4321
    </td>
    
    <td valign="top" width="68">
      2/2/2012
    </td>
    
    <td valign="top" width="91">
      Spend
    </td>
    
    <td valign="top" width="96">
      $50
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="52">
      5345
    </td>
    
    <td valign="top" width="68">
      2/10/2012
    </td>
    
    <td valign="top" width="91">
      Spend
    </td>
    
    <td valign="top" width="96">
      $75
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="52">
      0989
    </td>
    
    <td valign="top" width="68">
      2/11/2012
    </td>
    
    <td valign="top" width="91">
      Coupon
    </td>
    
    <td valign="top" width="96">
      ($100)
    </td>
  </tr>
</table>

We have two basic operations on our model: Spend and Coupon. One is a debit and one is a credit. The nice thing about the above model is it can easily fit in our ACID 2.0 constraints:

  * Associative & commutative – No matter what order we sum up the amounts, the final balance is the same
  * Idempotent – we only record a transaction if we know we haven’t seen that transaction ID before

In our original model, we would check the balance constantly to see if we needed to give out a coupon. In our new model, we separated that piece out into a separate process:

  * Process 1: Record transactions from yesterday
  * Process 2: On a periodic basis, search for accounts due a coupon, and give them one (by deducting the amount)

Because only a fraction of those daily transactions needed to get coupons, separating that piece out into a separate process ensured that the recording of spend went as fast as possible. It wouldn’t get slowed down by handing out coupons.

We did have to do work to ensure that we didn’t double-issue spend, so in those cases, we would employ various concurrency schemes to ensure that no two people were issuing coupons to the same ledger at the same time. Importantly, we didn’t care if someone was recording spend, since if we missed you this time, we’d get you the next time.

By slightly changing our modeling approach and thinking in terms of operations that could be applied in any order, we eliminated our original self-inflicted wounds of requiring ourselves to have always-consistent derived state (the balance). And in doing so, we saw our throughput shoot through the roof.