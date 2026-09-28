---
wordpress_id: 13
title: 'VS Testing &#8211; Annoyance Of The Day'
date: 2007-05-25T16:27:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/05/25/vs-testing-annoyance-of-the-day.aspx
categories:
  - TDD
  - Tools
redirect_from: "/blogs/joeydotnet/archive/2007/05/25/vs-testing-annoyance-of-the-day.aspx/"
---
This is mostly a rant, so feel free to skip this one.&nbsp; Really.

(Most folks are probably already enjoying the holiday weekend anyways&#8230;)

<rant>

I&#8217;ve recently started a new project on which I have to use the [dreaded VS Testing framework](http://joeydotnet.com/blog/archive/2006/12/25/15.aspx) again, or as I call it, the &#8220;Microsoft&nbsp;Visual Studio&nbsp;Enterprise Unit Testing Framework, um, Block&#8221;.&nbsp; Gotta have that word &#8220;enterprise&#8221; and &#8220;block&#8221; in there somewhere, right?&nbsp; 😛

I know it&#8217;s a minor thing, but why doesn&#8217;t the VS Testing [Ignore] attribute allow you to pass in a message as to exactly \*why\* you are ignoring this test.&nbsp; This just once again promotes bad practices by allowing folks to slap [Ignore] attributes on any tests they don&#8217;t feel like working on right now **without giving them the option of documenting why**!

Sure, you can do an&nbsp;Assert.Inconclusive(message) inside of the test to achieve the same thing, but then that would require you mess around in the test method body when you end up wanting to re-enable the test.&nbsp; Not nearly as clear as just removing an [Ignore] attribute.

This, along with the [ExpectedException debacle](http://weblogs.asp.net/rosherove/archive/2006/01/25/436414.aspx)&nbsp;that has also bitten me in the past, are just a couple things that make simple frameworks like NUnit, or even better, MBUnit much better choices.&nbsp; IMHO.

Guess that&#8217;s what happens when you re-invent only 95% of NUnit.&nbsp; :O

</rant>

Ok, \*now\* I can start the weekend.&nbsp; 🙂&nbsp; And, if you made it this far, you have a good weekend as well!&nbsp; 

Joey.&nbsp; Out.