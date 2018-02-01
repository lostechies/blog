---
id: 45
title: Test First Development
date: 2008-04-15T05:32:40+00:00
author: Evan Hoff
layout: post
guid: /blogs/evan_hoff/archive/2008/04/15/test-first-development.aspx
categories:
  - Uncategorized
---
This is my attempt at&nbsp;sharing some of&nbsp;my personal reasoning around the topic of test-first development.

Let me first sum up my thoughts in one shot:

> **At the class level, form and function are significantly more important than implementation.**

Test-first development forces me to focus on the usage and external structure of the class before allowing me to&nbsp;create an implementation.&nbsp; Within the context of a specific behavior or piece of functionality, there are an infinite number of implementations which will work.&nbsp; Given&nbsp;the infinite number of ways to implement&nbsp;the piece of functionality&nbsp;as a class, it&#8217;s the class&#8217;&nbsp;form that is the key differentiator.&nbsp; Specifically, each form exhibits a unique set of qualities.&nbsp; It&#8217;s&nbsp;by these qualities that each implementation can be judged.

Test-first development (as it was intended)&nbsp;forces&nbsp;me to focus on selecting the highest quality form from all designs that will meet the functional requirements.&nbsp; Implementation is easy.&nbsp; Design is tricky.&nbsp; I choose to let that which is most important drive my development process.

On the contrary, if the structure of the classes in your application are accidentally created as a side effect of their&nbsp;implementation,&nbsp;the system&#8217;s&nbsp;nonfunctional properties, such as maintainability, will also be accidentally affected.&nbsp; This is because the external structure of your classes are the knobs for such nonfunctional qualities as maintainability, modifiability,&nbsp;and testability.

Given the importance of these nonfunctional properties, this is to be avoided at all costs.&nbsp; Failure to meet nonfunctional requirements is the primary technical cause of catastrophic project and/or application failure.

> **Test-first development is a risk mitigation activity for key nonfunctional system properties and a defect-prevention process.**

This ties heavily into my knowledge of system and class design&#8211;issues&nbsp;such as&nbsp;coupling and&nbsp;modularity.&nbsp; By preselecting the form and use of the classes in my design, it forces me to&nbsp;think up front&nbsp;about the&nbsp;nonfunctional knobs of this cog in my system&#8211;knobs such as coupling, testability, maintainability, and modifiability.

> **By preselecting the structure and functionality of the class,&nbsp;I constrain the implementation.**

Gold-plated code is a bit of an epidemic in the software development industry.&nbsp; By constraining the implementation with form and usage, I become focused on implementing exactly what&#8217;s needed&#8211;nothing more.

> **Test-first development is&nbsp;neither&nbsp;a panacea nor a silver bullet.**

It doesn&#8217;t guarantee I will select the best design.&nbsp; It doesn&#8217;t even mean my selected design is implementable.&nbsp; But if and when I recognize either case, I can quickly throw away the old design and start fresh.&nbsp; 

Or at least that&#8217;s a side effect of having a maintainable, modifiable system.

And lastly..

> **It&#8217;s about having a tight, automated&nbsp;feedback loop on the health of the implementation.**