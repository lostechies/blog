---
wordpress_id: 131
title: 'Git+SVN: Script To Do “Svn Up” And “Git Commit” With Svn Revision Number'
date: 2010-04-02T20:04:14+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/04/02/git-svn-script-to-do-svn-up-and-git-commit-with-svn-revision-number.aspx
dsq_thread_id:
  - "262068568"
categories:
  - git
  - Source Control
  - Subversion
---
I’ve been using [Git+SVN](http://www.lostechies.com/blogs/derickbailey/archive/2010/02/03/branch-per-feature-how-i-manage-subversion-with-git-branches.aspx) for a while now, and I really like what it does for me. What I don’t like is the constant repetition of the same command to update from svn into my local git branch, over and over and over again. So, I wrote a little batch file to do my svn update and my git commit. I committed it to our repository so that I wouldn’t lose it when branching, merging, etc. and one of my coworkers asked if it was populating any useful info into the git commit message, like the svn revision #. At the time it was only committing with a “svn up” message, but it was easy to add other detail.

Since I run in a bash shell most of the time (the Git Bash shell… MingW32), I decided to take advantage of the bash commands like grep and piping, etc, to get the svn info that I wanted into my commit message. I wanted to get the svn revision number. This can be obtained by running “svn info”:

&#160; <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_498959AF.png" width="997" height="314" />

the “Revision: 30165” line is what I’m looking, so a simple command like “svn info | grep Revision” should do the trick:

&#160; <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_2CA034DA.png" width="997" height="154" />

Then, with a little help from [Tim Ottinger](http://twitter.com/tottinge/statuses/11480532867), I got the command line i needed to insert this info into my git commit message: git commit –m “$(svn info | grep “Revision”*)”

The resulting batch file has these commands in it:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> svn up</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> git add -A</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span> git commit -m "svn up to $(svn info | grep "Revision"*)"</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        And it looks like this when I run it, proving a nice log entry for me:
      </p>
      
      <p>
        <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_27BD811E.png" width="997" height="307" />
      </p>