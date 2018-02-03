---
wordpress_id: 127
title: How we got rid of the database–part 3
date: 2012-06-18T21:52:18+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/2012/06/18/how-we-got-rid-of-the-databasepart-3/
dsq_thread_id:
  - "732040890"
categories:
  - Uncategorized
---
In my last two posts ([part 1](http://lostechies.com/gabrielschenker/2012/06/12/how-we-got-rid-of-the-database/) and [part 2](http://lostechies.com/gabrielschenker/2012/06/13/how-we-got-rid-of-the-databasepart-2/)) I described how a command that is sent from the client is handled by an aggregate of the domain model. I also discussed how the aggregate, when executing the command, raises an event which is then stored in the event store and furthermore published asynchronously by the infrastructure.

In this post I want to show how these published events can be used by observers (or projection generators) to create the read model.

# Querying

When the user navigates to a screen the client sends a query to the read model. The query handler in the read model collects the requested data from the projections that make up the read model and returns this data to the client. The client never sends queries to the domain. The domain model is not designed to accept queries and return data. The domain model is optimized for write operations exclusively.

Assuming the user is navigating to the screen where existing tasks can be edited the query that the client triggers could be

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2012/06/image_thumb13.png" width="421" height="116" />](http://lostechies.com/gabrielschenker/files/2012/06/image13.png)

and the data returned by the query handler would look like this

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2012/06/image_thumb14.png" width="525" height="234" />](http://lostechies.com/gabrielschenker/files/2012/06/image14.png)

where

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2012/06/image_thumb15.png" width="418" height="133" />](http://lostechies.com/gabrielschenker/files/2012/06/image15.png)

contains the full name and id of the candidates that are assigned to this task and

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2012/06/image_thumb16.png" width="544" height="157" />](http://lostechies.com/gabrielschenker/files/2012/06/image16.png)

contains all the details of an animal that is target of the task.

Where does this data come from I hear you ask… Well, that’s the topic I’ll discuss next.

# Generating the read model

Whenever we design a new screen we need data to display on this screen. Thus we define projection(s) that are tailored in a way that best suits our needs. Ideally we want to create a projection that allows us to get all the data we want with one single read operation to the data store. That is the ideal, but in reality that is not always possible and thus we just want to state this principle: design the projections in such a way that we can retrieve the data needed for a screen using the minimal amount of read operations, ideally one operation only.

This principle requires as a consequence that we store our data in a highly de-normalized way. We regard data duplication in the read model as a necessary consequence and do **not** try to avoid it. Storage space is extremely cheap nowadays.

Since we are not using an RDBMS to store our read model the projections do not have to be “flat”. We can projections that are made of object graphs.

A first approach would thus consequently be to define a projection that looks somewhat similar to the query response object, that we define above. Let’s do so

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2012/06/image_thumb17.png" width="525" height="260" />](http://lostechies.com/gabrielschenker/files/2012/06/image17.png)

Please note that I use the typed Id (TaskId) introduced in [part 1](http://lostechies.com/gabrielschenker/2012/06/12/how-we-got-rid-of-the-database/) in my view.

Now we need to define a class, that creates the task details projection for us. We want to make the implementation of this class as simple as possible. The class should be a POCO and only depend on a writer object

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2012/06/image_thumb18.png" width="896" height="276" />](http://lostechies.com/gabrielschenker/files/2012/06/image18.png)

The writer that we inject into our projection generator class is responsible to physically write our views into the data store. In our case the data store will be the file system but it could be as well a table in an RDBMS or a document database or a [Lucene](http://lucene.apache.org/core/) index. From the perspective of this generator class it doesn’t really matter what type of data store it is.

The definition of the [IAtomicWriter](https://github.com/Lokad/lokad-cqrs/blob/lean/Core/Lokad.Cqrs.Portable/AtomicStorage/IAtomicWriter.cs) interface is very simple

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2012/06/image_thumb19.png" width="1012" height="108" />](http://lostechies.com/gabrielschenker/files/2012/06/image19.png)

For convenience we can then write some extension methods to this interface

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; margin: 0px 0px 24px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2012/06/image_thumb20.png" width="1396" height="495" />](http://lostechies.com/gabrielschenker/files/2012/06/image20.png)

Why not add these methods to the interface directly instead of writing extension methods you might ask. The reason is that we should always try to keep our interfaces as simple as possible such as that our code remains more composable and less coupled.

Having defined the interface and also added the above extension methods we can now continue to implement our projection generator class.

Each projection is created by events. All data that make up a projection are provided by events. In our sample the first event in the life cycle of a task is the NewTaskScheduled event that we defined in part 1. Let’s add code to handle this event in our projection generator

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2012/06/image_thumb21.png" width="930" height="525" />](http://lostechies.com/gabrielschenker/files/2012/06/image21.png)

We use the same convention as we already introduced with the aggregate: we call all our methods When. Each of those methods has exactly one parameter, the event that it handles. This convention makes it easier for us to later on write some tools around our read model. I will discuss this in detail in a later post.

Note that we have used the Add (extension-) method of the writer since at the time when the **NewTaskScheduled** event happens the corresponding view does not yet exists.

Later on other events of interest might be published by the domain and our projection generator can listen to them. Let’s take as a sample the **TaskPublished** event. We add the following code to the projection generator

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2012/06/image_thumb22.png" width="892" height="109" />](http://lostechies.com/gabrielschenker/files/2012/06/image22.png)

very simple, isn’t it?

The resulting file on the file system could look similar to this

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2012/06/image_thumb23.png" width="825" height="232" />](http://lostechies.com/gabrielschenker/files/2012/06/image23.png)

(remember that we are using JSON serialization).

In the next post I’ll try to wire up all pieces that we have defined so far such as that we can run a little end-to-end demo. Stay tuned…