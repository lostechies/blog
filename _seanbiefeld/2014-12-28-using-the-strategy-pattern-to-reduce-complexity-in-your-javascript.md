---
id: 4457
title: Using the Strategy Pattern to Reduce Complexity in Your JavaScript
date: 2014-12-28T18:48:30+00:00
author: Sean Biefeld
layout: post
guid: http://lostechies.com/seanbiefeld/?p=188
dsq_thread_id:
  - "3367781000"
categories:
  - JavaScript
  - Readability
tags:
  - javascript
  - refactor
  - Strategy Pattern
---
## Problem: {#problem-}

Do you ever find yourself writing a lengthy `switch` statements or `if` statements structured like a switch. Luckily there is the [Strategy Pattern](http://en.wikipedia.org/wiki/Strategy_pattern) to help alleviate this complex, sometimes unintelligible code. You may have also noticed that this code can have quite a high [Cyclomatic Complexity](http://en.wikipedia.org/wiki/Cyclomatic_complexity). 

Let's take a look at an example of a lengthy `switch` statement. The code below is checking a user's role and if they have read or write permissions. Now this is a contrived example but the pattern still applies.

[JS Bin](http://jsbin.com/gusojamama/1/edit?console)

Here we can see the complexity is becoming unweildy, sure there are ways to clean this code up more with string manipulation of the urls and roles/permissions. The permissions check should be a single function call as well. Humor me and let's pursue the Strategy Pattern for now and we'll clean up the permissions check along the way.

## Solution: {#solution-}

The Strategy Pattern will be our weapon of choice for tackling the problem above. So what is the Strategy Pattern, you may ask? Essentially it is a way to evaluate an input at runtime and execute predefined code based off of that input. This is JavaScript, a dynamic language so we won't have to go the full polymorphic, implenting interfaces like in C# to use this pattern. As an aside, you could actually do it that way in JavaScript if you'd like. Check out [this implentation](http://www.dofactory.com/javascript/strategy-design-pattern) to see how to do it that way.

For our solution we are going to utilize the fact that the JavaScript [Object is essentially a dictionary](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Property_Accessors), note the bracket notation to get object properties by a string. We are not handling super complex logic so a dictionary will suffice as our strategy implementation.

### Implementation {#implementation}

First we will start off laying out the basic structure for our strategy. We will define a `UserRoleStrategy` class with functions for each role and a default handler.



We are creating a function to handle each user role, similar to our switch statement. Now let's go ahead and add the logic for each user role. We will pull the logic out of our `switch` and place it in the appropriate user role function.



That's still pretty messy, so let's refactor the permissions logic. This step is not strategy pattern related but will make the code more readable. Our strategy object allows us to refactor easily and contain the logic within it.

[JS Bin](http://jsbin.com/jusiha/10/edit?js,consolee)
  


Refactor complete, now we have a strategy object with two private functions to handle our permission/url logic and our logging. We no longer rely on a switch statement to handle our user role logic but a full blown object that can be extended as needed. Note on line 53 we are instantiating our strategy object, `currentRoleHandler`, and passing in the `user`. We then use the square brackets to pass in our user role on line 57, `currentRoleHandler[user.role]()`. Resulting in a call to the correct function on our strategy object. 

That's it, thanks for reading!

## tl;dr {#tl-dr}

> Reduce cyclomatic complexity in your JavaScript with the [Strategy Pattern](http://en.wikipedia.org/wiki/Strategy_pattern) and utilize the fact that JavaScript objects can be used as a dictionaries.