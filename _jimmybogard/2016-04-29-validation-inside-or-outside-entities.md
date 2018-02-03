---
wordpress_id: 1180
title: Validation inside or outside entities?
date: 2016-04-29T19:45:32+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1180
dsq_thread_id:
  - "4787690216"
categories:
  - DomainDrivenDesign
---
A common question I get asked, especially around a vertical slice architecture, is where does validation happen? If you’re doing DDD, you might want to put validation inside your entities. But personally, I’ve found that validation as part of an entity’s responsibility is just not a great fit.

Typically, an entity validating itself will do so with validation/data annotations on itself. Suppose we have a Customer and its First/Last names are “required”:

[gist id=bd3e2a7f43b5ce09c5c07502c88a9ed7]

The issue with this approach is twofold:

  * You’re mutating state before validation, so your entity is allowed to be in an invalid state.
  * There is no context of what the user was trying to do

So while you can surface these validation errors (typically from an ORM) to the end user, it’s not easy to line up the original intent with the implementation details of state. Generally I avoid this approach.

But if you’re all up in DDD, you might want to introduce some methods to wrap around mutating state:

[gist id=5fdcf142da23d0ef74a917dafeb392b6]

Slightly better, but only slightly, because the only way I can surface “validation errors” are through exceptions. So you don’t do exceptions, you use some sort of command result:

[gist id=6915c225c9f5a5df7cb80c33c1329e5b]

Again, this is annoying to surface to the end user because I have one validation error at a time being returned. I can batch them up, but how do I correlate back to the field name on the screen? I really can’t. Ultimately, entities are lousy at command validation. Validation frameworks, however, are great.

### Command validation

Instead of relying on an entity/aggregate to perform command validation, I entrust it solely with invariants. Invariants are all about making sure I can transition from one state to the next wholly and completely, not partially. It’s not actually about validating a request, but performing a state transition.

With this in mind, my validation centers around commands and actions, not entities. I could do something like this instead:

[gist id=77418363357f563348b1dc1b98e70ded]

My validation attributes are on the command itself, and only when the command is valid do I pass it to my entities for state transition. Inside my entity, I’m responsible for successfully accepting a ChangeNameCommand and performing the state transition, ensuring my invariants are satisfied. In many projects, I wind up using FluentValidation instead:

[gist id=00580a98bc9129199ecf4be67903baa5]

The key difference here is that I’m validating a command, not an entity. And since entities themselves are not validation libraries, it’s much, much cleaner to validate at the command level. Because the command is the form I’m presenting to the user, any validation errors are easily correlated to the UI since the command was used to build the form in the first place.

Validate commands, not entities, and perform the validation at the edges.