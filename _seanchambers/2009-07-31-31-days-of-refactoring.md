---
wordpress_id: 3194
title: 31 Days of Refactoring
date: 2009-07-31T12:52:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/07/31/31-days-of-refactoring.aspx
dsq_thread_id:
  - "262346009"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/07/31/31-days-of-refactoring.aspx/"
---
Refactoring is an integral part of continually improving your code while it moves forward through time. Without refactoring you accrue technical debt, forget what portions of code do and create code that is resistant to any form of testing. It is an easy concept to get started with and opens the door to much better practices such as unit testing, shared code ownership and more reliable, bug-free code in general.

Because of the importance of refactoring, throughout the month of August I will be describing one refactoring a day for the 31 days of August. Before I begin, let me prefix this series with the fact that I am not claiming ownership of the refactorings I will describe, although I will try to bring some additional description and perhaps some discussion around each. I have chosen not to list the full set of refactorings on this first post until I actually post the refactoring. So as the month progresses I will update this post with links to each of the refactorings.

First on the list is credit where it is due. The majority of these refactorings can be found <a target="_blank" href="http://www.refactoring.com/">Refactoring.com</a>, some are from <a target="_blank" href="http://cc2e.com/">Code Complete 2nd Edition</a> and others are refactorings that I find myself doing often and from various other places on the interwebs. I don&rsquo;t think its important to note on each refactoring where it came from, as you can find refactorings of similar names found on various blogs and articles online.

On that note, I will be publishing the first post starting tomorrow that begins the 31 day marathon of various refactorings. I hope you all enjoy and learn something from the refactorings!

&nbsp;

  1. [Refactoring Day 1 : Encapsulate Collection](/blogs/sean_chambers/archive/2009/08/02/refactoring-day-1-encapsulate-collection.aspx)
  2. [Refactoring Day 2 : Move Method](/blogs/sean_chambers/archive/2009/08/02/refactoring-day-2-move-method.aspx)
  3. [Refactoring Day 3 : Pull Up Method](/blogs/sean_chambers/archive/2009/08/03/refactoring-day-3-pull-up-method.aspx)
  4. [Refactoring Day 4 : Push Down Method](/blogs/sean_chambers/archive/2009/08/04/refactoring-day-4-push-down-method.aspx)
  5. [Refactoring Day 5 : Pull Up Field](/blogs/sean_chambers/archive/2009/08/05/refactoring-day-5-pull-up-field.aspx)
  6. [Refactoring Day 6 : Push Down Field](/blogs/sean_chambers/archive/2009/08/06/refactoring-day-6-push-down-field.aspx)
  7. [Refactoring Day 7 : Rename (method, class, parameter)](/blogs/sean_chambers/archive/2009/08/07/refactoring-day-7-rename-method-class-parameter.aspx)
  8. [Refactoring Day 8 : Replace Inheritance with Delegation](/blogs/sean_chambers/archive/2009/08/07/refactoring-day-8-replace-inheritance-with-delegation.aspx)
  9. [Refactoring Day 9 : Extract Interface](/blogs/sean_chambers/archive/2009/08/07/refactoring-day-9-extract-interface.aspx)
 10. [Refactoring Day 10 : Extract Method](/blogs/sean_chambers/archive/2009/08/10/refactoring-day-10-extract-method.aspx)
 11. [Refactoring Day 11 : Switch to Strategy](/blogs/sean_chambers/archive/2009/08/11/refactoring-day-11-switch-to-strategy.aspx)
 12. [Refactoring Day 12 : Break Dependencies](/blogs/sean_chambers/archive/2009/08/12/refactoring-day-12-break-dependencies.aspx)
 13. [Refactoring Day 13 : Extract Method Object](/blogs/sean_chambers/archive/2009/08/13/refactoring-day-13-extract-method-object.aspx)
 14. [Refactoring Day 14 : Break Responsibilities](/blogs/sean_chambers/archive/2009/08/14/refactoring-day-14-break-responsibilities.aspx)
 15. [Refactoring Day 15 : Remove Duplication](/blogs/sean_chambers/archive/2009/08/15/refactoring-day-15-remove-duplication.aspx)
 16. [Refactoring Day 16 : Encapsulate Conditional](/blogs/sean_chambers/archive/2009/08/16/refactoring-day-16-encapsulate-conditional.aspx)
 17. [Refactoring Day 17 : Extract Superclass](/blogs/sean_chambers/archive/2009/08/17/refactoring-day-17-extract-superclass.aspx)
 18. [Refactoring Day 18 : Replace exception with conditional](/blogs/sean_chambers/archive/2009/08/18/refactoring-day-18-replace-exception-with-conditional.aspx)
 19. [Refactoring Day 19 : Extract Factory Class](/blogs/sean_chambers/archive/2009/08/19/refactoring-day-19-extract-factory-class.aspx)
 20. [Refactoring Day 20 : Extract Subclass](/blogs/sean_chambers/archive/2009/08/20/refactoring-day-20-extract-subclass.aspx)
 21. [Refactoring Day 21 : Collapse Hierarchy](/blogs/sean_chambers/archive/2009/08/21/refactoring-day-21-collapse-hierarchy.aspx)
 22. [Refactoring Day 22 : Break Method](/blogs/sean_chambers/archive/2009/08/22/refactoring-day-22-break-method.aspx)
 23. [Refactoring Day 23 : Introduce Parameter Object](/blogs/sean_chambers/archive/2009/08/23/refactoring-day-23-introduce-parameter-object.aspx)
 24. [Refactoring Day 24 : Remove Arrowhead Antipattern](/blogs/sean_chambers/archive/2009/08/24/refactoring-day-24-remove-arrowhead-antipattern.aspx)
 25. [Refactoring Day 25 : Introduce Design By Contract Checks](/blogs/sean_chambers/archive/2009/08/25/refactoring-day-25-introduce-design-by-contract-checks.aspx)
 26. [Refactoring Day 26 : Remove Double Negative](/blogs/sean_chambers/archive/2009/08/26/refactoring-day-26-remove-double-negative.aspx)
 27. [Refactoring Day 27 : Remove God Classes](/blogs/sean_chambers/archive/2009/08/27/refactoring-day-27-remove-god-classes.aspx)
 28. [Refactoring Day 28 : Rename boolean methods](/blogs/sean_chambers/archive/2009/08/28/refactoring-day-28-rename-boolean-method.aspx)
 29. [Refactoring Day 29 : Remove Middle Man](/blogs/sean_chambers/archive/2009/08/28/refactoring-day-29-remove-middle-man.aspx)
 30. [Refactoring Day 30 : Return ASAP](/blogs/sean_chambers/archive/2009/08/28/refactoring-day-30-return-asap.aspx)
 31. [Refactoring Day 31 : Replace Conditional with Polymorphism](/blogs/sean_chambers/archive/2009/08/28/refactoring-day-31-replace-conditional-with-polymorphism.aspx)

<div>
  Final post with links to download samples:&nbsp;<a href="http://www.lostechies.com/blogs/sean_chambers/archive/2009/08/31/31-days-of-refactoring-series-complete.aspx">http://www.lostechies.com/blogs/sean_chambers/archive/2009/08/31/31-days-of-refactoring-series-complete.aspx</a>
</div>