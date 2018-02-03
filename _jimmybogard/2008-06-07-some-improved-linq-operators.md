---
wordpress_id: 194
title: Some improved LINQ operators
date: 2008-06-07T23:39:59+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/06/07/some-improved-linq-operators.aspx
dsq_thread_id:
  - "264715787"
categories:
  - 'C#'
  - LINQ
---
I ran across a couple of scenarios the other day that were made pretty difficult given the current LINQ query operators.&nbsp; First, I needed to see if an item existed in a collection.&nbsp; That&#8217;s easy with the Contains method, when you want to find item that matches all the attributes you&#8217;re looking for.

Suppose I want only one attribute to match?&nbsp; For example, I have a Person class:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Person
</span>{
    <span style="color: blue">public string </span>FirstName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>LastName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

What if I want to see if a collection of Persons contains someone with the last name &#8220;Smith&#8221;?&nbsp; Contains only gives me two options:

<pre><span style="color: blue">public static bool </span>Contains&lt;TSource&gt;(<span style="color: blue">this </span><span style="color: #2b91af">IEnumerable</span>&lt;TSource&gt; source, TSource value);
<span style="color: blue">public static bool </span>Contains&lt;TSource&gt;(<span style="color: blue">this </span><span style="color: #2b91af">IEnumerable</span>&lt;TSource&gt; source, TSource value, <span style="color: #2b91af">IEqualityComparer</span>&lt;TSource&gt; comparer);
</pre>

[](http://11011.net/software/vspaste)

That doesn&#8217;t help, I have to implement some interface just to match against the LastName.&nbsp; Typically, this is solved with one of two options:

<pre><span style="color: green">// Inefficient Contains replacement
</span>values
    .Where(person =&gt; person.LastName == <span style="color: #a31515">"Smith"</span>)
    .Count()
    .ShouldBeGreaterThan(0);

<span style="color: green">// Efficient, but ugly and hard to use
</span>values
    .Where(person =&gt; person.LastName == <span style="color: #a31515">"Smith"</span>)
    .FirstOrDefault()
    .ShouldNotBeNull();
</pre>

[](http://11011.net/software/vspaste)

The first example is inefficient because Count() iterates through all of the values found, where I only really care if one is found.&nbsp; The second example works, but loses the intent of what I&#8217;m trying to find out.

I also had the same types of problems with Distinct, where I&#8217;d like to find distinct elements, but only looking at a certain value.&nbsp; I had to implement the same IEqualityComparer (very annoying).

### Better LINQ extensions

Instead of implementing some crazy interface, I&#8217;d like to just give the Contains and Distinct query operators an expression of what to look for.&nbsp; I&#8217;d like this test to pass:

<pre>[<span style="color: #2b91af">Test</span>]
 <span style="color: blue">public void </span>Better_enumerable_extensions()
 {
     <span style="color: blue">var </span>values = <span style="color: blue">new</span>[]
                      {
                          <span style="color: blue">new </span><span style="color: #2b91af">Person </span>{FirstName = <span style="color: #a31515">"Bob"</span>, LastName = <span style="color: #a31515">"Smith"</span>},
                          <span style="color: blue">new </span><span style="color: #2b91af">Person </span>{FirstName = <span style="color: #a31515">"Don"</span>, LastName = <span style="color: #a31515">"Allen"</span>},
                          <span style="color: blue">new </span><span style="color: #2b91af">Person </span>{FirstName = <span style="color: #a31515">"Bob"</span>, LastName = <span style="color: #a31515">"Sacamano"</span>},
                          <span style="color: blue">new </span><span style="color: #2b91af">Person </span>{FirstName = <span style="color: #a31515">"Chris"</span>, LastName = <span style="color: #a31515">"Smith"</span>},
                          <span style="color: blue">new </span><span style="color: #2b91af">Person </span>{FirstName = <span style="color: #a31515">"George"</span>, LastName = <span style="color: #a31515">"Allen"</span>}
                      };

     values
         .Distinct(person =&gt; person.LastName)
         .Count()
         .ShouldEqual(3);

     values
         .Distinct(person =&gt; person.FirstName)
         .Count()
         .ShouldEqual(4);

     values
         .Contains(<span style="color: #a31515">"Smith"</span>, person =&gt; person.LastName)
         .ShouldBeTrue();

     values
         .Contains(<span style="color: #a31515">"Nixon"</span>, person =&gt; person.LastName)
         .ShouldBeFalse();
}
</pre>

[](http://11011.net/software/vspaste)

In the Distinct example, I pass in a lambda expression of the distinct attribute I&#8217;m looking for.&nbsp; In the Contains example, I pass in the lambda expression, as well as the value I&#8217;m looking for.

To do this, I&#8217;ll need to create my extensions class with the new extension methods:

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">BetterEnumerableExtensions
</span>{
    <span style="color: blue">public static </span><span style="color: #2b91af">IEnumerable</span>&lt;TSource&gt; Distinct&lt;TSource, TResult&gt;(
        <span style="color: blue">this </span><span style="color: #2b91af">IEnumerable</span>&lt;TSource&gt; source, <span style="color: #2b91af">Func</span>&lt;TSource, TResult&gt; comparer)
    {
        <span style="color: blue">return </span>source.Distinct(<span style="color: blue">new </span><span style="color: #2b91af">DynamicComparer</span>&lt;TSource, TResult&gt;(comparer));
    }

    <span style="color: blue">public static bool </span>Contains&lt;TSource, TResult&gt;(
        <span style="color: blue">this </span><span style="color: #2b91af">IEnumerable</span>&lt;TSource&gt; source, TResult value, <span style="color: #2b91af">Func</span>&lt;TSource, TResult&gt; selector)
    {
        <span style="color: blue">foreach </span>(TSource sourceItem <span style="color: blue">in </span>source)
        {
            TResult sourceValue = selector(sourceItem);
            <span style="color: blue">if </span>(sourceValue.Equals(value))
                <span style="color: blue">return true</span>;
        }
        <span style="color: blue">return false</span>;
    }
}</pre>

[](http://11011.net/software/vspaste)

Yeah yeah, all those angle-brackets really start to get ugly.&nbsp; The new Contains method takes in the selector method now, in the form of a Func delegate.&nbsp; In the body, I just loop through the source items, evaluating the selector for each item.&nbsp; If the source value matches the value I&#8217;m searching for, I return &#8220;true&#8221; immediately and stop looping.&nbsp; Otherwise, I return false.

The new Distinct method uses the existing Distinct, but now it&#8217;s using a new DynamicComparer class:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DynamicComparer</span>&lt;T, TResult&gt; : <span style="color: #2b91af">IEqualityComparer</span>&lt;T&gt;
{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">Func</span>&lt;T, TResult&gt; _selector;

    <span style="color: blue">public </span>DynamicComparer(<span style="color: #2b91af">Func</span>&lt;T, TResult&gt; selector)
    {
        _selector = selector;
    }

    <span style="color: blue">public bool </span>Equals(T x, T y)
    {
        TResult result1 = _selector(x);
        TResult result2 = _selector(y);
        <span style="color: blue">return </span>result1.Equals(result2);
    }

    <span style="color: blue">public int </span>GetHashCode(T obj)
    {
        TResult result = _selector(obj);
        <span style="color: blue">return </span>result.GetHashCode();
    }
}
</pre>

[](http://11011.net/software/vspaste)

It has to do similar things as the Contains method, where I evaluate the items passed in against the selector method delegate passed in earlier.&nbsp; In any case, the existing Distinct method works the way I want to, without me needing to re-implement its internal logic as I did with the Contains.

I tried using the DynamicComparer with the Contains method, but it just worked out better re-implementing the logic.

### Intention-revealing interfaces == good

The Where/Count or even the Where/FirstOrDefault ways of getting the Contains is just plain ugly.&nbsp; By passing in a selector method, I can describe exactly what I&#8217;m looking for.&nbsp; In the case of Distinct, having to create a custom IEqualityComparer just for that is unnecessary most of the time.&nbsp; When I saw that initially, it just looked like more trouble than it was worth.&nbsp; But with the new and improved extensions, I get a much cleaner implementation.