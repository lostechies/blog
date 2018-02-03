---
wordpress_id: 3965
title: Use gitk to understand git – merge and rebase
date: 2010-09-03T23:25:00+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2010/09/03/use-gitk-to-understand-git-merge-and-rebase.aspx
dsq_thread_id:
  - "262046146"
categories:
  - git
---
This is the second part of my [Use gitk to understand git](/blogs/joshuaflanagan/archive/2010/09/03/use-gitk-to-understand-git.aspx) post.

In my initial overview, I demonstrated creating a branch, making a couple commits to that branch, and then merging them back into master. In that scenario, there were no changes in my local master (and since it was contrived, I knew there were no changes in the remote origin/master), so the merge was really just a fast-forward. In the real world, my workflow would be slightly different, as I would have to account for other people making changes to our shared repository (my origin remote).

To demonstrate, I&rsquo;ll rewind time and pretend we&rsquo;re back at the moment where we switched to master as we prepared to merge in the changes from the issue123 branch. The gitk visualization of the repository looked like:

 <img height="373" width="744" src="//lostechies.com/joshuaflanagan/files/2011/03/gitkgitkdemo_20100903_163536_57A177D6.png" alt="Just before merging issue123 into master" border="0" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" />

Before I merge my changes into master, I want to make sure my master branch is in synch with the central repository on github (which I refer to using the remote &ldquo;origin&rdquo;). We can see in the screenshot that my master branch refers to the same commit as origin/master, but that&rsquo;s because I haven&rsquo;t communicated with origin in a long time. All of my previous operations were done locally. In order to get the latest state from the remote repository, I need to perform a fetch.

<pre>d:codegitk-demo&gt;git fetch origin
remote: Counting objects: 7, done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 6 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (6/6), done.
From github.com:joshuaflanagan/gitk-demo
   bf37c64..ec8d10f  master     -&gt; origin/master</pre>

 <img height="373" width="744" src="//lostechies.com/joshuaflanagan/files/2011/03/gitkgitkdemo_20100903_164139_7D97282C.png" alt="new changes from remote" border="0" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" />

I&rsquo;ve downloaded new commits to my local repository and moved the remote branch pointer, but I haven&rsquo;t changed anything in my local branches. If I were to look in my working folder, I would see that none of my files have changed. To get the latest changes to the master branch from Tony, I need to merge them into my master branch.

<pre>d:codegitk-demo&gt;git merge origin/master
Updating bf37c64..ec8d10f
Fast-forward
 dairy.txt |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)
 create mode 100644 dairy.txt</pre>

 <img height="373" width="744" src="//lostechies.com/joshuaflanagan/files/2011/03/gitkgitkdemo_20100903_172124_6E804952.png" alt="After merging in remote" border="0" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" />x 

&nbsp;

Once again, since there was a straight line from my local master to origin/master, git was able to perform a fast-forward merge. The master branch has moved to point to Tony&rsquo;s latest commit. My working directory has been updated accordingly to have the changes he made.

Note that none of the changes I made for issue123 have been included in master yet. We need to merge the issue123 branch back into master, and ultimately push them to the shared repository on github. However, there is no straight line between issue123 and master &ndash; neither is a direct descendent of the other &ndash; which means we cannot do a fast-forward merge. We have to do either a &ldquo;real&rdquo; merge, or rebase.

### Merge

To perform a &ldquo;real&rdquo; merge, we just use the merge command as we have all along. Doing a fast-forward vs. a real merge is handled by git &ndash; not something you specify.

<pre>d:codegitk-demo&gt;git merge issue123
Merge made by recursive.
 fruits.txt     |    1 +
 vegetables.txt |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)</pre>

 <img height="373" width="744" src="//lostechies.com/joshuaflanagan/files/2011/03/gitkgitkdemo_20100903_173947_6688A6F0.png" alt="After merge" border="0" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" />

Previously with our fast-forward merges, no new commits were created &ndash; git just moved branch pointers. In this case, since there is a new snapshot of the repository that never existed before (includes Tony&rsquo;s new changes, as well as my changes from issue123), a new commit is required. The commit is automatically created with an auto-generated commit message indicating it was a merge. The merge commit has multiple ancestors (indicated by the red line going to the &ldquo;Forgot the yogurt&rdquo; commit&rdquo; and the blue line going to the &ldquo;Added another fruit&rdquo; commit). We can safely delete the issue123 branch now, but unlike in the fast-forward example, when we push our changes to the central server, there will be evidence that the issue123 message existed (in the merge commit message, and the repository history shows the branched paths).

<pre>d:codegitk-demo&gt;git branch -d issue123
Deleted branch issue123 (was cac3c72).

