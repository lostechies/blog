---
wordpress_id: 43
title: Migrating to Git
date: 2010-06-15T13:21:56+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2010/06/15/migrating-to-git.aspx
dsq_thread_id:
  - "263908922"
categories:
  - git
  - Workflow
redirect_from: "/blogs/gabrielschenker/archive/2010/06/15/migrating-to-git.aspx/"
---
This weekend our development team migrated to **Git**. As any other migration this migration introduced some friction at the very beginning. But all in all I think it went rather smooth.

## Disclaimer

This post is mainly thought as a self documentation for our own internal use. As we are in a very early adoption phase we do not consider these findings as final and/or recommendations to you. We are looking forward to tweak one or the other setting in our infrastructure as well as change our workflows if needed. I am looking forward to get some feedback from you and I invite you to share your own experiences by leaving a comment.

## Self-hosting Git

Previous to Git we were using SVN that was hosted on a Windows 2003 Server machine. Access to this central SVN repository was provided via an Apache Web server. After evaluating a couple of options we decided to leverage the existing infrastructure and self-hosting Git on this very same server and access Git using the HTTP protocol. The advantage being that 

  * we do not need to “fumble around” with SSH keys.
  * we already have Apache installed and configured

It turns out that this installation is also speedy enough for our purposes. To e.g. clone a 1.5 GB repository takes less than a minute on our internal network.

On the server we use Git on cygwin. A first attempt with msysgit failed and we were not able to resolve the problem in a timely manner.

## Converting the SVN Repository

Our SVN repository had about 30’000 commits. When we tried to convert this repo to Git directly on the server we had to stop this process after about 20 hours or so. Only after moving the whole SVN repo to a fast workstation with loads of RAM and converting it there we managed to do the job in less than 10 hours.

Now we have our full history transferred to GIT which is great.

## Git on the Client

