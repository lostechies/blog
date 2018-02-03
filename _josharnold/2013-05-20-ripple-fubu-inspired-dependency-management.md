---
wordpress_id: 257
title: 'ripple: Fubu-inspired dependency management'
date: 2013-05-20T15:47:33+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=257
dsq_thread_id:
  - "1301709407"
categories:
  - general
tags:
  - fubu
  - ripple
---
I&#8217;m happy to announce that our ripple project is now publicly available and it&#8217;s sporting some [brand new documentation](http://darthfubumvc.github.io/ripple/ripple/). The docs go into greater detail than I&#8217;m going to write here but I&#8217;ll provide some highlights:

**Overview:**

Ripple is a new kind of package manager that was created out of heavy usage of the standard NuGet client. The feeds, the protocol, and the packages are the same. Ripple just embodies differing opinions and provides a new way of consuming them that is friendlier for continuous integration.

**Features:**

1. Staying up to date with the latest build

Ripple introduces the concept of &#8220;Fixed&#8221; vs. &#8220;Float&#8221; dependencies. For internal dependencies, it&#8217;s often beneficial to keep all of your downstream projects built against the very latest of your internal libraries. For the Fubu team, this means that changes to FubuMVC.Core &#8220;ripple&#8221; into downstream projects and help us find bugs FAST.

2. Command line friendly

Ripple is 100% command line and has no ties into Visual Studio. The usages were designed for how the Fubu team works and for integration with our build server.

3. Generating nuspec files

Keeping your packages up to date with versions can be a challenge when you have a lot of them. Ripple provides the ability to automatically generate version constraints for the dependencies in your nuspec files so that you never get out of sync.

&#8230;[and lots more.](http://darthfubumvc.github.io/ripple/ripple/)

**Getting Started:**

Ripple is published both as a Ruby Gem (ripple-cli) and as a NuGet package (Ripple) &#8212; which you can use with Chocolatey.

You can read the &#8220;Edge&#8221; documentation here: [http://darthfubumvc.github.io/ripple
  
](http://darthfubumvc.github.io/ripple) _
  
Note:  The ripple docs are powered by our brand new &#8220;FubuDocs&#8221; tooling. Jeremy will likely be writing about that one soon. If he wasn&#8217;t planning on it&#8230;then I think I just volunteered him for it._