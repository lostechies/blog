---
wordpress_id: 3138
title: Branching a trunk permanently
date: 2007-09-27T22:41:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2007/09/27/branching-a-trunk-permanently.aspx
dsq_thread_id:
  - "268123691"
categories:
  - Uncategorized
---
I am wondering how someone else would achieve what I am trying to do here. Basically I have a development trunk for Project A. It is updated with new code on a daily basis and has frequent branches and merges for various features etc..


  


I have taken a project trunk and created a completely new project from it. I am doing this because the new trunk will go off it&#8217;s own development path and I don&#8217;t want modifications on Project B to create problems in Project A. In addition, namespaces in Project B will be different. This part is no problem. The problem I have is how to effeciently transmit updates to code from one project to the other. From time to time there may be new features added that I want to add to one project or the other but not all the time.


  


I thought about using patches and haven&#8217;t thought about it much recently. I&#8217;m at the point now where Project A has quite a few features that I wish to add to Project B without having to copy and paste code although this is what I may have to resort too.


  


I guess the bottom line is, there feels like there is an easier way to do this, if there is I haven&#8217;t found it yet =)