On each developer workstation we installed msysgit (currently at version 1.7.0.2). You can download it from [here](http://code.google.com/p/msysgit). During the installation we kept all the default settings.

One problem we faced was finding the “correct” the cr/lf setting. The recommended setting with **core.autocrlf** set to true did cause us problems. As an example:

> From a clean master branch we create a story branch and do some changes on it using VS2010. We commit those changes to the story branch and switch back to master. Now git status is telling us that some files have changed. If we analyze those files using e.g. gitk we find that they only differ in a missing end of line character at the end of each file.

As a result we decided to all turn auto cr/lf off with the following command

> <font face="Courier New">git config core.autocrlf <strong>false</strong></font>

This seems to work for us.

## Workflow

The workflow completely changes when migrating from SVN to Git. Based on various posts of [Jason Meridth](http://www.lostechies.com/blogs/jason_meridth/default.aspx) and also his [presentation](http://www.lostechies.com/blogs/jason_meridth/archive/2010/05/24/my-quot-git-branching-and-workflows-quot-presentation-at-austin-code-camp-2010.aspx) at Code Camp Austin 2010 as well as on the various posts of [Derrick Bailey](http://www.lostechies.com/blogs/derickbailey/default.aspx) we came up with the following workflow for our team.

  1. To start working with a git repository open a bash shell in the directory where you want to clone the repo to (in **Explorer** right click on the folder and select “Git Bash here”) 
    <font face="Courier New">git clone </font><font face="Courier New"><a href="http://yourname@servername:56789/git/projects/te6.git">http://yourname@servername:56789/git/projects/te6.git</a> targetdir</font> 
    
    put your own login name at the place of “**yourname**”,&#160; and choose your own target directory name at the place of “**targetdir**”. Also use the correct server name and port where the Apache Webserver is listening. </li> 
    
      * change into your target directory 
        <font face="Courier New">git status</font> 
        
        should now tell you that your repo is clean… </li> 
        
          * create a branch and checkout to that branch. Name the branch like the story or defect you are working on e.g. story2054 
            <font face="Courier New">git branch story2054 <br />git checkout story2054</font> 
            
            or shorter with only one command 
            
            <font face="Courier New">git checkout –b story2054</font> </li> 
            
              * start working on the code (e.g. in Visual Studio)
              * commit your changes into the (local) story branch 
                <font face="Courier New">git add –A <br />git commit –m “… some commit message …”</font> </li> 
                
                  * continue working…(repeat steps 4 and 5) until you’re done and your code is stable and can be published…
                  * when ready to push your changes switch to your master branch 
                    <font face="Courier New">git checkout master</font> </li> 
                    
                      * and update your local master branch with the latest changes from the server 
                        <font face="Courier New">git pull origin master:master</font>&#160;&#160;&#160;&#160;&#160;&#160;&#160; (or shorter:&#160;&#160; <font face="Courier New">git pull</font>) </li> 
                        
                          * switch to the story branch again and rebase the story branch on top of the newest version of master 
                            <font face="Courier New">git checkout story2054 <br />git rebase master <br /></font></li> 
                            
                              * merge your story branch into your local master 
                                <font face="Courier New">git checkout master <br />git merge story2054 <br /></font></li> 
                                
                                  * push changes in your local master to the server 
                                    <font face="Courier New">git push <br /></font></li> 
                                    
                                      * delete your story branch (since you’re done!!!) 
                                        <font face="Courier New">git branch -d story2054 <br /></font></li> </ol> 
                                        
                                        ## Backup our daily work
                                        
                                        When working with a distributed SCM system like Git developers only push features or fix defects to the origin when they are complete. Thus it can happen that a developer works and commits his changes only locally for days. But what happens in case of e.g. a hard disk crash on his machine? The work of several days would be lost.
                                        
                                        We came up with the following solution: each developer receives space on our internal SAN in the form of a network folder. He then maps his g-drive to this personal git network folder.
                                        
                                          1. Switch to the parent folder of the local git repository 
                                            <font face="Courier New">cd ..</font> </li> 
                                            
                                              * clone the local repository to the network folder using the –mirror switch 
                                                <font face="Courier New">git clone –mirror te6 g:/te6Backup.git</font> 
                                                
                                                this creates an empty (bare) repository in the target network folder and then clones the local repository into it. </li> 
                                                
                                                  * Go back into the local git repository 
                                                    <font face="Courier New">cd te6 <br /></font></li> 
                                                    
                                                      * Add the repository on the backup network folder as a remote (for easier handling) 
                                                        <font face="Courier New">git remote add backup g:/te6Backup.git –mirror</font> </li> 
                                                        
                                                          * continue working… and at the end of the day (or more often if you wish) push your changes to the backup 
                                                            <font face="Courier New">git push backup</font></li> </ol> 
                                                            
                                                            ## What to do if
                                                            
                                                            Here I give some possible answers to questions that surfaced in our team during usage
                                                            
                                                            **Problem**: I want to switch braches without first committing my changes
                                                            
                                                            **Solution**: Use the **stash** command
                                                            
                                                            <div>
                                                              <div>
                                                                <pre><span style="color: #606060">   1:</span> git checkout story2054</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   2:</span> <span style="color: #008000">//... do some changes</span></pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   3:</span> git stash</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   4:</span> git checkout master</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   5:</span> <span style="color: #008000">//... do whatever you want to do</span></pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   6:</span> <span style="color: #008000">//... and finally go back to the story branch</span></pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   7:</span> git checkout story2054</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   8:</span> git stash pop</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF--></div> </div> 
                                                                  
                                                                  <p>
                                                                    The stash command saves the changes since the last commit and then removes it from the current branch. Later on these changes can be re-applied to the branch by using <font size="3" face="Courier New">git stash <strong>pop</strong></font>.
                                                                  </p>
                                                                  
                                                                  <p>
                                                                    <strong>Problem</strong>: I did some changes (did not yet commit them though) and then realized that I am in the wrong branch
                                                                  </p>
                                                                  
                                                                  <p>
                                                                    <strong>Solution</strong>: Use the <strong>stash</strong> command
                                                                  </p>
                                                                  
                                                                  <div>
                                                                    <div>
                                                                      <pre><span style="color: #606060">   1:</span> <span style="color: #008000">//... forgot to switch (e.g. from master) to the story branch</span></pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">   2:</span> <span style="color: #008000">//</span></pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">   3:</span> <span style="color: #008000">//... do some changes ... and realize I'm in the wrong branch</span></pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">   4:</span> git stash</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">   5:</span> git checkout story2054</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">   6:</span> git stash pop</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF--></div> </div> 
                                                                        
                                                                        <p>
                                                                          That is: first save the changes you did in the wrong branch. Switch to the correct branch and then apply the saved changes to the current/correct branch.
                                                                        </p>
                                                                        
                                                                        <h2>
                                                                          Helpful References
                                                                        </h2>
                                                                        
                                                                        <p>
                                                                          The superb free eBook <a href="http://progit.org/book/">http://progit.org/book/</a>
                                                                        </p>
                                                                        
                                                                        <p>
                                                                          <b>Git cheat sheet</b> of <a href="http://refcardz.dzone.com/">DZone Refcardz</a>
                                                                        </p>