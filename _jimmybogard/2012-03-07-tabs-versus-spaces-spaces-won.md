---
wordpress_id: 595
title: 'Tabs versus spaces: Spaces won'
date: 2012-03-07T15:03:19+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/03/07/tabs-versus-spaces-spaces-won/
dsq_thread_id:
  - "602092203"
categories:
  - Rant
---
Why? Because since at least Visual Studio 2005, the default for tabs/spaces has been:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2012/03/image_thumb.png" width="761" height="444" />](http://lostechies.com/content/jimmybogard/uploads/2012/03/image.png)

Insert spaces, not “Keep tabs”. If tabs were supposed to win, they would have won the default settings battle. If the default settings in Visual Studio aren’t “do tabs everywhere”, then you’re fighting some serious momentum against you.

**I used to have “Keep tabs” on as my default, but this proved to be quite, quite annoying when working with teams or OSS development.** If I get a pull request with spaces, I might re-format the document to have spaces. But then it becomes much harder to understand _what_ has changed, since I have to fight with how well the diff tools deal with whitespace changes.

Even worse is the developer that re-formats documents they only look at, but don’t make any semantical changes to. I’ll see a commit with 5 changed files, but only one has actually changed.

I hit this with a pull request in AutoMapper, where the person submitting the pull request decided to replace all spaces with tabs, making it pretty hard to understand what changed without special whitespace switches.

**Do you like tabs in Visual Studio? I do too! But I gave up the tabs versus spaces argument, and so should you.**

**Spaces won.**