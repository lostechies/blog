---
wordpress_id: 594
title: Acronyms and Ubiquitous Language
date: 2011-12-11T18:00:41+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=594
dsq_thread_id:
  - "501050015"
categories:
  - Uncategorized
tags:
  - Acronyms
  - Ubiquitous Language
---
Acronyms are often employed within organizations as a way to abbreviate frequently used phrases in an attempt to expedite communication.&nbsp; Unfortunately, their use often does the exact opposite.&nbsp; Many programming language style guides discourage the use of acronyms.&nbsp; For instance, here’s what the .Net Framework [General Naming Conventions](http://msdn.microsoft.com/en-us/library/ms229045.aspx) has to say on the use of acronyms: 

> **Do not use any acronyms that are not widely accepted, and then only when necessary.** 

The reasoning for this is that acronyms tend to present a barrier to understanding rather than their intended goal of expediting communication.&nbsp; When used in conversation, if you’re confronted with an unfamiliar acronym then you at least have an opportunity to ask “_What does XYZ stand for?_”, but when a developer is reading through a new code base and encounters unfamiliar acronyms then there isn’t always an expedient way of bridging that communication barrier. 

Some might ask: “_But what do we do when acronyms are a deeply rooted part of the business’s day-to-day language?_” 

The use of a common language between developers and the business is referred to in Domain Driven Design as “_Ubiquitous Language_”.&nbsp; The book [Domain-Driven Design](http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215/ref=sr_1_1?ie=UTF8&qid=1323619169&sr=8-1) by Eric Evans has this to say concerning the use of a shared language with the business: 

> A project faces serious problems when its language is fractured.&nbsp; Domain experts use their jargon while technical team members have their own language tuned for discussing the domain in terms of design. 
> 
> The terminology of day-to-day discussions is disconnected from the terminology embedded in the code (ultimately the most important product of a software project).&nbsp; And even the same person uses different language in speech and in writing, so that the most incisive expression of the domain often emerge in a transient form that is never captured in the code or even in writing. 
> 
> Translation blunts communication and makes knowledge crunching anemic.&nbsp; Yet none of these dialects can be a common language because none serves all needs. 
> 
> … 
> 
> Therefore: 
> 
> Use the model as the backbone of a language.&nbsp; Commit the team to exercising that language relentlessly in all communication within the team and in the code.&nbsp; Use the same language in diagrams, written, and especially speech. 
> 
> Iron out difficulties by experimenting with alternative expressions, which reflect alternative models.&nbsp; The refactor the code, renaming classes, methods, and modules to conform to the new model.&nbsp; Resolve confusion over terms in conversation, in just the way we come to agree on the meaning of ordinary words. 
> 
> Recognize that a change in the UBIQUITOUS LANGUAGE is a change to the model. 
> 
> Domain experts should object to terms or structures that are awkward or inadequate to convey domain understanding; developers should watch for ambiguity or inconsistency that will trip up design.

&nbsp; 

At first, some may see this as a call to adopt the business’s acronyms as part of the Ubiquitous Language, and in some cases this might be the right thing to do (I’ll touch on this more in a bit), but let’s first consider a few things about what’s intended by using a Ubiquitous Language. 

First, the avocation of a Ubiquitous Language is first and foremost to facilitate communication and understanding.&nbsp; The job of the developer is to model the domain of the business in code, so adopting a common language with the business helps facilitate the creation of, and conversations about the model in ways that promote communication and understanding.&nbsp; That said, if the Ubiquitous Language isn’t promoting communication and understanding then you’re doing it wrong. 

&nbsp; 

<p align="center">
  <a href="https://lostechies.com/content/derekgreer/uploads/2011/12/cargo_cult_3.jpg"><img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: block; float: none; border-top-width: 0px; border-bottom-width: 0px; margin-left: auto; border-left-width: 0px; margin-right: auto; padding-top: 0px" title="cargo_cult_3" border="0" alt="cargo_cult_3" src="https://lostechies.com/content/derekgreer/uploads/2011/12/cargo_cult_3_thumb.jpg" width="500" height="256" /></a>&nbsp; <strong>Other people doing it wrong</strong>&nbsp;&nbsp;
</p>

Second, the fractured language Evans is referring to is the use of technical jargon to describe business concepts, not whether the concepts are expressed in abbreviated form or not.&nbsp; Expansion of business acronyms within the code doesn’t necessarily constitute a departure from the Ubiquitous Language. 

Third, the formation of the Ubiquitous Language is a two-way street.&nbsp; Business experts don’t always share a consistent language amongst themselves, and sometimes the terms they’ve grown accustomed to are ambiguous, confusing, or simply wrong.&nbsp; In these cases, the role of the development team should be to help forge a Ubiquitous Language with the user by agreeing upon terminology which clearly conveys understanding of the domain for both parties. 

That said, there are times when the use of business-specific acronyms may be appropriate.&nbsp; In cases where the use of acronyms are minimal and perhaps central to the identity of the business, using the acronyms in code may even be desirable.&nbsp; For example, imagine your company has won a bid to write an application for the [Ultimate Fighting Championship](http://en.wikipedia.org/wiki/Ultimate_Fighting_Championship) company to keep track of tournament brackets for Pay Per View events.&nbsp; For such an application, it would be completely appropriate to use the commonly used abbreviation for the company: UFC.&nbsp;&nbsp; 

If there are only a few acronyms used in the business which wouldn’t be prohibitive to learn then their use probably won’t pose much of an issue, but if the language of the business is flooded with acronyms then it’s best to use their expanded forms. 

I once worked at a company whose primary contract was with the United States Military.&nbsp; If you’ve never been exposed to military jargon before, I can tell you they take the use of acronyms to the extreme.&nbsp; The use of acronyms were littered throughout the code which made understanding the domain difficult for all.&nbsp; I recall several of the senior members of the team which had been with the company for years admitting that they only understood a small percentage of what the acronyms meant, and one junior developer explained that they didn’t know what a certain acronym used for a property meant, but they knew that that it always had to start with a certain sequence of letters.&nbsp; As it turned out, there was actually some correlation between the sequence of letters and the meaning of the acronym which was lost on all.&nbsp; Recommendations to stop using acronyms were met with objections that the team should continue using them because it was the “Ubiquitous Language”.&nbsp; Ironically, due to the way the U.S. Military conducted business with the company, only the management staff ever met with the generals for which a real Ubiquitous Language would have become useful, and then only rarely.&nbsp; Unfortunately, these choices among others lead to low quality and a high turn over rate among the development staff. 

In summary, acronyms may sound like a good idea because they save a few key strokes or syllables here and there, but before you use them in your code ask yourself if the code will be more or less understandable to the other developers who come after you.&nbsp; Additionally, if you’re using them under the banner of adhering to a “Ubiquitous Language” then ask yourself whether their use is really achieving a goal of promoting communication and understanding.
