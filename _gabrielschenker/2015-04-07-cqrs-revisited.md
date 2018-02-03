---
wordpress_id: 903
title: CQRS revisited
date: 2015-04-07T17:19:00+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=903
dsq_thread_id:
  - "3663283150"
categories:
  - Architecture
  - CQRS
  - How To
  - learning
  - Patterns
---
## Introduction

In my opinion Command Query Responsibility Segregation (CQRS) is one of the most useful architectural patterns when used in the context of a complex line of business application (LOB). Martin Fowler [writes](http://martinfowler.com/bliki/CQRS.html)

> … At its heart is a simple notion that you can use a different model to update information than the model you use to read information.

## <span>Observations</span>

<span>A lot of today’s applications are unnecessarily complex or slow since they do not use CQRS. This is a high level of a typical application</span>

[<img class="alignnone size-full wp-image-906" title="Old architecture" src="https://lostechies.com/gabrielschenker/files/2015/04/Old-architecture1.png" alt="" width="881" height="190" />](https://lostechies.com/gabrielschenker/files/2015/04/Old-architecture1.png)

<span>All read and write operations are handled by a domain model in the backend. Often this domain model is very anemic and consists mainly of entities that are pure data containers (DTOs) and some services that manipulate those entities. Sometimes the repository pattern is used to abstract the data store from the domain’s perspective. In this case we might see repository interfaces that look similar to this</span>

<span>[gist id=0124e9645ec2b2cf7d1e]</span>

<span>We can see that in the same interface we have both methods that query data and methods that change data. And this is a problem! Reading or querying data is a fundamentally different concern than changing data. As such we should keep these two types of operations separate from each other. There are various reasons for that</span>

  * <span>Reading data usually happens much more frequently than writing data. In many applications the frequency of reading versus writing is easily 10 to 1 or even 100 to 1.</span>
  * <span>When reading data we usually want to retrieve quite a bit of data. It can be a list of records or a record with associated data records, e.g. a customer with a list of all her orders and her shipping and billing addresses, etc.</span>
  * <span>Read operations do not change data they rather provide a glimpse into a snapshot of the current state to the observer. Repeating the same read operation over and over again should always return the same result.</span>
  * <span>On the other hand write operations typically only affect a very small set of data. Most often one single data record is affected by a write operation and even there only a few properties of the overall data record are changed.</span>
  * <span>Write operations change the state of the system thus they have side effects. The world looks different before and after a write operation.</span>
  * <span>Read operations need to be fast. A user is easily frustrated if a query takes more than half a second or so.</span>
  * <span>Users are much more tolerant when it comes to write operations. They know that something important happens in the system and thus tolerate longer response times.</span>

## Lesson learned

When looking at all these points mentioned above we can learn quite a bit and do a better job in our applications.

### Reading data

Since read operations need to be fast we should make sure that

  * data can be accessed in way that needs the least amount of DB queries possible for the specific context
  * no (complex) business logic needs to be executed while retrieving the data. Business logic should only be executed when the application tries to modify data.
  * aggregated data should not be calculated/aggregated on the fly when querying the data but should be pre-calculated. This can happen whenever data is changed that affects the aggregated values, which is rather rare compared to read operations, as stated above.

Read operations can never change any data! Read operations need to be side-effect free.

### Writing data

As we have discussed above write operations typically only affect a very limited set of data. Let’s say we have an operation “add product XYZ to shopping cart” in an e-commerce application. In this operation we add an item to the shopping cart object consisting of product number and quantity. The shopping cart itself is identified by a shopping cart Id. Thus the command that we send to the backend might look like this

[gist id=e5b7f8cc517812718b62]

As we can see although the operation is a very important one only a very limited set of data is sent to the back-end for processing. Note that the name of the command gives the context of the operation whilst the payload of the command only contains the minimal amount of information needed to successfully fulfill the requested operation.

Since we are now clearly distinguishing read and write operations the command does NOT return any data other than maybe a status message telling the sender whether or not the operation has succeeded and possibly some error messages (which can be displayed to the user) if the command has failed since some business rules were violated.

## <span>Implementations</span>

In our new world where read and write operations are separated a high level diagram of an application looks like this

[<img class="alignnone size-full wp-image-907" title="CQRS based architecture" src="https://lostechies.com/gabrielschenker/files/2015/04/CQRS-based-architecture.png" alt="" width="882" height="217" />](https://lostechies.com/gabrielschenker/files/2015/04/CQRS-based-architecture.png)

### Classical n-tier application

Let’s assume we have a LOB application using an RDBMS (SQL Server, Oracle, MySql, etc.) to store the data and .Net as the application framework. We could then use e.g. NHibernate or Entity Framework as the ORM for write operations whilst we are using bare bone ADO.NET for the queries.

[<img class="alignnone size-full wp-image-908" title="classical n-tier" src="https://lostechies.com/gabrielschenker/files/2015/04/classical-n-tier.png" alt="" width="446" height="262" />](https://lostechies.com/gabrielschenker/files/2015/04/classical-n-tier.png)

We use database views to simplify the data access when reading data. Views often provide a good means to present data in a de-normalized fashion which is ideal for queries.

If we use this approach and continue using the repository pattern from above then our resulting customer repository might look much simpler

[gist id=7879f5fd408e9d2ec866]

We only have a get method to retrieve the Customer record or entity we want to change and a save method to add a new instance of type Customer. For completeness I also added a Delete method to remove an existing Customer from the data store although I usually tend to avoid this. IMHO data should never be physically deleted from the data store… but that is a totally different discussion.

### Event sourcing and CQRS

If we are using Event Sourcing (ES) as another architectural pattern we can come up with the following high level diagram

[<img class="alignnone size-full wp-image-909" title="Event sourcing" src="https://lostechies.com/gabrielschenker/files/2015/04/Event-sourcing.png" alt="" width="664" height="366" />](https://lostechies.com/gabrielschenker/files/2015/04/Event-sourcing.png)

Here events generated by the domain as a result of commands that change state are written to an event store. Queries on the other hand get their data from a read model which is separate from the event store and is eventual consistent with the write model (the event store). A process running in the background asynchronously dispatches events (as they are flowing into the event store) to observers that build up the read model. In this particular case the read model could be a document database like Mongo DB or Raven DB and/or a file based full index like Elastic Search or Solr.

## Summary

CQRS is one of my preferred architectural patterns when it comes to complex LOB applications. Unfortunately a lot of existing LOB applications do not follow this rather straight forward pattern. This leads to a lot of unnecessary complexity. The execution paths of commands and queries are tightly coupled and thus cannot be individually tweaked or tuned. CQRS solves this problem quite nicely and allows us to build the best possible system for a given context. CQRS is not just limited to modern type of applications using event sourcing and/or DDD. It can be applied in any application that reads and writes data.