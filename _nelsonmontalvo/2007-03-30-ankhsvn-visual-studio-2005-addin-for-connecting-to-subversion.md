---
wordpress_id: 4733
title: AnkhSVN (Visual Studio 2005 AddIn for connecting to Subversion)
date: 2007-03-30T16:34:00+00:00
author: Nelson Montalvo
layout: post
wordpress_guid: /blogs/nelson_montalvo/archive/2007/03/30/ankhsvn-visual-studio-2005-addin-for-connecting-to-subversion.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/nelson_montalvo/archive/2007/03/30/ankhsvn-visual-studio-2005-addin-for-connecting-to-subversion.aspx/"
---
I was in refactoring mode, preparing for my repository post, and had to move files from one location to another.  
  
Now, moving files to other directories can easily be done within the Tortoise repository browser, but the updates are not reflected in the Visual Studio project using this method. You have to go into the project, delete the files in the old location and add the files in the new one. Tedious! 🙂  
  
I wanted an easy way to do moves &#8211; and just about anything else against Subversion &#8211; within Visual Studio, so I took a look at [AnkhSVN](http://ankhsvn.tigris.org/). Ankh is a Visual Studio AddIn (not an SCC provider) that gives you the ability to interface with your Subversion repository from within Visual Studio. The 1.0 version was just released in late January and appears stable.  
  
So far, so good. I was able to make the moves and the repository was updated automatically upon commit. The only caveat is that you have to commit any other changes that you may have in progress. Not a big deal.