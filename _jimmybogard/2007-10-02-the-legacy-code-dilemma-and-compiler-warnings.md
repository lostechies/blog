---
wordpress_id: 70
title: The Legacy Code Dilemma and compiler warnings
date: 2007-10-02T20:04:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/10/02/the-legacy-code-dilemma-and-compiler-warnings.aspx
dsq_thread_id:
  - "264977970"
categories:
  - LegacyCode
redirect_from: "/blogs/jimmy_bogard/archive/2007/10/02/the-legacy-code-dilemma-and-compiler-warnings.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/10/legacy-code-dilemma-and-compiler.html)._

I hit the Legacy Code Dilemma today while trying to reduce compiler warnings in our solution.&nbsp; For those that don&#8217;t know it, the Legacy Code Dilemma is:

**I need to fix some legacy code, but the fix isn&#8217;t ideal.**

After working on green-field development for a while, dealing with legacy code can be frustrating at first, unless you go through Michael Feathers&#8217; excellent [Legacy Code](http://www.amazon.com/Working-Effectively-Legacy-Robert-Martin/dp/0131177052) book.&nbsp; Whenever I feel the need to spend two days refactoring a small area to get it under test, I have to remind myself that it&#8217;s more important to deliver business value AND pay down technical debt than paying down technical debt alone.&nbsp; But then you hit dilemmas, where you KNOW the solution you&#8217;re putting in is ugly, but just don&#8217;t have the resources to &#8220;do it right&#8221;.

#### To fix or not to fix

I hit that today, where I was trying to reduce compiler warnings.&nbsp; I could fix the compiler warnings by making them go away, or fix the design problems that made the compiler warnings show up in the first place.

For example, I encountered a lot of &#8220;variable declared but not used&#8221;:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">try</span>
{
    <span class="kwrd">return</span> PricingDatabase.GetPrice(itemId);
}
<span class="kwrd">catch</span> (Exception ex)
{
    <span class="kwrd">return</span> 0.0M;
}
</pre>
</div>

In this case, the specific warning is &#8220;The variable &#8216;ex&#8217; is declared but never used&#8221;.&nbsp; The problem is the variable &#8220;ex&#8221; is declared but never referenced in the &#8220;catch&#8221; block.&nbsp; The design flaw, at least one of them, is that exception handling is used for flow control.&nbsp; Any time you see try-catch block [swallow the exception](http://www.lostechies.com/blogs/jimmy_bogard/archive/2007/04/30/swallowing-exceptions-is-hazardous-to.aspx) and do something else, it&#8217;s a serious code smell.

The problem about fixing the design issue is that **I&#8217;m dealing with legacy code, which has no tests**.&nbsp; Such design changes are foolish and even dangerous without proper automated tests in place.

#### Live to fight another day

If I wanted to fix the design flaw, I was in for a real battle.&nbsp; I would need to get this module under test, and get any client modules under test.&nbsp; For a codebase with little or no unit tests in place, that&#8217;s just not feasible.

Instead, I&#8217;ll fix the warning:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">try</span>
{
    <span class="kwrd">return</span> PricingDatabase.GetPrice(itemId);
}
<span class="kwrd">catch</span> (Exception)
{
    <span class="kwrd">return</span> 0.0M;
}</pre>
</div>

I kept the exception swallowing and all its nastiness, but gained a small victory by removing a compiler warning.&nbsp; Since this solution has several _hundred_ compiler warnings, all these little victories will pay off.&nbsp; Instead of charging off on a path of self-righteous refactoring, I&#8217;ve fixed the pain and lived to tell the tale.