---
wordpress_id: 618
title: Working with Forks on GitHub or CodePlex
date: 2012-04-02T18:42:58+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/04/02/working-with-forks-on-github-or-codeplex/
dsq_thread_id:
  - "633998413"
categories:
  - git
---
So you want to contribute to a Git project on GitHub or CodePlex. The first thing you always do here is create a fork, which is easy enough:

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2012/04/image_thumb.png" width="250" height="48" />](https://lostechies.com/content/jimmybogard/uploads/2012/04/image.png)

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2012/04/image_thumb1.png" width="605" height="82" />](https://lostechies.com/content/jimmybogard/uploads/2012/04/image1.png)

After you create your fork, you’ll likely then clone that forked repository locally like:

<pre>git clone git@github.com:jbogard/AutoMapper.git</pre>

That’ll create a remote called “origin” that points up to your fork (in this case, on github). Check out the Git book for [more info on remotes](http://progit.org/book/ch2-5.html).

But we’re not quite done. We’ve created a fork, which is its own entire repository, separate from the original “central” repository:

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2012/04/image_thumb2.png" width="464" height="484" />](https://lostechies.com/content/jimmybogard/uploads/2012/04/image2.png)

In this new distributed reality, we need to be able to work with those upstream repositories effectively.

### Making changes

If you want to make changes locally, great! But always make those changes in a branch. What we want to do is still be able to pull in any upstream changes, but isolate any contributions we make to the project. In order to do so, we’ll always create a local AND remote branch for any work we do. Our workflow looks like this:

<pre>git checkout -b MyFeature
**work work work & commit changes locally**
git push origin MyFeature</pre>

The reason we want to isolate our custom work from the master branch is that it makes it much, much easier to integrate and keep up to date with upstream changes. An example in GitHub is:

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2012/04/image_thumb3.png" width="325" height="239" />](https://lostechies.com/content/jimmybogard/uploads/2012/04/image3.png)

I have two branches – the default “master” branch, and one that I’m going to isolate for a pull request. The nice thing about CodePlex and GitHub is that they both allow you to “add” changes in the form of commits to your pull request. By isolating potential pull requests into a separate, dedicated remote branch, we can ensure that we don’t paint ourselves into a corner where we want to pull in upstream changes or work on something else.

Branches – local and remote – isolate work, and both GitHub and CodePlex work well with branches as pull requests.

When you’re done with any upstream changes, and our pull request is either accepted or rejected – kill your local and remote branch:

<pre>git branch -D MyFeature
git push origin :MyFeature</pre>

Once our changes are integrated (if they are), we want to use the upstream repository’s version of our changes.

### Pulling upstream changes

When you create a fork, you’ll also want a way to keep up to date with the upstream repository. The first thing to do will be to add a remote that points to the upstream repository (conventionally named &#8220;upstream&#8221;):

<pre>git remote add upstream git://github.com/AutoMapper/AutoMapper.git</pre>

With that remote added, we want to fetch upstream, merge all local branches with that repository, and push that to our upstream:

<pre>git checkout master
git fetch upstream
git merge upstream/master (for each upstream branch)
git push origin</pre>

This workflow:

  1. Fetches all upstream commits 
      * Merges our local branches (as fast-forward merges) to the upstream&#8217;s repository&#8217;s versions 
          * Synchronizes our fork with upstream changes by pushing our local repository up.</ol> 
        It’s a little weird that we have to work with our local repository to synchronize our fork with the upstream repository, but that’s just because it would be a little hard to try and do that directly in GitHub.
        
        The \*first\* thing you should do after forking a project and cloning that fork locally is add that “upstream” remote. It’s just much, much easier to have it set up early and get into the flow of fetch, merge, push for incorporating upstream changes.
        
        To review, working with forks on GitHub and CodePlex is easy if we do two things:
        
          * Create an “upstream” remote to represent the repository our fork originated from 
              * Always work in named local and remote branches for any commits we do in our fork</ul> 
            For more info, check out [GitHub’s help pages](http://help.github.com/).