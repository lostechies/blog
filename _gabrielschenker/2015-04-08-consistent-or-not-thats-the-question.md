---
wordpress_id: 914
title: 'Consistent or not that&#8217;s the question'
date: 2015-04-08T21:09:53+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=914
dsq_thread_id:
  - "3666626805"
categories:
  - asynchronous
  - CQRS
  - Event sourcing
  - Patterns
  - Read model
---
My last post about [CQRS](https://lostechies.com/gabrielschenker/2015/04/07/cqrs-revisited/ "CQRS revisited") has lead to a lively discussion around eventual consistent read models. First let me clarify what eventual consistency in the context of a read model means.

A read model that needs some time to get up to date after a change has happened in the write model is called an eventual consistent read model. Now &#8220;some time&#8221; can be anything from micro seconds to minutes or even hours and days. Under normal circumstances eventual consistent read models are up to date in a matter of milliseconds. But there are certain operations that can take a long time and thus the read model is stale for quite some time.

When do we need an eventual consistent read model? Do we need it at all? Well, it is 100% clear that not every type of application benefits from eventual consistency. In contrary, typical CRUD type applications are better off with full consistency. I call these types of applications &#8220;Forms over data&#8221;. The main goal of such applications (and there exist a lot out there) is to process data, potentially loads of data. The business logic is often simple, mostly it is about making sure that the user only enters valid data.

But there are other types of applications, those that automate complicated business processes. It&#8217;s not so much about data anymore but more about getting things done in the right sequence considering many special cases or scenarios. Often these applications also need to scale. Maybe the application is used in an audited business or users want to gain some &#8220;what if&#8221; insights or walk the history of business entities. Are these the applications that benefit from eventual consistency? Maybe, maybe not &#8211; it depends as always&#8230;

When I am trying to find the best possible solution for a given (complex) problem I like to think about the world where there exist no computers. Humans have done business for thousands of years without electronic gadgets and without software. And business was flourishing. Many businesses that have existed for thousands of years and still exists give good samples of how we should model our software. Ultimately our applications should not change the way how we do business but rather help us automate certain tedious tasks and allow us to do business with less resources or on a faster pace. But in the end a baker still needs to produce this wonderful artisan bread that I love with or without the help of computers.

That said, has business in the past and without computers been synchronous or asynchronous? Have such things as transactions existed? Did an action of one person participating in a business cause an instantaneous reaction of another actor in the process? What happened if some mistakes were made in a process due to human errors? Could everything just be rolled back?

I think most of you dear readers will agree with me if I&#8217;m saying that business without computers was mostly asynchronous and thus eventual consistent. And it worked just fine. Ok, but how did we deal with mistakes in the past since we had no automatic rollback? Well, we had compensating actions. As an example take the journal of an accountant. If the accountant makes a mistake in one journal entry she is not allowed to erase or correct the existing but wrong entry. Instead she compensates the mistake with a compensating journal entry. Similarly at Starbucks, what happens if you order a cafe mocha grande with whip cream, the barista already starts to brew your beverage but then the cashier discovers that your credit card cannot be processed and that you have no cash to pay? The barista won&#8217;t hand you out the coffee but he also cannot undo the coffee. The compensating action is that a) the barista dumps the beverage and b) that management has accounted for such events and is adding a tiny amount to the price of every beverage which in their sum will compensate for the loss.

It is an interesting historical fact that Baron Rothschild became rich because he would use the eventual consistency of business in his time to his own favor. I invite you to read about his history, it&#8217;s quite amusing.

A software architecture that is based on event sourcing and CQRS quite nicely reflects this business model &#8211; if done right. One of the most important thing is that the UI is designed accordingly &#8211; we call it a task based UI. So let&#8217;s dive into it a bit. Let&#8217;s assume we are in a restaurant and we order a menu. The waiter will confirm us that she has taken the order. In real life we won&#8217;t immediately ask her &#8220;hey is my food ready&#8230; where is my food&#8230; what&#8217;s the status of my food&#8230;&#8221;. No, we know that she has written down our order and it will be processed eventually. Similarly in a task based application the user triggers some action, e.g. order menu. The application sends a command to the backend called OrderMenu with a payload of the name of the entree and the sides and any possible extras. The backend replies either with order accepted or cannot accept order since e.g. that particular entree is sold out, etc. Let&#8217;s assume that the order was successful. In this case I can tell the user that indeed the order was successful and that the menu will be served soon. There is no need for the application to go and query the system for the status since the UI already has all necessary information. Thus in this particular case there is no problem that the read model is eventual consistent. The moment I as a user have reacted already more than enough time has passed that everything is up to date. Never forget that the user is always the slowest element in the chain. Computers act in micro and milli seconds whilst humans need fractions of seconds or multiple seconds to react.

One big advantage of eventual consistency is that scaling out is possible whilst in fully consistent systems only scale up is possible. Scale up is always much more expensive and complex than scale out. If you don&#8217;t believe me then just try to finance, configure and manage e.g. a Sql Server or Oracle cluster.

Ok, now if your application is a simple application or an application that does not need to scale up then you don&#8217;t need eventual consistency. It is too complex. I also want to state once more that CQRS as an architectural pattern has nothing to do with the question whether to go asynchronous or not. CQRS can be used in both worlds.