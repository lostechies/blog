---
wordpress_id: 4045
title: 'Smart and gets things done *right*'
date: 2009-09-30T02:56:54+00:00
author: Scott Reynolds
layout: post
wordpress_guid: /blogs/scottcreynolds/archive/2009/09/29/smart-and-gets-things-done-right.aspx
categories:
  - Rant
  - software
  - Testing
redirect_from: "/blogs/scottcreynolds/archive/2009/09/29/smart-and-gets-things-done-right.aspx/"
---
I suppose it&#8217;s time for the obligatory weigh-in on the latest bit o&#8217; reckless software advice from Joel Spolsky on the merits of the &#8220;Duct Tape Programmer&#8221;. 

I think being a duct tape programmer is a bit like being an alcoholic. Once you become one, you are one, and when you want to stop, you have to constantly be vigilant against backsliding. Oh, and the first step is admitting you have a problem. 

Hi, I&#8217;m Scott, and I&#8217;m a recovering duct tape programmer. 

I don&#8217;t want to get too deep in the weeds on Joel&#8217;s article, because the simple fact is that it doesn&#8217;t warrant as much discussion as it&#8217;s getting. On further review, he doesn&#8217;t say much more than &#8220;be like this and get things done, but, you&#8217;re probably not smart enough to be like this, so&#8230;&#8221;. I will be pulling out a few key parts of his article to make my points however.

What I do want to talk about is this notion that somehow being a craftsman and striving for appropriate, maintainable, and dare I say elegant solutions is in opposition of getting things done.

There&#8217;s a major problem in this industry (and the sub-industry of blogging/speaking/writing about this industry) of trying to remove contextual analysis from what we say. When we do that we get ourselves in trouble. Every product is different, every organization is different, and the needs of each varies wildly. Therefore it&#8217;s impossible to prescribe one action over another free of context. The second side of that same coin is that the vast majority of people taking this sort of context free advice don&#8217;t recognize this lack of context and run with it because some hero they worship said it. Then you get people that say things like &#8220;I don&#8217;t want to write tests because Jeff Atwood and Joel Spolsky don&#8217;t&#8221; or &#8220;I just want to code all night in a cave and &#8216;get shit done&#8217; because that&#8217;s what Joel said is valuable to business&#8221;. This is a major problem.

There&#8217;s also this problem of the definition of &#8220;quality&#8221; in software. Some people tend to take a narrow view that the software quality issue is about patterns and clean code. This is part of it to be sure, but it&#8217;s not the whole thing. Quality is part of solving the problem. Solving the right problem, with the right solution, that works for the business, in an amount of time that ensures value was provided, that&#8217;s part of quality. Ensuring that the code is at the very least \*correct\* is also part of quality. Ensuring that code is maintainable can also be part of quality. Each of these parts of quality has a cost associated with it, and business decisions have to be made about the ROI tradeoffs associated. The problem is the business rarely makes the decisions, because the developers either don&#8217;t care to raise the issue and educate, or don&#8217;t want to.

Joel&#8217;s hero of the day was Jamie Zawinski, one of the original developers at Netscape. He stands him up as a bastion of getting things done, and I won&#8217;t begin to deny Jamie&#8217;s talent. But I do want to break down the straw men set up by Joel and add some context.

### Just what is &#8220;important code&#8221;?

> Remember, before you freak out, that Zawinski was at Netscape when they were changing the world. They thought that they only had a few months before someone else came along and ate their lunch. A lot of important code is like that.

Yes, that was back in the glory wild west days of the internet and in the formative years of what the software industry has become. And yes, a lot of people are under the gun to get something to market before their funding runs out or someone bypasses them. But let&#8217;s be real. The vast majority of software development out there is on the more &#8220;mundane&#8221; systems&#8230;you know&#8230;the ones that run the world, rather than the fancy Web 2.0 products. Do you want a duct tape programmer writing the software that controls your bank, or the lab equipment processing your mother&#8217;s biopsy, or your insurance company&#8217;s claims system or the air traffic control systems? I don&#8217;t know the numbers, but I&#8217;m willing to bet that more people working in corporate IT on systems that have real impact on lives read Joel&#8217;s blog than do people like Jamie. Just a guess.

