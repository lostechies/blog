---
title: 'Ditch the Repository Pattern Already'
date: 2018-02-20T21:00:00+00:00
author: Derek Greer
layout: post
tags: [repository]
---

One pattern that still seems particularly common among .Net developers is the <a href="https://martinfowler.com/eaaCatalog/repository.html">Repository pattern.</a> 
I began using this pattern with NHibernate around 2006 and only abandoned its use a few years ago.

I had read several articles over the years advocating abandoning the Repository
pattern in favor of other suggested approaches which served as a pebble in my
shoe for a few years, but there were a few design principles whose application
seemed to keep motivating me to use the pattern.  It wasn't until a change of
tooling and a shift in thinking about how these principles should be applied
that I finally felt comfortable ditching the use of repositories, so I thought
I'd recount my journey to provide some food for thought for those who still
feel compelled to use the pattern.

## Mental Obstacle 1: Testing Isolation

What I remember being the biggest barrier to moving away from the use of repositories was writing
tests for components which interacted with the database.  About a year or so
before I actually abandoned use of the pattern, I remember trying to stub out a
class derived from Entity Framework's DbContext after reading an
anti-repository blog post.  I don't remember the details now, but I remember it
being painful and even exploring use of a 3rd-party library designed to help
write tests for components dependent upon Entity Framework.  I gave up after a while,
concluding it just wasn't worth the effort.  It wasn't as if my previous
approach was pain-free, as at that point I was accustomed to stubbing out
particularly complex repository method calls, but as with many things we often
don't notice friction to which we've become accustomed for one reason or
another.  I had assumed that doing all that work to stub out my repositories
was what I should be doing.

