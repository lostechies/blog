---
wordpress_id: 4217
title: 'Better git-svn Through Aliases: git up &#038; git dci'
date: 2010-11-29T14:00:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2010/11/29/git_2D00_svn_2D00_aliases_2D00_git_2D00_up_2D00_and_2D00_git_2D00_dci.aspx
dsq_thread_id:
  - "262699820"
categories:
  - git
  - git-svn
redirect_from: "/blogs/dahlbyk/archive/2010/11/29/git_2D00_svn_2D00_aliases_2D00_git_2D00_up_2D00_and_2D00_git_2D00_dci.aspx/"
---
I&#8217;ve been using git-svn for almost a year now, and have settled on a
  
low-friction workflow that has been working really well. First, a few
  
notes about how I work with Git and Subversion&#8230;

  1. For the most part, we avoid Subversion branching and merging, so I optimize for working in trunk.
  2. Forget about using Git `push` and `pull` for
  
    collaborating with others. git-svn stores extra metadata that isn&#8217;t
  
    pushed with the rest of the repository, so git-svn operations will fail
  
    on cloned repos. Furthermore, each repository&#8217;s git-svn commits are
  
    unique, so pulling from another repository will fetch its parallel
  
    history (if you have to do this, `git rebase -i` can help
  
    filter out the overlapping commits). That said, I do use push/pull to
  
    collaborate with myself across machines, though I always operate against
   
    Subversion from one machine.
  3. All substantial work is done in local topic branches, with master
  
    reserved exclusively for tracking what&#8217;s in (or to be immediately
  
    committed to) Subversion.

## git up

First up is the alias that stands in for `svn update`, to make sure I&#8217;m always working from the latest changes:

> <del><code>!git svn fetch && git push .&lt;br />
remotes/trunk:master && git push -f origin master:master&lt;br />
&& git rebase master</code></del>

**Update Nov. 30, 2010:** After reports that people were having issues calling `git up` from master, I&#8217;ve modified the alias slightly:

> `!git svn fetch && git svn rebase -l && git push . remotes/trunk:master && git push -f origin master`

If this is your first alias, the command to set the alias would be:

> `git config alias.up "!git svn fetch && git<br />
svn rebase -l && git push . remotes/trunk:master && git<br />
push -f origin master"`

Step by step, this alias does the following:

  1. Fetch the latest from Subversion. I use `svn fetch` instead of `svn rebase` because the former also fetches from Subversion branches; we&#8217;ll do our own rebase later.
  2. Rebase my current branch against its Subversion parent. `-l` skips a remote fetch, since we just did one.
  3. Update my local master branch to match Subversion&#8217;s trunk. If you didn&#8217;t use `--std-layout`, you might need to replace _remotes/trunk_ with _remotes/git-svn_ or whatever your git-svn ref is.
  4. Push master to my origin remote, which serves as a backup and allows
   
    me to collaborate with myself between machines (if you don&#8217;t have a Git
   
    remote, feel free to omit this).
  5. <del>Rebase my current branch against master (and therefore Subversion).</del>

The key is item #2: automating the synchronization of master and
  
Subversion means I never have to think about it again. I can either
  
rebase a topic branch against master to get reasonably fresh commits, or
   
use `git up` to grab the latest (mostly when preparing to
  
commit into Subversion). Without this alias, I tended to waste a fair
  
amount of time switching back to master periodically just to make sure
  
it&#8217;s up-to-date enough.

## When do I git up?

You can use `git up` pretty much any time you want &mdash; on
  
master, on a topic branch or even with a detached HEAD &mdash; as long as your
   
working copy and index are clean. If you have work in progress but need
   
Subversion&#8217;s latest, you can either `git stash` or make a temporary commit and then `git reset HEAD^`
   
after the update. I used to favor the former, but am starting to prefer
   
the latter because I tend to be undisciplined about cleaning up stashes
   
that `git stash pop` didn&#8217;t delete due to merge conflicts.

## git dci

Satisfied with this abstraction for pulling changes from Subversion, I
   
then applied the same logic to committing into Subversion:

> `!git svn dcommit && git push . remotes/trunk:master && git push -f origin master && git checkout master`

The dci alias (short for dcommit) does the following:

  1. Commit my local changes into Subversion, generating a Subversion
  
    commit for each new Git commit. If a modified file has also changed in
  
    Subversion since your last update, the dcommit will fail &mdash; `git up`, resolve conflicts and try again.
  2. Keep master in sync with Subversion&#8230;
  3. &#8230;and origin.
  4. And finally, switch back to master, which will now reference the
  
    latest git-svn commit. From here I can either delete my finished topic
  
    branch, or rebase against master (`git rebase master <em>branch-name</em>`) and get back to work.

