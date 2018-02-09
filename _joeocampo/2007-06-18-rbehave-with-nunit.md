---
wordpress_id: 26
title: RBehave with NUnit
date: 2007-06-18T15:01:37+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2007/06/18/rbehave-with-nunit.aspx
dsq_thread_id:
  - "262089977"
categories:
  - Uncategorized
redirect_from: "/blogs/joe_ocampo/archive/2007/06/18/rbehave-with-nunit.aspx/"
---
I just read Dan North&#8217;s article on <a href="http://dannorth.net/2007/06/introducing-rbehave" target="_blank">Introducing RBehave</a>.

In a jealous rage of not being able to utilize Ruby fully in .Net. (YET)&nbsp; I decided to see if I could pull off what Dan had created in rbehave using NUnit.&nbsp; Because I am a huge proponent of reuse, I didn&#8217;t want to extend my existing Test Coverage with a brand new framework.&nbsp; After all BDD coupled with ReSharper and Visual Studio make for happy testing.&nbsp; 

Now before I have the entire TDD community up in arms with what I am about to propose this is merely a pattern for the porting of rbehave to NUnit without having to invest in a whole new framework.

I would like to reiterate Dan&#8217;s vision of what rbehave is intended to be.

> &#8220;rbehave is a framework for defining and executing application requirements. Using the vocabulary of [behaviour-driven development](http://dannorth.net/whats-in-a-story), you define a feature in terms of a _Story_ with _Scenarios_ that describe how the feature behaves. Using a minimum of syntax (a few “quotes” mostly), this becomes an executable and self-describing requirements document.&#8221;

Now here is Ruby code for using rbehave:

<div>
  <div>
    <div class="post">
      <div class="storycontent">
        <div class="code ruby" style="font-family: monospace">
          <span style="font-weight: bold;color: #cc0066">require</span> ‘rubygems’<br /><span style="font-weight: bold;color: #cc0066">require</span> ‘rbehave’<br /><span style="font-weight: bold;color: #cc0066">require</span> ’spec’ <span style="color: #008000;font-style: italic"># for &#8220;should&#8221; method</span></p> 
          
          <p>
            <span style="font-weight: bold;color: #cc0066">require</span> ‘account’ <span style="color: #008000;font-style: italic"># the actual application code</span>
          </p>
          
          <p>
            Story <span style="color: #996600">&#8220;transfer to cash account&#8221;</span>,<br />%<span style="font-weight: bold;color: #006600">(</span>As a savings account holder<br />&nbsp; I want to transfer money from my savings account<br />&nbsp; So that I can get cash easily from an ATM<span style="font-weight: bold;color: #006600">)</span> <span style="font-weight: bold;color: #9966cc">do</span>
          </p>
          
          <p>
            &nbsp; Scenario <span style="color: #996600">&#8220;savings account is in credit&#8221;</span> <span style="font-weight: bold;color: #9966cc">do</span><br />&nbsp; &nbsp; Given <span style="color: #996600">&#8220;my savings account balance is&#8221;</span>, <span style="color: #006666">100</span> <span style="font-weight: bold;color: #9966cc">do</span> |balance|<br />&nbsp; &nbsp; &nbsp; @savings_account = Account.<span style="color: #9900cc">new</span><span style="font-weight: bold;color: #006600">(</span>balance<span style="font-weight: bold;color: #006600">)</span><br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">end</span><br />&nbsp; &nbsp; Given <span style="color: #996600">&#8220;my cash account balance is&#8221;</span>, <span style="color: #006666">10</span> <span style="font-weight: bold;color: #9966cc">do</span> |balance|<br />&nbsp; &nbsp; &nbsp; @cash_account = Account.<span style="color: #9900cc">new</span><span style="font-weight: bold;color: #006600">(</span>balance<span style="font-weight: bold;color: #006600">)</span><br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">end</span><br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">When</span> <span style="color: #996600">&#8220;I transfer&#8221;</span>, <span style="color: #006666">20</span> <span style="font-weight: bold;color: #9966cc">do</span> |amount|<br />&nbsp; &nbsp; &nbsp; @savings_account.<span style="color: #9900cc">transfer_to</span><span style="font-weight: bold;color: #006600">(</span>@cash_account, amount<span style="font-weight: bold;color: #006600">)</span><br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">end</span><br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">Then</span> <span style="color: #996600">&#8220;my savings account balance should be&#8221;</span>, <span style="color: #006666">80</span> <span style="font-weight: bold;color: #9966cc">do</span> |expected_amount|<br />&nbsp; &nbsp; &nbsp; @savings_account.<span style="color: #9900cc">balance</span>.<span style="color: #9900cc">should</span> == expected_amount<br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">end</span><br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">Then</span> <span style="color: #996600">&#8220;my cash account balance should be&#8221;</span>, <span style="color: #006666">30</span> <span style="font-weight: bold;color: #9966cc">do</span> |expected_amount|<br />&nbsp; &nbsp; &nbsp; @cash_account.<span style="color: #9900cc">balance</span>.<span style="color: #9900cc">should</span> == expected_amount<br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">end</span><br />&nbsp; <span style="font-weight: bold;color: #9966cc">end</span>
          </p>
          
          <p>
            &nbsp; Scenario <span style="color: #996600">&#8220;savings account is overdrawn&#8221;</span> <span style="font-weight: bold;color: #9966cc">do</span><br />&nbsp; &nbsp; Given <span style="color: #996600">&#8220;my savings account balance is&#8221;</span>, <span style="color: #006666">-20</span><br />&nbsp; &nbsp; Given <span style="color: #996600">&#8220;my cash account balance is&#8221;</span>, <span style="color: #006666">10</span><br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">When</span> <span style="color: #996600">&#8220;I transfer&#8221;</span>, <span style="color: #006666">20</span><br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">Then</span> <span style="color: #996600">&#8220;my savings account balance should be&#8221;</span>, <span style="color: #006666">-20</span><br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">Then</span> <span style="color: #996600">&#8220;my cash account balance should be&#8221;</span>, <span style="color: #006666">10</span><br />&nbsp; <span style="font-weight: bold;color: #9966cc">end</span><br /><span style="font-weight: bold;color: #9966cc">end</span></div> </div> </div> </div> </div> 
            
            <p>
              &nbsp;So I needed a way to capture the story concept using NUnit.&nbsp; I figured why not use the class text fixture attribute.
            </p>
            
            <table class="" cellspacing="0" cellpadding="2" width="600" border="1">
              <tr>
                <td class="" valign="top" width="354">
                  NUnit Syntax<span style="font-weight: bold;color: #9966cc"></span>
                </td>
                
                <td class="" valign="top" width="597">
                  <pre><font size="1">    <span>public</span> <span>class</span> <span>Transfer_to_cash_account</span> : </font><font size="1"><span>NBehaveAbstractFixture
