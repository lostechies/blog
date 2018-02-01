---
id: 606
title: ASP.NET MVC, Web API, Razor and Open Source and what it means
date: 2012-03-28T13:39:10+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2012/03/28/asp-net-mvc-web-api-razor-and-open-source-and-what-it-means/
dsq_thread_id:
  - "627141063"
categories:
  - Community
---
In case you missed it, a large part of ASP.NET is not only going open source, but [will be developed in the open on CodePlex and will accept contributions](http://weblogs.asp.net/scottgu/archive/2012/03/27/asp-net-mvc-web-api-razor-and-open-source.aspx). Now, ASP.NET MVC has always been open source, but has always been developed more or less behind closed doors.

_Quick side note, to learn more about what “Open Source” means, check out the [Open Source Definition](http://www.opensource.org/docs/osd) from the [OSI](http://www.opensource.org/). “Open Source” does not now nor has ever meant “accepts contributions”._

In ASP.NET MVC 3, the MVC framework was released under an OSI approved license, but Razor was not. But starting today, you can go to [CodePlex](http://aspnetwebstack.codeplex.com/) and not only download the source, but watch as the ASP.NET team commits code on a daily basis.

So how does this affect the products now being developed in the open, and accepting contributions? As a maintainer of AutoMapper, which also went from closed source to open, I’ve felt the challenge of this transition. While I can’t speak for the ASP.NET team, I can offer my perspective on how going OSS affected the development of AutoMapper.

**Will the quality of the product be adversely affected because the team accepts contributions?**

No. Just because someone has the ability to accept contributions does not mean that anybody’s crappy code will make it in. Code submitted will go through the same review process that all other code commits go through from internal teams.

**Will some yahoo be able to sidestep my current feedback channel and take the product in some other (wrong) direction?**

Possible, but unlikely. In my experience, large features don’t get submitted as pull requests without intensive discussions with the team. I’ve only received one or two very large features in AutoMapper, and those were after long conversations on GitHub or the mailing list. The discussions are public, and anyone can participate.

Basically, if you submit a large pull request that isn’t on the team’s roadmap, it’s more than likely going to get rejected. I know, because I’ve rejected large pull requests for the same reasons. If a team develops in the open, you don’t go hide in a hole, develop a big feature, then expect it to get rolled in.

**Will my pull request get accepted?**

I don’t know. I don’t accept every pull request. It’s not even a size thing, sometimes I just don’t like a feature, don’t think it’s needed, or don’t like an implementation. I’ve submitted plenty of patches that got rejected for a wide variety of reasons, but again, OSS is all about the ability to make your own changes, not that your changes will make it back into the fold.

**Will someone else’s changes be supported?**

Yes. Because the team ultimately makes the call on whether or not code gets into the mainline and released, it’s actually not that important _who_ wrote the code. It really just matters that the team has committed to support whatever code makes it in to the release.

**Are we in store for human sacrifice, dogs and cats living together, mass hysteria?**

No. But nice Ghostbusters reference.

**Can we trust these products now?**

I don’t see why not. You’ve never met the team that coded the original products, so it shouldn’t matter who wrote the code, rather that the code is approved.

**Is this a Good Thing?**

Yes. The biggest benefits I see are that:

  1. Small fixes that get lost in Connect issues etc. are much more easily addressed through contributions. The little stuff will get better and more complete.
  2. Bigger changes will get feedback more early from the community. Often, by the time the community gets to see a working product, it’s way past the point of being able to provide substantial feedback.

**What could go wrong?**

It’s not all rainbows and unicorns. The biggest thing is that once you start engaging directly with the community through your code, you’re going to start getting a lot more feedback. Now the feedback is better and more targeted, but it is a different animal.

However, I don’t think it’s going to be a big deal. Right now, the team receives feedback in big batches, after releases, making it quite hard to sift through all those comments at once. By developing in the open, those comments become spread out a lot more throughout the dev cycle. Also, I imagine that much of the feedback received after a release will just go away because things will just be addressed earlier when changes are much easier to make.

**Does this mean the Contrib projects are going away?**

No. Contrib projects have their place, as a repository of supplemental features that aren’t necessarily a good idea to fold into the main project. The part of the Contrib project that is filling out “missing” features will likely go away, but the “supplemental” parts are still definitely valuable. Also valuable are pieces that build on top of that product and another one, where the core product shouldn’t take that dependency.

As an example, Input Builders would never have made it into the MvcContrib project, as we would have just worked with the MVC team on a common design.

**Why CodePlex and not GitHub?**

Really? No no no wait. Really? You know, you can mirror the source on GitHub if that’s your style. It’s DISTIRBUTED VCS, ya know. But really? It’s called being a Team Player. And the CodePlex team is (re)committed to make CodePlex a viable place for OSS development. GitHub is still vastly superior, but the level of feedback that the MS teams will start giving the CodePlex team because of this new relationship is also a Good Thing.

In short, this is a Good Thing, and I’m excited that Microsoft is taking this step. It’s a step I never thought Microsoft would take, and just assumed that it would never happen. But it has, and now we can start pushing for other products/tools to be released the same way.