---
wordpress_id: 3357
title: Now that I use the Delete Key…
date: 2009-06-06T13:21:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/06/06/now-that-i-use-the-delete-key.aspx
dsq_thread_id:
  - "274844635"
categories:
  - Best Practices
  - development
  - legacy code
---
<div class="wlWriterEditableSmartContent" style="padding-right: 0px;padding-left: 0px;float: right;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  <a href="//lostechies.com/chrismissal/files/2011/03/deleteKey8x6_6E6078EA.jpg" rel="thumbnail"><img src="//lostechies.com/chrismissal/files/2011/03/deleteKey_726D576D.png" width="335" border="0" height="229" /></a>
</div>

### Some Quick Background

I have the longest tenure on our team, and it&rsquo;s not that long; there was a bit of an exodus just prior to me joining. I was with a small contract team and none of us knew the code when we were thrown into the situation. Needless to say, since I&rsquo;ve been there the longest, I have the most experience with the code. <a href="http://en.wikipedia.org/wiki/Revision_control" target="_blank">Source control management</a> was handled by Visual Source Safe 6.0 and there was little documentation. Most of the <a title="You can stop putting Change History in source" href="http://subjunctive.wordpress.com/2008/12/05/you-can-stop-putting-change-history-in-source-its-2008/" target="_blank">documentation was in comments in the code</a>, usually followed by <a title="The Danger of Commenting Out Code" href="http://www.markhneedham.com/blog/2009/01/17/the-danger-of-commenting-out-code/" target="_blank">code that was commented out</a>. Without the confidence of tools to ensure that our production code was actually the code in VSS (no common build process or automation). We were afraid of our code.

### Moving On

Since then, we&rsquo;ve switched to Subversion, we have an <a href="http://en.wikipedia.org/wiki/Test_automation" target="_blank">automated test suite</a>, and <a href="http://martinfowler.com/articles/continuousIntegration.html" target="_blank">continuous integration</a>. **I no longer have a fear of deleting code that is commented out.** We do a fairly good job of not letting this even get into the source code repository, but you&rsquo;ll find it from time to time. Our code review process is getting better each day and test coverage continues to rise.

As the post reads, I use the delete key without fear now. Code that is committed has comments tied to the revision, it has been reviewed and has tests around it. There is no need for code to be commented out, it only confuses matters, I delete it when I see it, and it&rsquo;s a good feeling to be able to do so. <a title="A Sign of Team Maturity" href="/blogs/jimmy_bogard/archive/2009/04/09/a-sign-of-team-maturity.aspx" target="_blank">I don&rsquo;t think we&rsquo;re that mature of a team, since I still get excited about unit test numbers</a>, but this is a really good step to be in, compared to where we used to be.

### Even Better! (A Side Note)

Not only have I been more apt to delete code that is commented, I&rsquo;m also more likely to delete entire methods, classes and interfaces. This is largely due to the fact that our entire team has a copy of <a href="http://www.jetbrains.com/resharper/" target="_blank">ReSharper</a> by <a href="http://www.jetbrains.com/company/" target="_blank">JetBrains</a>. Tools only get you so far, but they can be helpful in reducing the time it takes to get something done. ReSharper is great for refactoring enforcing some best practices like removing un-used code.