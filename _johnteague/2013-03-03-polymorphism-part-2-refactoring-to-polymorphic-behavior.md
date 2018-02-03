---
wordpress_id: 3783
title: 'Polymorphism Part 2: Refactoring to Polymorphic Behavior'
date: 2013-03-03T21:50:07+00:00
author: John Teague
layout: post
wordpress_guid: http://lostechies.com/johnteague/?p=184
dsq_thread_id:
  - "1116600029"
categories:
  - Uncategorized
---
I spoke at the Houston C# User Group earlier this year.&nbsp; Before my talk [Peter Seale](https://twitter.com/pseale) did an introductory presentation on refactoring.&nbsp; He had sample code to calculate discounts on an order based on the number of items in the shopping cart.&nbsp; There were several opportunities for refactoring in his sample.&nbsp; He asked the audience how they thought the code sample could be improved.&nbsp; He got several responses like making it easier to read and reducing duplicated code.&nbsp; My response was a bit different; while the code worked just fine and did the job, it was very procedural in nature and did not take advantage of the object-oriented features available in the language.&nbsp;&nbsp; 

One of the most important, but overlooked refactoring strategies is converting logic branches to polymorphic behavior.&nbsp; Reducing complicated branching can yield significant results in simplifying your code base, making it easier to test and read. 

## The Evils of the switch Statement

One of my first large applications that I had a substantial influence on the design of the application had some code that looked like this: 

<pre class="csharpcode"><span class="kwrd">private</span> <span class="kwrd">string</span> SetDefaultEditableText()
{
  StringBuilder editableText = <span class="kwrd">new</span> StringBuilder();
    <span class="kwrd">switch</span> ( SurveyManager.CurrentSurvey.TypeID )
    {
        <span class="kwrd">case</span> 1:
        editableText.Append(<span class="str">"&lt;p&gt;Text for Survey Type 2 Goes Here&lt;/p&gt;"</span>);                            
        <span class="kwrd">case</span> 2:
        editableText.Append(<span class="str">"&lt;p&gt;Text for Survey Type 2 Goes Here&lt;/p&gt;"</span>);
        <span class="kwrd">case</span> 3:
        <span class="kwrd">default</span>:
        editableText.Append(<span class="str">"&lt;p&gt;Text for Survey Type 3 Goes Here&lt;/p&gt;"</span>);
    }
    <span class="kwrd">return</span> editableText.ToString();
} </pre>

Now there are a lot of problems with this code (a Singleton, really).&nbsp; But I want to focus on the use of the switch statement. As a language feature, the switch statement can be very useful. But when designing a large-scale application it can be crippling and using it breaks a lot of OOD principles.&nbsp; For starters if you use switch statement like this in your code, chances are you are going to need to do it again.&nbsp; Now you’ve got duplicated logic scattered about your application.&nbsp; If you ever need to add a new case branch to your switch statement you now have to go through the entire application code base and look where you used these statements and change them. 

What is really happening is changing the behavior of our app based on some condition.&nbsp; We can do the same thing using polymorphism and make our system less complex and easier to maintain.&nbsp; Suppose you are running a Software as a Service application and you’ve got a couple of different premium services that you charge for.&nbsp; One of them is a flat fee and the other service fee is calculated by the number of users on the account.&nbsp; The procedural approach to this might be done by creating an enum for the service type and then use switch statement to branch the logic. 

<pre class="csharpcode"><span class="kwrd">public</span> <span class="kwrd">enum</span> ServiceTypeEnum
{
    ServiceA, ServiceB
} 

<span class="kwrd">public</span> <span class="kwrd">class</span> Account
{
    <span class="kwrd">public</span> <span class="kwrd">int</span> NumOfUsers{get;set;}
    <span class="kwrd">public</span> ServiceTypeEnum[] ServiceEnums { get; set; }
} 

<span class="rem">// calculate the service fee</span>
<span class="kwrd">public</span> <span class="kwrd">double</span> CalculateServiceFeeUsingEnum(Account acct)
{
    <span class="kwrd">double</span> totalFee = 0;
    <span class="kwrd">foreach</span> (var service <span class="kwrd">in</span> acct.ServiceEnums) { 

        <span class="kwrd">switch</span> (service)
        {
            <span class="kwrd">case</span> ServiceTypeEnum.ServiceA:
                totalFee += acct.NumOfUsers * 5;
                <span class="kwrd">break</span>;
            <span class="kwrd">case</span> ServiceTypeEnum.ServiceB:
                totalFee += 10;
                <span class="kwrd">break</span>;
        }
    }
    <span class="kwrd">return</span> totalFee;
} 
</pre>

This has all of the same problems as the code above. As the application gets bigger, the chances of having similar branch statements are going to increase.&nbsp; Also as you roll out more premium services you’ll have to continually modify this code, which violates the Open-Closed Principle.&nbsp; There are other problems here too.&nbsp; The function to calculate service fee should not need to know the actual amounts of each service.&nbsp; That is information that needs to be encapsulated. 

