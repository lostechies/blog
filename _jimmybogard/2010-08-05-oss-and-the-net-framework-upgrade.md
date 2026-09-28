---
wordpress_id: 426
title: OSS and the .NET Framework upgrade
date: 2010-08-05T13:39:02+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/08/05/oss-and-the-net-framework-upgrade.aspx
dsq_thread_id:
  - "264716549"
categories:
  - Misc
redirect_from: "/blogs/jimmy_bogard/archive/2010/08/05/oss-and-the-net-framework-upgrade.aspx/"
---
I’ve hit a bit of a dilemma recently, I want to use features in C# 4.0 and .NET 4.0 to enhance AutoMapper, but this would eliminate the possibility of .NET 3.0 projects from being able to use the new version.

One option is to say that the current version is the last 3.0 version, and if you want 3.0, use that one.&#160; Another option is to fork, and keep a 3.0 version going forward, where I can apply bug fixes etc. to it.

This is the first OSS project I’ve been involved in that actually survived to another .NET Framework release, so I’m not entirely sure what the community expectations would be around this area.

My initial thought is just to upgrade the library to VS 2010 and .NET 4, but that might leave a few people in a lurch.&#160; Luckily I’m on Git, so it’s not really a problem to support multiple branches.

How have other projects dealt with this?