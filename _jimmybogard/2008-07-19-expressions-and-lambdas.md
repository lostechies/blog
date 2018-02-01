---
id: 208
title: Expressions and Lambdas
date: 2008-07-19T02:59:42+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/07/18/expressions-and-lambdas.aspx
dsq_thread_id:
  - "264715855"
categories:
  - LINQ
---
Some conversation on a [recent post on Chad&#8217;s blog](http://www.lostechies.com/blogs/chad_myers/archive/2008/07/06/exploring-shadetree-features-part-1-static-reflection-with-reflectionhelper.aspx) brought up the confusion between Lambdas and Expressions.&nbsp; A while back, I went into the [various ways to create delegates](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/03/22/variations-on-a-func-y-theme.aspx) throughout the different versions of C#.&nbsp; Although I touched on it briefly, the slight variations in the different lambda types can lead to some unexpected compilation errors.

C# 3.0 introduced two types of lambdas: Expression Lambdas and Statement Lambdas.&nbsp; The difference is easy to spot, here are two identically functioning lambdas:

<pre><span style="color: blue">public void </span>LambdaExpressionsAndStatements()
{
    <span style="color: blue">var </span>books = GetBooks();

    <span style="color: blue">var </span>exprBooks = books.Find(book =&gt; book.Author.Contains(<span style="color: #a31515">"Fowler"</span>));

    <span style="color: blue">var </span>stmtBooks = books.Find(book =&gt; { <span style="color: blue">return </span>book.Author.Contains(<span style="color: #a31515">"Fowler"</span>); });
}
</pre>

[](http://11011.net/software/vspaste)

See the difference?&nbsp; The second lambda has brackets.&nbsp; These brackets are a statement block, and can contain any old C# code.&nbsp; The statement lambda is really just a shorter version of a C# 2.0 anonymous method.

The first version is a different type of lambda: the expression lambda.&nbsp; So why do both compile?&nbsp; The Find method&#8217;s signature is:

<pre><span style="color: blue">public </span>T Find(<span style="color: #2b91af">Predicate</span>&lt;T&gt; match)</pre>

[](http://11011.net/software/vspaste)

Predicate<T> is a delegate type, so how does the &#8220;book.Author.Contains&#8221; part of the first lambda get converted to a delegate?

It turns out that the C# compiler is really smart.&nbsp; Smart enough to see an expression that returns a boolean, which matches the signature of the Predicate delegate.&nbsp; At compile time, it creates an anonymous delegate from the expression, as confirmed by Reflector.&nbsp; So we couldn&#8217;t do something like this:

<pre><span style="color: blue">var </span>exprBooks = books.Find(book =&gt; book.Author.Split(<span style="color: #a31515">' '</span>));</pre>

[](http://11011.net/software/vspaste)

We get the compiler error:

<pre>Cannot convert lambda expression to delegate type 'System.Predicate&lt;Samples.Book&gt;' because some of the return types in the block are not implicitly convertible to the delegate return type</pre>

[](http://11011.net/software/vspaste)

Basically, that the return type of the Split call (string[]) isn&#8217;t boolean, so it doesn&#8217;t compile.

### Expressions

Expressions are a fundamental addition to C# that allows LINQ to work its magic.&nbsp; Expressions at compile-time are converted to expression trees, which is really a large object made up of things like equals statements, variables, etc.&nbsp; It&#8217;s as if you decomposed C# statements into their fundamental building blocks, and represented these building blocks as classes and objects.

The interesting thing about expressions is that they can be converted to lambdas, and therefore executable code.&nbsp; Lambda statements however, don&#8217;t jive with expressions.&nbsp; Since lambda statements contain actual blocks of code, rather than an expression that represents a block of code, the compiler can&#8217;t convert all of those potential lines of code of a statement block into a real-deal expression.&nbsp; It&#8217;s why you can&#8217;t do this in a LINQ query expression:

<pre><span style="color: blue">var </span>linqBooks = <span style="color: blue">from </span>book <span style="color: blue">in </span>books
                <span style="color: blue">where </span>{ <span style="color: blue">return </span>books.Author.Contains(<span style="color: #a31515">"Fowler"</span>); }
                select book;
</pre>

[](http://11011.net/software/vspaste)

I get a nasty compile error:

<pre>Invalid expression term '{'</pre>

[](http://11011.net/software/vspaste)

I tried to use a lambda statement (the bracket business) where a lambda expression was required.&nbsp; A LINQ query expression is compiled into an expression tree, mixed in with the extension method calls to the LINQ query extensions (Where, Select, Union etc.)&nbsp; Here&#8217;s another way to write the above LINQ query expression, using LINQ query extensions instead:

<pre><span style="color: blue">var </span>linqStmtBooks = books.Where(book =&gt; { <span style="color: blue">return </span>book.Author.Contains(<span style="color: #a31515">"Fowler"</span>); });</pre>

[](http://11011.net/software/vspaste)

This looks exactly like our original Find example above, but this time I&#8217;m using the LINQ query extension method, instead of the List<T>.Find method.&nbsp; But LINQ query expressions (the SQL-like from..where..select) requires expressions, not statements.

### 

### Why do I care?

Well, 99.999% of the time, you won&#8217;t.&nbsp; Most folks won&#8217;t develop any APIs that use Expression<T> (the actual type behind the expression trees).&nbsp; Unless you&#8217;re someone like [Oren](http://ayende.com/) or [Jeremy](http://codebetter.com/blogs/jeremy.miller/) of course.

But if you happen to _use_ an API that works with Expression<T> instead of Func (delegates), you&#8217;ll need to care. For example, LINQ to SQL, LINQ to NHibernate and Entity Framework all deal with Expressions, not Funcs.&nbsp; So you&#8217;ll need to use the lambda expressions instead of the lambda statements.&nbsp; **No brackets allowed!**

So if you&#8217;re dealing with LINQ query expressions (the &#8220;from..where..select&#8221; business), you&#8217;ll have to go out of your way to do LINQ query statements with brackets.&nbsp; But using other APIs, you&#8217;ll get a strange compile error.&nbsp; If you see this compile error, just use an expression instead of a statement, and you&#8217;ll be set.