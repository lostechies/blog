---
wordpress_id: 128
title: 'Git: Oops! I Changed Those Files In The Wrong Branch!'
date: 2010-04-01T17:37:17+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/04/01/git-oops-i-changed-those-files-in-the-wrong-branch.aspx
dsq_thread_id:
  - "262063153"
categories:
  - Branching Strategies
  - git
  - Source Control
redirect_from: "/blogs/derickbailey/archive/2010/04/01/git-oops-i-changed-those-files-in-the-wrong-branch.aspx/"
---
I do this a lot… I’ll be assigned some work, start into it and get part way down the path, am ready for a commit and I realize that I’ve been changing code in the wrong branch of my local git repository. For example:

&#160; <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_5CDF6673.png" width="997" height="314" />

… but I didn’t want those changes on the master branch… I wanted them on some other branch, such as “mybranch” or “existingbranch”.

The good news is that git is AWESOME and this really isn’t a big deal. I can easily move these changes to a new branch or to an existing branch by doing one of the following… and there are probably many other ways of accomplishing the goal of moving your changes to a new or existing branch, too. These are the two methods I use most often, though.

&#160;</p> 

### Move To A New Branch

To move these changes to a new branch, run this command where “mybranch” is the name of the branch you want to create.

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> git checkout -b mybranch</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        and then run git status again. You’ll see that the changes you made are still in place and you can now commit them to the new branch.
      </p>
      
      <p>
        <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_67308AD3.png" width="997" height="394" />
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        Move To An Existing Branch
      </h3>
      
      <p>
        To move these changes to an exiting branch, just checkout the other branch with the regular checkout command. For example, run this command where “existingbranch” is the name of an existing branch.
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> git checkout existingbranch</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              Then run git status again, and you’ll see the same results but you’ll be on the existing branch:
            </p>
            
            <p>
              <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_665824E9.png" width="997" height="394" />
            </p>