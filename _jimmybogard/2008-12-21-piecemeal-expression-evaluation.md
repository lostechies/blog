---
wordpress_id: 266
title: Piecemeal Expression evaluation
date: 2008-12-21T22:33:06+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/12/21/piecemeal-expression-evaluation.aspx
dsq_thread_id:
  - "272315840"
categories:
  - 'C#'
redirect_from: "/blogs/jimmy_bogard/archive/2008/12/21/piecemeal-expression-evaluation.aspx/"
---
One of the more interesting uses of Expressions is [strongly-typed reflection](http://www.clariusconsulting.net/blogs/kzu/archive/2006/07/06/TypedReflection.aspx).&#160; It seems that most of the time dealing with expressions, I never care about ever actually _evaluating_ the expression for any reason.&#160; When all I’m doing is parsing and examining the expression, I’ll never really need to evaluate the result.&#160; But any expression can be compiled to a delegate, so you’ll usually see code like this:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Expression_example()
{
    <span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">Customer</span>, <span style="color: blue">object</span>&gt;&gt; expr = c =&gt; c.Name;

    <span style="color: blue">var </span>bob = <span style="color: blue">new </span><span style="color: #2b91af">Customer </span>{Name = <span style="color: #a31515">"Bob"</span>};

    <span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">Customer</span>, <span style="color: blue">object</span>&gt; func = expr.Compile();

    <span style="color: blue">var </span>result = func(bob);

    result.ShouldEqual(<span style="color: #a31515">"Bob"</span>);
}</pre>

[](http://11011.net/software/vspaste)

To create an expression, we need a lambda.&#160; Unfortunately, the only way I’ve seen to create an Expression object is through the compiler.&#160; In the above example, we create an expression that represents a Func<Customer, object>.&#160; That is, the expression must be a lambda that expects a Customer and returns object.&#160; This is the basis of most strongly-typed reflection schemes.&#160; To actually execute the delegate behind the Expression, we call the Compile method, which returns a fully-functioning…function.

If you’re interested in Reflection.Emit, I’d highly suggest popping open the code for System.Linq.Expressions.ExpressionCompiler in Reflector.&#160; That’s the bad boy responsible for turning our Expression into executable code.&#160; 

In the above test, the Compile() call returns a strongly-typed delegate; namely, Func<Customer, object>.&#160; We get compile-time safety for calling the lambda, so we can’t call it with something besides a Customer, for example.

But what if we want to compile something else besides the expression as a whole?&#160; And why the heck would we want to in the first place?

Recently, I ran into a situation where I didn’t care about evaluating the entire expression, just one part of it.&#160; I wanted to have all of my HTML ID attributes in an ASP.NET MVC application generated from one place, so that both our front-end and our WatiN tests use the same mechanisms and EditModels to provide an iron-clad compile-safe manner of generating and using IDs (and NAMEs).&#160; The interesting part came when I ran into arrays, where I had an EditModel looking something like this:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Customer
</span>{
    <span style="color: blue">public string </span>Name { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">Address</span>[] Addresses { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}

<span style="color: blue">public class </span><span style="color: #2b91af">Address
</span>{
    <span style="color: blue">public string </span>Zip { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

In some form somewhere, a user could edit their list of addresses in one form.&#160; To have all of the form model binding magic work correctly, I needed to take the array index into account, so that this expression:

<pre><span style="color: #2b91af">HtmlIdGenerator</span>.Generate&lt;<span style="color: #2b91af">Customer</span>&gt;(c =&gt; c.Addresses[0].Zip);</pre>

[](http://11011.net/software/vspaste)

Would generate a correct HTML NAME attribute, that included the index.&#160; The end result looked something like “Addresses[0].Zip” for the NAME attribute value.

I was able to parse the Expression tree with no worries to get to the actual BinaryExpression that represented the ExpressionType.ArrayIndex expression type.&#160; The problem I ran into was that the array index, in actual use, could be absolutely and anything that resolved to an integer.&#160; This could be a constant value, like the above example, or a closure (where I pass in the array index in a loop), a method call, etc.&#160; A strongly-typed Expression was nowhere to be found, as I had only the Expression type work with.&#160; Its Compile method just returns Delegate, not a fancy Func<> or Action<>, or any other delegate type.

But it turned out not to matter, as Delegate has a DynamicInvoke, which allows me to pass in any parameters and returns any result as object.&#160; With this in mind, I had my piecemeal Expression evaluation:

<pre><span style="color: blue">case </span><span style="color: #2b91af">ExpressionType</span>.ArrayIndex:
    <span style="color: blue">var </span>binaryExpression = (<span style="color: #2b91af">BinaryExpression</span>) visited;

    <span style="color: #2b91af">Expression </span>indexExpression = binaryExpression.Right;
    <span style="color: #2b91af">Delegate </span>indexAction = <span style="color: #2b91af">Expression</span>.Lambda(indexExpression).Compile();
    <span style="color: blue">int </span>value = (<span style="color: blue">int</span>)indexAction.DynamicInvoke();</pre>

[](http://11011.net/software/vspaste)

With the index value, I could now use that value in my HTML NAME/ID attribute value generator.&#160; It didn’t matter how the array index value was generated, as the Compile() method took care of all the details.&#160; Closures, constants, methods, whatever.

No matter _where_ I am in the Expression tree, I can always Compile() each Expression piece and evaluate it individually.&#160; Any necessary parameters need to be passed in, but for cases like closures, it doesn’t matter.&#160; The closure already keeps track of any method parameters needed.&#160; Neato.