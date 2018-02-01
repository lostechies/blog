---
id: 3135
title: NAnt Build Prompter
date: 2007-09-24T19:00:00+00:00
author: Sean Chambers
layout: post
guid: /blogs/sean_chambers/archive/2007/09/24/nant-build-prompter.aspx
dsq_thread_id:
  - "277720335"
categories:
  - Uncategorized
---
This is a very basic script that a co-worker named Rabid made for me. I don&#8217;t know this syntax but he does for all the group policy stuff we have at work. Basically the way I had it setup to manually do nant builds was I had three seperate .bat files. That did the following:


  



  


  * One for copying the build to the staging server 

  


  * One for copying the build to the deployment server 

  


  * One for doing a complete build and then copying to the staging server 


  


It was kind of a pain to have seperate bat files because then I had to run a specific one depending on the build/deployment I wanted. So this is the script that a co-worker came up with NAnt Build Prompter


  


You can download it from my GoogleCode repository here : <http://schambers.googlecode.com/svn/trunk/Tools/clickToBuild.bat>


  


The only thing you have to do is open the bat file, and change the path to nant.exe. The file is setup now with the following folder structure:   
&#8211; trunk   
&#8211;libnantnant.exe   
&#8211; branches   
&#8211; tags   
&#8211; clickToBuild.bat   
&#8211; default.build


  


You only have to open the file and change the path to nant.exe. Maybe there is an easier way to do this but I haven&#8217;t tried it yet. Just thought I would share this as I have found it useful. Up to this point I just had 3 separate bat files. One for each build target. This is all running on my build server that is also running CruiseControl so when I need to update the production server, I log into the build server and kick off the deployment target.


  


If anyone wants to see the build file I am using let me know. It&#8217;s pretty much setup as a template now that I just copy to a new project and then change the variables. I&#8217;m sure everyone probably has something similar though.