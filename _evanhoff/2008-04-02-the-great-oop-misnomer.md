---
id: 42
title: The Great OOP Misnomer
date: 2008-04-02T02:08:04+00:00
author: Evan Hoff
layout: post
guid: /blogs/evan_hoff/archive/2008/04/01/the-great-oop-misnomer.aspx
categories:
  - Uncategorized
---
What&#8217;s the biggest minomer with OOP?

> Object-oriented programming is all about objects.

False.&nbsp; Objects are instances of classes and only exist at runtime.

Object-oriented programming is all about class design.&nbsp; It should have been named Class Oriented Programming (COP).

Bertrand Meyer asked this question in his <a href="http://www.amazon.com/Object-Oriented-Software-Construction-Prentice-Hall-International/dp/0136291554/" target="_blank">classic tome</a> on object-oriented design:

> Do we design for runtime or design time?

Answer:

Object-oriented programming is about design-time constraints.&nbsp; Concepts such as reuse, maintainability, encapsulation, information hiding, and inheritance are all design-time constructs.

In fact, there are multiple designs that end up with the same runtime layout (objects) but that aren&#8217;t all considered good object-oriented design (you can&#8217;t judge the class design by what&nbsp;the object&nbsp;looks like at runtime).

The lack of focus on runtime issues is, in my opinion, the greatest weakness of OOP.

This was one of the issues that the Component-Orientation crowd, such as <a href="http://www.amazon.com/Component-Software-Beyond-Object-Oriented-Programming/dp/0201745720/" target="_blank">Szyperski</a>,&nbsp;capitalized on.