---
id: 206
title: 'Mocks, Stubs and Unreadable Tests: Clearly I&#8217;m Doing This Wrong'
date: 2011-01-14T03:31:14+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2011/01/13/mocks-stubs-and-unreadable-tests-clearly-i-m-doing-this-wrong.aspx
dsq_thread_id:
  - "264543705"
categories:
  - AntiPatterns
  - Principles and Patterns
  - Quality
  - RSpec
  - Test Automation
  - Testing
  - Unit Testing
---
I tweeted this a few minutes ago:

[<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-01-13-at-9.18.38-PM.png" border="0" alt="Screen shot 2011-01-13 at 9.18.38 PM.png" width="526" height="221" />](http://twitter.com/#!/derickbailey/status/25752002038333440)

This is in reference to a horrible test that I wrote today. It&#8217;s got 2 assertions and more than 20 lines of context to set up the mocks that I needed, to isolate things and prove what I wanted to prove.</p> 

As a reference point, here&#8217;s the implementation the class under test:</p> 

In the [same](http://www.lostechies.com/blogs/jimmy_bogard/archive/2011/01/06/putting-mocks-in-their-place.aspx) [thread](http://www.lostechies.com/blogs/jimmy_bogard/archive/2011/01/11/shifting-testing-strategies-away-from-mocks.aspx) of [thinking](http://www.lostechies.com/blogs/jimmy_bogard/archive/2011/01/12/defining-unit-tests.aspx) that Jimmy has been posting about recently (which I&#8217;m in 100% agreement with), I want to get away from writing ugly tests like this. I&#8217;m clearly breaking all the principles that Jimmy is talking about &#8211; I&#8217;m exposing a lot of detail of the implementation of the class under test, I&#8217;m creating a very brittle test that will break with any small change to the class under test, and I&#8217;m making it very painful for me to change this part of the system because the tests are getting in my way.

Here&#8217;s the problem I have with a lot of the talk concerning bad tests&#8230; it&#8217;s wonderful talk, but it&#8217;s nothing more. I&#8217;m reading Jimmy&#8217;s posts and I&#8217;m thinking that he&#8217;s on to something, but I&#8217;m always left with a giant question at the end: how do I \_not\_ do what you&#8217;re talking about?

What are the alternatives to this? How can I improve my test, in this scenario? Am I missing something simple like an object mother or a context class? Should I be letting the actual classes run in this case, which would require a fairly significant amount of setup data including a number of .haml template files that need to be read / processed?

I&#8217;m looking for real-world examples of how to solve real-world testing problems. It doesn&#8217;t really matter what language the tests are written in: Ruby, C#, Java, Python&#8230; I&#8217;ll even take C++ if your solution is understandable and illustrates the principles of good test design.

Post links to your solutions to this type of problem in the comments.