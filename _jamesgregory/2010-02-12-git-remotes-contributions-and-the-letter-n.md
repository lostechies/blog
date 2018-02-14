---
wordpress_id: 4504
title: 'Git: Remotes, contributions, and the letter N'
date: 2010-02-12T02:23:00+00:00
author: James Gregory
layout: post
wordpress_guid: /blogs/jagregory/archive/2010/02/12/git-remotes-contributions-and-the-letter-n.aspx
dsq_thread_id:
  - "276447131"
categories:
  - git
  - github
redirect_from: "/blogs/jagregory/archive/2010/02/12/git-remotes-contributions-and-the-letter-n.aspx/"
---
Here&#8217;s a few ways to think about Git and it&#8217;s distributed nature.

  * You deal with multiples of repositories, not a single central repository
  * Updates come from a remote repository, and changes are pushed to a remote; none of these repositories have to be the same
  * _Origin_ is the canonical name for the repository you cloned from
  * _Upstream_ is the canonical name for the original project repository you forked from

## General pushing and pulling

<p style="text-align:center">
  <img src="http://lostechies.com/content/jamesgregory/uploads/2011/03.GitRemotes/remote-1.png" />
</p>

Pushing your changes to a remote: `git push remote_name`

<p style="text-align:center">
  <img src="http://lostechies.com/content/jamesgregory/uploads/2011/03.GitRemotes/remote-2.png" />
</p>

Pulling changes from a remote: `git pull remote_name`

Or if you want to rebase:

<pre>git fetch remote_name
git rebase remote_name/branch</pre>

> You can change your `branch.autosetuprebase` to `always`, to make this the default `git pull` behaviour.

That&#8217;s all there is to moving commits around in Git repositories. Any other operations you perform are all combinations of the above.

## Github &mdash; personal repositories

When you&#8217;re dealing directly with Github, on a personal project or as the project owner, your repositories will look like this:

<p style="text-align:center">
  <img src="http://lostechies.com/content/jamesgregory/uploads/2011/03.GitRemotes/remote-3.png" />
</p>

To push and pull changes between your local and your github repositories, just issue the push and pull commands with the origin remote:

<pre>git push origin
git pull origin</pre>

You can set the defaults for these commands too, so the origin isn&#8217;t even necessary in a lot of cases.

## Github &mdash; receiving contributions

As a project owner, you&#8217;ll sometimes have to deal with contributions from other people. Each contributor will have their own github repository, and they&#8217;ll issue you with a pull request.

<p style="text-align:center">
  <img src="http://lostechies.com/content/jamesgregory/uploads/2011/03.GitRemotes/remote-4.png" />
</p>

There&#8217;s no direct link to push between these two repositories; they&#8217;re unmanned. To manage changes from contributors, you need to involve your local repository.

You can think of this as taking the shape of a V.

<p style="text-align:center">
  <img src="http://lostechies.com/content/jamesgregory/uploads/2011/03.GitRemotes/remote-5.png" />
</p>

You need to register their github repository as a remote on your local, pull in their changes, merge them, and push them up to your github. This can be done as follows:

<pre>git remote add contributor contributor_repository.git
git pull contributor branch
git push</pre>

## Github &mdash; providing contributions

Do exactly as you would your own personal project. Local changes, pushed up to your github fork; then issue a pull request. That&#8217;s all there is to it.

## Github &mdash; the big picture

Here&#8217;s how to imagine the whole process, think of it as an N shape.

<p style="text-align:center">
  <img src="http://lostechies.com/content/jamesgregory/uploads/2011/03.GitRemotes/remote-6.png" />
</p>

On the left is the contributor, and the right is the project. Flow goes from bottom left, along the lines to the top right.

  1. Contributor makes a commit in their local repository
  2. Contributor pushes that commit to their github
  3. Contributor issues a pull request to the project 
      * Project lead pulls the contributor&#8217;s change into their local repository
      * Project lead pushes the change up to the project github</ol> 
    That&#8217;s as complicated as it gets.