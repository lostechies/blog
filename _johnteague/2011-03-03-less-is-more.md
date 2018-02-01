---
id: 3782
title: Less Is More
date: 2011-03-03T05:16:00+00:00
author: John Teague
layout: post
guid: /blogs/johnteague/archive/2011/03/03/less-is-more.aspx
dsq_thread_id:
  - "262055790"
categories:
  - Uncategorized
---
I started a new project this year and part of my responsibilities is gathering requirements and converting them to user stories and acceptance criteria. &nbsp;It&#8217;s been a very interesting experience for me and put me a little out of my comfort zone. &nbsp;I&#8217;ve been sheltered most of my career, with someone else there to drive out these requirements. &nbsp;It&#8217;s actually taught or reinforced a lot of things that I think are very important.

### Distilling to Minimum Viable Product

Before this project I was sharing office space at a startup incubator, where people with an idea were given some direction and focused on what they really need to do first as a startup: get customers. &nbsp;One term I heard over and over was Minimum Viable Product. &nbsp;What is the smallest thing of value you can launch with? &nbsp;I&#8217;m taking the same approach with an enterprise application: what&#8217;s the smallest set of features you need to stop using you&#8217;re homegrown excel application. &nbsp;The interesting thing to me is that I&#8217;m not just reminding the business owner, but also myself.

### Do the simplest thing that works until it doesn&#8217;t

What&#8217;s the simplest thing you can do to solve the problem but also follows sound software design principles? I&#8217;m not saying you should cut corners on your architecture to complete the application quickly, in fact the opposite. &nbsp;No matter how well you can elicit requirements from business owners and no matter how many thought provoking questions you ask, until users start using the application, the users simply won&#8217;t know everything they need until they start using the application. &nbsp;By using a modular design that&#8217;s has easy to replace functionality you can keep the process simple and change it when you have better information

### YAGNI

You Ain&#8217;t Gonna Need It. &nbsp;It&#8217;s one of my favorite acronyms, but it&#8217;s harder to adhere to than you might think. &nbsp;When you&#8217;re gathering requirements you often hear about things the business owners want to do in the future. &nbsp;Plus it&#8217;s just in our nature to build in everything we can. &nbsp;It takes a great deal of restraint to build an application that is useful in 3 months instead of the perfect solution in 8.

### The 80 / 20 Rule

This is probably the most difficult thing for programmers to remember: not everything has to be solved in the application. &nbsp;Today we we&#8217;re hashing out the stories dealing with escalation. &nbsp;There were one or two scenarios where the person handling escalation couldn&#8217;t solve the problem themselves, but needed either a manager or some other team member to do something. &nbsp;There&#8217;s no doubt this could be done within the application, but the reality was that it would just be faster if they asked the person either in person or on the phone or in an email to make the change for them. &nbsp;Since it was only one or two cases out of 15 or 20, it didn&#8217;t make sense to have this part of the minimum viable product. &nbsp;

It&#8217;s possible that our analysis is wrong and it happens way more often than we think. &nbsp;But at this point we don&#8217;t know and trying to build it now would add weeks to initial deployment. &nbsp;There are plenty of cases where it&#8217;s just better to handle edge cases outside of the application. &nbsp;The important part is to gather data so that you can either confirm or refute your original hypothesis

### Metrics

A lot of assumptions are made during the initial development of an application. &nbsp;You need to be able to validate those assumptions and one way to do that is to gather as much data about usage as you can. &nbsp;From click throughs to thorough logging, capturing usage data is crucial to find the holes in your initial assumptions.

We&#8217;re one of the few professions where it&#8217;s okay to build something with imperfect information. &nbsp;We have the ability to improve our designs after people start using it. &nbsp;It&#8217;s okay to get a few things wrong as long as you design your system so that you can make changes quickly. &nbsp;Low coupling, design by contract, and high test coverage help you do that. &nbsp; By applying restraint in our design and architecture and incrementally improving applications can lead to really great software