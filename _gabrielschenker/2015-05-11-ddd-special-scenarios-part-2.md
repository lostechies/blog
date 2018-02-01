---
id: 978
title: 'DDD &#8211; Special scenarios, part 2'
date: 2015-05-11T15:30:54+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=978
dsq_thread_id:
  - "3755615948"
categories:
  - Architecture
  - DDD
  - Design
  - How To
  - practices
---
In my [last post](https://lostechies.com/gabrielschenker/2015/05/07/ddd-special-scenarios-part-1/ "DDD – Special scenarios, part 1") I discussed possible solutions for two specific problems when using DDD. In this post I want to analyze more

## Collaboration of aggregates

Aggregates in DDD are very self centric or self focused. An aggregate does not care where it comes from and where it goes nor does it care about its environment. But sometimes our application needs functionality that requires two or more instances of aggregates to collaborate. In our world of personal loans that I have used in the preceding posts this could be a customer aggregate and a loan application aggregate. If we want to keep track about how many applications a specific customer has started and/or how many loans have been granted to this customer we need some kind of collaboration between said two types of aggregates.

[gist id=7a991fbad2b499b112cf]

In the above snippet a service IIdGenerator is used to generate a new ID for the loan application aggregate to be created and a service ICustomerLocator is used to locate a customer having the given email address and return its ID. This ID is then used to re-hydrate the customer aggregate using the repository. Then we call the StartNewApplication method of the customer aggregate which will return a new instance of a loan application aggregate. Finally the (modified) customer and loan application aggregates are persisted using the repository.

The respective (simplified) code in the customer aggregate might look like this

[gist id=b1a7228d74c63daff168]

As we can see each aggregate remains pretty much self centered and really doesn&#8217;t care about its environment and the whereabouts. The application service is responsible for the orchestration of multiple aggregate instances.

## Generic vs specific commands

One of the most problematic things that I regularly stumble across is the fact that developers are using very generic commands. When we are used to a CRUD based approach where we have insert, update and delete commands and all of a sudden want to write an application that uses DDD we might be tempted to continue using these or similar types of commands. But the reason why we want to used DDD in the first place is the fact that the application is complex and involves some rather involved business logic and processes. In such scenarios we need to make sure that we keep the complexity of the domain under control. One important way to do so is to make our commands explicit and specific.

To give a concrete sample let&#8217;s assume we have the following command

[gist id=02301345aad7257fe33b]

which is used to update certain properties of an existing loan application. Easy enough you might think. No! Why not? This seemingly harmless command leaves a lot of questions unanswered and the back-end code that handles this command has to do a lot of guess work. What was the intent of the user when this command was triggered? What exactly changed. Did every property change or only a single one. What edge cases do we have to consider, etc. The validation logic and the business logic become extremely complex over time the more properties this very generic command includes.

It is much much better to have very precise and intention revealing commands that are focusing on an explicit scenario that is limited in scope like

[gist id=0adcd18662e88f6ff895]

or

[gist id=8cf41bb2e29294e68774]

or

[gist id=28720785fc47d4225016]

or

[gist id=435c96fdc0a69b627e39]

technically we could have used the one generic update command to use in all four scenarios and thus avoid to have many different command classes. But the drawbacks of this approach by far outweighs the advantage.

Specifically note how some of the properties of the generic update command need to have their type defined as nullable since we do not always have a value for all of the properties depending on the scenario where we use the command. Contrary to that every single property of a specific command is required. It is strictly part of the delta that is going to change. Thus we don&#8217;t need any special validation like &#8220;if this property is there then that property should not be defined&#8230;&#8221;, to give just one sample.

Also note that we have the property **Status** in the update command. That is we expect the UI layer to provide us this information thus burdening the UI with unnecessary responsibilities. With specific commands we never need to include the status of the entity since the command is explicit in its context and intent.

## Summary

In this post I have discussed two more scenarios that might not be straight forward but when done wrong can make our lives cumbersome. In the first scenario I have shown how we can orchestrate the collaboration of multiple aggregate instances of the same or different types. In the second sample I have discussed the pros and cons of generic versus specific commands.