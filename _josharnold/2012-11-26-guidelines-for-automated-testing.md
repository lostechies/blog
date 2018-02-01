---
id: 222
title: Guidelines for Automated Testing
date: 2012-11-26T16:30:40+00:00
author: Josh Arnold
layout: post
guid: http://lostechies.com/josharnold/?p=222
dsq_thread_id:
  - "944914039"
categories:
  - general
tags:
  - automated-testing
  - guidelines-automated-testing
---
### Overview

Continuing the theme of my most recent posts, I’ve decided to start a series on Automated Testing. I’ll be pulling from lessons learned on all of the crazy things that I’ve been involved with over the last year.

> <span style="background-color: #ffffff; font-size: medium;"><span style="font-size: medium;">It’s a known fact that preemptively writing a table of contents means that you will never get around to finishing a series. Don’t worry, I&#8217;ve already written and scheduled each post.</span></span>

### Table of Contents

  1. Rapid feedback cycle ([Jeremy covered this one](http://jeremydmiller.com/2012/10/11/test-with-the-finest-grai/))
  2. [System state](http://lostechies.com/josharnold/2012/11/11/some-foundational-ideas-for-automated-testing/)
  3. [Collapsing your application into a single process](http://lostechies.com/josharnold/2012/11/16/automated-testing-with-fubumvc-storyteller-and-serenity/)
  4. [Defining test inputs](http://lostechies.com/josharnold/2012/11/28/guidelines-for-automated-testing-defining-test-inputs/)
  5. Standardizing your UI mechanics
  6. Separating test expression from screen drivers
  7. Modeling steps for reuse
  8. Providing contextual information about failures
  9. Dealing with AJAX
 10. Utilizing White-box testing for cheaper tests