---
id: 386
title: Context and Best Practices
date: 2010-01-26T14:25:47+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2010/01/26/context-and-best-practices.aspx
dsq_thread_id:
  - "264716410"
categories:
  - DomainDrivenDesign
---
Last night, I had a Skype/SharedView session with a buddy in Arkansas trying to apply DDD and “best practices” to an application he was building.&#160; He wanted to use all the ALT.NET tools he’s heard so much about, such as NHibernate, StructureMap and so on.&#160; The problem came when he went to go look at the sample applications for “Floogle Architecture”, and was basically stopped dead in his tracks.&#160; His question to me was, “do I really have to do all this?&#160; It seems like a little overkill”.&#160; He had looked at several reference applications for every different Floogle Architecture out there, and all confused more than enlightened.

Back when I was getting started trying to apply design principles to my work, I also yearned for that golden reference application that would just tell me what I needed to do, or at least show me what I _shouldn’t_ do.&#160; I remember looking at JP Boodhoo’s application he built after a Nuthin But Dot Net course, and I had the same thoughts.&#160; “Do I really have to do all this?&#160; It seems like a little overkill.”&#160; What my buddy and I were missing was **context**.

Earlier that day, I had a Q&A session with another buddy in town that’s been developing Rails apps to production for around 4 years.&#160; Over the course of the past couple of years or so, I’ve also built up a set of mental best practices when it comes to building ASP.NET MVC applications.&#160; But something had been nagging me.&#160; Rails folks have built large, testable, scalable applications with **far far less moving parts**.&#160; Why do I need all these moving parts, indirections, abstractions and so on to be successful, when plenty of other folks are successful without them?&#160; Talking with these two folks in one day reminded me (again): **Context is king.**

### The Right Way versus the Better Way

My .NET buddy was building a small application.&#160; It had something like 4 entities and less than 10 screens.&#160; It was a small application built for a specific purpose, and wasn’t really going to get much bigger.&#160; The Floogle Architecture reference applications are built with a much different context .&#160; They could be for applications with hundreds of controllers, dozens upon dozens of entities, and very complex screens.&#160; However, all of that context is missing in each respective reference application.

One of the sticking points from Eric Evans when describing DDD was that DDD was **never meant to be applied to every solution**.&#160; It’s hard, it’s complex, and it takes a lot of work and collaboration.&#160; In fact, I’ve heard quoted that something like 95% of every application built is not complex enough to warrant a DDD solution.&#160; **So why is every application I build using the most complex DDD architecture?**&#160; Am I special?&#160; Do I live solely in that 5%, or have I just decided to pick one architecture and apply it globally, no matter the context?

When reviewing my Rails buddy’s actual production Rails app, I was struck by how little code there was, and how flat the architecture is.&#160; He had Model, Views and Controllers, **and that’s it!**.&#160; All these pieces that I put in place to support complexity, such as a service layer, dependency injection, factories, indirection, facades, the list goes on, were just _not needed_ in his projects.&#160; That’s not to say that the Rails app wasn’t complex.&#160; It had complex querying, validation, caching and so on, but it just didn’t need a lot of code to do so.&#160; Rails apps don’t even have the concept of a _project,_ yet all Floogle Architecture examples highlight the need for proper layer separation through project structure.

Instead of focusing on the “Right Way” to build an application, I should have focused on the “Better Way”.&#160; Sometimes the better way to build an application is to pick the absolute simplest architecture imaginable.&#160; Sometimes I don’t need DDD.&#160; Sometimes I should just use ActiveRecord, because I just don’t have that domain complexity.&#160; When I taught a class for ASP.NET MVC recently, I threw out all my default usage patterns, because building from scratch would pretty much guarantee I built the minimum I actually needed for the context at hand.

### Default Architectures

One of the books that heavily influenced my understanding of DDD was [Jimmy Nilsson’s book](http://www.amazon.com/Applying-Domain-Driven-Design-Patterns-Examples/dp/0321268202).&#160; In it, he talks about a “new default architecture”.&#160; So I developed an architecture, and applied it pretty much without any thought to every. single. project I worked on.&#160; It works well because I know it and understand it, I know its limitations and its constraints, and I know where it can bend complexity-wise.&#160; Over the years, this default architecture has grown and grown to basically handle every complexity I’ve ever seen.&#160; It’s now very flexible…but very difficult to understand.&#160; Pick any reference DDD architecture out there, and you’ll see the same thing.

And that’s where my .NET buddy went wrong.&#160; He picked what he thought was a default MVC architecture, when instead it was a reference DDD architecture.&#160; His first question should have been, “do I need DDD?”.&#160; In his case, decidedly not.&#160; In in most cases, decidedly not.&#160; When talked with my Rails buddy and mentioned the word “Entity”, I was met with a blank stare.&#160; When I sketched out the flow of control in our default architecture, all the pieces _we_ had to develop, his (polite) response was “That looks…hard…”.&#160; Yes, yes it is hard.&#160; It was completely necessary for the context in which we first developed it, _but not for every context_.

So why do I try and apply that architecture to every context?&#160; **Because I’m lousy at predicting complexity.**&#160; However, Rails folks have happily developed large systems to production _without_ all the pieces I decided I needed for every project.&#160; Instead of looking for a “Default Architecture”, I should instead be looking for the “Better Architecture Choice for This Context”.

### Starting Small

In the upcoming conversations with my .NET buddy, I’m going to have him throw out all the default architectures he’s looked at.&#160; They are interesting from a patterns/style perspective, but _utterly useless_ if you don’t understand the context behind the decisions that brought the samples to that point.&#160; And for his case, he just doesn’t need them.

Instead, he needs things like “how do I integrate NHibernate?” and “why should I use a DI framework?”.&#160; All the rest can be built up as needed, in a YAGNI fashion, when (or if) the application and the business requirements demand the need for DDD and a complex architecture.