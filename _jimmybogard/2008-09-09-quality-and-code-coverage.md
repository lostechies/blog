---
wordpress_id: 227
title: Quality and code coverage
date: 2008-09-09T11:59:17+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/09/09/quality-and-code-coverage.aspx
dsq_thread_id:
  - "265199650"
categories:
  - TDD
  - Testing
redirect_from: "/blogs/jimmy_bogard/archive/2008/09/09/quality-and-code-coverage.aspx/"
---
It&#8217;s an age-old question: should our team&#8217;s goal be 100% coverage?&nbsp; A valid question, but one I&#8217;ve never much cared about in practice.&nbsp; The idea is that the team, all practicing TDD, should dutifully measure and add unit tests until they reach the _assumed_ pinnacle of unit testing: 100% coverage.

The general motivation behind 100% coverage is that 100% coverage equals zero bugs.&nbsp; But what _exactly_ is 100% coverage?&nbsp; Coverage of _what_?&nbsp; Wikipedia lists several kinds of coverage measures:

  * Function coverage
  * Statement coverage
  * Condition (Branch) coverage
  * Path coverage
  * Entry/exit coverage

One of the most popular code coverage tools in .NET is [NCover](http://www.ncover.com/), which supports:

  * Function coverage (implicitly)
  * Statement coverage
  * Branch coverage (Enterprise edition only)

NCover is a powerful tool, but it still doesn&#8217;t support all types of coverage.&nbsp; Attaining 100% coverage in NCover still means there are paths that we haven&#8217;t tested yet, which means there are still potential bugs in our code.&nbsp; If 100% coverage is a goal, stopping with NCover&#8217;s measurement would lead into a false sense of security, or that an assumption that your codebase is bug-free.&nbsp; **It isn&#8217;t.**

Not only is it not bug-free, but code coverage says nothing of defects.&nbsp; Defects occur when the users of the software tell you it&#8217;s not working the way they would like, and the root cause is a gap in the story analysis, missing acceptance criteria, or even a new story altogether.&nbsp; 100% coverage doesn&#8217;t mean we&#8217;re done, not by a long shot.

### 

### 

### Only the interesting parts

In recent projects where we measured coverage several months in to the project, we saw regular numbers of 90% coverage.&nbsp; This was on a team doing 100% TDD.&nbsp; So what happened to the extra 10%?&nbsp; If we&#8217;re doing TDD all the time, why isn&#8217;t every statement covered?&nbsp; Every change was introduced with TDD, yet we still had gaps.

So are we doing TDD wrong?&nbsp; Looking at our tests, it certainly doesn&#8217;t seem so.&nbsp; Every test introduced covered behavior we considered interesting.&nbsp; If behavior isn&#8217;t interesting, we don&#8217;t care about it.&nbsp; Things like parameter checks, properties, law of demeter violations, and other brain-dead code is not covered.&nbsp; Why?&nbsp; The behavior just isn&#8217;t that interesting.&nbsp; If tests are a description of the behavior of the system, why fill it with all the boring, trivial parts?&nbsp; The effort required to cover triviality is just too high compared to other ways we can increase value.

### 

### Diminishing returns

Missing in the 100% coverage conversation is the effort required to get to 100%.&nbsp; Attempting to get another 5% takes equal effort of the previous 10%.&nbsp; The next 2% takes equal effort of the previous 15%, and so on.&nbsp; The closer we try to get to 100%, the more difficult it is to achieve.&nbsp; This is called **the law of diminishing returns**.&nbsp; As we get closer and closer to 100%, it takes vastly more effort to get there.&nbsp; At some point, you have to ask yourselves, **is there value in this effort**?&nbsp; Often, bending code to get 100% can decrease design quality, as you&#8217;re now twisting the original intent _solely_ for coverage concerns, not usability, readability or other concerns.

Which is why when the question of 100% coverage comes up, I&#8217;m very skeptical of it as a goal or bar to set.&nbsp; Measuring coverage is an interesting data point, as are other measures such as static analysis.&nbsp; But in the end, it&#8217;s only a measure, an indication.&nbsp; It&#8217;s still up to the team to decide on the value of addressing missing areas, with the full knowledge that they are still limited to what the tool measures.

Personally, I&#8217;d much rather spend the effort elsewhere, where I&#8217;ll get a much better return on my effort spent.