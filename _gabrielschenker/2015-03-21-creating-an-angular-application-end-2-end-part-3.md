---
wordpress_id: 894
title: Creating an Angular application end-2-end – Part 3
date: 2015-03-21T18:15:58+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=894
dsq_thread_id:
  - "3615761653"
categories:
  - Event sourcing
  - GetEventStore
  - How To
  - introduction
  - MongoDB
  - Read model
  - Ubuntu
---
# Introduction

In the last two posts of this series which you can find [here](https://lostechies.com/gabrielschenker/2015/01/05/creating-an-angular-application-end-2-end-part-1/) and [here](https://lostechies.com/gabrielschenker/2015/01/11/writing-an-angular-js-application-end-2-endpart-2/) I started to implement the server side of a complete Angular JS application that uses CQRS and Event Sourcing as architectural patterns and stores the events created by the aggregates in the domain in [GetEventStore](https://geteventstore.com/). All this runs on my Ubuntu 14.10 Linux VM which is hosted in Hyper-V on my computer.

After we have successfully implemented the code that handles an incoming command, dispatches this command to the domain aggregate and stores the event(s) created by the aggregate in GetEventStore (GES), it is now time to start implementing the code necessary to build a read model from the events stored in GES. Our first read model will use MongoDB as the data store.

## On a side note

Due to the fact that I changed my job and am now with [Clear Measure](http://www.clear-measure.com/) my blog got a bit neglected. I had to first digest the many changes that awaited me there. Clear Measure is an awesome company and… we are hiring! If you are passionate about software development and are eager to work with great people then please [apply](http://www.clear-measure.com/careers/).

# The Read Model

We want to start with a very simple read model. Our read model should consist of a collection of all recipes. Each recipe is represented by the following view

{% gist 1f8daf8589b13e305bf9 %}

For the moment we just want to store the id, name, category and status of the recipe as well as the name of the user who authored the recipe. We now want to define an observer class that listens to incoming recipe events and uses them to create a read model. For each type of event that the observer handles we implement a When method which has the specific event as (single) parameter. If we have the two events **RecipeCreated** and **RecipeSubmitted** then the class (without implementation) looks like this

{% gist 2bc2ee4956bd107558ff %}

To write the data to the underlying data store (MongoDB in this case) the observer uses a writer which implements this interface

{% gist 097604e46a0c03e9b275 %}

The interface has only two members, one to add a new item to the underlying data collection and the other to update an existing item in the collection. The writer is injected to the observer through the constructor

{% gist d6290e58a45a0569bf3e %}

We can now implement the code needed to add a new recipe when handling the **RecipeCreated** event and to update an existing recipe when handling the **RecipeSubmitted** event using the injected writer

{% gist 20108fbf099ca4988d40 %}

If we are creating our read model this way the code is really simple to implement a new or extend an existing observer. In my company we use this approach a lot and it makes our lives quite easy. In this particular case if we add another recipe related event that the observer needs to handle we just need to add another When method to the class that handles the new event. Most probably this event will be used to update the existing recipe and thus we’ll use the Update method of the writer.

Now let’s implement the **IProjectionWriter<T>** interface for MongoDB, shall we? To access MongoDB from ASP.NET and C# we need a driver. Luckily we can just download and install it via nuget. We add this line to the dependencies section of the project.json file

<span style="font-family: 'courier new';">&#8220;mongocsharpdriver&#8221;: &#8220;1.9.2&#8221;</span>

Save the file and in a terminal run <span style="font-family: 'courier new';">kpm restore</span> to download and install the new package.

Here is the code for our MongoDB projection writer

{% gist f013ac20287c4b7c1c52 %}

To access MongoDB we need a connection string. If MongoDB is installed locally we can use “mongodb://localhost”. In this case we inject the connection string to use via constructor injection.

When the Add method on line 20 is called then we need to first determine to which MongoDB collection the new item shall be added (line 22). Once we have the collection we just add the item (line 23). To get hold of the collection we have the helper method GetCollection. In the GetCollection we first create a new MongoDB client using the connection string. Through the client we get access to the server (line 44) and via the server to the database (which we conveniently call Recipes, line 45). Once we have the database we can get hold of the desired collection (line 46). This collection by our convention shall be named like the type name of the item, e.g. RecipeView.

The Update method is only slightly more complicated. Since this is an update we assume that there must already exist an item in the collection that has the given Id as primary key (line 28 through 30). If we do not find such an item then we have a fatal error and we throw an exception. Otherwise we use the update action passed to the method to update the existing item (line 35) and save the updated item back to the collection in MongoDB (line 36).

That’s all we need for the moment. We can now try to test this code. For this we can e.g. implement a simple Test controller that when called creates a new instance of the MongoDB projection writer and uses it to add an item to the read model and also update this item thereafter. The code we use looks like this

{% gist 1825e0a6465f224991e0 %}

On line 15 we create a new instance of the MongoDB projection writer passing in the connection string for our locally installed MongoDB server. On line 17 we first create a new recipe and on line 25 we try to update the just created recipe.

We can now compile our code (kpm build) and if ok run the webserver (k kestrel). We also need to make sure MongoDB runs (see [here](https://lostechies.com/gabrielschenker/2014/12/31/creating-an-ubuntu-developer-vm-on-hyper-v-part-2/) for more details). We can then use the Postman plugin for Chrome to send a post request to the test controller just implemented above. Create a POST request to the URI [http://localhost:5004/api/test/test](http://localhost:5004/api/test/test "http://localhost:5004/api/test/test"). We should see the following in the terminal

[<img style="border-width: 0px;" src="https://lostechies.com/content/gabrielschenker/uploads/2015/03/image_thumb.png" alt="image" width="468" height="129" border="0" />](https://lostechies.com/content/gabrielschenker/uploads/2015/03/image.png)

And if we use e.g. [Robomongo](http://robomongo.org/) to access MongoDB and analyze the outcome we should see this

[<img style="border-width: 0px;" src="https://lostechies.com/content/gabrielschenker/uploads/2015/03/image_thumb1.png" alt="image" width="804" height="417" border="0" />](https://lostechies.com/content/gabrielschenker/uploads/2015/03/image1.png)

Clearly our code has created a new collection **RecipeView** in a database Recipes and we also see that in this collection there is the expected recipe with all its properties.

# Summary

In this post we have implemented the infrastructure need to generate a read model from our events. The read model in this particular case is stored in MongoDB. Creating a read model for other undelying data stores is simple. Samples are Lucene.Net, the file system or a relational database. We only need to create a storage specific implementation of the interface **IProjectionWriter<T>** and we’re done.