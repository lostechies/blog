---
wordpress_id: 537
title: Git workflows with git-tfs
date: 2011-09-20T13:31:50+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/09/20/git-workflows-with-git-tfs/
dsq_thread_id:
  - "420269165"
categories:
  - git
  - TFS
---
I’ve been working with [git-tfs](https://github.com/spraints/git-tfs) on a project for about a couple of months. Git-tfs is a source control bridge that allows you to work with [Git](http://git-scm.com/) locally, reducing the number of operations to communicate with the TFS source control server to exactly three operations:

  * Clone 
      * Push 
          * Pull</ul> 
        Pretty much the same three operations that require connections with normal DVCS work. Having worked with DVCS such as Git and Mercurial for a few years, it’s nice to keep the DVCS paradigm when interacting with a centralized VCS like TFS.
        
        Why use the git-tfs bridge? A few good reasons:
        
          1. You’re not communicating with TFS source control for nearly every operation 
              * Work perpetually offline, forever and ever 
                  * No workspaces 
                      * No local file locking (all that “files are readonly” stuff) 
                          * Merges use Git’s algorithm and Git’s merge tools 
                              * You still see all of the history in TFS</ol> 
                            You don’t, however, get remote branches very easily. You can do multiple remotes, but it’s not something I’ve tried out (yet). That being said, I’ve found a couple of workflows adapted to my normal Git workflow work really well when interacting with git-tfs.
                            
                            Assuming you’ve already cloned, I basically follow two rules:
                            
                              1. The master branch represents commits in TFS 
                                  * All commits locally are done in local topic branches</ol> 
                                Let’s dig in to how these rules apply in practice.
                                
                                ### Git-tfs workflow
                                
                                Since master represents TFS commits (and should represent deployable code), the first thing we do locally on a clean repository is:
                                
                                <pre>git checkout -b TopicBranch</pre>
                                
                                We first create a local branch representing the topic of what our work is going to be. From there, work proceeds as normal:
                                
                                <pre>/* work work work */
git add -A
git commit -m "My first fun commit"
/* work work work */
git add -A
git commit -m "Still going"
/* work work work */
git add -A
git commit -m "OK now I'm done"</pre>
                                
                                At this point, we&#8217;re done with what we&#8217;re done locally, and it&#8217;s time to integrate our changes. First, we want to make sure we have all upstream commits pulled down before we merge:
                                
                                <pre>git checkout master
<strong>git tfs pull</strong></pre>
                                
                                The bolded commands are the git-tfs commands. Our master branch is updated with the latest upstream commits from TFS. If any commits came down the pipe, we’ll want to make sure our branch is updated to be based on the latest upstream commits. To do that, we’ll perform a straightforward rebase:
                                
                                <pre>git checkout TopicBranch
git rebase master</pre>
                                
                                Our local topic branch is now based against the latest upstream commit. We can now build locally and push our changes up to Team System. I like to use the standard TFS check-in tool to do so, so I use the git-tfs command:
                                
                                <pre><strong>git tfs checkintool --build-default-comment</strong></pre>
                                
                                That last command line flag instructs git-tfs to build a comment based on the comments. The normal TFS check-in dialog pops up, and you can associate work items, add comments and so on. Once you check in, git-tfs pushes the commit up.
                                
                                If the commit succeeds, git-tfs will pull the commit back down to master, performing a merge commit between your local topic branch and master. Once that’s done, you only need to clean up the local git branches and you’re done:
                                
                                <pre>git checkout master
git branch -d TopicBranch</pre>
                                
                                You’re now back to where you started, and can build more software starting the workflow from the beginning.
                                
                                ### Motivations
                                
                                Why always work in a topic branch and not off master? I’m a big believer in the piece of Continuous Delivery that states that commits in master should always always always not just be _potentially_ deployable commits but _actually_ deployed commits. A clean master branch ensures this is the case.
                                
                                Working off of master also introduces weird parallel lines of work that make it difficult to understand what the heck is going on:
                                
                                [<img style="background-image: none; border-right-width: 0px; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/09/image_thumb6.png" width="40" height="244" />](http://lostechies.com/jimmybogard/files/2011/09/image6.png)
                                
                                Not a fan.
                                
                                ### Working with gated check-ins
                                
                                Later versions of TFS have a feature that checkins can be gated so that a build must succeed before the check-in actually gets committed. This functions by a check-in only pushing up a shelveset, and the shelveset then gets committed automatically once the Team Build build succeeds.
                                
                                If you’re working with gated check-ins, your workflow is slightly different since TFS is now the entity performing the check-in, not you locally. Locally, when you run the checkintool command, you’ll get a “checkin cancelled” message, because your check-in was in essence, delayed.
                                
                                Our check-in workflow now becomes:
                                
                                <pre>git tfs checkintool --build-default-comment
/* Click the "Build Changes" button that pops up */
/* Wait for build to succeed, and the "build success" message to pop up*/
git checkout master
<strong>git tfs pull</strong>
git branch -D TopicBranch</pre>
                                
                                The main difference is that git-tfs can’t perform the merge commit of our topic branch locally since git-tfs wasn’t the tool performing the actual commit. We have a couple of choices at the end:
                                
                                  * Make a merge commit manually (weird)
                                  * Let our local topic branch stick around (OK, but also weird to have dangling branches)
                                  * Delete the un-merged topic branch with the –D switch
                                
                                I prefer the last option, simply because I don’t much care about the local commits, since they don’t show up anywhere upstream. If I had Git remotely, I would do differently.
                                
                                NOTE: you will need the latest drop of git-tfs to allow this to work. [A recent bug was fixed](https://github.com/spraints/git-tfs/issues/46) that allowed the other TFS build dialogs to pop up correctly.
                                
                                ### Summary
                                
                                If you’re using TFS and know Git, you should stop using TFS directly and use the git-tfs bridge. It works, it’s reliable, and it takes away nearly all of the inefficiencies of working with a centralized VCS like TFS. With this workflow, you’ll keep a sane view of what upstream TFS looks like, and easily manage and isolate local work.