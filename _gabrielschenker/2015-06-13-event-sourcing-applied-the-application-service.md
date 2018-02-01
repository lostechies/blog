---
id: 1050
title: 'Event Sourcing applied &#8211; the application service'
date: 2015-06-13T15:52:41+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1050
dsq_thread_id:
  - "3846334219"
categories:
  - Architecture
  - DDD
  - Design
  - Event sourcing
  - How To
  - Patterns
  - practices
---
In my previous posts I [revisited Event Sourcing](https://lostechies.com/gabrielschenker/2015/05/26/event-sourcing-revisited/ "Event sourcing revisited") (ES) and introduced in detail how I [apply ES](https://lostechies.com/gabrielschenker/2015/06/06/event-sourcing-applied-the-aggregate/ "Event Sourcing applied – the Aggregate") when implementing the aggregates of a domain model. In this post I want to talk about the application services that are the hosts of my aggregates. As I have explained in my previous posts aggregates are self-centric objects that do not care about their environment nor about where they come from and where they go. Thus we need someone or something who is responsible to place an aggregate into the world since it makes no sense to just have an isolated object that has no connection to the outside world. This something is the application service.

## Persistence

First and foremost an aggregate has a life cycle. An aggregate which is in its simplest form just an object and in more complex scenarios a cluster of objects, comes to life at one point. Some operation or user action has the consequence that a new aggregate instance is created. Since we cannot rely on the fact that electricity is always available or that our servers are up and running all the time we need to persist this new aggregate. Later, when we want to apply another command or action to the aggregate we first want to re-load or as we prefer to say re-hydrate the aggregate from storage. Once re-hydrated we apply the action and then persist the (modified) aggregate again. This re-hydration and persisting of the aggregate is one of the tasks of the aggregate service. Note that I did not mention what re-hydrating or persisting an aggregate exactly means and how we implement it. For now those details are not important. Why not? They are not important since the application service uses a repository to do it and the repository has to know how in detail persistance has to work. The application service only orchestrates and delegates this work.

Let&#8217;s look at a sample, our usual loan application that I have so far used in all my previous posts. The user who wants to apply for a new personal loan triggers the creation of a new loan application aggregate by starting a new loan application. The corresponding command that is sent to the domain for processing is called **StartLoanApplication**. To help me keep things simple and consistent I once again use a convention similar to the one that I introduced in the previous post about the aggregate. The convention says that the public methods of the application service always are called When and they have exactly one parameter which happens to be the command that is sent for processing to the domain. Thus we start our code like this

[gist id=6c0795eb7fed4edf37c9]

As you can see we have called our application service **LoanApplicationService** to make it clear what aggregate this service services. I have added a method When to the class which handles the command **StartLoanApplication**. As pointed out in the comments in the above code snippet the body of this method should do 5 things.

  * First we want to create a new unique ID for the aggregate that will be created. _(I personally prefer to have the domain be responsible to generate IDs for the new aggregates but we could also work with client generated IDs.)_
  * Second we use the repository to re-hydrate the aggregate from storage. Since in this case the aggregate does not exist the repository will internally use a factory to generate a brand new aggregate instance which is then returned to the service.
  * Now we can apply the action which in this case is calling the Start method on the aggregate.
  * Next we use the repository again to persist the aggregate since it has changed
  * Finally we return the newly created ID to the caller.

If we have now a subsequent command like e.g. **SetFinacialInfos** that has to be applied to our aggregate then we extend our code like this

[gist id=1e95b9c80d285b55489a]

Evidently here we have a void method since there is no need to pass anything back to the caller. The implementation of the method looks fairly similar to the previous one except for the fact that we do not have to generate a new ID nor to return it to the caller. The remaining part is similar. Just to make it clear let&#8217;s handle the SubmitLoanApplication command.

[gist id=10478ea6e9341797ab52]

Having this recurring pattern we can refactor our service a bit and introduce a helper method that is called by all the When methods. This helper method, let&#8217;s call it Act is responsible to re-hydrate the aggregate, apply the correct action to the aggregate and then persist the modified aggregate using the repository. The implementation of this method looks like this

[gist id=4f7acc3ff86572ada994]

As we can see the method expects the ID of the aggregate we are dealing with to be passed as a first parameter. The second argument is an action<T> where T is the type of the aggregate and in this case the LoanApplicationAggregate. Then the method uses the repository and the passed id to re-hydrate the aggregate. It then applies the action to the aggregate and finally uses the repository again to save the modified aggregate. This is simple right? And indeed it is. It always and always again positively surprises me how simple and elegant code is and looks who is based on sound (architectural) patterns!

Now we can refactor our service and it will look like this

[gist id=c41b7ee2d439d31dc7aa]

All of a sudden our code looks clean and nearly trivial. We can see that each command except the one that triggers the creation of a new aggregate, need to carry with it the ID of the aggregate. This is how we identify which target each command is addressing. In each When method then we need to just define which is the specific action that needs to be applied to the aggregate or formulated differently which method of the aggregate we need to call and how the parameters of the method call are mapped from the command.

Handling yet another command becomes very easy and straight forward as we can see when we handle the AcceptOffer command which is triggered when the user accepts one of the offers the system has made to her. We just add yet another When method with a call to the Act helper method.

[gist id=06d96b32734a82cf6b34]

That&#8217;s all what we have to say about persistance of an aggregate.

## Providing services

As stated earlier, the aggregate is self centric, a POCO object and doesn&#8217;t care about the where about. Sometimes an aggregate needs some service to help it do its business. This may be a service used to make some complicated calculations or similar. The aggregate does not care where this helper service comes from it just expects it to be there when needed. The way we implement our aggregates we cannot use constructor injection on the aggregate to get hold of external dependencies. Thus we inject the service in the appropriate method where it is needed by the aggregate. Let&#8217;s assume that the aggregate has a method Approve and in the body of this method the aggregate needs to execute some complex financial calculations. We can then define the method signature on the aggregate as follows

[gist id=7bd8264ff33c1f22cdd1]

Now the application service is responsible to provide the service to the aggregate. The application service can use constructor dependency injection to get hold of the service and then pass it to the aggregate when appropriate. Thus we have this

[gist id=e54b272f46ddf5d4af16]

## Orchestration

In a more specific and maybe exotic example the application service can also orchestrate the collaboration of two or more aggregates. Let&#8217;s for a moment imagine that in our domain of applications for personal loans we have a customer aggregate and lets also assume that when a user starts a new loan application the command is actually handled by the customer aggregate which represents this user. We can then have code similar to this one in a **CustomerApplicationService**:

[gist id=06a139e9db9e8b68add1]

In this scenario the customer aggregate is responsible to build up a new instance of the loan application aggregate. It uses a factory service to do this. The application service is responsible to re-hydrate the customer aggregate from storage, apply the action, provide the external dependencies to the customer aggregate (factory) and finally persist the new loan application aggregate to storage.

Thus we have seen a sample how the application service orchestrates the collaboration of two aggregates.

##  Summary

Aggregates are self centric and infrastructure agnostic. They do not care about where they come form or where they go nor do they care where all the helper services come from they need to delegate some work. For all these purposes we use application services. Each aggregate type has a corresponding application service. The application service can be considered as the host of the aggregate and is responsible for all orchestration and infrastructure matters.

It is worth noting that the application service at no point deals with the fact that we are using event sourcing. The only participants in the domain that deal with the intrinsic of ES are the aggregate and the repository.

In the next post we are going to discuss the repository and the underlying storage used when applying the Event Sourcing as an architectural pattern. Thanks for reading and please stay tuned.

**Psssst**: There is an upcoming free workshop about **Event Sourcing** that I am moderating. Please have a look [here](https://lostechies.com/gabrielschenker/2015/06/13/workshop-about-event-sourcing/ "Workshop about Event Sourcing") for further details.