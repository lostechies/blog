---
wordpress_id: 154
title: The many faces of ExpectedException
date: 2008-03-11T02:25:55+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/03/10/the-many-faces-of-expectedexception.aspx
dsq_thread_id:
  - "264715596"
categories:
  - TDD
---
I&#8217;m not a fan of the style most xUnit frameworks suggest for verifying exceptions.&nbsp; After seeing the problems with using an attribute to perform assertions, many frameworks have come up with their own way of their own way of doing it.&nbsp; Outside using a different xUnit framework, you can also perform this verification manually inside your test.&nbsp; It&#8217;s not quite as explicit, but it&#8217;s possible.

Suppose we have the following OrderProcessor that we&#8217;d like to test:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">OrderProcessor
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">INotificationService </span>_notificationService;

    <span style="color: blue">public </span>OrderProcessor(<span style="color: #2b91af">INotificationService </span>notificationService)
    {
        <span style="color: blue">if </span>(notificationService == <span style="color: blue">null</span>)
            <span style="color: blue">throw new </span><span style="color: #2b91af">ArgumentNullException</span>(<span style="color: #a31515">"notificationService"</span>);

        _notificationService = notificationService;
    }

    <span style="color: blue">public void </span>ProcessOrder(<span style="color: #2b91af">Order </span>order)
    {
        <span style="color: blue">if </span>(order == <span style="color: blue">null</span>)
            <span style="color: blue">throw new </span><span style="color: #2b91af">ArgumentNullException</span>(<span style="color: #a31515">"order"</span>);
    }
}
</pre>

