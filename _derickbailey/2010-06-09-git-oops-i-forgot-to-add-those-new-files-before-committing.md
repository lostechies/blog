---
wordpress_id: 168
title: 'Git: Oops. I Forgot To Add Those New Files Before Committing'
date: 2010-06-09T21:05:43+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/06/09/git-oops-i-forgot-to-add-those-new-files-before-committing.aspx
dsq_thread_id:
  - "263025747"
categories:
  - Command Line
  - git
  - Source Control
redirect_from: "/blogs/derickbailey/archive/2010/06/09/git-oops-i-forgot-to-add-those-new-files-before-committing.aspx/"
---
I do this pretty regularly… working away, adding files, finish something up and commit. Only after I commit do I realize that I forgot to add the new files to git. 

 <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_7D3FA709.png" width="702" height="547" />

This always frustrated me with subversion because it meant I would have to make yet another commit and put in some silly commit message like “forgot to add these files to the previous commit” and I would often repeat the same commit message as the previous commit along with the note about forgotten files. Anyone that needed to merge my changes anywhere would have to some how know that they need to read the commit messages and figure out that this second commit was supposed to be part of the first commit, so they have to bring it along for the merge.

&#160;

### Git Commit &#8211;amend To The Rescue!

With git, you can solve this problem easily without having to create another commit in the repository and without having to re-type any of your commit messages. Stage the file that you forgot then when you do your commit, provide the “&#8211;amend” and “-C” options. 

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> git commit --amend –C HEAD</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        The &#8211;amend option tells git that you want to add these changes to the previous commit… that you want to amend the previous commit with these changes.
      </p>
      
      <p>
        The –C option (<a href="http://www.kernel.org/pub/software/scm/git/docs/git-commit.html">or –c option</a>… slightly different semantics, but generally the same) requires you to specify what previous commit’s message you want to reuse. If you don’t provide the –C or –c option, your commit message editor will come up and will contain the commit message from the HEAD commit allowing you to modify the message if you want. Alternatively, you can still provide a –m “message” and this new message will be used.
      </p>
      
      <p>
        <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_4277FE33.png" width="702" height="108" />
      </p>
    </p>
    
    <p>
      and you can see in gitk that there is only one commit with that message, but the menu.html file that I previously forgot is there
    </p>
    
    <p>
      <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_420BCB3E.png" width="667" height="571" />
    </p>
    
    <p>
      Note that &#8211;amend will change the SHA1 ID of the commit… you can see in the original screen shot at the top that the commit was ID 8bbad12 and in the second screenshot and the gitk screen shot, the ID is now 35af25e. If you need to preserve the SHA ID of the previous commit, this is probably not the best option for you. But if you don’t need to preserve it, this can save your coworkers the headache of having to look through a bunch of “forgot to add the files” commits.
    </p>