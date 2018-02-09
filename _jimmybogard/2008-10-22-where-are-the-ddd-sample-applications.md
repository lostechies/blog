---
wordpress_id: 242
title: Where are the DDD sample applications?
date: 2008-10-22T11:39:42+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/10/22/where-are-the-ddd-sample-applications.aspx
dsq_thread_id:
  - "264715948"
categories:
  - DomainDrivenDesign
redirect_from: "/blogs/jimmy_bogard/archive/2008/10/22/where-are-the-ddd-sample-applications.aspx/"
---
It’s a question I see quite a bit, on the ALT.NET mailing list, the DDD mailing list, and any other medium where DDD comes up.&#160; For those trying DDD, this is a rather difficult question to answer.&#160; Many have tried to create DDD how-to’s and samples, including Jimmy Nilsson in [his book](http://www.amazon.com/Applying-Domain-Driven-Design-Patterns-Examples/dp/0321268202).&#160; The problem with these examples are twofold:

  * They only show the code-level software patterns
  * DDD isn’t defined as a specific architecture or a specific set of software patterns

There are plenty of software patterns described in Evans’ book.&#160; Entity, Aggregates, Value Object, Aggregate Root, Services, Repositories, Factories and so on.&#160; But merely applying these patterns misses the point, it’s (sigh) cargo cult DDD.

DDD is first and foremost about a model expressed as software.&#160; Businesses have processes and tasks they do, and DDD attempts to bridge the gap between developer and domain expert by applying patterns that help transfer a model of reality into code.&#160; Techniques like Ubiquitous Language attempt to reduce the amount of translation between software model and conceptual model.&#160; Building a robust Ubiquitous Language requires extensive conversations and learning on the part of the developer.

And therein lies the rub.&#160; A finished application does not capture the journey.&#160; It does not capture the conversation.&#160; It captures the final product of learning and application, but not the road to get there.&#160; It does not capture brainstorming or whiteboarding sessions.&#160; It does not capture (well) major decisions and their effects on the model.&#160; Without this journey, the value of the destination is severely diminished.

In Evans’ book, he goes into fairly deep discussion about the domain his examples use.&#160; He also provides sample conversations, sample whiteboarding, and sample modeling sessions.&#160; Some of these are reflections of real conversations and real events.&#160; **If you’re looking for a DDD example, it’s Evans’ DDD book.**

However, if you’re looking for technical examples of the Repository pattern, ask for that instead.&#160; If you Google “repository pattern” or look for NHibernate examples, you’ll find plenty of resources on how to apply the technical patterns.&#160; Keep in mind that using the Repository pattern does not equate to practicing DDD.&#160; And those who (at least believe) they understand what DDD is all about, a request for DDD examples really doesn’t make any sense.