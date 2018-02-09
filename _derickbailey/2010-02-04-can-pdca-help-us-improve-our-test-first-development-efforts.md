---
wordpress_id: 102
title: Can PDCA Help Us Improve Our Test-First Development Efforts?
date: 2010-02-04T04:42:52+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/02/03/can-pdca-help-us-improve-our-test-first-development-efforts.aspx
dsq_thread_id:
  - "262068398"
categories:
  - Agile
  - Community
  - Kaizen
  - Lean Systems
  - Philosophy of Software
  - Standardized Work
redirect_from: "/blogs/derickbailey/archive/2010/02/03/can-pdca-help-us-improve-our-test-first-development-efforts.aspx/"
---
I was thinking about target conditions and the [Plan-Do-Check-Act (PDCA)](http://en.wikipedia.org/wiki/PDCA) cycle earlier today when a code related issue that I was having popped into head and decided to meld with the current string of thoughts. The resulting thought was leading me toward wondering if a PDCA approach to test-first development (TDD/BDD/etc) would be of significant benefit. 

The basic idea behind PDCA is to work in small steps toward a defined goal – not an specific implementation as a goal, but a process as a goal. We would need to find a goal that defines a process and find small steps that can provide feedback quickly, allowing us to adjust our approach to the goal as needed. 

It seems that user stories and acceptance criteria are already a fit for this type of goal and the PDCA cycle. A user story and it’s acceptance criteria does not describe an implementation, but a process that the software should provide. 

  * Plan: discuss the story and criteria detail
  * Do: implement a criteria or two
  * Check: get feedback from customer rep on the increment of functionality
  * Act: adjust as needed based on feedback, and start the PDCA cycle again 

I’m also wondering if the test-first process itself could benefit from a PDCA cycle… this is my first attempt and fleshing out the idea, so it’s probably a bit off, still.

  * Plan: write a failing test to begin the implementation of an acceptance criteria (Red)
  * Do: make the test pass (Green)
  * Check: validate the full business needs technical standards against the implementation
  * Act: adjust the implementation as needed (Refactor)

Is there any value in this? is it just a bunch of uber-geekery babble or nonsense? Is it painfully obvious and doesn’t need to be restated as PDCA? I’m interested in honest feedback on the idea and whether or not you think there could be any value in taking a PDCA based approach to test-first development.