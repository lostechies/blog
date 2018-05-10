---
wordpress_id: 102
title: How we got rid of the database–part 2
date: 2012-06-13T21:33:01+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/2012/06/13/how-we-got-rid-of-the-databasepart-2/
dsq_thread_id:
  - "725178350"
categories:
  - CQRS
  - Event sourcing
  - no-database
---
# A quick introductory sample – continued

In [part one](https://lostechies.com/gabrielschenker/2012/06/12/how-we-got-rid-of-the-database/) of this series I started to explain what we do, when e.g. a user (in the particular case a principal investigator) wants to schedule a new task. In this case a command is sent from the client (the user interface of the application) to the domain. The command is handled by an aggregate that is part of the domain. The aggregate first checks whether the command violates any invariants. If not the aggregate converts the command into an event and forwards this event to an external observer. The observer is injected into the aggregate by the infrastructure during its creation. The observer accepts the event and stores it in the so called event store.

It is important to realize, that once the event is stored we can commit the transaction and we’re done. What(?) &#8211; can I hear you say now; don’t we have to save the aggregate too?

No, there is no need to save (the current state of) the aggregate; saving the event is enough. Since we store all events that an aggregate ever raises over time we have the full history at hand about what exactly happened to the aggregate. Whenever we want to know the current state of an aggregate we can just re-create the aggregate from scratch and re-apply all events that we have stored for this particular instance.

We can extend the diagram that I first presented in my [last post](https://lostechies.com/gabrielschenker/2012/06/12/how-we-got-rid-of-the-database/)&nbsp; as follows

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; margin: 0px 0px 24px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2012/06/image_thumb9.png" width="610" height="454" />](https://lostechies.com/content/gabrielschenker/uploads/2012/06/image9.png)

If we now look at just the events of one single task instance we would have something like this

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2012/06/image_thumb10.png" width="495" height="497" />](https://lostechies.com/content/gabrielschenker/uploads/2012/06/image10.png)

If we create a new task aggregate and apply all the n events that we find in the event store then the result is a task aggregate that has been completed.

It is important to know that new events are always only appended to the stream of existing events. Never do we delete or modify an already existing event! This is equivalent to the transaction journal of an accountant. The accountant always only adds new journal entries. He never modifies an existing one nor does he ever delete a previous entry.

But how do we store these events? There are various possibilities, we could serialize the event and store it in a column of type BLOB (binary large object) or CLOB (character large object) of a table in a relational database. We would also need to have a column in this table where we can store the ID of the aggregate.

We could as well store the (serialized) event in a document database or in a key value store (e.g. Hashtable).

But wait a second…, if we serialize the event why can we not just store it directly in the file system? Why do we need such a thing as a database which only adds complexity to the system (it is always funny to point out that a database ultimately stores the data in the file system too).

Let’s then define the boundary conditions:

  * we serialize the events using _Google protocol buffer_ format
  * we create one _file_ per aggregate instance; this file contains all events of the particular instance
  * any new incoming event is always _appended_ at the end of the corresponding file

Advantages

  * Google protocol buffer 
  * produces very compact output
  * is one of the fastest ways to serialize an object (-graph)
  * is relatively tolerant to changes in the event signature (we can change names of properties of add new properties without producing version conflicts)

  * since we usually only operate onto a single aggregate per transaction we need only one read operation to get all events to re-construct the corresponding aggregate
  * append operations to a file are fast and simple

Disadvantages

  * we have to decorate our events with attributes to make them serializable using Google protocol buffer

If we are using protbuf-net library, which is available as a nuget package, to serialize our events then we can use the standard DataContractAttribute and DataMemberAttribute to decorate our events

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2012/06/image_thumb11.png" width="761" height="261" />](https://lostechies.com/content/gabrielschenker/uploads/2012/06/image11.png)

Note that the _order_ of the properties and there _data type_ is important but not their name.

Assuming we have our event serialized and it is available as an array of bytes we can use the following code to append it to an existing file

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; margin: 0px 0px 24px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2012/06/image_thumb12.png" width="623" height="780" />](https://lostechies.com/content/gabrielschenker/uploads/2012/06/image12.png)

The code is a simplified version of the productive code we use in our application. What is missing is the code that&nbsp; also stores the length of the data buffer to append as well as its version. Whilst incomplete the above code snippet nevertheless shows that there is no magic needed and certainly no expensive database required to save (serialized) events to the file system.

Since we did not want to reinvent the wheel we chose to use the [Lokad.CQRS](http://lokad.github.com/lokad-cqrs/) “framework”. If you are interested in the full code just browse through the [FileTapeStream](https://github.com/Lokad/lokad-cqrs/blob/lean/Core/Lokad.Cqrs.Portable/TapeStorage/FileTapeStream.cs) class.

Loading the stream of events from the very same file is equally “easy” and the implementation can be found in the same class.

In my next post I will talk about how we can _query_ the data. Stay tuned…