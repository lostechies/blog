---
wordpress_id: 162
title: Variations on a Func-y theme
date: 2008-03-22T17:15:47+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/03/22/variations-on-a-func-y-theme.aspx
dsq_thread_id:
  - "264715619"
categories:
  - 'C#'
---
Delegates have come a long way since C# 1.0 debuted back in early 2002.&nbsp; The progression from using delegate parameters (outside of events) grew from quite cumbersome to fairly expressive with Lambda expressions with C# 3.0.&nbsp; Functional style programming has become easier (some say feasible) with generics, lambdas and expression trees.

But it wasn&#8217;t always quite so easy.&nbsp; To fully appreciate the possibilities a functional-style API gives us, I like to crack open the history books and examine how delegates have changed in C# throughout the years.

### Manual class creation: C# 1.0

Suppose I want to search a list of books by author and return the first matching book.&nbsp; For these examples, I&#8217;ll assume I have the full Enumerable extensions, but search methods could be created manually by declaring special delegates.&nbsp; But for simplicity&#8217;s sake, I&#8217;ll just use the [FirstOrDefault(TSource)](http://msdn2.microsoft.com/en-us/library/bb549039.aspx) extension method.

In C# 1.0, I had to create a special class to perform the matching:

<pre><span style="color: blue">public </span><span style="color: #2b91af">Book </span>FindByAuthor(<span style="color: blue">string </span>author)
{
    <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Book</span>&gt; books = GetBooks();

    <span style="color: #2b91af">MatchesAuthorSpecification </span>spec = <span style="color: blue">new </span><span style="color: #2b91af">MatchesAuthorSpecification</span>(author);

    <span style="color: blue">return </span>books.FirstOrDefault(spec.IsSatisfiedBy);
}
</pre>

[](http://11011.net/software/vspaste)

After getting the list of books, I create a MatchesAuthorSpecification, initializing the spec object with the author I&#8217;m trying to find.&nbsp; Here&#8217;s the specification class:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">MatchesAuthorSpecification
</span>{
    <span style="color: blue">private readonly string </span>_author;

    <span style="color: blue">public </span>MatchesAuthorSpecification(<span style="color: blue">string </span>author)
    {
        _author = author;
    }

    <span style="color: blue">public bool </span>IsSatisfiedBy(<span style="color: #2b91af">Book </span>book)
    {
        <span style="color: blue">return </span>book.Author == _author;
    }
}
</pre>

[](http://11011.net/software/vspaste)

The FirstOrDefault method expects a delegate to perform the matching, specifically a Func<TSource, bool> predicate.&nbsp; All this means is that it needs a method that takes a Book and returns a bool.&nbsp; The &#8220;IsSatisfiedBy&#8221; method matches that signature, so my little Specification class works to perform the author matching.

The Specification pattern is great, but if I don&#8217;t need that class outside of this FindByAuthor method, it&#8217;s not doing much for me.&nbsp; With C# 1.0, I didn&#8217;t have a choice in the matter, I have to pass in a concrete method name to the FirstOrDefault method.

### Anonymous methods on the move: C# 2.0

With C# 2.0 came anonymous methods.&nbsp; I could now create little method snippets inside other methods, without needing to create special classes or other methods to hold the logic.

Additionally, these anonymous methods supported closures, which allow anonymous methods to reference the scope they were created in.&nbsp; This allows me to reference local variables inside the method block, with a bunch of compiler magic taking care of the rest.

Using anonymous methods, my FindByAuthor method now looks like:

<pre><span style="color: blue">public </span><span style="color: #2b91af">Book </span>FindByAuthor(<span style="color: blue">string </span>author)
{
    <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Book</span>&gt; books = GetBooks();

    <span style="color: blue">return </span>books.FirstOrDefault(<span style="color: blue">delegate</span>(<span style="color: #2b91af">Book </span>book) { <span style="color: blue">return </span>book.Author == author; });
}
</pre>

[](http://11011.net/software/vspaste)

[](http://11011.net/software/vspaste)The body of the anonymous method looks exactly like the C# 1.0 version, without the need to create a class around it.&nbsp; Note that the anonymous method refers to the &#8220;author&#8221; variable passed in to the method.&nbsp; The anonymous method &#8220;remembers&#8221; what the local author variable is when the anonymous method is declared.&nbsp; This allows the Find method to work properly.

Anonymous delegates were a nice addition, but they could get ugly fairly quickly.&nbsp; You never wanted more than two or three lines in these anonymous methods, but even one line didn&#8217;t look great.&nbsp; It&#8217;s hard to discern exactly what&#8217;s going on with all of the braces, keywords and statements around.

### Lambda expressions: C# 3.0

Lambda expressions are finally available with C# 3.0.&nbsp; Lambda expressions offer a much terser syntax for creating anonymous methods.&nbsp; But it turns out there are two types of lambdas:

  * Statement lambdas
  * Expression lambdas

Statement lambdas look almost exactly like anonymous methods, with the &#8220;delegate&#8221; keyword removed:

<pre><span style="color: blue">public </span><span style="color: #2b91af">Book </span>FindByAuthor(<span style="color: blue">string </span>author)
{
    <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Book</span>&gt; books = GetBooks();

    <span style="color: blue">return </span>books.FirstOrDefault(book =&gt; { <span style="color: blue">return </span>book.Author == author; });
}
</pre>

[](http://11011.net/software/vspaste)

[](http://11011.net/software/vspaste)Lambda expressions also include the lambda operator &#8220;=>&#8221; to associate the statement or expression block with the input parameters.&nbsp; In the above example, the type of &#8220;book&#8221; is inferred from the underlying delegate type (Func<Book, bool>).&nbsp; This format is an improvement on anonymous methods, but the statement block still looks strange inside another method call.

With expression lambdas, I can make the syntax about as terse as it gets:

<pre><span style="color: blue">public </span><span style="color: #2b91af">Book </span>FindByAuthor(<span style="color: blue">string </span>author)
{
    <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Book</span>&gt; books = GetBooks();

    <span style="color: blue">return </span>books.FirstOrDefault(book =&gt; book.Author == author);
}
</pre>

[](http://11011.net/software/vspaste)

Now that&#8217;s readable!&nbsp; No extra class to define, just a short lambda expression describing the matching function.&nbsp; The compiler can look at the expression lambda and infer the operation based on its result.&nbsp; Since the expression shown returns a boolean, the C# compiler infers that this is what the method should return.

Looking at each implementation in .NET Reflector, each implementation from the manual class creation to lambda expression is almost exactly the same.

### 

### Lambdas are your friend

Delegates have come a long way since C# 1.0, with C# 3.0 allowing powerful functional programming concepts like closures, currying, folding and others.

Entire algorithms can be abstracted and the varying parts passed in as delegates.&nbsp; The entire System.Linq.Enumerable set of extension methods is based on this concept of extracting algorithms.&nbsp; With the simplicity of lambda expressions, new avenues of removing duplication are opened up.