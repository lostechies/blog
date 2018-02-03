---
wordpress_id: 8
title: Evils of duplication
date: 2007-04-16T12:53:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/04/16/evils-of-duplication.aspx
dsq_thread_id:
  - "265528476"
categories:
  - 'C#'
  - Refactoring
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/evils-of-duplication.html)._

Everyone is guilty of using &#8220;Ctrl-C, Ctrl-V&#8221; in code.&nbsp; During development, we may see opportunities to duplicate code&nbsp;a dozen times a day.&nbsp; We&#8217;re working on some class Foo that needs some behavior that is already implemented in class Bar.&nbsp; The quickest way to implement this is Copy, Paste, and call it a day.&nbsp; But what are the long-term implications of this?&nbsp; If this is a codebase that must be maintained for months, even years, what will these seemingly innocuous keyboard coding shortcuts do to us?&nbsp; The answer is not pretty.

### A complex world

The truth is, coding isn&#8217;t that hard.&nbsp; Give me a feature, and on a clean slate system, I could have it done in two weeks.&nbsp; I code it as fast as I can, and with some solid testing, I can be reasonably sure that you&#8217;ll get what you asked for.

Fast forward six months.&nbsp; Everything is great with the feature I implemented, but I&#8217;m requested to make&nbsp;some small change.&nbsp; Now I&#8217;m in trouble.&nbsp; The small change isn&#8217;t that difficult, but now I need to figure out how that affects the existing system.&nbsp; I&#8217;m in luck though, it looks like there&#8217;s already something similar in the codebase, and a quick Copy-Paste second later, the changes are done (with some minor tweaks, of course).&nbsp; I get tired of making these changes for these ungrateful customers, so I decide to leave for greener pastures and cleaner slates.

Now the customer wants another change, but this time it affects **both** features.&nbsp; I&#8217;m not around, and I&#8217;m not answering emails, so it&#8217;s up to Joe to fix this problem.&nbsp; Not being familiar with the codebase, Joe resorts to searching for changes he must make.&nbsp; He finds the two features (a couple of days later) and makes the change **in both places**.&nbsp; I think you can see where this is going.&nbsp; Any change that affects the two features will have to be made in both places, and it will be up to the developer to remember or be lucky enough to find the two places where the changes are made.&nbsp; Instead of taking a couple of days to make a change, it takes a month, because Joe has to make darn sure that this code wasn&#8217;t copied and pasted a dozen other times.

### Conditions deteriorate

If Copy Paste is rampant in a codebase, maintainability vanishes.&nbsp; We&#8217;d spend 95% of our time just figuring out what the code is doing, where the changes should be made, and how many other places I need to fix since the logic is duplicated many times rather than actually coding the changes.&nbsp; All because I decided to take a shortcut and Copy Paste.&nbsp; Our estimates need to go up even though&nbsp;the changes aren&#8217;t hard because we have no idea how many places we have to make the same fix.

### Real-world example

I had a defect recently where I needed to know whether the current web customer was a&nbsp;Business (rather than&nbsp;Individual)&nbsp;customer or not.&nbsp; I found some logic in a base page class&nbsp;that looked like this:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">protected</span> <span class="kwrd">bool</span> IsBusiness<br />
{<br />
   <span class="kwrd">get</span><br />
   {<br />
      <span class="kwrd">if</span> ((StoreContext.Current != <span class="kwrd">null</span>) && (StoreContext.Current.StoreSettings != <span class="kwrd">null</span>) && (StoreContext.Current.StoreSettings.CustomerType != <span class="kwrd">null</span>) && (StoreContext.Current.StoreSettings.CustomerType.Trim().Length&gt;0))<br />
      {<br />
         <span class="kwrd">if</span> (StoreContext.Current.StoreSettings.CustomerType.ToUpper() == <span class="str">"BUSINESS"</span>)<br />
         {<br />
            <span class="kwrd">return</span> <span class="kwrd">true</span>;<br />
         }<br />
      }<br />
      <span class="kwrd">return</span> <span class="kwrd">false</span>;<br />
   }<br />
}<br />
</pre>
</div>

This looks pretty good, but it&#8217;s on a Page class and I&#8217;m working with a UserControl.&nbsp; I _could_ just copy paste this code block and be finished.&nbsp; But what if this logic ever changed?&nbsp; What if instead of &#8220;BUSINESS&#8221;, the compare string needed to change to&nbsp;&#8220;CORPORATE&#8221;.&nbsp; As a quick sanity check, I looked for other instances of this logic to see if I couldn&#8217;t use a different class.&nbsp; Bad news.&nbsp; This same block of code is used over a dozen times in my solution.&nbsp; That means that this string can never change because the cost of change&nbsp;is too great and it affects too many modules.

### A solution

What I&#8217;d really like is for this logic to be in only one place.&nbsp; That is, logic should appear [once and only once](http://c2.com/xp/OnceAndOnlyOnce.html).&nbsp; Here&#8217;s a static helper class I would use to solve this problem (with some minor refactorings*):

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">class</span> SettingsHelper<br />
{<br />
<br />
   <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">bool</span> IsBusiness()<br />
   {<br />
      StoreContext context = StoreContext.Current;<br />
<br />
      <span class="kwrd">if</span> ((context == <span class="kwrd">null</span>) || <br />
         (context.StoreSettings == <span class="kwrd">null</span>) || <br />
         (context.StoreSettings.CustomerType == <span class="kwrd">null</span>))<br />
         <span class="kwrd">return</span> <span class="kwrd">false</span>;<br />
         <br />
      <span class="kwrd">string</span> customerType = context.StoreSettings.CustomerType.Trim();<br />
<br />
      <span class="kwrd">return</span> (<span class="kwrd">string</span>.Compare(customerType, <span class="str">"BUSINESS"</span>, StringComparison.OrdinalIgnoreCase) == 0);<br />
   }<br />
<br />
}<br />
</pre>
</div>

When I eliminate duplication, I increase maintainability and lower the total cost of ownership.&nbsp; Duplication occurs in many forms, but Copy Paste is the easiest for the developer to eliminate.&nbsp; Just don&#8217;t do it.&nbsp; If you feel the urge to use that &#8220;Ctrl-C, Ctrl-V&#8221; combination, stop and think of Joe, who has to clean up your mess.&nbsp; Think about where this behavior should be, and put it there instead.&nbsp; I&#8217;d try to put the behavior as close to the data as possible, on the class that contains the data if possible.&nbsp; If it requires a helper class, create one.&nbsp;&nbsp;Just do whatever it takes to prevent Copy Paste duplication, since we pay many times over in maintenance costs for maintaining duplicated logic.

### Greener pastures

We have&nbsp;a codebase that&#8217;s been successful for years.&nbsp; I&#8217;ll try to treat it like my home, and clean as I go.&nbsp; I won&#8217;t introduce duplication, and I&#8217;ll do my best to eliminate it where I find it.&nbsp; Doing so will ensure that this codebase will continue to be successful in the years to come.&nbsp; I&#8217;ve been that developer Joe and it&#8217;s not fun.

&nbsp;

* Refactorings:

  * [Replace nested conditional with guard clauses](http://www.refactoring.com/catalog/replaceNestedConditionalWithGuardClauses.html) 
      * [Introduce explaining variable](http://www.refactoring.com/catalog/introduceExplainingVariable.html) 
          * [Replace ToUpper with string.Compare](http://www.codeproject.com/csharp/stringperf.asp)</ul>