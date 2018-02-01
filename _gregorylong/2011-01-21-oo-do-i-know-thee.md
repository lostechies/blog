---
id: 4794
title: OO Do I Know Thee?
date: 2011-01-21T22:13:00+00:00
author: Gregory Long
layout: post
guid: /blogs/thatotherguy/archive/2011/01/21/oo-do-i-know-thee.aspx
dsq_thread_id:
  - "265182807"
categories:
  - OO Concepts
  - Programming
---
I was first introduced to the OO Programming Paradigm through JAVA in 1998. &nbsp;Before that I did most of my work in C or shell scripts. &nbsp;I liked it well enough but for business applications the paradigm felt wrong. &nbsp;JAVA was a breath of fresh air and &#8211; at first &#8211; it seemed so natural. &nbsp;I was indoctrinated into the well known 4 Concepts of OO and the whole Is A vs Has A relationships. &nbsp;I dutifully created my Parent Objects which then had more specific Children (Dog Is A(n) Animal). &nbsp;And it quickly began to feel as awkward as procedural programming. &nbsp;In fact it was worse, because of a sense that my initial &#8220;this is so natural&#8221; reaction was correct and I must have taken a wrong turn.

This last year has seen a major shift in how I perceive what OO is and how well (or not so well) the languages I&#8217;ve used represent or support OO. &nbsp;The sequence happened a bit like this:

First I went to Nothing But .Net and had many of my ideas about .Net stripped away. &nbsp;It would be fair to say I left with more questions than answers but they were questions I&#8217;d been looking for since my JAVA days.

Then I learned Objective C and with it new questions around what an object is, what it does, and how are they connected. &nbsp;And do they always have to be connected?

Then I started playing with Ruby and found even more questions about objects, behaviors, abstraction, and an OO application.

All of which has lead me to this &#8211; I still don&#8217;t know The Truth about OO but I have a pretty good idea what it isn&#8217;t. &nbsp;A better way to say this is: I have a better idea why my initial feeling was so strong and where I diverged from the &#8220;it just makes sense&#8221; view of OO. &nbsp;Some of those errors (in no particular order):

An Object is an encapsulates data and behaviors around that data. &nbsp;Wrong. &nbsp;Nope, not even going there. &nbsp;Wrong. &nbsp;Wrong. &nbsp;Wrong. &nbsp;This doesn&#8217;t mean an object can&#8217;t have data and behaviors. &nbsp;Having and being are different things. &nbsp;Don&#8217;t confuse them.

Inheritance is a parent-child relationship. &nbsp;Incomplete. &nbsp;The parent-child metaphor has way too much meaning and side-effects that have no place in the idea of Inheritance. &nbsp;Don&#8217;t confuse them.

(C#) Interfaces are an abstract representation of a responsibility. &nbsp;Too inflexible and limiting. &nbsp;Narrows the scope of what they can be by (ironically) assigning them too broad a role in an application.

Abstraction is primarily expressed through Interfaces and Abstract Classes. &nbsp;Perhaps that is a vehicle supplied in a particular language but Abstraction is not organically connected to any mechanism to express it. &nbsp;Thinking of it in linguistic programming terms limits it&#8217;s meaning and our ability to exercise it.

I could go on to list many of the design patterns and principles you may have heard, including SOLID. &nbsp;I&#8217;ve held most of these in an almost holy status at one point or another. &nbsp;None of them hold The Key to OO nirvana and many of them &#8211; when viewed from an inappropriate perspective (which I often did) &#8211; can distract you from the potential and power of OO.

Lastly, from the time of my euphoric introduction to JAVA until (painfully) recently I treated OO like a sacred hammer and saw most meaningful programming challenges as eager nails. &nbsp;Sad-but-true.

I now see OO as a useful paradigm to consider for human process driven applications (e.g. an application designed to mimic or assist in tasks a human would/could do). &nbsp;With that broad definition I would understand people thinking I still have a magic hammer and see everything as a nail. &nbsp;The reality for me is more subtle &#8211; so much so that I won&#8217;t elaborate in this post &#8211; and I&#8217;m beginning to see many problems I _can_ solve with OO but I don&#8217;t feel I _have_ solve with OO.

I know I haven&#8217;t supplied many answers in this post. &nbsp;You don&#8217;t need my answers. &nbsp;You don&#8217;t really even need my questions. &nbsp;You need your own questions and your own answers. &nbsp;I hope mine can help you find yours.