---
wordpress_id: 1099
title: 'Event sourcing applied &#8211; the read model'
date: 2015-07-16T18:29:51+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1099
dsq_thread_id:
  - "3941691386"
categories:
  - Architecture
  - asynchronous
  - Event sourcing
  - GetEventStore
  - How To
  - introduction
  - Patterns
  - practices
  - Read model
---
In my last posts about event sourcing I discussed the write side of the picture. I introduced the aggregate which is the target of commands and as a reaction publishes event and I have also discussed the application service which hosts the aggregate and provides the necessary infrastructure to it. Finally I have presented 2 implementations of the repository used to persist events in either a relational database or a special event store.

This time we want to look at the query or read side of the picture. First we need to say it loud and clearly that an event store is not going to be queried ever. It would be a very bad idea to query an event store since it only consist of a stack of events. That would be highly inefficient! Thus we need another source which we can query when we need to display some data on screen or to create a report. We call this source a **read model**.

We are using the events to successively build up our read model. Normally we define some observers in our application that listen to certain events and if they get hold of some they use those events to create a projection. Here a projection is the synonym for a particular view of the data. In an e-commerce application we could for example have projections for such things as customers, orders, invoices, products, etc.

Projections can be created synchronously as the events are published by the aggregate or asynchronously and thus decoupled from the creation of the event in the domain. But before we dive deeper into the synchronous versus asynchronous discussion let&#8217;s discuss how we can implement a so called observer.

I like to implement all my observers as POCO classes using the convention that I add a method called **When** for each event that I want to handle. The When method returns **void** and has always only **one parameter**, the event I want to handle. Thus if I have an observer called LoanApplicationObserver and two events **LoanApplicationStarted** and **LoanApplicationSubmitted** that I want to handle then my code looks like this

{% gist e93a0ed6d0337cdd8067 %}

For each additional event we want to handle we just define yet another When method. This is straight forward, isn&#8217;t it. But it is important to notice that using such kind of conventions makes defining observers very simple and allows us to build a simple infrastructure around it which will use these observers.

No when thinking about what we really want to do here then we come to the conclusion that we want to generate a view (or document). In this particular case the view could be called **LoanApplicationView**. This view will be a snapshot of the current state of the corresponding loan application. As the events flow in over time we continue to update the view (or better said the corresponding instance of the view). Now we have two operations that we need to perform, we need to create a new instance of the view when the very first event of the life cycle of the loan application is handled. Let&#8217;s call this operation the **Add** operation. For every subsequent event we need to update the now existing instance. Thus we just have said that we need an **Update** operation. (_Some times we also need a delete operation but this time let&#8217;s skip thi_s)

We now define an interface **IProjectionWriter<T>** for our writer. It looks like this

{% gist 54104b01a5d2bffdb51d %}

So let&#8217;s inject a writer service into our observer which implements this interface where T corresponds to the type of the view we want to generate. In our case this would thus be LoanApplicationView. Our code now looks like this

{% gist 3b0b61aecc25a9f1e9f7 %}

Note how in the When method where we handle the very first event of the life cycle of a loan application (the LoanApplicationStarted event) we use the add method of the writer to add a new instance of type LoanApplicationView. We use the payload of the event to fill out details of the view. Also note how we use another convention here, the convention that we always call the primary key of the view **Id**.

Now note that in the other When method we use the Update method to use the event data to modify an existing view instance. The update method has two parameters, the first parameter is the primary key of the instance we want to modify and the second parameter is a Action<LoanApplicationView>. The writer takes the passed in ID to load the current value of the instance from the storage and provides it to us so that we can modify it. Once we have modified it the writer will save the changes back to the data store.

It is very important to realize that up to now we have no indication about what type of underlying storage we are using. Is it a relational database, a document database, elastic search or even a file system? At this level I do not need to know. Later we will see how we can provide different implementations for the interface **IProjectionWriter<T>** targeting different types of data stores.

Just to familiarize ourselves let&#8217;s handle another event. This time it is the PhoneNumberAdded event. The code snippet we need to add to the observer looks like this

{% gist 0faf3560526f314845b7 %}

again we have used the update method since this particular event never starts the life cycle of a loan application. It only ever occurs when the loan application has previously been started.

It is important that we realize that each When method only updates a small part of the whole view. Just the data that each event transports. And it is a best practice to keep our events focused, meaning that they transport the least amount of data possible. Generic and fat events are to be avoided at all cost!

Next we need to define a registry where we can register all observers that we implement. The infrastructure code that we will discuss in my next post will use this registry to wire up everything. The code for the registry looks like this

{% gist f505ca62ee1330522310 %}

The class instantiates each observer using a factory and returns it to the caller.

In my next post I will discuss the infrastructure code needed to wire up all these observers with the source of events. Stay tuned&#8230;

&nbsp;