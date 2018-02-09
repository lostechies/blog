---
wordpress_id: 3196
title: 'Refactoring Day 2 : Move Method'
date: 2009-08-02T13:50:34+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/02/refactoring-day-2-move-method.aspx
dsq_thread_id:
  - "262346345"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/02/refactoring-day-2-move-method.aspx/"
---
_<font size="1"></font>_

_<font size="1"></font>_

_<font size="1"></font>_

_<font size="1"></font>_

<font size="1">The refactoring today is pretty straightforward, although often overlooked and ignored as being a worthwhile refactoring. Move method does exactly what it sounds like, move a method to a better location. Let’s look at the following code before our refactoring:</font>

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> BankAccount</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> BankAccount(<span class="kwrd">int</span> accountAge, <span class="kwrd">int</span> creditScore, AccountInterest accountInterest)</pre>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <pre><span class="lnum">   5:</span>         AccountAge = accountAge;</pre>
    
    <pre><span class="lnum">   6:</span>         CreditScore = creditScore;</pre>
    
    <pre><span class="lnum">   7:</span>         AccountInterest = accountInterest;</pre>
    
    <pre><span class="lnum">   8:</span>     }</pre>
    
    <pre><span class="lnum">   9:</span>&#160; </pre>
    
    <pre><span class="lnum">  10:</span>     <span class="kwrd">public </span><span class="kwrd">int</span> AccountAge { get; private set; }</pre>
    
    <pre><span class="lnum">  11:</span>     public <span class="kwrd">int</span> CreditScore { get; private set; }</pre>
    
    <pre><span class="lnum">  12:</span>     <span class="kwrd">public</span> AccountInterest AccountInterest { get; private set; }</pre>
    
    <pre><span class="lnum">  13:</span>&#160; </pre>
    
    <pre><span class="lnum">  14:</span>     <span class="kwrd">public</span> <span class="kwrd">double</span> CalculateInterestRate()</pre>
    
    <pre><span class="lnum">  15:</span>     {</pre>
    
    <pre><span class="lnum">  16:</span>         <span class="kwrd">if</span> (CreditScore &gt; 800)</pre>
    
    <pre><span class="lnum">  17:</span>             <span class="kwrd">return</span> 0.02;</pre>
    
    <pre><span class="lnum">  18:</span>&#160; </pre>
    
    <pre><span class="lnum">  19:</span>         <span class="kwrd">if</span> (AccountAge &gt; 10)</pre>
    
    <pre><span class="lnum">  20:</span>             <span class="kwrd">return</span> 0.03;</pre>
    
    <pre><span class="lnum">  21:</span>&#160; </pre>
    
    <pre><span class="lnum">  22:</span>         <span class="kwrd">return</span> 0.05;</pre>
    
    <pre><span class="lnum">  23:</span>     }</pre>
    
    <pre><span class="lnum">  24:</span> }</pre>
    
    <pre><span class="lnum">  25:</span>&#160; </pre>
    
    <pre><span class="lnum">  26:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> AccountInterest</pre>
    
    <pre><span class="lnum">  27:</span> {</pre>
    
    <pre><span class="lnum">  28:</span>     <span class="kwrd">public</span> BankAccount Account { get; private set; }</pre>
    
    <pre><span class="lnum">  29:</span>&#160; </pre>
    
    <pre><span class="lnum">  30:</span>     <span class="kwrd">public</span> AccountInterest(BankAccount account)</pre>
    
    <pre><span class="lnum">  31:</span>     {</pre>
    
    <pre><span class="lnum">  32:</span>         Account = account;</pre>
    
    <pre><span class="lnum">  33:</span>     }</pre>
    
    <pre><span class="lnum">  34:</span>&#160; </pre>
    
    <pre><span class="lnum">  35:</span>     <span class="kwrd">public</span> <span class="kwrd">double</span> InterestRate</pre>
    
    <pre><span class="lnum">  36:</span>     {</pre>
    
    <pre><span class="lnum">  37:</span>         get { <span class="kwrd">return</span> Account.CalculateInterestRate(); }</pre>
    
    <pre><span class="lnum">  38:</span>     }</pre>
    
    <pre><span class="lnum">  39:</span>&#160; </pre>
    
    <pre><span class="lnum">  40:</span>     <span class="kwrd">public</span> <span class="kwrd">bool</span> IntroductoryRate</pre>
    
    <pre><span class="lnum">  41:</span>     {</pre>
    
    <pre><span class="lnum">  42:</span>         get { <span class="kwrd">return</span> Account.CalculateInterestRate() &lt; 0.05; }</pre>
    
    <pre><span class="lnum">  43:</span>     }</pre>
    
    <pre><span class="lnum">  44:</span> }</pre></p>
  </div>
</div>

