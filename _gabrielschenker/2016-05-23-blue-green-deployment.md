---
wordpress_id: 1521
title: Blue-Green Deployment
date: 2016-05-23T21:11:42+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1521
dsq_thread_id:
  - "4852604738"
categories:
  - Architecture
  - CI/CD
  - continuous deployment
  - Design
  - How To
  - Patterns
---
# Introduction

These days our customers expect their applications to be up and running all the time and literally experience no down-time at all ever. At the same time we should be able to add new features to the existing application or fix existing defects. Is that even possible? Yes, it is, but it is not for free. We have to make a certain effort to achieve what is called zero-downtime deployments.

This post is part of my series about [Implementing a CI/CD pipeline](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/). Please refer to [this](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/) post for an introduction and a full table of contents.

# Zero down-time

If we need to achieve zero down-time then we can not use the more classical way of deploying new versions of our application. There we used to stop the current version of the application and put up the maintenance page for all our potential users that wanted to use the application while we were deploying. We would tell them something along the line

_&#8220;Sorry, but our site is currently down for maintenance. We appologize for the inconvenience. Please come back later.&#8221;_

But we cannot afford to do that anymore. Every minute of down-time signifies a lot of missed opportunities and with that potential revenue. So what we have to do is install the new version of the application while the current version is still up and running. For that we need to either have additional servers at hand to which we can install the new version or we need to find a way how we can have to versions of the same application running on the same servers. This is also called a **non destructive deployment**.

Since we leave the current version running while we deploy the new bits we (usually) have more time to execute the deployment. Once the new version is installed we can run some tests against it &#8211; also called smoke tests &#8211; to make sure the application is working as expected. We also use this opportunity to warm up the new application and potentially pre-fill the caches (if we use any) so that once it is hit by the public it is operating with maximal speed.

It is important to notice that during this time the new application is not visible to the public and we can only reach it internally to e.g. test it. Once we&#8217;re sure the new version is working as expected we reconfigure the routing from the current version to the new version. This reconfiguration happens (near to) instantaneous and all public traffic is now funneled through the new version. We can keep the previous version around for a while until we are sure that no unexpected fatal error was introduced with the new version of the application.

# Rollback

Bad things happen, it&#8217;s just a sad truth. Sometimes we introduce a severe bug with a new release of our software. This can happen no matter how good we test. In this situation we need a way to rollback the application to the previous know good version. This rollback needs to be fool proof and quick.

When we are using zero-downtime or non-destructive deployment we gain this possiblity for free. Since the new version has been deployed without destroying or overwriting the previous version the latter is still around as long as we want after we have switched the public traffic over to the new version. We thus &#8220;only&#8221; need to redirect the traffic back to the old version if bad things happen. Again, re-routing traffic is a near instantaneous operation and can be fully automated so that a rollback is absolutely risk-free.

Compare this with a rollback in the case of a classically deployed application which used to be destructive. Once the new version was in place the old version was gone. One had to find the correct previous bits and re-install them&#8230; a nightmare! Most often the necessary steps to execute during a rollback were maybe documented but never exercised. A huge risk and nerve wrecking for everyone.

# Schema Changes

The attentive reader may now say: &#8220;Wait a second, what about the case where a deployment encompasses breaking database schema changes?&#8221;

This is an interesting question and it needs some further discussion. I will go into full details in an upcoming post dedicated to this topic. Suffice to say at this point that there is a recommended best practice how to exercise breaking schema changes in situations like these. In a nutshell, we need to deploy schema changes separately from code changes and ALWAYS make the schema changes such as that they are backwards compatible. I promise, I&#8217;m going to describe the how and why in much more details in this upcoming post. Please stay tuned.

# Blue-Green Deployment

Ok, now we have spoken about **non destructive deployment** and **zero downtime deployment**. There are various ways how this can be achieved. One is called **Blue-Green Deployment**. In this case we have a current version up and running in production. We can label this version as the **blue** version. Then we install a new version of our application in production. This time we label it with the color **green**. Once **green** is completely installed, smoke tested and ready to go we funnel all traffic through it. After waiting for some time until we are sure that no rollback is needed the **blue** version is now obsolete and can be decommissioned. The **blue** label is now free. When we deploy yet a newer version we will call it the **blue** version, and so on and so on. We are permanently switching from blue to green to blue to green.

# Implementation Details

Let&#8217;s assume we are going to use blue-green deployment for a micro service called `Foo`. This service `Foo` is currently running in production and is at version `v3`. In a blue-green scenario each service has a color assigned. Let&#8217;s assume that we are currently `blue`. So far we talked about a logical service when we talked about `Foo`. But now let&#8217;s go to the physical components. Since our service needs to be highly available we run at least three instances of the service. We call them `Foo-1-blue`, `Foo-2-blue` and `Foo-3-blue`. These are now 3 physical instances of the logical `blue` service `Foo`. They run on different nodes (where node is either a VM or a physical server). We have a **reverse proxy** in front of the service which load-balances the traffic to the 3 instances using e.g. a round robin algorithm. We can use e.g. **Nginx** or **HAProxy**, etc. for this task.

If now another service say `Bar` needs to access `Foo` then it will make the request to a load balancer or reverse proxy which makes the **color** decision. Currently this one is configured to route the traffic to `blue`. For clarification please see the graphic below

[<img src="https://lostechies.com/gabrielschenker/files/2016/05/Foo-blue.png" alt="" title="Foo-blue" width="408" height="265" class="alignnone size-full wp-image-1525" />](https://lostechies.com/gabrielschenker/files/2016/05/Foo-blue.png)

Now it is time to deploy `v4` of the service `Foo`. This new version gets the color `green` assigned. We once again for high availability reasons deploy 3 instances of the new version of the service. We call those 3 instances `Foo-1-green`, `Foo-2-green` and `Foo-3-green`. These 3 instances can be deployed to new nodes or if possible and requested coexist with the blue versions on the same nodes. Once we have smoke-tested and warmed up the new instances we can now reconfigure the router that controls the color. It will now funnel all public traffic through the `green` version as shown in the graphic below.

[<img src="https://lostechies.com/gabrielschenker/files/2016/05/Foo-green.png" alt="" title="Foo-green" width="491" height="529" class="alignnone size-full wp-image-1528" />](https://lostechies.com/gabrielschenker/files/2016/05/Foo-green.png)

As you can see, the `blue` version of the service is still there and can be used in case we have to exercise a rollback.

# Summary

In this post I have discussed in detail what zero-downtime deployments are and how this can be achieved by using the technique on non-destructive deployments. One variant of this latter technique is the so called blue-green deployment. These days this is a technique frequently used in fully automated CI/CD pipelines. This post is part of a series about [Implementing a CI/CD pipeline](https://lostechies.com/gabrielschenker/2016/01/23/implementing-a-cicd-pipeline/).