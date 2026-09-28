---
wordpress_id: 1198
title: 10 Lessons from a Long Running DDD Project – Part 1
date: 2016-06-13T16:14:26+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1198
dsq_thread_id:
  - "4907250694"
categories:
  - DomainDrivenDesign
---
Round about 7 years ago, I was part of a very large project which rooted its design and architecture around domain-driven design concepts. I’ve blogged a lot about that experience (and others), but one interesting aspect of the experience is we were afforded more or less a do-over, with a new system in a very similar domain. I presented this topic at NDC Oslo (recorded, I’ll post when available).

I had a lot of lessons learned from the code perspective, where things like AutoMapper, MediatR, Respawn and more came out of it. Feature folders, CQRS, conventional HTML with HtmlTags were used as well. But beyond just the code pieces were the broader architectural patterns that we more or less ignored in the first DDD system. We had a number of lessons learned, and quite a few were from decisions made very early in the project.

### Lesson 1: Bounded contexts are a thing

Very early on in the first project, we laid out the [personas](http://www.agilemodeling.com/artifacts/personas.htm) for our application. This was also when Agile and Scrum were really starting to be used in the large, so we were all about using user stories, personas and the like.

We put all the personas on giant post-it notes on the wall. There was a problem. They didn’t fit. There were so many personas, we couldn’t look at all of them at one.

So we color coded them and divided them up based on lines of communication, reporting, agency, whatever made sense

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2016/06/image_thumb.png" width="640" height="277" />](https://lostechies.com/content/jimmybogard/uploads/2016/06/image.png)

Well, it turned out that those colors (just faked above) were perfect borders for bounded contexts. Also, it turns out that 72 personas for a single application is way, way too many.

### 

### Lesson 2: Ubiquitous language should be…ubiquitous

One of the side effects of cramming too many personas into one application is that we got to the point where some of the core domain objects had very generic names in order to have a name that everyone agreed upon.

We had a “Person” object, and everyone agreed what “person” meant. Unfortunately, this was only a name that the product owners agreed upon, no one else that would ever use the system would understand what that term meant. It was the lowest common denominator between all the different contexts, and in order to mean something to everyone, it could not contain behavior that applied to anyone.

When you have very generic names for core models that aren’t actually used by any domain expert, you have something worse than an anemic domain model – a generic domain model.

### Lesson 3: Core domain needs consensus

We talked to various domain experts in many groups, and all had a very different perspective on what the core domain of the system was. Not what it should be, but what it was. For one group, it was the part that replaced a paper form, another it was the kids the system was intending to help, another it was bringing those kids to trial and another the outcome of those cases. Each has wildly different motivations and workflows, and even different metrics on which they are measured.

Beyond that, we had directly opposed motivations. While one group was focused on keeping kids out of jail, another was managing cases to put them in jail! With such different views, it was quite difficult to build a system that met the needs of both. Even to the point where the conduits to use were completely out of touch with the basic workflow of each group. Unsurprisingly, one group had to win, so the focus of the application was seen mostly through the lens of a single group.

### Lesson 4: Ubiquitous language needs consensus

A slight variation on lesson 2, we had a core entity on our model where at least the name meant something to everyone in the working group. However, that something again varied wildly from group to group.

For one group, the term was in reference to a paper form filed. Another, something as part of a case. Another, an event with a specific legal outcome. And another, it was just something a kid had done wrong and we needed to move past. I’m simplifying and paraphrasing of course, but even in this system, a legal one, there were very explicit legal definitions about what things meant at certain times, and reporting requirements. Effectively we had created one master document that everyone went to to make changes. It wouldn’t work in the real world, and it was very difficult to work in ours.

### Lesson 5: Structural patterns are the least important part of DDD

Early on we spent a \*ton\* of time on getting the design right of the DDD building blocks: entities, aggregates, value objects, repositories, services, and more. But of all the things that would lead to the success or failure of the project, or even just slowing us down/making us go faster, these patterns were by far the least important.

That’s not to say that they weren’t valuable, they just didn’t have a large contribution to the success of the project. For the vast majority of the domain, it only needed very dumb CRUD objects. For a dozen or so very particular cases, we needed highly behavioral, encapsulated domain objects. Optimizing your entire system for the complexity of 10% really doesn’t make much sense, which is why in subsequent systems we’ve moved towards a more CQRS model, where each command or query has complete control of how to model the work.

With commands and queries, we can use pretty much whatever system we want – from straight up SQL to event sourcing. In this system, because we focused on the patterns and layers, we pigeonholed ourselves into a singular pattern, system-wide.

Next up – lessons learned from the new system that offered us a do-over!
