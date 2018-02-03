---
wordpress_id: 1029
title: Combating the lava-layer anti-pattern with rolling refactoring
date: 2015-01-15T15:37:29+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=1029
dsq_thread_id:
  - "3422958162"
categories:
  - Architecture
  - Design
---
[Mike Hadlow](http://mikehadlow.blogspot.com/) blogged about the [lava-layer anti-pattern](http://mikehadlow.blogspot.com/2014/12/the-lava-layer-anti-pattern.html), describing, which I have ranted about in nearly every talk I do, the nefarious issue of opinionated but lazy tech leads introducing new concepts into a system but never really seeing the idea through all the way to the end. Mike’s story was about different opinions on the correct DAL tool to use, but none of them actually ever goes away:

![LavaLayer](http://lh5.ggpht.com/-qav7JW2HWqs/VI8XQU0gQwI/AAAAAAAATQU/QdWvJXP5N0o/LavaLayer%25255B5%25255D.png?imgmax=800)

It’s not just DALs that I see this occur. Another popular strata I see are database naming conventions, starting from:

  * ORDERS
  * tblOrders
  * Orders
  * Order
  * t_Order

And on and on – none of which add any value, but it’s not a long-lived codebase without a little bike shedding, right?

That’s a pointless change, but I’ve seen others, especially in places where design is evolving rapidly. Places where the refactorings really do add value. I called the result [long-tail design](http://lostechies.com/jimmybogard/2013/10/01/curbing-long-tail-design/), where we have a long tail of different versions of an idea or design in a system, and each successive version occurs less and less:

![](http://lostechies.com/jimmybogard/files/2013/10/image1.png)

Long-tail and lava-layer design destroy productivity in long-running projects. But how can we combat it?

**Jimmy’s rule of 2: There can be at most two versions of a concept in an application**

In practice, what this means is we don’t move on to the next iteration of a concept until we’ve completely refactored all existing instances. It starts like this:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2015/01/image_thumb6.png" width="219" height="83" />](http://lostechies.com/jimmybogard/files/2015/01/image6.png)

A set of functionality we don’t like all exists in one version of the design. We don’t like it, and want to make a change. We start by carving out a slice to test out a new version of the design:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2015/01/image_thumb7.png" width="219" height="83" />](http://lostechies.com/jimmybogard/files/2015/01/image7.png)

We poke at our concept, get input, refine it in this one slice. When we think we’re on to something, we apply it to a couple more places:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2015/01/image_thumb8.png" width="220" height="83" />](http://lostechies.com/jimmybogard/files/2015/01/image8.png)

It’s at this point where we can start to make a decision: is our design better than the existing design? If not, we need to roll back our changes. Not leave it in, not comment it out, but roll it all the way back. We can always do our work in a branch to preserve our work, but we need to make a commitment one way or the other. If we do commit, our path forward is to refactor V1 out of existence:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2015/01/image_thumb9.png" width="219" height="83" />](http://lostechies.com/jimmybogard/files/2015/01/image9.png)

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2015/01/image_thumb10.png" width="219" height="83" />](http://lostechies.com/jimmybogard/files/2015/01/image10.png)

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2015/01/image_thumb11.png" width="219" height="83" />](http://lostechies.com/jimmybogard/files/2015/01/image11.png)

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2015/01/image_thumb12.png" width="228" height="83" />](http://lostechies.com/jimmybogard/files/2015/01/image12.png)

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2015/01/image_thumb13.png" width="219" height="83" />](http://lostechies.com/jimmybogard/files/2015/01/image13.png)

We never start V3 of our concept until we’ve completely eradicated V1 – and that’s the law of 2. At most two versions of our design can be in our application at any one time.

We’re not discouraging refactoring or iterative/evolutionary design, but putting in parameters to discipline ourselves.

In practice, our successive designs become better than they could have been in our long-tail/lava-layer approach. The more examples we have of our idea, the stronger our case becomes that our idea _is_ better. We wind up having a rolling refactoring result:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="output_yWnRTm" src="http://lostechies.com/jimmybogard/files/2015/01/output_yWnRTm_thumb.gif" width="240" height="91" />](http://lostechies.com/jimmybogard/files/2015/01/output_yWnRTm.gif)

A rolling refactoring is the only way to have a truly evolutionary design; our original neanderthal needs to die out before moving on to the next iteration.

Why don’t we apply a rolling refactoring design? Lots of excuses, but ultimately, it requires courage and discipline, backed by tests. Doing this _without_ tests isn’t courage – it’s reckless and developer hubris.