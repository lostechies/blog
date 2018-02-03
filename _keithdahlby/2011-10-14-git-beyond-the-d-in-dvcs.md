---
wordpress_id: 83
title: Git Beyond the D in DVCS
date: 2011-10-14T06:23:33+00:00
author: Keith Dahlby
layout: post
wordpress_guid: http://lostechies.com/keithdahlby/?p=83
dsq_thread_id:
  - "442889936"
categories:
  - git
---
Jimmy&#8217;s [post](http://lostechies.com/jimmybogard/2011/10/14/the-d-in-dvcs/ "The D in DVCS") is a nice reminder of the advantages of a **distributed** version control system. But having ramped up on Git primarily through [git-svn](http://solutionizing.net/2010/11/26/git-svn-aliases-git-up-and-git-dci/ "Better git-svn Through Aliases"), I thought it would be worth enumerating some of the advantages I&#8217;ve found just in my local workflow:

## 1. Local Branching

More than anything, cheap local branches have changed how I work. I don&#8217;t know any developers that have the luxury of only working on one thing at a time. Not only do local branches provide the perfect mechanism to compartmentalize work on different features (or just ideas you&#8217;d like to try), but Git&#8217;s branching mechanism also works great for trying different approaches to the same problem. It&#8217;s trivial to reset a branch back a few commits if an idea doesn&#8217;t work out, or create a new branch from a few commits ago to see if there&#8217;s a better way.

The other advantage of local branches is that they&#8217;re not public unless you want them to be. Not only are centralized branches slower to work with and commit to, the ceremony required to set them (if you have permission at all) attaches a feeling of permanence—I&#8217;m less likely to commit something that&#8217;s not necessarily finished, but may still be useful. I don&#8217;t have these reservations with Git—my main repository at work has maybe 20 branches of refactorings, spikes and other works in progress that I&#8217;m free to revisit as time allows without feeling self-conscious about their current lack of polish.

## 2. Smarter Merging

Because of Git&#8217;s focus on file content rather than file location, it&#8217;s much better at resolving merge conflicts for you, especially across renames. That&#8217;s not to say you&#8217;ll never get conflicts, but they&#8217;re typically real conflicts—files deleted in one branch and modified in another, overlapping Visual Studio project file changes, etc. And for those you can hook up a 3-way merge tool like [Beyond Compare](http://www.scootersoftware.com/ "Beyond Compare") or [P4Merge](http://www.perforce.com/product/components/perforce_visual_merge_and_diff_tools "P4Merge") to make quick work of them.

## 3. Pause and Resume

So your boss comes in and says something to the effect of &#8220;stop everything you&#8217;re doing and make this change for the CEO.&#8221; What do you do? In SVN you might create a patch file of your work in progress and revert. In TFS you might shelve your changes up to the server. In Git you have a two options that are built right in:

  1. `git stash`, which pushes the changes in your index and working directory onto a local stack of stashes from which you can pop at any time. Your typical workflow would look something like this: 
    <pre>$ git stash save "I love interruptions!"
$ git checkout master -b pti
# ... save the day ...
$ git checkout my-feature
$ git stash pop</pre>
    
    The disadvantage of stashes is that they&#8217;re not explicitly tied to the branch where the work happened. The longer it takes to get back to what you were working on, the higher the chance you&#8217;ll forget you had some work stashed.</li> 
    
      * Stage all your changes and make a temporary commit that you&#8217;ll later revert: 
        <pre>$ git add -A && git commit -m "I love interruptions!"
$ git checkout master -b pti
# ... save the day ...
$ git checkout my-feature
$ git reset HEAD~</pre>
        
        The kicker is the final command, which moves the `my-feature` branch pointer back one (to `HEAD`&#8216;s parent) but leaves the working directory unchanged—keeping your old work in progress. The advantage of this approach is that the temporary commit lives with the branch where the changes belong.</li> </ol> 
        
        It doesn&#8217;t take long for both of these operations to become second-nature, greatly decreasing the impact of these interruptions.
        
        ## 4. Rewriting History
        
        Pretending a temporary commit never happened is just one example of rewriting history, which becomes a fundamental operation for an intermediate/advanced Git user. But first, our cardinal rule:
        
        <p style="padding-left: 30px;">
          <strong>Once a commit is pushed, it&#8217;s permanent.</strong>
        </p>
        
        History that has been shared with others is off-limits for rewriting unless you have explicitly communicated that history may be rewritten. For example, I routinely overwrite branches I push based on pull request feedback, but once something hits [posh-git](https://github.com/dahlbyk/posh-git)&#8216;s master branch it&#8217;s there for good.
        
        So with that out of the way, I present my corollary to the cardinal rule:
        
        <p style="padding-left: 30px;">
          <strong>Until you push, pretend you&#8217;re perfect.</strong>
        </p>
        
        In the simplest case, this might simply mean using `git commit --amend` to fix a typo in the last commit&#8217;s message, or include changes to a file that you forgot to save. For more complex needs, like pretending you wrote your tests _before_ the implementation, check out the amazing [interactive rebase](http://book.git-scm.com/4_interactive_rebasing.html).
        
        ## 5. The Staging Area
        
        Some people view Git&#8217;s staging area as an annoyance—an extra step between code and commit. I simply see it as your standard commit dialog with all the boxes unchecked by default. Checking all the boxes is as simple as `git add -A`, which I alias as `git aa` (`git config --global alias.aa "add -A"`). Or you can use `git commit -a` to stage all changes before commiting (though this won&#8217;t pick up additions or deletions).
        
        The real power, though, comes from the ability to stage (`git add --patch`) and unstage (`git reset --patch`) parts of your changes before commiting. You can even use `git checkout --patch` to revert some changes in your working directory without affecting others, or even to pull in partial changes from another commit altogether.
        
        I use this feature on an almost daily basis to separate cosmetic changes from refactoring from new feature work, without having to undo some changes so that I can commit the others. The result is more smaller, atomic commits that separate inert changes from those that actually change behavior.
        
        ## Tip of the Iceberg
        
        Ultimately these are just a few of the things that have convinced me Git is worth the learning curve, worth the cost to migrate, worth the cost to retrain your staff; and this doesn&#8217;t even touch on the advantages and flexibility of Git&#8217;s distributed nature. I just hope to pique your interest enough that you give it a try for yourself.
        
        And if you&#8217;re already using Git, how does this compare with your list of must-have features?