<font size="1"><br /> <br />The point of interest here is the BankAccount.CalculateInterest method. A hint that you need the Move Method refactoring is when another class is using a method more often then the class in which it lives. If this is the case it makes sense to move the method to the class where it is primarily used. This doesn’t work in every instance because of dependencies, but it is overlooked often as a worthwhile change.</font>

<font size="1">In the end you would end up with something like this:<br /> <br /></font>

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> BankAccount</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> BankAccount(<span class="kwrd">int</span> accountAge, <span class="kwrd">int</span> creditScore, AccountInterest accountInterest)</pre>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <pre><span class="lnum">   5:</span>         AccountAge = accountAge;</pre>
    
    <pre><span class="lnum">   6:</span>         CreditScore = creditScore;</pre>
    
    <pre><span class="lnum">   7:</span>         AccountInterest = accountInterest;</pre>
    
    <pre><span class="lnum">   8:</span>     }</pre>
    
    <pre><span class="lnum">   9:</span>&#160; </pre>
    
    <pre><span class="lnum">  10:</span>     <span class="kwrd">public</span> <span class="kwrd">int</span> AccountAge { get; <span class="kwrd">private</span> set; }</pre>
    
    <pre><span class="lnum">  11:</span>     <span class="kwrd">public</span> <span class="kwrd">int</span> CreditScore { get; <span class="kwrd">private</span> set; }</pre>
    
    <pre><span class="lnum">  12:</span>     <span class="kwrd">public</span> AccountInterest AccountInterest { get; <span class="kwrd">private</span> set; }</pre>
    
    <pre><span class="lnum">  13:</span> }</pre>
    
    <pre><span class="lnum">  14:</span>&#160; </pre>
    
    <pre><span class="lnum">  15:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> AccountInterest</pre>
    
    <pre><span class="lnum">  16:</span> {</pre>
    
    <pre><span class="lnum">  17:</span>     <span class="kwrd">public</span> BankAccount Account { get; <span class="kwrd">private</span> set; }</pre>
    
    <pre><span class="lnum">  18:</span>&#160; </pre>
    
    <pre><span class="lnum">  19:</span>     <span class="kwrd">public</span> AccountInterest(BankAccount account)</pre>
    
    <pre><span class="lnum">  20:</span>     {</pre>
    
    <pre><span class="lnum">  21:</span>         Account = account;</pre>
    
    <pre><span class="lnum">  22:</span>     }</pre>
    
    <pre><span class="lnum">  23:</span>&#160; </pre>
    
    <pre><span class="lnum">  24:</span>     <span class="kwrd">public</span> <span class="kwrd">double</span> InterestRate</pre>
    
    <pre><span class="lnum">  25:</span>     {</pre>
    
    <pre><span class="lnum">  26:</span>         get { <span class="kwrd">return</span> CalculateInterestRate(); }</pre>
    
    <pre><span class="lnum">  27:</span>     }</pre>
    
    <pre><span class="lnum">  28:</span>&#160; </pre>
    
    <pre><span class="lnum">  29:</span>     <span class="kwrd">public</span> <span class="kwrd">bool</span> IntroductoryRate</pre>
    
    <pre><span class="lnum">  30:</span>     {</pre>
    
    <pre><span class="lnum">  31:</span>         get { <span class="kwrd">return</span> CalculateInterestRate() &lt; 0.05; }</pre>
    
    <pre><span class="lnum">  32:</span>     }</pre>
    
    <pre><span class="lnum">  33:</span>&#160; </pre>
    
    <pre><span class="lnum">  34:</span>     <span class="kwrd">public</span> <span class="kwrd">double</span> CalculateInterestRate()</pre>
    
    <pre><span class="lnum">  35:</span>     {</pre>
    
    <pre><span class="lnum">  36:</span>         <span class="kwrd">if</span> (Account.CreditScore &gt; 800)</pre>
    
    <pre><span class="lnum">  37:</span>             <span class="kwrd">return</span> 0.02;</pre>
    
    <pre><span class="lnum">  38:</span>&#160; </pre>
    
    <pre><span class="lnum">  39:</span>         <span class="kwrd">if</span> (Account.AccountAge &gt; 10)</pre>
    
    <pre><span class="lnum">  40:</span>             <span class="kwrd">return</span> 0.03;</pre>
    
    <pre><span class="lnum">  41:</span>&#160; </pre>
    
    <pre><span class="lnum">  42:</span>         <span class="kwrd">return</span> 0.05;</pre>
    
    <pre><span class="lnum">  43:</span>     }</pre>
    
    <pre><span class="lnum">  44:</span> }</pre></p>
  </div>
</div>

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre>&#160;</pre></p>
  </div>
</div>

<font size="1">Simple enough!</font>

_<font size="1"></font>_

_<font size="1">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="http://www.lostechies.com/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</font>_