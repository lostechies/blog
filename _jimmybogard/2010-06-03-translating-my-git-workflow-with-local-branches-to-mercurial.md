---
id: 415
title: Translating my Git workflow with local branches to Mercurial
date: 2010-06-03T02:46:08+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2010/06/02/translating-my-git-workflow-with-local-branches-to-mercurial.aspx
dsq_thread_id:
  - "264716503"
categories:
  - git
  - Mercurial
---
It took me a while to really settle in to a Git workflow I like to use on a daily basis.&#160; It’s a pretty common workflow, and is centered around local topic branches and rebasing.&#160; It’s not actually much different than the workflow I used with SVN, except that I prefer rebase over merge.&#160; My [typical Git workflow](http://www.lostechies.com/blogs/jimmy_bogard/archive/2010/04/30/automapper-git-workflow-dealing-with-bugs-issues.aspx) starts out with:

  * git checkout –b “SomeTopic” 
  * <work work> 
  * git add . 
  * git commit –am “Commit message” 
  * <repeat last 2 steps as necessary> 
  * git checkout master 
  * git pull &#8211;rebase origin master 
  * git checkout SomeTopic 
  * git rebase master 
  * git checkout master 
  * git rebase SomeTopic (or merge, same thing) 
  * git push origin master 
  * git branch –d SomeTopic 

In a nutshell, all work, and I mean ALL WORK, is done in a local branch.&#160; Every time.&#160; This is because I can never predict when other, unrelated work might come up.&#160; I do work in a local branch.&#160; When I want to bring that work back to master (basically, trunk), I first do a pull from origin back to master, rebasing my existing commits.

At this point, I should note that I rarely, rarely ever need to rebase upstream changes.&#160; If I pull work back to master, that means that I’m about to push.&#160; Otherwise, it can just stay in a local topic branch.

Anyway, I make sure that my master reflects the absolute latest upstream changes.&#160; When I’m ready to bring the local branch back in, INSTEAD OF MERGING, I [rebase the branch on to master](http://progit.org/book/ch3-6.html).&#160; All this means in practice is that the branch’s commits are re-played onto the master branch.&#160; Merging instead squashes all the branch’s work in to one single merge commit, which I’d rather avoid.

