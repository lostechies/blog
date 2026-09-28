---
wordpress_id: 3869
title: Diffing Files to Avoid Easy Goofs
date: 2011-05-17T22:51:41+00:00
author: Sharon Cichelli
layout: post
wordpress_guid: http://lostechies.com/sharoncichelli/?p=36
dsq_thread_id:
  - "306498347"
categories:
  - Uncategorized
---
A good habit learned at my last job has saved me a lot of embarrassment and bugs (same thing): Before committing a set of changes to source control, I look at the diff of each file. _Look_ at the changes, read &#8217;em over, look for misspellings and placeholder notes-to-self and files I hadn&#8217;t intended to change; then make fixes and revert as needed. It&#8217;s like proofreading. Polishing the fingerprints off a product before sending it into the world. [Checking your knot](http://www.supertopo.com/climbers-forum/1359870/Check-Your-Knot-More-Accidents).

Shortcuts for diffing files:

  * In TFS, Shift&ndash;double-click a file name in the Pending Changes window. (You can [configure TFS&#8217;s diff tool](http://blogs.msdn.com/b/jmanning/archive/2006/02/20/diff-merge-configuration-in-team-foundation-common-command-and-argument-values.aspx).)
  * In TortoiseSvn, double-click a file name in the &#8220;Changes made&#8221; panel of the Commit window.
  * In git and Hg&#8230; help me out here. I&#8217;m too used to a visual side-by-side. Recommend a nice explanation of getting the most from those in-line diff reports?

If that seems daunting because there are so many files to review, check in more often. I appreciate the mentors who have drilled into me: small, focused, atomic changes. It keeps me focused on what I&#8217;m doing. Make this one change, and every other stray thought that leaps to mind (&#8220;Ooh, I need to do _this_, too!&#8221;) gets tossed in a running text file, to be addressed later. How small is small enough? When it no longer feels onerous to diff all your files before checking in. 😉 In addition to keeping my thought process on-track, this habit makes it easy to review, fix, unwind, and selectively pick certain changes when I need to.

Small check-ins are like the [extract-method refactoring](http://www.refactoring.com/catalog/extractMethod.html). In code, when you have a collection of statements that _do_ something, you&#8217;d extract them into a method so that you can _name_ the something. Similarly, a focused check-in can have a descriptive and useful check-in comment.

The three habits fit together: small check-ins targeting a focused goal, with a useful commit message, reviewing the changes before checking them in. Reduces the number of times I have to think &#8220;Who the heck did&mdash;?! Oh, me. Heh.&#8221;