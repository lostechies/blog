---
id: 40
title: Quality Must Be Built In – It Cannot Be Added On
date: 2009-02-27T03:58:47+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2009/02/26/quality-must-be-built-in-it-cannot-be-added-on.aspx
dsq_thread_id:
  - "262068075"
categories:
  - Management
  - Philosophy of Software
  - Quality
---
Quality must be built in, it cannot be added on. … well, ok. I’ll admit that it’s not entirely true. If you don’t mind spending exorbitant amounts of money doing rework, causing projects to be late and over budget, and possibly losing the business, then by all means, wait until after-the-fact to try and add quality onto a product. No really. It can be done. You just have to accept that the system will be rewritten. After all, isn’t that the way software development goes? Build something… try to add on to it… recognize the problems that prevent you from continuing and then justify starting the same vicious cycle over. (How arrogant are we, as software developers and development teams, to expect our customers to accept this? But, I digress…)

We already know that the real world builds quality into their products by <a href="http://www.lostechies.com/blogs/derickbailey/archive/2009/01/30/favor-defect-prevention-over-quality-inspection-and-correction.aspx" target="_blank">favoring defect prevention over quality inspection</a>. What we often don’t realize, though, is the real cost of not building in quality from the start. So, what are the costs and effects of trying to add-on quality after the fact? Before I go down that rabbit hole, though, I want you to understand how I define quality, at the moment. Without this understanding, the illustration is far less effective.

### Defining Quality

I’ve run across a lot of definitions of ‘Quality’ over the years. Some of them good, some bad, some so far off from the truth that they would cause me to laugh if I didn’t know someone truly believed them. After all this time, I’ve begun to settle on my current favorite definition of Quality as: <a href="http://en.wikipedia.org/wiki/Zero_Defects" target="_blank">conformance to requirements</a>. 

Yes, I understand the somewhat naive focus that this definition of quality presents. However, I have yet to find as solid a foundation for quality as this. The Wikipedia entry for Zero Defect, from which I take that definition, continues to say this about quality as conformance to requirements:

> _“Every product or service has a requirement: a description of what the customer needs. When a particular product meets that requirement, it has achieved quality, provided that the requirement accurately describes what the enterprise and the customer actually need. This technical sense should not be confused with more common usages that indicate weight or goodness or precious materials or some absolute idealized standard. In common parlance, an inexpensive disposable pen is a lower-quality item than a gold-plated fountain pen. In the technical sense of Zero Defects, the inexpensive disposable pen is a quality product if it meets requirements: it writes, does not skip nor clog under normal use, and lasts the time specified.”_

In summary &#8211; the customer is the one that defines quality. That’s a much less naive view than the definition betrays. 

### More Than Meets The Eye

Saying that the customer defines quality is still somewhat naive – at least on the surface. It is true that the customer is the final authority on whether or not the product is quality. However, the reality of quality in software development is that there’s more too it than just meeting the <u>current</u> requirements. As <a href="http://www.lostechies.com/blogs/derickbailey/archive/2009/01/28/on-the-success-of-a-project.aspx" target="_blank">I’ve previously talked about</a>, I think quality is more of a two-sided coin in software. On the one side – the primary side – you have conformance to requirements. That is, what the customer actually needs to help solve their business needs. On the other side of that coin is the technical quality, as defined by the known best practices and standards that we adhere to as individual developers, team members, companies and larger communities. (Side note: More often, I’m finding it easier to define <a href="http://www.lostechies.com/blogs/chad_myers/archive/2008/08/18/good-design-is-not-subjective.aspx" target="_blank">what quality in software is not</a>, rather than what it is.) That being said, I’ll leave the definition of quality in software engineering to those previous and future discussions.

Getting back to the original point I was making, I’d like to illustrate a situation that I’m very familiar with on the cost of not building quality in from the start.

### Creating The ‘Perfect’ Failure

A long time ago, in a company far far away… [insert star wars theme]… there was a product under development. To protect the <strike>guilty</strike> innocent, we’ll call this project “ProjectX”. ProjectX’s customer was a very large entity, with lots of software products and projects that had been developed by many many software providers in the past. So, when ProjectX was first delivered to this customer and the customer said “It’s PERFECT!”, there was much rejoicing on the part of the software provider. In fact, ProjectX was deemed so perfect by the customer – having met every requirement, with less than 1% of the functionality being deemed ‘flawed, but still usable’ – that the customer declared ProjectX’s test results and acceptance as ‘the new standard’, across the board. 

