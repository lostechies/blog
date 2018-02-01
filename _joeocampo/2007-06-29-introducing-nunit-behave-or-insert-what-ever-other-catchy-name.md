---
id: 29
title: Introducing NUnit.Behave or insert what ever other catchy name
date: 2007-06-29T01:36:17+00:00
author: Joe Ocampo
layout: post
guid: /blogs/joe_ocampo/archive/2007/06/28/introducing-nunit-behave-or-insert-what-ever-other-catchy-name.aspx
dsq_thread_id:
  - "262089437"
categories:
  - BDD (Behavior Driven Development)
---
OK I was bored yesterday and I decided to update what I had worked on the other day from <a href="http://dannorth.net/" target="_blank">Dan North&#8217;s</a> post on <a href="http://dannorth.net/2007/06/introducing-rbehave" target="_blank">rbehave</a>.

Let look at my original attempt.

<pre>[<span>Test</span>]
        <span>public</span> <span>void</span> Transfer_to_cash_account()
        {
            <span>/*
                 As a savings account holder
                 I want to transfer money from my savings account
                 So that I can get cash easily from an ATM)
             */

</span>            <span>Account</span> savings = <span>null</span>;
            <span>Account</span> cash = <span>null</span>;

            Scenario(<span>"savings account is in credit"</span>);
            Given(<span>"my savings account balance is"</span>, 100,
                  <span>delegate</span>(<span>int</span> accountBallance)
                      {
                          savings = <span>new</span> <span>Account</span>(accountBallance);
                      });

            Given(<span>"my cash account balance is"</span>, 10,
                  <span>delegate</span>(<span>int</span> accountBallance)
                      {
                          cash = <span>new</span> <span>Account</span>(accountBallance);
                      });

            When(<span>"I transfer to cash account"</span>, 20,
                 <span>delegate</span>(<span>int</span> transferAmount)
                     {
                         savings.TransferTo(cash, transferAmount);
                     });

            Then(<span>"my savings account balance should be"</span>, 80,
                 <span>delegate</span>(<span>int</span> expectedBallance)
                     {
                         <span>Assert</span>.AreEqual(expectedBallance, savings.Ballance);
                     });
            Then(<span>"my cash account balance should be"</span>, 30,
                 <span>delegate</span>(<span>int</span> expectedBallance)
                     {
                         <span>Assert</span>.AreEqual(expectedBallance, cash.Ballance);
                     });

        }</pre>

