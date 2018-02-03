---
wordpress_id: 25
title: The MVC Template Team Got It Right
date: 2009-02-20T16:04:22+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2009/02/20/the-mvc-template-team-got-it-right.aspx
dsq_thread_id:
  - "262055612"
categories:
  - Uncategorized
---
I just created my first project with ASP.Net MVC RC1 and I had a pleasant surprise!!

As with the beta, when you create a new project with the MVC project template, it creates a AccountConroller as part of the startup code.&#160; In the beta, all of the logic to handle user login and authentication was directly in the Action method.&#160; This completely violates Separation of Concerns.

With RC1 this code looks much better, they created IFormAuthentication and IMembershipService interfaces and added them to the constructor (for constructor dependency injection) and now all work is delegated to these interfaces.

Kudus MVC team!! This is the correct design for both SoC and for testing purposes.&#160; For RTM, could you also include the correct unit tests for this controller to further reinforce the need for testing.