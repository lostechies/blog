---
id: 3352
title: Anti-Patterns and Worst Practices – You’re Doing it Wrong!
date: 2009-05-26T12:00:00+00:00
author: Chris Missal
layout: post
guid: /blogs/chrismissal/archive/2009/05/26/anti-patterns-and-worst-practices-you-re-doing-it-wrong.aspx
dsq_thread_id:
  - "262174872"
categories:
  - Best Practices
  - Design Principles
  - development
  - DRY
  - legacy code
  - SOLID
  - Testing
---
[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;margin: 0px 0px 0px 10px;border-right-width: 0px" alt="doing-it-wrong" src="//lostechies.com/chrismissal/files/2011/03/doingitwrong_thumb_72CB7849.jpg" width="244" align="right" border="0" height="192" />](//lostechies.com/chrismissal/files/2011/03/doingitwrong_45B68B7B.jpg) When shown ideal code, I think developers understand why it is favorable. When it is regarding <a href="http://en.wikipedia.org/wiki/Separation_of_concerns" target="_blank">Separation of Concerns (SoC)</a> or <a href="/blogs/jason_meridth/archive/2008/03/26/ptom-single-responsibility-principle.aspx" target="_blank">Single Responsibility Principle</a> (<a href="/blogs/sean_chambers/archive/2008/03/15/ptom-single-responsibility-principle.aspx" target="_blank">SRP</a>) the consensus is something along the lines of &ldquo;of course, that makes sense&rdquo;. But not always do these same developers actually practice the techniques or principles. It&rsquo;s always nice to see good code, but I think it&rsquo;s also important to look at bad code from time-to-time.

Just as there are best practices, there are also worst practices. When you see some of these worst practices, you should do your best to acknowledge them, avoid them and try to remove them from your code, even if you have to do it little by little. The side effects of these are probably going to cause you a lot of frustration and pain in the future if they stick around for too long.

Here&rsquo;s the four I&rsquo;ve decided I&rsquo;m going to single out over the next week:

> ### <a target="_self" href="/blogs/chrismissal/archive/2009/05/27/anti-patterns-and-worst-practices-the-arrowhead-anti-pattern.aspx"><span style="text-decoration: underline">Part 1 : The Arrowhead Anti-Pattern</span></a>
> 
> This anti-pattern is quite simple. You&rsquo;ll see an &ldquo;arrowhead&rdquo; form when your code has conditionals and loops nested within each other, over and over. The reason that this is bad is because it increases the <a href="http://en.wikipedia.org/wiki/Cyclomatic_complexity" target="_blank">cyclomatic complexity</a> of the code. The higher the cyclomatic complexity, the more it is prone to bugs and defects, thus the harder it is to ensure the code works as expected.
> 
> ### <a target="_self" href="/blogs/chrismissal/archive/2009/05/28/anti-patterns-and-worst-practices-monster-objects.aspx"><span style="text-decoration: underline">Part 2 : Monster Objects</span></a>
> 
> Sometimes referred to as God objects, these are objects that are just too big, bulky and hard to manage. If you&rsquo;re familiar with ASP.NET, you&rsquo;ll be familiar with HttpContext, a Monster object.
> 
> ### <a target="_self" href="/blogs/chrismissal/archive/2009/05/30/anti-patterns-and-worst-practices-heisenbugs.aspx"><span style="text-decoration: underline">Part 3 : Heisenbugs</span></a>
> 
> A Heisenbug is named after Heisenberg&rsquo;s Uncertainty Principle. Which states that the state of an object cannot be accurately measured, because any attempt to do so will change the result. In software, this can manifest itself when breaking the <a href="http://www.martinfowler.com/bliki/CommandQuerySeparation.html" target="_blank">Command-Query Separation</a> design guideline.
> 
> ### <a target="_self" href="/blogs/chrismissal/archive/2009/06/01/anti-patterns-and-worst-practices-utils-class.aspx"><span style="text-decoration: underline">Part 4 : Utils Class</span></a>
> 
> In the software world, you&rsquo;re probably going to come across a class with this name at some point. What does it do? Nobody knows, that&rsquo;s why it exists. When you see a Utils (or Utility) class, its existence is probably due to laziness or lack of domain knowledge.