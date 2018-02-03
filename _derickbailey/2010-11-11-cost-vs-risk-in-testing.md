---
wordpress_id: 196
title: Cost vs. Risk In Testing
date: 2010-11-11T16:07:41+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/11/11/cost-vs-risk-in-testing.aspx
dsq_thread_id:
  - "263664547"
categories:
  - Analysis and Design
  - Pragmatism
  - Productivity
  - Quality
  - Risk Management
  - Testing
---
There was a bit of interesting discussion on twitter this morning, concerning the cost of test-first vs. risk. Here’s the visual version of what I’m saying:

[<img style="border-bottom: 0px;border-left: 0px;padding-left: 0px;padding-right: 0px;border-top: 0px;border-right: 0px;padding-top: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_thumb_780D2BFD.png" width="640" height="341" />](http://lostechies.com/derickbailey/files/2011/03/image_72328864.png)

The premise behind the value of test-first is that we will wash out (or reduce) the cost of a system over time by having a system that is easier to maintain, etc. I believe in the value of test-first development and I have seen the benefit that it creates when done right. I’ve also seen the downside of it when done poorly or in the wrong circumstances.&#160; Notice that I’m not putting any specific numbers on this chart. I left any specific numbers off the chart because the context of every application, every team, ever customer and everything else involved in a system is going to change the numbers and modify the curves. 

There is a cost associated with a test-first approach. If you put in 100% unit test coverage, and 100% integration test cover and 100% end-to-end functionality test coverage, then you end up with 300% coverage of your system. Is the cost of maintaining 300% coverage worth it in your system? Can you get away with a grand total of 100% coverage while limiting your system to an acceptable amount of risk?&#160; Do you even need 20% coverage to reduce the risk to an acceptable level? Does it make sense to take on a test-first approach for a given feature, system, bug fix, etc? What’s the risk vs cost? Is there a mixed approach of getting it done now and writing a test for it later, that will provide both risk mitigation and cost effectiveness? 

I can’t answer these questions for you. Your answers will vary depending on a large number of factors. For example, a startup on it’s first iteration of a product may not find any value in a test-first approach while a well established business creating critical systems for itself or a client will likely find the risk of not using test-first development too high. You have to consider the cost vs risk in your specific circumstances. Find the sweet spot for your circumstances and don’t assume that the sweet spot for two different projects will ever be the same. Don’t be surprised when you realize that the sweet spot changes within the same project, either. Sometimes the sweet spot will be test-first. Sometimes it will be test-after. Sometimes it will be not to bother with an automated test at all. 

Be pragmatic, not dogmatic, about your approach to testing and development.