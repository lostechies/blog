---
wordpress_id: 205
title: Using Git subtrees to split a repository
date: 2014-04-04T20:27:48+00:00
author: John Teague
layout: post
wordpress_guid: http://lostechies.com/johnteague/?p=205
dsq_thread_id:
  - "2586860596"
categories:
  - Uncategorized
---
We are in a position where we needed to create a new back-end server for an application. The current application is on a MEAN stack (Mongodb, Expressjs, Angularjs, Node.js), but a new client wants the backend to be deployed onto a JBoss server.  This created a situation where we needed a completely different backend, but the front-end was shared between them.  The approach we opted for was using git subtrees to split the ui code into its own repository and shared between the nodejs repo and the Java repo.  We did this by using the subtree features in git.

To be clear, I would only use this for very specific situations like this.  If possible, keeping things simple in a single repository is usually best.  But if you&#8217;re in the same situation, hopefully this will be helpful for you.

## Splitting the Original Repository

The subtree commands effectively take a folder and split to another repository.  Everything you want in the subtree repo will need to be in the same folder. For the sake of this example, let&#8217;s assume you have a /lib folder that you want to extract to a separate repo.

Create a new folder and initialize a bare git repo:

<pre>mkdir lib-repo
cd lib-repo
git init --bare</pre>

Create a remote repository in github or wherever for lib project and add that as the origin remote.

From within your parent project folder, use the subtree split command and put the lib folder in a separate branch:

    git subtree split --prefix=lib -b split

Push the contents to the of the split branch to your newly created bare repo using the file path to the repository.

    git push ~/lib-repo split:master

This will push the split branch to your new repo as the master branch

From `lib-repo` push to your origin remote

Now that lib folder lives in it&#8217;s new repository, you need to remove it from the parent repository and add the subtree back, from it&#8217;s new repository:

<pre>git remote add lib &lt;url_to_lib_remote&gt;
git rm -r lib
git add -A
git commit -am "removing lib folder"
git subtree add --prefix=lib lib master</pre>

&nbsp;

## Setting up a new user with the subtree

When a new user wants to work on your repository, they will need to setup the subtree repo manually.  What ends up happening is that the split off folder will live in two repositories:  the existing repo and the one setup as a subtree.  You need to explicitly commit changes to subtree.  This is obviously a mixed blessing.  If you have a repository with a few occasional committers, they can pull the original repository and push as if the subtree didn&#8217;t exist.  Then some one on the core team could occasionally push to the subtree.

If you want set up a core member who pushes to the subtree, clone the repository as normal:

<pre> git clone &lt;core_git_location&gt;</pre>

You will also need to add a second remote repository that points to the rain-ui repository

<pre>git remote add lib <span style="text-decoration: underline;">&lt;lib_git_location&gt;</span></pre>

Once the repository is cloned, you need to remove the lib folder and commit the changes:

<pre>git rm -r lib
<span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">git add -A </span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">git commit -am "removing lib folder and contents"</span></pre>

Now you need to add the lib folder back, but this time using the subtree commands and the rain-ui repo

<pre>git subtree add --prefix=lib lib master</pre>

_Breakdown_: prefix defines the folder, lib is the name of the remote repository for the lib project, master is the branch you are pulling from the lib remote

## Pushing to the lib repository

If all you are doing is working on non-lib related items you are done, continue pushing to the main repository as necessary.  If you have changes in a different repository that is using the lib repo as a subtree and you  want to push changes upstream, use the following command:

<pre>git subtree push --prefix=lib &lt;lib remote name&gt; &lt;branch name&gt;</pre>

<pre>#following the example 
git subtree push --prefix=lib lib master</pre>

## Pulling from the lib repository {#ConfiguringGittoincludeRain-UIsubtree-Pullingfromtherain-uirepository}

If there are changes in the lib repository and you are not working in the main  repository, you would use the corresponding subtree pull command:

<pre>git subtree pull --prefix=lib &lt;lib remote name&gt; &lt;branch name&gt;</pre>

<pre>#following the example 
git subtree pull --prefix=lib lib master</pre>

## References {#ConfiguringGittoincludeRain-UIsubtree-References}

Here is the list of reference I used during the process. When doing additional research on this topic, be aware of a different strategy called subtree merging, which is a different approach.

<a href="https://github.com/apenwarr/git-subtree/blob/master/git-subtree.txt" rel="nofollow">https://github.com/apenwarr/git-subtree/blob/master/git-subtree.txt</a>

<a href="http://blogs.atlassian.com/2013/05/alternatives-to-git-submodule-git-subtree/" rel="nofollow">http://blogs.atlassian.com/2013/05/alternatives-to-git-submodule-git-subtree/</a>

<a href="http://makingsoftware.wordpress.com/2013/02/16/using-git-subtrees-for-repository-separation/" rel="nofollow">http://makingsoftware.wordpress.com/2013/02/16/using-git-subtrees-for-repository-separation/</a>