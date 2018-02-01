---
id: 15
title: What does maintainability mean to you?
date: 2007-06-07T17:49:53+00:00
author: Joey Beninghove
layout: post
guid: /blogs/joeydotnet/archive/2007/06/07/what-does-maintainability-mean-to-you.aspx
categories:
  - Patterns
  - TDD
---
Sometimes in my discussions with other developers, we have to agree to disagree on certain things.&nbsp; One recent topic was that of maintainability, in regards to&nbsp;the size of&nbsp;classes/methods and project structures.&nbsp; 

I find it curious that some developers believe a [single 4000 line class](http://c2.com/cgi/wiki?GodClass) with [single methods being hundreds of lines long](http://c2.com/cgi/wiki?LongMethodSmell) is actually more maintainable than say,&nbsp;40&nbsp;classes with ~100 lines each and methods around 7-10 lines long.&nbsp; Of course this is just a vague example, but you get my point.&nbsp; Being pretty open to other ideas/views, I just simply can&#8217;t bring myself to understand this (even though long&nbsp;ago&nbsp;that&#8217;s how I used to think!).&nbsp; 

_Chances are that a single class consisting of thousands of lines of code is in **major** violation of the [Single Responsibility Principle (SRP)](http://en.wikipedia.org/wiki/Single_responsibility_principle)&nbsp;and, with&nbsp;no&nbsp;unit tests,&nbsp;makes future changes without introducing bugs near impossible.&nbsp;_ 

Interestingly, I also find that developers who prefer the &#8220;put everything in **Logic.cs**&#8221; approach (_Yes, I&#8217;ve actually seen this exact filename in a production system_), seem to rely **very** heavily on the debugger.&nbsp; That&#8217;s really a shame, because there are much better and faster techniques available to discover bugs and&nbsp;understand how a particular class works.

Take unit testing, for example.&nbsp; Yes, I&#8217;m just talking about plain old state-based unit testing, even if you don&#8217;t&nbsp;understand the huge benefits of TDD/BDD (which is a bigger shame).&nbsp; But even unit tests alone can help break your reliance on the debugger.&nbsp; One of the best things you can do when finding/fixing bugs is **write a failing unit test that exposes the bug**.&nbsp; It&#8217;s so much faster to run a simple unit test than to step through a debugger, especially when your classes are gigantic.&nbsp; And, when&#8217;s the last time your debugger acted as a regression test for you?&nbsp; (I&#8217;ll take your silence as &#8220;never&#8221;&#8230;)

Another interesting observation I&#8217;ve had about large classes and methods is that they **rarely** have automated tests for them.&nbsp; This seems very strange to me.&nbsp; My confidence level in code like this, without automated tests,&nbsp;is extremely low.&nbsp; Nevertheless, I&#8217;ve occasionally had to work with systems like this.&nbsp; And I usually start by writing just a few unit tests and work from there.&nbsp; But that won&#8217;t last long until you realize you&#8217;ve got some serious refactoring to do because the code is so tightly coupled to everything else.&nbsp; This can make writing simple unit tests **very** hard.

The usual complaint I hear about keeping classes/methods small is Class/Method Explosion.&nbsp; Indeed, you probably will have many more classes (and hopefully interfaces) and methods, but with proper naming and location, you can pretty easily understand the flow of logic.&nbsp; And with unit tests that have descriptive names, it becomes that much easier.&nbsp; 

Simple Example:&nbsp; If you had to change the calculation of a gold customer&#8217;s discount, wouldn&#8217;t it be much easier to find in a GoldCustomerDiscountSpecification rather than on line 1238&nbsp;of the OrderService class?&nbsp; Oh, and did you remember to change it on line 854 in the CustomerService class as well?&nbsp; (I rest my case&#8230;)

I&#8217;m not even going to talk about SProcs that are a 1000 lines long, which sadly, I&#8217;ve also seen in production systems.&nbsp; Eeek!

So I guess I&#8217;d just encourage folks to look for ways to separate responsibilities in your code and use unit tests (and even better TDD) to aid you in your efforts.&nbsp; **And free yourself from the debugger!**