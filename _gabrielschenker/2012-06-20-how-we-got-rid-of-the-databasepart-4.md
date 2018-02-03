---
wordpress_id: 128
title: How we got rid of the database–part 4
date: 2012-06-20T21:31:33+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/2012/06/20/how-we-got-rid-of-the-databasepart-4/
dsq_thread_id:
  - "734825612"
categories:
  - CQRS
  - Event sourcing
  - no-database
---
This is the fourth episode of a series of posts about how we do CQRS and event sourcing. To my (positive) surprise the first three parts ([part 1](http://lostechies.com/gabrielschenker/2012/06/12/how-we-got-rid-of-the-database/), [part 2](http://lostechies.com/gabrielschenker/2012/06/13/how-we-got-rid-of-the-databasepart-2/), [part3](http://lostechies.com/gabrielschenker/2012/06/18/how-we-got-rid-of-the-databasepart-3/)) have caused quite some discussion amongst the readers. Since I constantly have discussions about the very same topics with my team members and external co-workers I decided to dedicate this fourth part to answer some of those topics.

# Eventual consistency

Full consistency (also called [immediate consistency](http://en.wikipedia.org/wiki/Immediate_consistency)) is overrated, period!

When I have some doubt about whether something “is right” or “can possibly work” then I try to find analogies in the real world. And it turns out that when looking for analogies in the business world where [eventual consistency](http://en.wikipedia.org/wiki/Eventual_consistency) applies then we find those everywhere! Even in scenarios which are &#8220;business-critical” or “life-threatening”. But then if real world works in an eventual consistent way, why are we tying to achieve full consistency at all cost in our [LOB](http://en.wikipedia.org/wiki/Line_of_business) applications?

Let me give some real world samples of eventual consistency:

  * you are ordering a book at an online book store. After you have checked out and your payment by credit card has been accepted the application tells you that your order has been placed and will be shipped asap. At the moment you receive the confirmation the online store has not yet reserved the book for you nor is it guaranteed that this very book is on stock and if not that it is still available from the publisher. It some times happens that the book is not on stock and thus the delivery is delayed. In this case the online shop will notify you by sending an email. If the book is not available any more then the shop might offer you alternatives and compensate you with a special bonus.
  * The unit price of some share traded at the stock exchange changes. This change in price is appearing on the stock tickers only with a certain (short?) delay; maybe a couple of seconds or even minutes.
  * You order a coffee at your local coffee shop. The cashier forwards your order to the barista immediately and then takes your credit card to check out. To check the credit card and approve the payment might take a while. In the mean time the barista has already started to brew your coffee. It turns out that your credit card is invalid and you have no alternative payment method. The coffee cannot be undone and as a “compensating action” the barista gets the order to throw the coffee away.
  * A terrible accident happens. You call 911 and explain that there is a person having life threatening injuries. The person answering the call promises that EMS and fire fighters will be there as quickly as they can. At the moment you end the call the fire fighters and EMS have not yet been sent on their way nor are any surgeons put on hold that will take care of the injured person. All this is organized asynchronously. When the injured person finally arrives at the hospital he gets treated as soon as a team&nbsp; of surgeons/doctors is available. The patient might even have to wait for some time if no doctor is available.

All these samples are not made up by me but are very real and happen daily! Thus I can assure you that we can develop applications that are eventual consistent and at the same time happily fulfill all business requirements. We just need to address the problem a little bit different. A recommendation is to design your application in a task oriented way. Each task should be very focused and well defined. Avoid having “fluffy” or vague use cases.

# After a successful transaction I need to refresh/reload the screen

With CQRS and ES this is not possible since the read model is only eventually consistent with the domain model. The delay can be very short (a couple of milliseconds) or quite long (seconds to minutes) depending on the type of transaction. 

But this is not a problem! Why not?

We design our application in a way that commands sent to the domain model have a high probability to succeed. This can be achieved by e.g. pre-validating the commands prior to sending them to the corresponding aggregate of the domain model. Assuming now that the command succeeds we can update the screen to reflect the new state without reloading everything from the database/data source. We already have all the necessary data at hand, otherwise we would not have been able to create and send the command in the first place. As a sample: if we send the command “PublishTask” to the domain model and the domain model sends back an ACK then we can set the status of the corresponding task on the screen to “published” without querying the database.

But what about if it takes a long time (seconds to minutes) until the read model is in sync with the domain model after a transaction has been executed?

In this case it is often the case that the person that triggers the transaction is not the same person/user that needs to see the result of the transaction (other than it has been completed successfully). As a sample take again our online book store. The manager decides to reduce the unit price of all books in stock by 10% to better compete with the competitors. Now who is most interested to see those changes in price? It is not the manager since he knows what he has just done. He does not have to browse through the list of all books to have a confirmation of the change. But the clients of course benefit from this price reduction. But it doesn’t matter if the price change is only reflected in the online catalog minutes after the manager has executed the price reduction.

# Why not use a database for the event store or the read model

Well, first of all, please read the title of my series of blog posts: “How we got rid of the database”. This series is not only about the theory behind CQRS and event sourcing but also about the concrete application of an architecture based on CQRS/ES as well as our goal to reduce the overall complexity of the system. If we can achieve our goals with simpler means why not do it. Why shouldn’t we strive for simplicity when solving problems and achieving solutions?

It turned out that we did not leverage nor need all the features an RDBMS a la Oracle or SQL Server could offer. It was as if I took a truck when a bicycle would be sufficient or search for a calculator to calculate 5 + 5, instead of using my brain.

What we need when doing CQRS is 

  * in the domain model: an efficient way to access a stream of events identified by the unique ID or the aggregate instance which produced the events.  
    Solution –> we serialize all events as they occur into an append only file whose full name is a codified version of the ID.
  * in the read model: an efficient way of accessing (denormalized) instances (=the current state) of view models by their respective unique ID in addition to (secondary) indices that are e.g. serialized hash tables (or dictionaries). _I will talk more about indices in a future post._

All that and more can be easily achieved by avoiding any database (relational or document) and just using some simple code that can read and (atomically) write single files.

# How can we enforce referential integrity?

We cannot, at least not at the data level!

Integrity of data is solely guaranteed by our application. It is the responsibility of the application to maintain integrity and consistency of the data. 

One important aspect in this regard is that we eliminate the concept of “delete” from our vocabulary (I know, I know, there are always exceptions…). In the business world the concept of “delete” does not exists

  * we do not delete an employee but rather release him
  * we do not delete an order but rather cancel it
  * we do not delete a coffee in a coffee shop but rather discard it (the ingredients have already been used)
  * an accountant does not delete a wrong journal entry but rather compensates it with a journal correction

If ever we have to “delete” an item we do not physically delete it but mark it “as deleted”.

But if we never physically delete anything from our data store we do not run into problems like “orphaned children” or “missing references”.

As an added benefit we are better prepared for any audit, since no data is ever lost.

# What about backup?

We only ever need to make sure that our event store is backed up. We really(!) don’t care about the read model since it can always be rebuilt from the event store in case of catastrophic failure. And if this is not sufficient, we can always create the read model redundant; we just send the events (which are used to build the projections) to at least two different servers.

The event store on the other hand is just a folder full of files and can be backed up by any decent backup program out in the market. No special and expensive software needed!