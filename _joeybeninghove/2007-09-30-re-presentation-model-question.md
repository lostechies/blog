---
id: 40
title: 'RE: Presentation Model Question'
date: 2007-09-30T00:04:00+00:00
author: Joey Beninghove
layout: post
guid: /blogs/joeydotnet/archive/2007/09/29/re-presentation-model-question.aspx
categories:
  - Domain Driven Design
  - NHibernate
  - Patterns
  - Refactoring
---
I&#8217;ve been&nbsp;working on an end to end example using MonoRail (I know, just get
  
it posted Joey!)&nbsp;that can demonstrate _one_ way this can be implemented
  
and JP has given me the green light to get it posted even though he&#8217;s working in
  
some sample code as well.&nbsp; (I&#8217;m sure his example will be much better than mine)&nbsp;
  
🙂&nbsp; 

But I wanted to respond quickly&nbsp;to [Liam&#8217;s
  
questions](http://codebetter.com/blogs/jean-paul_boodhoo/archive/2007/09/28/screen-bound-dto-update-getting-the-terminology-right.aspx#168899) on [JP&#8217;s
  
latest update on screen-specific DTOs](http://codebetter.com/blogs/jean-paul_boodhoo/archive/2007/09/28/screen-bound-dto-update-getting-the-terminology-right.aspx). 

Here was Liam&#8217;s first question: 

> &#8220;Firstly, isn&#8217;t this a violation of the DRY principle?&#8221;

Well&#8230; it depends.&nbsp; 🙂 

It certainly is not right for every situation.&nbsp; But one of _my_
  
motivations for using screen-specific DTOs is [SRP](http://www.objectmentor.com/resources/articles/srp.pdf).&nbsp; Having a
  
set of task specific/screen specific DTOs can sometimes give you the loose
  
coupling you need to protect your domain model from being polluted (most of the
  
time, unintentionally) by UI and/or infrastructure concerns.&nbsp; 

If I have to work within a complex domain, I typically like for the
  
responsibilities of the domain model to be&nbsp;narrowly focused on object
  
interactions and relationships to make it easier to understand and maintain. 

Now, if your DTOs are nothing more than mirror images of your domain model,
  
then that is definitely a smell and is most likely not very DRY.&nbsp; I&#8217;ve been on a
  
couple projects like this and, at that point, maintenance of the mapping layer
  
becomes very tedious and generally makes developers unhappy.&nbsp; Not a good thing. 

Liam&#8217;s second question is something I&#8217;ve been looking for/working towards
  
myself: 

> &#8220;Secondly, is there a nice way to handle the mapping between the domain model
  
> and the presentation model?&#8221;

This is a very good question.&nbsp; So, of course, all of this&nbsp;does come with a
  
price.&nbsp; Maintaining a mapping layer is usually a necessary evil if you choose to
  
go this route.&nbsp; I&nbsp;try to&nbsp;start out with simple hand-rolled mappers and let it
  
evolve from there.&nbsp; Most likely, through continuous refactoring you could arrive
  
at a fairly robust and somewhat easy to maintain mapping layer.&nbsp; I feel like I&#8217;m
  
getting close to that point on my current project now that I have a dozen or so
  
mappers implemented.&nbsp; 

Unfortunately, I don&#8217;t know of any decent frameworks out there that can
  
tackle this problem of domain-presentation mapping&nbsp;the same way, say NHibernate,
  
solves the object-relational mapping&nbsp;problem.&nbsp; If&nbsp;you know of any, please let me
  
know.&nbsp; Otherwise, I suppose it wouldn&#8217;t be too hard to &#8220;harvest&#8221; one from an
  
existing application.&nbsp; In fact, I may try to do just that on my current project
  
if I can see any value in it. 

You&#8217;re probably saying, &#8220;Just post some code Joey!&#8221;.&nbsp;&nbsp;I know, I know.&nbsp; Well,
  
I&#8217;m pretty close.&nbsp; I just like to make sure&nbsp;the quality of the&nbsp;samples I
  
provide&nbsp;are close to, if not the&nbsp;same, as the code I churn out every day.&nbsp; So,
  
thanks for your patience.&nbsp; 🙂

&nbsp;