---
wordpress_id: 354
title: Thanks Houston TechFest!
date: 2009-09-28T12:41:01+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/09/28/thanks-houston-techfest.aspx
dsq_thread_id:
  - "265527686"
categories:
  - ASPNETMVC
---
This past weekend I gave a talk on one of my favorite topics – UI testing.&#160; In it, I focused almost exclusively on techniques for authoring maintainable UI tests, and how design for testability extends to views, models and controllers in MVC land.&#160; It’s trivial to write UI tests that break easily, but not much more difficult to write maintainable tests, given that you’ve intentionally designed your UI layer for UI testability.

Big thanks to the Houston TechFest organizers, who put on a fantastic conference, and to all the attendees, who had to put up with me for an hour.&#160; For those that are interested, you can find the code and slides here:

[Testing the Last Mile in ASP.NET MVC code and slides](http://grabbagoftimg.s3.amazonaws.com/uitesting-trunk.zip)

I had a lot of people asking about the wrappers on top of our browser automation tool, WatiN, and if they were open source.&#160; The answer is no, not yet, but we’re working on it.&#160; A quick road to fragile UI tests is browser automation code directly in your UI tests, so the sample code provided should at least provide some ideas and guidance to craft your own wrappers.&#160; And as always, my door is always open for questions.&#160; My email door, at least.