> Side note – The git “[rebase considered harmful](http://changelog.complete.org/archives/586-rebase-considered-harmful)” article is 3 years old.&#160; A lot of opinions have changed since then, so while its core arguments do apply (never rebase a pushed commit), rebase is a sharp, useful tool that does great things when used right.

Finally, I do a merge/rebase from master to the branch, which really just does a fast-forward merge.&#160; Because the SomeTopic pointer is a descendant of the master pointer, a merge/rebase is really just moving the master pointer up to the SomeTopic pointer.&#160; Once this is done, I push and I’m finished.

Translating this to Hg has been a little more difficult, however.

### Combining Rebase and Bookmarks

Right now, I’m trying to use [Bookmarks](http://mercurial.selenic.com/wiki/BookmarksExtension) and [Rebase](http://mercurial.selenic.com/wiki/RebaseExtension) to achieve this same workflow.&#160; The basic workflow I want is:

  * All work is always isolated from any other work 
  * Pulling latest does not affect isolated work 
  * Isolated work, when rolled back in, has linear history preserved 

I don’t really care _how_ this is accomplished.&#160; So, I’m going from this article on the [different ways of doing branching in Mercurial](http://stevelosh.com/blog/2009/08/a-guide-to-branching-in-mercurial/).

So my first try was using the Hg extensions Rebase and Bookmarks, which have both been included with Mercurial for a while now.&#160; On the surface, Rebase and Bookmarks seem very similar to Git’s rebase and branching model.

Mimicking git, I try:

  * hg bookmark SomeTopic 
  * <work work> 
  * hg commit –Am “Some message” 

Now I want to pull those changes back to master…but wait, there is no master!&#160; I don’t have a pointer to when I first made the branch, and even worse, the “default” branch is now sitting on my SomeTopic branch.

What I’d really like to do is do “hg checkout default”, then do an update, so that “default” always represents the upstream current state.&#160; But “default” has moved!

My next attempt was to create a “master” bookmark right before I created the “SomeTopic” bookmark, so that “master” mimics the Git master branch – that is, it’s merely a named pointer, nothing special.

I now want to do some more, unrelated work, so I:

  * hg update master 
  * hg bookmark SomeOtherTopic 
  * <work work> 
  * hg commit –Am “Some other message” 

At this point, here’s my tree:

[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_7F37A3CC.png" width="394" height="109" />](http://lostechies.com/jimmybogard/files/2011/03/image_7B9988EF.png) 

As we can see here, I have my master bookmark marking where I diverged my bookmarks.&#160; This now more or less matches what I see in Git, with the exception of that “default” branch.

Let’s say that we now want to bring “SomeTopic” back to “master”.&#160; Really, I want to rebase “SomeTopic” on to “master”.&#160; Because “master” is a parent of SomeTopic, this should really just be a fast-forward merge.&#160; The master should just be moved up to SomeTopic.

If there were upstream changes, that would change the story a bit.&#160; Master would move up to those upstream changes, and all changes from where SomeTopic and master diverged would be replayed on top of master.&#160; One thing to note is that Git is very smart about fast-forward merges.&#160; If I rebase SomeTopic on to master, and master is still where it was, nothing would happen.&#160; I could then rebase master on to SomeTopic (or merge), and master would just move up.

In the picture above, I really just want “master” to move up to “SomeTopic”, then I can push “master” up.&#160; So let’s try to do an hg rebase:

  * hg rebase –b SomeTopic –d master 

I want to rebase SomeTopic on top of master.&#160; I get a message “nothing to rebase”.&#160; That’s fine, as I have nothing to do here anyway.&#160; “master” is in the direct ancestry of “SomeTopic”.

The next thing I want to do is move master to SomeTopic, which at this point should just be a fast-forward merge.&#160; But nothing I seem to do will allow me to move “master” up to “SomeTopic”.&#160; I try all of these:

  * hg update master/hg merge –r SomeTopic <- “nothing to merge” 
  * hg rebase –b master –d SomeTopic <- “nothing to rebase” 

Blarg.&#160; Even though I’ve configured my bookmark to automatically move forward, there doesn’t seem to be a way to do this myself.&#160; What I can do is:

  * hg bookmark –d master 
  * hg update SomeTopic 
  * hg bookmark master 
  * hg bookmark –d SomeTopic 

This basically fast-foward merges the master bookmark to SomeTopic, by…deleting it and re-creating it.&#160; If Mercurial supported a fast-forward merge here, that would be GREAT, but it doesn’t, so I have to jump through a bunch of hoops here.&#160; All of which I could batch up in to a “fast-forward” alias, but is still annoying, as Git just handles this automatically.

Anyway, this is now the state of things:

[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_2C4C909B.png" width="393" height="84" />](http://lostechies.com/jimmybogard/files/2011/03/image_5AA61648.png) 

And now I want to push “master” up.&#160; But this will be interesting, I don’t want “SomeOtherTopic” to go out.&#160; So, I use:

  * hg push –b master

Now only the “master” piece got pushed up.&#160; Let’s say we now want to get the SomeOtherTopic back in to the fold, AND, that there were upstream changes.&#160; In this case, we want to update our master to be include new changes, but without affecting “SomeOtherTopic”.&#160; We do this to update our master:

  * hg update master
  * hg pull &#8211;rebase –b default

This makes our local repository tree now:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_648B07B3.png" width="439" height="105" />](http://lostechies.com/jimmybogard/files/2011/03/image_12E48D61.png) 

Exactly what we wanted! The “master” bookmark got moved up, past “SomeOtherTopic”.&#160; Now, we just need to rebase SomeOtherTopic onto master:

  * hg rebase –b SomeOtherTopic –d master

This means I’m replaying the SomeOtherTopic on top of master, resulting in the following tree:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_7CAE720E.png" width="492" height="105" />](http://lostechies.com/jimmybogard/files/2011/03/image_120C2777.png) 

Looking good!&#160; I now just follow the FF-merge-master-to-branch routine:

  * hg update SomeOtherTopic
  * hg bookmark –f master <- basically moves master to current location, better than delete/add
  * hg bookmark –d SomeOtherTopic <- delete the bookmark (the work is integrated now)
  * hg push –b master

Well, that’s it.&#160; It’s not completely like git branching, there are some caveats here and there, as git handles remotes different than Hg.&#160; Git also automatically handles fast-forward merges, but in practice, I don’t think that it’ll be a big deal.

I need to run with this with a team to really make sure it doesn’t corrupt things, but it seems to work so far.