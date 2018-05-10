---
wordpress_id: 157
title: Managing Bug Fixes Across Multiple Releases With Git Cherry-Pick
date: 2010-05-14T15:42:17+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/05/14/managing-bug-fixes-across-multiple-releases-with-git-cherry-pick.aspx
dsq_thread_id:
  - "264117729"
categories:
  - git
  - Source Control
  - Workflow
redirect_from: "/blogs/derickbailey/archive/2010/05/14/managing-bug-fixes-across-multiple-releases-with-git-cherry-pick.aspx/"
---
One of the problems I’ve faced in my software development career is managing bug fixes across multiple releases. If there are multiple versions of the software in development, test, production, out at client sites and deployed to internal servers, it can be difficult to keep up with all of the versions. If a bug is found in one version and it’s verified that the same bug exists in the other versions, then the patch for that bug has to be applied to all of the affected versions. In the past, I’ve manually handled the updating of the various versions in various ways: creating patch files, merging individual revisions across subversion branches, copy & paste code between multiple checkouts, etc. Yesterday, I found a new way of handling this and it seemed to be much easier than the things that I have done in the past: [git cherry-pick](http://www.kernel.org/pub/software/scm/git/docs/git-cherry-pick.html).

&#160;

### History Is Written By The Victorious

One of the most important things to understand about moving change sets around in git is whether or not you are going to rewrite history or preserve it. Git cherry-pick and git rebase are both history re-writing commands. They do not preserve the SHA identifiers for the commits that are being moved around. Instead, they rewrite those commits into the destination. If you need to preserve the history of your commits, then you shouldn’t use these commands; you would likely want to do a merge (or something else that preserves history… not sure what that would be off-hand, if anything).

There are scenarios where either is appropriate and scenarios where they are not appropriate and there’s a lot of [great information](http://book.git-scm.com/4_rebasing.html) about [when to use what](http://stackoverflow.com/questions/1241720/git-cherry-pick-vs-merge-workflow) already. You should take the time to read up on the subject.

&#160;

### Multiple Versions And Divergence

In the scenario where I am maintaining multiple versions of the software, I tend to have multiple working branches – one per version. For example, in my current project I have the master branch and a branch called aws0135. This branch represents a previous version of the software and is actively being maintained.

&#160; <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_10159169.png" width="357" height="355" />

You can see in this screen shot that my master branch and my aws0135 branch are divergent. Because we are maintaining aws0135 ‘as-is’ in terms of functionality, and we are adding new functionality into master, we will not converge these two branches at any point in time. They will always be divergent. However, we still need to apply bug fixes to both branches in many cases.

In this scenario I don’t necessarily care about preserving history because I am never going to do anything between the branches where that would cause problems. With that in mind, when I commit a change to one branch and I need to apply the same change to the other branch, I can use git cherry-pick to pluck out the change that I need and apply it to another branch.

&#160;

### Cherry Picking The Background Color Fix

This morning I was told there is a small issue in one of our forms: the background color is wrong. This isn’t a huge problem and it’s not causing any crashes, but it is an inconsistency in the application look & feel and it is a simple fix. I opened up the code in the aws0135 branch and made the fix. You can see the “fixed background color on message dialog” commit in the previous screen shot. This is the change that I want to bring into the master branch. Now, being a simple change where I don’t care about history, I could just checkout the master branch and make the same change. But what fun is that? Let’s go cherry-picking! The basic command is simple, though there are other options: 

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> git cherry-pick [SHA1]</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        Looking at my repository, I can see that the SHA for the background color is 2090b68ef8237db39056dff4e9e274f72c01054a. We don’t need all of that, though… the first 5 or 6 characters should be enough to uniquely identify the commit. Before we run the cherry-pick, though, you will want to make sure you are on the destination branch, so checkout the master branch first. Then run the cherry-pick:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> git cherry-pick 2090b6</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_6F8E51B6.png" width="669" height="268" />
            </p>
            
            <p>
              The cherry pick completed with a new commit id that starts with b563edd. Looking at gitk again, we can see the change in the master branch with the complete SHA id of the commit:
            </p>
            
            <p>
              <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_360B41BF.png" width="352" height="352" />
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              Moving On And Picking More Cherries
            </h3>
            
            <p>
              With the cherry-picking done between these two branches, I can go do the same thing against any other branches that I want. I can also pick other commits from other points in time and apply then to any branch I want. Be careful, though. Cherry-picking works great in this scenario because I know that the master and aws0135 branches will never converge. If you ever have a situation where a topic branch will eventually need to merge into another branch, you probably won’t want to use cherry-pick.
            </p>