[](http://11011.net/software/vspaste)

This will work but the delegates can get really old especially is you want to have several scenarios.&nbsp; So I decided to use basially make a composite key out of the behavior and the message.&nbsp; I then created a Hashtable to store the key with the corresponding delegate.&nbsp; What does this allow me to do.&nbsp; Well now I can write additional scenarios with out having to worry about the initial plumbing.&nbsp; Observe.

<pre>[<span>Test</span>]
        <span>public</span> <span>void</span> Transfer_to_cash_account()
        {
            <span>/*
                 As a savings account holder
                 I want to transfer money from my savings account
                 So that I can get cash easily from an ATM)
             */

</span>            <span>Account</span> savings = <span>null</span>;
            <span>Account</span> cash = <span>null</span>;

            Scenario(<span>"savings account is in credit"</span>);
            Given(<span>"my savings account balance is"</span>, 100,
                  <span>delegate</span>(<span>int</span> accountBallance)
                      {
                          savings = <span>new</span> <span>Account</span>(accountBallance);
                      });

            Given(<span>"my cash account balance is"</span>, 10,
                  <span>delegate</span>(<span>int</span> accountBallance)
                      {
                          cash = <span>new</span> <span>Account</span>(accountBallance);
                      });

            When(<span>"I transfer to cash account"</span>, 20,
                 <span>delegate</span>(<span>int</span> transferAmount)
                     {
                         savings.TransferTo(cash, transferAmount);
                     });

            Then(<span>"my savings account balance should be"</span>, 80,
                 <span>delegate</span>(<span>int</span> expectedBallance)
                     {
                         <span>Assert</span>.AreEqual(expectedBallance, savings.Ballance);
                     });
            Then(<span>"my cash account balance should be"</span>, 30,
                 <span>delegate</span>(<span>int</span> expectedBallance)
                     {
                         <span>Assert</span>.AreEqual(expectedBallance, cash.Ballance);
                     });
            
            Given(<span>"my savings account balance is"</span>, 400);
            Given(<span>"my cash account balance is"</span>, 100);
            When(<span>"I transfer to cash account"</span>, 100);
            Then(<span>"my savings account balance should be"</span>, 300);
            Then(<span>"my cash account balance should be"</span>, 200);

        }</pre>

[](http://11011.net/software/vspaste)

Much nicer but then I didn&#8217;t like how it read so I created a template pattern that would allow the Given, When, Then methods to return a conjunction type that would allow me to write more readable scenarios. For instance:

<pre>Given(<span>"my savings account balance is"</span>, 500)
                .And(<span>"my cash account balance is"</span>, 20)
                .When(<span>"I transfer to cash account"</span>, 30)
                .Then(<span>"my savings account balance should be"</span>, 470)
                .And(<span>"my cash account balance should be"</span>, 50);


            Scenario(<span>"savings account is overdrawn"</span>);
            Given(<span>"my savings account balance is"</span>, -20)
                .And(<span>"my cash account balance is"</span>, 10)
                .When(<span>"I transfer to cash account"</span>, 20)
                .Then(<span>"my savings account balance should be"</span>, -20)
                .And(<span>"my cash account balance should be"</span>, 10);</pre>

[](http://11011.net/software/vspaste)

Yup that&#8217;s the ticket.&nbsp; Now you can run the test from within NUnit and the test runner will produce the following output in the console.

&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8211; 

Scenario: savings account is in credit  
Given my savings account balance is: 100  
And my cash account balance is: 10  
When I transfer to cash account: 20  
Then my savings account balance should be: 80  
And my cash account balance should be: 30 

Scenario: savings account is in credit  
Given my savings account balance is: 400  
And my cash account balance is: 100  
When I transfer to cash account: 100  
Then my savings account balance should be: 300  
And my cash account balance should be: 200 

Scenario: savings account is in credit  
Given my savings account balance is: 500  
And my cash account balance is: 20  
When I transfer to cash account: 30  
Then my savings account balance should be: 470  
And my cash account balance should be: 50 

Scenario: savings account is overdrawn  
Given my savings account balance is: -20  
And my cash account balance is: 10  
When I transfer to cash account: 20  
Then my savings account balance should be: -20  
And my cash account balance should be: 10  
&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8211; 

&nbsp;

As you can see the message heap evaluates for redundant actions (&#8220;Given&#8221; &#8220;Given&#8221;) and replaces the second instance with &#8220;And&#8221; making the output much more readable.

Here is the entire test fixture.

<pre><span>using</span> NUnit.Behave;
<span>using</span> NUnit.Framework;

<span>namespace</span> BehavioralExample
{
    <span>public</span> <span>class</span> <span>Account_Specs</span> : <span>BehavioralFixture
</span>    {
        [<span>Test</span>]
        <span>public</span> <span>void</span> Transfer_to_cash_account()
        {
            <span>/*
                 As a savings account holder
                 I want to transfer money from my savings account
                 So that I can get cash easily from an ATM)
             */

</span>            <span>Account</span> savings = <span>null</span>;
            <span>Account</span> cash = <span>null</span>;

            Scenario(<span>"savings account is in credit"</span>);
            Given(<span>"my savings account balance is"</span>, 100,
                  <span>delegate</span>(<span>int</span> accountBallance)
                      {
                          savings = <span>new</span> <span>Account</span>(accountBallance);
                      });

            Given(<span>"my cash account balance is"</span>, 10,
                  <span>delegate</span>(<span>int</span> accountBallance)
                      {
                          cash = <span>new</span> <span>Account</span>(accountBallance);
                      });

            When(<span>"I transfer to cash account"</span>, 20,
                 <span>delegate</span>(<span>int</span> transferAmount)
                     {
                         savings.TransferTo(cash, transferAmount);
                     });

            Then(<span>"my savings account balance should be"</span>, 80,
                 <span>delegate</span>(<span>int</span> expectedBallance)
                     {
                         <span>Assert</span>.AreEqual(expectedBallance, savings.Ballance);
                     });
            Then(<span>"my cash account balance should be"</span>, 30,
                 <span>delegate</span>(<span>int</span> expectedBallance)
                     {
                         <span>Assert</span>.AreEqual(expectedBallance, cash.Ballance);
                     });

            Given(<span>"my savings account balance is"</span>, 400);
            Given(<span>"my cash account balance is"</span>, 100);
            When(<span>"I transfer to cash account"</span>, 100);
            Then(<span>"my savings account balance should be"</span>, 300);
            Then(<span>"my cash account balance should be"</span>, 200);

            Given(<span>"my savings account balance is"</span>, 500)
                .And(<span>"my cash account balance is"</span>, 20)
                .When(<span>"I transfer to cash account"</span>, 30)
                .Then(<span>"my savings account balance should be"</span>, 470)
                .And(<span>"my cash account balance should be"</span>, 50);


            Scenario(<span>"savings account is overdrawn"</span>);
            Given(<span>"my savings account balance is"</span>, -20)
                .And(<span>"my cash account balance is"</span>, 10)
                .When(<span>"I transfer to cash account"</span>, 20)
                .Then(<span>"my savings account balance should be"</span>, -20)
                .And(<span>"my cash account balance should be"</span>, 10);
        }
    }
}

<span>public</span> <span>class</span> <span>Account
</span>{
    <span>private</span> <span>int</span> accountBallance;

    <span>public</span> Account(<span>int</span> accountBallance)
    {
        <span>this</span>.accountBallance = accountBallance;
    }

    <span>public</span> <span>int</span> Ballance
    {
        <span>get</span> { <span>return</span> accountBallance; }
        <span>set</span> { accountBallance = <span>value</span>; }
    }

    <span>public</span> <span>void</span> TransferTo(<span>Account</span> account, <span>int</span> amount)
    {
        <span>if</span> (accountBallance &gt; 0)
        {
            account.Ballance = account.Ballance + amount;
            Ballance = Ballance - amount;
        }
    }
}</pre>

[](http://11011.net/software/vspaste)

I am uploading the code to Google code and should have it ready shortly.&nbsp; Just having trouble with Ankh and Tortoise.&nbsp;

I am not to crazy about inheriting an abstract class as <a href="http://codebetter.com/blogs/scott.bellware/default.aspx" target="_blank">Scott Bellware</a> mentioned but I just can&#8217;t seem to get around it since C# is not a dynamic language.&nbsp; Let me know what you all think?&nbsp; Am I on the right track?&nbsp; Either way I am having fun coding!

You can download the code from the following link:

[http://code.google.com/p/nunitbehave/source](http://code.google.com/p/nunitbehave/source "http://code.google.com/p/nunitbehave/source")