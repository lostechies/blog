---
id: 241
title: Investing in your tests–A lesson in object composition
date: 2012-12-22T18:16:52+00:00
author: Josh Arnold
layout: post
guid: http://lostechies.com/josharnold/?p=241
dsq_thread_id:
  - "987746219"
categories:
  - general
tags:
  - Testing
---
“Invest in your tests”. I say it all the time and it just never seems to carry the weight that I want it to. This bothers me. It bothers me so much that it’s generally in the back of my mind at any given point of my day. And then it happened…

In my last post, I talked about the joy of cleaning up code that I wrote two years ago. In the process of doing so, I made some observations about object composition and usability that gave me an “ah-ha” moment. I finally have a concrete example for this vague/abstract statement about quality and effort.

So, here it is: **investing in your tests – a real life example**. But let’s establish some context first.

### Validator Configuration

The flexibility in composition of the Validator class in FubuValidation is something that we pushed for since the beginning. We have the concept of an IValidationSource that can provide a collection of rules for a given type. Some examples would be:

  * A simple FI/DSL ala FluentValidation 
      * Attribute markers for rules 
          * Mapping NHibernate configuration into validation (e.g., required)</ul> 
        One of the built in sources adapts the IValidationRule interface (which operates at the class level) into a separate configuration of field validation rules. The Field Validation configuration is similar and has its own IFieldValidationSource to aggregate rules. To top it all of, the ValidationGraph (the semantic model) essentially memoizes the various paths to validation for optimization purposes.
        
        Naturally, this amount of flexibility makes the API…well, let’s just say it started to really suck.
        
        ### First Iteration: The “Basic” pattern
        
        One of the things we typically do for situations like this is expose a “Basic” static method on an implementation that composes the basic setup for a class. In addition to the static builders, the constructors of the various implementations add the default configuration.
        
        This let’s us do something like:
        
        
        
        ### The Scenario Pattern
        
        This pattern originated from FubuCore’s model binding and it’s been valuable ever since. The idea is that you have a static builder that exposes a way to configure the composition of a particular component. Here’s an example of the ValidationScenario:
        
        
        
        The lambda allows you to specify field rules, validation sources, inject services, etc. It’s all located in the core FubuValidation library. This ensures that the composition stays up to date but minimizes any impact on YOU when you’re writing tests for your custom rules.
        
        ### Wrapping Up
        
        “Investing in your tests” means exactly what it sounds like. Effort should be spent removing complexity, minimizing friction, and making sure that your tests are not brittle. Sometimes that means exposing helper methods on your APIs and other times it means building entirely different blocks of code to bootstrap tests.