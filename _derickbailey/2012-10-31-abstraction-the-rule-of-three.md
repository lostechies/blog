---
id: 1021
title: 'Abstraction: The Rule Of Three'
date: 2012-10-31T11:14:42+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=1021
dsq_thread_id:
  - "908714093"
categories:
  - AntiPatterns
  - JavaScript
  - Pragmatism
  - Principles and Patterns
  - Risk Management
---
I often hear people say something like &#8220;if you need it once, build it. If you need it twice, abstract it.&#8221; People often say then in the context of the &#8220;DRY&#8221; &#8211; or [Don&#8217;t Repeat Yourself](http://en.wikipedia.org/wiki/Don%27t_repeat_yourself) &#8211; principle. In theory this sounds great because you&#8217;re removing duplication in your code. This falls apart pretty quickly in a lot of circumstances, though.

The idea of DRY needs to be tempered with YAGNI &#8211; &#8220;[You Aint Gonna Need It](http://en.wikipedia.org/wiki/You_ain't_gonna_need_it)&#8220;. With that, we end up with [The Rule Of Three](http://en.wikipedia.org/wiki/Rule_of_three_(computer_programming)), and it clearly says that code can be copied once but the third time you need it, you should abstract it.

## Patterns In Math

Think back to early school years when you were learning about patterns in math class. You were most likely introduced to problems that read something like this:

> Complete the pattern:
> 
> 1, 2, 3, \_, \_, _

The obvious answer here is that the pattern continues &#8220;4, 5, 6&#8221; because the pattern is to add 1 to the previous number. 

But what happens if we remove 3 from this pattern:

> Complete the pattern:
> 
> 1, 2, \_, \_, \_, \_

Is it possible to complete this pattern? … I don&#8217;t think it is &#8211; at least, not with certainty. You could assume that the pattern is 1, 2, 3, 4, 5, 6 but you might be very wrong. What if the pattern is not &#8220;add 1 to the previous number&#8221;? What if the pattern is &#8220;multiple the previous number by 2&#8221;? Then the pattern would completion would be 1, 2, 4, 8, 16, 32.

The point is that two positions does not create a guaranteed pattern. Two positions creates the potential for a pattern to emerge. We need at least a third position for the pattern to be identified in even the most simple cases. Often we need more than that to truly identify a pattern of more complexity, though.

## Patterns In Code

If a mathematical pattern can&#8217;t be properly identified with only two positions, then why do we say &#8220;Don&#8217;t Repeat Yourself&#8221; in code and force abstractions on ourselves with only two reference implementations? Honestly this is often because the problems of code duplication begin the first time we copy & paste something. Most of us (myself included) have run in to so many problems that started the moment we copy & pasted code, that we force ourselves to abstract when immediately.

The problem that we face in abstracting code is the same problem that we face in math patterns, though. If we only have two use cases for a given pattern, we don&#8217;t yet know the exact shape of the pattern or whether we even have a pattern to begin with. 

An Example in JavaScript:

[gist file=1.js id=3988403]

In this example, we have a condition that is being checked on an object. If that condition is true, we do one thing. If that condition if false, we do something else. This pattern of if-then checks is repeated between the &#8220;stuff&#8221; and &#8220;moreStuff&#8221; functions.

Now the engineer and pattern-matching-machine that I am says, &#8220;Looks like we&#8217;re checking the state of this object and doing something different. Let&#8217;s build a state pattern or statemachine.&#8221; But this is a premature optimization. We could spend a few hours or days building the state pattern or statemachine to handle this for us only to have the requirements for the system change or realize that there&#8217;s a bug and we need to update the code to look like this instead:

[gist file=2.js id=3988403]

Now we don&#8217;t have the same potential pattern in place anymore, and we don&#8217;t need the same state machine that we might have previously built. The abstract that we may have spent our time on is wrong and is probably going to get in the way and add overhead and cruft that we no longer need.

Instead of saying that we should abstract something the second time we need it, then, we should be saying &#8220;pay attention&#8221; the second time we need it. Then when we see this same implementation for a third time, a more appropriate abstraction can probably be made.

## The Rule Of Three

The rule of three applies to both simple math patterns and code patterns equally well. In math, we need at least three positions before we even have a chance at identifying a pattern. In code, the exact same thing is still true.

If you need something once, build it. If you need something twice, pay attention. If you need it a third time, abstract it.

## Intuition And Limitations

In spite of the validity that the rule of three has, it isn&#8217;t a golden law of software development that will solve all of your abstraction needs. Like every other &#8220;rule&#8221; we use in software development, it&#8217;s a heuristic &#8211; a guideline to give us an idea, a percentage match to judge against and see if we need to abstract or not.

The rule of three is not the only heuristic by which we judge, though. Intuition and experience also come in to play. We may see the pattern emerge after a single use, given enough experience and intuition. It may be dangerous to abstract at this point, though, because the details of the specific scenario are going to bleed in to the abstraction. A second implementation of the same pattern may show that we truly are going to repeat this pattern throughout our code. The second implementation will also give us a better idea of how the abstraction should be shaped so that we don&#8217;t bleed too many details of the specific scenarios in to it. There&#8217;s still some danger here, though. Our intuition might still be off a bit, but with experience and input from others we can probably adjust for that. 

In the end, though, the goal of &#8220;Don&#8217;t Repeat Yourself&#8221; needs to be tempered with YAGNI which leads us to The Rule of Three and the mathematical proof that two positions does not make a pattern. Given the combination of these and other principles as well, we have a good framework for moving forward and creating solid abstractions in our code.