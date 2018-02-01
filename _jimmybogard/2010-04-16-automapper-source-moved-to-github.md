---
id: 400
title: AutoMapper source moved to GitHub
date: 2010-04-16T02:13:46+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2010/04/15/automapper-source-moved-to-github.aspx
dsq_thread_id:
  - "265908020"
categories:
  - AutoMapper
---
After putting it through the paces, I’m ready to (finally) announce that the AutoMapper source code has moved to GitHub:

<http://github.com/jbogard/AutoMapper>

I wanted to wait to “officially” move until I had moved the build over, added new features and processed a few pull requests.&#160; For dealing with OSS projects, I really can’t imagine using SVN again, as pull requests and git merges are so much easier than dealing with patch files.&#160; Additionally, the branching model of git made my life much, much easier to deal with support requests and bug reports.&#160; Git simply and easily supports all the workflows I need to provide a good experience to those using my project, from me adding new features to getting support questions answered quickly and easily.

So can do you contribute?&#160; First, check out Jason’s git for Windows developers post:

<http://www.lostechies.com/blogs/jason_meridth/archive/2009/06/01/git-for-windows-developers-git-series-part-1.aspx>

Next, get over to github and create an account:

<http://github.com/>

Finally, you can check out a few great resources on how to use git and contribute on github:

<http://progit.org/>

<http://www.gitready.com/>

<http://help.github.com/>

I really wanted to make sure that the move wasn’t just done to satisfy some personal interest in learning git.&#160; But after spending the past few months with AutoMapper on github, it’s just been a much better OSS experience than I had with SVN, and the move can only benefit the project.

Remember, with git, branching is easy and in fact, encouraged!

### Moving the codebase

Actually moving the codebase on GitHub was very easy.&#160; GitHub supports migration from SVN, including commit history.&#160; GitHub walked me through the process, and all I really needed to do was paste in the SVN url.&#160; GitHub did the rest.

The only other semi-difficult piece was to change the CI build on teamcity.codebetter.com.&#160; Originally, the version number was populated from the SVN revision number.&#160; Since git uses hashes for commits, I had to pick a different method.&#160; Instead, I now use the build number in the version number from the TeamCity build.&#160; All in all, it took all of about 5 minutes to move the source, and around an hour to rework the build script and get a new build going on TeamCity to point to GitHub instead of SVN.

I was quite apprehensive at first about moving, but it was so ridiculously easy, I couldn’t imagine keeping an OSS project on SVN.

As a side note to other OSS project owners, please please PLEASE get off SVN or any other centralized VCS.&#160; It’s not a good model for OSS development.&#160; Distributed VCS is the platform to host on going forward.