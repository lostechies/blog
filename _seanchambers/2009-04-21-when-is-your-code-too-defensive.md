---
id: 3192
title: When is your code too defensive?
date: 2009-04-21T03:44:08+00:00
author: Sean Chambers
layout: post
guid: /blogs/sean_chambers/archive/2009/04/20/when-is-your-code-too-defensive.aspx
dsq_thread_id:
  - "350593542"
categories:
  - Uncategorized
---
I had a discussion with some fellow developers a little while ago about DesignByContract and creating defensive code. The subject of being \*too\* defensive came up in the fact that while writing defensive code is a good thing, it’s not hard to go off the deep end and start building too many walls protecting your fort.

Any good developer has a certain level of skepticism when writing a line of code that depends on something from a related class/system. This includes checking for errors, making sure things are in an expected state, QA testing etc…, but when does this become too much of a burden?