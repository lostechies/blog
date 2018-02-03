---
wordpress_id: 996
title: 'DDD &#8211; The aggregate'
date: 2015-05-25T12:57:41+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=996
dsq_thread_id:
  - "3792901701"
categories:
  - Architecture
  - DDD
  - Design
  - How To
  - Patterns
  - TDD
---
In my last posts I [revisited](https://lostechies.com/gabrielschenker/2015/04/16/ddd-revisited/ "DDD revisited") domain driven design (DDD), [applied](https://lostechies.com/gabrielschenker/2015/04/28/ddd-applied/ "DDD applied") it to a concrete domain and shed some light onto special scenarios ([here](https://lostechies.com/gabrielschenker/2015/05/07/ddd-special-scenarios-part-1/ "DDD – Special scenarios, part 1") and [here](https://lostechies.com/gabrielschenker/2015/05/11/ddd-special-scenarios-part-2/ "DDD – Special scenarios, part 2")) and how one could possibly solve them using DDD. In this post I want to talk a little bit more about the aggregate and how I like to implement it.

The [aggregate](http://martinfowler.com/bliki/DDD_Aggregate.html) is a logical boundary for things that can change in a business transaction of a given context. An aggregate can be represented by a single class or by a multitude of classes. If more than one class constitutes to an aggregate then one of them is the so called root class or entity. All access to the aggregate from outside has to happen through the root class. The outside world should only ever see (an interface to) the root class. Everything else remains internal to the aggregate.

As a consequence only the root class or entity needs a globally (!) unique ID. Any other entity only requires a locally unique ID (that is an ID that is unique inside the boundaries of a given aggregate instance).

## Implementing an aggregate

Let&#8217;s make a simple sample. Imagine we have a **loan application aggregate**. To distinguish my aggregates from other objects I personally like to suffix their names with -Aggregate. Thus we have a **LoanApplicationAggregate**. To start with and to keep it simple this aggregate consists of a single class

[gist id=970ff4203866efd2b724]

It is important to notice that the aggregate is a [POCO](http://en.wikipedia.org/wiki/Plain_Old_CLR_Object) and thus doesn&#8217;t inherit from or depend on some framework (base class).

To avoid that implementation details of the aggregate leak out and to enforce the [tell don&#8217;t ask](http://martinfowler.com/bliki/TellDontAsk.html) principle I tend to keep the state of the aggregate private to the aggregate. The state of the aggregate is usually represented by properties. For our loan application aggregate some typical attributes or properties of the state are:

  * email, address, social security number, annual income (of the borrower),
  * requested loan amount, bank account, etc.

we can implement those as follows

[gist id=ae281f5f73f31425b294]

There is one exception though to this. I want to make the globally unique ID of the aggregate public but read only. Thus I have

[gist id=52b7a7895320e9bafaa9]

In general working with GUIDs instead of e.g. integers as IDs that need to be globally unique has proven to be very straight forward, robust and scalable. GUIDs can be generated anywhere without the danger of collisions. That&#8217;s the reason I have chosen our ID to be of type GUID.

Now when doing DDD then the aggregates are the place where interesting stuff happens. Here you are going to implement most of the application or domain specific business logic. Thus aggregates are much much more than pure data containers or DTOs.

Ideally the aggregate exposes an interface to the outside world with intention revealing method names that can be called. In our situation such an intention revealing method could be **StartApplication** and another one could be **SubmitApplication**. This could look somewhat like

[gist id=c61bf36305cfd0d235a6]

Note how the former method has four parameters id, email, firstName and lastName whilst the latter doesn&#8217;t need a parameter. This means that we can only start an application if we provide (at least) a unique ID, the email address and first and last names of the borrower. On the other hand telling the aggregate that it is to be submitted needs no other data.

A method body usually consist of some code that checks the preconditions and makes sure that the execution of this method does not violate some business constraints. What could that mean? In the case of starting a new application a precondition check could be that one cannot start the same application more than once. In the case of submitting an application a typical precondition check could be to verify that only an application that is currently in status **Draft** can be submitted. The implementation could then look like this

[gist id=738805b73485dcfa80a1]

Another important part of the method body is to update the internal state. Thus we have

[gist id=1bc9f4a1c186dbfae2ce]

Note how in the StartApplication method we automatically set the status of the aggregate to Draft whilst in the SubmitApplication method we set the status to Submitted.

Finally there could be the need to publish some event to the outside world that something interesting has happened. Interested parties (called observers) could then react to this/these event(s) and do something important on their turn. [_In a typical enterprise application such events could be published on a [bus](http://en.wikipedia.org/wiki/Enterprise_service_bus), e.g. [NServiceBus](http://particular.net/nservicebus), [Mass Transit](http://masstransit-project.com/) or similar &#8211; but this is outside of the scope of this post_]

[gist id=1fceebe3b91e306a5f37]

The internal Publish method just adds the passed event to a collection of yet unpublished events. The infrastructure which hosts the aggregate will then be responsible to e.g. dispatch these unpublished events to the bus.

After having shown some implementation details it is time to refactor the whole aggregate a bit. I personally like to separate concerns inside the aggregate. For me the aggregate should be responsible for the business logic and house keeping whilst the state should be maintained by a separate object. I call this new object the State object. In our case I introduce a new class called LoanApplicationState. An instance of this class will be private to each aggregate instance. Here is this state class

[gist id=e96f0434f57f0bfef61a]

An here is how I use it inside my aggregate

[gist id=abe6bb736b64c8bf0254]

As I said this helps me to separate concerns and as an added bonus makes unit tests or TDD much more elegant. Let&#8217;s now have a look how we can test such an aggregate

##  Testing the aggregate

Given the way we have implemented the aggregate so far and specifically considering the fact that we have separated the state of the aggregate into its own class makes testing really straight forward. When using NUnit as our testing framework then I like to implement a simple base class which allows me to write tests in a Give-When-Then style. Here is this base class together with the definition of a Then attribute

[gist id=53baa8f1fc0fbbf120c2]

Now I can write a simple test for the **StartApplication** method

[gist id=33bdb3f4cdcc8fbaf60e]

Note how I always call the class I am testing the **system under test** (sut, see line 3 above). Also note how I setup the preconditions in the Given method, I then act in the When method and finally I have a method decorated with the [Then] attribute for each assertion. Also note how I can use the state object in my assertions. This is really cool; I can now access any detail of the state object although during runtime the state is private to the aggregate!

Similarly I can write a unit test for the **SubmitApplication** method to assert that an exception is thrown if the loan application is not in status Draft.

[gist id=cbce808998858082fb3a]

Since the aggregate is the place where most of the critical and business specific action happens it is also the place for which you would probably want to write most of your unit tests. Using the implementation patterns that I have shown above it is a joy and straight forward to implement unit tests for even the most exotic edge cases.

## Persisting the aggregate

Assuming that we are working with a relational database backing our application it makes sense to use the aggregate state object as the object we want to persist since it encapsulates all state. If we are using an ORM like NHibernate or Entity Framework it is straight forward. Let&#8217;s assume we are using **NHibernate** in our application combined with **Fluent NHibernate** for the mapping of (data-) entities to underlying tables in the database then we just need to make all the properties of our state object virtual. Thus we have

[gist id=e655824dfdaa37e3f40a]

We can then use code similar to this to re-hydrate an aggregate from storage

[gist id=da54dbc58526e8e21c7d]

here _session is an object of type **ISession**. Persisting the changed state of the aggregate is similarly straight forward

[gist id=99daf5cfd029330ffc41]

which of course implies that the aggregate provides a **GetState** method returning its internal state for persistance.

Note that the whole re-hydration and persisting of aggregates can be further abstracted using the repository pattern that I have introduced in earlier posts (e.g. [this one](https://lostechies.com/gabrielschenker/2015/04/28/ddd-applied/ "DDD applied")).