---
wordpress_id: 260
title: 'Why Source Control Matters and Hopefully it&#8217;s Git'
date: 2012-07-20T08:08:08+00:00
author: Chris Missal
layout: post
wordpress_guid: http://lostechies.com/chrismissal/?p=260
dsq_thread_id:
  - "773170389"
categories:
  - Best Practices
  - Continuous Improvement
  - git
  - Project Management
  - Rant
tags:
  - clean code
  - dvcs
  - Git
---
I had an interesting and fun discussion last week with my fellow [Headspring](http://www.headspring.com) employees. I&#8217;m a big advocate of using [git](http://lostechies.com/chrismissal/category/git/) and I&#8217;m also the type of person that likes clean code and clean commits. Combining these two things and **my own personal opinions**, this means I:

  * Don&#8217;t commit commented code (actual code commented out, not notes or todos in comments)
  * Don&#8217;t commit nonsense like whitespace at the end of lines or extra line breaks for no reason. My IDEs and text editors show whitespace! This is actually important when looking for logical changes to a file over time. I don&#8217;t want to sift through garbage.
  * Commit only working code (can be run/compiled and tests passing).
  * There are some version control systems that let you commit/push code without commit messages. That&#8217;s just dumb to me. (Yes, I know somebody can just put a single character as a message &#8220;to get by&#8221;, but it becomes pretty clear who cares versus who doesn&#8217;t at that point)

I have strong feelings about this, but I haven&#8217;t yet fully figured out why I feel that way about these things. My knee-jerk thought is that I want to be proud of my code base and not ashamed. To me, this is the difference between a house from hoarders and a museum, no to be completely overdramatic. I realize that code that isn&#8217;t in production is worthless and crappy code bringing in money is better, but come on, how long does it take to add a message? You can also [clean your code in a single key stroke](http://www.jetbrains.com/resharper/features/code_formatting.html) with good add-ons.

<div id='gallery-1' class='gallery galleryid-260 gallery-columns-2 gallery-size-thumbnail'>
  <figure class='gallery-item'> 
  
  <div class='gallery-icon landscape'>
    <a href='/content/chrismissal/uploads/2012/07/museum.jpg'><img width="150" height="150" src="/content/chrismissal/uploads/2012/07/museum-150x150.jpg" class="attachment-thumbnail size-thumbnail" alt="" srcset="/content/chrismissal/uploads/2012/07/museum-150x150.jpg 150w, /content/chrismissal/uploads/2012/07/museum-100x100.jpg 100w" sizes="100vw" /></a>
  </div></figure><figure class='gallery-item'> 
  
  <div class='gallery-icon landscape'>
    <a href='/content/chrismissal/uploads/2012/07/hoarders.jpg'><img width="150" height="150" src="/content/chrismissal/uploads/2012/07/hoarders-150x150.jpg" class="attachment-thumbnail size-thumbnail" alt="" srcset="/content/chrismissal/uploads/2012/07/hoarders-150x150.jpg 150w, /content/chrismissal/uploads/2012/07/hoarders-100x100.jpg 100w" sizes="100vw" /></a>
  </div></figure>
</div>

In my years of working with teams that use source control, I feel there is a direct correlation between the care that is given to the code base and the quality of the code that is produced. If you don&#8217;t have standards (even very loose ones) about what is saved in your [VCS](http://en.wikipedia.org/wiki/Revision_control), you likely have a crumby codebase and a product of equal quality. If you&#8217;re careful about what gets pushed/committed, you likely have a solid product, great team, and well thought out code.

Just sayin&#8230;