---
wordpress_id: 56
title: NHibernate 3 Beginners Guide published
date: 2011-08-29T19:56:52+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/2011/08/29/nhibernate-3-beginners-guide-published/
dsq_thread_id:
  - "399527253"
categories:
  - book
  - introduction
  - NHibernate
  - tutorial
---
[<img style="background-image: none; padding-left: 0px; padding-right: 0px; display: inline; float: left; padding-top: 0px; border: 0px;" title="image" src="https://lostechies.com/content/gabrielschenker/uploads/2011/08/image_thumb.png" border="0" alt="image" width="198" height="244" align="left" />](https://lostechies.com/content/gabrielschenker/uploads/2011/08/image.png)

I am very pleased to announce that my book [NHibernate 3 Beginners Guide](http://www.packtpub.com/nhibernate-3-beginners-guide/book) has finally been published. It is a wonderful feeling to finally have a book in my hands that cost me a couple of months of intense work. But I think the result is well worth it.

If you are interested in the book then there is also a [free chapter](http://www.packtpub.com/sites/default/files/6020OS-Chapter-3-Creating-a-%20Model.pdf?utm_source=packtpub&utm_medium=free&utm_campaign=pdf) available for download.

I was lucky to have [Fabio Maulo](http://fabiomaulo.blogspot.com/) and [José F. Romaniello](http://joseoncode.com/) as my reviewer, the former being the lead of the [NHibernate](http://www.nhforge.org) project and the latter an active contributor to the the project.

My goal for this book has been to provide an easy to follow introduction to NHibernate 3.x. The text covers NHibernate up to version 3.1 GA and even references some of the new features of NHibernate 3.2 GA. It was very important to me to not use a data centric approach but rather choose a **model first** approach.

In this regard this book is NOT just an updated version of [NHibernate 2 Beginners Guide](https://www.packtpub.com/nhibernate-2-beginners-guide/book) but rather a complete rewrite.

I also have paid attention to cover all foundational topics in a clear and concise way. In no way did I want to abandon the reader in the dust of uncertainty.

Let me provide you the list of chapters found in the book with a short introduction about the respective content of each chapter.

**Chapter 1, First Look…** explains what NHibernate is and why we would use it in an application that needs to access data in a relational database. The chapter also briefly presents what is new in NHibernate 3.x compared to the version 2.x and discusses how one can get this framework. Links to various sources providing documentation and help are presented.

**Chapter 2, A First Complete Sample…**walks through a simple yet complete sample where the core concepts of NHibernate and its usage are introduced.

**Chapter 3, Creating a Model…** discusses what a domain model is and what building blocks constitute such a model. In an exercise the reader creates a domain model for a simple ordering system.

**Chapter 4, Defining the Database Schema…**explains what a database schema is and describes in details the individual parts comprising such a schema. A schema for the ordering system is created in an exercise.

**Chapter 5, Mapping the Model to the Database…**teaches how to bridge the gap between the domain model and the database schema with the aid of some wiring. This chapter presents four distinct techniques how the model can be mapped to the underlying database or vice versa. It is also shown how we can use NHibernate to automatically create the database schema by leveraging the meta-information contained in the domain model.

**Chapter 6, Sessions and Transactions…**teaches how to create NHibernate sessions to communicate with the database and how to use transactions to group multiple tasks into one consistent operation which succeeds or fails as a whole.

**Chapter 7, Testing, Profiling, Monitoring and Logging…**introduces how to test and profile our system during development to make sure we deliver a reliable, robust and maintainable application. It also shows how an application can be monitored in a productive environment and how it can log any unexpected or faulty behavior.

**Chapter 8, Configuration…** explains how we can tell NHibernate which database to use, as well as provide it the necessary credentials to get access to the stored data. In addition to that many more settings for NHibernate to tweak and optimize the database access are explained in this chapter.

**Chapter 9, Writing Queries…** discusses the various means how we can easily and efficiently query data from the database to create meaningful reports on screen or on paper.

**Chapter 10, Validating the data to persist…**discusses why data collected by an application needs to be correct, complete and consistent. It shows how we can instrument NHibernate to achieve this goal through various validation techniques.

**Chapter 11, Common Pitfalls – Things to avoid…** as the last chapter of this book presents the most common errors developers can make when using NHibernate to write or read data to and from the database. Each such pitfall is discussed in details and possible solutions to overcome the problems are shown.