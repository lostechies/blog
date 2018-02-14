---
wordpress_id: 165
title: 'FubuMVC Primer: Configuration vs. Runtime'
date: 2011-02-01T01:55:08+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=165
dsq_thread_id:
  - "604038195"
categories:
  - general
---
Before I get started, if you haven’t read it yet, I strongly recommend that you read Jeremy’s post about [FubuMVC’s Configuration Strategy](http://codebetter.com/jeremymiller/2011/01/10/fubumvcs-configuration-strategy/). He documented a lot of the decisions that were made in the beginning that helped drive a lot of the design decisions that formed FubuMVC.

## Configuration

### The Action Call

When I first got started with Fubu, the thing that stood out to me the strongest was the concept of an ActionCall. From traditional MVC approaches this is the idea that given some Route “projects/list” gets translated into the invocation of a Method “List” that exists on a Class “ProjectsController”. Simply put, an ActionCall is a pointer to the method that will be invoked for a particular Route. Now it’s not uncommon to assume that the invocation of said ActionCall is a responsibility of some object within your system. What piqued my initial interest in Fubu was the conventional way in which that responsibility was delegate.

You see in Fubu terminology, an ActionCall is simply a BehaviorNode. Let’s discuss this before moving on.

### Behaviors

Let’s consider a very common scenario that an ActionCall would handle: creating an entity. Assuming that you’re building a CRUD application, the algorithm for doing these operations are fairly similar. Here’s an example of how each of these operations could be done:

#### Creating an Entity

  1. Validate the input for the entity. If successful, continue; otherwise, display an error
  2. Create an entity from the input
  3. Initialize a unit of work
  4. Insert the entity
  5. Commit the unit of work
  6. If successful, redirect to the details screen for that entity; otherwise, redirect to the input screen and display errors

For each entity in your system, you may find yourself writing the same boiler plate code. Perhaps you catch this repetition early on and abstract out to a reusable service. Here’s an example of what your “Controller” code may look like for a particular entity if you were using ASP.NET MVC:

As I mentioned, this assumes that you caught the repetition early and abstracted out to what I’m calling an ICreateEntityService. Despite your best DRY efforts, however, you’re going to find yourself doing this for every entity of your system. Admittedly there might be some magic in ASP.NET MVC that can prevent you from doing so but that’s not the point that I’m trying to make here. Instead, I’m simply pointing out several steps in a process that you follow for every entity in your system. We have repetitive steps – a “repeatable” process, if you will. Let’s reframe our thinking and approach this process as a series of Behaviors that are performed in response to a given Route, where each “step” is a “Behavior”. In fact, one could say that there is a chain of behaviors that execute in the response to a particular request. That, my friend, is exactly what FubuMVC is all about.

### The Behavior Node

So now we’ve got this high-level concept of a Behavior – a step in some process that we define at will. We will also have this notion that a chain of these “Behaviors” are executed in response to a particular request. What does that mean exactly? Well, it means that during configuration time, we can create, remove, and manipulate these “behavior chains”. Each BehaviorChain is modeled similarly to a linked list (as illustrated below): <a name="linked-list"></a> To make a long story short (don’t worry, [I’ll explain this later](#iactionbehavior)), a BehaviorNode represents a Behavior. Given some BehaviorChain, you can modify the order of your nodes and compose your chain of behaviors in any way that you like. Unfortunately, the description I’ve used so far about a Behavior needs to be clarified quite a bit more before I can accurately model our &#8220;Creating an Entity” scenario. Let’s discuss the Runtime version of all of this a little bit and then come back to wrap it up.

## Runtime

### The IActionBehavior <a name="iactionbehavior"></a>

The IActionBehavior interface is the programmatic representation of the Behavior concept that we’ve been discussing. The interface definition is very simple: 

We’ll leave the InvokePartial for a later date and instead focus on the Invoke method and general structure of a Behavior. The interface not only provides a contract for which behaviors are invoked within the system, it also has some magic that is given to it by virtue of one of Fubu’s greated strength: dependency inversion is a first-class citizen. You see, the transformation from a BehaviorChain to Behaviors is one that takes the [image from above](#linked-list) and translates it into the following model:

[<img class="aligncenter size-full wp-image-166" title="russian-doll_thumb" src="/content/josharnold/uploads/2012/03/russian-doll_thumb.jpg" alt="" width="484" height="484" srcset="/content/josharnold/uploads/2012/03/russian-doll_thumb.jpg 484w, /content/josharnold/uploads/2012/03/russian-doll_thumb-150x150.jpg 150w, /content/josharnold/uploads/2012/03/russian-doll_thumb-300x300.jpg 300w, /content/josharnold/uploads/2012/03/russian-doll_thumb-100x100.jpg 100w" sizes="(max-width: 484px) 100vw, 484px" />](/content/josharnold/uploads/2012/03/russian-doll_thumb.jpg)

&nbsp;

The runtime model is what we call a Russian Doll model. By that I mean each Behavior contains a reference to the next Behavior and has full control over the invocation of it. For any IActionBehavior implementation, if that Behavior has a dependency on IActionBehavior or a public property of type IActionBehavior, the next Behavior will be injected by the configured IoC container.

This is often better explained with code examples so consider the following implementation of IActionBehavior.Invoke (this is taken from the base class BasicBehavior – provided by Fubu for most behavior implementations):



## Bringing it together

With our new description of a Behavior in mind, let’s revisit our “Creating an Entity” scenario:

  1. Validate the input for the entity. If successful, continue; otherwise, display an error
&nbsp;

  2. Create an entity from the input
&nbsp;

  3. Initialize a unit of work
&nbsp;

  4. Insert the entity
&nbsp;

  5. Commit the unit of work
&nbsp;

  6. If successful, redirect to the details screen for that entity; otherwise, redirect to the input screen and display errors
&nbsp; </ol> 

Given the russian-doll nature of behaviors and their ability to control the invocation of the next, this becomes very easy to approach.

### Validation Behavior

Validate the input model (CreateProjectInput). If successful, invoke the next behavior; otherwise, redirect

### Create entity input

Transform the input model to the appropriate entity

### Entity creation

We probably want #’s 3-5 to be a transaction, so this will be our “ActionCall”. However, since our last step involves checking the result of this transaction, we’re going to switch things up a little bit. Our third behavior is going to be one that wraps our ActionCall with a try/catch. Here’s a quick code example: 

### The ActionCall

We discussed how you might find yourself repeating code quite a bit for each Entity in your system. Rather than abstracting out the process to a service, we’ve been representing each step of that process as behaviors. Naturally, I want to continue that so let’s make a generic class to handle the creation, insertion, and committing of our entity:



As I mentioned before, ActionCalls represent a method that will be invoked. We can make an action call point to nearly anything (I’ll explain the restrictions in a later post) and reuse open-generic type definitions like this.

## Wrapping it up

Ok, I covered a lot of material. My advice to you is to dive into the source and take a look at the classes that I mentioned.

Did I miss something? Have a question? Leave me a comment and I’ll try to get back to you but it would be much more beneficial to the community if you posted it in our mailing list: <http://groups.google.com/group/fubumvc-devel?hl=en>