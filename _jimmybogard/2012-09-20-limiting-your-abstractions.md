---
id: 674
title: Limiting your abstractions
date: 2012-09-20T14:14:53+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2012/09/20/limiting-your-abstractions/
dsq_thread_id:
  - "851933198"
categories:
  - Architecture
---
It’s been almost 3 years since I first wrote about [moving away from the Repository abstraction](http://lostechies.com/jimmybogard/2009/09/11/wither-the-repository/). Since then, I’ve gone more or less full-bore without any concept of a repository in the systems I’ve built. I haven’t removed existing repositories, but I’m just not finding any value in them as an abstraction.

Repositories I see generally come in two flavors:

  * Abstracting the ORM framework
  * Encapsulating queries

An example of the first might be something like:

[gist id=3755794]

While one encapsulating queries would more more along the lines of:

[gist id=3755811]

Where each method encapsulates a single query. Both cases provide value in certain cases. If I have a goal of abstracting my ORM, I would go with the first, and perhaps include the second as well.

But is an ORM something that requires abstraction? I don’t think so – abstracting something like an ORM actively prevents me from using powerful features. An ORM is already an abstraction, we really need to question whether we need to abstract an abstraction.

### Digging deeper

We need to go back to _why_ we introduced the Repository pattern in the first place. It was likely in the name of “testability”. We might start with something like this:

[gist id=3755845]

Seems complex, no? However, if the complexity grows, we’re still limiting its scope to exactly one method. Whether we pull this query out into a class, repository or extension method, the query will be in one method. In our controller action, what does it matter exactly that this code lies in our controller or another class? What about a more complex example:

[gist id=3755895]

Again, it’s just a set of queries. I’d still want to encapsulate this in one spot, but I really don’t see a reason to move this code out from where it is. If the query changes, I’m still just changing code in one spot. An abstraction here would only serve to misdirect.

The trick is when I have more than one concept in play. Let’s look at an action that has to do a couple of different things (queries are quite dull, it turns out):

[gist id=3755938]

In this case, I have a lot of validation, but the actual work is delegated to the “AddCommentTask” object. It’s a command object, that takes care of performing the actual work of the task outside of MVC, validation, ActionResults and the like.

We limited our abstractions to concepts (tasks) and we could do the same with queries if we started to have more than one concept at play.

### Testing strategies

My testing strategy these days is:

  * Unit test isolated components (domain models and other already isolated classes)
  * Integration test the rest

I don’t do automocking containers. I only stub out components I can’t control. Otherwise, it’s a strategy of pushing behavior as far down as possible, but not by introducing abstractions.

For something like a database, my tests will be slower. I’m willing to accept that, since the tradeoff is ease of refactoring. My tests don’t break because something needs to be stubbed differently.

In these controllers, I would just make sure I have a seam to test. In the RaccoonBlog case, it’s just a matter of swapping out the underlying session with one going against an in-memory version, and my tests become much faster. But the seam exists.

But otherwise, I just don’t bother. Introducing a repository merely to stub something out is a waste of time from my experience. It introduces an unnecessary abstraction, where a concept (an encapsulated query object) would suffice. And even then, my test would look exactly the same.

Rather than focusing on abstractions, I’m instead focusing on concepts, and let the tests fall where they may. After all, my controllers above aren’t object-oriented – they’re procedural, as their needs warrant.