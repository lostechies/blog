---
wordpress_id: 129
title: 'Git: How To Revert A Branch Merge'
date: 2010-04-01T19:02:28+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/04/01/git-how-to-revert-a-branch-merge.aspx
dsq_thread_id:
  - "262068573"
categories:
  - Branching Strategies
  - git
  - Source Control
redirect_from: "/blogs/derickbailey/archive/2010/04/01/git-how-to-revert-a-branch-merge.aspx/"
---
This was a stumper for me a while back. Jason Meridth posted on [reseting / reverting git commits](https://lostechies.com/blogs/jason_meridth/archive/2010/03/23/git-reset-checkout-amp-quot-bare-double-dash-quot-and-revert.aspx) and I had a question in the comments. My specific situation was about having a branch merged at the wrong time and how to undo that merge. Here’s an example of the situation, shown with gitk:

 <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_6030F4F4.png" width="326" height="135" />

In this scenario, the “test” branch was not supposed to be merged yet… i missed some changed, or i needed to do something else with the master branch, etc. Whatever the reason, I wanted to rollback to the point where test and master were not yet merged. As i stated in the comments on jason’s post, I ran around in circles trying to get ‘git revert’ to do what I wanted, with no luck. Lucky for me, Nick Quranto had [a blog post on reverting with git](http://www.gitready.com/intermediate/2009/03/16/rolling-back-changes-with-revert.html), pointed me toward [an in-depth read](http://www.kernel.org/pub/software/scm/git/docs/howto/revert-a-faulty-merge.txt) on the subject and was happy to answer my questions via email.

It turned out the answer was much more simple than what I was trying to do. Since I merged the test branch into the master branch, I can run this from the master branch:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> git reset --hard HEAD^</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        Here, you can see that this moves the HEAD of master back to the previous commit (<strong>Note:</strong> for more info on what HEAD^ means, see <a href="http://book.git-scm.com/4_git_treeishes.html">Git Treeishes</a> in the git docs):
      </p>
      
      <p>
        <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_46C8F1BA.png" width="613" height="187" />
      </p>
      
      <p>
        Apparently the “revert” command differs from the “reset” command in a very important way: revert will take the changes from whatever commit you specify and undo them, creating a new commit for the new version. In contrast to that, “reset” will move the pointer that represents your branch’s location to whatever point you specify. So, doing a reset on the test master branch allowed me to move the current location of HEAD back to the previous commit on that branch (<strong>Another Note:</strong> I know I’m messing up the detail on how reset vs. revert works… this is just a basic high level experience report, rather than an in-depth discussion on what really goes on).
      </p>
      
      <p>
        The result looks like this in gitk:
      </p>
      
      <p>
        <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_58395292.png" width="158" height="105" />
      </p>
      
      <p>
        This is exactly what I wanted: the master and test branch are no longer merged and I can continue working on either / both of them independently with the ability to merge them together at some later point in time.
      </p>