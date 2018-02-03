---
wordpress_id: 3183
title: Refactoring towards deeper insight
date: 2008-08-24T14:03:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2008/08/24/refactoring-towards-deeper-insight.aspx
dsq_thread_id:
  - "268123845"
categories:
  - Uncategorized
---
While giving my DDD presentation at the Jacksonville Code Camp, I felt that DDD refactoring was one area that I really didn&#8217;t touch on enough. I mentioned it briefly but I wanted to build on the discussion that we started to have in the presentation. I feel this is a very important practice of DDD and needs more explanation.


  


When doing DDD, a very important concept is the fact that noone gets the model correct the first time. This is against the traditional waterfall&nbsp;approach of BDUF (big design up front) and trying to set everything in stone from the beginning. Because of this reason, the domain model needs to be refactored throughout the development lifecycle. In order to support this constant refactoring, you need to use TDD in order to keep your model functioning as expected. Without the safety net of tests, you have no way of seeing how the changes impact other portions of the system.


  


In my presentation I spoke about two areas of refactoring in relation to DDD, or refactoring in general. Timing and Intiation. There are other concepts surrounding refactoring that I won&#8217;t focus on here.


  


Timing of refactoring deals with when refactoring should occur during the development. Refactor too early and you will spin your wheels, wait too long and it becomes difficult to change the model and more costly. There is a sweet spot for timing to perform refactoring. I would say its a fairly large window as you will start to get code smells, this is an indicator that refactoring needs to occur, along with the ubiquitous language changing. The refactoring timing is fairly easy to see and show take place once you see it coming. Don&#8217;t hesitate or put it off until later, it will hurt much more if you do.


  


Initiation of refactoring is important as well. Once you notice that refactoring needs to take place the second step is actually initiating the refactoring. It&#8217;s extremely easy to start cowboy coding doing refactoring changes because you have the tests, but this shouldn&#8217;t be the case. It&#8217;s very tempting but try to avoid this. Instead, begin writing tests to drive the refactoring in the direction you wish to go. If you notice that an entity has been renamed in the language from Loan to LoanSomething, then start by renaming it in your tests, which will then drive you to rename it in the domain. This is how all refactorings should take place in general, not only in DDD. Choose portions to localize the refactorings, but at the same time to just take little nibbles off the model. Try to cover as much of the domain model as required without making huge refactoring changes. The idea here is to perform small incremented refactorings that increase the cohesiveness of the model while not make huge sweeping changes in the process.


  


While not the most important or well documented aspect of DDD, Refactoring plays an integral role when performing DDD. It feels slow and sluggish at first, but once you get the hang of it, you can utilize your toolset to aid in the refactoring, such as CodeRush or ReSharper. These greatly speed up the refactoring process in various ways. Don&#8217;t be afraid or nervous to start&nbsp;refactoring, you will introduce problems but quickly iron them out in the process. Do this often enough, with the correct methods and your domain model will become much more flexible and cohesive for future changes. The domain model is NEVER set in stone. No matter who you are, noone will get it correct the first time. I really want to stress that point. Be comfortable and accept that so you can refactor towards a better model. Do this on an often enough basis and you will drive the domain model to a deeper insight that better reflects what the core idea of the domain model is. Hence, refactoring towards deeper insight.


  


I hope that clears up anything I may have left out of my presentation and further defines the role of refactoring in DDD. Comments, Questions?