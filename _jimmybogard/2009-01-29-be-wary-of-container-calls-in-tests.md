---
wordpress_id: 276
title: Be wary of container calls in tests
date: 2009-01-29T03:16:18+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/01/28/be-wary-of-container-calls-in-tests.aspx
dsq_thread_id:
  - "264716038"
  - "264716038"
categories:
  - Testing
---
This one cost me a couple of hours today.&#160; To be clear:

**No calls to the IoC container in a unit or integration test!**

I want my tests to fail because of an assertion failure, not because of a setup failure.&#160; Containers aren’t brittle, but they can be in a test, and an incorrectly configured container can cause an _explosion_ of failures in tests.&#160; That makes it very difficult to pinpoint a true failure.&#160; There are plenty of patterns to set up fixtures and contexts – from the Builder pattern to the Object Mother pattern to a common Setup method.&#160; All of these can set up the context of a test without using an IoC container.

I have tests for my container, but I have to be very, very wary of a container call in a test.&#160; And no, I don’t use an auto-mocking container as well, I have yet to be convinced it’s better than Builder or Object Mother.&#160; With those patterns, I can follow the yellow-brick road to exactly what’s being constructed.&#160; Not so in the event of a container failure in a test.

If you’ve had luck with containers in a test, I’d love to hear about it.