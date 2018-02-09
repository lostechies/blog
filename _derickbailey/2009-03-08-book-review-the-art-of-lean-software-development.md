---
wordpress_id: 41
title: 'Book Review: The Art of Lean Software Development'
date: 2009-03-08T21:05:57+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/03/08/book-review-the-art-of-lean-software-development.aspx
dsq_thread_id:
  - "267399013"
categories:
  - Agile
  - Books Reviews
  - Lean Systems
redirect_from: "/blogs/derickbailey/archive/2009/03/08/book-review-the-art-of-lean-software-development.aspx/"
---
[The Art of Lean Software Development](http://www.amazon.com/gp/product/0596517319?ie=UTF8&tag=loste02-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=0596517319) <img style="border-right: medium none;border-top: medium none;margin: 0px;border-left: medium none;border-bottom: medium none" height="1" alt="" src="http://www.assoc-amazon.com/e/ir?t=loste02-20&l=as2&o=1&a=0596517319" width="1" border="0" />

<a href="http://www.amazon.com/gp/product/0596517319?ie=UTF8&tag=loste02-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=0596517319" target="_blank"><img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="240" src="http://sitb-images.amazon.com/Qffs+v35leqt2hzIDMEaTnR2Zw7h/Gzfo5WlntadKf7/1UbiAgEX5609I3+LL/JaAL4ZQ1TYVr4=" width="183" border="0" /></a>

This is an admittedly short book at only 122 pages. The authors felt that there was a need to have an introductory offering into the world of Lean and Agile methodologies, and have done a great job of keeping the book very focused. They offer an introductory look at some foundational Lean and Agile concepts and provide a clear understanding of how Lean is not in itself a specific process or methodology, but is at it’s core a philosophy that draws on existing processes and methodologies, giving them true value to the business. 

# 

### The Good

The core of this book discusses what the authors believe are the “_five most important practices that you can adopt as you begin your Lean software development journey._” The practices that they outline are common practices that are found in many existing Agile methodologies, so they are likely to be familiar to those who have done any research or read any blogs on recent trends in software development. 

They actually list six practices, but consider the first one to be ‘Practice 0’ – what you should be doing, period, even if you are not doing any form of Agile or Lean development. The full list of development practices that they list, are:

  * Practice 0: Source Code Management And Scripted Builds 
  * Practice 1: Automated Testing 
  * Practice 2: Continuous Integration 
  * Practice 3: Less Code 
  * Practice 4: Short Iterations 
  * Practice 5: Customer Participation 

Over-all, I’m happy with the practices that they outline. The practices they chose are very fundamental to most Agile methodologies, and they do a great job of explaining how each of the practices supports the lean philosophies that were discussed at the beginning of the book. Each of the practices is discussed in enough detail from the process standpoint, to make the reader want to know more. They avoid getting into too many technology and platform specific details. However, they often mention frameworks and tools that cover a wide range of platforms, giving the reader ample information to continue their research. The authors also manage to be very up to date in the processes that they discuss, and often mention newer, budding efforts such as Behavior Driven Development and applying the Theory Of Constraints to software development. 

While the practices may be engineering focused, they present them as benefits to the business of software development, which I applaud greatly. Far too many Agile books and discussions are focused entirely inward toward the engineers and project managers, with little to no regard for the customer (other than the standard ‘co-location’ or ‘constant communication’ lines). 

Throughout the book, including the final chapter on ‘What Next’, there are multiple references to existing literature on the various tools, technologies, philosophies and practices, including Lean resources. The last portion of the book is dedicated to listing these references in a well organized, categorical manner. This makes it very easy for the reader to find additional resources on the information provided in the book.

Personally, my favorite chapter of the book was chapter 1: ‘Why Lean’. This chapter introduces many of the problems that we have known about in software engineering. They go on to talk about the Agile Manifesto and mention many of the popular Agile methodologies. The real meat of the chapter, to me, is the explanations used to justify Agile and Lean to the business – actual studies and reports generated from real world projects reported under ‘The CHAOS Study’, with over 40,000 (yes, that’s forty-thousand) projects in the study. I find myself referencing this chapter and this data time and time again. It’s a very enlightening dataset.

### The Bad

There are a few questionable items in the book, in my opinion. I would not say these items are show-stoppers to prevent people from buying the book, though. 

#### **Code Coverage**

The first item that jumped out at me is in Practice 1: Automated Testing. At the bottom of Page 49, they say the following (emphasis is mine, to illustrate where I take issue):

> _**It is unrealistic, and probably not worth the cost, to achieve 100% test coverage of your source code.** For new code and projects that are new to automated testing, 60 to 80% code coverage for your tests is a reasonable target, although seasoned testers will strive for 80 to 95% coverage. There are tools that will examine your source code and tests, and then tell you what your test coverage is (for example, Emma and Cobertura for Java, and NCover for .NET)._

I am disappointed that they would make such a blanket statement without any conditions or explanation. I think the notion that 100% code coverage is ‘unrealistic’ betrays the authors’ personal experience and technologies that they develop against. Yes, there are many cases where 100% code coverage is not reasonable (integration with Sharepoint, for example), but there are plenty of cases where 100% coverage is possible and should be expected. At the very minimum, I would prefer them to say that starting with 100% coverage should be the default, and then to discuss scenarios where this is not reasonable.

#### **Continuous Integration**

The second item that jumped out at me was the overall repetition provided in Practice 2: Continuous Integration. While the chapter itself is very valuable and provides a great amount of information, it is very repetitious. They seem to take the following approach throughout the chapter:

  1. List the benefits 
  2. Describe the benefits in a little detail 
  3. Re-list the benefits and how they support Lean 
  4. Re-describe the benefits in a little more detail and repeat from #3 

It got a little old hearing the same thing over and over and over with just a little more detail each time. That being said, the chapter is still worth reading and properly understanding. They do a great job of describing why CI is important – but do it very repetitively (much like my description, here. 🙂 )

### Summary and Recommendation

From the preface, page ix:

> **_Who Should Read This Book?_** 
> 
> _This book is for software developers and managers of software developers who are new to Lean software development and, possibly, new to Agile software development. It is for those who want to quickly understand why Lean software development is important and what it can do for you._ 
> 
> _This is purposefully a short book, with short chapters. We know that you are just as busy as we are, and we don&#8217;t believe in padding our chapters with useless fluff. In every chapter we try to be as succinct and to-the-point as possible. Our goal is to introduce you to the important topics and resources so that you know where to go when you need more details._

The overall focus on the business value that Lean provides, while introducing the engineering practices makes for a great project management or senior software engineer / team lead level read. There is enough information in this book to hopefully garner the additional research of the readers. I believe the authors have appropriately stated their audience in the preface and have done a phenomenal job of keeping the book short, easy to read, and very informative. 

### Final Score

In light of the two issues that I listed above, I would give this book a 4 out of 5 and recommend it to the same audience that the authors recommend.