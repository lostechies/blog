---
wordpress_id: 586
title: OSS Rules of Engagement
date: 2012-02-08T14:07:55+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/02/08/oss-rules-of-engagement/
dsq_thread_id:
  - "568803318"
categories:
  - OSS
---
After [two](http://ayende.com/blog/154305/send-me-a-patch-for-that) [posts](http://wekeroad.com/2012/02/07/kiss-the-ring/) to a [reaction](http://devlicio.us/blogs/hadi_hariri/archive/2012/02/06/submit-a-patch.aspx) of a [comment](https://lostechies.com/jimmybogard/2012/02/01/improving-the-git-windows-experience-downloads/#comment-426770262) on [feedback I had for the Git installer](https://lostechies.com/jimmybogard/2012/02/01/improving-the-git-windows-experience-downloads/), I thought it was pertinent to share my thoughts on OSS rules of engagement. [Scott Chacon](http://scottchacon.com/) left a comment along the lines of “your time spent complaining is better directed at submitting a pull request”. Which, as an OSS developer and project maintainer, I agree up to a point, until that reaction discourages feedback.

I understand how daunting it can be to contribute to an unfamiliar project, especially if you recognize that the people most familiar with the codebase would take a lot less time to do so, and probably do it “right” in the first place. I also understand how frustrating it can be to have large, visible OSS project where the number of people complaining/giving feedback far dwarfs the number of people actually contributing.

So what are the rules of OSS engagement for me?

### 1. Un-actionable complaints will largely be ignored

Mostly because I don’t have too much time to figure out what you want. I generally will respond with prodding, but unless you respond back, I won’t have anything actionable to address. Having an example of the alternative is generally the minimal bar here.

### 2. Feedback is encouraged. Example client code even better

As an OSS developer maintaining libraries, I often get feedback of “Can it do XYZ?”. Sometimes the answer is No, but I would like to see what your vision of how it should behave.

What should the methods be called? What does the configuration look like? What’s an example of the behavior you’re envisioning?

I don’t even care if the code compiles – just show me an example of what you’re thinking.

### 3. Unit tests for bugs encouraged, but not required

I just really need code to reproduce the bug. A report of a bug with zero code is much harder to reproduce, and much less likely to get fixed.

If you want to up your odds of getting a bug fixed, the more code I get demonstrating the problem, the better.

### 4. The more actionable the feedback, the more likely it gets integrated.

Pull requests are at the top end of the “actionable feedback” scale. An email reporting a bug with no code as at the low end. The more actionable the feedback I receive, the more likely I will have the time/energy to respond to the feedback.

However, I won’t turn people away for _not_ giving me a pull request. I encourage it, and often point folks to try, especially if they want to “up the odds”.

**I might encourage you to send me a pull request, but I’ll never disparage you for _not_ sending me one.**