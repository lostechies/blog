---
wordpress_id: 44
title: Git and our friction points and beginners mistakes
date: 2010-06-18T14:11:54+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2010/06/18/git-and-our-friction-points-and-beginners-mistakes.aspx
dsq_thread_id:
  - "263908936"
categories:
  - git
  - Workflow
redirect_from: "/blogs/gabrielschenker/archive/2010/06/18/git-and-our-friction-points-and-beginners-mistakes.aspx/"
---
## Introduction

A couple of days ago I posted an [article](http://lostechies.com/blogs/gabrielschenker/archive/2010/06/15/migrating-to-git.aspx) talking about our migration from SVN to Git. During our first handful of days working with Git our team found several friction points hindering our daily work flow and we all did some things really wrong. But com’on after all we are learning, right? 

In this post I want to share some of our findings.

## Where is my blame feature?

Working with SVN and the Visual.SVN plugin for Visual Studio one can right click in any code file and call blame. A really handy feature. How can we do such a thing in with git without having to type a lot? First possibility is to use the git blame command. But this needs a lot of typing if the relevant file is located in a highly nested subfolder.

> <font face="Courier New">git blame /subfolder1/subfolder2/subfolder3/FileIWantToBlame.cs</font>

not very wrist friendly I want to say.

Second way is to use **gitk**. Type **gitk** in the bash shell and right click on the file you want to blame and select “blame parent commit”. But this only works if the file has been modified otherwise it is not available in the list of changed files and thus cannot be accessed.

I wonder whether there is not a easy way to blame directly from within Visual Studio? Any suggestions…?

## Help, I have merge conflicts

When merging or rebasing we might run into merge conflicts that cannot automatically be resolved by git. We can then just call **git mergetool**

>      <font face="Courier New"></p> 
> 
> <p style="margin: 0in 0in 0pt" class="MsoNormal">
>   <span style="font-family: consolas;color: #4f6228"><font size="3"><font color="#000000">$ <b>git mergetool</b> </p> 
>   
>   <p>
>     </font></font></span>
>   </p>
>   
>   <p style="margin: 0in 0in 0pt" class="MsoNormal">
>     <span style="font-family: consolas;color: #4f6228"><font size="3"><font color="#000000">merge tool candidates: tortoisemerge emerge vimdiff </p> 
>     
>     <p>
>       </font></font></span>
>     </p>
>     
>     <p style="margin: 0in 0in 0pt" class="MsoNormal">
>       <span style="font-family: consolas;color: #4f6228"><font size="3"><font color="#000000">Merging the files: build.rb </p> 
>       
>       <p>
>         </font></font></span>
>       </p>
>       
>       <p style="margin: 0in 0in 0pt" class="MsoNormal">
>         <span style="font-family: consolas;color: #4f6228"> </p> 
>         
>         <p>
>           <font color="#000000" size="3">&#160;</font>
>         </p>
>         
>         <p>
>           </span>
>         </p>
>         
>         <p style="margin: 0in 0in 0pt" class="MsoNormal">
>           <span style="font-family: consolas;color: #4f6228"><font size="3"><font color="#000000">Normal merge conflict for &#8216;build.rb&#8217;: </p> 
>           
>           <p>
>             </font></font></span>
>           </p>
>           
>           <p style="margin: 0in 0in 0pt" class="MsoNormal">
>             <span style="font-family: consolas;color: #4f6228"><font size="3"><font color="#000000">&#160; {local}: modified </p> 
>             
>             <p>
>               </font></font></span>
>             </p>
>             
>             <p style="margin: 0in 0in 0pt" class="MsoNormal">
>               <span style="font-family: consolas;color: #4f6228"><font size="3"><font color="#000000">&#160; {remote}: modified </p> 
>               
>               <p>
>                 </font></font></span>
>               </p>
>               
>               <p style="margin: 0in 0in 0pt" class="MsoNormal">
>                 <span style="font-family: consolas;color: #4f6228"><font color="#000000" size="3">Hit return to start merge resolution tool (tortoisemerge):</font></span>
>               </p>
>               
>               <p>
>                 </font>
>               </p></blockquote> 
>               
>               <p>
>                 to manually merge the conflicting file with one of the suggested tools. If we want to permanently define which tool (e.g. tortoisemerge) we want to use we can do this by updating our configuration with
>               </p>
>               
>               <blockquote>
>                 <p>
>                   <strong><font face="Courier New">$ git config &#8211;global merge.tool tortoisemerge</font></strong>
>                 </p>
>               </blockquote>
>               
>               <p>
>                 now each time we type <strong>git mergetool</strong> the Tortoise merge tool is automatically opened.
>               </p>
>               
>               <h2>
>                 Git reflog
>               </h2>
>               
>               <p>
>                 A coworker called me this morning and said to me something like: “Yesterday night before leaving I committed all my changes to my working branch but this morning they are all gone…”. Digging a little bit deeper we found out that my coworker after committing to the local working branch pushed to the backup and as a first thing in the morning pulled from the backup.
>               </p>
>               
>               <p>
>                 Well I said, first of all you should not need to pull from your backup except in case where you lost your local repository due to e.g. a hard disk crash or the like. On the other hand if the backup repository would really be up to date then a pull should not have changed anything, right?
>               </p>
>               
>               <p>
>                 What can we do now? We analyzed the log but the last entry that showed up was about 4 hours earlier than the one that my coworker did before leaving… where did the about 3 other commits go?
>               </p>
>               
>               <p>
>                 After googling around we found out that <strong>git reflog</strong> might help in our situation and indeed this command showed us exactly what happened. We also found our missing commits. Hurray!
>               </p>
>               
>               <p>
>                 Using this command you get something similar to this
>               </p>
>               
>               <p>
>                 <a href="http://lostechies.com/gabrielschenker/files/2011/03/image_0ED5DF98.png"><img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2011/03/image_thumb_40614D2D.png" width="608" height="100" /></a>
>               </p>
>               
>               <p>
>                 Now we can use <strong>git reset</strong> to go back to any desired point in the history (and thus undo “unwanted” changes). In our case I saved the day by using this command
>               </p>
>               
>               <blockquote>
>                 <p>
>                   <font face="Courier New">git reset –hard HEAD@{5}</font>
>                 </p>
>               </blockquote>
>               
>               <p>
>                 and my coworker was happy again….
>               </p>
>               
>               <h2>
>                 Git and changing the database schema
>               </h2>
>               
>               <p>
>                 When using Git as your SCM it is normal to work for quite a while – maybe for a couple of days – in a local branch and without ever pushing the changes to the origin. Usually we only push when a feature is done or a defect is completely resolved.
>               </p>
>               
>               <p>
>                 When implementing new features or user stories most often database schema changes are needed. We have an inhouse database schema and data migration tool that we use for this job. Each developer writes migration scripts as she is changing the schema or the (baseline-) data. Now these scripts have to follow a naming convention such as that they start with a 4-digit number and are sequential (without holes). In a distributed system it is now more difficult to maintain this numbering convention. Furthermore it is more likely that we will also have database schema conflicts.
>               </p>
>               
>               <p>
>                 We do not yet have a good solution for this scenario.
>               </p>
>               
>               <h2>
>                 I’m in the wrong directory baby
>               </h2>
>               
>               <p>
>                 This happened to me once: I was navigating to a sub directory of my local Git repository and didn’t realize that I was still in that sub directory when I did my next merge. Although I had used the <strong>–A</strong> option with <strong>git add</strong> I still had untracked files after the commit.
>               </p>
>               
>               <p>
>                 The problem was that the untracked files were in another branch of my repository in relation to my current location. Lesson learned: Always do your usual git operations in the root of your repository.
>               </p>
>               
>               <h2>
>                 Backing up my local repository
>               </h2>
>               
>               <p>
>                 <span>Since we are going to work locally potentially for days without pushing to the origin (our central repository) we might well loose our work if we have a hard disk crash or our office is flooded. Thus we need some backup strategy. We decided to use backed up network folder to do the job. Each developer has a folder on our internal SAN which he attaches as a network folder (e.g. as a g-drive). Then we use the following command to copy a clone of our local repository to the network drive</span>
>               </p>
>               
>               <blockquote>
>                 <p>
>                   <span><font size="3" face="Courier New">git clone –mirror <em>repoName</em> g:/<em>repoName</em>.git</font></span>
>                 </p>
>               </blockquote>
>               
>               <p>
>                 <span>To make life easy we define an alias for the backup repository</span>
>               </p>
>               
>               <blockquote>
>                 <p>
>                   <span><font size="3"><font face="Courier New">git remote add <strong>backup</strong> g:/<em>repoName</em>.git –mirror</font><font face="Trebuchet MS"> </font></font></span>
>                 </p>
>               </blockquote>
>               
>               <p>
>                 <span>and we can now save our changes at any time by simply typing </span>
>               </p>
>               
>               <blockquote>
>                 <p>
>                   <span><font size="3" face="Courier New">git push backup</font></span>
>                 </p>
>               </blockquote>
>               
>               <p>
>                 <span>in the command shell.</span>
>               </p>
>               
>               <p>
>                 <span>The backups created with the <strong>&#8211;mirror</strong> options do contain <strong>all</strong> branches and their commits in the repo. We can do a <strong>git push backup</strong> and this will mirror all changes to all branches regardless of our current branch.</span>
>               </p>