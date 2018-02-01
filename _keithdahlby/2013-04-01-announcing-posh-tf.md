---
id: 122
title: Announcing posh-tf
date: 2013-04-01T01:27:35+00:00
author: Keith Dahlby
layout: post
guid: http://lostechies.com/keithdahlby/?p=122
dsq_thread_id:
  - "1178682385"
categories:
  - posh-git
  - posh-tf
  - Powershell
---
As you may or may not know, I&#8217;ve been a fan of Git for a while now. I&#8217;ve [hacked](https://github.com/libgit2/libgit2sharp/commits/vNext?author=dahlbyk "Contributions to LibGit2Sharp") on an implementation of it, I&#8217;ve [presented](http://vimeo.com/43659036 "Git More Done @ NDC") on it, I&#8217;ve even built a [PowerShell environment](http://github.com/dahlbyk/posh-git "posh-git") for it that&#8217;s used by at least twelve people that aren&#8217;t related to me. Until a few months ago, I was content in my little Git bubble.

But recently I&#8217;ve been working with a team that has broadened my horizons and imparted a valuable lesson to me: &#8220;there&#8217;s nothing Git can do that TFS can&#8217;t.&#8221; Now if you&#8217;ve been following me for a while, you know this has been patently untrue. Until today.

# Announcing posh-tf

Obviously the killer feature that TFS lacks as an alternative to Git is that it doesn&#8217;t integrate well with PowerShell. According to the [UserVoice suggestion](http://visualstudio.uservoice.com/forums/121579-visual-studio/suggestions/3801822-provide-a-better-tf-exe-experience-with-powershell "TFS UserVoice: Provide a better tf.exe experience with PowerShell"), at least one person thinks this needs to be remedied. And so I am pleased to present [posh-tf: a PowerShell environment for Team Foundation](https://github.com/dahlbyk/posh-tf).

posh-tf provides everything that posh-git provides, except for the things that aren&#8217;t readily available from `tf.exe`:

  * No current branch information
  * No file status information
  * No tab completion for new, modified or deleted files
  * No tab completion for branches, shelvesets, etc

Actually, it would probably be easier to just list what it does provide:

  * Tab expansion for commands: `tf ch<tab>` expands to `tf checkout`
  * Tab expansion for help: `tf help ch<tab>` expands to `tf help checkout`
  * A prompt hook if someone can figure out a way to get current directory status.

Can&#8217;t wait to get started? The [readme](https://github.com/dahlbyk/posh-tf#readme) has everything you need!

I&#8217;m thrilled with what I have to release today, and am looking forward to working with the TFS community to make posh-tf even better!