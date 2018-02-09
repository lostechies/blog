---
wordpress_id: 48
title: The difficult definition of professional software development
date: 2011-02-04T22:51:00+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2011/02/04/the-difficult-definition-of-professional-software-development.aspx
dsq_thread_id:
  - "425624472"
categories:
  - Craftsmanship
redirect_from: "/blogs/rssvihla/archive/2011/02/04/the-difficult-definition-of-professional-software-development.aspx/"
---
Here are some of the contradictory phrases (and a few paraphrases) I&#8217;ve overheard used to define what is &#8220;good&#8221; and &#8220;bad&#8221; code. 

  * Code should always be well commented
  * Maintainable code has unit tests and well named methods therefore needs little if any comments
  * Class explosion is to be avoided at all costs
  * Many small simple well named classes are the key to well organized code
  * Unit tests really don&#8217;t test anything useful
  * Dependency injection leads to an unusable mess
  * Dependency Injection is a very useful tool for making your code extensible and easily reused&#8221;
  * Inheritance leads to solid code reuse
  * Inheritance is the strongest coupling of your code you can have
  * Functional programming simplifies and minimizes the complexity of your code
  * Functional programing just makes my eyes bleed!
  * Static global references are &#8216;just programming&#8217; and something you have to learn how to manage to make simple easy to understand code
  * Static global spiderwebs are crippling to maintenance and program lifetime

&nbsp;

The part that is most difficult about that list for me is while I agree with half of it strongly and respect the people who said those things, the other half that list I do not agree with, has all come from people I respect and who overall do some pretty impressive things. They&#8217;ve certainly created things by all measures more impressive than anything I&#8217;ve ever produced

This leads me to question how much do software principles matter when taking them out of the context of yourself but viewing it in a bigger picture. Thinking about it, 95% of the software that I actually like probably wasn&#8217;t using any TDD at any point in time and certainly violates a number of things that I would consider required for &#8220;professional software&#8221;. I keep reinforcing this fact every time I checkout the source of a major software project I&#8217;ve used for years and gasp in horror at the spaghetti code I find.

Worse still the different schools of thought are not compatible in the slightest, and one side views the other side as wholly unprofessional (granted for different reasons) to the point that I&#8217;ve realized I myself was perceived as the one being &#8220;amateur&#8221; by those with a different definition of what makes good and bad software. I of course unfortunately often thought the same of them, regardless of how I felt about them personally.

Anyway, this is all food for thought and I have not yet come to any conclusion what it all means. It&#8217;s just easily the most frustrating thing about our profession and has on more than a few occasions had me long to return to being a sysadmin (too bad I really love making things). I know I&#8217;ve tried coding under other schools of thought and while through practice I was able to deliver well enough, I&#8217;m far slower and more error prone with no TDD, big mega classes, and avoiding dependency injection