Again, by automating most of what I was already doing I can be
  
confident that I will always come out of a dcommit in a well-known,
  
consistent state from which I can proceed without extra thought.

## When do I dci?

`git dci` should be used when you want to commit HEAD and
  
its uncommitted ancestors into Subversion. In my experience, this
  
usually falls into one of three scenarios:

### 1. Entire Branch

You have a topic branch and want to replay all of its commits into
  
Subversion one by one. In this case, simply checkout the branch and call
   
`git dci`:

[<img class="alignnone size-full" src="http://solutionizing.files.wordpress.com/2010/11/git-dci-simple.png" alt="git dci Entire Branch" height="593" width="720" />](http://solutionizing.files.wordpress.com/2010/11/git-dci-simple.png)

I use this most often, as I prefer granular commits and a linear history.

**Update Dec. 4, 2010:** Donn [pointed out](http://twitter.com/donnfelker/status/10397762684190720 "Twitter / Donn Felker") that I gloss over my use of an `lg` alias, which provides a concise graph of history. The alias is described [here](http://www.jukie.net/bart/blog/pimping-out-git-log "pimping out git log").

### 2. Squashed Branch

The exception to my linear history preference is if the build would
  
break between intermediate commits. For example, I might upgrade a
  
dependency in one commit and then fix the build in the next commit. One
  
could certainly use a squash merge or interactive rebase, but sometimes I
   
prefer to keep the granular history in Git.

So how do we accomplish this with git-svn? Well git-svn essentially
  
treats merge commits as the sum of their parts, relative to the previous
   
Subversion commit &mdash; it squashes for us. To make our single Subversion
  
commit, we&#8217;ll just switch to master and use `git merge --no-ff`:

[<img class="alignnone size-full wp-image-848" src="http://solutionizing.files.wordpress.com/2010/11/git-dci-merge1.png" alt="git merge --no-ff" height="555" width="720" />](http://solutionizing.files.wordpress.com/2010/11/git-dci-merge1.png)

The `--no-ff` flag forces the creation of a merge commit
  
even though we should be able to fast-forward (if we up&#8217;d first, that
  
is). You can make this the default behavior for master by setting
  
branch.master.mergeoptions (I use `--no-ff --no-commit`).

Once we have our merge commit, we again use `git dci` to push all its changes into Subversion:

[<img class="alignnone size-full wp-image-849" src="http://solutionizing.files.wordpress.com/2010/11/git-dci-merge2.png" alt="git dci After Merge" height="536" width="720" />](http://solutionizing.files.wordpress.com/2010/11/git-dci-merge2.png)

Note that the dev2 commits remain untouched by git-svn, and Subversion has the combined changes:

[<img class="alignnone size-full wp-image-850" src="http://solutionizing.files.wordpress.com/2010/11/git-dci-merge3.png" alt="git-svn Merge Commit in Subversion" height="234" width="612" />](http://solutionizing.files.wordpress.com/2010/11/git-dci-merge3.png)

### 3. Detached HEAD

The final scenario is really no different from either #1 or #2, but it&#8217;s worth pointing out that you can use `git dci`
   
from any HEAD, not just on a branch. For example, suppose I have a few
  
refactoring commits that I created as part of feature work which I would
   
like to share with the team now while I finish up the feature. In this
  
case, I can checkout (or merge from) the last of the commits I want to
  
share:

[<img class="alignnone size-full wp-image-845" src="http://solutionizing.files.wordpress.com/2010/11/git-dci-detached1.png" alt="Checkout Detached HEAD" height="365" width="720" />](http://solutionizing.files.wordpress.com/2010/11/git-dci-detached1.png)

And `git dci` from the detached HEAD to save those changes:

[<img class="alignnone size-full wp-image-846" src="http://solutionizing.files.wordpress.com/2010/11/git-dci-detached2.png" alt="git dci from Detached HEAD" height="384" width="720" />](http://solutionizing.files.wordpress.com/2010/11/git-dci-detached2.png)

Note that `git dci` left me on master. Now to continue on
  
dev3, I just rebase against master so Git is aware that the dci&#8217;d
  
commits have been updated with git-svn metadata:

[<img class="alignnone size-full wp-image-847" src="http://solutionizing.files.wordpress.com/2010/11/git-dci-detached3.png" alt="git rebase master dev3" height="175" width="720" />](http://solutionizing.files.wordpress.com/2010/11/git-dci-detached3.png)

If I want to get even more sophisticated, I could cherry-pick then
  
dci individual commits, or I could create a copy of the branch and use
  
interactive rebase to exclude the commits that I don&#8217;t want to dci yet.
  
Just remember to rebase the topic branch against master when you&#8217;re
  
done.

If you have any additional git-svn tips or questions, please let me know.