d:codegitk-demo&gt;git push origin master
Counting objects: 12, done.
Delta compression using up to 2 threads.
Compressing objects: 100% (6/6), done.
Writing objects: 100% (8/8), 914 bytes, done.
Total 8 (delta 0), reused 0 (delta 0)
To git@github.com:joshuaflanagan/gitk-demo.git
   ec8d10f..5835415  master &ndash;&gt; master</pre>

 <img height="373" width="744" src="//lostechies.com/joshuaflanagan/files/2011/03/gitkgitkdemo_20100903_175152_257A278C.png" alt="After pushing merge to github" border="0" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" />

<img height="399" width="644" src="//lostechies.com/joshuaflanagan/files/2011/03/CommitHistoryforjoshuaflanagansgitkdemoGitHubGoogleChrome_20100903_175300_795D2A9A.png" alt="Commit History after merge" border="0" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" />

### Rebase

There are a few reasons not to like the merge approach:

  * Branching paths in the history can be unnecessarily complicated
  * The extra merge commit. 
  * Your branch is now no longer a private, local concern. Everyone now knows that you worked in an issue123 branch. Why should they care? 

Note: There are some scenarios where you want to preserve the fact that work was done in a separate branch. In those cases, the above &#8220;downsides&#8221; are not really downsides, but the desired behavior. However, in many cases, the merge is only necessary because of the timing of parallel work, and preserving that timeline is not important.

You can use git rebase to avoid these issues. If you have commits that have never been shared with anyone else, you can have git re-write them with a different starting point. If we go back in time to the point right after we merged in Tony&rsquo;s changes, but before merging in issue123:

 <img height="373" width="744" src="//lostechies.com/joshuaflanagan/files/2011/03/gitkgitkdemo_20100903_180406_69DA18CB.png" alt="Before rebase" border="0" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" />

Currently, the issue123 commits branch off from the &ldquo;third commit&rdquo;. The rest of the world doesn&rsquo;t need to know that is where we started our work. We can re-write history so that it appears like we started our work from Tony&rsquo;s latest changes. We want the issue123 commits to branch off from master, the &ldquo;Forgot the yogurt&rdquo; commit.

<pre>d:codegitk-demo&gt;git checkout issue123
Switched to branch 'issue123'

d:codegitk-demo&gt;git rebase master
First, rewinding head to replay your work on top of it...
Applying: My first commit
Applying: Added another fruit</pre>

 <img height="373" width="744" src="//lostechies.com/joshuaflanagan/files/2011/03/gitkgitkdemo_20100903_181059_5DD82897.png" alt="After rebase" border="0" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" />

After a rebase, the &ldquo;My first commit&rdquo; now directly follows the &ldquo;Forgot the yogurt&rdquo;&#8221; commit, making the issue123 branch a direct descendent of the master branch. This means we can now do a fast-forward merge to bring issue123&rsquo;s changes into master.

<pre>d:codegitk-demo&gt;git checkout master
Switched to branch 'master'

d:codegitk-demo&gt;git merge issue123
Updating ec8d10f..b5a86d6
Fast-forward
 fruits.txt     |    1 +
 vegetables.txt |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)</pre>

 <img height="373" width="744" src="//lostechies.com/joshuaflanagan/files/2011/03/gitkgitkdemo_20100903_181548_07D826C0.png" alt="No merge commit required after rebase" border="0" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" />

When we delete the issue123 branch and push these changes to the remote repository on github, there is no longer any evidence that the issue123 branch ever existed. Anyone that pulls down the repository will see a completely linear history, making it easier to understand.

<pre>d:codegitk-demo&gt;git branch -d issue123
Deleted branch issue123 (was b5a86d6).

d:codegitk-demo&gt;git push origin master
Counting objects: 9, done.
Delta compression using up to 2 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (6/6), 626 bytes, done.
Total 6 (delta 1), reused 0 (delta 0)
To git@github.com:joshuaflanagan/gitk-demo.git
   ec8d10f..b5a86d6  master &ndash;&gt; master</pre>

[<img height="373" width="744" src="//lostechies.com/joshuaflanagan/files/2011/03/gitkgitkdemo_20100903_182029_thumb_7A256AB7.png" alt="Pushed to remote" border="0" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" />](//lostechies.com/joshuaflanagan/files/2011/03/gitkgitkdemo_20100903_182029_74B6FA13.png) x 

&nbsp;

<img height="336" width="644" src="//lostechies.com/joshuaflanagan/files/2011/03/CommitHistoryforjoshuaflanagansgitkdemoGitHubGoogleChrome_20100903_182214_5212BB98.png" alt="Commit History after rebase" border="0" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" />