---
id: 903
title: 'Git on Windows: Whence Cometh Configuration'
date: 2016-08-22T08:47:19+00:00
author: Derek Greer
layout: post
guid: https://lostechies.com/derekgreer/?p=903
dsq_thread_id:
  - "5085504615"
categories:
  - Uncategorized
---
I recently went through the process of setting up a new development environment on Windows which included installing [Git for Windows](https://git-scm.com/). At one point in the course of tweaking my environment, I found myself trying to determine which config file a particular setting originated. The command ‘git config &#8211;list’ showed the setting, but ‘git config &#8211;list &#8211;system’, ‘git config &#8211;list &#8211;global’, and ‘git config &#8211;list &#8211;local’ all failed to reflect the setting. Looking at the options for config, I discovered you can add a ‘&#8211;show-origin’ which led to a discovery: Git for Windows has an additional location from which it derives your configuration.

It turns out, since the last time I installed git on Windows, [a change was made](https://github.com/git-for-windows/git/commit/153328ba92ca6cf921d2272fa7e355603cbf71b7) for the purposes of sharing git configuration across different git projects (namely, libgit2 and Git for Windows) where a Windows-specific location is now used as the lowest setting precedence (i.e. the default settings). This is the file: C:\ProgramData\Git\config. It doesn’t appear git added a way to list or edit this file as a well-known location (e.g. ‘git config &#8211;list windows’), so it’s not particularly discoverable aside from knowing about the ‘&#8211;show-origin’ switch.

So the order in which Git for Windows sources configuration information is as follows:

  1. C:\ProgramData\Git\config
  2. system config (e.g. C:\Program Files\Git\mingw64\etc\gitconfig)
  3. global config (%HOMEPATH%\.gitconfig
  4. local config (repository-specific .git/config)

Perhaps this article might help the next soul who finds themselves trying to figure out from where some seemingly magical git setting is originating.
