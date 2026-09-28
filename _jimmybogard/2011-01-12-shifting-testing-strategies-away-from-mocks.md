---
wordpress_id: 447
title: Shifting testing strategies away from mocks
date: 2011-01-12T01:51:36+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2011/01/11/shifting-testing-strategies-away-from-mocks.aspx
dsq_thread_id:
  - "264716639"
categories:
  - BDD
redirect_from: "/blogs/jimmy_bogard/archive/2011/01/11/shifting-testing-strategies-away-from-mocks.aspx/"
---
Over the past couple of years or so, I’ve started to come to the opinion that reliance on mocks for driving out design can seriously hamper large- to medium-scale refactoring efforts.&#160; Things like adding method parameters, renames and the like aren’t affected.&#160; But many of the techniques in [Refactoring](http://www.amazon.com/Refactoring-Improving-Design-Existing-Code/dp/0201485672) and [Refactoring to Patterns](http://www.amazon.com/Refactoring-Patterns-Joshua-Kerievsky/dp/0321213351) become quite difficult to do when our tests are overly concerned with the implementation details of our system under test.

Before I get to the punch line, it might be worth setting up the context of how I got here.&#160; Up until of a couple of years ago, I had written my unit tests in a very top-down, one-layer-at-a-time approach.&#160; I’d do some whiteboarding, figure out what my top-level component looked like through tests, and built interfaces and mocked out interactions with lower-level components.&#160; **At no point was I testing the top-level component using the actual low-level component.**

Two things started to influence my testing strategies away from that notion.&#160; One was experience trying to do large refactorings, where I was pulling out cross-cutting concerns across an entire layer of the system.&#160; At that point, all my unit tests with all their mocks were a large barrier to these design changes.&#160; The tests were concerned with low-level interactions between components.&#160; But at this level of refactoring, those interactions were about to get deleted, but I still had interesting parts of those tests I wanted to keep.&#160; Namely, the direct inputs and outputs of the component, and I could give a flying [bleep] about the indirect inputs and outputs.

At some point, I wanted a test that **only concerned itself with observable results**.

### Shift towards BDD

Following the talks and guidance from [Scott Bellware](http://blog.scottbellware.com/), I started writing more tests in the Context-Specification style of tests.&#160; That is, combining [testcase-class-per-fixture](http://xunitpatterns.com/Testcase%20Class%20per%20Fixture.html) and a naming style that focused on describing the behavior of the system from a user’s point of view (though who that user might be would change depending on the perspective).

At that point, talking about the interactions of between dependencies became less interesting.&#160; Specifically, because I found that except for unobservable indirect outputs (sending an email, webservices and the like), the language centered around things that I _could_ observe.

If implementation detail language was removed from the test names, I found myself far more concerned about how the real system behaved.&#160; When test names and code were then using the real component and its real dependencies, I found myself far more amenable to making big sweeping changes in responsibilities, because at every level, I was describing the behavior of the direct, observable behavior.

### Observing indirect outputs

Indirect outputs (a void method) are usually tested in a mocking framework by either setting an expectation that the method will be called, or asserting afterwards that the method WAS called.&#160; But what if the real component was used?&#160; The method was called in order to affect a change in something, that’s the whole point of commands.&#160; Commands are intended to induce a side effect, it’s now just up to us to observe it.

For unit tests, I draw the line here when the request crosses the process boundary (database, queue etc).&#160; However, I’ll still build full-system tests that do perform a command and directly observe all that there is to observe (granted that I actually own the observable systems).&#160; If I don’t own that system that I can observe, that’s usually when our partners complain that I’m calling their tests systems too often and please stop.

When building out the components, I still do things like program to interfaces, as it still helps me build out a component’s shape without worrying about an implementation yet.&#160; In the test, I’ll use a container to instantiate the components, only filling in process-crossing components with mocks.

### Supplying indirect inputs

Indirect inputs are dependencies whose methods that are called return a value.&#160; Same as indirect outputs – if the component crosses a process boundary, I’ll supply a fake or a stub.&#160; In integration tests, I’ll supply the real component if it’s a system I own, otherwise I’ll keep the fake or stub.

_Side note – I’m not a fan of committing always-running tests that hit systems I don’t own.&#160; I don’t want a failed build because someone else’s test system isn’t up._

If it becomes difficult to set up these inputs, there are patterns for that.&#160; Whether it’s object mother, fixtures or the builder pattern, I can still keep my tests concise and understandable, and push down the setup logic into helper components.

### The end result

I’m still doing top-down design, but now I’m supplying the real components as much as possible.&#160; I test at the detail as directed by the design of the component I’m building, but I allow the underlying components to do their work.&#160; This cuts down on mock setups that don’t actually match what can happen in production – if you use the real deal, you can’t fake an impossible situation.

There are downsides to this approach of which I’m well aware – defect isolation being a big one.&#160; But the tradeoff for an actual safety net instead of a noose makes up for this.