---
id: 4222
title: 'Review: Instant Mercurial Distributed SCM Essentials How-to'
date: 2013-07-02T00:58:35+00:00
author: Keith Dahlby
layout: post
guid: http://lostechies.com/keithdahlby/?p=133
dsq_thread_id:
  - "1457425623"
categories:
  - Book Review
  - Mercurial
---
I was recently offered a review copy of [Instant Mercurial Distributed SCM Essentials How-to](http://www.packtpub.com/mercurial-distributed-scm-essentials-how-to/book), presumably because I&#8217;m vocal about Mercurial being my backup DVCS of choice. Or something. So I worked my way through its 51 pages looking to fill in some gaps in my knowledge of Mercurial.

### The Good

The book is arranged as a series of ten recipes along the natural path through learning a DVCS: installation, local workflow, remote workflow/collaboration, and some extras. The book also includes recipes on setting up mercurial-server, both using a file share and using SSH, and an introduction to Continuous Integration.

Though I was already familiar with DVCS concepts and Mercurial&#8217;s implementation, I did learn a few things:

  * Mercurial&#8217;s [templates](http://hgbook.red-bean.com/read/customizing-the-output-of-mercurial.html) seem more complete and easier to read/use than Git&#8217;s pretty format codes
  * Similar to PowerShell&#8217;s handling of arguments, Mercurial will execute commands as long as you type enough characters for it to figure out what you mean (`st => status`, `out => outgoing`, `in => incoming`, etc). This works for aliases, too.
  * Mercurial&#8217;s counterpart to a Git `--bare` repository is created with the `--no-update` flag
  * I knew Mercurial&#8217;s branches are heavier than Git&#8217;s, but I didn&#8217;t realize you actually had to close a branch (with `hg commit --close-branch`) after its changes have been merged.
  * TortoiseHg has a `shelve` command that&#8217;s similar to `git stash`. It turns out there&#8217;s also a shelve extension apart from TortoiseHg, which the book does not mention.
  * Mercurial Queues are ridiculous. More on that later.
  * The [Crecord extension](http://mercurial.selenic.com/wiki/CrecordExtension) allows you to mimic `git add --patch`.
  
    > It is very similar to the use of Git&#8217;s staging area…except that you have the choice to use it (by typing `hg crecord`) or to commit everything (by typing `hg commit`).
    
    N.B. The more I use it and teach it, the more I appreciate Git&#8217;s staging area. Crecord captures only a portion of its capabilities.</li> </ul> 
    
    ### The Bad
    
    The overall structure of the book could work well, but I was disappointed by the execution within some important recipes. Each recipe is broken into sections: _Getting Ready_, _How to do it_, _How it works_, and _There&#8217;s more_. The recipe itself is a numbered list within _How to do it_, which is where things get confusing: new concepts are often introduced partway through a list, without fanfare or sufficient detail.
    
    For example, branches were introduced in bullet #7 (of 9) in the &#8220;Branching, merging and managing conflicts&#8221; recipe. Then _There&#8217;s more_ concludes the chapter with a two-sentence paragraph introducing Bookmarks, which &#8220;offer another way of diverging to postpone the problems of merges and conflicts,&#8221; and giving this guidance on how one should handle divergent lines of work:
    
    > To summarize, for topical temporary diversion, it is a good practice to use only clones. It helps, for switching back and forth between several lines of development in parallel, to use bookmarks; and if you need a long-term diversion, use branches.
    
    Maybe this is enough of the Essentials for someone new to Mercurial, but I was expecting more.
    
    My other frustration was the book&#8217;s regular use of new commands and options without any introduction or explanation. I knew enough to guess at most of them, but I found the started purpose of a particular example was often lost in my need to process the unexpected new information at the same time.
    
    ### The Ugly
    
    The _Using additional commands and extensions_ recipe includes a discussion of [Mercurial Queues](http://mercurial.selenic.com/wiki/MqExtension). I was looking forward to the &#8220;Essential&#8221; introduction to MQ, because the [GitConcepts section of the Mercurial documentation](http://mercurial.selenic.com/wiki/GitConcepts#Git.27s_staging_area "GitConcepts: Git's staging area") says:
    
    <p style="padding-left: 30px;">
      If you need the index, you can gain its behavior (with many additional options) <a href="http://stevelosh.com/blog/2010/08/a-git-users-guide-to-mercurial-queues">with mercurial queues</a> (<a href="http://mercurial.selenic.com/wiki/MQ">MQ</a>).
    </p>
    
    I rather like the index, especially now that I know [how `reset` works](http://git-scm.com/2011/07/11/reset.html "Git Reset Demystified") (and that it supports `--patch`!), so I was curious what MQ brings to the table. In a word: confusion.
    
      * `hg qinit` creates a file structure under `.hg/patches` with its own Mercurial repository, so patches can themselves be versioned (which seems really weird to me).
      * `hg qnew` creates a new patch, which seems like a &#8220;future commit&#8221; of sorts.
      * `hg qrefresh` applies current changes to the latest patch. 
          * An `hg status` here shows no changes, as expected.
          * An `hg log -r tip` here shows a new changeset, with a tag for the patch plus `qbase`, `qtip` and `tip`. So it seems like this is kind of a commit, it&#8217;s just not referenced by any branches/bookmarks. Apparently `tip` is always the most recent changeset, even if it&#8217;s not a real commit? I&#8217;m not convinced this is a useful distinction.
      * `hg qcommit` creates a commit within the `.hg/patches` repository to save the patch changes.
      * `hq qapplied` lists patches applied since the last real commit.
      * `hg qpop`, treating patches as a stack, removes one or more patches from the working directory.
      * `hg qpush` restores one or more patches to the working directory &#8211; it&#8217;s unclear what happens if you fail to `qpush` after you `qpop`.
      * The book stops there, but apparently there&#8217;s also a `qfinish` to convert a patch into a permanent changeset.
    
    Eight new commands with no apparent relationship to existing Hg concepts. I&#8217;ll give MQ proponents the benefit of the doubt that it can be productive, but I&#8217;m not sure how it would fit into a complete workflow with branches or bookmarks. From what I know so far, it seems like a lot of effort to make mutable commits that aren&#8217;t commits, when it would be much easier to just accept that a commit doesn&#8217;t need to be immutable until future work depends on it.
    
    ### Conclusion
    
    Ultimately, this isn&#8217;t really my kind of book — as a professional, I like to know my tools beyond just the &#8220;Essentials.&#8221; If you&#8217;re looking for a bare-minimum introduction, with a little extra, this isn&#8217;t a bad place to start, though I would be surprised if there weren&#8217;t free material online of similar quality.