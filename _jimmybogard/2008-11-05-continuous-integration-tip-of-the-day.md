---
wordpress_id: 246
title: Continuous Integration Tip of the Day
date: 2008-11-05T02:46:29+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/11/04/continuous-integration-tip-of-the-day.aspx
dsq_thread_id:
  - "264715951"
categories:
  - Rant
redirect_from: "/blogs/jimmy_bogard/archive/2008/11/04/continuous-integration-tip-of-the-day.aspx/"
---
We wasted quite a bit of time not following this rule today:

**If the CI build fails, roll back the previous revision.**

The build failed, and from the exception we assumed it was an environmental issue.&#160; Well, a few commits later, and the build kept failing.&#160; We couldn’t tell if it was the original commit or later commits that made the build keep failing.&#160; We tried reverting individual revisions, but no go.

Eventually, the only thing that worked was reverting back to the last successful build.&#160; Thus wasting quite a bit of everyone’s time.&#160; Lots of excuses on why the build should be green when it wasn’t, but a green build is a green build.&#160; A red build is a red build.

This is one of those lessons it seems like we have to learn every few months.&#160; Hopefully, this bad taste will stick in our mouths for longer next time.