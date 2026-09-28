---
wordpress_id: 4854
title: Ubiquitous Language can be refactored!
date: 2007-05-15T18:05:21+00:00
author: Jasdeep Singh
layout: post
wordpress_guid: /blogs/jasdeep_singh/archive/2007/05/15/ubiquitous-language-can-be-refactored.aspx
categories:
  - Domain Driven Design
  - Ubiquitous Language
redirect_from: "/blogs/jasdeep_singh/archive/2007/05/15/ubiquitous-language-can-be-refactored.aspx/"
---
_Recognize that a change in_ [_UbiquitousLanguage_](http://domaindrivendesign.org/discussion/messageboardarchive/UbiquitousLanguage.html) _is a change to the model._ 

_Excerpted from [DomainDrivenDesignBook](http://domaindrivendesign.org/discussion/messageboardarchive/DomainDrivenDesignBook.html)_.

We all understand the importance of ubiquitous language as the basis of communication amongst the stakeholders of a project.&nbsp;Often we have had modeling sessions with the business team when we talk UL, yet in the back of our minds we might not like the terms that are being used to describe various&nbsp;entities/value objects/aggregates/services etc in our discussion. Most often than not, we may have resigned to the terms as permanent; sometimes we might not even care. Alright, the point that I am trying to make is that if the domain model equates to code and&nbsp;TDD practitioners seldom think twice before refactoring code (we call it courage bundled with the abilities of Resharper); so why do we hesitate to change the UL?

The UL gets created when the first code is written. It grows as the code grows and gets dirty as more and more crap (no pun intended) gets added to it. And yet, we sometimes undergo massive code refactoring exercises without thinking too much about how that will impact the model. And if its changing the model, its bound to have an affect on UL.

There is always that potential that our model and UL might have a mismatch and I believe every effort should be made to not let that happen.