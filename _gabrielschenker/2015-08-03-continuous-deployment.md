---
id: 1110
title: Continuous deployment
date: 2015-08-03T18:47:29+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1110
dsq_thread_id:
  - "4000657342"
categories:
  - continuous deployment
  - introduction
  - Uncategorized
---
These days everybody wants to try new ideas as quickly as possible in the market. We want to see whether or not our customers like a new feature. If yes then we want to work on the feature and improve it and if not then we want to fail fast and learn fast from the mistake and correct fast.

To be able to do this a company producing mission critical software can embrace continuous deployment (CD). CD is not a tool nor a simple process, it is a whole pipeline of processes and associated culture changes in the company. CD in a nutshell manifests itself in such a way that if a developer finishes coding a new feature and pushes this feature to a central code repository then a process starts whose end result is that the code containing the new feature is in production and the feature is thus available to the consumers. All this happens fully automated and without any human intervention. This sounds scary, doesn&#8217;t it? Yes and no&#8230; but let&#8217;s look into more details what exactly CD implies.

## Culture change

Due to the fact that when a developer pushes code it is deployed to production without any human intervention means that we have to change the way how we structure the software development process. There cannot be any departments with very specific responsibilities anymore. No more separation between PM, Development, QA and operations. No more walls between those departments. No more people throwing things over the wall. There must be one team responsible for a product or a feature from end to end. And when I say from end to end then that means starting with analysis and design followed by implementation, testing and acceptance until and inclusive deployment into production. Everyone in the team is responsible for the whole process to succeed. Of course we will continue to have specialist having certain roles in our team. But everyone is member of the same team and works collaboratively to achieve the end goal.

## Small changes

There is an inherent truth that &#8220;big changes imply big risk and small changes imply small risk&#8221;. It is our goal to mitigate risk. Thus we are trying to keep our changes small that we want to deploy to production. We&#8217;d rather have multiple deployments to production, each one containing a rather small small change set than on big change. Since everything is fully automated as mentioned above in the definition of CD, deploying multiple times to production per day is not an issue and many well known and successful companies are already doing it with great success.

## Branching strategy

Here I am assuming that the team uses Git and a service like GitHub, BitBucket or similar. Since every change we make to the system goes immediately into production there is no need any more for sophisticated branching strategies like GitFlow or similar. A developer implements her new feature (or bug fix) on a feature branch. When she&#8217;s ready she does a pull request against the master branch and the pull request is reviewed by her peers or team lead. If the pull request is accepted by the reviewer(s) it can be merged into master. This will trigger the CD pipeline and a few minutes later the new feature or bug fix is in production.

Like this there is no need to have a develop branch or any other long living branch. The goal is to keep each feature branch as short lived as possible, ideally not longer than 1 or 2 days.

## Partially completed features

Sometimes a feature is too big to complete in one task. Each task should take no longer than one to two days to complete. Thus we often have the situation where a feature needs to be split into multiple tasks, each one taking a developer say one day to implement. In such a situation we use feature toggles to avoid that a feature that is only partially implemented is exposed in production. The code is still there in production it is just deactivated by the feature toggle. Once the feature is completed the feature toggle can be removed.

By pushing incomplete features to the master branch we avoid long living feature branches and the more than likely merge conflicts that are associated with long living branches.

## Works on my machine

We all know the story of Joe the developer who always produces code that works on his machine but not on any other environment, right? What can be the cause for this? Most likely it is either &#8211; and God forbid &#8211; that Joe did use some absolute file paths or relied on machine specific settings, or also very likely Joe is using some libraries that have a different version than the ones installed on the other environments.

How does CD overcome these problems? The idea is that we work with identical settings and configurations in all environments. This requires that we do not provision our environments manually but in a fully automated way; that is we are scripting our environment. This is called &#8220;infrastructure as code&#8221;. Tools that help us to achieve that goal are Chef, Puppet, Ansible, bash or Powershell scripts, etc. Most relevant cloud providers assist us with many services, e.g. Amazon AWS provides services like CloudFormer.

What does this mean? This means that when we need to deploy our artifacts that are built from the code containing a new feature to a new environment (say integration) then we do not use an existing environment but create this environment from scratch using code generated and maintained by the above tools. That is, in a cloud we would instantiate new VMs from scratch and configure them however we need them and then deploy our artifacts to these new instances.

## Production like environment on my laptop?

