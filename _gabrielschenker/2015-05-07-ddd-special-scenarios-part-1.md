---
wordpress_id: 964
title: 'DDD &#8211; Special scenarios, part 1'
date: 2015-05-07T22:10:09+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=964
dsq_thread_id:
  - "3746174577"
categories:
  - DDD
  - Design
  - How To
  - practices
---
## Introduction

In the last two posts ([here](https://lostechies.com/gabrielschenker/2015/04/16/ddd-revisited/ "DDD revisited") and [here](https://lostechies.com/gabrielschenker/2015/04/28/ddd-applied/ "DDD applied")) I first revisited domain driven design (DDD) in general and then I showed how we apply DDD on a realistic sample domain. For most people DDD sounds very compelling but as always the devil lies in the little details. Thus I often get asked how we solve specific scenarios. In this post I will show possible solutions for two of them.

## Special scenarios

### Generating new aggregate instances

When generating new instances of an aggregate we need a new globally unique identifier for this instance. There are different possibilities how we can achieve this.

  * Generate the unique ID on the client and send it with the command that triggers the creation of a new instance
  * Generate the unique ID on the server and return it to the client in the response of the command

Let&#8217;s assume that I need to enter at least my first and last name as well as my email address to be able to start a new loan application. In the former case my command would then look like this

[gist id=3934e55ab7ab7f0f6ac6]

Note that the (Loan Application) ID is part of the command since in this scenario we generate the ID on the client. When generating the ID on the client we most probably will want to use a data type that makes it easy to generate globally unique value. A Guid is the most logical choice.

If on the other hand I generate my IDs on the server then the corresponding command looks like this

[gist id=c4a6cae8a6f707efc321]

As you can see, no need to pass an ID to the backend. In both cases we might want to send our command to a REST-ful endpoint, e.g. <URL>/api/applications/create. If we use ASP.NET Web API with attribute routing our controller might look like this

[gist id=a606e062c7ad0ead3c15]

The above implementation is for the scenario where we do deliver the unique ID from the client. In this case we do not need to return anything in the response to the client; it suffices to respond with a status code 201 (created).

On the other hand if we need to create the ID on the backend then we might want to use a service for this purpose. A service that implements the following interface would work well for this

[gist id=b3e182c025ff99b817da]

We can now modify our controller and inject this service.

[gist id=c2d4d89f63ee69bb5695]

as you can see we use the service to generate a new ID. We also return the ID in the payload of the response to the client. Note that this is not a violation of CQRS since the id is not much more than part of the acknowledgment that the command has been successfully executed &#8211; similar to the status code 201 (created). It is important to note that we only return the ID and not the whole state of the newly created aggregate instance.

### Handling business rule violations

When dealing with line of business applications the we most certainly have some business logic that the aggregate must implement and some business rules that it enforces. Whenever a client sends a command to the backend which will be handled by an aggregate it can happen that the aggregate refuses to execute the command since some business rule(s) would be violated. As an example take the situation where the command AcceptLoanOffer is applied to the aggregate but the aggregate is in a state where this is not possible (e.g. no offers have yet been made to the applicant). In such situations we need to communicate this back to the client. We could just throw an exception which would result in a status code 500 (internal server error) returned to the client.

[gist id=4979de29eb9c3f5f8fb0]

This is perfectly fine if we follow the principle that each command should be highly likely to succeed. How can we achieve this principle? Well, one way is to implement the client in a way that it makes some pre-checks prior to sending a command by e.g. querying the backend for certain information (in this particular case whether or not the offer can be accepted) and not sending the command at all if the pre-conditions are not fulfilled.

But this is not always very helpful, specifically if multiple business rules can be violated at once and we want to display the reason(s) of the failure to the user of the application. In this case we can modify our aggregate like this and provide a broken rules collection

[gist id=7e5772a7d6f521ce4468]

Now the application service can use this information to generate a standard response to the client which might or might not include broken rules

[gist id=2e18e6d71d729a49afc7]

As our aggregate grows and we add more and more logic to it we can then refactor this code and extract the common code into a helper method which is called by all public methods

[gist id=12d56521c03e6bbcc559]

In the above sample I have created the helper method Execute that handles all the plumbing code such as that the actual methods (here to accept an order and to on-board a loan application) are simple.

Finally the controller which uses the application service would look like this

[gist id=b3005956f447bbd12d90]

Note how we return a status code 400 (bad request) if there are any broken rules and we add the list of broken rules to the body of the response to the client. The client can then use this information and e.g. display is to the user. If on the other hand there are no broken rules then we just return status code 200 (OK).

## Summary

In this post I have shown possible approaches how one can solve specific scenarios when using DDD and possibly CQRS. The first scenario dealt with the problem of creating new instances of an aggregate and dealing with the unique ID that is required to identify this new instance. In the second scenario I discussed how one can deal with possible violations of business rules enforced by the aggregate. As always, there exist multiple approaches how one can solve these problems; my post shows the approaches I have used in the past.