---
wordpress_id: 492
title: Symptoms of a centralized VCS
date: 2011-05-25T13:03:44+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/05/25/symptoms-of-a-centralized-vcs/
dsq_thread_id:
  - "313405326"
categories:
  - Tools
---
Reading the [TFS 2010 Branching Guide on CodePlex](http://tfsbranchingguideiii.codeplex.com/) (no, I’m not a glutton for punishment, just want to know what else is going on in the world), I found an interesting note on scratch or temporary branches that pretty much sums up a lot of the drawbacks of centralized VCS like TFS and SVN (emphasis mine):

> “Scratch” or temporary branches
> 
> Before creating a new branch for an individual to “play in”, prototype, or test changes in &#8211; it may be helpful to ask the following questions to see if there is a better alternative to creating a new branch. Using the options below may expose another area where the developer should be working, will prevent low quality, orphaned, or inappropriate code from getting into your source tree.
> 
>   1. Can you use a shelveset? Frequently developers just want a way to save or share changes. A shelveset accomplishes both of these tasks by saving the changes in the TFS database but not committing them to the branch. 
>       * Is there another work item you should be working on? Sometimes other work is not visible to the individual engineer. 
>           * Work in the “next version” branch mentioned above if the change is approved for next version release. 
>               * If the work is truly not related to the project and for developer training use TFS 2010 “basic edition” to create a stand along TFS instance right on the developer desktop. This is completely separate from the production TFS that the team may be using. Consider using this for projects the developer would consider “throw away” (i.e. training) code.</ol> 
>             The goal here is to keep the bar fairly high for creating a branch to keep the team focused on contributions that will help the current product ship or get an early start on the next version of the product. **Every extraneous check in has an operational cost (i.e. storage, back up time, restore time, performance, etc.) so should be avoided**.</blockquote> 
>             
>             Contrast this with Git:
>             
>             git checkout -b TopicBranchName
>             
>             Presto, a local branch that may or may not ever get back into mainline development. All of the alternative options listed are mainly focused on making sure that the centralized VCS repository stays “clean”. In a DVCS, I don’t run into that problem. I can create local clones, local branches, none of which never need to make it up to the server. All the operations are local, insanely fast, and don’t require an internet connection.
>             
>             If I have to worry about the operational cost of commits (check ins), is that really a VCS tool I want to use? This isn’t really a TFS problem – SVN managed branches in a similar manner. It all comes back to the real disease – using a centralized VCS system.