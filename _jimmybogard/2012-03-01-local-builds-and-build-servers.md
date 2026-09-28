---
wordpress_id: 591
title: Local builds and build servers
date: 2012-03-01T21:13:42+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/03/01/local-builds-and-build-servers/
dsq_thread_id:
  - "595303328"
categories:
  - ContinuousIntegration
---
So this week I added [NuGet](http://confluence.jetbrains.net/display/TCD7/NuGet) publishing straight from TeamCity for [AutoMapper](http://automapper.org/). Every time I push to master, a new NuGet package is automatically published to the official NuGet repository. In order to do so, I just used the built-in steps in TeamCity to pack and publish the package.

TeamCity makes it very simple to do so, and it’s just a couple of screens to set up. What I’m conflicted on is **how much logic should be in the build server configuration versus the build script that lives with the source code**.

On one hand, putting this in the source code (the entire build/deploy script) ensures that the logic of how to build and deploy a component is version controlled along with the code itself, so that I can deploy any version at any time. This is what the Continuous Deployment book recommends, to version deployment scripts along with the rest of the code.

The flip side is that **deployments in general change at different rates and different reasons than code**. In fact, I’ve often seen these be totally orthogonal concerns, and I don’t want to necessarily have to make a commit in source control just to alter my deployment strategy.

Where it hit me in AutoMapper was the server build was failing in how I configured the steps, but **I couldn’t drop back to a local build to run individual steps in isolation** and debug. Instead, I kept having to run the entire build. With a build whose entire set of build/deployment steps are entirely in a script that is version controlled and runnable locally, I could have incrementally, and in isolation, built out the build/deployment scripts.

I haven’t figured out the best way to go, but with the increasing power of build servers to be the definition of your build in a very easy fashion, it’s going to be tougher to decide.