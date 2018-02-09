---
wordpress_id: 3956
title: How to resolve a binary file conflict with Git
date: 2010-01-29T03:47:35+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2010/01/28/how-to-resolve-a-binary-file-conflict-with-git.aspx
dsq_thread_id:
  - "262113201"
categories:
  - git
redirect_from: "/blogs/joshuaflanagan/archive/2010/01/28/how-to-resolve-a-binary-file-conflict-with-git.aspx/"
---
When performing a merge in <a href="http://git-scm.com/" target="_blank">git</a>, you might see the message:

<pre>warning: Cannot merge binary files: HEAD:somefile.dll vs. otherbranch:somefile.dll

Auto-merging somefile.dll
CONFLICT (content): Merge conflict in somefile.dll
Automatic merge failed; fix conflicts and then commit the result.</pre>

In this scenario, somefile.dll is a binary file that has been modified in both the current branch, and the branch you are attempting to merge in to the current branch. Since the file cannot be textually merged, you need to make a decision: do you keep the version of the file in your current branch, or the version in the other branch.

In TortoiseSVN, I was used to being able to right-click on the file in question and choose “Resolve using mine”, or “Resolve using theirs”. So what is the git equivalent?

### Resolve using mine

The file in your working copy is still the copy from your current branch – in other words, it was not modified by the merge attempt. To resolve the conflict and keep this file:

<pre>git add somefile.dll 
git commit –m “My commit message for the merge”</pre>

### Resolve using theirs

If you prefer to resolve the conflict using their copy, you need to get the version of the file from the branch you were trying to merge in:

<pre>git checkout otherbranch somefile.dll</pre>

Now that you have the correct version of the file in your working copy, you can mark it as resolved (by adding it), and commit:

<pre>git add somefile.dll
git commit –m “My commit message for the merge”</pre>

Note that in place of _otherbranch_, you can use any name (<a href="http://book.git-scm.com/4_git_treeishes.html" target="_blank">treeish</a>) that refers to a branch: a local branch name (otherbranch), a remote branch name (origin/master), a specific commit SHA (980e3cc), etc. For example, if you were merging in from your remote when you received the conflict, and you wanted to resolve using the remote version, you would retrieve that copy of the file using:

<pre>git checkout origin/master somefile.dll</pre></p> 

<pre></pre></p> 

<pre></pre>

You then add the file and commit as described above.

**UPDATE**: There is a shortcut for getting the copy from the other branch (and it even uses the terminology I was expecting):

<pre>git checkout --theirs -- somefile.dll</pre>