But there is more to ProjectX than the initial quality that the customer observed. In fact, ProjectX had a deep, dark, disturbing secret just waiting to rear it’s ugly head. That secret was the distinct lack of quality that the software provider had built into ProjectX. Everyone at the software provider knew the lack of quality – it was a necessary business decision to role ProjectX out the door as quickly as possible. 

Fast forward 5 years, now. ProjectX is still a living, breathing, changing system. The customer, over the last 5 years, has requested numerous enhancements, requirements changes, and other stuff for ProjectX to do. While working on these new requirements and changes, the software provider found themselves in a sticky situation. Since they had set ‘the new standard’ with the customer – a standard so high, that they were now expected to deliver ‘on time, under budget, with perfect quality’ – the customer expected the software provider to continue meeting ‘the new standard’. Since the software provider knew that the original business decision to sacrifice quality for speed would come back to haunt them eventually, the software provider spent inordinate amounts of time trying to rectify the situation. They re-implemented parts of the system that were being modified, and introduced new architectures and standards when features needed them, and they worked 60 to 80 hour weeks for months – nay, years – on end, trying to introduce quality into ProjectX. 

With each successive delivery of new features and functionality, though, the customer began to notice a distinct drop in quality. In fact, there was an alarming trend in the quality of the product, over time. The customer began to track the ratio of defective to non-defective functions, and they began to complain about the problems that ProjectX was having. Eventually, the customer’s user base refused to install the latest version of ProjectX because of the large number of known issues in ProjectX. 

The customer became very upset at this new trend and many discussions with many sad users were had. And there was much sadness at the software provider. Questions were asked. Fingers were pointed. Many more discussions were had, and so-on and so-forth. The software provider, not willing to accept the new state of their software, decided to fix things… but that’s another story. 

### How ‘Perfect’ Failed

So how did a system that was deemed ‘perfect’ by the customer come to fail so miserably in the eyes of the same customer? The simple, honest, oh-so-hard-to-believe truth is that the software provider was unable to ‘add quality on’ after-the-fact. The software development team grew in their capabilities. They brought in new eyes and fresh expertise in development practices and architectures. They re-thought, re-structured, and re-worked so much of the system over such a long period of time. But it was never enough. There was simply too much of ProjectX that could not reasonably be changed and still meat the deadlines for new requirements, changes and enhancements. 

Over time, the initial lack of quality that was built into ProjectX rotted the system, from the inside out. Because ProjectX was unable to modified to meet the new requirements without breaking the old requirements, the customer no longer saw ProjectX as a quality product. The cost of this lack of quality was tremendous – the software provider’s reputation had been tarnished, the customer did not trust the provider and did not want to use ProjectX anymore, and the software provider had a legitimate chance of failing as a company and shutting its doors. 

### Conclusion: Build Quality In Or Risk Losing Your Lunch Money

Creating a quality product really is a two sided coin. If you create the perfect system in the customer’s eyes, but you can’t maintain that system and add new features and functionality – where is the quality? You’ve effectively put lipstick on a pig and called it a supermodel. But if you have the ‘perfect’ engineering practices and the ‘perfect’ system that is ultra-easy to add features on to, and no one wants to buy the product because it does not solve any real business problems or provide anything that a customer actually wants or needs, then where’s the quality in that? You’ve effectively delivered a Lexus LS-400 when the customer asked for a ham sandwich.

It is imperative that quality be built in to a product from the start. <a href="http://thetoyotaway.org/" target="_blank">We know how to do this.</a> We are (or should be) standing on the shoulders of giants. We only need to keep in mind both sides of the coin when creating the needed quality. Customer quality first, with engineering equally as important after the customer says ‘PERFECT!’.

This is not just a scary bed time story and this is not just a bunch of ‘ivory tower’ fluff. “ProjectX”, despite a fictitious name, was a real project at a real company and the story I told is the boiled down version of really happened. In fact, it has happened at least once in every job I’ve had as a professional software developer. I know the cost of not building in quality from the start. I’ve seen my friends, coworkers and bosses lose their lunch money. It’s not a happy scene.