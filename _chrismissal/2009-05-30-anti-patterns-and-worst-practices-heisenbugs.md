---
id: 3355
title: Anti-Patterns and Worst Practices – Heisenbugs
date: 2009-05-30T05:00:00+00:00
author: Chris Missal
layout: post
guid: /blogs/chrismissal/archive/2009/05/30/anti-patterns-and-worst-practices-heisenbugs.aspx
dsq_thread_id:
  - "262174914"
categories:
  - Best Practices
  - Design Principles
  - legacy code
  - Testing
---
As I mentioned before, a Heisenbug occurs when trying to check the state of an object. These types of defects are common with concurrency issues are present. Microsoft has put out a library to help diagnose these problems: <a href="http://research.microsoft.com/en-us/projects/chess/" target="_blank">CHESS</a> ([http://msdn.microsoft.com/en-us/devlabs/cc950526.aspx](http://msdn.microsoft.com/en-us/devlabs/cc950526.aspx "http://msdn.microsoft.com/en-us/devlabs/cc950526.aspx")). I&rsquo;m not going to be addressing the concurrency issue, but the <span style="text-decoration: line-through">more common</span>&nbsp;_simpler_ types of Heisenbugs; the occurrences of these types of flaws in a &ldquo;normal&rdquo; application. When digging deeper into the issue, you may be causing more of a problem. This type of bug can manifest itself when not adhering to <a href="http://en.wikipedia.org/wiki/Command-Query_Separation" target="_blank">command-query separation guidelines</a> (CQS). I&rsquo;ve seen a prime example of this in code that performs calculations and validation inside a C# property setter.

### Breaking CQS

When you first glance at this code, you may immediately identify that there&rsquo;s a problem here. If you do, good for you; this is the kind of code that breaks CQS guidelines and can creep into your codebase if you&rsquo;re not careful. (Another reason pair-programming and code reviews are extremely helpful)

<pre><span style="color: blue">public </span><span style="color: #2b91af">IShippingMethod </span>ShippingMethod<br />{<br />    <span style="color: blue">get<br />    </span>{<br />        <span style="color: blue">return </span>shippingMethod;<br />    }<br />    <span style="color: blue">set<br />    </span>{<br />        <span style="color: blue">if</span>(<span style="color: blue">value</span>.IsValidFor(<span style="color: blue">this</span>))<br />            shippingMethod = <span style="color: blue">value</span>;<br />    }<br />}</pre>

[](http://11011.net/software/vspaste)

Why is this bad? If you haven&rsquo;t spotted it already, it&rsquo;s the conditional inside the the setter. If you&rsquo;re a consumer of this API, you can set the ShippingMethod and immediately after, the value that you set is not the value currently assigned. This type of behavior inside a setter hasn&rsquo;t been as common to me as it could be (thankfully), but I&rsquo;ve seen other behaviors that can cause issues. Take this similar example:

<pre><span style="color: blue">public </span><span style="color: #2b91af">IShippingMethod </span>ShippingMethod<br />{<br />    <span style="color: blue">get<br />    </span>{<br />        <span style="color: blue">return </span>shippingMethod;<br />    }<br />    <span style="color: blue">set<br />    </span>{<br />        <span style="color: blue">if</span>(<span style="color: blue">value</span>.IsValidFor(<span style="color: blue">this</span>))<br />        {<br />            shippingMethod = <span style="color: blue">value</span>;<br />            shippingCode = <span style="color: blue">value</span>.GenerateShippingCode(<span style="color: blue">this</span>);<br />        }<br />        <span style="color: blue">else<br />        </span>{<br />            shippingCode = <span style="color: #2b91af">ShippingCode</span>.GROUND;<br />        }<br />    }<br />}</pre>

[](http://11011.net/software/vspaste)

The setting of one property is deciding a change in another field. You could essentially set the ShippingCode, then set the ShippingMethod and have a different result in the ShippingCode you just assigned. If you want to make things worse, put that shippingCode assignment operator inside the get of the ShippingMethod property. Why would anybody do this? Because <a title="Murphy's Law" href="http://en.wikipedia.org/wiki/Murphy%27s_law" target="_blank">if it can be done, it will be done</a> at some point. Talk about driving a developer crazy!?

Here is where CQS comes into play. In our <span style="text-decoration: underline">query</span> of what the Order&rsquo;s ShippingMethod was, we were also <span style="text-decoration: underline">commanding</span> it to recalculate another value. (_This example is based off of one that I&rsquo;ve seen. You can replace the set property with a function that sets it, this provides a little bit more visibility to the developer that something is going to happen. In .Net the getters/setters are functions behind the scenes, but there is a bit of an understanding that these aren&rsquo;t supposed to perform actions. See <a href="http://msdn.microsoft.com/en-us/library/bb384054.aspx" target="_blank">AutoProperties</a>._) In the previous example I could show commands being performed inside the get, actually doing both a command and query, blatantly violating CQS, but I&rsquo;ll spare you some pungent code smell.

### Stack Memory Allocation

These types of defects can be avoided by being careful and understanding your code base. Not all the time do we have the luxury of working with code we&rsquo;ve written. This similar type of behavior can exist in places where you&rsquo;re not used it. Take the following test, it seems to make sense.

<pre>[<span style="color: #2b91af">Test</span>]<br />    <span style="color: blue">public void </span>NotificationService_should_have_first_message_equal_to_one()<br />    {<br />        <span style="color: green">// Arrange<br />        </span><span style="color: blue">var </span>service = <span style="color: blue">new </span><span style="color: #2b91af">NotificationService</span>();<br /><br />        <span style="color: green">// Act<br />        </span><span style="color: blue">var </span>first = service.GetNextNotification();<br /><br />        <span style="color: green">// Assert<br />        </span><span style="color: #2b91af">Assert</span>.That(first.Message, <span style="color: #2b91af">Is</span>.EqualTo(<span style="color: #a31515">"one"</span>));<br />    }<br />}</pre>

This test passes with no problems if you run it straight through without examining it. However, when you step through the code with the debugger turned on:

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" alt="debugger" src="//lostechies.com/chrismissal/files/2011/03/debugger_thumb_34DA530A.jpg" width="426" border="0" height="211" />](//lostechies.com/chrismissal/files/2011/03/debugger_2537B748.jpg) 

With the highlighted text above, I added a QuickWatch to determine what the value will be when calling the GetNextNotification function on NotificationService. My test was passing, it should return the value I&rsquo;m asserting below; it should return the string &ldquo;one&rdquo;:

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" alt="quickWatch" src="//lostechies.com/chrismissal/files/2011/03/quickWatch_thumb_01A0AA52.jpg" width="625" border="0" height="268" />](//lostechies.com/chrismissal/files/2011/03/quickWatch_7D93CBCE.jpg) 

In this screen shot of the QuickWatch dialog, you can see that the value of the Notification&rsquo;s Message property is &ldquo;two&rdquo;. Why on earth would it be different this time around? As small as this example is, it proves that Heisenbugs can most certainly exist in very simple environments. Why does this exist? Well, in this example, it&rsquo;s due to poor implementation. You may have spotted it already with the name of my Get**Next**Notification function. The **Next** is the giveaway, I could have omitted the Next in the function name and made it even harder to figure out, it&rsquo;s returning the top of a Stack<string> collection. The debugger is helping break this (by the debugger examining it, I&rsquo;m getting commands & queries, thus unexpected behavior).

<pre><span style="color: blue">public </span><span style="color: #2b91af">Notification </span>GetNextNotification()<br />{<br />    <span style="color: blue">return </span>stack.Pop();<br />}</pre>

[](http://11011.net/software/vspaste)

### Dealing with Deferred Execution

The last type of Heisenbug I&rsquo;d like to briefly touch on is a side effect of some newer functionality of the .Net runtime, <a href="http://msdn.microsoft.com/en-us/library/bb669162(loband).aspx" target="_blank">deferred execution</a>.

> _Deferred execution means that the evaluation of an expression is delayed until its realized value is actually required. Deferred execution can greatly improve performance when you have to manipulate large data collections, especially in programs that contain a series of chained queries or manipulations. In the best case, deferred execution enables only a single iteration through the source collection. (<a href="http://msdn.microsoft.com/en-us/library/bb943859(loband).aspx" target="_blank">From MSDN</a>)_

**I&rsquo;m not suggesting that deferred execution is a Heisenbug**, just that you can get some unexpected behavior when dealing with it. If you check out <a title="Deferred Execution in LINQ" href="http://geekswithblogs.net/cwilliams/archive/2008/03/20/120673.aspx" target="_blank">Chris Williams&rsquo; example</a> you&rsquo;ll see a nice quick example of how this can be &ldquo;weird&rdquo;. Here&rsquo;s the C# version of his example:

<pre><span style="color: blue">var </span>filter = <span style="color: #a31515">"System"</span>;<br /><span style="color: blue">var </span>query = <span style="color: blue">from </span>a <span style="color: blue">in </span><span style="color: #2b91af">AppDomain</span>.CurrentDomain.GetAssemblies()<br />            <span style="color: blue">where </span>a.GetName().Name.Contains(filter)<br />            <span style="color: blue">select </span>a.GetName().Name;<br /><span style="color: green">//filter = "Xml";</span></pre>

[](http://11011.net/software/vspaste)

When you&rsquo;re dealing with LINQ or _yield return_, just keep in mind what&rsquo;s going on and you should be fine. The unexpected behavior in my experience is most noticeable when testing with the debugger, all the more reason to avoid it. 😉

[See more <a href="/blogs/chrismissal/archive/2009/05/25/anti-patterns-and-worst-practices-you-re-doing-it-wrong.aspx" target="_self">Anti-Patterns and Worst Practices</a>]