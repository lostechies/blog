---
id: 1017
title: Event sourcing revisited
date: 2015-05-26T21:42:06+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1017
dsq_thread_id:
  - "3796629719"
categories:
  - Architecture
  - DDD
  - Design
  - Event sourcing
  - How To
---
Event Sourcing (ES) over the last few years has become one of my favorite architectural patterns when implementing a complex line of business (LOB) application or a complex component making part of a LOB application.

## Attention &#8211; paradigm change!

It took me some time thought to make the full mental switch that is required to really understand what ES is an what its implications are. I openly admit that the first two iterations I was responsible for were sub-optimal to say the least. But then, to fail is not a problem as long as we learn from our failures and do better next time.
  
Interestingly the theory behind ES seems to be really easy to understand. A lot of developers I have personally taught or mentored quickly assured me that &#8220;they got it&#8221; when in reality they still remained very much afflicted with the classical stateful thinking.

## The classical, stateful world

In the classical main-stream architecture the applications we design and build are stateful. What does that mean? This means that we always store a snapshot of the objects we deal with in our application in a data store. The snapshot represents the state the object was/is after the last modification. We continuously overwrite the previous state or snapshot with the newest version in the data store. For simple applications this might be more than sufficient since we are not really interested in what was before and how we did get to the point we currently are. Such applications are only interested in the here and now.

Let me give you a sample of what I am talking about: Let&#8217;s assume that John Doe has a bank account. Today he wants to know what the current balance of his account is. With the mobile app of his bank he can access this information and finds that the balance is $2535.45 as of today. A week later John wants to again know the newest balance and he&#8217;s told that now the balance is $5455.10. John is very happy that he has now more money on his account than a week before. John is an easy going man and doesn&#8217;t worry too much about details as long as the big picture looks OK, and in this case since the balance is clearly positive, he&#8217;s satisfied.

## We want more insight

Laura, John&#8217;s wife on the other hand is a little bit more worried and wants to know more details. She&#8217;s interested in how it comes that in only one week the balance of their account changed so much. Thus she drills into the details and sees the following

<table>
  <tr>
    <th>
      Date
    </th>
    
    <th>
      Description
    </th>
    
    <th>
      Debit
    </th>
    
    <th>
      Credit
    </th>
    
    <th>
      Balance
    </th>
  </tr>
  
  <tr>
    <td>
      05/01/2015
    </td>
    
    <td>
      HEB Round Rock
    </td>
    
    <td>
      125.24
    </td>
    
    <td>
    </td>
    
    <td>
      5455.10
    </td>
  </tr>
  
  <tr>
    <td>
      05/02/2015
    </td>
    
    <td>
      Loewe Hutto
    </td>
    
    <td>
      25.00
    </td>
    
    <td>
    </td>
    
    <td>
      5430.10
    </td>
  </tr>
  
  <tr>
    <td>
      05/03/2015
    </td>
    
    <td>
      Check #181
    </td>
    
    <td>
      335.00
    </td>
    
    <td>
    </td>
    
    <td>
      5095.10
    </td>
  </tr>
  
  <tr>
    <td>
      05/03/2015
    </td>
    
    <td>
      Payroll &#8230;
    </td>
    
    <td>
    </td>
    
    <td>
       3145.25
    </td>
    
    <td>
      8240.35
    </td>
  </tr>
  
  <tr>
    <td>
      &#8230;
    </td>
    
    <td>
      &#8230;
    </td>
    
    <td>
       &#8230;
    </td>
    
    <td>
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      05/26/2015
    </td>
    
    <td>
      Fire Bowl Cafe
    </td>
    
    <td>
       9.20
    </td>
    
    <td>
    </td>
    
    <td>
      2696.35
    </td>
  </tr>
</table>

This is the list of transactions executed on the account. It carefully and in detail lists each change that has been applied to the account. We can easily see where the account has been credited and where it has been debited and when it happened and what was the reason of the change. This is a journal of financial transactions. We can call each line of this journal an **event** that happened. Each event telling us what has happened to the account at a specific date and/or time.

