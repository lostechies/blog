---
id: 207
title: 'I Use Inheritance And I&#8217;m Not Entirely Ashamed Of It. Should I Be?'
date: 2011-01-18T17:22:50+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2011/01/18/i-use-inheritance-and-i-m-not-entirely-ashamed-of-it-should-i-be.aspx
dsq_thread_id:
  - "264081770"
categories:
  - AntiPatterns
  - Principles and Patterns
  - Ruby
---
Some time ago I saw a video of [Dave Thomas](http://pragdave.pragprog.com/) at the [Scotland On Rails 2009](http://www.engineyard.com/blog/community/scotland-on-rails/page-2/) event. I[n this video](http://scotland-on-rails.s3.amazonaws.com/2A04_DaveThomas-SOR.mp4) he says something along the line of

> **&#8220;Inheritance is the work of the devil. You should not be using it, 99% of the time.&#8221;- Dave Thomas**

At the time my primary ruby work was albacore &#8211; and I think I did a pretty good job of following Dave&#8217;s statement in that framework. But now I&#8217;m doing full time rails work and I&#8217;m having a hard time with this. Here&#8217;s why&#8230;

My current rails project is Rails 3 with MongoDB and Mongoid as the document mapper. This combination makes it stupid-simple to use inheritance and not feel any pain.

 

## Some Context

The project is based around assessments, with questions and answers, and reporting on those answers. The system has to support multiple assessments, each with it&#8217;s own specific questions and question types. Some questions are simple drop lists, some are combinations of drop list and text boxes, and some are highly complex layouts with multiple fields and varying options based on how you answer.

To build such complex assessments on top of a common infrastructure, we set up the system with a base &#8220;Question&#8221; model. This model contains the core information that is needed to know what part of the assessment the question belongs in, what the question name and description is, and how to validate and score the answers that are supplied to the question. When we need an actual question for an assessment, though, we do not use the Question model directly. Rather, we use a specialized question type that inherits from the Question model.

For example, we have a model for the questions that are a simple list box for selection: &#8220;Selection < Question&#8221;. This model provides the additional fields that are required for the question to have the necessary functionality including an options attribute to provide the list of available options. To build an assessment, we create a Selection question and provide the list of options, then save that model to MongoDB.

The Question model looks something like this:</p> 

The Selection model looks something like this:</p> 

 

## Why Inheritance?

Here&#8217;s the key to this and why inheritance is so easy with MongoDB / Mongoid: we never have to configure anything for the inheritance to work. Mongoid does it all for us.

To save a Selection question to the database, and to deserialize that question back into a Selection model, we have to do nothing more than call .save and .find, or any other data access method that Mongoid provides to the base Question model.

The document we end up with looks like this:</p> 

It&#8217;s that simple. Mongoid knows how to save and load the correct model based on the types in the inheritance chain and the _type field that it stores for us. It&#8217;s easy and we don&#8217;t have to worry about configuration or special code to make it work.

 

## Why Not Inheritance? What Should I Be Doing?

This is really what it comes down to for me&#8230; I don&#8217;t understand why we shouldn&#8217;t be using inheritance in this particular situation. Yes, I know the old platitudes about &#8220;favor composition over inheritance&#8221; and in my .NET work, I have done this for many years&#8230; and in my .NET work, composition over inheritance has made my life so much easier. Tools like NHibernate, while they do make life easier for me in .NET, are painful to use with inheritance models, in my opinion. But in this system, with no pain being felt at the moment, I have to question this&#8230;

I want to know why Dave Thomas says I&#8217;m doing ruby wrong by using inheritance. Can someone enlighten me? Can someone show me an example of how I should be doing this, without using inheritance? Or is my scenario the 1% of the time that Dave would say is ok?