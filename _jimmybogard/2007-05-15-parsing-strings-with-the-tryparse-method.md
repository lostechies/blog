---
id: 18
title: Parsing strings with the TryParse method
date: 2007-05-15T14:33:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/05/15/parsing-strings-with-the-tryparse-method.aspx
dsq_thread_id:
  - "265998531"
categories:
  - 'C#'
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/parsing-strings-with-tryparse-method.html)._

I recently [posted](http://www.lostechies.com/blogs/jimmy_bogard/archive/2007/05/11/pop-quiz-on-ref-and-out-parameters-in-c.aspx) on the out and ref keywords in C#, and mentioned the only time I&#8217;d see the &#8220;out&#8221; keyword was in the [Tester-Doer](http://msdn2.microsoft.com/en-us/library/ms229009.aspx)&nbsp;pattern.&nbsp; Well, I was really looking for the [Try-Parse](http://blogs.msdn.com/kcwalina/archive/2005/03/16/396787.aspx) pattern (near the end of the post).&nbsp; The Try-Parse pattern is ideal for situations where exceptions might be thrown in common scenarios, like parsing strings for numeric or date-time data.

### A simple example

Let&#8217;s say I&#8217;ve read some text in from an outside source into a string.&nbsp; The outside source could be a querystring, XML, a database row, user input, etc.&nbsp; The problem is that I need the value in terms of an integer, date, or some other primitive type.&nbsp; So how would we do this&nbsp;in .NET 1.0 or 1.1?

<div class="CodeFormatContainer">
  <pre><span class="kwrd">string</span> rawCustomerNumber = GetCustomerNumber();<br />
<br />
<span class="kwrd">try</span><br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">int</span> customerNumber = <span class="kwrd">int</span>.Parse(rawCustomerNumber);<br />
&nbsp;&nbsp;&nbsp;&nbsp;DoSomethingWithCustomerNumber(customerNumber);<br />
}<br />
<span class="kwrd">catch</span><br />
{<br />
}<br />
</pre>
</div>

So what&#8217;s so bad with this code?&nbsp; The real issue is that exceptions are very expensive to handle in .NET.&nbsp; If &#8220;rawCustomerNumber&#8221; often has bad values, this code snippet could kill the performance of our application.&nbsp; Whenever I profile application performance, number of exceptions thrown and caught&nbsp;are one of the first things I&#8217;ll look at since they&#8217;re so expensive.&nbsp; Besides, exceptions are supposed to be exceptional, but in the snippet above, exceptions could happen quite often when parsing text.

### A new way

So how should we parse text going forward?&nbsp; Versions of the .NET Framework starting with 2.0 introduced a new method for most primitive types, &#8220;TryParse&#8221;.&nbsp;&nbsp;Here&#8217;s what&nbsp;Int32.TryParse looks like:&nbsp;

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">bool</span> TryParse (<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">string</span> s,<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">out</span> <span class="kwrd">int</span> result<br />
)</pre>
</div>



Before, the parse method would return the parsed integer value.&nbsp; Now, the return value is a bool, specifying whether or not parsing was successful or not.&nbsp; Exceptions won&#8217;t get thrown if the string isn&#8217;t a valid value anymore, and I now&nbsp;use the &#8220;out&#8221; param to get the parsed value back from the function.&nbsp; Here&#8217;s the modified code:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">string</span> rawCustomerNumber = GetCustomerNumber();<br />
<br />
<span class="kwrd">int</span> customerNumber;<br />
<span class="kwrd">if</span> (Int32.TryParse(rawCustomerNumber, <span class="kwrd">out</span> customerNumber))<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;DoSomethingWithCustomerNumber(customerNumber);<br />
}</pre>
</div>



Although &#8220;out&#8221; params should be generally avoided, in this situation they are perfectly reasonable because the readability has improved.&nbsp; I don&#8217;t like relying on exceptions for flow control logic, which can kill readability.&nbsp; Nothing is more confusing than trying to follow a bunch of nested&nbsp;try-catch blocks to see what the real behavior is supposed to be.&nbsp; Now I have a very clear flow control path, &#8220;If parsing was successful, do something with the result&#8221; instead of &#8220;Try to parse, and if I don&#8217;t get an exception, do something with the result&#8221;.

### A look at the numbers

I timed the two methods calling them 10,000 times with bad values.&nbsp; The original example took nearly 4 seconds to execute, while the TryParse method took less than 100 milliseconds to complete.&nbsp; That&#8217;s over a 40x difference!&nbsp; If this code was deep down in a large stack trace, the difference would be even greater.&nbsp; That&#8217;s some good incentive to pick TryParse over the original Parse method.

### Closing thoughts

The Try-Parse pattern is fairly common in the .NET Framework, and you can find it on [numeric](http://msdn2.microsoft.com/en-us/library/system.int32.tryparse.aspx) [types](http://msdn2.microsoft.com/en-us/library/system.double.tryparse.aspx), [dates](http://msdn2.microsoft.com/en-us/library/system.datetime.tryparse.aspx), even the [Dictionary class](http://msdn2.microsoft.com/en-us/library/zkw5c9ak.aspx).&nbsp; Since it&#8217;s a pattern, you can implement it yourself by following the [FDG recommendations](http://www.amazon.com/Framework-Design-Guidelines-Conventions-Development/dp/0321246756/)&nbsp;detailed [here](http://blogs.msdn.com/kcwalina/archive/2005/03/16/396787.aspx).&nbsp; I&#8217;ve used it in the past for search methods and other situations where I want a result and also a boolean telling me if the operation was successful.&nbsp; The pattern isn&#8217;t for every situation, but it&#8217;s another tool in your repertoire.