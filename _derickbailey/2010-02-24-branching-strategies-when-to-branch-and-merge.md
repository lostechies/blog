---
id: 104
title: 'Branching Strategies: When To Branch And Merge'
date: 2010-02-24T15:18:35+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/02/24/branching-strategies-when-to-branch-and-merge.aspx
dsq_thread_id:
  - "262046224"
categories:
  - Branch-Per-Feature
  - Branching Strategies
  - git
  - Source Control
  - Subversion
---
</p> 

At a very high level, all branching strategies have the same core policies: create the branch when you are confident that the cost of branching and merging is less than the cost of committing to the main source line, and merge when you are “done, done” making changes in that branch. There are many branching strategies that are very useful. You can branch per iteration or sprint, branch per sub-team, branch-per-release, branch per feature or defect, etc. Most likely, though, you will find yourself in scenarios where a policy of a single branching strategy is not feasible. The real world is full of fun surprises and little nuances that can make a single strategy good, bad or otherwise – all within the same project. 

Having multiple branching strategies available in your toolbox will undoubtedly create new opportunities to sustain or improve the performance of your team. For example, my current team tends to run on a branch per iteration basis. However, we have recently found ourselves using a feature branch in our centralized source control system. Additionally, many of the individual team members run local branches for their day to day development work, synchronizing with the centralized server only when necessary. This emergent set of strategies allows us to solve some rather complex problems that are found in our environment, rather easily. 

&#160;

## Branching Strategies

Here are some of the branching strategies that I’ve used in the last few years. I know there are many others out there and I can almost guarantee that I’ll end up using more than just this list at some point. I don’t intend this to be an exhaustive list of branching strategies – only an introductory list. For a much more in-depth discussion of other branching strategies check out Brad Appleton’s “[Branching Patterns for Parallel Software Development](http://www.cmcrossroads.com/bradapp/acme/branching/)”. 

&#160;

### Branch Per Feature

If you’re reading this, you’re probably familiar with branching by feature. 🙂 If not, you may want to head back to [the beginning of my series](http://www.lostechies.com/blogs/derickbailey/archive/2009/07/15/branch-per-feature-source-control-introduction.aspx) to get a complete understanding of what feature branches are, why, when and how to use them. As a quick review, though, a feature branch is exactly what is sounds like. A branch is created for a feature to be developed from the start of work on that feature, to it’s completion. Once the feature is ready to go you merge it back into the main source line or into another branch for continued work. Multiple feature teams can work in parallel without immediately affecting each other. When FeatureTeamA completes their work and merges back into the main source line, FeatureTeamB is then required to merge the changes into their branch so that they have the correct foundation of code to work from.

&#160;

### Branch Per Iteration/Sprint

Branching per iteration or sprint is used to separate the individual iterations from each other. This allows you to have potential release candidates in one branch while continuing to work on new features and development efforts in other branches. You can either create a branch at the beginning of the iteration and work out of there, entirely, or you can work out of the trunk throughout the iteration and branch it at the end. 

If your customer or other stakeholders are not immediately available for review or demonstration of the iteration’s features, then an iteration branching strategy can be very beneficial. You can continue working on the next set of features and functionality while you wait for the customer availability. Once they have reviewed the work and if they suggest any changes, those changes can either be incorporated into the original iteration branch as a potential release, or can be worked into the current or future iterations.

&#160;

### Branch Per Team/Sub-Team (Hub And Spoke)

If you’re working on a team that has multiple projects, feature groups, or other separated areas of functionality, you can divide the work into teams and sub-teams and have each team working in their own branch. This can be done with feature branches, project branches, functional areas, or any other line of division in the code. The important factor here is that the branch is maintained by multiple developers who may, in turn, have their own sub-branches during development efforts. The effect of this branching strategy is that you will have a multi-tiered hub-and-spoke layout in your source control system. There will be a hub where multiple sub-teams synchronize their own changes, and each hub will synchronize to a further upstream hub. 

If your team is using feature breakdown and rollup techniques that allow individual stories to be implemented independently, you can merge to a hub and show the current state of a feature to a customer. For example, if FeatureA has Story1, Story2 and Story3, you may be able to merge Story1 and Story2 into a “FeatureA” branch when they are done. Let the customers and/or other stakeholders see the current progress of the feature, while Story3 is still being worked on. Then when the Story3 is ready, it can be merge into the FeatureA branch for final testing, and the FeatureA branch can be merged into the main source line when it is ready for delivery. 

Distributed versioning systems like Mercurial and Git make this very easy to do. Chances are, if you are using a distributed system then you are working in a manner that is similar to this already. It’s a very natural branching schema for distributed source control systems. Centralized source control, on the other hand, requires more work and more coordination for this to be effective. It can be done, though. For example, with Subversion you may find that you need to create sub-folders in your primary branches folder. Each of these folders may represent a team, and would contain multiple branches – one per sub-team (or per person).

&#160;

## Merging

Whatever branching strategy you decide to use, the merging strategy tends to follow right behind. For example, a branch per feature strategy typically has merges done along feature completion lines. That is, when a feature is started, a branch is made and when that feature is done, the branch is merged back in to the main source line. This isn’t always the case, though. There are some good reasons for decoupling the branching strategies from the merging strategies, allowing your team to react to the real world and it’s every changing landscape. Your team’s definition of “done” will have a direct impact on when you should merge your code. Feature or bug-fix aggregation can be done to simplify testing. Inter-branch dependencies can cause problems that may solved by merging branches together. 

In a continuous deployment environment, “done” means that is has been thoroughly tested by all automated and human testers, verified by the stakeholders, demonstrated to potential end users, etc. etc. It is production worthy, and ready to be shipped. In other environments – like many of the teams that I have worked with in the last few years &#8211; “done” means something much earlier in the lifecycle of a feature or piece of functionality. For example, a team I worked with in 2009 had a “done” definition that stopped just prior to demonstration and formal testing by our customer. Another team I worked with defined “done” as “ready for the test lab”. And still other teams have other definitions that match their specific circumstances.

There are still other reasons why you might not merge along the same lines as you originally branched.

&#160;

## Other Strategies And Considerations

There are many aspects of a system to be considered when branching your code – more than what I’ve stated here. You need to consider a team’s organization, the system’s architecture, etc. These, together with the rest of the circumstances that create the context in which you work, will play into which branching strategies you decide to use, when. In the end, the goal is to provide a sandbox for the context in which code is being written. Understanding the available options, when each option is best suited to the situation at hand and [the cost of these options](http://www.lostechies.com/blogs/derickbailey/archive/2010/02/24/branching-strategies-the-cost-of-branching-and-merging.aspx) will help you in deciding how and when to branch.