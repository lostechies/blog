---
wordpress_id: 126
title: Why I Write Automated Tests For My Code
date: 2010-03-29T18:07:19+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/03/29/why-i-write-automated-tests-for-my-code.aspx
dsq_thread_id:
  - "269589003"
categories:
  - Agile
  - Behavior Driven Development
  - Craftsmanship
  - Pragmatism
  - Quality
  - Unit Testing
redirect_from: "/blogs/derickbailey/archive/2010/03/29/why-i-write-automated-tests-for-my-code.aspx/"
---
I started my journey of unit testing my code about 4 years ago… I had played with nunit prior to that, but I never understood the point and would delete my tests after I got them to pass… that was a long time ago, and of course I’m much more educated and experienced now. 🙂 One of the interesting things that I’ve noticed in myself over the years, concerning tests, is a change in why I write tests for my code. I’m not sure I could articulate all the various reasons that have come and gone since I started this journey, so I won’t try to do that. Rather, I wanted to note why I test, currently.

I have one overarching reason that I want to write automated tests for my code. This one reason sums it up for me and encapsulates all of the other reasons that I current have, have had in the past, and will ever have. It’s a meta-reason, really… one that allows me to change the specifics of how I test and the reasons for implementation details without having to question why I am testing. 

> ### **I’m Not Smart Enough To Get It Right The First Time**

That’s it. That’s why I write automated tests for my code. I know I’m not smart enough to get it right the first time because I have empirical evidence from 10+ years of software development without automated tests. I release bugs into production… that’s what it comes down to. Honestly, I don’t even get my tests right the first time. I have to iterate over the high level of my understanding, and slowly begin to drill down into the tests one at a time, filling in the test implementation and then the actual code implementation as I go. Even with all my effort to do things right and get it done right as quickly and effectively as possible, I still screw things up. The good news is that I usually have tests in place that tell me I screwed something up before the code gets committed to source control. 

Now, I know I’m not perfect still and I won’t claim anything asinine like ‘tests help me write perfect code’. I still create bugs because I’m not perfect and my tests don’t always cover every possible combinatorial execution path in my code. That’s just unreasonable. (side note: I still claim 100% test coverage should be the default that you start with, not something that you work toward… but I’m smart enough to know that I’m only talking about symbol coverage, branch coverage, and simple function coverage. There are other types of code coverage that are unreasonable to write automated tests for all the time. There are also plenty of times and places where it takes a human to property test with exploratory methods that are not reasonable to do with automation.)

I don’t consider every “test” to be a test when I write it. In fact, I consider “tests” to be something that I write less and less frequently. Rather, I write specifications to show that my code is working as expected – [built to specification](http://www.lostechies.com/blogs/derickbailey/archive/2009/01/30/favor-defect-prevention-over-quality-inspection-and-correction.aspx). I write tests when I need to check for certain behavior or defects after the the implementation has been done. I’m testing to see how my code behaves in certain scenarios. 

There are still other reasons that I write code with a test-first approach… but I think I’ve made my primary point abundantly clear: I’m not smart enough to get it right the first time for anything of any significance. Sure, individual lines of code, methods or even classes may be correct… but I’m talking about larger functionality groups that are meaningful to the end user… it just doesn’t happen, or happens so rarely that I consider it a statistical anomaly. Even in the world of collaborative, iterative, incremental development with wonderful customer interaction, [we fail on a regular basis](http://www.lostechies.com/blogs/derickbailey/archive/2010/02/28/failure-is-not-an-option-it-is-a-requirement.aspx) and still don’t get it right the first time. The difference is that we’re not yet releasing to production when we find the failures so we have the chance to fix the failures that we have found before the end user sees them.

And lastly, I want to drop a little twitter conversation into the mix, just for fun. 🙂

&#160;

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="how does anyone have any faith in their own code / changes without automated tests to prove it works? #itbogglesthemind" src="http://lostechies.com/derickbailey/files/2011/03/image_66B7A6CD.png" width="525" height="249" />](http://twitter.com/derickbailey/statuses/11256812685)&#160;&#160; [<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="@derickbailey Actually, without tests faith is all you are left with :)" src="http://lostechies.com/derickbailey/files/2011/03/image_741DB9D3.png" width="493" height="175" />](http://twitter.com/derekgreer/statuses/11256885706)