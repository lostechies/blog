---
wordpress_id: 4422
title: Huge Scale Deployments
date: 2015-08-28T15:18:47+00:00
author: Andrew Siemer
layout: post
wordpress_guid: http://lostechies.com/andrewsiemer/?p=51
dsq_thread_id:
  - "4075558430"
categories:
  - Scale
---
What are the best practices for supporting huge-scale deployments? How do you manage fidelity of environments and processes, monitoring, blue/green deployments and more across thousands of servers?

Earlier this month, I participated in an online panel on the subject of [Huge Scale Deployments](http://electric-cloud.com/blog/2015/08/continuous-discussions-c9d9-episode-23-recap-huge-scale-deployments/), as part of Continuous Discussions (#c9d9), a series of community panels about Agile, Continuous Delivery and DevOps. Watch a recording of the panel:

Continuous Discussions is a community initiative by [Electric Cloud](http://electric-cloud.com/resources/continuous-delivery-101/continuous-deployment/), which powers Continuous Delivery at businesses like SpaceX, Cisco, GE and E*TRADE by automating their build, test and deployment processes.

Below are a few snippets from my contribution to the panel:

**The practice of huge-scale deployments**

“In the previous company I worked at we had a situation where the huge-scale deployment was a multi-team, highly coupled system made of multiple interwoven systems. You’d be on a call bridge for days, literally, people roll off go to sleep for 2 hours and come right back. Yes, you shouldn&#8217;t change configurations on the fly, you shouldn&#8217;t do anything manual, everything is automated, whether it’s virtual or physical hardware.

“Having these huge coupled systems – you  have to stay away from it, whether you use microservices or autonomous components, whatever – you should have a small enough surface area of tests, parts that can go down their own deployment path. If it’s side by side or whatever your deployment strategy is, you slowly drain traffic over to the new component, test it out, you can assure it actually works. It’s a small change, not an entire system change all at once, with a queue of work that people are sitting in.”

**Fidelity of environments**

“I think it’s easy to come up with data to look at all the inefficiencies. We all enjoy analyzing inefficiencies to make things more performant. I find it easy to convince people who live in the trenches, they’re on these crazy deployment calls, they own the deployments. It’s usually middle management, the people who own siloes or own a budget, they’re usually somewhat in the way, if I can put it that way, but ultimately you need to justify fidelity of environment to the people at the top that control the purse strings, or above that.”

“There’s a YouTube video with a [conference talk](https://www.youtube.com/watch?v=6FPXbQ2WpAM&safe=active) by ING that talks about the justification of Continuous Delivery and the automation to make stuff go live quickly. They had to put in place the culture change, what needs to happen, and that is – if you’re in the way you’re not here anymore. We need to understand what we do as a company, we deliver product and features, that’s what allows us to innovate, if you’re in the way of that you don’t work here anymore. That’s huge.

“But in a bigger company you’ve got the middle management who really don’t want their cheese to move. They’ve got to move their cheese, or get on the bus and then everything’s easy. We can justify it.  We can make it happen, it’s not hard, it’s just changing the culture.

“We had a client who had a bad experience in the cloud. They’re trying to justify their virtual environment, and they own a lot of hardware but they don’t have the staff to support going to the cloud. So okay, that’s easy to solve, we can find people who can get you in the cloud the right way, but then it’s a discussion of OPEX vs. CAPEX, how do we justify the infrastructure we’ve already invested in, even if it’s not supporting our needs.”

**Fidelity of process**

“I find that process has to be fully transparent, from up in the dev process all the way to production. We frequently see a run book that has every single detail for going to production. The reason they need the transparency of going to production, is they need to have step-by-step from all the errors of the past, ‘oh, if this happens you need to do step 552’. It speaks to the lack of automation up to that point and through that point.

“Generally we have engineers of the team who have experienced the pains of doing things different in each environment. It’s usually not a fight once the team is enabled to invest time in automation. We try to get most of our clients to a virtual environment, we preach heavily that environment is code, it’s all checked into source control. There are no manual changes, you need to make the change in code base or configuration, and then the change flows out appropriately.

“In slightly more risk-averse organizations, maybe they need Bob the executive to approve it and they queue up waiting for the approval, but then it continues to flow in the automatic process. Or – continuous deployment where everyone wants to get to in my opinion, as soon as I commit code it automatically goes through all those steps and then it makes things go live.

“As for the Continuous Delivery idea of making deployment a business decision – it’s an educational topic. What if I tell you we can get the binaries delivered to production, where we see how that component reacts to traffic? Whether through feature toggling or whatever the configuration strategy is, get the bits out there and even have it turned off, but have it sit around code that is running in production and it’s much easier to solve things earlier on. It’s kind of like a branching story, the longer you wait to merge it into production environment the bigger of a story it’s going to be.”

**Monitoring, feature flags, blue/green deployments, canaries**

“We’re working with large customers, big systems, but small staff. We try to preach for a single light that tells you if your system is up or down. If it’s red, we have systems that dig in to see what the problem is. Metrics, tracking of things that are important – X number of items in the cart, people checking out, and business value. We don’t only check that the system is working, we also check the business value, see that this particular activity that is important to the business owner is happening with a certain frequently.

“We use StatsD and hosted Graphite for the graphs. We create dashboards that show lines of what’s happening in the system and you can look throughout the day and see if that’s expected behavior. And then watch it when there’s a deployment or a configuration change. Normally have this humpback throughout the day, and now I made a deployment and it flat-lined.

“Something like Newrelic helps you monitor disk, CPU, that the tools you’re running on are also working as expected. We’re also monitoring message-based stuff, queues, which shows my system behavior when going from one service to another making sure that’s not clogged up. Going back to that light, so we have “everything’s good”, but when things are bad, we’ve thought about that, and the systems we have in place will tell us that things are broken.

“Very often it’s a new project or a client who brings a monolithic system they just can’t add features to. The notions we talk about is “definition of done” at different levels in the process, and “iteration zero”, these are the things we expect in the project. Here is the runtime, the CI, we now talk about CI/CD, the CI build scripts that run locally, as time goes by we introduce infrastructure as code, metrics, logging and monitoring, we build up the iteration zero story. They know how to write code but don’t know how to support things in production, we try to build it up so it becomes part of their DNA.”