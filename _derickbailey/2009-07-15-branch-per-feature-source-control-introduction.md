---
wordpress_id: 68
title: Branch-Per-Feature Source Control. Introduction
date: 2009-07-15T21:04:35+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/07/15/branch-per-feature-source-control-introduction.aspx
dsq_thread_id:
  - "262068252"
categories:
  - Agile
  - Branch-Per-Feature
  - Branching Strategies
  - Continuous Integration
  - git
  - Source Control
  - Standardized Work
  - Subversion
  - Workflow
redirect_from: "/blogs/derickbailey/archive/2009/07/15/branch-per-feature-source-control-introduction.aspx/"
---
**Update:** 

I have used the term ‘branch-per-feature’ very loosely until recently. It was a catchy name, easy to remember, and got the point across. However, this is only one example of what is really a branching strategy.&#160; A branching strategy is nothing more than an understanding of when you should branch your code and when you should merge that branch, where. 

With that in mind, I feel the need to reorganize and rewrite many of these posts, as the information is applicable to more than just branch-per-feature. However, I don’t know that I would have time for that. Maybe I’ll get to it some day… maybe I’ll rework all of this as part of a book at some point. Maybe maybe maybe… just note that the processes and theories I provide here are easily extracted into principles that can be applied to most branching strategies.

&#160;

&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;-

I’ve been meaning to write up a post on Branch-Per-Feature for a very long time now – nearly a year, actually. I’ve been seeing a lot of twitter about this idea, recently, and have done a poor job of assisting those who are asking questions. Today, though, [Tim Ottinger](http://agileotter.blogspot.com/) finally convinced me to get off my butt and get it done. So, here it is… well… here’s the index and introduction for a multi-part post series, anyway.

### What Is Branch-Per-Feature

At the heart of Branch-Per-Feature, is the notion of using source control in a manner that allows multiple teams or individuals to work on the same software system without clobbering each other with change sets. That is, we should be able to work in a manner that allows Feature Team A (FTA) and Feature Team B (FTB) to work independently of each other. FTA should be able to analyze, code, test, and deliver their feature without any regard for the work that FTB is currently engaged in. When either team is finished with their work, the other team will merge the now stable feature changes into their branch, and continue on from there.

### The Article Series

As I began writing up the initial post on Branch-Per-Feature, I recognized the significant amount of information that I was trying to dump onto the world, all at once. While I do believe that all of what I am going to say is useful and beneficial, I also think that it would be better for the community if I split the information into more logical chunks. This will allow the individual reader to more easily find information that they are looking for, without having to wade through page after page after page of information that they don’t want at the moment.

The following is the outline of posts that I am planning for this series.

  1. [Branch-Per-Feature Source Control: Why](https://lostechies.com/blogs/derickbailey/archive/2009/07/15/branch-per-feature-source-control-part-1-why.aspx) 
  2. [Branch-Per-Feature Source Control: How (Theory)](https://lostechies.com/blogs/derickbailey/archive/2009/07/21/branch-per-feature-source-control-part-2-how-theory.aspx) 
  3. [Branch-Per-Feature Source Control: How I Manage Subversion With Git Branches](https://lostechies.com/blogs/derickbailey/archive/2010/02/03/branch-per-feature-how-i-manage-subversion-with-git-branches.aspx) 
  4. Branching Strategies: 
      1. [When To Branch And Merge](https://lostechies.com/blogs/derickbailey/archive/2010/02/24/branching-strategies-when-to-branch-and-merge.aspx) 
      2. [The Cost Of Branching And Merging](https://lostechies.com/blogs/derickbailey/archive/2010/02/24/branching-strategies-the-cost-of-branching-and-merging.aspx) 
      3. [Handling Dependencies Between Branches](https://lostechies.com/blogs/derickbailey/archive/2010/04/06/branching-strategies-handling-dependencies-between-branches.aspx)
      4. Database Considerations 
      5. Continuous Integration Per Branch 

Other branch per feature and branching strategy posts out there on the interwebs

  1. [Branch-Per-Feature in Subversion](http://darrell.mozingo.net/2009/12/04/branch-per-feature-in-subversion/) (by Darrell Mozingo) 

The “Lessons Learned” information may find it’s way directly into the individual posts. However, I’m hoping to collect all of these into a single post, specifically, at the end of the series. Be sure to check back to this index page on a regular basis, for updates in the series. I’m planning to get the series done in a fairly short amount of time (a few weeks, at the most) so that I don’t lose my momentum or motivation.