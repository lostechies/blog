---
id: 7
title: 'OSS on Github &#8211; Tips and Tricks'
date: 2011-07-01T16:38:43+00:00
author: Josh Arnold
layout: post
guid: http://lostechies.com/josharnold/?p=7
dsq_thread_id:
  - "347261839"
categories:
  - general
tags:
  - fubu
  - Git
---
This has come up a few times on a few projects so I thought I would share some tips and tricks that the Fubu team uses to manage the distribution of work. Call them conventions, rules, whatever works best for you.

> <span style="text-decoration: underline;">Update:</span>
  
> These rules vary a little bit when you have commit rights to the central repo. The way I describe them here are rules for those that do not have commit rights.

**Rule #1 &#8211; Don&#8217;t make changes to your local or remote master branches.**

The master branch on the central repo (i.e., DarthFubuMVC/fubumvc.git) AND the master branch on YOUR fork belong to the framework team. Here&#8217;s an example:

I have a fork of DarthFubuMVC/fubumvc. At all times, my master branch must be an identical replica of DarthFubuMVC&#8217;s master. Of course, I may fall behind and not push the latest changes to my master. This is ok. The point here is that I cannot have changes to my master branch that are not in DarthFubuMVC&#8217;s.

Another good rule here is that your local branches should match your github repo&#8217;s (on origin). In other words, don&#8217;t save changes to your local master that aren&#8217;t on your github master. And since you shouldn&#8217;t have changes to your fork&#8217;s master that aren&#8217;t in DarthFubuMVC&#8217;s we can conclude with this:

> **Don&#8217;t make changes to your local or remote master branches.**

**Rule #2 &#8211; Pull requests should always come from remote branches**

Given that you accept Rule #1, the only way to make changes is by branching. Therefore, in order to make changes public, you need to create a remote branch on your fork. Which leads us to rule #2:

> **Pull requests should always come from remote branches**

This makes it much easier to maintain commit history and ensure that the proper commits are pulled in without the need (or least decreasing the need) for cherry-picking.

**Rule #3 &#8211; Keep your trees trimmed**

Commit history is good and it&#8217;s even better when it&#8217;s properly maintained. So don&#8217;t be the neighbor that lets his trees grow into your backyard and drop leaves everywhere.

It&#8217;s a simple process that keeps everybody happy:

  1. Branch for a feature
  2. Do some work and commit it
  3. Checkout master and pull the latest
  4. Checkout your branch and rebase on top of master
  5. Run a build
  6. Push your branch
  7. Issue your pull request

This ensures that your changes are applied on top of the very latest changes to master. It makes it easier to read, easier to pull in, and increases your chances of your pull requests being accepted.

So there it is, rule #3:

> **Keep your trees trimmed**

These are the rules we follow for Fubu work but I think they&#8217;re generally applicable to most projects. What about you? What process do you use?

Major hat tip to [Josh Flanagan](http://lostechies.com/joshuaflanagan/), our resident master (not jack) of all trades and Git guru for establishing this process.