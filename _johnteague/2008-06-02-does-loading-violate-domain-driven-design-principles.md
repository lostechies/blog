---
id: 9
title: Does Lazy Loading via Properties Violate Domain Driven Design Principles?
date: 2008-06-02T18:37:00+00:00
author: John Teague
layout: post
guid: /blogs/johnteague/archive/2008/06/02/does-loading-violate-domain-driven-design-principles.aspx
dsq_thread_id:
  - "262055469"
categories:
  - NHibernate DDD
---
Some comments to a recent [post](http://codebetter.com/blogs/jeremy.miller/archive/2008/05/25/we-re-talking-past-each-other-on-the-entity-framework.aspx) on [Jeremy Miller&#8217;s](http://codebetter.com/blogs/jeremy.miller/default.aspx) blog raised the question of whether NHibernate&#8217;s lazy loading capabilities violate Domain Driven Design.&nbsp; While that conversation was centered around bypassing repositories for access data, which is not true since your aggregate roots are your repository source.&nbsp; But there is another aspect that was not discussed.


  


Evans discusses that client code does not need to know about the repository implementation, but developers do.<SUP>1 </SUP>


  


Let&#8217;s look at a simple example, suppose you have an Order object with a list of LineItems as a property. The source code is deceptively simple.


  


<DIV>
  <br /> 
  
  <DIV>
    <PRE><SPAN>   1:</SPAN> Order order = orderRepository.GetById(1);</PRE>
    
    <PRE><SPAN>   2:</SPAN> <SPAN>foreach</SPAN>(LineItems item <SPAN>in</SPAN> order.LineItems)</PRE>
    
    <PRE><SPAN>   3:</SPAN> {</PRE>
    
    <PRE><SPAN>   4:</SPAN>     <SPAN>//do something fancy here</SPAN></PRE>
    
    <PRE><SPAN>   5:</SPAN> }</PRE>
  </DIV>
</DIV>


  


Using NHibernate&#8217;s lazy loading, the LineItems property on an Order instance will not be populated until it is first called.&nbsp; When it is accessed, a database call will be made to populate the LineItems collection.&nbsp; The first time I saw this, I was floored.&nbsp; &#8220;That is sooo cool&#8221;, Then I started thinking about it.&nbsp; That lazy load call could be very expensive and if the person maintaining the code after I&#8217;m gone doesn&#8217;t know that the property accessor results in a potentially expensive database call, how can they make the proper decision on when that collection should be used?


  


This functionality obviously satisfies Evans first clause, but to me it violates the second part.&nbsp; Developer&#8217;s need to know when expensive operations occurs, and hiding that operation behind a property accessor obscures that possibility. Now it has been argued that the real problem is that the property syntax is the real problem<SUP>2</SUP>. And I can agree with that, however the cat is out of the bag on that one. 


  


The title of this blog post is a question to the community.&nbsp; What are your thoughts? Do you think that using a getter method better describes to the developer that something more than an instance variable is being accessed?&nbsp; Or are you okay with the property syntax?


  


&nbsp;


  


1.&nbsp; Evans, Domain Driven Design, p. 154


  


2.&nbsp; Richter, CLR via C#, p.217