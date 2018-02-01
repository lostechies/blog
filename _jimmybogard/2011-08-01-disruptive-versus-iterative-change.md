---
id: 507
title: Disruptive versus iterative change
date: 2011-08-01T13:22:35+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2011/08/01/disruptive-versus-iterative-change/
dsq_thread_id:
  - "374149720"
categories:
  - Agile
---
Scrum is a rather interesting phenomena. As a process, the feedback system it incorporates encourages incremental and iterative improvements not only in the software, but the process itself. Once scrum is in place, things can go rather smoothly, although I do find pull-based processes to be [smoother and less disjointed](http://lostechies.com/jimmybogard/2011/05/13/from-sprints-to-pull-based-flow/).

But getting scrum in place is an extremely disruptive change. And usually, at least one business group has to be dragged kicking and screaming into the process. Or, scrum is instead installed in one tiny part of the entire production pipeline (development), with the entire process still being one very long (6-12 month) iteration.

I find it more than a little ironic that although the process itself is incremental and iterative, installing scrum in the first place is a big, disruptive change.

In our projects, we’re very often these days confronted with replacing existing solutions with new ones. In these situations, we keep a very close eye on risk, and our initial goal is to **get something into actual production use as quickly as possible**. Replacing the entire existing system at once is a highly risky affair, and one we try to avoid like the plague.

### An iterative improvement approach

An alternate approach would be to instead just take whatever process you have right now, however ill or well-defined, and just start improving that.

One team I talked to said they did 2 week iterations. But in terms of “done”, the end of a sprint didn’t mean a production release. As we mapped more and more steps out, the entire process was more like:

  * Requirements definition (4-6 weeks)
  * Analysis (4-6 weeks)
  * Development (8 weeks)
  * Testing (2 weeks)
  * UAT (2 weeks)
  * Release (~ 1 day)

The development phase was the actual scrum part, so basically 4 two-week sprints occurred there. Handoffs from development to testing to UAT were instantaneous. Release only occurs when the entire UAT phase is done, however. In the initial scrum implementation, it might look like our iteration length is 2 weeks. 

If we add up the numbers, actual iteration length from definition to production ranges from 20 to 24 weeks! A far cry from the 2 week sprint that we first assumed we were working under.

One issue we saw were large handoffs, that all of requirements definition had to be done before analysis started. In order to speed the process up, the first suggestion was to simply **reduce the size of the work going through the process**. The entire 20-24 week process worked off a single (large) document. Reducing the size of that to something manageable would reduce the amount of time development needed to wait before starting work.

This is just an example, but in our case we started with an existing process instead of throwing the whole machine into a lurch with a forced process. Risk-wise, **it’s much easier just to map out what’s actually going on and improve that**, rather than development trying to impose a process on other business groups.