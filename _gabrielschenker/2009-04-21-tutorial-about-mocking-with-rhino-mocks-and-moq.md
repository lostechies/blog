---
wordpress_id: 22
title: Tutorial about mocking with Rhino Mocks and Moq
date: 2009-04-21T10:01:36+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2009/04/21/tutorial-about-mocking-with-rhino-mocks-and-moq.aspx
dsq_thread_id:
  - "263908862"
categories:
  - Mock
  - mocking framework
  - tutorial
redirect_from: "/blogs/gabrielschenker/archive/2009/04/21/tutorial-about-mocking-with-rhino-mocks-and-moq.aspx/"
---
I was asked to write a tutorial about mocking with Rhino Mocks on [DotNetSlackers](http://dotnetslackers.com).

## Introduction

When using TDD to develop an application it is essential that the system under test (SUT) can be tested in isolation. That is, only the class that I am currently developing is “real” and all other parts are simulated or faked. If my SUT needs to collaborate with other components those other components are mocked during the test. We can either manually implement such mock objects or use a mocking framework for this task. There exist several well known mocking frameworks for the .NET platform. In this article I’ll give a short introduction in the two most used OSS mocking frameworks. The first is Rhino Mocks which was developed by Oren Eini, aka Ayende and the other one is Moq developed by Daniel Cazzulino.

&#160;

The first part of this tutorial is now online and can be seen [here](http://dotnetslackers.com/articles/designpatterns/To-mock-or-not-to-mock-that-is-the-question-Part-1.aspx).