---
id: 3388
title: Using AppHarbor for Continuous Integration
date: 2011-03-12T01:12:00+00:00
author: Chris Missal
layout: post
guid: /blogs/chrismissal/archive/2011/03/11/using-appharbor-for-continuous-integration.aspx
dsq_thread_id:
  - "262074367"
categories:
  - AppHarbor
  - Continuous Integration
  - Deployment
  - git
---
I thought it would be interesting to use [AppHarbor](http://appharbor.com/) as a quick way to get some code with tests under a continuous integration environment. Along with this, if I could also use the AppHarbor deployed web site to serve that file, even better!

### AppHarbor

**What:** If you haven&#8217;t heard about AppHarbor yet, go check it out. They offer Git and Mercurial hosting that will also run unit tests (with various frameworks). You&#8217;re able to deploy different versions of your site with a single click and they have SQL Server support.

**Why:** It&#8217;s free and easy. It runs your tests. It lets you deploy any version of your code. It&#8217;s getting better each day.

### Continuous Integration

**What:** Why should I describe it when others can do so much better:

<p style="padding-left: 30px">
  <i>Continuous Integration is a software development practice where members of a team integrate their work frequently, usually each person integrates at least daily &#8211; leading to multiple integrations per day. Each integration is verified by an automated build (including test) to detect integration errors as quickly as possible. Many teams find that this approach leads to significantly reduced integration problems and allows a team to develop cohesive software more rapidly. This article is a quick overview of Continuous Integration summarizing the technique and its current usage. &#8211; <a href="http://martinfowler.com/articles/continuousIntegration.html">Martin Fowler</a></i>
</p>

**Why:** Deliver your most current build through a web site by typing &#8220;git push AppHarbor master&#8221;. It wont build your binary unless your tests pass. This means there&#8217;s no way to push a new downloadable version of your code unless all tests pass; it&#8217;s just nice and easy.

### How to do this?

The code is super simple, you can download the assembly to do this from the application that actually does it. Visit <http://cheap-ci.apphb.com>.</p> 

### Some Questions and Thoughts

I don&#8217;t know if this is useful or not, but I wanted to try it. Let me know what I&#8217;m missing or doing wrong. Let me know if there&#8217;s something to do better. The thought popped in my head the other day, and now that I have a proof of concept, I thought I should share.