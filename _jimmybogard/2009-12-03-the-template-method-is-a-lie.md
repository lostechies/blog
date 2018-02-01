---
id: 371
title: The Template Method is a lie
date: 2009-12-03T01:56:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/12/02/the-template-method-is-a-lie.aspx
dsq_thread_id:
  - "264716353"
categories:
  - Design
  - OO
---
[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_2C7FA22D.png" width="304" height="349" />](http://lostechies.com/jimmybogard/files/2011/03/image_4F23E0A8.png) 

In my recent adventures with [controller-less actions](http://www.lostechies.com/blogs/chad_myers/archive/2009/06/18/going-controller-less-in-mvc-the-way-fowler-meant-it.aspx), and trying to solve the issue of the crazy CRUDController mess I had put myself (and our team/project) into.&#160; While some gravitate towards the Singleton pattern to abuse after they learn the [GoF patterns](http://www.hillside.net/patterns/DPBook/DPBook.html), that wasn’t the case for me.&#160; Instead, I fell in love with the [Template Pattern](http://www.dofactory.com/Patterns/PatternTemplate.aspx).&#160; But there’s a problem with the Template pattern as the golden hammer for every incidence of duplication we find in our application.&#160; The Template Method favors _inheritance over composition_.

Template method has its place, but that place is for procedural, algorithmic duplication.&#160; If you jump to Template method, you reinforce a procedural, rather than Object-Oriented design.&#160; Instead of template method, I’ve forced myself to look at the more OO patterns (though I haven’t gone as far as join the [Anti-If Campaign](http://www.antiifcampaign.com/))&#160; These patterns include:

  * Strategy
  * State
  * Command
  * Chain of Responsibility
  * Observer
  * Visitor
  * Double-dispatch

All of these lead towards a more OO approach, which I have surprised myself lately on how far I really have to go in that area.&#160; What’s held me back is my knee-jerk reaction to duplication to put in a Template pattern.&#160; This pattern has its place, but like any over-applied pattern, can stink up your design and architecture when you push it into places it shouldn’t go.