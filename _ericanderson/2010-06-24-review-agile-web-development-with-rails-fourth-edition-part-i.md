---
wordpress_id: 4721
title: 'Review: Agile Web Development With Rails, Fourth Edition (Part I)'
date: 2010-06-24T04:21:00+00:00
author: Eric Anderson
layout: post
wordpress_guid: /blogs/eric/archive/2010/06/24/review-agile-web-development-with-rails-fourth-edition-part-i.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/eric/archive/2010/06/24/review-agile-web-development-with-rails-fourth-edition-part-i.aspx/"
---
With a full house of kids, I don&#8217;t get as much of a chance to dabble in technologies that I&#8217;m not using at work.&nbsp; So, I am much more selective in what I choose to learn.&nbsp; I also seemed to be moving jobs enough and bouncing back and forth between the JVM (Java, Groovy) and the CLR (VB.Net, C#) that I was already expanding my language horizon on an annual basis.&nbsp; While, I&#8217;ve been watching Rails from a distance for quite some time, I never seemed to have the bandwidth to take the jump and force myself to sit down and learn it.&nbsp; For whatever reason, I&#8217;ve decided that now is the time.&nbsp; After asking several friends which book to start with, I settled on [_Agile Web Development with Rails_](http://pragprog.com/titles/rails4/agile-web-development-with-rails) [PragPress].

Disclaimer:&nbsp; As of this writing, the fourth edition is still in beta as is Rails 3.&nbsp; I know the book is a work in progress, but I am reviewing it as-is.

## Summary

The purpose of this blog post is to review _Part I: Getting Started_.&nbsp; Part I is divided into four chapters: &#8220;Installing Rails,&#8221; &#8220;Instant Gratification,&#8221; &#8220;The Architecture of Rails Applications,&#8221; and &#8220;Introduction to Ruby.&#8221;&nbsp; These first four chapters are intended to lay the foundation needed to understand the deeper material covered in the rest of the book.&nbsp; Additionally, they serve to whet the appetite of the reader by walking him through some very basic examples.

## Chapter 1: Installing Rails

When I first started looking at Rails, I was using the third edition of this book and installing Rails 2.&nbsp; At the time, I was using my Windows 7 box.&nbsp; I found the walk through for installation to be helpful and complete for getting Rails up and running on Windows.&nbsp; This time around, I decided to go with my Ubuntu linux environment.&nbsp; I still needed to install both Ruby and Rails.&nbsp; And again, I found the guides to be very helpful to get things running.&nbsp; One section that I found a bit jarring was the sidebar entitled, &#8220;Upgrading RubyGems on Linux.&#8221;&nbsp; This sidebar lists several methods for upgrading RubyGems for different versions of RubyGems and different linux distributions.&nbsp; The slightly odd part is that there is no explanation for which method is needed for which setup.&nbsp; Perhaps this is because there are so many linux distributions out there that listing them all would take another page (or more).&nbsp; Regardless, I found it odd that I was encouraged to keep trying the different methods until I found &#8220;the one that works for [me].&#8221;&nbsp; 

The authors have also thoughtfully included a section discussing different editors and integrated development environments (IDE&#8217;s) that are available.&nbsp; When I first read this section in the third edition, I learned about a nice text editor for Windows that I didn&#8217;t know existed ([E-TextEditor](http://e-texteditor.com/)).&nbsp; This time around, I decided to stick with my linux text editor of choice.&nbsp; I briefly looked at using an IDE like RubyMine, but the Rails 3 version is still in beta (since Rails 3 is as well).&nbsp; I decided that sticking with a bare editor was fine for learning.&nbsp; I&#8217;m a command-line junkie anyway.

Overall, I found the installation guide to be plenty thorough.&nbsp; Perhaps that&#8217;s because I intended to work with all of the defaults (including sqlite for a database).&nbsp; Perhaps if I would have deviated more from the happy path, I would have had more of a problem.&nbsp; Then again, the authors have done a good job at pointing the reader to the necessary, external resources when they choose to step away from the default installation.

## Chapter 2: Instant Gratification  


In 13 pages, the reader is walked through creating a Hello, Rails application.&nbsp; This allows the reader to quickly experience the power and simplicity of Rails.&nbsp; Because the chapter accomplishes its goal very well, I don&#8217;t have much to mention.&nbsp; By the end of the chapter, the reader can have a very simple Rails application running in their development environment and handling requests.&nbsp; There are plenty of screen shots in just the right places, and I was never left with a question as to how to do something.

## Chapter 3: The Architecture of Rails Applications
  


  
This chapter covers the basics of the Rails architecture.&nbsp; Models, Views, and Controllers are each discussed in turn.&nbsp; The basic request pipeline is described and illustrated. Additionally, there is a brief explanation of ActiveRecord.&nbsp; The chapter does a good job of teaching where different code concerns go within the architecture.&nbsp; The responsibilities of the Model, View, and Controller are covered well.&nbsp; Perhaps my reading of this chapter is skewed because I&#8217;ve worked with multiple MVC platforms already.&nbsp; However, I found that the topics were covered in sufficient (brief) detail.&nbsp; By the end of the chapter, the reader has a good idea of how the various files are laid out within a Rails application and what responsibilities are addressed by each of the major components of the system.

## Chapter 4: Introduction to Ruby
  


  
This chapter is new for the fourth edition, and I found it to be a very welcome addition.&nbsp; Having never coded in Ruby before, I found this chapter to be quite informative.&nbsp; The authors assume that the reader knows nothing about Ruby.&nbsp; Since I am squarely in the target audience for this chapter, I can honestly say that I learned a great deal here.&nbsp; The authors have covered object-orientation, data types, logic, and structures.&nbsp; 

The authors also cover a small set of Ruby idioms.&nbsp; I found this to be very helpful since the bulk of my programming experience is in static languages.&nbsp; The coverage of Ruby idioms is only slightly longer than a single page, but I&#8217;ve already found it useful.

## Conclusion
  


  
So far, I&#8217;ve found this book to be a very enjoyable, informative read.&nbsp; I look forward to continuing on (and to posting some reviews).