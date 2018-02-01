---
id: 32
title: The problem with code comments
date: 2007-06-19T20:31:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/06/19/the-problem-with-code-comments.aspx
dsq_thread_id:
  - "265531522"
categories:
  - Rant
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/problem-with-code-comments.html)._

Let me first state that I&#8217;m&nbsp;not proposing eliminating the use of code comments.&nbsp; Code comments can be very helpful&nbsp;pointing a developer in the right&nbsp;direction when trying to change&nbsp;a complex&nbsp;or&nbsp;non-intuitive&nbsp;block of code.

Additionally, I&#8217;m also not referring to API documentation (like C# XML code comments) when I&#8217;m referring to code comments.&nbsp; I&#8217;m talking about the little snippets of comments that some helpful coder gave to you as a gift to explain why this code is the way it is.&nbsp; Code comments are easy to introduce, can be very helpful, so what&#8217;s the big deal?

### Code comments lie

Code comments cannot be tested to determine their accuracy.&nbsp; I can&#8217;t ask a code comment, &#8220;Are you still correct?&nbsp; Are you lying to me?&#8221;&nbsp; The comment may be correct, or it may not be, I don&#8217;t really know unless I visually (and tediously) inspect the code for accuracy.

I can trust the comment and just assume that whatever it tells me is still correct.&nbsp; But everyone knows the colloquialism about assuming, so chances are I&#8217;ll be wrong to assume.&nbsp; Who&#8217;s to blame then, me or the author of the original comment?&nbsp;&nbsp;It can be dangerous to assume that&nbsp;a piece of text that is neither executable nor testable is inherently correct.

### Code comments are another form of duplication

This duplication is difficult to see unless I need to change the code the comment pertains to.&nbsp; Now I have to make the change in two places, but one of the places is in comments.&nbsp; If every complexity in code required comments, how much time would I need to&nbsp;spend keeping the original comments up to date?&nbsp; I would&nbsp;assert that it takes as much time to update a code comment as it does to make a change on the code being commented.

Since the cost to maintain comments is high, they&#8217;re simply not maintained.&nbsp; They then&nbsp;fall into another pernicious category of duplication where the duplicate is stale and invalid.&nbsp; When code comments are invalid, they actually hurt the next developer looking at the code because the comment may lie to the developer and cause them to introduce bugs, make the wrong changes, form invalid assumptions, etc.

### Code comments are an opportunity cost

I think the real reason code comments aren&#8217;t maintained is that most developers instinctively view them as an [opportunity cost](http://en.wikipedia.org/wiki/Opportunity_cost).&nbsp; That is, spending time (and therefore money) to maintain code comments costs me in terms of not taking the opportunity to improve the code such that I wouldn&#8217;t need the comments in the first place.&nbsp; The benefits of making the code more soluble, testable, and consequently more maintainable are much more valuable than having up-to-date comments.

A worse side-effect is when developers use the time to update the comments to do nothing instead.&nbsp; Call it apathy, ignorance, or just plain laziness, but more often than not the developer would rather&nbsp;leave the incorrect comments as-is and not worry about eliminating the need for comments.

### Code comments are not testable

If I can&#8217;t test a code comment, I can&#8217;t verify it.&nbsp; Untested or not testable&nbsp;code is by definition legacy code and not maintainable.&nbsp; But code can be refactored and modified to be made testable and verifiable.&nbsp; Code comments can&#8217;t, so they will always remain not maintainable.&nbsp; Putting processes in place to enforce code comments are up-to-date is not the answer since the fundamental problem with comments are I can&#8217;t test to know if they are correct in any kind of automated or repeatable fashion.

### Alternatives

So if code comments are bad (there are exceptions of course), what should I do instead?

  * Refactor code so that it is soluble 
      * Refactor code so that it is testable 
          * Use intention-revealing names for classes and members 
              * Use intention-revealing names for tests</ul> 
            There are always exceptions to the rule, and some scenarios where code comments are appropriate&nbsp;could be:
            
              * Explaining third-party libraries, like MSMQ, etc.&nbsp;(that should be hidden behind interfaces anyway) 
                  * Explaining test results (rare) 
                      * Explaining usage of a third-party framework like ASP.NET where your code is intimate with their framework</ul> 
                    I&#8217;d say 99 times out of 100, when I encounter a code comment, I just&nbsp;use [Extract Method](http://www.refactoring.com/catalog/extractMethod.html) on&nbsp;the block being commented with a name that might include some of the comment.&nbsp; Tools like [ReSharper](http://www.jetbrains.com/resharper/) will actually examine your code comments and suggest a good name.&nbsp; When&nbsp;the code comment block is extracted in a method, it&#8217;s testable, and now I can enforce the behavior through a test, eliminating the need for the comment.&nbsp;