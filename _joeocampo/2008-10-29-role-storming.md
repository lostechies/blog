---
id: 122
title: Role Storming
date: 2008-10-29T03:06:00+00:00
author: Joe Ocampo
layout: post
guid: /blogs/joe_ocampo/archive/2008/10/28/role-storming.aspx
dsq_thread_id:
  - "262089547"
categories:
  - 'Agile Project Coaching &amp; Management'
  - Agile Teams
---
**UPDATE: This excercise is ideal for large projects with many SME&#8217;s in the room. &nbsp;In this case I was building a Loan Orgination System for a bank with 10+ SME&#8217;s in the room that were all arguing with each other about the Persona&#8217;s and thier behaviors this took two days to do but the outcome was well worth the effort. If you have 1-4 SME&#8217;s this is possibly overkill. &nbsp;Be pragmatic not dogmatic.**&nbsp;

<img width="385" height="257" style="float: right;margin-top: 5px;margin-bottom: 5px" src="http://farm4.static.flickr.com/3236/2743011951_abf5d55723.jpg?v=0" alt="Scott Butner's Flicker photostream" />

Occasionally I am brought in to facilitate story break down sessions. I have to admit that this is one of the more enjoyable aspects for me when dealing with large Agile project because it allows me to learn a ton of information about the business domain. 

One of the first exercises I go through is a Roles Storm. This is an exercise that gets the customer to think about the different types of behaviors that certain roles and personas can perform in their software that they are asking you to build. This exercise helps me to hold story authoring sessions in the future. 

I try to focus the discussion towards the lowest level persona that does something. The template of the exercise is very simple: 

> A {Persona/Role} can &hellip;

In this case I will use the &ldquo;Loan Rep&rdquo; persona. 

> A Loan Rep 
> 
> &#8211; can view their own pipeline 
> 
> &#8211; can order a credit report

Once we establish the lowest common denominator you simply move up the chain: 

> A Processor 
> 
> &#8211; can do everything a Loan Rep can do and 
> 
> &#8211; can upload to desktop originator and loan prospector

As you can see I am able to start identifying lots of domain concepts. DO NOT try to dive deep with this exercise. Its focus is around brainstorming of Personas and Roles only. Let the customer do most of the talking. Do not let this turn into a technical discussion. 

**WARNING: This list does NOT contain stories, it contains concepts for stories but it does NOT contain stories!!!!** 

Preparation time for this exercise is a few minutes but the event usually last at least a full day. 

In the end you end up with a list that looks something like this: 

### Roles

#### Back Office (Centralized Admin)

##### Super User

  1. can do what the help desk manager and business admin can do, 
  2. can defines profiles, 
  3. can maintains universal system tables, 
  4. has access to the entire application, 
  5. can delete loan records from the system, (flag to stop display of record in any pipeline view &ndash; only available to admin and can be identified on reports.) 
  6. can update mortgage center home page content, 
  7. can create admin users, 

##### Help Desk Manager

  1. can do what a team lead can do, 
  2. can be given the permission to delete loan records from the system, 
  3. <revisit> can reset loan events, 

##### Help Desk Team Lead

  1. can do what a help desk user can do 
  2. can add and maintain users, 
  3. can create and maintain loan centers, (full name of lender in table &ndash; online view would be an abbreviated version) 
  4. can maintain peer level admin profiles or lower, 
  5. can pull lead between reps and processors within a loan center, 
  6. can push lead and loan records to other loan centers, 

##### Help Desk

  1. can add and maintain mortgage center users, 
  2. has system wide read only access, 
  3. can invoke a system wide search 

##### Business Admin (Centralized)

  1. can add and maintain loan programs and fee schedules, 
  2. <revisit> can create and maintain printable documents, 
  3. <revisit>can maintain dropdown tables (ex. Marketing codes, loan conditions), 
  4. can add new contact types and global contacts. 

##### Loan Office Admin (Loan Center)

  1. can pull lead between reps and processors within their loan center(s), 
  2. can push lead and loan records to other loan centers, 
  3. can modify user permissions within their specified role within their loan center, 
  4. can make a user inactive or active within their loan center, 
  5. can make user available or unavailable within their loan center, 
  6. <revisit> shared roles, 
  7. can be given access to assign loan to themselves, 

#### Field Roles

##### Loan Center Manager 

  1. can do everything a processor can do, 
  2. can pull lead between reps and processors within their loan center, 
  3. can push lead and loan records to other loan centers, 
  4. can modify user permissions within their specified role within their loan center (include permissions to access loan center pipeline) 
  5. can make a user inactive or active within their loan center, 
  6. can make user available or unavailable within their loan center 
  7. Can delete leads across loan centers and users (no credit ordered) 

##### Processor

  1. can do everything a loan rep can do and 
  2. can upload to desktop originator and loan prospector, 
  3. can export FNMA 3.2 file, 
  4. can add and maintain conditions to a loan, 
  5. can submit loan package to lender, 
  6. can print all documents, 
  7. can add and update lender denial and counteroffer, 
  8. can view all teams pipelines within their loan center, 
  9. can edit any lead or application within their loan center, 
 10. can run reports for their loan center. 

##### Loan Rep

  1. can add and edit & delete their leads in the system but cannot delete an application (credit has been ordered), 
  2. can view their own pipeline, 
  3. can order credit, 
  4. can include and exclude liabilities from the 1003 section, 
  5. can complete full 1003, 
  6. can order appraisal, 
  7. can order title, 
  8. can add notes to conversation log, 
  9. can add contacts, 
 10. can create rate locks, 
 11. can print 3 day disclosures, 
 12. can select loan programs and fee schedules, 
 13. can print the 1003 blank or otherwise, 
 14. can import 1003, 
 15. can view and print rate sheets, 
 16. can flag loan as withdrawn, 
 17. <revisit> task creation and assignment, 
 18. can submit lead to processor, 
 19. can push lead to another user, 
 20. can collect and record upfront fees, 
 21. can run reports for their pipeline, 
 22. can make themselves available or unavailable 
 23. can be given permission to pull from loan center pipeline (public queue)