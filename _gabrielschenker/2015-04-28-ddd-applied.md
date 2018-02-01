---
id: 951
title: DDD applied
date: 2015-04-28T21:28:07+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=951
dsq_thread_id:
  - "3721370034"
categories:
  - Architecture
  - DDD
  - How To
---
## Introduction

In my last post [DDD revisited](https://lostechies.com/gabrielschenker/2015/04/16/ddd-revisited/) I talked about what is important when using domain driven design (DDD) as an architectural pattern. I have had the pleasant surprise that this post was event mentioned on [InfoQ](http://www.infoq.com/news/2015/04/ddd-wrong-way). Today I want to discuss and show in a realistic context how DDD can be applied. As with CQRS, DDD does not imply any specific additional architectural patter, tooling or infrastructure.

## The domain

In this post I will concentrate on the domain of personal loans. A person with a regular income and a decent credit score can apply for a personal loan to e.g. finance a new car or a trip around the world to name just a few possibilities. This domain is of sufficient complexity to justify the use of domain driven design (DDD).

Ubiquitous language

When talking with subject matter experts one can start to identify nouns and verbs that are used in all discussions when talking about the business (processes). In our particular domain we might identify specifically one noun that is mentioned over and over again. This noun is **Loan Application**. We might also identify other nouns that come up like **Prospect**, **Customer**, **Lead**, etc. On the other hand we hear domain experts using verbs like

  * start (a loan application)
  * submit (an application)
  * approve, withdraw, etc.

<div>
  <span style="font-size: 16px; line-height: 24px;">Let&#8217;s concentrate on the Loan Application for now. When talking about such a &#8220;thing&#8221; we get to know that part of it are personal infos of the applicant like first and last name as well as date of birth, social security number, job, salary, etc. Other information that is part of a loan application is financial data like requested loan amount, type of loan, etc. All these attributes or properties will be part of the Loan Application &#8220;thing&#8221;.</span>
</div>

<div>
</div>

<div>
</div>

## Implementation

When it comes to the implementation of the domain using DDD the nouns will become aggregates and the verbs the actions executed upon the aggregates. Normally this is equivalent to the methods we implement in an aggregate. Of course aggregates do not live in isolation and some infrastructure is needed around the aggregates. Those other parts will be application services, repositories, APIs, etc. to just name the most important ones.

### Contracts

When talking about contracts I am referring to commands, events and interfaces. These are the elements with which the elements of the domain (model) communicate with the outside world. Here the outside world can be the user interface or another system. Commands most often are triggered by user action. They transport the intent of the user. Each command has exactly one target in the domain. The target can either accept the command and execute it or refuse it.

Events tell &#8220;the world&#8221; that something (interesting) has happened. Events can have zero to many listeners that react to the event. Events are things that have happened (in the past) and thus cannot be refused. History cannot be undone. Interested listeners have to just accept the fact that this particular event has happened.

Interfaces are the connection points over which different components interact. Usually messages are exchanged over such connection points. Here message is a common denominator for either a command or an event.

### The aggregate

Let&#8217;s start with the aggregate. This is the component where the interesting stuff happens. Here we find all the business logic that is specific to the context the aggregate represents. The aggregate is infrastructure agnostic. It doesn&#8217;t care where it comes from and where it goes. The aggregate is very self-centric and doesn&#8217;t care about it&#8217;s environment. The aggregate has no dependency to any infrastructure component and it encapsulates its state; that is, the state is private to the aggregate and not directly accessible from outside.

I start by defining the aggregate as a class named according to the noun I identified in the ubiquitous language (loan application) with a post fix aggregate. The aggregate has a constructor

[gist id=ca00e2e8a1a054d9202c]

As you can see the constructor expects one parameter which is the state of the aggregate. I prefer to define the state as an encapsulated object containing all the properties necessary to define the aggregate. The aggregate implements the following interface

[gist id=b2b52c5c66a542cbd943]

Now for each verb that I identified in the ubiquitous language I define a method on the aggregate. Let&#8217;s take the verb withdraw as a sample.

[gist id=029221f5153e24604d6b]

This method has no parameters. Another sample would be the verb accept (offer)

[gist id=749528223e2dff3a5987]

in this case the method has one parameter, namely the id of the offer that the user accepted for his loan.

### The application service

Each aggregate needs a host which provides it the necessary infrastructure. The application service is this host. This service is among other responsible to re-hydrate the aggregate from storage and after acting upon it to persist the changes back to the storage. The application service also provides the aggregate with the necessary (helper) services if needed and facilitates the collaboration of more than one instance of an aggregate where appropriate.

[gist id=306cb2a626c515668dc1]

The service implements a public method called When with one parameter, which is the command we want to handle &#8211; in this case the Withdraw command. In the method we use the repository to re-hydrate the aggregate from storage using its unique ID which must be provided by the command. Then we act upon the aggregate and finally we use the repository again to persist (the changed state of) the aggregate back to the storage. Any other command we handle very similarly, here the accept offer command as a sample

[gist id=95ecb4508b998ed049bd]

Since all methods look somewhat the same we can refactor this class like so

[gist id=9f12e347284b8db3e1ac]

This reduces the amount of code needed significantly.

### Persistance

In our imperfect world where computers can shut down due to hardware failure or power outage we need to have a means to persist the state of our domain model or more specific of our aggregates. In DDD we most often use the repository pattern to provide persistance. The repository object abstracts the underlying storage technology to the domain. The repository can be used to load or re-hydrate an aggregate from storage and to save or persist it (or its state) to the storage.

Our repository implements the simple interface

[gist id=09df01f5416a40bf622a]

Only two methods are needed, the one to re-hydrate an aggregate instance and the other to persist the changes (in the state) of the aggregate.

The implementation of the repository depends on the storage mechanism or library used for persistance. If we use NHibernate a simple implementation could look like this

[gist id=e613e323c44db99b70ba]

The API

The messages are fed into the domain through some API. This can be e.g. a REST-ful API, a message bus handler or even an RPC style interface. In this case let&#8217;s assume that we have a REST-ful API implemented using the ASP.NET Web API. An implementation using Node JS and Express JS would be very similar to achieve.

Here is how I implement a REST-ful API. I am using attribute routing to make the definition of (arbitrary) endpoints super easy. In the following snippet I defined the two endpoints for withdraw and accept order

[gist id=1f2d03ab0a65e79af902]

The controller is only an API component and does nothing else that immediateley forward control to the application service which hosts the target aggregate.

[gist id=57dda0199f2bfcd05c78]

## Summary

In this post I have presented a sufficiently complex context in which the application of DDD can make sense. I have shown for this particular context which part comprise the domain and how I implement each part.