---
wordpress_id: 4427
title: Testing microservices
date: 2016-01-11T19:47:30+00:00
author: Andrew Siemer
layout: post
wordpress_guid: http://lostechies.com/andrewsiemer/?p=133
dsq_thread_id:
  - "4482411862"
categories:
  - Microservices
---
This morning I was asked about a super high level talk I gave a while back: [Grokking Microservices in 5 Minutes](http://www.slideshare.net/asiemer/groking-microservices-in-5-minutes-47955679?qid=5b8a83f0-c2fe-444a-bb9e-13625216507d&v=qf1&b=&from_search=1).  Specifically regarding the testing of microservices.  One of the more difficult parts to building tiny things that collectively form big things.

The question was around the &#8220;shared pool&#8221; of tests and how to do that.  There are many ways to implement the shared pool concept.  But first let&#8217;s discuss why having a shared pool of tests might be important.

If you have gone down the microservices path, or are currently responsible for the appropriate care and feeding of a monolith and are starting to think about carving it up into smaller service pieces &#8211; you want to be sure to understand how to test what you are building.  A great image for why this topic is important is this.  The simple act of going from a behemoth app to many small apps can result in a yard littered with smaller piles of behemoth code!

[<img class="alignnone size-full wp-image-136" title="stateless-authentication-for-microservices-12-638[1]" src="http://clayvessel.org/clayvessel/wp-content/uploads/2016/01/stateless-authentication-for-microservices-12-6381.jpg" alt="" width="638" height="479" />](http://clayvessel.org/clayvessel/wp-content/uploads/2016/01/stateless-authentication-for-microservices-12-6381.jpg)

To safe guard you from this transition understanding how to maintain services so that they remain non-brittle is important.  Aside from ensuring that your system is built to fail in a manageable and expected way (another discussion) you also need to invest in the flexibility to move fast.  This means testing your boundaries to ensure that breaking changes are caught early.  Microservices allow you to move fast with product iteration in small batches.  But as your service becomes a dependency for another up stream service they will inevitably take a contract dependency that needs to stay strong.

There are many ways to ensure that you don&#8217;t break contracts &#8211; versioning is one.  And that should be in place from day one.  But subtle changes in your underlying systems could potentially have impact on how things are being consumed externally.  The more past versions of your software you need to keep around, the more likely these subtle changes could impact your consumers in ways you haven&#8217;t thought of (perhaps you have a bunch of apps using your API for example, and they can&#8217;t always keep up with your release schedule, meaning you need to keep older versions around for a while).

It becomes important for you to test your assumptions of your services to ensure that your contract does what it says it will do.  This is the first layer of keeping your service reliable for teams that take a dependency on your service.  But you can only guess at how your customers are using your service.  The next level of testing is to allow your consumers to publish tests to you (internal, not your customers or third party developers).  They will write the tests based on how they use your service &#8211; not how you envision them to use your service.  These tests can be part of your CI and will alert you to any place (way early) that your internal tweaks have broken an upstream relationship with your consumers.

## How do we support shared testing?

But how?  Unfortunately this is where it heavily depends on the language/framework you have chosen to utilize for your testing and your application.  There are lots of ways to do this, but in my .net world this might look like an integration test project that is versioned along with the service I am building that consumers can commit tests into (via pull request).  The team that builds the service owns the code repository.  The team that is using my service can contribute tests to this particular test project in the code repo of my service.  You might have an IntegrationTests project sitting next to a ConsumerTests project.

This model works great for small teams or single teams in that they become the publisher of all tests.  But scales well to multiple teams building/owning their own services as all tests for a given service live local on the dev machine and seamlessly fit into the CI story.  Everyone understands the moving pieces.  And the tests live and are versioned with the service.

As your enterprise grows, or you are already not in a .net team, you may pick another framework and test runner to centralize around.  But the concept is the same.  You need a mechanism that watches for commits to your code base that will know how to run your consumer tests.  And a way to allow your consumers to give you tests that represent their usage of your contracts.  This can be done in many clever ways!

## But what about supporting multiple versions of a service?

But what if you need to keep several versions of a given service and it&#8217;s API alive for longer periods of time?  This is an even more grey area.  I will speculate from here: if you are living in an infrastructure as code world, part of standing up an environment for a version of your software that is intended to live in prod should have an integration path.  Keeping the shared tests alive for each running prod version is the best way for this as it allows you to iterate on the prod version (so that you can do hot fixes along the way) and still run the appropriate tests.  Again, if the tests live with the code, and you are using a branching model that supports hot fixes separate from new features/versions, this should be easy enough to manage.

## Don&#8217;t forget to test the system as a whole

Once you tackle integration testing the microservice your team is responsible for, and you provide a mechanism for consumers of your service to contribute tests around how they use your service, make sure that you also have tests for how the application as your customer sees it is also tested! (functional tests from the UI back)

While it is important to ensure that first level boundaries are tested, it is equally important that you don&#8217;t forget about the user and their experience.  A user has an expected experience.  If you are a commerce app this means that a user needs to browse, search, read about, and select products.  Add products to a cart, manipulate the details of a product in the cart, and eventually purchase the product.  Once they have placed an order there may be back office processes that need to occur.  Eventually a customer will get notifications about their order, when items ship, etc.  And there may be support for a customer to complain.

All of these things touch the customer and need a story to validate that the experience works as they would expect it.  And if you have a mobile app and a web app then you likely have a few things to test.  The mobile APP UI, the web app UI, and the API that drives each of them.  [I covered some strategies for building and maintaining an API](http://www.slideshare.net/asiemer/making-your-api-behave-like-a-big-boy?qid=c793b9f7-abff-47a9-9254-612d0ecc88d2&v=default&b=&from_search=1).  I have not really covered the UI bits as much (though many other folks have written about that).

There are lots of ways to piece together a UI from a microservices collection.  You might treat the UI as something to apply this microservice concept too where each of your application is self contained.  Or you might build a microservice as a feature where the backend and front end code live together which would then become a mash up as a SPA or similar.  Lots of options.  Testing for each of those options might be subtly different.

The key here is that you don&#8217;t forget that one type of testing likely doesn&#8217;t remove the need for another type of testing.

## Some reading/experiences from others wading into the microservices trend

Most of these articles talk about testing in some form.  However, a lot of people struggle when tackling testing.  In which case, read through the comments.  There is always loads of gold in the comments!

<https://blog.yourkarma.com/building-microservices-at-karma>

<https://www.opencredo.com/2014/11/19/7-deadly-sins-of-microservices/>

<http://www.infoq.com/articles/microservices-practical-tips>

## Other articles I stumbled across along the way

[Great article on how to think about Microservices](https://auth0.com/blog/2015/11/07/introduction-to-microservices-part-4-dependencies/) (part 4 of a 4 part series).

<https://www.nginx.com/blog/microservices-at-netflix-architectural-best-practices/>