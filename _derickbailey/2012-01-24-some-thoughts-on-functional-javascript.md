---
wordpress_id: 758
title: Some Thoughts On Functional JavaScript
date: 2012-01-24T07:29:08+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=758
dsq_thread_id:
  - "550844951"
categories:
  - DSL
  - Functional
  - JavaScript
---
Just for fun I decided to put together a quick sample of some functional JavaScript &#8211; as in, [functional programming](http://en.wikipedia.org/wiki/Functional_programming) done with JavaScript. I&#8217;m not really very familiar with functional languages other than playing with Haskell a bit and doing some functional-style stuff in C# and Ruby. I wanted to see what a functional JavaScript code base might look like.

## A Functional Calculator

To keep things simple, I created a calculator using nothing but functions. Each function takes other functions as parameters and returns a function. The only exception to this is the simple \`value\` function which takes a value and returns a function that itself will return the original value.

Here&#8217;s the basic code I wrote for my calculator, including the aforementioned \`value\` function:

{% gist 1660207 funcalc.js %}

I wrote all this through the use of some Jasmine tests, but as a quick example of how it can work, here&#8217;s a simple formula and result:

{% gist 1660207 sample.js %}

## My Thoughts And Reactions

These are the interesting points that stand out in my head. I&#8217;m not sure if these are &#8220;correct&#8221; or not… it&#8217;s just what pops out in my mind.

If anyone has any corrections and additional thoughts or notes, I&#8217;d love to hear them &#8211; just drop me a line in the comments, below.

#### Functions And Functions As State

I&#8217;ve represented everything as a function &#8211; even the simple values of 1 through 4. And every function returns a function, except for the simple values, which return a function that returns the actual value.

<img title="FunctionAllTheThings.jpg" src="http://lostechies.com/derickbailey/files/2012/01/FunctionAllTheThings.jpg" border="0" alt="FunctionAllTheThings" width="400" height="300" />

In the process of returning functions from functions, I&#8217;m representing the state of the application as a series of functions.

This one is a bit odd for me to wrap my head around. I&#8217;m not sure if this is really correct, or if it&#8217;s just an oversimplification of what&#8217;s really happening here. There are no data-structures, though, only functions. So it stands to reason that the state is stored as a series of functions that can be evaluated to produce a result.

**Update**: The Wikipedia article on [functional programming](http://en.wikipedia.org/wiki/Functional_programming) says that fp &#8220;avoids state&#8221;. So… am I wrong in thinking that I&#8217;ve represented the state with functions instead of data structures?

#### Funcional Command Pattern

The result isn&#8217;t actually evaluated until I invoke the\`resultFunc\` in the above example. But I have the \`resultFunc\`available as a variable and I can pass it around anywhere I want. This basically turns it into a command pattern implementation, only in a functional manner instead of an object manner.

#### Compose-able And DSL Functions

All of these functions are side effect free. None of them actually mutates any existing application state. Of course this is a really simple implementation, but that was one of my goals. I&#8217;ll need to play with some more complex ideas in order to really see how side effect free would play out.

One of the benefits of side effect free functions is that the code in the sample is far more declarative and compose-able than most code I write. Since each function does one very small and very simple thing, taking in other functions as parameters, it&#8217;s easy to build things.

{% gist 1660207 compose.js %}

This is something that I&#8217;ve played with in other languages, and I like this aspect of functional programming. It&#8217;s a great way to build DSLs for example.

#### Compared To Object / Prototypal

Oscar Godson posted [a version of my code alongside a prototypal version](http://jsbin.com/atopek/edit#javascript) for a comparison.

{% gist 1660207 prototypal.js %}

I like seeing them side by side. It&#8217;s interesting the see all of the different ways that JavaScript can do the same thing. It also shows me just how ugly I think the functional version is. When you compare the actual formula in the comments to the functional JS code, the code is inside-out-backwards. The prototypal code with it&#8217;s method chaining is closer to the formula, though it&#8217;s still a bit off.

I think it&#8217;s easier to read and understand the chaining, though. It also reminds me of LINQ and monads &#8211; pipes and filters with a single result coming from the end of it.

#### More Fun Functional Stuff To Try

I haven&#8217;t done anything like memoizing or currying for these simple examples, but those are ideas I want to play with, too. I&#8217;ve written a currying function in JavaScript once or twice, and there&#8217;s plenty of examples in the good JS books. Memoizing is also available in Underscore.js but should be trivial to implement a naive version of it. I&#8217;m sure there are plenty of other things that would be fun to try, as well.

<span style="font-size: 18px; font-weight: bold;">Code And Continuing Thoughts (Maybe)</span>

If you&#8217;re interested in seeing this code, [it&#8217;s on Github](https://github.com/derickbailey/jsfuncalc).

I&#8217;m thinking about taking this a little further over time, just for fun. I&#8217;ve posted these comments in the read me (actually &#8211; they started there…) and I&#8217;ll continue to update the read me as I progress (assuming I actually do continue exploring this and don&#8217;t just forget about it like so many other things).

This is really pretty simple stuff&#8230; but it&#8217;s fun to write asimple exercise like this and think about what&#8217;s going on, why and see how it affects the way I think and approach software development.
