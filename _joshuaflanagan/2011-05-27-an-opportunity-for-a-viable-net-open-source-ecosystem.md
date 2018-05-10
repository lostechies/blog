---
wordpress_id: 3975
title: An opportunity for a viable .NET open source ecosystem
date: 2011-05-27T01:23:57+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: http://lostechies.com/joshuaflanagan/2011/05/27/an-opportunity-for-a-viable-net-open-source-ecosystem/
dsq_thread_id:
  - "315037208"
categories:
  - Uncategorized
---
> 
I recently started getting to know Microsoft&#8217;s <a href="http://www.nuget.org/" target="_blank">Nuget</a> package management tool. I&#8217;ll admit I was going into it expecting to be disappointed, still annoyed that it had effectively killed the <a href="http://codebetter.com/drusellers/2010/07/17/nu/" target="_blank">nu</a> project and marginalized <a href="http://www.openwrap.org/" target="_blank">OpenWrap</a> &#8211; two projects in the same problem space, but from the community, that I thought had promise. However, after an hour or so of playing with it &#8211; pulling packages into a project, authoring my own package &#8211; I came away impressed. It worked and it was easy.

Of course, it wasn&#8217;t too long before I ran into a pain point. I wanted to create a nuget package as part of my continuous integration build. A nuget package needs a version number that increases with every release. So it stands to reason that every time you build the package, you are going to give it a new version number. The problem was that the version number could only be specified in the .nuspec file. The .nuspec file describes how to build the package, mostly static information that should be checked into source control. The idea that I would have to modify this file every time I built seemed absurd (because it was). I had found it! A reason to complain about nuget! Microsoft just doesn&#8217;t get it! Wait until twitter hears about this!

## A New Hope

And then I remembered there was something very _different_ about the nuget project: while it is primarily maintained by Microsoft employees, it accepts contributions from the community. Suddenly, the barbs I was about to throw wouldn&#8217;t apply just to the big bully Microsoft, but my own .NET developer community. As a core member of many open source projects over the years, I know how limited resources are, and that feature prioritization is usually based on the needs of the people willing to do the work. If I thought it was important, it was time to step up. So <a href="http://nuget.codeplex.com/workitem/754" target="_blank">I logged an issue</a>. It got a few nods of approval, so <a href="http://nuget.codeplex.com/SourceControl/changeset/changes/3e9aa42bbdd2" target="_blank">I submitted a pull request</a>. And then the strangest, most wonderful, the big-ship-is-turning thing happened: they accepted it. Within two days of discovering this twitter-rant worthy, how-could-they-not-think-of-this-scenario, nuget-is-doomed problem, it was fixed. Huh.

Fast forward a few weeks. Old prejudices die hard. I&#8217;m trying to take advantage of the very cool <a href="http://www.symbolsource.org/" target="_blank">symbolsource.org</a> integration (I think the lack of an approachable public symbol server until now has been as big a hole as not having a package manager). It becomes painfully clear that the nuget support for symbol package creation is only viable for the most simplest scenarios. I was annoyed and exhausted from a long night of fighting the tool, so was a little quicker on the twitter trigger (although still much tamer than I felt):

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; margin: 0px 0px 8px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="/content/joshuaflanagan/uploads/2011/05/image_thumb.png" width="324" height="109" />](/content/joshuaflanagan/uploads/2011/05/image.png)

Then, remembering my last experience, I figured I would at least <a href="http://nuget.codeplex.com/discussions/258338" target="_blank">start a discussion</a> before giving up for the night. To my surprise, the next day it was <a href="http://nuget.codeplex.com/workitem/1089" target="_blank">turned into an issue</a> &#8211; this isn&#8217;t just another <a href="http://ayende.com/blog/2667/how-to-kill-the-community-feedback-or-the-uselessness-of-microsoft-connect" target="_blank">Microsoft Connect black hole</a>. After hashing out a few details, I went to work on a solution and submitted a <a href="http://nuget.codeplex.com/SourceControl/changeset/changes/2e7df0e9ae42" target="_blank">pull request</a>. It was accepted within a few days. Aha! This is open source. This is how its supposed to work. This works.

The Nuget project is the most exciting thing to come out of Microsoft DevDiv since the .NET Framework was released. I think it is very important to the .NET open source community that it succeeds. Not just for the obvious benefit of simplifying distribution for all of the non-Microsoft open source solutions. But for the potential it has to change minds internally at Microsoft about how community collaboration can work. And for the potential it has to change minds in the _community_, about how collaboration with Microsoft can work.

## Epilogue: The alternative

Ever read the What If&#8230;? comic books? <a href="http://en.wikipedia.org/wiki/What_If_(comics)" target="_blank">From wikipedia</a>:

> _What If_ stories usually began with [the narrator] briefly recapping a notable event in the mainstream Marvel Universe, then indicating a particular point of divergence in that event. He would then demonstrate, by way of looking into a parallel reality, what could have happened if events had taken a different course from that point.

I&#8217;ve been thinking a lot lately about &#8220;What if&#8230; Microsoft had launched ASP.NET MVC as a collaborative project that accepted community contributions the same way that Nuget does?&#8221;

Would <a href="http://fubumvc.com/" target="_blank">FubuMVC</a> exist? I&#8217;m not sure it would, and I&#8217;m not sure that would be a bad thing. We, the FubuMVC team, started out building a new product on ASP.NET MVC, adopting Microsoft&#8217;s framework before it even went 1.0. We inevitably ran into some pain points that we had to work around. Of course, the workarounds had to be implemented in our application codebase because Microsoft did not want them and/or could not take them. As we built up more and more workarounds, we relied less and less on the out-of-box functionality. It starts with a custom action invoker. Which leads to custom model binding. Then custom HTML helpers. Route creation and URL resolution. After a year and a half of this, it became clear we were building our own framework. During a few days of a long Christmas vacation, <a href="https://lostechies.com/chadmyers/" target="_blank">Chad Myers</a> went the last mile and extracted our changes into a google code project that eventually became FubuMVC.

Now consider what might have happened if Microsoft accepted contributions to MVC. Remember, we didn&#8217;t decide from day 1 to write a new framework &#8211; we had a product to build. As each issue came up, we could have submitted it as a patch. Each patch on its own wouldn&#8217;t have been a revolutionary change. But the motivations behind them may have started to sneak into the consciousness of everyone working on the codebase. You see, we, and anyone else that may have contributed, had a major advantage over the Microsoft contributors: we were building real applications with this framework.

Now, I don&#8217;t think the end result would have been a framework with all of FubuMVC&#8217;s traits (requiring an inversion of control container would have been DOA). But certainly some of the core ideals (composition over inheritance, leveraging the strengths of the type system) could have snuck in. And instead of going our own way, we could have benefited from all of Microsoft&#8217;s work: Visual Studio tooling, razor view engine support, documentation, and an overall thoroughness you get from paid employees working on it full time. And of course its not just us &#8211; ideas and code from projects like <a href="https://github.com/openrasta/openrasta-stable/wiki" target="_blank">OpenRasta</a>, <a href="https://github.com/NancyFx/Nancy" target="_blank">NancyFX</a>, and <a href="http://owin.org/" target="_blank">OWIN</a> could have snuck in too.

I think that was a major missed opportunity. The Nuget project is proving there is a better way.