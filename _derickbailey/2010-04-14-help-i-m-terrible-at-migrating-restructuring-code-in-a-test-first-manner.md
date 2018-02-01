---
id: 139
title: Help! I’m Terrible At Migrating/Restructuring Code In A Test-First Manner
date: 2010-04-14T16:05:45+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/04/14/help-i-m-terrible-at-migrating-restructuring-code-in-a-test-first-manner.aspx
dsq_thread_id:
  - "262068652"
categories:
  - AntiPatterns
  - Continuous Improvement
  - Craftsmanship
  - Model-View-Presenter
  - Philosophy of Software
  - Pragmatism
  - Unit Testing
---
I’ve spent the last day or so restructuring some code – specifically converting a WinForms form into a user control so that I can host the control in several different forms that need it. This involves changing the presenter for the original form, the form itself, the view interface for the form and then re-creating these as the user control. 

I’ve noticed that when I do something like this I tend to hack at it from the implementation first and then go back and migrate the unit tests later (often commenting out unit tests as I’m going just to get the changes made first). I know intellectually that I should be migrating my code via test-first development efforts… but I seem to be lacking the knowledge to get that done correctly.

So, I wanted to ask: how do you go about migrating code like this? Do you take a test-first approach? If so, what tips and tricks can you share to help me learn this aspect of test-first development?