</span>    {
        </font><span><font size="1">/*
         As a savings account holder
         I want to transfer money from my savings account
         So that I can get cash easily from an ATM)
         */</font></span></pre>
                  
                  <blockquote>
                    <p>
                      <font size="1">}</font><a href="http://11011.net/software/vspaste"></a>
                    </p>
                  </blockquote>
                </td>
              </tr>
              
              <tr>
                <td class="" valign="top" width="354">
                  RBehave Syntax
                </td>
                
                <td class="" valign="top" width="597">
                  Story <span style="color: #996600">&#8220;transfer to cash account&#8221;</span>,<br />%<span style="font-weight: bold;color: #006600">(</span>As a savings account holder<br />&nbsp; I want to transfer money from my savings account<br />&nbsp; So that I can get cash easily from an ATM<span style="font-weight: bold;color: #006600">)</span> <span style="font-weight: bold;color: #9966cc">do</span>
                </td>
              </tr>
            </table>
            
            <p>
              As you can see the story &#8220;transfer to cash account&#8221; is the name of the public class Transfer_to_cash_account.&nbsp; As I am sure you all noticed the [TestFixture] attribute is missing but you will also notice that the Transfer_to_cash_account class inherits from NBehaveAbstractFixture, more on this later.&nbsp; Lets talk about the real meat here, the &#8220;Given&#8221; &#8220;When&#8221; &#8220;Then&#8221; constructs.
            </p>
            
            <table class="" cellspacing="0" cellpadding="2" width="600" border="1">
              <tr>
                <td class="" valign="top" width="141">
                  NUnit<br />Syntax
                </td>
                
                <td class="" valign="top" width="1079">
                  <pre><font size="1">        [<span>Test</span>]
        <span>public</span> <span>void</span> savings_account_is_in_credit()
        {
            <span>Account</span> savings = <span>null</span>;
            <span>Account</span> cash = <span>null</span>;

            <font color="#ff8000">Given</font>(<span>"my savings account balance is"</span>, 100,
                <span>delegate</span>(<span>int</span> accountBallance)
                {
                    savings = <span>new</span> <span>Account</span>(accountBallance);
                });

            <font color="#ff8000">Given</font>(<span>"my cash account balance is"</span>, 10,
                <span>delegate</span>(<span>int</span> accountBallance)
                {
                    cash = <span>new</span> <span>Account</span>(accountBallance);
                });

            <font color="#ff8000">When</font>(<span>"I transfer"</span>, 20,
                <span>delegate</span>(<span>int</span> transferAmount)
                {
                    savings.TransferTo(cash, transferAmount);
                });

            <font color="#ff8000">Then</font>(<span>"my savings account balance should be"</span>, 100,
                <span>delegate</span>(<span>int</span> expectedBallance)
                {
                    <span>Assert</span>.AreEqual(expectedBallance, savings.Ballance);
                });

        }</font></pre>
                  
                  <p>
                    <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                    
                    <tr>
                      <td class="" valign="top" width="141">
                        RBehave Syntax
                      </td>
                      
                      <td class="" valign="top" width="1079">
                        &nbsp;<font size="1"> Scenario <span style="color: #996600">&#8220;savings account is in credit&#8221;</span> <span style="font-weight: bold;color: #9966cc">do</span><br />&nbsp; &nbsp; Given <span style="color: #996600">&#8220;my savings account balance is&#8221;</span>, <span style="color: #006666">100</span> <span style="font-weight: bold;color: #9966cc">do</span> |balance|<br />&nbsp; &nbsp; &nbsp; @savings_account = Account.<span style="color: #9900cc">new</span><span style="font-weight: bold;color: #006600">(</span>balance<span style="font-weight: bold;color: #006600">)</span><br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">end</span><br />&nbsp; &nbsp; Given <span style="color: #996600">&#8220;my cash account balance is&#8221;</span>, <span style="color: #006666">10</span> <span style="font-weight: bold;color: #9966cc">do</span> |balance|<br />&nbsp; &nbsp; &nbsp; @cash_account = Account.<span style="color: #9900cc">new</span><span style="font-weight: bold;color: #006600">(</span>balance<span style="font-weight: bold;color: #006600">)</span><br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">end</span><br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">When</span> <span style="color: #996600">&#8220;I transfer&#8221;</span>, <span style="color: #006666">20</span> <span style="font-weight: bold;color: #9966cc">do</span> |amount|<br />&nbsp; &nbsp; &nbsp; @savings_account.<span style="color: #9900cc">transfer_to</span><span style="font-weight: bold;color: #006600">(</span>@cash_account, amount<span style="font-weight: bold;color: #006600">)</span><br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">end</span><br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">Then</span> <span style="color: #996600">&#8220;my savings account balance should be&#8221;</span>, <span style="color: #006666">80</span> <span style="font-weight: bold;color: #9966cc">do</span> |expected_amount|<br />&nbsp; &nbsp; &nbsp; @savings_account.<span style="color: #9900cc">balance</span>.<span style="color: #9900cc">should</span> == expected_amount<br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">end</span><br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">Then</span> <span style="color: #996600">&#8220;my cash account balance should be&#8221;</span>, <span style="color: #006666">30</span> <span style="font-weight: bold;color: #9966cc">do</span> |expected_amount|<br />&nbsp; &nbsp; &nbsp; @cash_account.<span style="color: #9900cc">balance</span>.<span style="color: #9900cc">should</span> == expected_amount<br />&nbsp; &nbsp; <span style="font-weight: bold;color: #9966cc">end</span><br />&nbsp; <span style="font-weight: bold;color: #9966cc">end</span></font>
                      </td>
                    </tr></tbody> </table> 
                    
                    <p>
                      I have intentionally left the account assertion at 100 so it will generate the following stack trace.
                    </p>
                    
                    <pre><font size="1">System.ArgumentException: 
