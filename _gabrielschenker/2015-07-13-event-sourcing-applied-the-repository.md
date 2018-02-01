---
id: 1064
title: 'Event Sourcing applied &#8211; the Repository'
date: 2015-07-13T18:52:01+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1064
dsq_thread_id:
  - "3931880712"
categories:
  - Architecture
  - asynchronous
  - commands
  - CQRS
  - DDD
  - Event sourcing
  - How To
  - Patterns
---
In my last few posts I started by [revisiting](https://lostechies.com/gabrielschenker/2015/05/26/event-sourcing-revisited/ "Event sourcing revisited") the architectural pattern Event Sourcing and looked into how we can apply this pattern. I first discussed [implementation of the aggregates](https://lostechies.com/gabrielschenker/2015/06/06/event-sourcing-applied-the-aggregate/ "Event Sourcing applied – the Aggregate") and then of the [application services](https://lostechies.com/gabrielschenker/2015/06/13/event-sourcing-applied-the-application-service/ "Event Sourcing applied – the application service"). In this post I am going to discuss the repository which abstracts the re-hydration and persisting of the aggregates for us. I am going to discuss 2 possible implementations, the first one when using a relational database as event store and the second one when using a specialized event store, in this case the [GetEventStore](https://geteventstore.com/).

## The repository interface

So far we have only dealt with the repository interface. We have seen that we need exactly two methods, one to retrieve an existing aggregate from storage by it&#8217;s unique ID and one to persist the new or modified aggregate. Here is the definition of the interface

[gist id=4bd236d9ea435f82e048]

Since the concept is the same for all types of aggregates we implement one single version and use generics to make it more versatile. Here the generic parameter T represents the aggregate. Note that by our own convention each aggregate must implement an interface **IAggregate**. We use this interface in the Save methode to avoid that anything else than an aggregate is passed to the repository and, as we will see later to allow the repository to communicate with the aggregate over this interface.

## Implementation for SQL Server

Now let&#8217;s write an implementation for the repository interface and let&#8217;s start with SQL Server as a typical representative of a relational database. An implementation for any other RDBMS like Oracle, Postgres or MySql is very similar and is left to the reader as an exercise.

First we need to discuss how we are going to store the events. We know that each aggregate instance publishes an stream of events over its life cycle. The stream of events can be uniquely identified by the globally unique ID of the corresponding aggregate instance. Let&#8217;s agree that we will store all events in one single table. The primary key of this table is not really important from the perspective of the repository or the domain thus we can chose any type of PK we like. Let&#8217;s use the datatype uniqueidentifer of SQL Server. We also want a column for the aggregate ID and another one for the version of the aggregate. The version will help us to order the events in the stream. Of course we want to store the event itself in another column. Now here we can just use a nvarchar(MAX) data type for the column and store in it the serialized event. I prefer JSON format but XML format is also possible. Note that the upcoming SQL Server 2016 will support JSON natively which is a bonus. We also want another column where we can store the meta data of each event as JSON formatted string. Finally we add a column where we can store the category of events or the aggregate type name which is equivalent. This column will be of use if we need to retrieve events only of a given category. Remember we store all events in the same table. Last but not least we add a column dispatched of type bit to the table which will indicate whether or not a given event has been dispatched by the infrastructure to all observers. As we will see in future posts the observers are responsible to build the various read models.

The schema of the table now looks like this

[gist id=ac1fa747fbe068981655]

So far we have not indexed this table other than defining a primary key. The repository will retrieve events by aggregate ID thus we need to at least add an index on the column AggregateId. We also need an index on the column Dispatched.

[gist id=f5dbe5daba67b0097122]

With this we should be good to go and ready to implement the repository. To keep things as simple and fast as possible we will use Ado.Net to access the database. The only thing we need then to inject into the repository is a factory which we will use to create instances of aggregates given a stream of events and a &#8220;service&#8221; that provides us the connection string to the SQL Server. Our class looks like this

[gist id=15594a6d17c371971b1e]

### The save method

Now let&#8217;s first implement the Save method. Here we get as a parameter the aggregate which is implementing the interface IAggregate. First we get the list of uncommitted events from the aggregate. If we have no events we don&#8217;t need to do anything and can just bail out otherwise we use an extension method **ToEventData** to transform our array of domain events into an array of objects of type **EventData** whose shape matches the schema of the database table into which we want to  persist the events. Here is the first part of the code of the Save method

[gist id=c967fe27e781d81285e4]

The class EventData is defined as follows

[gist id=b9a53821d8383e598868]

and the extension method **ToEventData** is shown here

[gist id=1ff79e0f3ce2f026d638]

Note how we add the fully qualified type name of the event as header information and serialize the header and the body to JSON format. Also not how we use a helper class [CombGuid](https://gist.github.com/gnschenker/97aee28ba3424f6d8f8d) to generate a new ID for each event. We use Comb GUIDs and not just normal GUIDs since they are optimized for indexing.

Now that we have an array of EventData objects we use ADO.Net and Dapper to persist them into the table Events in SQL Server. Note how we first load the highest known version number for the given aggregate ID and compare it to the version number that our aggregate was when we loaded it. This is done to catch concurrency violations. If someone else has modified the aggregate in the mean time we throw an exception otherwise we insert the events into the table. All this happens in a transaction. Here is the complete Save method.

[gist id=a092f67eb78cbdb082e2]

Note that as a last statement we tell the aggregate to clear all uncommited events.

### The Get method

Now we can implement the Get method of the repository as follows

[gist id=fb0dd7d166a1e7711898]

We&#8217;re getting all events that have the given aggregate ID and we use the extension method DeserializeEvent to get the list of domain events from the EventData types. We then use the aggregate factory to create a new instance of the aggregate passing it the array of events. Finally we return the new aggregate to the caller.

The extension method used above is very straight forward and looks like this

[gist id=7b8fe8dbdd1b2b8036a6]

We use the information that is stored in the meta data to get the fully qualified name of the event and use this information to deserialize the event data into a specific domain event.

## Implementation for GetEventStore

Ok, we have seen how to implement the repository interface for SQL Server. Now it&#8217;s time to do the same for a dedicated Event Store. In this case we use GetEventStore. There is a C# library available (nuget package!) to access GetEventStore.

### The Get method

Using this library our Get method can be implemented like this

[gist id=bae52dcadb22db43bd84]

We are retrieving the events slice by slice from GES until there are no more left. This is what the do loop is for. We can use the **ReadStreamEventsForwardAsync** method of the connection method to get the next slice of events. Note that the GES client only provides async methods. I will talk about this in the next section in more detail. We are using the Result method to await and return the slice. Then we use the DeserializeEvent extension method to deserialize the slice of GES events into the domain events we are really looking for and add them to the events list. Similar to what we did in the implementation for SQL Server we now use the aggregate factory to generate a new instance of the expected aggregate type by passing it the list of events. We then return this aggregate to the caller.

Here is the **DeserializeEvent** method

[gist id=d42dddabc3153a1cbdc6]

It is straight forward and very similar to what we saw in the implementation for SQL Server above.

We also use the **GetStreamName** helper method to identify the stream we want to load. GES uses the name of the stream as its unique identifier. Here is the implementation

[gist id=fb585ff824948949ae71]

### The Save method

TheSave method looks like this

[gist id=432fbeec71e890556313]

First we get all uncommitted events from the aggregate. If there are none we are done and bail out. Otherwise we determine the name of the stream to which these events belong and calculate the expected version which will help us to check if we have a concurrency issue (someone else has changed the aggregate in the mean time).  We then define some meta data; here it is a commit ID and the fully qualified name of the aggregate which is the source of these events. Note that these two values are totally arbitrary. What kind of meta data you store with each event is up to you and depends on the use case.

Now we use the **ToEventData** extension method to wrap the domain events into a GES specific structure including the meta data. We then use the **AppendToStreamAsync** method of the GES connection object to append the yet uncommitted events to the stream (of already existing events). Once again this method is asynchronous and thus we use the **Wait** method to await the completion of the operation. Finally we tell the aggregate to clear the list of uncommited events.

The ToEventData method implementation is as follows

[gist id=887629be1b5ed5b13d2f]

First we serialize the domain event (here called more generically \`message\`) using these serializer settings

[gist id=05ea9b299c8c8c151ba3]

Then we once again add the fully qualified name of the event to the meta data and serialize the meta data using the same serializer settings. Then we return a new instance of type **EventData** which is the specific format in which GES stores the events.

<div>
</div>

## Asynchronous operations

So far we have implemented our repositories synchronously. But since we are dealing with IO operations which can take time we should really implement them asynchronously. We can use the async await pattern provided by C# to do so. Luckily the GES client library is already fully async and also Dapper provides async methods to access SQL Server (or any other relational DB). The interface IRepository has to be changed to look like this

[gist id=a0267f5a7f78dc0bfa8d]

And the slightly modified version of the SQL Server repository then looks like this

[gist id=c37d622a1b6a889b7d3e]

## Summary

In this post I have shown 2 different implementations of the repository interface. Both repositories are used to store events generated by an aggregate. I have thus shown that the choice of the Event Sourcing architectural pattern doesn&#8217;t necessarily tie us to a particular event store. We can use a relational DB, a no-SQL store or a specialized event store. The advantage of a specialized event store is usually the tooling around it. On the other hand using a RDBMS like SQL Server as event store makes our infrastructure guys happy because they know exactly how to deal with such a database when it comes to maintenance and backup.