---
wordpress_id: 68
title: 'Git/Branch-Per-Feature &#8211; Composable Deployments/Releases?'
date: 2010-03-09T05:27:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2010/03/09/git-branch-per-feature-composable-deployments-releases.aspx
categories:
  - git branch-per-feature
redirect_from: "/blogs/joeydotnet/archive/2010/03/09/git-branch-per-feature-composable-deployments-releases.aspx/"
---
(composed in vim with love)

Now that I&rsquo;m starting to use Git a lot more, I&rsquo;ve been thinking about and starting to use branch-per-feature a little bit. This morning I had a term pop into my head as I was thinking about branch-per-feature: &ldquo;Composable Deployments/Releases&rdquo;. Now I&rsquo;m still getting the hang of this whole branch-per-feature thing, so this might be old hat for a lot of you, but I noticed something in some of my recent work with Git and how my workflow was starting to shape up. Here is an example of how using Git and Branch-Per-Feature is starting to make my life easier. 

**Disclaimer**

****I&rsquo;ve only been using Git for a couple weeks, so go easy on me&#8230; 😉 

**Life With Subversion**

****I manage my church&rsquo;s web site and have used subversion for managing the code for a long time. As I&rsquo;m working on new projects for this web site, I deploy them to a &ldquo;staging&rdquo; site that is used to review and test out new changes with our Pastors and ministry leaders. In the meantime, small changes and content updates get done and deployed to &ldquo;production&rdquo; in parallel to these new, larger projects that get pushed to &ldquo;staging&rdquo;. One of the issues I&rsquo;ve always had is how to easily work on these new projects separately and deploy new features in isolation from one another. Using the typical trunk/branches style of subversion, I&rsquo;ve always done most work directly in trunk and sometimes creating branches for larger projects. Unfortunately trying to do this with subversion is Not Fun(TM). Also this made it tough to separate &ldquo;staging&rdquo; deployments from &ldquo;production&rdquo; ones. Of course I could have managed environment-specific branches in subversion and done the merging dance with subversion, but again, Not Fun(TM). 

**Enter Git**

****I&rsquo;ve been using Git for a couple weeks locally to manage local branches for my &ldquo;day job&rdquo;, where we still use subversion as our main VCS (for now&#8230;muwhahaha :)). But for my church site I decided to make the full move to use Git with Beanstalk [<http://beanstalkapp.com>], which is where I&rsquo;ve been doing my subversion hosting for a while now. Beanstalk just recently added Git support and so far it&rsquo;s working out great.
  
One of the first things I noticed as I started using Git was how easy it is to branch and merge code. So I figured I&rsquo;d try out this whole Branch-Per-Feature [[http://www.lostechies.com/blogs/derickbailey/archive/2009/07/15/branch-per-feature-source-control-introduction.aspx](/blogs/derickbailey/archive/2009/07/15/branch-per-feature-source-control-introduction.aspx)] thing all the cool kids are talking about these days. Needless to say I&rsquo;m liking it a lot. 

Ok, so getting to the point of this post, here is a peek at the branches I&rsquo;m managing right now: 

  * master (gets deployed to production)
  * staging (environment branch used to push to a staging site)
  * faith (feature branch for a new statement of faith page)
  * visitors (feature branch for a new visitors page)
  * <insert other temporary branches here for one-off changes that get merged into master and deployed>

One of the things I \*really\* like about this is that I can keep work nice and isolated in feature branches and easily merge them as needed into the appropriate environment-specific branch (staging or master) when it&rsquo;s ready to be deployed. My current workflow is something like this: 

(Note the use of Git aliases [<http://git.wiki.kernel.org/index.php/Aliases>], which I&rsquo;d highly recommend) 

  * git co faith
  * &#8230;do some changes&#8230;
  * git add .
  * git ci -m &ldquo;blah blah&rdquo;
  * git co staging
  * git merge faith
  * test changes in staging branch and deploy to staging environment

The way I&rsquo;m treating the staging branch is mainly as a &ldquo;merge and deploy&rdquo; branch. I&rsquo;m not usually making any direct changes in the staging branch. So, in theory, once the feature in the faith branch is tested and ready for to be deployed to production, I could just merge that feature branch straight into master and then do my normal production deployment. This seems like a really nice way to work. That&rsquo;s why I called it &ldquo;composable deployments/releases&rdquo; because it&rsquo;s really nice to be able to &ldquo;compose&rdquo; a deployment simply by merging in the appropriate feature branches as needed. 

I&rsquo;m still a Git n00b for the most part, so I&rsquo;d be very interested in your feedback and improvements. I&rsquo;m sure my thoughts on this will change the more I learn and use Git, but so far this is really working for me quite well.