-Behavior Heap-
Given my savings account balance is: 100
Given my cash account balance is: 10
When I transfer: 20
Then my savings account balance should be: 100
</font></pre>
                    
                    <p>
                      <font size="1">at AlamoCoders.BDD.Domain.Specs.NBehaveAbstractFixture.Then[T](String message, T actionValue, action`1 delegateAction) in </font><a href="NBehaveAbstractFixture.cs*59*1"><font size="1">NBehaveAbstractFixture.cs:line 59 </font></a><br /><font size="1">at AlamoCoders.BDD.Domain.Account_Specs.Transfer_to_cash_account.savings_account_is_in_credit() in </font><a href="RBehave.cs*40*1"><font size="1">RBehave.cs:line 40</font></a>
                    </p>
                    
                    <pre><font size="1">NUnit.Framework.AssertionException:   Expected: 100
  But was:  80</font>
</pre>
                    
                    <p>
                      The magic is in the anonymous generic delegate.&nbsp; Rather than tell you how this works let me show you.&nbsp; Here is the code for the the NBehaveAbstractFixture.
                    </p>
                    
                    <pre><font size="1"><span>using</span> System;
<span>using</span> System.Collections.Generic;
<span>using</span> System.Text;
<span>using</span> NUnit.Framework;

<span>namespace</span> AlamoCoders.BDD.Domain.Specs
{
    [<span>TestFixture</span>]
    <span>public</span> <span>class</span> </font><font size="1"><span>NBehaveAbstractFixture
</span>    {
        <span>private</span> <span>string</span> messageHeap;

        <span>protected</span> <span>delegate</span> <span>void</span> <span>action</span>&lt;T&gt;(T value);

        [<span>SetUp</span>]
        <span>protected</span> <span>virtual</span> <span>void</span> SetUp()
        {
            messageHeap = <span>"rn-Behavior Heap-rn"</span>;
        }

        [<span>TearDown</span>]
        <span>protected</span> <span>virtual</span> <span>void</span> TearDown()
        {
            messageHeap = <span>string</span>.Empty;
        }

        <span>protected</span> <span>void</span> When&lt;T&gt;(<span>string</span> message, T actionValue, <span>action</span>&lt;T&gt; delegateAction)
        {
            </font><font size="1"><span>try
</span>            {
                InvokeDelegateAction(<span>"When"</span>, actionValue, delegateAction, message);
            }
            <span>catch</span> (<span>Exception</span> e)
            {
                <span>throw</span> BehaviorException(<span>"When"</span>, actionValue, e, message);
            }
        }

        <span>protected</span> <span>void</span> Given&lt;T&gt;(<span>string</span> message, T actionValue, <span>action</span>&lt;T&gt; delegateAction)
        {
            </font><font size="1"><span>try
</span>            {
                InvokeDelegateAction(<span>"Given"</span>, actionValue, delegateAction, message);
            }
            <span>catch</span> (<span>Exception</span> e)
            {
                <span>throw</span> BehaviorException(<span>"Given"</span>, actionValue, e, message);
            }
        }

        <span>protected</span> <span>void</span> Then&lt;T&gt;(<span>string</span> message, T actionValue, <span>action</span>&lt;T&gt; delegateAction)
        {
            </font><font size="1"><span>try
</span>            {
                InvokeDelegateAction(<span>"Then"</span>, actionValue, delegateAction, message);
            }
            <span>catch</span> (<span>Exception</span> e)
            {
                <span>throw</span> BehaviorException(<span>"Then"</span>, actionValue, e, message);
            }
        }

        <span>private</span> <span>void</span> InvokeDelegateAction&lt;T&gt;(<span>string</span> methodBehavior, T actionValue, <span>action</span>&lt;T&gt; delegateAction, <span>string</span> message)
        {
            delegateAction(actionValue);
            AddMessageToMessageHeap(actionValue, message, methodBehavior);
        }

        <span>private</span> <span>ArgumentException</span> BehaviorException&lt;T&gt;(<span>string</span> methodBehavior, T actionValue, <span>Exception</span> e, <span>string</span> message)
        {
            AddMessageToMessageHeap(actionValue, message, methodBehavior);
            <span>return</span> <span>new</span> <span>ArgumentException</span>(messageHeap, e);
        }

        <span>private</span> <span>void</span> AddMessageToMessageHeap&lt;T&gt;(T actionValue, <span>string</span> message, <span>string</span> methodBehavior)
        {
            messageHeap += <span>string</span>.Format(<span>"{0} {1}: {2}rn"</span>, methodBehavior, message, actionValue);
        }
    }
}</font>
</pre>
                    
                    <p>
                      <a href="http://11011.net/software/vspaste"><a href="http://11011.net/software/vspaste"></a></p> 
                      
                      <p>
                        As you can see this is very crude but it works!&nbsp; Let me know what you think.
                      </p>