---
wordpress_id: 167
title: 'Git: D’oh! I Meant To Create A New Branch First!'
date: 2010-06-08T14:59:43+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/06/08/git-d-oh-i-meant-to-create-a-new-branch-first.aspx
dsq_thread_id:
  - "262796962"
categories:
  - Branch-Per-Feature
  - Command Line
  - git
  - Source Control
redirect_from: "/blogs/derickbailey/archive/2010/06/08/git-d-oh-i-meant-to-create-a-new-branch-first.aspx/"
---
Yesterday I ran into a situation with git where I was working away on some code, finished what I was doing and committed the changes. Immediately after making the commit, I realized that I was still sitting in my master branch instead and had made the commits there instead of on a topic branch like I meant to. 

 <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_468DFE69.png" width="261" height="63" />

If I were using subversion, at this point I would create a branch from the head of where I committed and then revert the original commits. The subversion history would show that I made the mistake and anyone that pulled changes from the original location would get the commits applied and then rolled back. 

Git makes this situation trivial, and no one will ever have to know that you accidentally made a commit to the wrong branch, first. 🙂

&#160;

### Git Reset To The Rescue!

The first thing you want to do is snap off a new branch, just like you would in subversion. I normally like to use the ‘checkout’ shortcut to create the branch and switch to the branch at the same time:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> git checkout -b mytopicbranch</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        but in this case, I don’t actually want to checkout the branch yet, so I’m just going to create a branch without switching to it:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> git branch mytopicbranch</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              At this point, both mytopicbranch and master are pointing to the same location.
            </p>
            
            <p>
              <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_514B55BE.png" width="361" height="102" />
            </p>
            
            <p>
              What we really want, though, is for master to still be back at “initial commit” and mytopicbranch to contain the two commits that were made after that. To do this, we need to know the sha fingerprint of the commit we want (which we can see in the above image) and we need to use the ‘<a href="http://www.kernel.org/pub/software/scm/git/docs/git-reset.html">git reset</a>’ command. The great thing about reset is that is doesn’t do anything to the contents of the repository like a revert would do. Rather, the reset command just moves the branch pointer (the HEAD of the branch) to the commit that you specify.
            </p>
            
            <p>
              Run this command:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> git reset 2f7efb32 --hard</pre>
                
                <p>
                  <!--CRLF--></div> </div>
                </p></p> 
                
                <p>
                  and you will see git move the HEAD of the master branch to that commit:
                </p>
                
                <p>
                  <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_65D0A53C.png" width="451" height="67" />
                </p>
                
                <p>
                  Now when we look at the repository again, we see master where we want it and we see mytopicbranch where it should be, as well!
                </p>
                
                <p>
                  <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_4C68A202.png" width="257" height="73" />
                </p>
                
                <p>
                  No changes were made to the content of the repository. We only moved the HEAD pointer for the master branch around and made it look like we actually created our branch before making those other two commits. 🙂
                </p>