Another principle that I picked up from somewhere (maybe the big <a
href="http://xunitpatterns.com/">xUnit Test Patterns</a> book? ... I don't remember) that seemed to keep me bound to my repositories was
that <a href="http://aspiringcraftsman.com/2012/04/01/tdd-best-practices-dont-mock-others/">you shouldn't write tests that depend upon dependencies you
don't own</a>.  I believed at the time that I should
be writing tests for Application Layer services (which later morphed into
discrete dispatched command handlers) and the idea of stubbing out either
NHIbernate or Entity Framework violated my sensibilities.

## Mental Obstacle 2: The Dependency Inversion Principle Adherence

The Dependency Inversion Principle seems to be a source of confusion for many which
stems in part from the similarity of wording with the practice of
<a href="https://lostechies.com/derickbailey/2011/09/22/dependency-injection-is-not-the-same-as-the-dependency-inversion-principle/">Dependency Injection</a>
 as well as from the fact that the pattern's formal definition
reflects the platform from whence the principle was conceived (i.e. C++).  One
might say that the abstract definition of the Dependency Inversion Principle
was too dependent upon the details of its origin (ba dum tss).  I've written
about the principle a few times (perhaps my most succinct being
<a href="https://stackoverflow.com/a/1113937/1219618">this Stack Overflow answer</a>),
but put simply, the Dependency Inversion Principle has at its
primary goal the decoupling of the portions of your application which define <i>policy</i>
from the portions which define <i>implementation</i>.  That is to say, this
principle seeks to keep the portions of your application which govern what your
application does (e.g. workflow, business logic, etc.) from being tightly
coupled to the portions of your application which govern the low level details
of how it gets done (e.g. persistence to an Sql Server database, use of Redis
for caching, etc.).

A good example of a violation of this principle, which I recall from my NHibernate
days, was that once upon a time NHibernate was tightly coupled to log4net. 
This was later corrected, but at one time the NHibernate assembly had a hard
dependency on log4net.  You could use a different logging library for your own
code if you wanted, and you could use binding redirects to use a different
version of log4net if you wanted, but at one time if you had a dependency on
NHibernate then you had to deploy the log4net library.  I think this went
unnoticed by many due to the fact that most developers who used NHibernate also
used log4net.

When I first learned about the principle, I immediately recognized that it seemed to
have limited advertized value for most business applications in light of what
Udi Dahan labeled<a href="http://udidahan.com/2009/06/07/the-fallacy-of-reuse/">
The Fallacy Of ReUse</a>.  That is to say, <i>properly understood</i>, the Dependency
Inversion Principle has as its primary goal the reuse of components and keeping
those components decoupled from dependencies which would keep them from being
easily reused with other implementation components, but your application and
business logic isn't something that is likely to ever be reused in a different
context.  The take away from that is basically that the advertized value of
adhering to the Dependency Inversion Principle is really more applicable to
libraries like NHibernate, Automapper, etc. and not so much to that workflow
your team built for Acme Inc.'s distribution system.  Nevertheless, the
Dependency Inversion Principle had a practical value of implementing an
architecture style Jeffrey Palermo labeled 
<a href="http://jeffreypalermo.com/blog/the-onion-architecture-part-1/">the Onion Architecture.</a>
Specifically, in contrast to <a href="https://msdn.microsoft.com/en-us/library/ff650258.aspx">
traditional 3-layered architecture models</a>
where UI, Business, and Data Access layers precluded using
something like
<a href="https://msdn.microsoft.com/en-us/library/ff648105.aspx?f=255&amp;MSPPError=-2147217396">Data Access Logic Components</a>
to encapsulate an ORM to map data directly to entities within
the Business Layer, inverting the dependencies between the Business Layer and
the Data Access layer provided the ability for the application to interact with
the database while also <i>seemingly </i>abstracting away the details of the
data access technology used.

While I always saw the fallacy in strictly trying to apply the Dependency Inversion
Principle to invert the implementation details of how I got my data from my
application layer so that I'd someday be able to use the application in a
completely different context, it seemed the academically astute and in vogue
way of doing Domain-driven Design at the time, seemed consistent with the GoF's
advice to program to an interface rather than an implementation, and provided
an easier way to write isolation tests than trying to partially stub out ORM
types.


## The Catalyst

For the longest time, I resisted using Entity Framework.  I had become fairly
proficient at using NHibernate, the early versions of Entity Framework were years behind in features and
maturity, it didn't support Domain-driven Design well, and there was a fairly steep learning curve
with little payoff.  A combination of things happened, however, that began to make it harder to ignore.
First, a lot of the NHibernate supporters (like many within the Alt.Net
crowd) moved on to other platforms like Ruby and Node.  Second, despite it lacking many features,
.Net developers began flocking to the framework in droves due to it's backing and promotion by Microsoft.
So, eventually I found it impossible to avoid which led to me trying to apply
the same patterns I'd used before with this newer-to-me framework.

To be honest, once I adapted my repository implementation to Entity Framework
everything mostly just worked, especially for the really simple stuff.
Eventually, though, I began to see little ways I had to modify my abstraction
to accommodate differences in how Entity Framework did things from how
NHibernate did things.  What I discovered was that, while my repositories
allowed my application code to be physically decoupled from the ORM, the way I
was using the repositories was in small ways semantically coupled to the
framework.  I wish I had kept some sort of record every time I ran into
something, as the only real thing I can recall now were motivations with
certain design approaches to expose the SaveChanges method for
<a href="https://lostechies.com/derekgreer/2015/11/01/survey-of-entity-framework-unit-of-work-patterns/">
Unit of Work implementations</a>.
I don't want to make more of the semantic coupling argument
against repositories than it's worth, but observing little places where
<a href="https://www.joelonsoftware.com/2002/11/11/the-law-of-leaky-abstractions/">my abstractions were leaking</a>,
combined with the pebble in my shoe from developers who I felt
were far better than me which were saying I shouldn't use them lead me to begin
rethinking things.

## More Effective Testing Strategies

It was actually a few years before I stopped using repositories that I stopped
stubbing out repositories.  Around 2010, I learned that you can use Test-Driven
Development to achieve 100% test coverage for the code for which you're
responsible, but when you plug your code in for the first time with that team
that wasn't designing to the same specification and not writing any tests at
all that things may not work.  It was then that I got turned on to Acceptance
Test Driven Development.  What I found was that writing high-level subcutaneous
tests (i.e. skipping the UI layer, but otherwise end-to-end) was overall
easier, was possible to align with acceptance criteria contained within a user
story, provided more assurance that everything worked as a whole, and was
easier to get teams on board with.  Later on, I surmised that I really
shouldn't have been writing isolation tests for components which, for the most
part, are just specialized facades anyway.  All an isolation test for a facade
really says is "did I delegate this operation correctly" and if you're not
careful you can end up just writing a whole bunch of tests that basically just
validate whether you correctly configured your mocking library.


So, by the time I started rethinking my use of repositories, I had long since stopped
using them for test isolation.

## Taking the Plunge
It was actually about a year after I had become convinced that
repositories were unnecessary, useless abstractions that I started working with
a new codebase I had the opportunity to steer.  Once I eliminated them from the
equation, everything got so much simpler.   Having been repository-free for
about two years now, I think I'd have a hard time joining a team that had an
affinity for them.

## Conclusion
 If you're still using repositories and you don't have some
other hangup you still need to get over like writing unit tests for your
controllers or application services then give the repository-free lifestyle a
try.  I bet you'll love it.


