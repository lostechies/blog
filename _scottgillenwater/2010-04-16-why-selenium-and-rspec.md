---
wordpress_id: 7
title: Why Selenium and Rspec?
date: 2010-04-16T00:54:00+00:00
author: Scott Gillenwater
layout: post
wordpress_guid: /blogs/stgillen/archive/2010/04/15/why-selenium-and-rspec.aspx
categories:
  - automate
  - Hudson
  - RSpec
  - Selenium
---
<span style="text-decoration: underline"><b>Introduction</b></span>

A year ago, I was put to the task, with the help of Joe Ocampo (fellow los techie) to have automated UI tests that everyone in a Development/QA environment (all levels of experience) can help with.&nbsp; We wanted to have a framework/DSL that had the following objectives:

  1. Main Objective &#8211; Team Involvement (again all levels of experience in Development/QA Environment to assist in test creation)
  2. Readability
  3. Maintainable 
  4. Scalable 
  5. Tests suitable for Agile environment w/ ability to be executed through a CI Server

Based on prior experience using commercial UI automated tools, some of these principles we based on flaws of those tools, so we wanted to go the open source route, and the obvious choice was selenium.&nbsp; At the time I had some experience writing selenium tests in python, plus I did create a selenium multi-thread runner in python by simply modifying unit-test library in python to accept threads. I was committed to using selenium just for solving the scalable objective (by utilizing selenium-grid).&nbsp; This still didn&#8217;t solve the main objective of having Team Involvement.&nbsp; This is were Joe had the vision of having me look into using of Rspec.&nbsp; With the combination of Selenium and Rspec, we were able to solve all the objectives. 

<span style="text-decoration: underline"><b>Team Involvement</b></span>

With Rspec, manual testers could now participate in writing specs (which could replace the need to writing manual tests, because it is the manual test)

Manual testers could still write tests as you would in any manual testing tool (Action &#8211; Expected Result)

Example of pending spec (Manual test):

![](/cfs-file.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/stgillen.rspec/pendingSpecExample.jpg)

&nbsp;

Using the power of Rspec; testers can easily write tests in this format. Once a spec has been written, trained QA testers will then &#8216;fill in&#8217; the
   
test with automation test. This gives QA a more agile approach as far as keep the manual and
  
automation test together in one file.&nbsp; The spec gives QA the opportunity to run the automated tests manually if
  
failure occurs.

<span style="text-decoration: underline">Example of automated spec</span>:

![](/cfs-file.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/stgillen.rspec/passingSpecExample.jpg)

<span style="text-decoration: underline"><b>Readability</b></span>

With the framework/DSL created and using Rspec assertions, it even allows the automation code to be easily read and reduces the need to know selenium api commands.&nbsp; Selenium and Rspec have their own Selenium Test Formatter that will print out beautiful reports, that can be read by anyone in the
   
business, print screenshots, and capture selenium server logs in event of test
  
failure.&nbsp; 

<span style="text-decoration: underline">Example of passing test:</span>

![](/cfs-file.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/stgillen.rspec/passingRspecReport.jpg)

<span style="text-decoration: underline"><b>Maintainability </b></span>

Specs will be written in a QA test repository (centralized), which will allow the reuse of code from other projects or applications automated.&nbsp; (Object-Oriented Approach) objects and element classes will be
  
centralized and only maintained in one place, to make updates easier to
  
maintain.

<span style="text-decoration: underline">Example of object classes:</span>

![](/cfs-file.ashx/__key/CommunityServer.Blogs.Components.WeblogFiles/stgillen.rspec/objectLevelExample.jpg)

<span style="text-decoration: underline"><b>Scalability </b></span>

Utilizing Selenium Grid and multiple Selenium Servers, specs can be run on
  
multiple threads to decrease the amount of time to run the spec.

<span style="text-decoration: underline"><b>Tests suitable for Agile environment w/ ability to be executed through a<br /> CI Server</b></span>

Using this format manual specs can be written before development begins and automation can be filled in during and/or completion of development.&nbsp; Writing Rake tasks to execute tests and using Hudson CI Server, selenium-grid plugin, and rake plugin, tests can easlly run and tracked.&nbsp; 

More to come!

&nbsp;

&nbsp;

&nbsp;