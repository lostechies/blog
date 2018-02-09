---
wordpress_id: 230
title: TDD design trade-offs and junk food
date: 2008-09-18T23:56:48+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/09/18/tdd-design-trade-offs-and-junk-food.aspx
dsq_thread_id:
  - "264715918"
categories:
  - TDD
redirect_from: "/blogs/jimmy_bogard/archive/2008/09/18/tdd-design-trade-offs-and-junk-food.aspx/"
---
[Tony Rasa](http://elegantcode.com/) recently [talked about design trade-offs](http://elegantcode.com/2008/09/16/tdd-test-driven-dogma/) when doing TDD:

> When “doing TDD,” we consciously make design trade-offs to favor testability. &#8230; we end up with a lot of single-implementation interfaces because of testability concerns and from weaknesses with our tools.

When I first started doing TDD, many of the new designs that came out of this practice seemed backwards and counterproductive at first.&nbsp; After all, I wound up with many more classes, lots of interfaces, and most interfaces had exactly one implementation.

It turned out that before doing TDD, I wasn&#8217;t very good at OO design (not that I&#8217;m all that great now).&nbsp; I tried, but all in all it was largely a bunch of guesswork coupled with the fear of changing code.

In college, I decided to give up caffeine, fast food and soft drinks.&nbsp; Initially, healthy food tasted disgusting and it felt like I was going through junk food withdrawal.&nbsp; After a month or so of following a healthier diet practice, I decided to splurge on a cheeseburger.&nbsp; It was disgusting, and I was thoroughly nauseated.&nbsp; My body was not used to such high levels of fat, and was letting me know it was not pleased.

Starting TDD is giving up OO junk food.&nbsp; No more short cuts, god classes or big balls of mud, which seemed so comforting before.&nbsp; No more wallowing in the debugger, taking pride in knowing how to take apart the Gordian knot, or making a mental stack of variables.&nbsp; It hurt at first, seemed a little alien, but led toward leaner, tighter and more cohesive designs.

As for these so-called &#8220;trade-offs&#8221;, they are the first steps towards better designs.&nbsp; One-implementation interfaces aren&#8217;t a design smell, it&#8217;s separation of concerns in action, dependency inversion principle in action.&nbsp; Breaking big pieces into smaller cohesive units works on any scale, and you&#8217;ll be hard pressed to find the lower limit of its cost.

Because my initial OO designs had next to zero interfaces, it seemed rather silly to have a bunch of seemingly one-off implementations.&nbsp; Eventually, I saw interfaces for what they truly were: contracts.&nbsp; An interface is a contract, that any implementation needs to adhere to.&nbsp; Consumers of the interface do not care about implementation details, nor can they, as the interface provides no other information besides the signatures it provides.

When doing TDD in a top-down behavioral design fashion, I create interfaces well before I ever create an implementation for them.&nbsp; And that&#8217;s _reducing_ cost, as I don&#8217;t write code I don&#8217;t absolutely prove that I need yet.&nbsp; TDD forces the developer to put down the cheeseburger, drop the chalupa and ditch the Mountain Dew, forming a leaner, tighter and more cohesive codebase.