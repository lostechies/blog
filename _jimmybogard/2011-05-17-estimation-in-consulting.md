---
wordpress_id: 489
title: Estimation in consulting
date: 2011-05-17T13:16:59+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/05/17/estimation-in-consulting/
dsq_thread_id:
  - "306024655"
categories:
  - Agile
---
Some of our big early agile projects in consulting gave us quite a big perspective in what works well in estimation techniques in our consulting business, and what doesn’t. We already [ditched the group estimation techniques of planning poker](https://lostechies.com/jimmybogard/2011/05/10/ditching-planning-poker/), finding the time to be largely a waste and its only benefits (group design, etc.) to be better served with other, more targeted activities. But what we kept for a while was exposing our estimations of sizing to the customer.

Regardless if we did sprints or not, we would show the customer the estimated cost of stories:

  * Story 438 – 13 points
  * Story 34 – 8 points
  * Story 424 – 5 points
  * Story 453 – 13 points

This led to quite a bit of back and forth with the customer with the question of “what the heck is a point?!?!?” The customer wants to know how much a feature is likely to cost. But **a point is a measure of complexity, not effort**. Talking about estimated effort is a completely different conversation.

Our customers don’t write checks in points. They write checks in dollars. For a customer to make an educated decision on priority etc. they need to have an understanding on how much a feature is likely to cost them, in a term that actually makes sense to them.

### Transitioning to hours

Nearly all of our contracts these days are structured as time & materials. We bill hourly, and work in mutual risk plans in our contracts with things like escape clauses for the client and so on. We like to compare our inventory to the fish market. In a fish market, any fish not sold at the end of the day is trashed, waste. Any hour we don’t sell to a client is (potential) waste. Ultimately, our inventory is hours, and that’s what we sell to clients.

Coming back to estimation, cost in points caused nothing but confusion and frustration with client after client. So, we ditched estimating cost in points. It’s still extremely important to set cost expectations with a client. No one likes to take their car in for a brake check and see a bill on the other side for $3000. As long as we’re upfront about uncertainty and risk, **it’s critical to set proper expectations on how much a feature will cost, in actual dollars**. And as long as features/stories follow the [INVEST](http://en.wikipedia.org/wiki/INVEST_(mnemonic)) guidelines, we can reduce the risk of missing the target.

By including all activities in our story flow boards, we include all activities in getting a story to production when estimating cost, such as:

  * Feature Analysis
  * System Analysis (for existing systems)
  * Modeling
  * Design
  * Development
  * Testing
  * Stabilization
  * Deployment

Hands on the keyboard typing are merely one phase of a story’s lifecycle, but all the other phases include time, effort, manpower and ultimately money. These phases add value and are part of delivering a story, so we include all these in our estimates. To keep with the spirit of our Fibonacci story sizes, we followed powers of 2 in our cost estimates:

  * 1 hour
  * 2 hours
  * 4 hours
  * 1 day
  * 2 days
  * 3 days

This would be in each of the areas of effort for delivering a story:

<table border="1" cellspacing="0" cellpadding="2" width="200">
  <tr>
    <td width="100" valign="top">
      Feature Analysis
    </td>
    
    <td width="100" valign="top">
      2 hours
    </td>
  </tr>
  
  <tr>
    <td width="100" valign="top">
      System Analysis
    </td>
    
    <td width="100" valign="top">
      8 hours
    </td>
  </tr>
  
  <tr>
    <td width="100" valign="top">
      Modeling
    </td>
    
    <td width="100" valign="top">
      4 hours
    </td>
  </tr>
  
  <tr>
    <td width="100" valign="top">
      Design
    </td>
    
    <td width="100" valign="top">
      4 hours
    </td>
  </tr>
  
  <tr>
    <td width="100" valign="top">
      Development
    </td>
    
    <td width="100" valign="top">
      2 days
    </td>
  </tr>
  
  <tr>
    <td width="100" valign="top">
      Testing
    </td>
    
    <td width="100" valign="top">
      2 hours
    </td>
  </tr>
  
  <tr>
    <td width="100" valign="top">
      Deployment
    </td>
    
    <td width="100" valign="top">
      1 hour
    </td>
  </tr>
  
  <tr>
    <td width="100" valign="top">
      Total
    </td>
    
    <td width="100" valign="top">
      37 hours
    </td>
  </tr>
</table>

This total cost would be labeled something like “optimistic cost estimate” or “unrealistic cost estimate”, to convey that there is still uncertainty. Then, depending on the client, system, environment and past history, we’d have an uncertainty percentage, ranging from something like 10% to 50%. This is all about factoring variance of the final costs of stories. Some projects have wildly varying costs from the original estimate, some don’t. We’d then include this in our cost estimate of a story:

<table border="1" cellspacing="0" cellpadding="2" width="200">
  <tr>
    <td width="100" valign="top">
      Unrealistic Estimate
    </td>
    
    <td width="100" valign="top">
      37 hours
    </td>
  </tr>
  
  <tr>
    <td width="100" valign="top">
      Risk factor
    </td>
    
    <td width="100" valign="top">
      25%
    </td>
  </tr>
  
  <tr>
    <td width="100" valign="top">
      Realistic Estimate
    </td>
    
    <td width="100" valign="top">
      46.25 hours
    </td>
  </tr>
</table>

We can then track to see based on each story how close we are to the varying estimates, and make adjustments to our risk factors as necessary. The tech lead/principal (who is also a developer) provides these estimates to the customer, and it’s usually a starting point on discussions of priority, complexity and so on.

### All about communication

In consulting, we sell hours of time. For a customer to make an informed decision on choosing stories, managing complexity and budget, they have to have a realistic expectation of cost. While story points are good at estimating complexity, they aren’t good at cost. Instead, we adapted our story estimation techniques to our delivery models to come up with a solution that our customers actually undertand. They may not like our estimates, but we’ve at least set the proper expectations against a number that actually makes sense to someone signing a check.