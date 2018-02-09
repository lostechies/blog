---
wordpress_id: 429
title: Why Hg branches are broken (or at least less useful)
date: 2010-08-26T03:18:16+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/08/25/why-hg-branches-are-broken-or-at-least-less-useful.aspx
dsq_thread_id:
  - "265140510"
categories:
  - Mercurial
redirect_from: "/blogs/jimmy_bogard/archive/2010/08/25/why-hg-branches-are-broken-or-at-least-less-useful.aspx/"
---
In one picture:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_2EB351FC.png" width="407" height="125" />](http://lostechies.com/jimmybogard/files/2011/03/image_214D3EF6.png) 

In Hg, branches are metadata included in each changeset.&#160; In the operation above, I created a branch, but that only marked the current directory with a branch name.&#160; The branch won’t actually show up unless I make a commit.&#160; In fact, if I checkout to another revision, it’s as if the “hg branch” command never happened.&#160; When I list the branches, you won’t see this new branch name.&#160; The name in the PS window just comes from the PowerShell-Hg extension being smart.

One implication is that our team has to make phantom commits for the branch to officially “show up”.&#160; You start to see commits like “phantom commit” early on, then later they start saying “stupid commit”.&#160; It’s the only way we could get a branch to show up locally and on the server.

In Git, a branch is nothing more than a pointer to a commit, and the commit itself carries no information about a branch name.&#160; A much more flexible model in my experience.

This hit me today when I wanted to move a set of commits to a different branch, which turned out to be very difficult as the branch name was embedded in to the commit names.&#160; Rebasing helped, except that the commits were already pushed to the server.&#160; We wound up having to back out of the commits, even though these were on a different logical branch, simply because our build server got confused about these extra commits that were marked with the wrong branch name.

Perhaps Hg branches aren’t broken and this design is intentional.&#160; But it’s annoying and less powerful and flexible than Git’s more simple model, of just a pointer to a commit.

> _Side note for the Git folks – I’ve also wasted 2 hours of my life on Git when my .git folder suddenly went empty – and not from me accidentally deleting anything.&#160; Lost all my dangling topic branches on that one._