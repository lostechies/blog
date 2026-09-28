---
wordpress_id: 191
title: Failures of aimless large-scale refactorings
date: 2008-06-04T02:37:31+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/06/03/failures-of-aimless-large-scale-refactorings.aspx
dsq_thread_id:
  - "285174268"
categories:
  - Refactoring
redirect_from: "/blogs/jimmy_bogard/archive/2008/06/03/failures-of-aimless-large-scale-refactorings.aspx/"
---
At the recent Austin Code Camp, I heard a few stories after my Legacy Code talk about teams attacking their legacy code in prolonged refactoring binges that never seemed to end.&nbsp; Never ending, because no one had a good idea of what success looked like.

Once technical debt has built up to a certain point, some folks opt to [declare bankruptcy](https://lostechies.com/blogs/jimmy_bogard/archive/2007/07/05/when-technical-debt-leads-to-bankruptcy.aspx) and start over.&nbsp; A place I came from recently did this fairly regularly, about once every two years.&nbsp; It wasn&#8217;t that a new technology would solve new business problems (although this was how IT sold the re-work), but the current codebase was completely unable to change at the rate the business needed.

### 

### Starting over

When we have a large legacy codebase, how should we turn it around?&nbsp; How much resources do we allocate to re-sculpting the big ball of mud?&nbsp; In a previous job, we did this by hijacking an entire release as an &#8220;engineering&#8221; release, rewriting the entire plumbing of the application.

Huge disaster, to say the least.

Needless to say, the refactoring itself was technically successful, but in the business side, a complete failure.&nbsp; We paused adding business value for months while we tinkered.&nbsp; The business absolutely resented us for this, and held it against us up until I left.

I&#8217;ve personally never seen a developer-induced month-long refactoring session succeed, and the failures of these refactoring efforts do serious long-term harm on the credibility of the team.&nbsp; The business never EVER likes to see basically a work stoppage to fix a mess that, in their eyes, are of the developers own doing.

### Risk and angles of attack

Another angle of attack besides charging up the hill to the machine gun nest, armed with only a bayonet, is to take a more strategic aim at de-gunking your system.

One approach that worked well for us was to only refactor in areas that needed to be changed.&nbsp; Change is needed for many reasons, whether it&#8217;s new features, bugs, performance problems, or others.

By only refactoring areas that needed to change, we were able to mitigate the risk of performing large-scale refactorings by making small, targeted steps towards a brighter future.&nbsp; We didn&#8217;t always know what the end result would look like, but that was a good thing.

If anything, developers are terrible guessers.&nbsp; My design guesses are always always always wrong the first time.&nbsp; It&#8217;s a waste of time to argue relentlessly on the best way to refactor a certain area, as tools like ReSharper and methods laid out in Kerievsky, Fowler and Feathers&#8217; books make it fairly easy to change direction.

### A pact for continuous improvement

To make sure that our codebase continuously improved, our team agreed that every change we made would improve our codebase.&nbsp; Even something as small as eliminating a couple duplicate methods was a big improvement.&nbsp; In a big ball of mud, we deleted code far more than we added, as it was rampant duplication that got us in to our original mess.

Over time, small changes allowed us to see larger refactorings that became more apparent.&nbsp; Since the large refactorings were driven from actual needs to change, we had confidence that we were moving in the right direction.

The whole point of the refactorings was to eliminate duplication so that we could add value, quicker.&nbsp; Stopping for months to re-work the application, given no direction on what areas are most important, is almost guaranteed to be a business failure, if not a technical one as well.