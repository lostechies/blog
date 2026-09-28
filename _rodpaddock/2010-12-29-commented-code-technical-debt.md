---
wordpress_id: 4480
title: Commented Code == Technical Debt
date: 2010-12-29T17:13:00+00:00
author: Rod Paddock
layout: post
wordpress_guid: /blogs/rodpaddock/archive/2010/12/29/commented-code-technical-debt.aspx
dsq_thread_id:
  - "263003377"
categories:
  - Uncategorized
redirect_from: "/blogs/rodpaddock/archive/2010/12/29/commented-code-technical-debt.aspx/"
---
Over the last month I have spent countless hours modifying code in our
  
development framework. This framework is nearing the 4th grade now (9
  
years old) and has had many sections modified or rewritten extensively
  
over the ensuing decade.

A common technique I used when changing code was to comment large swaths
   
of code and insert new code in its place. I can tell you now this
  
technique was a poor idea and has wasted a considerable amount of my
  
time. This may sound obvious to you but to some it might not. Here&#8217;s
  
what I experienced:

1) Every time &nbsp;found a commented block I was forced to perform a context
   
switch. Why did I comment this code? These context switches are the
  
equivalent of a phone call or a child coming into the home office to
  
play. It takes precious time away from the task at hand.

2) The commented out code takes up space on the screen and in the flow
  
of the code. This requires a mental filter and a minor context switch.

3) And finally it is like doing testing after the fact. If you find
  
yourself adding comments to your code: //REMOVE THIS CODE LATER you have
   
lost. Just kill the code now. You wont remember why you added that line
   
in the first place so just don&#8217;t do it. kill -9 that cruft now.

So what if you feel like your code is precious and needs to be kept
  
intact like it&#8217;s the Magna Carta? Just use your version control system.
  
The code will always be there to recover like the the Ark of the
  
Covenant. If you don&#8217;t have a version control system get one. There is
  
NO reason not to.

So now that I have your attention&#8230; kill that cruft. Otherwise I&#8217;ll submit your name to my new reality show: Code Hoarders

NOTE: For those of you that are code comment haters, this post is not
  
for you. Relevant comments are always a good ideas and should be used.
  
&nbsp;Consider this flame bait if you so desire 🙂