[](http://11011.net/software/vspaste)

Note that the same exception type is thrown from two different locations.&nbsp; What I&#8217;d like to do is <strike>create a test</strike> specify some behavior that when ProcessOrder is called, it errors when the Order is null.&nbsp; There are several ways of doing this, some that work better than others.

### Using attributes

To set an expectation that a block of code will throw a certain type of exception, you need to decorate your test method with an ExpectedException attribute.&nbsp; Both NUnit, MSTest, and MbUnit provide this attribute (all with the same name).&nbsp; For example, here&#8217;s an NUnit test verifying the exception test:

<pre>[<span style="color: #2b91af">Test</span>]
[<span style="color: #2b91af">ExpectedException</span>(<span style="color: blue">typeof</span>(<span style="color: #2b91af">ArgumentNullException</span>))]
<span style="color: blue">public void </span>Should_throw_ArgumentNullException_when_the_Order_is_null()
{
    <span style="color: #2b91af">OrderProcessor </span>processor = <span style="color: blue">new </span><span style="color: #2b91af">OrderProcessor</span>(<span style="color: blue">null</span>);

    processor.ProcessOrder(<span style="color: blue">null</span>);
}
</pre>

[](http://11011.net/software/vspaste)

This test passes, but for the wrong reason.&nbsp; When I pass in the null argument for the OrderProcessor constructor, the constructor throws the exception, and the ProcessOrder method is never even executed!&nbsp; This tests passes, but only accidentally.

Additionally, it&#8217;s not clear from the body of the test what specifically is supposed to fail.&nbsp; As long as anything inside the method body throws the correct exception, the test will pass.&nbsp; I don&#8217;t like tests passing accidentally and I don&#8217;t like opaque tests.

Although NUnit&#8217;s ExpectedException attribute has additional parameters for checking messages, etc., it&#8217;s still a kludge around the real problem of using an attribute to perform assertions.

### Manual checking

This is my preferred method when using NUnit, MSTest or MbUnit.&nbsp; In this style, I put a try-catch block explicitly around the statement of code I expect to throw the exception.&nbsp; Using NUnit:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_throw_ArgumentNullException_when_the_Order_is_null()
{
    <span style="color: #2b91af">OrderProcessor </span>processor = <span style="color: blue">new </span><span style="color: #2b91af">OrderProcessor</span>(<span style="color: blue">null</span>);

    <span style="color: blue">try
    </span>{
        processor.ProcessOrder(<span style="color: blue">null</span>);
        <span style="color: #2b91af">Assert</span>.Fail(<span style="color: #a31515">"Should throw ArgumentNullException"</span>);
    }
    <span style="color: blue">catch </span>(<span style="color: #2b91af">ArgumentNullException</span>)
    {
    }
}
</pre>

[](http://11011.net/software/vspaste)

If the test code gets past ProcessOrder, I force a test failure (and provide a meaningful message).&nbsp; This test now fails, as the constructor is the statement throwing the exception.&nbsp; I get a fast, meaningful failure when ProcessOrder does not throw the expected exception.

I test a specific exception type by only including that exception in the catch block.&nbsp; If some other exception is thrown, the exception won&#8217;t get caught by my specific catch block, and the test will fail.

There are several variations of the manual checking, but the basic idea is the same.&nbsp; Put a try-catch block only around the statement that should throw, and put in specific checking to make sure the test passes only when the exception you want is thrown.

### xUnit.net style &#8211; Assert.Throws

Instead of using an attribute or doing manual try-catch blocks, xUnit.net introduces an Assert.Throws method, where I can supply behavior through a delegate.&nbsp; This is all a mouthful, it&#8217;s easier to see the code:

<pre>[<span style="color: #2b91af">Fact</span>]
<span style="color: blue">public void </span>Should_throw_ArgumentNullException_when_the_Order_is_null()
{
    <span style="color: #2b91af">OrderProcessor </span>processor = <span style="color: blue">new </span><span style="color: #2b91af">OrderProcessor</span>(<span style="color: blue">new </span><span style="color: #2b91af">NotificationService</span>());

    <span style="color: #2b91af">Assert</span>.Throws&lt;<span style="color: #2b91af">ArgumentNullException</span>&gt;(() =&gt; processor.ProcessOrder(<span style="color: blue">null</span>));
}
</pre>

[](http://11011.net/software/vspaste)

I supply the block that should throw in the lambda expression, but this could be an anonymous delegate or function name.

I really like this style as it combines the assertion, the exception type, and the block that throws into one readable statement.&nbsp; Although the parameter-less lambda block can look strange, I&#8217;m able to confine the block that expects the exception to the one statement that should throw, just like I was able to do in the manual example.

Looking at the source code behind the xUnit.net implementation, behind the scenes it does something very similar to the manual example.&nbsp; It just wraps it up into one nice, neat call.

### NBehave style &#8211; fluent interface

As we&#8217;re pushing towards the 0.4 release of NBehave, we&#8217;re trying more fluent syntax using BDD-style extension methods that wrap existing xUnit implementations.&nbsp; For example, a fluent wrapper over MSTest would now look like:

<pre>[<span style="color: #2b91af">TestMethod</span>]
<span style="color: blue">public void </span>Should_throw_ArgumentNullException_when_the_Order_is_null()
{
    <span style="color: #2b91af">OrderProcessor </span>processor = <span style="color: blue">new </span><span style="color: #2b91af">OrderProcessor</span>(<span style="color: blue">new </span><span style="color: #2b91af">NotificationService</span>());

    processor.WhenCalling(x =&gt; x.ProcessOrder(<span style="color: blue">null</span>)).ShouldThrow&lt;<span style="color: #2b91af">ArgumentNullException</span>&gt;();
}
</pre>

[](http://11011.net/software/vspaste)

In the earlier example using lambdas, I was forced to use a parameter-less lambda that looked a little strange.&nbsp; In this case, the specification is meant to be as human-readable as possible, almost sentence-like.&nbsp; With some generics work, the lambda gets strongly typed to the class under test, so I get all of the IntelliSense and refactoring goodness.&nbsp; (I&#8217;m still trying to reverse the order of the methods&#8230;not as simple as it seems.)

### So many choices&#8230;

When it comes down to it, you want a test that:

  * Fails for the reasons you want
  * Can be immediately understood on what it&#8217;s testing

Whichever choice you go with, as long as it conforms to the above criteria, you should come out fine in the end.&nbsp; For me, the attribute method is the only one that doesn&#8217;t achieve either of the above.&nbsp; Exceptions seem to have been made a special case, but since lambdas have made anonymous delegates much easier to deal with, better alternatives exist for the verbose or broken mechanisms we had to use previously.