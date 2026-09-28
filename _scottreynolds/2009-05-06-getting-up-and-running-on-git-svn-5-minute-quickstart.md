---
wordpress_id: 4039
title: Getting up and running on git-svn (5 minute quickstart)
date: 2009-05-06T01:23:17+00:00
author: Scott Reynolds
layout: post
wordpress_guid: /blogs/scottcreynolds/archive/2009/05/05/getting-up-and-running-on-git-svn-5-minute-quickstart.aspx
categories:
  - git
  - svn
redirect_from: "/blogs/scottcreynolds/archive/2009/05/05/getting-up-and-running-on-git-svn-5-minute-quickstart.aspx/"
---
[Git](http://git-scm.com/) seems to be all the rage these days, and, while I was quite reluctant at first, I am here to tell you that I definitely see what all the fuss is about.

As a bit of intro, these are just a few of the reasons I am loving git:

  * It&#8217;s FAST. Basically 100% local operation, optimized file compares, it&#8217;s just plain fast.
  * Cheap local branching. Branches are easy to create, and even easier to merge or throw away.
  * git-stash. The stash is awesome. It&#8217;s basically a local shelf where you can store some changes temporarily, automatically rolling back the working copy to the last commit, and then reapply what&#8217;s in the stash at any time. It&#8217;s not something I use every day, but it&#8217;s cool.
  * Truly distributed. Star-schema commit structure supported but not required. History is local, operations are local, and with merging being so easy, working disconnected has never been easier.
  * git actually watches your file store. So if you rename/add/modify/delete/move files, it knows, and tracks. No need for IDE integration to solve this headache, and no forgetting to add that new file to svn before breaking the build.

Ok, that&#8217;s my short list about how I learned to stop worrying and love git. Now I&#8217;ll talk about something that should be of help to a lot of you out there who, like me, already have your projects under svn and want to get more comfortable with git before switching your whole organization to it en masse.

The good news is during your learning/transition time, you can keep your team on svn and use git with the git-svn bridge. Git-svn gives you local git operations with the ability to interact with the master svn repository, merging commit history for you and being almost completely transparent to the rest of the team still using svn.

Without further ado, I present the getting up and running guide to git-svn.

First, clone your svn repo locally (this is the same as svn checkout) with the command: _git svn clone -s http://repourl/trunk_. This gives you a local git repo with a master branch that has the svn trunk in it. The -s param is telling git that the standard trunk/branches/tags convention is followed. 

Yeah, that&#8217;s it for setup. Couldn&#8217;t be easier. May take some time so sit back and relax, but it&#8217;s still WAY faster than a fresh checkout with Tortoise, I guarantee. 

Okay, now that we are set up, on to day to day operations. You do work. You commit locally with _git commit -m &#8220;commit message&#8221;_. You add new files to git with _git add [file]_ or to add all _git add ._ (period). You do this as often as you like. One of the nicer things about git is that it supports a tight iterative workflow by allowing you these local &#8220;micro-commits&#8221; without the hassle of integrating each commit.

When you&#8217;re ready to get latest from svn you do _git svn fetch_ which will get the current trunk from the server, and then _git svn rebase_ to merge your branch and the latest. You can also do a _git merge_ but I have read that it can cause history problems, and that _git svn rebase_ is the way to go. When you are ready to push your local changes to the central svn repo, you hit _git svn dcommit_ and you&#8217;re done.

Recapping, it&#8217;s:

  1. create local git repo: _git svn clone -s http://svnrepo_ 
  2. get latest from svn: _git svn fetch_ then _git svn rebase_
  3. make local changes: _git add_ and _git commit -m &#8220;message&#8221;_
  4. push to svn: _git svn dcommit_ 

repeating steps 2-4 as necessary. 

That&#8217;s it. Easy as pie.

Many thanks to the community, and especially [Aaron Jensen](http://codebetter.com/blogs/aaron.jensen/archive/2009/03/12/hosting-your-oss-project-on-github.aspx), the .net world&#8217;s chief git evangelist, for all the help they&#8217;ve given me with git.

For more great git resources, check out [GitCasts](http://gitcasts.com) and [Gitready](http://gitready.com), as well as Aaron&#8217;s blog post linked above and the links contained therein.

<div>
  Technorati tags: <a rel="tag" href="http://technorati.com/tags/git">git</a><a rel="tag" href="http://technorati.com/tags/source%20control">source control</a><a rel="tag" href="http://technorati.com/tags/subversion">subversion</a><a rel="tag" href="http://technorati.com/tags/svn">svn</a>
</div>