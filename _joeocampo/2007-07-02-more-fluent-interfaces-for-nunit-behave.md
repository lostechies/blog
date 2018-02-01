---
id: 30
title: More Fluent Interfaces for NUnit.Behave
date: 2007-07-02T20:29:15+00:00
author: Joe Ocampo
layout: post
guid: /blogs/joe_ocampo/archive/2007/07/02/more-fluent-interfaces-for-nunit-behave.aspx
dsq_thread_id:
  - "262088252"
categories:
  - BDD (Behavior Driven Development)
---
I have been enhancing the overall structure of NUnit.Behave to evolve to a more <a href="http://www.martinfowler.com/bliki/FluentInterface.html" target="_blank">fluent interface</a>.&nbsp; The following is a working example of what I have come up with.

&nbsp;

<div>
  <pre><span><span>            Story(</span><span>"Account Holder withdraws cash"</span><span>)
                .As_a(</span><span>"savings account holder"</span><span>)
                .I_Want(</span><span>"to transfer money from my savings account"</span><span>)
                .So_That(</span><span>"I can get cash easily from an ATM"</span><span>)
                .Scenario(</span><span>"savings account is overdrawn"</span><span>)
                .Given(</span><span>"my savings account balance is"</span><span>, -20)
                .And(</span><span>"my cash account balance is"</span><span>, 10)
                .When(</span><span>"I transfer to cash account"</span><span>, 20)
                .Then(</span><span>"my savings account balance should be"</span><span>, -20)
                .And(</span><span>"my cash account balance should be"</span><span>, 10);</span></span></pre>
  
  <p>
    <a href="http://11011.net/software/vspaste"></a></div> 
    
    <p>
      &nbsp;In the test runner the following output appears.
    </p>
    
    <p>
      <font face="Courier New">Story: Account Holder withdraws cash<br />Narrative: As a savings account holder <br />&nbsp;&nbsp;&nbsp; I want to transfer money from my savings account <br />&nbsp;&nbsp;&nbsp; so that I can get cash easily from an ATM. </font>
    </p>
    
    <p>
      <font face="Courier New">&nbsp;&nbsp;&nbsp; Scenario: savings account is overdrawn<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Given my savings account balance is: -20 !PENDING Delegate IMPLEMENTATION!<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; And my cash account balance is: 10 !PENDING Delegate IMPLEMENTATION!<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; When I transfer to cash account: 20 !PENDING Delegate IMPLEMENTATION!<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Then my savings account balance should be: -20 !PENDING Delegate IMPLEMENTATION!<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; And my cash account balance should be: 10 !PENDING Delegate IMPLEMENTATION!</font>
    </p>
    
    <p>
      Don&#8217;t worry I am working on &#8220;!PENDING&#8221; but I just needed something as placeholder for the time being.
    </p>
    
    <p>
      I love this fluent interface approach though.&nbsp; It really makes the code much more maintainable.
    </p>