---
id: 215
title: 'Heartbleed Hotel: The biggest Internet f*ckup of all time'
date: 2014-04-09T04:36:43+00:00
author: Brad Carleton
layout: post
guid: http://lostechies.com/bradcarleton/?p=215
dsq_thread_id:
  - "2597697153"
categories:
  - heartbleed
  - internet
  - Web
tags:
  - heartbleed
---
<p dir="ltr">
  The heartbleed bug is the single biggest f*ckup in the history of the Internet.
</p>

<p dir="ltr">
  For anyone that doubts the veracity of this claim let me state the plain and simple facts:
</p>

> <p dir="ltr">
>   Since December of 2011 any individual with an Internet connection could read the memory of maybe half of the &#8220;secure&#8221; Web servers on the Internet.
> </p>

<p dir="ltr">
  For the layman, reading the memory of a Web server often means being able to read usernames, passwords, credit card numbers and basically anything else that the server is doing.
</p>

<p dir="ltr">
  Shocking.
</p>

<p dir="ltr">
  For over two years we&#8217;ve all had our pants down and no one even noticed.
</p>

<h2 dir="ltr">
  Open Source Failed
</h2>

For most developers, myself included, open source has been a mythical paradigm shift in software development that should be embraced without question.

What of bugs?  There&#8217;s a famous adage about bugs in open source:

> <p dir="ltr">
>   Given enough eyeballs, all bugs are shallow
> </p>

<p dir="ltr">
  Applied to this case, the buffer overflow in the hearbeat protocol should have been easily found by someone.  But it wasn&#8217;t.
</p>

<p dir="ltr">
  After the heartbleed bug, can this statement of open source fact still be considered valid?  What does it mean to have eyes on code.
</p>

<p dir="ltr">
  If I wanted to look at the code for OpenSSL, I could have.  Guess what?  I never did, and I would bet that most of the people reading this article didn&#8217;t either.
</p>

<h2 dir="ltr">
  The Ultimate Humiliation for Public Key Infrastructure
</h2>

It&#8217;s long been known that our current public key infrastructure was horribly broken.  Mostly, proven by numerous compromises of the supposed &#8220;sources of trust&#8221;, the certificate authorities.

Broken and run roughshod over by the likes of the NSA, hackers and other government agencies over the globe.

This latest episode is really just icing on the cake.  Not only are the private keys of &#8220;secured&#8221; servers up for grabs, but so is their most sensitive and personal data.

<p dir="ltr">
  I think it’s time we as an industry take a good hard look in the mirror, and reevaluate&#8230; everything.
</p>