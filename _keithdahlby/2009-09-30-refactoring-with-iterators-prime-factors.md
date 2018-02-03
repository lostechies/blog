---
wordpress_id: 4198
title: 'Refactoring with Iterators: Prime Factors'
date: 2009-09-30T15:17:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2009/09/30/refactoring-with-iterators-prime-factors.aspx
dsq_thread_id:
  - "262493300"
categories:
  - Iterators
  - Refactoring
---
[Andrew Woodward](http://www.21apps.com/) recently posted a [comparison of his test-driven Prime Factors solution](http://www.21apps.com/development/comparing-myself-to-uncle-bob-martin/ "Comparing myself to Uncle Bob Martin") to [one written by](http://www.butunclebob.com/ArticleS.UncleBob.ThePrimeFactorsKata "Prime Factors Kata") [Uncle Bob](http://butunclebob.com/ "Robert C. Martin"). In the comments, someone suggested that Andrew use an iterator instead so I thought I&#8217;d give it a try.

First, let&#8217;s repost the original code:

<pre>private const int SMALLEST_PRIME = 2;<br /><br />public List&lt;int&gt; Generate(int i)<br />{<br />    List&lt;int&gt; primes = new List&lt;int&gt;();<br />    int divider = SMALLEST_PRIME;<br />    while (HasPrimes(i))<br />    {<br />        while (IsDivisable(i, divider))<br />        {<br />            i = AddPrimeToProductsAndReduce(i, primes, divider);<br />        }<br />        divider++;<br />    }<br />    return primes;<br />}<br /><br />private bool IsDivisable(int i, int divider)<br />{<br />    return i%divider == 0;<br />}<br /><br />private bool HasPrimes(int i)<br />{<br />    return i &gt;= SMALLEST_PRIME;<br />}<br /><br />private int AddPrimeToProductsAndReduce(int i, List&lt;int&gt; primes, int prime)<br />{<br />    primes.Add(prime);<br />    i /= prime;<br />    return i;<br />}<br /></pre>

By switching our method to return `IEnumerable<int>`, we can replace the `primes`
  
list with an iterator. We will also remove the AddPrimeToProducts
  
functionality from that helper method since we don&#8217;t have the list any
  
more:

<pre>public IEnumerable&lt;int&gt; Generate(int i)<br />{<br />    int divider = SMALLEST_PRIME;<br />    while (HasPrimes(i))<br />    {<br />        while (IsDivisable(i, divider))<br />        {<br />            yield return divider;<br />            i = Reduce(i, divider);<br />        }<br />        divider++;<br />    }<br />}<br /><br />private int Reduce(int i, int prime)<br />{<br />    return i / prime;<br />}<br /></pre>

I think this is a good change for three reasons:

  1. There&#8217;s nothing about the problem that requires a `List<int>` be returned, we just want a sequence of the factors.
  2. `AddPrimeToProductsAndReduce` suggested that it had a side effect, but exactly what wasn&#8217;t immediately obvious.
  3. It&#8217;s much easier to see what values are being included in the result.

That said, I think we can clean this up even more with a second
  
iterator. Specifically, I think we should break out the logic for our
  
candidate factors:

<pre>private IEnumerable&lt;int&gt; Divisors<br />{<br />    get<br />    {<br />        int x = SMALLEST_PRIME;<br />        while (true)<br />            yield return x++;<br />    }<br />}<br /></pre>

Which allows us to separate the logic for generating a divider from the code that consumes it:

<pre>public IEnumerable&lt;int&gt; Generate(int toFactor)<br />{<br />    foreach (var divider in Divisors)<br />    {<br />        if (!HasPrimes(toFactor))<br />            break;<br /><br />        while (IsDivisable(toFactor, divider))<br />        {<br />            yield return divider;<br />            toFactor = Reduce(toFactor, divider);<br />        }<br />    }<br />}</pre>

We should also eliminate the negation by flipping `HasPrimes` to become `IsFactored`:

<pre>public IEnumerable&lt;int&gt; Generate(int toFactor)<br />{<br />    foreach (var divider in Divisors)<br />    {<br />        if (IsFactored(toFactor))<br />            break;<br /><br />        while (IsDivisable(toFactor, divider))<br />        {<br />            yield return divider;<br />            toFactor = Reduce(toFactor, divider);<br />        }<br />    }<br />}<br /><br />private bool IsFactored(int i)<br />{<br />    return i &lt;= 1;<br />}</pre>

This does introduce a (very) minor inefficiency in that the `Divisors` enumerator will `MoveNext()` one extra time before breaking out of the loop, which could be mitigated by checking `IsFactored` both before the `foreach` and after the `while` loop. Less readable, insignificantly more efficient&#8230;take your pick.

The other advantage to breaking out the logic to generate `Divisors`
  
is that we can easily pick smarter candidates. One option is to skip
  
even numbers greater than 2. An even better optimization takes
  
advantage of the fact that all primes greater than 3 are of the form
  
x&plusmn;1 where x is a multiple of 6:

<pre>private IEnumerable&lt;int&gt; Divisors<br />{<br />    get<br />    {<br />        yield return 2;<br />        yield return 3;<br />        int i = 6;<br />        while (true)<br />        {<br />            yield return i - 1;<br />            yield return i + 1;<br />            i += 6;<br />        }<br />    }<br />}</pre>

Implementing this sort of logic in the original version would have
  
been much more difficult, both in terms of correctness and readability.