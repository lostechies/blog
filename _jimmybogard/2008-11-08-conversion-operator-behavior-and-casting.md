---
id: 249
title: Conversion operator behavior and casting
date: 2008-11-08T02:55:39+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/11/07/conversion-operator-behavior-and-casting.aspx
dsq_thread_id:
  - "264715978"
categories:
  - 'C#'
---
Today I hit something that I just assumed would work, but absolutely did not.&#160; The issue was around the explicit conversion operators, which I use from time to time when I create [Value Objects](http://www.lostechies.com/blogs/jimmy_bogard/archive/2007/06/25/generic-value-object-equality.aspx) that wrap a specific primitive with extra behavior.&#160; Concepts like Email, Phone Number, Money and others tend to wrap a single primitive, but with some extra behavior.&#160; Now, in C# 3.0, extension methods can be used to add this extra behavior.&#160; But I tend to think [extension methods can be a form of primitive obsession](http://www.lostechies.com/blogs/jimmy_bogard/archive/2007/12/18/extension-methods-and-primitive-obsession.aspx).&#160; So instead, I’ll create Value Object classes, but with some conversion operators to help go back and forth from primitive types to the Value Object.

However, the behavior of conversion operators isn’t exactly what I imagined.&#160; For example, I have the fun Foo and Bar types:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Foo
</span>{
    <span style="color: blue">public </span>Foo(<span style="color: blue">int </span>value)
    {
        Value = value;
    }

    <span style="color: blue">public int </span>Value { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

    <span style="color: blue">public static explicit operator </span><span style="color: #2b91af">Bar</span>(<span style="color: #2b91af">Foo </span>foo)
    {
        <span style="color: blue">return new </span><span style="color: #2b91af">Bar</span>(foo.Value + 10);
    }
}

<span style="color: blue">public class </span><span style="color: #2b91af">Bar
</span>{
    <span style="color: blue">public </span>Bar(<span style="color: blue">int </span>otherValue)
    {
        OtherValue = otherValue;
    }

    <span style="color: blue">public int </span>OtherValue { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

    <span style="color: blue">public static implicit operator </span><span style="color: #2b91af">Foo</span>(<span style="color: #2b91af">Bar </span>bar)
    {
        <span style="color: blue">return new </span><span style="color: #2b91af">Foo</span>(bar.OtherValue + 5);
    }
}</pre>

[](http://11011.net/software/vspaste)

One defines an implicit operator, and the other an explicit conversion operator.&#160; Here’s an example of the implicit and explicit operators in action:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>This_will_work()
{
    <span style="color: #2b91af">Bar </span>bar = <span style="color: blue">new </span><span style="color: #2b91af">Bar</span>(10);

    <span style="color: #2b91af">Foo </span>foo = bar; <span style="color: green">// Implicit conversion operator

    </span>foo.Value.ShouldEqual(15);

    <span style="color: #2b91af">Bar </span>bar2 = (<span style="color: #2b91af">Bar</span>) foo; <span style="color: green">// Explicit conversion operator

    </span>bar2.OtherValue.ShouldEqual(25);
}</pre>

[](http://11011.net/software/vspaste)

In the implicit operator, the Bar instance is implicitly converted to the Foo instance.&#160; For the other way around, I need to explicitly cast to Bar for the explicit conversion operator to kick in from Foo to Bar.

Still making sense, right?&#160; Here’s where things get a bit&#8230;wonky:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Does_not_work()
{
    <span style="color: blue">object </span>bar = <span style="color: blue">new </span><span style="color: #2b91af">Bar</span>(7);
    
    <span style="color: green">// does not compile
    // Foo foo = bar; 

    </span><span style="color: blue">object </span>foo = <span style="color: blue">new </span><span style="color: #2b91af">Foo</span>(14);
    
    <span style="color: #2b91af">Bar </span>bar2 = (<span style="color: #2b91af">Bar</span>) foo;

    bar2.OtherValue.ShouldEqual(24);
}</pre>

[](http://11011.net/software/vspaste)

Now, the first conversion won’t work because the compiler only sees the object type, but at runtime it’s of type Bar.&#160; However, the interesting thing is that the explicit conversion operator fails!&#160; Not only that, it’s a completely bizarre and ridiculous exception:

<pre>System.InvalidCastException : Unable to cast object of type 'CastingBehavior.Foo' to type 'CastingBehavior.Bar'.</pre>

[](http://11011.net/software/vspaste)

No, there is a cast available.&#160; We created the explicit conversion operator for just that purpose.&#160; Popping open Reflector reveals the true culprit.&#160; Here’s the IL for the implicit operator conversion that worked:

<pre>L_000a: call class CastingBehavior.Foo CastingBehavior.Bar::op_Implicit(class CastingBehavior.Bar)</pre>

[](http://11011.net/software/vspaste)

Huh.&#160; Okay, here’s the explicit conversion that worked in the first test:

<pre>L_001f: call class CastingBehavior.Bar CastingBehavior.Foo::op_Explicit(class CastingBehavior.Foo)</pre>

[](http://11011.net/software/vspaste)

Hmmm.&#160; Not looking too promising.&#160; Finally, here’s the IL from the cast that threw the exception:

<pre>L_0011: castclass CastingBehavior.Bar</pre>

[](http://11011.net/software/vspaste)

And there’s the culprit!&#160; Now, I’m no IL expert, but it’s easy to see that the two cast operations are doing two completely different things.&#160; One is calling the explicit cast operator (which is a cleverly disguised method on the Foo type), and the other is calling “castclass”, whatever that is.

This means that **conversion operators are evaluated at compile time, not run-time**.&#160; Which is rather unfortunate, the conversion operators are nothing more than a cheap C# compiler trick, and don’t do anything interesting in the CLR.&#160; The same applies for all of the operator overloads, they are fancy compiler tricks to call specifically named methods.&#160; But conversion operators aren’t embedded into the CLR, nor is the CLR aware of them.&#160; It’s just another method call at that point.

Which is tricky, as it doesn’t look any different.&#160; You get an InvalidCastException, even though you’ve defined an explicit conversion operator.&#160; But this is not a “cast substitute” – it’s merely an operator.&#160; A cast is a cast, [except when it isn’t](http://www.interact-sw.co.uk/iangblog/2004/01/20/casting), and when it isn’t, it can trip you up with runtime exceptions as we saw here.