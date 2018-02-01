---
id: 355
title: My favorite bug-tracking system
date: 2009-09-29T17:57:03+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/09/29/my-favorite-bug-tracking-system.aspx
dsq_thread_id:
  - "264716307"
categories:
  - Agile
---
I’m of the opinion that a process must demonstrate the need for software, before software is put in place to manage that process.&#160; Bug tracking is a process, but often we jump straight to a software solution for managing/tracking bugs before considering lower-tech, lower-risk and lower-overhead approaches.&#160; In our bug-tracking process, we employ a few main principles:

  * Bugs are a normal part of the development process
  * Most bugs are rework, therefore waste, and we should strive to eliminate this waste
  * Bugs are fixed as they are found ([stop-the-line](http://www.informit.com/articles/article.aspx?p=664147&seqNum=5)), and do not live for more than 1 business day

Given that bugs do not live for more than one business day, it is not necessary for us to maintain an inventory of bugs.&#160; Instead, we want a system than can accurately report a bug, and make it easy for it to be verified.

With these constraints in mind, my favorite bug tracking system is a [5&#215;8” orange sticky note](http://www.officemax.com/office-supplies/post-it-notes-flags/post-it-super-sticky-notes/product-ARS23443):

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="23443p_01[1]" src="http://lostechies.com/jimmybogard/files/2011/03/23443p_011_thumb_1FD9E30E.jpg" width="401" height="357" />](http://lostechies.com/jimmybogard/files/2011/03/23443p_011_1C3BC831.jpg) 

On this giant sticky note, the person that finds the bug writes:

  * Their initials
  * The name of the story
  * A short description

If there is a screenshot, this will be stapled to the back.&#160; When the developer is done with the bug, they write:

  * Their initials
  * The revision # of the commit that fixed the bug

The revision number is used to make sure that the currently deployed version is up-to-date enough to check the fix.&#160; So how does this bug tracking system work?&#160; Here is our process:

  * Person finds bug.&#160; Person could be anyone, developer, BA, product owner.
  * Finder creates orange card for bug, following the specified template (every piece of information goes in a certain spot on the giant post-it)
  * If the bug is a blow-up, or blocks the delivery of a story, it is placed on the desk of the tech lead (me)
  * If the bug is not specifically called out in acceptance criteria, it is placed on the desk of the BA lead.
  * These bugs go through triage, because sometimes things “work as designed” but not “work as expected”.&#160; Those in the latter category need to go through the normal story process.

  * The tech lead assigns the bug to a developer (or themselves), by placing the bug on the assigned developer’s desk
  * When the fix is done, the developer writes their initials and the revision number, and gives the orange card back to the originator, with a smile
  * The originator of the bug verifies the fix, and places the orange card in the trash with a “thumbs up” to let the developer know the bug is verified fixed.

This is about as lightweight as we can get it, without chaos.&#160; This process has evolved over time, but we’ve always fit our tools (post-its) to our process, instead of fitting our process to a tool.&#160; We’re all in the same room, so there is absolutely zero need to track bugs electronically.&#160; Tracking them electronically would create waste, as we would now have inventory to manage in some other system.&#160; It really can’t get much easier than a bright piece of paper on my desk.

### Fit the tool to the process

This process evolved given the attributes of the constraints of our system.&#160; We all sit in the same room.&#160; We strive for face-to-face, verbal communication over all other forms.&#160; We don’t want to add overhead by tracking information that no one cares about.&#160; When someone suggests to use a software bug tracker, it needs to come from a need to have that information in that format, not because geeks like software.

But what if we had different constraints?&#160; What if we weren’t all in the same room?&#160; Fine, software it is!&#160; Until then, I’ll choose the absolute lowest overhead solution.

But how does it scale?&#160; Well, if you keep an inventory of bugs for more than a day, not too well.&#160; If bugs are fixed when they happen, it’s just not possible to have more than a dozen bugs out at a time.&#160; Scaling needs a vector, you have to understand in which direction it can scale.&#160; It scales with the size of the team, but not with geography or volume.&#160; That’s fine, we keep those two small and constant.&#160; Those choices were intentional, as separated teams and higher volume through poor quality or turnaround decreases delivery throughput.