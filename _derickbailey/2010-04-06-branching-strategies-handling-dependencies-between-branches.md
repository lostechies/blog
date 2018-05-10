---
wordpress_id: 133
title: 'Branching Strategies: Handling Dependencies Between Branches'
date: 2010-04-06T12:15:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/04/06/branching-strategies-handling-dependencies-between-branches.aspx
dsq_thread_id:
  - "262068587"
categories:
  - Branch-Per-Feature
  - Branching Strategies
  - Principles and Patterns
  - Source Control
redirect_from: "/blogs/derickbailey/archive/2010/04/06/branching-strategies-handling-dependencies-between-branches.aspx/"
---
Every system evolves over times. There’s no way around this and there is no reasonable/certain/real way to think ahead 100% of the time. It’s simply not possible to predict every possible outcome or issue or situation. This change affects every part of software development, from requirements and feature definition, down to the code, and out to source control and configuration management. Good architecture, coding practices and source control management can make change easier, but even when all of the rules for when to use which branching strategy in source control are followed, there are still going to be situations that make it difficult to keep branches clean and decoupled. At some point in a project’s lifecycle, branch dependencies – where one or more branches directly depend on the features, functionality, code, and/or other changes in another branch that is currently in development – will occur. When this happens, there are some high level techniques that can be used to mitigate the problems.

&#160;

### Some Branch Dependency Types

There are many reasons that one branch may depend on another. The real world can be a tricky and frustration filled environment where subtle nuances can wreak havoc on what was thought to be a solid process. None of these dependency types are exclusive of others. It’s very likely that a team will run into more than one of these dependency problems at the same time. This is especially true for projects that are relatively young and/or changing rapidly. 

This isn’t a complete list of dependencies either, but an understanding of high level dependency types will help lead to recognition of others as they are encountered.

> **Architecture Dependencies:** As the architecture of a system changes, it is highly likely that an in-progress feature will need to or want to use the new architectural components. If the architectural changes are occurring on a branch, so as not to disturb the main source line, then the in-progress branches may have a dependency on the new architecture’s branch. 
> 
> **Feature Dependencies:** There are times when one feature cannot be completed without another feature that is currently in progress, or at least one feature may be severely hampered or less valuable without the other feature in place. For example, when implementing a spell check tool in a word processor, there is little value in telling the end user that a word is spelled wrong if the software cannot provide suggested corrections.
> 
> **Bug Fix Dependencies:** A single bug can affect many different features and functional points in a system. When a bug is found and the code in question is being used by an in-progress branch, there is now a dependency on that bug fix. 

&#160;

### Handling Branch Dependencies

There are a number of ways to approach branch dependencies and like everything else in software development, the way the dependencies are handled is going to be entirely context specific. An understanding of the current situation is required in order to know how to handle the situation. Factors to consider include the type of dependencies in question, the organization of the team, the general branching strategies being used, the architecture of the system, etc. etc.

> **Sub-Branches:** Using a branch to implement functionality needed in two or more branches. When that branch’s work is finished, it is merged into the other branched that need it.
> 
> **On Hold:** Putting one or more branches on hold while the changes in another branch are stabilized. Once the changes are stable, they can be merged into the on hold branches directly or into a common location such as the main source line or a sub-branch, etc. 
> 
> **Architectural Abstraction / Decoupling:** Use abstractions such as interfaces, abstract base classes, design patterns and architectural implementations to create boundaries between parts of the system.
> 
> **And Fakes / Stubs:**&#160; Depending on the type of boundaries in place, it is usually fairly easy to provide fake / stub implementations to the branch that depends on the changes in another branch. Once the changes are ready, the fake / stub implementations can be removed and the production ready implementations can be put in place. Good use of concepts like Inversion of Control, Dependency Inversion, Dependency Injection will help with situations like this. Other architectural concepts such as 
> 
> **Release, Patch, Re-Release:** A.K.A. Hope and Pray! Complete the work in a branch, ignoring any other branch that it may depend on, or that depend on it. When the dependency branch is completed, patch the code that was previously released to avoid code duplication, inconsistencies, and other issues that pop up. The judgment of when to use this tactic relies heavily on knowing the cost of delay for a given change and the cost of re-work. 

&#160;

### The Human Side Of Branching And Dependencies

No matter how many rules or policies or patterns we have for handling these situations, we will invariably come across new and frustrating problems in our efforts. Our best intentions and the solutions we implement today will set up the problems that we run into, tomorrow. In the end, the only real way to manage these scenarios is good ‘ol fashion communication. Talk to your team members. Use daily stand ups. Get together for design discussions and problem solving sessions. The more you communicate with each other, the less likely you’ll run into one of these scenarios after it’s too late to handle it gracefully.

&#160;

### How To …

The ideas that I’ve outlined are not a definitive list by any stretch of the imagination. I’ve only talked about the things that I’ve run into and have done, and I’m certain that others will have more to contribute based on their own knowledge and experience. I also haven’t covered anything more than a few words on each of these subjects, as the mechanical process for handling any of these is no different than any branching or merging effort. The real difference is why and when you are branching and merging&#8230; the strategies that you employ. If you would like more information on the mechanics of branching and merging from a theoretical and practical perspective, see the other entries in my [Branching Strategies series](https://lostechies.com/blogs/derickbailey/archive/2009/07/15/branch-per-feature-source-control-introduction.aspx), and in my [Source Control](https://lostechies.com/blogs/derickbailey/archive/tags/Source+Control/default.aspx) and related tags.