---
id: 956
title: 'I&#8217;m Wring A Book On Building Backbone Plugins'
date: 2012-07-06T18:17:06+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=956
dsq_thread_id:
  - "754399128"
categories:
  - Backbone
  - Books
  - Jasmine
  - WatchMeCode
---
A few weeks ago I published a screencast on [building Backbone plugins](http://www.watchmecode.net/backbone-plugin) (paid). In this screencast, I walk and talk through the steps that I take to build, test, package and deploy some of the plugins and projects that I build for Backbone. But that screencast could only go so far, and only provide so much information. I quickly followed up with two additional screencasts (both free): [AMD Builds With Grunt And Rigger](http://www.watchmecode.net/amd-builds-with-grunt), and [Annotated Source Code With Docco](http://www.watchmecode.net/annotated-code-with-docco). But the truth is, there is a lot more going on in side my head than I&#8217;m able to express in this kind of time frame and medium. So, to add to the knowledge base and explore some of finer points, lessons learned, principles and patterns that are involved in building useful plugins as both open source projects and project-specific abstractions, I&#8217;m writing a book.

## Building Backbone Plugins, Add-Ons, And Abstractions

This is my working title for the book. I know it&#8217;s very utilitarian and dull, but that&#8217;s fine right now. It gets the point across about what the book contains at this point. But real value in the book is not just how to build these things. The real value is in identifying the principles and patterns, and the lessons that can be learned from writing Backbone applications and abstractions, allowing us to build even more amazing systems, even faster, in the future. 

At this time, I don&#8217;t have a publisher lined up. I am planning on pitching this to 1 or 2 or more, hoping to get it in with someone. I have some in mind and have started conversations already. Ultimately, this book will be published even if it just comes through me using LeanPub or something similar. I plan on finishing the vast majority of the content before really pitching to anyone, though. 

And on the subject of content&#8230;

## The Intent And Some Content

I already have an ok/rough outline for the book. The outline has been through a few rounds of feedback from some close friends, and has been majorly overhauled from what I started with. I&#8217;m happy with it right now, but I know it will change.

I&#8217;ve also written the core of the preface to introduce the book and what it contains, and the first pass at the first 5 1/2 chapters. I&#8217;m happy with the progress that I&#8217;ve made and I hope to get the first pass at the majority of the content done within the next 2 to 3 months. I fully expect to re-write most of it a few times once it goes in to review and editing, but that&#8217;s another story 🙂

To give you an idea of what this book will really be about, here&#8217;s the opening paragraphs that I&#8217;ve written for the preface of the book.

> Building Backbone.js applications without the use of plugins, add-ons and project-specific abstractions is a waste of time and money.
> 
> If every feature of every system (in any language, on any platform) had to be built form the ground up, no one would deliver anything of real value. Instead, we build systems on top of systems &#8211; the abstractions, plugins, libraries and frameworks that perform the core functions of the platform and infrastructure we need. But even with the use of existing add-ons and abstractions, the understanding of how to effectively build your own abstractions and re-usable components is a necessary part of software development. And JavaScript and Backbone.js applications are no different than any other application or system in this regard. It is our responsibility as developers, technical leads and architects, then, to look for ways to effectively use and create re-usable plugins, add-ons and abstractions.
> 
> But while Backbone is no different than any other system in the need for abstractions, it does provide some unique and interesting ways in which we can build our reusable peices. And having an understanding of how to use Backbone effectively means more than just using the existing components that it comes with, or existing plugins built by other developers. It means understanding how all of the peices fit together, and how those peices can be extended and augmented. It means understanding how to pull apart the general needs of a component to create something that can be extended in to a specific scenario. And it means knowing how to recognize and extract the patterns that we create in our own applications, in to re-usable components that may be deliverable as plugins and add-ons in themselves.
> 
> This book, then, will show you how to effectively use Backbone.js by building abstractions, add-ons and plugins for your own applications and as open source projects. It will give you the knowledge you need to work with the components that Backbone includes, build complementary objects to be used within JavaScript and Backbone applications, and ultimate save time and money while delivering features faster.

## The Next Few (Many?) Months

Between writing this book, working on open source projects, and paying client work, I haven&#8217;t been blogging much lately. I knew this would happen which is one of the reasons that I have delayed writing a book for so long. Creating content &#8211; whether it&#8217;s blog posts, answer StackOverflow questions, building the Wiki for Backbone.Marionette, screen casting or writing a book, takes a ton of mental energy. It&#8217;s fun and I love doing all of it, but I have to go in cycles. I&#8217;ve been on a book writing and wiki building cycle for a while, and other bits are suffering. But I felt it was time to actually get something done, in spite of this, and I&#8217;m doing it. 

I hope to not leave this blog empty for long, though. I plan on getting back in to writing here &#8211; but the subject matter will be slightly different. I won&#8217;t be posting much about the book, and maybe not much about Backbone. But the subject of what is to come for this blog will be another blog post, soon.