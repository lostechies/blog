---
id: 7
title: Self-Documenting Unit Tests
date: 2007-04-10T16:49:00+00:00
author: Jasdeep Singh
layout: post
guid: /blogs/jasdeep_singh/archive/2007/04/10/self-documenting-unit-tests.aspx
categories:
  - Agile
  - BDD
  - BDD Extension Methods
  - Behavior Driven Design
  - Comments
  - Design
  - inspiration
  - Orcas
  - self-documenting
  - Unit Tests
---
We have been practicing agile for more than a few years now and getting better as&nbsp;we move along, or at least that&#8217;s the goal and a desired expectation from the&nbsp;team; rightfully so since humans typically learn from experience. We jumped on the notion that by going agile, we can certainly reduce the mostly obsolete documents that managers/developers strive to keep current (or not), and fail. So the idea of having self documented code and unit tests sounded encouraging, to say the least. 


  


The inspiration for this blog entry is **not** to comment about the&nbsp;_want_ of having comments within code, since there is unquestionably&nbsp;no need, even though that&#8217;s a very hot _unresolved_ topic. A very personal opinion, and I agree with folks out there, for having code comments is when you would like to proudly apologize for your work. &#8220;_I so am superciliously sorry for writing this code, since I and only I can read it, lest you shall read the comments that I wrote_&#8220;.


  


The inspiration for this blog entry **is** really to better understand how we can write self-documenting code, and very specifically the unit tests. We should take pride in the fact that new developers on the team are easily be brought on board to the design of the system merely by taking a look at the unit tests. In an ideal situation that may be the case, however in reality it&#8217;s more far fetched than it seems. I personally got baffled last week when I started to delve into a feature of our system developed a few months ago. We have strived to keep our unit tests clean and readable, more so functional. The unit/feature/system design obtained by practicing&nbsp;TDD certainly would make all the sense having known&nbsp;the **context** under which&nbsp;it was established. The context is what defines the behavior of the system, it is what goes on to be gloriously enbraced by the domain model and it is what helps determine the overall design of a system.&nbsp;Best practices of appropriately naming variables, methods, classes etc. are all part of establishing a clear context, which in turn provides clarity and the most needed self-documentation.


  


In comes <A href="http://behaviour-driven.org/" target="_blank"><FONT color="#669966">BDD</FONT></A> or <A href="http://behaviour-driven.org/" target="_blank"><FONT color="#669966">Behavior Driven Design</FONT></A> and suddenly there is light, literally shone on the context. As my colleague <A href="http://www.agilejoe.com/" target="_blank"><FONT color="#669966">Joe O</FONT></A>&nbsp;talks in his <A href="http://www.lostechies.com/blogs/joe_ocampo/archive/2007/03/05/nunit-behavior-driven-development.aspx" target="_blank"><FONT color="#669966">post</FONT></A>,&nbsp;and Scott Bellware&nbsp;exhibits the <A href="http://codebetter.com/blogs/scott.bellware/archive/2006/12/18/156436.aspx" target="_blank"><FONT color="#669966">BDD Extension Methods</FONT></A>&nbsp;in Orcas that he has been playing with, and the industry in general, behavior as expressed by context has become the most focussed aspect of writing software, more importantly the unit tests and everything follows suit. 


  


I firmly believe that &#8220;comments within code&#8221; issue can never be resolved, however for those like me who would rather write simpler code <A href="http://behaviour-driven.org/" target="_blank"><FONT color="#669966">BDD</FONT></A> is the way to go.