OK, what I just said above works very well in the cloud, but what about my laptop? Even if a developer has a pretty powerful laptop it is hard to run more than 1 or 2 VMs concurrently on it. But if we are developing a somewhat complex and mission critical application we have a lot going on and this results in the fact that we need a big number of VMs. What to do?

In this situation we can leverage containers as provided to us by Linux. The Linux OS defines the necessary infrastructure to run applications or services in a container which completely isolate the application or service from all other applications and services. At the same time a container sits on top of the host OS and abstracts it to the contained application/service. Thus a container is much leaner than a VM since it does NOT contain its own OS. Docker is such a container system. By using we can reproduce a production like environment using a single VM on our laptop.

Unfortunately only Linux currently supports containers. OS-X and Windows will be supported in the near future. A Windows based Docker image is in the make.

## The CD pipeline

The image below shows how a simple CD pipeline could look like. It is a very rough picture but it gives a good idea of the overall process.

[<img class="alignnone size-full wp-image-1119" title="pipeline" src="https://lostechies.com/gabrielschenker/files/2015/08/pipeline1.png" alt="" width="1443" height="771" />](https://lostechies.com/gabrielschenker/files/2015/08/pipeline1.png)

### Step 1

Let&#8217;s now look at the individual steps. As a developer has finished her feature she merges it into the master branch. This triggers the CI server to compile the code and build new artifacts. The artifacts are tested by running unit and integration tests. If everything is OK the process continues with step 2 otherwise everything is aborted and the developer gets notified.

### Step 2

Since step 1 was successful the artifacts are promoted to integration. First the CI server triggers the fully automated provisioning of an integration environment and if successful triggers the deployment of the artifacts to this new environment. Then tests are run against the artifacts. If everything is OK the process continues with step 3 otherwise everything is aborted and the developer gets notified.

### Step 3 (optional)

Step 2 was successful and the artifacts are promoted to the performance testing environment. Once again the CI server triggers the fully automated provisioning of the performance environment and if successful triggers the deployment of the artifacts to this new environment. Now performance and load tests are run against the new artifacts.  If everything is OK the process continues with step 4 otherwise everything is aborted and the developer gets notified.

### Step 4

Artifacts are now ready to be promoted to the staging environment which will become our new production if all works as planned. If the application is very complex and consists of many elements like auto scaling groups, reverse proxies, gateways, etc. then we will not want to recreate the whole environment from scratch for each deploy but only the elements that are affected by our deployment; say a particular VM or scaling group. On the other hand if the application is simple that we should do as we did in the previous steps and create everything from scratch using the infrastructure code. Once the environment is ready we run some infrastructure tests that make sure our environment is configured as expected (e.g. the right ports are open, correct drives are mounted, certificates are installed, etc.). Finally we deploy the artifacts.

### Step 5

Now we do A/B testing using a reverse proxy between staging and production. Say we start by funneling 10% of the traffic through the new code on staging and the remaining 90% remain on production. The application logs issues and errors as well as performance data to a central hub. Some automated logic is then used to compare the performance and behavior of the new code against the previous release. If everything looks good the traffic through the new code is increased until it reaches 100%.

[<img class="alignnone size-full wp-image-1115" title="A/B teesting" src="https://lostechies.com/gabrielschenker/files/2015/08/step5.png" alt="" width="646" height="537" />](https://lostechies.com/gabrielschenker/files/2015/08/step5.png)

Staging has now become the new production and the previous production code is idle. We keep it around for a bit until we are confident that the new production is stable. If something goes terribly wrong and a bug has been introduced in the new production code we can roll back to the previous release in no time. Otherwise we can decommission the old release.

Note that all this happens fully automated!

## My customer has doubts

Hey it is normal for people to have doubts that CD can actually work without any human intervention. Maybe it is not even our customer but our team that is doubtful. In such a situation we can slightly change the process and do what is called **continuous delivery**. The difference between CD and continuous delivery is that in the latter case a human &#8211; most probably a QA person &#8211; can pull the trigger and decide whether or not a feature can go to production or not.

Over time as we see how things go into production and cause no problems confidence will increase and we can eliminate this human &#8220;bottleneck&#8221;. Who wants to sit there and pull the trigger 20 or more times a day?

## Conclusion

We have seen that implementing continuous deployment is a major undertaken. There is no single solution to the problem. Many steps are necessary to achieve the goal. Most importantly we also need a corresponding culture change in the company that wants to embrace continuous deployment. Naturally the customer we are producing the software for must also be on the same boat.

In my next posts I will discuss individual elements of the CD pipeline in more detail. Keep tuned&#8230; and please share your own experiences with CD in the comments. Thanks