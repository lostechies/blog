---
wordpress_id: 472
title: Efficient transactional processing
date: 2011-04-22T13:12:43+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/04/22/efficient-transactional-processing/
dsq_thread_id:
  - "285935353"
categories:
  - Architecture
---
Ayende had a post on [how to handle race conditions and unbounded result sets](http://ayende.com/Blog/archive/2011/04/22/when-race-conditions-amp-unbounded-result-sets-are-actually-the-again.aspx), describing a problem where you needed to perform transactional work against a set of entities. A bad solution would be:

> <pre>var subscriptions = session.Query&lt;Subscription&gt;().Where(s=&gt;s.NextCharge &lt; DateTime.Now);
<span class="kwrd">foreach</span>(var sub <span class="kwrd">in</span> subscriptions)
{
   sub.ChargeAccount(); <span class="rem">// 1 sec</span>
}</pre>

We have a rule on our system. A query can return an entity if and only if it queries solely on that entity’s identifier. **Only one entity may be returned from a query at a time.**

If we need to display information just to search, but not act upon, we can use any number of projection options like AutoMapper, SQL views, SQL projections, LINQ projections, de-normalized view tables with CQRS and so on.

However, if we need to ACT upon that information, we ALWAYS project into some sort of message object. Something like:

> <pre>var subscriptions = session.Query&lt;Subscription&gt;()
    .Where(s=&gt;s.NextCharge &lt; DateTime.Now)
    .Project.To&lt;ChargeAccountMessage&gt;();

Bus.Send(subscriptions);
</pre>

That Project.To is just the [autoprojection to a DTO](https://lostechies.com/jimmybogard/2011/02/09/autoprojecting-linq-queries/) done at the SQL level. The object returned is a message that only includes the identifier, to be sent off for processing by message handlers (in my case, on the NServiceBus bus using MSMQ messages to 1 to N concurrent handlers).

In each handler, I’ll load up the aggregate root entity by its identifier, using whatever specific fetching strategy I need for that ONE entity and that ONE operation. I can then scale processing as much as I need to, and **decouple myself from the synchronous, serial processing the “foreach” loop saddles me to.**

Our rule of “Never ForEach on an Entity” lets us scale processing appropriately, handle failure conditions (like, what happens if the query returns 50K items and the 25Kth one fails), and constrain transactions to very tight windows, processing only one entity-operation per transaction

In the above case, I never even look at a parallel ForEach loop, because of needing to worry about failures. The query identifies which entities need work done to them, and no more. Another win for message-based architectures!