When we look at the above table then we see that the we have a stream of events that when applied to the account will result in the balance of $2696.35 as of today 05/26/2015. While John Doe is only interested in this last number his wife knows so much more now. She can reason about all the events that happened during the current month. At any time can she ask questions (and get answers for them) like: &#8220;what was the balance 10 days ago?&#8221; or &#8220;why it comes that the balance increased dramatically on May 3rd?&#8221; and &#8220;how much did we spend at HEB this month?&#8221;.

Exactly this kind of deeper insight can be provided to users of an application that uses event sourcing as an architectural pattern. Instead of storing the current state of &#8220;things&#8221; in the data store we store for each object a stream of events which represent what happened to this particular object over time. Having this stream of events somewhere persisted we can then go and replay it such as that we can generate the state of the respective object as of today or as of yesterday or a week ago, or&#8230; The possibilities are endless.

## Events are immutable

Another very interesting fact is that events that have happened are immutable. An event describes something that happened in the past and thus cannot be undone. Consequently the storage mechanism that we use to persist our events becomes very simple. It is basically a stack. We continuously append new events on top of the stack. Existing events are never touched again. No update or delete operation is defined, only add operations are ever possible.

## Mistakes always happen

If for some reason we made a mistake and added a wrong entry to our transaction log then we can fix this by adding another compensating transaction. That is, I credit the say $24 back to the account that I had previously debited by mistake.

## Names are important

When we use event sourcing in a LOB application then we give our events meaningful names. The name of the event describes the exact context. Since an event describes what has happened in the past the name should always be in written in past tense with the verb at the end.

The payload of the event (its properties) are the delta of what has changed.

## Another sample

If we work with the same domain as in my previous posts about DDD (see [here](https://lostechies.com/gabrielschenker/2015/04/16/ddd-revisited/ "DDD revisited"), [here](https://lostechies.com/gabrielschenker/2015/04/28/ddd-applied/ "DDD applied"), [here](https://lostechies.com/gabrielschenker/2015/05/07/ddd-special-scenarios-part-1/ "DDD – Special scenarios, part 1"), [here](https://lostechies.com/gabrielschenker/2015/05/11/ddd-special-scenarios-part-2/ "DDD – Special scenarios, part 2") and [here](https://lostechies.com/gabrielschenker/2015/05/25/ddd-the-aggregate/ "DDD – The aggregate")) &#8211; the loan application &#8211; we could have events such as

  * ApplicationStarted
  * PersonalInfosApplied
  * FinancialInfosApplied
  * ApplicationSubmitted
  * OffersGenerated
  * OfferAccepted
  * ApplicationApproved
  * LoanBoarded
  * etc.

From the chosen names it should be pretty evident what in each step happened to and with the loan application object. A new loan application is started by the user. She first provides her personal infos then continues to provide some additional financial infos. Finally she submits the application. The system then generates some loan offers for her. The user then selects on offer and accepts it. The system will do some more credit checks and finally approves the loan application. Now the loan can be boarded which means that the funds are transferred to the user&#8217;s account.

In our data store we will now find such a stream of events for each loan application that has been made over time. There will be no LoanApplication table or similar needed.

## The read model

Now this is all straight forward and relatively easy to implement. But what about queries? So far we have talked about operations that change object. I call this the write side. But a normal LOB application also needs to have a read side which is represented by the queries that are executed on the data to display something on the screen or print it out to paper. A data store for events &#8211; called an **event store** &#8211; is not at all suited for (complex) queries. For this reason we need a store which contains the data in a shape that best suits our needs for display. We call this store the read model. True to the spirit of CQRS read concerns should be handled totally separated from write concerns.

The read model is in most cases a denormalized view of the current state of objects. It can be provided by a relational database, a document database or a full text index to name just a few. The read model is constantly updated using the events that are generated by the system as discussed above. This constant updating of the read model can either happen synchronously or asynchronously. In the latter case we say that the read model is eventual consistent with the write model since there is a tiny time gap (usually milliseconds) between the moment where the write model records a change and the moment where the read model has been updated with that change too.

The read model should be designed in a way that all necessary queries triggered by the application can be executed with the least amount of I/O operations possible. The query logic should be as simple as possible. Data should be pre-aggregated where needed, etc.

It is important to not that the read model is pre-prepared for queries. The update of the read model happens when something in the system changes which in turn is represented by the events. This makes totally sense since write operations that cause a change are much much less frequent in a typical LOB application than read operations.