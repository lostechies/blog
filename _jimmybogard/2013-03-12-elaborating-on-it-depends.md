---
id: 741
title: Elaborating on “it depends”
date: 2013-03-12T13:09:08+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=741
dsq_thread_id:
  - "1132566026"
categories:
  - Agile
  - TDD
---
On the discussion on “When should I test?”, I followed up with a conversation:

When it provides value.

When is that?

It depends.

And it truly does depend. But upon what? That’s trickier to answer – and there is no absolute, concrete prescriptive guidance that will tell you in a given situation, that writing a test will provide value.

I started out my TDD experience writing unit tests all the time. Chasing “everything is unit tested” didn’t provide ultimate value. I started writing other tests as well. I went test-first, test-after, and test-when-I-feel-like-it. I’ve done unit tests, integration tests, subcutaneous tests, UI tests, functional tests, acceptance tests, and pretty much everything in-between. I’ve used mocking frameworks, sworn off mocking frameworks, used auto-mocking containers, swore off auto-mocking containers, used test generators, swore off test generators.

After all this time and all these tests, I’ve come to the conclusion that ultimately I was chasing the wrong goal. My goal is to make my customers successful. Not write software.

If my solution does require software, then I write software that provides value. If my software changes over time, then I write software in a way that enables change.

Sometimes that involves tests, sometimes it doesn’t. How do I know when to write tests? When I can see that not having them will hamper me in providing value. How do I know when not to write tests? When I can see that having them will hamper me in providing value.

It took me a long time to get to this point, so for folks new to testing, it’s important to build the experience to know when you feel value is there. Zero tests in all situations – not a good idea. 100% coverage in all situations – also not a good idea.

But not everyone should take the same 5-10 year journey to get at this point. So where should we start? In a codebase with no tests, end-to-end tests as a security blanket provide the most value.

From there, add tests when you feel like they add value. Not before.