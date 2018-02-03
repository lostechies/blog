---
wordpress_id: 387
title: Evolutionary Architecture
date: 2010-01-29T03:47:25+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/01/28/evolutionary-architecture.aspx
dsq_thread_id:
  - "264716425"
categories:
  - Design
---
A popular cause the Agile folks like to rally against is the idea of a Big Design Up Front (BDUF).&#160; But much like Waterfall, the people doing BDUF will hardly admit that it’s BDUF that they’re doing.&#160; Instead, you’re much more likely to get a bevy of really convincing cautionary tales of what might happen if you _don’t_ do a certain design.&#160; With enough experience under their belt, the architect slips into a “Just-In-Case” design mode, where the myriad of pain points encountered in the past leave a design that’s hardened against every possible difficulty that might come up.

Instead of a well architected design, you’ll have one that’s over-abstracted, over-engineered, over-complicated and very difficult for the next developer to come on board and understand.&#160; But there’s an alternative approach.&#160; The better choice instead of BDUF is a collection of design and architecture techniques that both delay decisions until they’re absolutely necessary, and refactoring practices to evolve our design when assumptions are proved incorrect.

### Technique #1: YAGNI

YAGNI stands for “[You Aren’t Gonna Need It](http://xp.c2.com/YouArentGonnaNeedIt.html)”.&#160; It’s a generally philosophy of waiting until code actually needs to be written before writing it.&#160; Instead of guessing or projecting on future needs, abstractions or features, the need must present itself in a concrete manner.&#160; This idea can be abused as a way of dismissing true needs for abstractions, so it can take some trust and negotiation in a team when disagreements arise on whether a need has arisen.

The benefit of YAGNI is that you don’t develop features that you might not need.&#160; If you only design based on needs currently evident in the codebase, you’ll never fall into the trap of over-design.&#160; After a design has changed passed the YAGNI tipping point, it can be tempting to castigate yourself, asking “why didn’t we do that sooner”?&#160; Because you didn’t _need_ it sooner.&#160; The trick is to find the right tipping point to guide the next step in design.

### Technique #2: Pain-Driven Development

Another common over-engineering technique is refactoring areas that may be ugly, but don’t actually present any problems.&#160; The antidote for refactorbation and speculative design is pain-driven development.&#160; The concept is simple: if it doesn’t hurt, it doesn’t need fixing.&#160; If it hurts, fix it!&#160; The bottom line is that not all areas of your application will have the same sophistication and attention to detail in its design.&#160; But that’s normal, every project works under constraints and you have to focus your time on the most critical areas.

The most critical areas tend to be the ones that change the most.&#160; In Feathers’ Legacy Code book, he recommends refactoring code only when it requires change.&#160; If we only refactor when code needs to change, it naturally leads to the most-changed areas having the best design.&#160; If the most-changed areas are where the most features are added, it tends to follow that the design needs to be more robust in those areas.&#160; By paying attention to pain, we can gauge how much time and effort we need to address in changing a design.&#160; A design may not be ideal, but if it’s not causing much pain, there’s not much ROI on “fixing” the problem.

If you view pain as a cost or a debt, then a design improvement must be measured on how much pain the fix solves, rather than how much better it makes us feel or lets us flex our intellectual muscles.&#160; For long-lasting success, it’s important that we spend our time improving areas that will have the most long-term impact.&#160; Paying attention to pain is a great technique for doing so.

#### Corollary to Pain-Driven Development

Sometimes a pain can be so slight, but so endemic, that you become numb to pain.&#160; An alternative solution doesn’t seem like it will be that much better, since you’ve become adjusted to the more difficult design or tool.&#160; This tends to close your mind to opportunities that the new design or tool provides.&#160; For example, we used the HBM NHibernate mapping files for a long time because we were all quite familiar with using them, and didn’t cause that much pain.&#160; However, Fluent NHibernate opened new doors that our numbness to the HBM pain was actually an opportunity cost because we couldn’t take advantage of things like conventions to drastically reduce the amount of manual mapping code we needed.

So while the current design may not incur too much pain, we still have to be aware of the opportunities alternative designs might afford us.

### Technique #3: Iterative Design

Another big issue I’ve seen with long-lived codebases is that although good design concepts are introduced, they are sparsely, almost randomly applied to the outside observer.&#160; Improving the architecture of a system is good, but leaving a trail of decaying, older designs still in the codebase can cripple further innovation.&#160; When we encounter a system-wide pain, we don’t just fix it in one or two spots.&#160; Instead, we estimate the cost to apply the fix system-wide.&#160; Only once we’ve applied the design system-wide will we try to apply the next iteration in our design.

The benefits to this approach are several.&#160; With several older designs in our system in varying degrees in the evolution of our system, it becomes harder and harder to determine what the “right” design is.&#160; If we have a system-wide concept that we only improve one spot at a time, we wind up with a looooong trail of various designs, and it becomes that much harder to find what the next step is.&#160; When it comes to system-wide architecture and design, the more examples we have of the current design, the better our next choice will be.

### Other Techniques

I could go on forever on other techniques, such as DRY, Responsibility-Driven Design, Convention over Configuration, Last Responsible Moment, Simplest Thing that Could Possibly Work and more.&#160; Since some decisions are not easily reversible, we would like to wait until we have as much information as possible before making a long-lasting, costly to reverse decision.&#160; When it comes to choosing between something like Rails or ASP.NET MVC, it would be only responsible to ask as many questions as possible before we make our final decision.&#160; Or choosing between Active Record or the Domain Model pattern.&#160; Are we in that 5% slice that actually needs DDD?&#160; Or is it just 5% of our current application that might require DDD?&#160; These are tough questions to answer, and there’s not always all the information you need to know where to go.

In my experience, I’ve found that choosing the simplest thing that could possibly work is a great starting point, and applying iterative design as we go tends to produce the best final result.