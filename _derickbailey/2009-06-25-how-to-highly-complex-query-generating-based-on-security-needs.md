---
wordpress_id: 63
title: How To? Highly Complex Query Generating Based On Security Needs
date: 2009-06-25T20:26:29+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/06/25/how-to-highly-complex-query-generating-based-on-security-needs.aspx
dsq_thread_id:
  - "262068237"
categories:
  - .NET
  - 'C#'
  - Data Access
  - Security
  - Unit Testing
redirect_from: "/blogs/derickbailey/archive/2009/06/25/how-to-highly-complex-query-generating-based-on-security-needs.aspx/"
---
I have the following object model:

&#160; <img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="508" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_38648237.png" width="512" border="0" /></p> 

An Office belongs to one Office Group. An Office also belongs to one Office Region. There is no relationship between Office Group and Office Region. They are two separate groupings for various reasons. A Counselor belongs to one Office. A Veteran is assigned to one Office.

I need to implement the following security rules for a Counselor looking at Veterans, starting with “deny access to all Veteran records, unless any of the following are true”:

  1. If a Counselor is an Administrator (a role of the Counselor), that Counselor can see all Veteran records 
  2. A Counselor can see any Veteran that has no current Office assignment 
  3. A Counselor can see Veterans that are assigned to an Office within the Counselor’s Office Group 
  4. If a Counselor belongs to a “Regional Office”, that Counselor can see Veterans that are assigned to that Region 
  5. … a few others in similar fashion … 

I also need to implement the following around the above rules:

  1. When a Counselor searches for Veterans, they are only allowed to see search results that meet the above criteria 
  2. When a Counselor views the detail of a Veteran, they are only allowed to see the the Veteran if the above criteria is met. This includes, if a Counselor tries to manually load a Veteran (manually type in url “id=1234”)
  1. … and the Counselor is not allowed to see the Veteran, show a “Not Authorized” message 
  2. … and the Vet does not exist, show a “Vet Does Not Exist” message 

so…

how do you create a search process around a security need like this? How do you go about creating a very complex rule system to determine which Veterans the Counselor can see? In my ideal world, I’d have some way of checking this security need against the search results and against an individual veteran record, without duplicating the code or logic for that check anywhere… is this a realistic expectation? What “standard” security implementations are out there, that would help me resolve my needs?

This is being done in C# in an ASP.NET Webforms app, using NHibernate for our ORM. I don’t expect NHibernate to be able to solve this problem for us, but if it can, that’s even better. And, I do expect to be able to write some sort of Unit or Integration tests around whatever the process is.

Any advice or help is appreciated.