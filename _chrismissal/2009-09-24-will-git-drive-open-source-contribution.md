---
wordpress_id: 3368
title: Will Git Drive Open Source Contribution
date: 2009-09-24T00:04:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/09/23/will-git-drive-open-source-contribution.aspx
dsq_thread_id:
  - "262175031"
categories:
  - git
  - Open Source
---
I know I&#8217;m not alone when I say that I&#8217;ve been hearing a lot more about Git lately. I have talked to others that have expressed interested in moving to Git and dropping use of Subversion. _Now just to properly date this post&#8230; (SVN is currently on version 1.6.5 and Git is on version&nbsp;v1.6.4.4)._

## Gaining Traction

Just to show you some charts of how Git is gaining some ground and getting some awareness, here is the trend of Google&#8217;s searches for &#8220;git tutorial&#8221; (blue) vs &#8220;svn tutorial&#8221; (red):

![](//lostechies.com/chrismissal/files/2011/03/git-tutorial-svn-tutorial.png)

Additionally, the trend for Google searches for &#8220;git vs svn&#8221; seems to be skyrocketing out of nowhere:

![](//lostechies.com/chrismissal/files/2011/03/git-vs-svn.png)

It would seem that there are a lot of others out there looking into the differences between Git and SVN. Is it because they don&#8217;t know what Git is? Maybe. Is it because they&#8217;re finding problems with SVN? Maybe. That&#8217;s why I&#8217;ve been looking into it.

## The Pain of Subversion

I feel that Subversion is a big step up from using a version control system like Visual Source Safe. But I&#8217;ve also experienced my share of pain when dealing with multiple branches of a project. I&#8217;m always pleasantly surprised when a merge in SVN goes smoothly, but shouldn&#8217;t they always go smoothly? Why do I put up with the headaches while&nbsp;simultaneously expecting&nbsp;them each time? It&#8217;s time to remedy the pain and Git seems to address those pain points.

I still consider myself a newbie when it comes to Git, but what I&#8217;ve heard from others is that approving pull requests is much, much simpler than applying patches. Patch managers or project managers are allowed to &#8220;cherry pick&#8221; certain portions of commits, not the entire bulk of an individuals contribution. Many of the build errors on the CI server that I&#8217;ve committed are not adding files to Subversion beforing committing. I&#8217;ve gotten a lot better at this, but it still happens from time to time. When using Git, I&#8217;ve had great success by using &#8220;git status&#8221;, which shows me exactly what is unversioned. With this step as part of my workflow it&#8217;s been much easier to avoid adding files.

## The Benefit of a DVCS

With services like Github, anybody can commit by pushing their code to their own fork and asking the project managers to pull their changes into the master. I likely don&#8217;t have to explain how the process works, you can figure it out own your own. The other benefits&#8230;

> GIT kicks SVN&#8217;s butt wrt working copy. Same project pulled from the same SVN repo. GIT with full history 42 MB; SVN only trunk 134 MB. Wow!  
> &#8211; [@JamesKovacs](http://twitter.com/JamesKovacs/status/3831453052)

Git has been designed to keep a smaller footprint. Since you have local repositories, it is faster; also, you don&#8217;t have to worry about doing exports since there is only a top-level &#8220;.git&#8221; folder in the main repository, instead of a hidden folder, in&nbsp;every folder and subfolder.

You can commit multiple times locally, then push these all to the master. This allows you to work offline and complete a feature, push it to your local master, then keep moving on to something else. When you get back to a connected environment, you can then push many commits to the master or have them pulled from your fork. &#8220;Working on a plane&#8221; is usually the common scenario that is mentioned when you&#8217;re listening or reading about committing locally.

## Projects Moving to Git

The following projects use Git, are moving to, or have talked about moving to Git:

  * MvcContrib
  * Rails
  * NHibernate
  * Castle Project
  * RhinoTools (including Rhino Mocks)
  * rspec
  * Cucumber

## Will OSS Thrive From Git

Anybody can predict the future, it&#8217;s the accuracy that always seems to be the problem. I don&#8217;t know that open source will thrive from projects switching to, or being on Git repos, but I am going to predict that it will help them. Only time will tell on how accurate I am with this prediction. Apparantly I&#8217;m not the only one that is inspired by this shift:

> What I like about Git, makes me excited to develop&#8230;.  
> &#8211;
  
> [@TimBarcz](http://twitter.com/TimBarcz/statuses/3932146460) 

I&#8217;m really anxious to hear some other opinions on Git. What do you think about Git helping out OSS projects? What do you think about Git in general?