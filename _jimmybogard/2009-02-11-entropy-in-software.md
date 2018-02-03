---
wordpress_id: 281
title: Entropy in software
date: 2009-02-11T01:23:54+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/02/10/entropy-in-software.aspx
dsq_thread_id:
  - "267829792"
categories:
  - Design
---
One of the greatest lessons I had growing up was from my music teacher, on improvement:

> You’re either getting better or getting worse, but you’re never standing still

The same applies to a software system.&#160; Any software system’s design either gets better or worse with each change made.&#160; Often times, we borrow on our technical debt for a short-term gain, knowing we’ll need to repay the debt later with some larger refactorings.&#160; This is a tactical choice made at the expense of a potentially strategic advantage.

I believe that it is the natural order of software to gravitate towards a “[big ball of entropy](http://codebetter.com/blogs/gregyoung/archive/2009/02/05/big-ball-of-entropy.aspx)”.&#160; It’s why I think velocities on teams level out over time – simply because it can become more and more costly to make changes to a system.&#160; If we’re not proactive on eliminating duplication when we find it, that big ball of mud will be right around the corner.

Once designs grow to a certain size, effort has to be made on the macro level to break apart concerns.&#160; Separation of concerns on the class level can only take you so far, eventually you’ll need to take separation of concerns to the system level, and implement strategies like messaging/SOA to keep systems independent, decoupled and cohesive.&#160; I’ve worked on systems designed as one, monolithic application designed to run every piece of the enterprise, and these systems were impossible (financially speaking) to change after a period of time.&#160; But because management favored tactical over strategic change, thinking only short-term, fun blamestorming meetings soon ensued.

### Quality with a name, and a price

Tactical decisions aren’t bad, when a balance is struck between designing just-in-time versus waiting for a design to emerge.&#160; It’s when we wait too long for a design to emerge, ignore the technical debt, and pass up on opportunities to eliminate duplication where our system gets worse, not better.

Each improvement comes with a price, and it really is up to management to both understand the cost and decide on the direction.&#160; If we’re building a two-week application never to be touched again, why is SOLID important?&#160; It’s not really.&#160; Better to optimize for short-term value with convention-based, RAD design than try to bolt on DDD to something that really won’t change much.

But every change makes software better or worse, and we as developers need to be cognizant of the implications of each change we make.&#160; We can’t blindly change, change, change an application without always thinking, “is this change incurring technical debt”?

I see it as the responsibility of every single developer on the team to always be thinking, critiquing and judging each change and design choice.&#160; In some teams I’ve worked with, one person, a senior developer or team lead would be the only person who tried to keep up with the duplication created by the rest of the team.&#160; I felt bad at the time, but didn’t really say anything because usually that person was the hero type, and it seemed like a natural order in the team.

Looking back, I can see now how destructive this arrangement was for the overall success of the project.&#160; Since the team lead was prideful, they coveted and relished that role.&#160; The sad part is, even five minutes of thinking on a design, considering alternatives, and whiteboarding was considered a waste of time by the team lead.

### 

### Faulty assumptions

Some of the reasons I’ve seen bad (i.e., costly) design by choice include:

  * Laziness
  * Apathy
  * Inability to recognize the last responsible moment

It’s one thing to do the “easiest thing that could possibly work” and another to do the “most cost-effective thing that could possibly work”.&#160; If we want to control the entropy of a system, we have to think of both the long and short-term cost of change.&#160; If long-term costs keep increasing, our design or architecture is faulty.&#160; Catching these bad designs becomes exponentially cheaper as you get closer to the decision point, as an early bad design can be very, very difficult and costly to improve as time goes by.

When **thinking** was discouraged in favor of **doing** at the decision point, it was because of the faulty assumption by the decision maker that we were wasting our time and software is easy to change as time goes on.&#160; Well, it isn’t.&#160; Some fundamental design decisions are very costly to reverse, and we shouldn’t assume that every design, even with testing in place, is easy to change.

If we take the time to do group design and improve every time we change the software, we can keep software entropy in check, ensuring the long-term maintainability and viability of the systems we get paid to build.