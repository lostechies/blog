---
wordpress_id: 356
title: Bugs, defects and feedback
date: 2009-09-30T17:58:35+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/09/30/bugs-defects-and-feedback.aspx
dsq_thread_id:
  - "264716317"
categories:
  - Agile
redirect_from: "/blogs/jimmy_bogard/archive/2009/09/30/bugs-defects-and-feedback.aspx/"
---
In [my last post](https://lostechies.com/blogs/jimmy_bogard/archive/2009/09/29/my-favorite-bug-tracking-system.aspx), I talked about how we like to track bugs, with just pieces of paper.&#160; At lot of the responses were interesting, but I think some came back to the issue of “what is a bug?”&#160; Some felt that bugs needed to live in a more durable system (as if paper isn’t durable, and previous to around 1985 no one knew how to manage information).&#160; But for us, bugs don’t live more than 1 business day, so there’s no need to keep them around, unless we want to do trend analysis.

But one important issue is how we deal with feedback.&#160; A user can come up to us and say, “the site is broken”.&#160; That could mean a lot of things.&#160; It could mean the site is blowing up, or it could mean that they couldn’t find the “Submit Order” button.&#160; To the user, the site is broken.

Instead of referring to negative user feedback as “bugs”, we treat them as “issues”.&#160; So what is an “issue”?&#160; **An issue is negative user feedback with potentially actionable fix.**&#160;&#160; Note “potentially”.

### The feedback process

When we get an issue from a user, the issue goes into triage with the Product Owner.&#160; The Product Owner is the person/team deciding what gets developed, so it’s logical that they decide what action to take with an issue.&#160; An issue falls into two broad categories:

  * Bug
  * Defect

**A bug is an issue where the site is unusable or acceptance criteria has not been met**.&#160; This includes things from “the site is down” to “you misspelled a word”.&#160; All of our stories have tangible and intangible acceptance criteria, functional and non-functional requirements.&#160; The expectations of these have been laid forth a long time ago, so we don’t really negotiate too much on what is or is not a bug.&#160; The user may have a different idea of the classification of bug, but they don’t get to decide.

**A defect is an issue where the site is usable and acceptance criteria have been met, but the application does not work as expected**.&#160; Things in this category are “data field should be over here”, “add this label”, “this business rule isn’t quite right” and so on.&#160; We don’t expect the users to know all of the stories we’ve developed, but there are still situations where the site isn’t working like it should, but works as agreed.&#160; We work hard to do good JIT analysis, but we still miss things.

### Actions on bugs

Bugs are fixed immediately, with an SLA of one business day.&#160; We do things like branch and release-per-feature, automated builds and deployments, so we’re never more than about 15 minutes away from a commit to production fix.&#160; We refuse to keep an inventory of open bugs, so bugs are fixed as they arrive, and the team will stop their work to fix a bug.&#160; Because we stop-the-line, we strive to eliminate as many bugs as we can.&#160; This includes good design, a strong testing culture, and post-mortems on bugs to see how we can improve the next time around and eliminate the possibility of a bug like that to arise again.

### Actions on defects

Defects need to be analyzed just as much as regular stories need to, so defects enter a second queue where they either turn into stories, or something we call “tweak stories”.&#160; Stories take 1-5 business days to deliver, while a “tweak story” gets turned around as quickly as a bug.&#160; It all comes down to the complexity of the defect.&#160; In any case, the Product Owner prioritizes these defects along with stories, and ultimately it’s the PO that decides when (or if) the team takes action on a defect.

### The feedback cycle

For critical bugs, like “the site blows up”, there is no need to triage.&#160; It’s unacceptable that the site blows up, so we’ll fix those immediately.&#160; But for more subtle feedback, the developer team is ill-equipped to make a determination on the nature of an issue.&#160; Often, the development team attempts to fix every issue that comes their way, whether it’s a bug or not, in an effort to make the user happy.&#160; But the guy that says “the customer is always right”?&#160; He goes broke.&#160; The customer _isn’t_ always right, so it’s the PO’s responsibility for determining the classification of the issue.

Ultimately, it’s about roles and responsibilities.&#160; Developer teams are usually quite poor at determining the priority of work, as they don’t always have the deep business/project understanding of scope, deadlines, priorities and so on.&#160; Instead, we place the responsibility of triage and prioritization where it belongs, with the Product Owner.

With this system in place, we have no need to keep what we call “bugs” around in a durable format.&#160; Once artifacts become durable, people hesitate to delete them, and now they need to become managed.&#160; At one point, I kept bugs.&#160; But I found I never looked at them, as our practice of post-mortems on bugs as they are fixed was perfectly adequate.&#160; Instead, I (or nowadays, the originator) just toss them when they’re done, and it feels quite liberating.