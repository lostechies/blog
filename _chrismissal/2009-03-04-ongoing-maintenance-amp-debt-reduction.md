---
wordpress_id: 3345
title: 'Ongoing Maintenance &#038; Debt Reduction'
date: 2009-03-04T02:44:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/03/03/ongoing-maintenance-amp-debt-reduction.aspx
dsq_thread_id:
  - "262174772"
categories:
  - Best Practices
redirect_from: "/blogs/chrismissal/archive/2009/03/03/ongoing-maintenance-amp-debt-reduction.aspx/"
---
I don’t like like analogies or metaphors most of the time, they’re weak logical arguments; I try to avoid them. Recently, I’ve seen many weak analogies that don’t really put things into real perspective. Comparing <a title="The Ferengi Programmer" href="http://www.codinghorror.com/blog/archives/001225.html" target="_blank">Star Trek to software development</a> is probably not going to give somebody a good understanding of the situation; especially since:

  * Star Trek isn’t real 
  * Even people who are aware of it, aren’t familiar with all the alien races in the shows 

That’s my little rant on weak analogies. I’ll be using my own later, so call me a hypocrite, I’m fine with that. Better examples include “<a title="Professionalism and Thermodynamics" href="http://www.lostechies.com/blogs/derickbailey/archive/2008/12/04/professionalism-and-thermodynamics.aspx" target="_blank">Professionalism and Thermodynamics</a>” and even non-comparisons like “<a title="Paying Down Your Technical Debt" href="http://www.codinghorror.com/blog/archives/001230.html" target="_blank">Paying Down Your Technical Debt</a>”. Here’s my stab at an analogy that (still weak) is likely a bit more easily understood.

### Keeping your surroundings tidy

It’s natural for all things to become messy or dirty over time, this is <u><a title="Entropy (wikipedia)" href="http://en.wikipedia.org/wiki/Entropy" target="_blank">entropy defined</a></u>, <u><a title="Self-organization systems (wikipedia)" href="http://en.wikipedia.org/wiki/Self-organization" target="_blank">there are exceptions</a></u> of course; maintaining software **is not** one of those exceptions. The only way to keep things organized is to put energy into sustaining some level of tidiness. This can be seen (here comes my weak analogy) in a messy room, a dirty garage, or an aging vehicle. By taking care of these things on a regular basis, you’re much less likely to run into the problem of: 

> _“Wow this is a disaster! It’s going to take days or weeks to get this baby back to normal!”_

When adding a new feature to your application, you may uncover a weakness that had not been seen until some code was required to be added/changed. At the time, it may have seemed like the best implementation. Your code is growing now and your “garage” is probably getting messy.

### Not Just Spring Cleaning… Clean that Garage Weekly

So just like the garage, that takes all weekend (or more) to clean up, your application will get to a point where a spring cleaning isn’t good enough. It will become hard to maintain and add features to, because you can’t get to where you want to be without tripping over something.

### Reduce, Reuse, Refactor

Much like Earth-friendly “<a title="Reduce, Reuse, & Recycle" href="http://www.news.harvard.edu/gazette/2008/02.28/01-reusing.html" target="_blank">green initiatives</a>” that promote Reduce, Reuse, Recycle; I think an application can benefit from a similar motto:

  * **Reduce** : Delete unused methods and variables, remove commented out code. This should be done every time you commit. Remember, cleaning this up later is going to take extremely longer than if you do it regularly. 
  * **Reuse** : Combine common functionality wherever possible (software’s version of recycling). Oftentimes this will lead you right into the refactor portion. 
  * **Refactor** : As your application matures and adds new features, keep refactoring it and ensure you’re not falling deeper into <a title="Debt Metaphor" href="http://www.youtube.com/watch?v=pqeJFYwnkjE" target="_blank">Technical Debt</a>. 

<a title="XP : After 10 Years Why Are We Still Talking About It" href="http://chicagoalt.net/event/February2009Meeting-XPAfter10yearswhyarewestilltalkingaboutit" target="_blank">Uncle Bob</a> put it nicely when he compared it to a Boy Scout motto:

> _“Leave the campground cleaner than how you found it.”_

### Yes, It Takes Work

If anybody tries to convince you that clean code and reduction of technical debt is fast and easy, they’re not being honest with you. Refactoring your application can take a lot of work if you don’t have sufficient tests around it. You need to make sure that you don’t break anything. The more confident you are in your application working, the easier it is to modify it for the betterment of the project.

Maintenance of your code is probably hard to sell to upper management and project owners. If somebody doesn’t have the technical background of writing software, it would seem like “wasted time” because they don’t “see” a benefit. By “see” I literally mean “see”. The application doesn’t look any different or add new functionality. I don’t have a good answer to this yet, but I’m working on it. In the meantime, these posts seem to answer some hard-to-answer questions and concerns.

  * <a title="Show #397 | 11/25/2008 (60 minutes) Michael Feathers talks Legacy Code" href="http://www.dotnetrocks.com/default.aspx?showNum=397" target="_blank">DNR : Michael Feathers talks Legacy Code</a>
  * <a title="Technical Debt, How we accumulate it, and how we can reduce it" href="http://devlicio.us/blogs/derik_whittaker/archive/2007/05/25/technical-debt-how-we-accumulate-it-and-how-we-can-reduce-it.aspx" target="_blank">Technical Debt, How we accumulate it, and how we can reduce it</a>