_A slight aside: enums are a very limited data structure.&nbsp; If you are not using an enum for what it really is, a labeled integer, you need a class to truly model the abstraction correctly.&nbsp; You can use_ [_Jimmy’s_](http://jimmybogard.lostechies.com) _awesome_ [_Enumeration class_](http://lostechies.com/jimmybogard/2008/08/12/enumeration-classes/) _to use classes to also us them as labels._ 

Let’s refactor this to use polymorphic behavior.&nbsp; What we need is abstraction that will allow us to contain the behavior necessary to calculate the fee for a service. 

<pre class="csharpcode"><span class="kwrd">public</span> <span class="kwrd">interface</span> ICalculateServiceFee
{
    <span class="kwrd">double</span> CalculateServiceFee(Account acct);
} </pre>

Several people in my previous post asked me why I started with an interface and if by doing so is it really polymorphism.&nbsp; My coding style is generally favors composition than inheritance (which I hope to discuss later), so I generally don’t have deep inheritance trees.&nbsp; Going by the definition of I provided: “_Polymorphism lets you have different behavior for sub types, while keeping a consistent contract_.”&nbsp; it really doesn’t matter if it starts with an interface or a base class as you get the same benefits. I would not introduce a base class until I really needed too. 

Now we can create our concrete implementations of the interface and attach them the account. 

<pre class="csharpcode"><span class="kwrd">public</span> <span class="kwrd">class</span> Account{
    <span class="kwrd">public</span> <span class="kwrd">int</span> NumOfUsers{get;set;}
    <span class="kwrd">public</span> ICalculateServiceFee[] Services { get; set; }
} 

<span class="kwrd">public</span> <span class="kwrd">class</span> ServiceA : ICalculateServiceFee
{
    <span class="kwrd">double</span> feePerUser = 5; 

    <span class="kwrd">public</span> <span class="kwrd">double</span> CalculateServiceFee(Account acct)
    {
        <span class="kwrd">return</span> acct.NumOfUsers * feePerUser;
    }
} 

<span class="kwrd">public</span> <span class="kwrd">class</span> ServiceB : ICalculateServiceFee
{
    <span class="kwrd">double</span> serviceFee = 10;
    <span class="kwrd">public</span> <span class="kwrd">double</span> CalculateServiceFee(Account acct)
    {
        <span class="kwrd">return</span> serviceFee;
    }
} 
</pre>

Now we can calculate the total service fee using these abstractions.

<pre class="csharpcode"><span class="kwrd">public</span> <span class="kwrd">double</span> CalculateServiceFee(Account acct){
    <span class="kwrd">double</span> totalFee = 0;
    <span class="kwrd">foreach</span> (var svc <span class="kwrd">in</span> acct.Services)
    {
        totalFee += svc.CalculateServiceFee(acct);
    }
    <span class="kwrd">return</span> totalFee;
} <br /></pre>

Now we’ve completely abstracted the details of how to calculate service fees into simple, easy to understand classes that are also much easier test. Creating a new service type can be done without changing the code for calculating the total service fee. 

<pre class="csharpcode"><span class="kwrd">public</span> <span class="kwrd">class</span> ServiceC : ICalculateServiceFee
{
    <span class="kwrd">double</span> serviceFee = 15;
    <span class="kwrd">public</span> <span class="kwrd">double</span> CalculateServiceFee(Account acct)
    {
        <span class="kwrd">return</span> serviceFee;
    }
} </pre>

But now we have introduced some duplicated code, since the new service behaves the same as <font face="Consolas">ServiceB</font>.&nbsp; This is the point where a base class is useful.&nbsp; We can pull up the duplicated code into base classes. 

<pre class="csharpcode"><span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> PerUserServiceFee : ICalculateServiceFee
{
    <span class="kwrd">private</span> <span class="kwrd">double</span> feePerUser;
    <span class="kwrd">public</span> PerUserServiceFee(<span class="kwrd">double</span> feePerUser)
    {
        <span class="kwrd">this</span>.feePerUser = feePerUser;
    }
    <span class="kwrd">public</span> <span class="kwrd">double</span> CalculateServiceFee(Account acct){
        <span class="kwrd">return</span>  feePerUser * acct.NumOfUsers; 
   }
}
</pre>

<pre class="csharpcode"><span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> MonthlyServiceFee : ICalculateServiceFee
{
    <span class="kwrd">private</span>  <span class="kwrd">double</span> serviceFee;
    <span class="kwrd">public</span> MonthlyServiceFee(<span class="kwrd">double</span> serviceFee)
    {
        <span class="kwrd">this</span>.serviceFee = serviceFee;
    } 

    <span class="kwrd">public</span> <span class="kwrd">double</span> CalculateServiceFee(Account acct)
    {
        <span class="kwrd">return</span> serviceFee;
    }
} 

</pre>

Now our concrete classes just need to pass the <font face="consolas">serviceFee</font> value to their respective base classes by using the base keyword as part of their constructor. 

<pre class="csharpcode"><span class="kwrd">public</span> <span class="kwrd">class</span> ServiceA : PerUserServiceFee
{
    <span class="kwrd">public</span> ServiceA() : <span class="kwrd">base</span>(5) { }
} 

<span class="kwrd">public</span> <span class="kwrd">class</span> ServiceB : MonthlyServiceFee 
{
    <span class="kwrd">public</span> ServiceB() : <span class="kwrd">base</span>(10) { }
} 

<span class="kwrd">public</span> <span class="kwrd">class</span> ServiceC : MonthlyServiceFee
{
    <span class="kwrd">public</span> ServiceC() : <span class="kwrd">base</span>(15) { }
} 

</pre>

Also, because we started with the interface and our base classes implement it, none of the existing code needs to change because of this refactor. 

Next time you catch yourself using a switch statement, or even an if-else statement, consider using the object-oriented features at your disposal first.&nbsp; By creating abstractions for behavior, your application will be a lot easier to manage.