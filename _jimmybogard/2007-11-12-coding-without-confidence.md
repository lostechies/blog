---
wordpress_id: 97
title: Coding without confidence
date: 2007-11-12T20:38:48+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/11/12/coding-without-confidence.aspx
dsq_thread_id:
  - "264715412"
categories:
  - Testing
redirect_from: "/blogs/jimmy_bogard/archive/2007/11/12/coding-without-confidence.aspx/"
---
As a favor to my wife, I developed an Excel application to help her employer out with scheduling and status in a small wood manufacturing shop.&nbsp; Excel was chosen as it was the lowest barrier to entry, and the quickest to get out the door.&nbsp; It wasn&#8217;t a mission-critical app and I wasn&#8217;t getting paid or anything, so I thought I could get something delivered fairly easily.

After all, what was needed was &#8220;no big deal&#8221; and &#8220;we just need something that works&#8221;.

The final solution used a lot of hidden columns to calculate intermediate results, and macros to make it easier for the end user to interact with the spreadsheet.&nbsp; The problem is that there are absolutely zero tests on anything, nor can their ever be.&nbsp; There&#8217;s no such thing as &#8220;ExcelUnit&#8221;.&nbsp; I found a &#8220;VBAUnit&#8221;, but it was last released over 4 years ago.

For a while, I couldn&#8217;t figure out why I was so worried about releasing (i.e., emailing them a copy) the Excel app.&nbsp; I realized that **I had been coding without any&nbsp;confidence that what I was delivering worked, and would continue to work**.

I&#8217;ve been so accustomed to having tests and automated builds as my backup, coding without them felt dirty and a little scary.&nbsp;&nbsp;I was asked &#8220;so does it work?&#8221;&nbsp;and my only answer was &#8220;I hope so&#8221;.&nbsp;&nbsp;I was entrenched in&nbsp;&#8220;CyfDD&#8221;, or &#8220;Cross-your-fingers Driven Development&#8221;.&nbsp; Does it work?&nbsp; I dunno, better cross your fingers.&nbsp; CyfDD is a close cousin of &#8220;GoykapDD&#8221;, or &#8220;Get-on-your-knees-and-pray Driven Development&#8221;.&nbsp; Releasing only once per year or two leads to GoykapDD.

Sometimes I get asked why I bother with automated tests and builds.&nbsp; Frankly, **without automated tests and builds**, **I have zero confidence in my code**.&nbsp; Nor _should_ I, or should&nbsp;anyone else for that matter.&nbsp; Confidence in code written without automated tests and builds is just delusion.