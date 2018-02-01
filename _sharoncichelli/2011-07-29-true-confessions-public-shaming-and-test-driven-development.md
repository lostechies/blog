---
id: 166
title: True Confessions, Public Shaming, and Test-Driven Development
date: 2011-07-29T16:37:51+00:00
author: Sharon Cichelli
layout: post
guid: http://lostechies.com/sharoncichelli/?p=166
dsq_thread_id:
  - "1069749400"
categories:
  - Unit Testing
---
Okay, I admit it. Sometimes I write unit tests second instead of first. I also bite my nails and rest my elbows on the dinner table. But when I&#8217;ve got a bug to fix, and I&#8217;ve already found the offending line, I can hardly resist the urge to just&#8230; just&#8230; _change_ it. I&#8217;ll follow up with unit tests afterwards, promise.

I admit this to you because admitting my wrongs is a step towards rehabilitation. I admit this to save you pain. Learn from my example. Test-second is so much less efficient than test-first. Consider the following workflow:

  1. Reproduce, identify, debug the issue.
  2. Fix the code.
  3. Compile and try it out.
  4. Write a test that proves I fixed it.
  5. Compile and run the test.
  6. Change the code back to make sure my test really proves what it is trying to prove.
  7. Compile and see the test fail.
  8. Re-fix the code.
  9. Compile and see the test pass.

I humble myself before you. How much time am I wasting there? It&#8217;s embarrassing.

There&#8217;s also a subtle point in step 1. What if I could use unit tests instead of the debugger to find the issue? That will be faster, too.

We can do better:

  1. Reproduce the issue and formulate a theory.
  2. Write a test that exercises the theory.
  3. Compile and see the test fail, corroborating the theory.
  4. Fix the code.
  5. Compile and see the test pass, validating the theory.

Perhaps you can relate. Perhaps you even bite your nails, too. I won&#8217;t judge. Flog me or join me, the comments are open: Confess your bad habits (um, your _unit-testing_ bad habits, please), and commit yourself to improvement. I challenge you to improve your efficiency and write your unit tests first, even&mdash;especially&mdash;for the little bug fixes.