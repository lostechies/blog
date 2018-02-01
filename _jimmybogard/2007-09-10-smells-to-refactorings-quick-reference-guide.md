---
id: 61
title: Smells to refactorings quick reference guide
date: 2007-09-10T17:51:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/09/10/smells-to-refactorings-quick-reference-guide.aspx
dsq_thread_id:
  - "267850059"
categories:
  - Refactoring
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/09/smells-to-refactorings-quick-reference.html)._

Two&nbsp;books I like to have close by are Martin Fowler&#8217;s &#8220;[Refactoring: Improving the Design of Existing Code](http://www.amazon.com/Refactoring-Improving-Design-Existing-Code/dp/0201485672)&#8221; and Joshua Kerievsky&#8217;s &#8220;[Refactoring to Patterns](http://www.amazon.com/Refactoring-Patterns-Addison-Wesley-Signature-Kerievsky/dp/0321213351)&#8220;.&nbsp; It&#8217;s not that productive to memorize all of the refactorings, and especially the patterns.&nbsp; Applying patterns and refactorings before they are needed can make your code unnecessarily complex and less&nbsp;maintainable in the long run.&nbsp; No one likes running into an [Abstract Factory](http://www.dofactory.com/Patterns/PatternAbstract.aspx)&nbsp;with only one concrete factory implementation.&nbsp;

I need a context for which to apply patterns and refactorings, and code smells provide the best indication for those contexts.&nbsp; All I really need to do is get good at recognizing smells, and then it becomes a cinch to look up possible refactorings.&nbsp;&nbsp;I made&nbsp;a nice quick reference guide&nbsp;help me match smells&nbsp;to refactorings:

[Smells to Refactorings Quick Reference Guide](http://s3.amazonaws.com/grabbagoftimg/Smells%20to%20Refactorings.pdf)

It&#8217;s adapted from [this guide](http://industriallogic.com/papers/smellstorefactorings.pdf), but I had a tough time reading that one when it was pasted on the wall next to me.&nbsp; My version spans 3 pages in a larger font&nbsp;and&nbsp;a landscape layout, and I&#8217;ve had no issues reading it on the wall next to me.

The list of smells is much smaller and easier to remember than the patterns and the refactorings.&nbsp; By recognizing smells instead of using patterns when they&#8217;re not necessary, I can apply an evolutionary, [JIT (just-in-time) approach](http://www.agilemodeling.com/essays/amdd.htm) to my design and architecture.&nbsp; Instead of planning patterns beforehand, I can have confidence that I can recognize where they&#8217;re needed, and apply them as necessary, exactly when they&#8217;re necessary, at the [last responsible moment](http://codebetter.com/blogs/jeremy.miller/archive/2006/01/18/136648.aspx).