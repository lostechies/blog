---
id: 4648
title: 'Book Review &#8211; RESTful .NET'
date: 2009-05-10T19:59:39+00:00
author: Colin Jack
layout: post
guid: /blogs/colinjack/archive/2009/05/10/book-review-restful-net.aspx
categories:
  - Books
  - REST
  - WCF
---
Since we are using REST on top of WCF on my current project I was glad to see that this book had been written as I was hoping it would answer some questions I had. 

However my first issue with this book was the title. As I say we&#8217;re using WCF but WCF isn&#8217;t the only way to implement REST in .NET, however the book does not take the time to evaluate alternatives (including building RESTful applications on top of ASP.NET MVC) so _RESTful WCF_ would have been a more accurate title. 

In fact if we wanted to truly represent the books focus I think we would call it _WCF REST_ because the primary focus is on WCF. There was a lot of WCF detail in here, starting from chapter 2, and personally I found some if quite boring especially where the author has chosen to put in property listings of some key WCF classes. I just don&#8217;t find that sort of content all that useful and I&#8217;d have expected a lot of it to be in an appendix at best. 

However the WCF focus has some other implications. Take HATEOS which is an important part of REST, my company has been lucky enough to have [Sebastien Lambla](http://serialseb.blogspot.com/) and [Alan Dean](http://alandean.blogspot.com/) in our office and both emphasized its importance. However there is almost no discussion of it in the book, and the reason for this becomes clear on page 246 where the author states that although hypermedia is important in REST it isn&#8217;t covered in the book because WCF has poor support for it. As I say we&#8217;re using WCF so I knew that WCF&#8217;s support for links in normal representations was non-existent, but I do consider it a flaw of the book and in my view the author would have been better stating this big problem up-front or tried to add framework to make linking a lot easier (something Seb did for us). 

Strangely the author actually states that he actually avoids discussing custom infrastructure code because it takes away from learning about the technology (page 97). Personally I would prefer the book if had a focus on REST and how to get the advantages of REST using WCF, low level WCF plumbing/architecture is a necessary evil not something I want to read much about and more importantly if we need extra framework then I&#8217;d like to see it discussed.

I also thought it was doubly odd that chapter 9 discussed &#8220;Using Workflow to Deliver REST Services&#8221;, all centred around Windows Workflow, when to me when I see the words workflow in a REST book I&#8217;m again thinking of HATEOS (the [RESTbucks example at InfoQ](http://www.infoq.com/articles/webber-rest-workflow) shows this approach brilliantly and will form part of a rival book).

Before wrapping up I also wanted to identify one bit of the book where the advice is very questionable. Chapter 10 is called &#8220;Consuming RESTful XML Services Using WCF&#8221; and one approach described is to take the interface attributed with _[ServiceContract](http://msdn.microsoft.com/en-us/library/system.servicemodel.servicecontractattribute.aspx)_ and use it client side. Just to be clear we&#8217;re talking about making class like _channel.CreateAuthority(authority)_ and then letting WCF work out what HTTP request to make. You won&#8217;t want to be doing that.

Anyway I personally wouldn&#8217;t recommend this to anyone wanting to learn about REST, instead I&#8217;d recommend (for now) [RESTful Web Services](http://www.amazon.co.uk/RESTful-Web-Services-Leonard-Richardson/dp/0596529260/ref=sr_1_1?ie=UTF8&s=books&qid=1241987182&sr=8-1). If however you are using WCF and REST, and feel you already understand REST, then this book will give you some insight into support for REST in WCF.