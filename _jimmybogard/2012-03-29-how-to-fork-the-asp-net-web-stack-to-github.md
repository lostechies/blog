---
wordpress_id: 609
title: How to fork the ASP.NET Web Stack to GitHub
date: 2012-03-29T13:26:18+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/03/29/how-to-fork-the-asp-net-web-stack-to-github/
dsq_thread_id:
  - "628744211"
categories:
  - ASPNETMVC
  - git
---
I find GitHub a lot easier to work with for visual diffs etc., so if you’re interested in forking the newly released ASP.NET Web Stack on CodePlex to GitHub, it’s quite simple.

### Prerequisites:

First, get a GitHub account and make sure you’re set up locally. GitHub has a great tutorial here: <http://help.github.com/win-set-up-git/>

Next, just create a dummy repository and make sure you can push/pull OK.

### Forking a CodePlex repository

  1. Create an aspnetwebstack repository on GitHub:  
    [<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2012/03/image_thumb4.png" width="485" height="175" />](http://lostechies.com/jimmybogard/files/2012/03/image4.png)  
    You can just call it “aspnetwebstack” to make things easy. 
      * Clone the CodePlex repository locally, using the Git bash or Posh-Git 
        <pre>git clone https://git01.codeplex.com/aspnetwebstack
cd aspnetwebstack</pre>
        
          * Create a Git remote for your GitHub repository: 
            <pre>git remote add github git@github.com:jbogard/aspnetwebstack.git</pre>
            
              * Push the aspnetwebstack repository you just cloned up to GitHub: 
                <pre>git push github master</pre>
                
                  * Profit!</ol>