For me, the code running my bank is more important code than web browser code. Calling it &#8220;important code&#8221; is a huge red flag for me of the developer/geek bias in Joel&#8217;s opinions. Important in this case means approximately &#8220;cool and new&#8221;. My definition of important code makes me afraid that the people who write such code will follow Joel&#8217;s advice.

### Ship It!

> “Yeah,” he says, “At the end of the day, ship the fucking thing! It’s great to rewrite your code and make it cleaner and by the third time it’ll actually be pretty. But that’s not the point—you’re not here to write code; you’re here to ship products.”

Yes, you&#8217;re here to ship. I don&#8217;t think that&#8217;s a question in anyone&#8217;s mind. But let&#8217;s talk about the meat of this quote. The assumption here is that the developers of the non-duct-tape variety are focused on &#8220;pretty&#8221; code. Coupled with other sentiments in the article, it would seem that Joel (and Jamie) is saying that a testing practice and the idea of putting together a readable, maintainable codebase is the enemy of getting things done. This isn&#8217;t a binary issue. Being for a maintainable codebase doesn&#8217;t mean being against shipping. Being for code quality doesn&#8217;t mean being for cleverness or complexity for the sake of cool (quite often it means the opposite).

Again, this statement lacks the analysis of the context of different project and organization needs. If you&#8217;re trying to produce the world&#8217;s first web browser then yeah, get it out there and get it done. If you&#8217;re trying to produce a long-lasting insurance claims application that will be the backbone of a corporation&#8217;s business, then maintainability should probably be on your radar. Again, include the business in the decision making process. You shouldn&#8217;t go off on your own in either direction, sacrificing quality for speed or vice-versa.

### Testing

> Zawinski didn’t do many unit tests. They “sound great in principle. Given a leisurely development pace, that’s certainly the way to go.

Now this is just crap, and it assumes and perpetuates the flawed idea that a mature testing practice costs you time. Yes, I said mature. Getting started on TDD _will_ be slow at first, but the payoff is huge. And let&#8217;s not forget that time to market is total time to market, not just time to code features. Those features have to be implemented and tested before release (hopefully), and a practice that eschews testing for the sake of speed is often going to result in costly rework that will cost time ultimately. Again, context being what it is, I&#8217;m not saying that you can&#8217;t do quality work and avoid rework with no testing, but what I am saying is that you also can&#8217;t say that testing is only for those with &#8220;a leisurely development pace&#8221;. My team cranks out features at an alarming rate sometimes, and manages to do so while practicing TDD and testing all the way up and down the stack.

The point I&#8217;m getting at here is that we need to evaluate each project on its own merits and decide the practices that are appropriate to produce the value needed in the time required, and that we absolutely have to be careful about tossing around potentially harmful advice to our large audiences that will likely lead to some really crappy software being produced. Matt Hinze said it best when [he said](http://twitter.com/mhinze/status/4341230362) &#8220;&#8230;never take software advice from a bug tracking system salesman&#8221;.

Oh and let&#8217;s not forget how bad Netscape&#8217;s browser ultimately became, and what a bloated piece of garbage it was by the time it died. Guess all that duct tape caught up with them.

<!-- Technorati Tags Start -->

Technorati Tags:
  
<a href="http://technorati.com/tag/software" rel="tag">software</a>, <a href="http://technorati.com/tag/tdd" rel="tag">tdd</a>, <a href="http://technorati.com/tag/software%20writing" rel="tag">software writing</a>, <a href="http://technorati.com/tag/rant" rel="tag">rant</a>, <a href="http://technorati.com/tag/quality" rel="tag">quality</a> 

<!-- Technorati Tags End -->