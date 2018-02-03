---
wordpress_id: 3375
title: How I Approach a Defect
date: 2010-02-02T05:11:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2010/02/02/how-i-approach-a-defect.aspx
dsq_thread_id:
  - "273269193"
categories:
  - Best Practices
  - Continuous Improvement
  - development
  - Testing
---
Lately I&#8217;ve been tracking some of the steps I go through in a given day or week. I was fixing a bug the other day when I decided that I should write down all the mental notes I refer to when addressing a problem like a bug in code. These are questions I didn&#8217;t always ask in the past and I feel they are valuable, so why not share them?

Here&#8217;s a few questions I&#8217;ll ask myself when I think I have fixed a defect.

### Does This Solve the Problem?

The first and foremost concern is fixing the problem. Do the changes I&#8217;m proposing actually fix the problem? Or do they defer it off elsewhere? I try to remember that &#8220;the fix&#8221; should actually fix the problem. This may seem obvious, but sometimes a bug fix only deflects the problem elsewhere.

### Is This Flexible, Maintainable, Clear and Simple?

Some of these may seem to overlap, so I&#8217;ll describe what I mean by each of them:

  1. **Flexible:** Does this solution allow somebody else to easily change or add to the code I have written? _I could probably fix an issue by adding a bunch of conditionals in a place they don&#8217;t belong, but this is_ [_just duct-taping the broken code_](http://www.joelonsoftware.com/items/2009/09/23.html "Duct Tape Programmers create more issues than they solve")_.  
    &nbsp;_
  2. **Maintainable:**&nbsp;Similar to the previous question, does my solution address the root cause? _I could run a database query to correct some bad data from time to time, but this doesn&#8217;t lend itself to fixing the root of the problem. It creates a maintenance nightmare and just ends up being a waste of time.  
    &nbsp;_
  3. **Clear:** Are the changes I have made obvious and discoverable? _I work primarily in the ASP.NET world and there are many ways to write code that isn&#8217;t obvious (what comes to mind right now is writing an HttpModule that does some work to modify a request/response). Slipping in some code that fixes a problem at an odd place is not a clear way to fix a problem.  
    &nbsp;_
  4. **Simple:** Do your best to stick to the simplest thing that works. I could implement a big system to address a problem that involves an editor and management tools. However, if I can fix the problem some of these won&#8217;t even be necessary. Don&#8217;t over-engineer the problem to make it a bigger one than it actually is.  
    &nbsp;

### Does This Leave the Code Better Than I Found It?

Somebody once said&nbsp;&#8220;Always&nbsp;<span>leave</span>&nbsp;the&nbsp;<span>code</span>&nbsp;in a&nbsp;<span>better</span>&nbsp;state&nbsp;<span>than</span>&nbsp;when&nbsp;<span>you found it</span>.&#8221; That somebody was [Robert (Uncle Bob) Martin](http://objectmentor.com/omTeam/martin_r.html "Uncle Bob"). It&#8217;s great advice and when followed, you&#8217;re creating a better product every day. I&#8217;m a firm believer in this motto because it works. Don&#8217;t take shortcuts, you&#8217;re only going to be spending long nights later on paying back the technical debt you&#8217;ve accrued.

### Is It Covered with Tests to be Future-Proof?

How do you prevent defects and bugs from popping up again? There are two ways I can think of. You write unit tests and keep them running and passing with every code change, or you hire a team of people to test every possible feature of the code every time a new feature or bug fix is added. Your most consistent option is also the cheapest, the former, unit tests and a CI environment. Write a test to confirm the defect then fix it. If you continue to keep your code in a consistent state of harmony, you&#8217;re going to prevent defects from occurring and re-occurring. I could also point out that fixing a bug right away is 1000 times cheaper than fixing it after it goes into production, but you probably already knew that. 😉

The previous four questions are running through my head the whole time I&#8217;m addressing the issue. Once I feel I have them all satisfied, I go through a few more steps before having my code peer reviewed:

### Is There Any Code that was Commented Out or Stale?

If you&#8217;re on board with never commenting out code I&#8217;m partially with you. I&#8217;ll comment out code when running tests, but the real problem with commenting out code is getting that code checked into source control. I&#8217;ll browse through my changes and make sure that I don&#8217;t have any code that is commented out that I forgot to delete. While this has the benefit of maintaining a clean code repository, it&#8217;s also quite embarrassing when somebody has to ask you to delete it because you forgot.

Additionally, productivity and/or refactoring tools may give you warnings of code that is unnecessary, unreachable, or just plain pointless. Delete those lines too, they&#8217;re just making your code messy and nobody likes cleaning up a mess that isn&#8217;t theirs.

### Do Any Named Variables or Classes Exist that Aren&#8217;t Clear?

This one isn&#8217;t always easy for me. It&#8217;s hard to take yourself out of context for a moment to ask yourself if the names you have chosen are clear without knowing the bowels of the code. A class with a name of LabelRequest might make sense to me since I&#8217;ve been working on a customer product return service, but there could be a better name for it. Something like ReturnShippingLabelRequest is a bit more clear for somebody else entering that area of code for the first time. Either of those beats &#8220;LR&#8221; though.

### Are All Changes Relevant to the Fix?

<span style="font-weight: normal;font-size: 12px">Lastly, it&#8217;s important to ask yourself if all code changes that are being reviewed are applicable to the fix. Make sure there is nothing like &#8220;I also cleaned up 15 other files&#8221; going on in your request for review. These are red-flags that a code reviewer should probably point out to you, but if you can catch them before somebody else, you&#8217;re just saving some extra time for everybody. Additionally, if I&#8217;m reviewing thousands of lines of pointless code changes mixed in with some critical code changes, I&#8217;m probably going to get lazy with the review and miss something. Keep it relevant and you&#8217;ll keep the code reviewer astute.</span>

By no means is this list all-inclusive and perfect; I&#8217;m just sharing what is currently working for me and my team. Feel free to leave me any comments or suggestions on thoughts/questions you consider when fixing a defect.

&nbsp;