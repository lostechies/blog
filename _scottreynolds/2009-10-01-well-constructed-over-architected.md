---
id: 4046
title: Well-constructed != Over-architected
date: 2009-10-01T06:32:06+00:00
author: Scott Reynolds
layout: post
guid: /blogs/scottcreynolds/archive/2009/10/01/well-constructed-over-architected.aspx
categories:
  - DDD
  - Quality
  - software
  - SOLID
---
Let&#8217;s imagine for a moment that we&#8217;re building a dog house for our beloved family pet. We want it to protect Rover from the elements, be a comfortable place for him to escape the sun and relax, and in general, have the structure hold up for quite some time.

We are probably going to select decent wood, rather than scraps. We&#8217;ll probably frame it out, make sure it&#8217;s sturdy, make sure the joints are secure, that it has a solid base, and that the roof is well put together. We&#8217;re probably going to plan it out, draw it up, and do the measurements to make sure Rover fits inside. If we aren&#8217;t that good at carpentry, we may grab a book or two and follow the recommendations of people more practiced than us. Sure, we can hammer nails, but we don&#8217;t necessarily know whether a miter joint is more appropriate than a dovetail joint in this case. We&#8217;re not just going to slap it together with glue and tacks, leaving gaps between boards, and not being too concerned if it skews in a strong wind. In short, we&#8217;re going to build a shelter that we&#8217;re happy to put a loved one in.

We aren&#8217;t going to support the walls with flying buttresses to future-proof the structure. We aren&#8217;t going to build it with steel girders. We aren&#8217;t going to turn it into the [Winchester House](http://www.winchestermysteryhouse.com/).

**There&#8217;s a difference between well-constructed and over-architected.**

There&#8217;s an epidemic of misinformed opinion going around that adhering to commonly accepted good coding practices is synonymous with being an &#8220;architecture astronaut&#8221;. That somehow someone who insists on applying SOLID and other principles to their code is more likely to inappropriately &#8220;solve&#8221; simple problems with too much complexity. This is simply not the case, and in my experience, the opposite is usually true.

If I have a simple one-off forms over data application to deliver in a short time it&#8217;s very unlikely that I&#8217;m going to spend a lot of time applying everything I ever read about DDD to the problem, and put a message bus behind it, put NHibernate under it, and implement some extensibility framework ahead of time just in case.

I will, however, write the code to adhere to the Single Responsibility Principle, and I will employ Dependency Inversion, and I probably won&#8217;t have many Law of Demeter violations. And I&#8217;ll probably, but maybe not always, design it with TDD. Why? Because my experience leads me to understand that these are good things. They help ensure that this simple app is going to be understandable and readable in 6 months when I have to add a feature or fix a bug. And they&#8217;re internalized. It&#8217;s the way I code now. It&#8217;s no faster or slower than not employing SOLID principles because that&#8217;s a useless comparison at this point. I&#8217;m unlikely to _not_ employ these techniques because it&#8217;s how I write code.

I believe that IoC containers are powerful tools. Every application I&#8217;ve written in the last couple of years does not, however, employ an IoC tool. Each of them does, however, make use of dependency inversion internally because that&#8217;s a good way to construct your classes.

I believe ORMs are powerful and useful tools. I do not, however, have a single application in production today that uses NHibernate (ok, it&#8217;s out, I&#8217;m the only alt.net guy not using NHibernate in production). I do, however, typically abstract data access away from the rest of the application as a natural result of applying SRP.

I believe that DDD is a very powerful design philosophy, and that DDD as a concept is composed of many useful parts, not just the patterns. Every application I have in production does not, however, have a complex domain model, and a layer of application and domain services, and a slew of repositories, and explicit aggregates with roots and so on. 

I do, however, always think about my domain even if it&#8217;s an ActiveRecord type implementation, because it helps make sure I&#8217;m modeling the appropriate concepts. And I do always think about and build a lexicon for ubiquitous language for a project because it enhances communication and clarity. And I do think about what my bounded contexts are because it helps me understand the nature of the system.

Irrespective of the complexity of code to be written or the time allotted to write it, I always strive to make sure my code is readable, and that my APIs are intention-revealing. This isn&#8217;t about geeking out on code structure, this is about putting something together that someone else on your team can understand. There&#8217;s no time tradeoff to be made here, nor is there a complexity one. It&#8217;s just part of constructing your software well.

Nobody ever said that building software well meant employing every tool and technique in the alt.net toolbelt every time, so I don&#8217;t know why people insist on acting like that&#8217;s being said. These arguments about not having enough time to &#8220;do it right&#8221; or not wanting to overcomplicate &#8220;simple&#8221; solutions usually come from a position of either ignorance or fear.

Constructing something well means simply constructing something well. Have the professionalism to do so.

<!-- Technorati Tags Start -->

Technorati Tags:
  
<a href="http://technorati.com/tag/quality" rel="tag">quality</a>, <a href="http://technorati.com/tag/software%20writing" rel="tag">software writing</a>, <a href="http://technorati.com/tag/craftsmanship" rel="tag">craftsmanship</a>, <a href="http://technorati.com/tag/SOLID" rel="tag">SOLID</a>, <a href="http://technorati.com/tag/DDD" rel="tag">DDD</a> 

<!-- Technorati Tags End -->