---
id: 245
title: Searching for a read-only list
date: 2008-10-30T00:09:19+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/10/29/searching-for-a-read-only-list.aspx
dsq_thread_id:
  - "421520601"
categories:
  - 'C#'
---
A while back, Eric Lippert talked about [arrays being somewhat harmful](http://blogs.msdn.com/ericlippert/archive/2008/09/22/arrays-considered-somewhat-harmful.aspx).&#160; The reason being, if you’re looking to create logical immutability, arrays aren’t it.&#160; Array length is immutable, but its contents aren’t.&#160; If you need to return an array, make sure you create a new instance every single time, or it might get modified underneath you.

Eric discusses in detail the issues with arrays, and all of his issues make sense.&#160; The only problem is, there aren’t any good alternatives in the BCL for a read-only collection.

You can use IEnumerable<T>, but all of its functionality comes from the LINQ query extensions.&#160; Count(), which was Length for arrays, is O(n) for most cases.&#160; It does exactly what you think it does, and loops through the entire list and increments a count.&#160; It does some intelligent checking, and returns the Count property for ICollection<T> implementations, but for all other cases, just loops through the list.

IEnumerable<T> also does not provide an indexer, so that really won’t work.

How about the next on the list, ICollection<T>?&#160; Here’s that interface:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">ICollection</span>&lt;T&gt; : <span style="color: #2b91af">IEnumerable</span>&lt;T&gt;, <span style="color: #2b91af">IEnumerable
</span>{
    <span style="color: green">// Methods
    </span><span style="color: blue">void </span>Add(T item);
    <span style="color: blue">void </span>Clear();
    <span style="color: blue">bool </span>Contains(T item);
    <span style="color: blue">void </span>CopyTo(T[] array, <span style="color: blue">int </span>arrayIndex);
    <span style="color: blue">bool </span>Remove(T item);

    <span style="color: green">// Properties
    </span><span style="color: blue">int </span>Count { <span style="color: blue">get</span>; }
    <span style="color: blue">bool </span>IsReadOnly { <span style="color: blue">get</span>; }
}</pre>

[](http://11011.net/software/vspaste)

Hmmm, not quite.&#160; There is an Add method, but no indexer.&#160; And a funny flag, “IsReadOnly”, that users of the collection are supposed to check?&#160; That’s not a very good user experience.&#160; Also not good, as implementers of ICollection<T> are expected to throw a NotSupportedException if IsReadOnly is false, for mutating operations like Add and Clear.

Blech, another violation of the Interface Segregation Principle.&#160; If I have a read-only list, why would I need to implement any read-only operations?

Looking further, we find a promising candidate: ReadOnlyCollection<T>.&#160; However, this class merely wraps another list, which can be modified underneath.&#160; Additionally, this class implements IList and IList<T>, which means you could potentially get runtime errors because Add and Clear look like available operations.

The final option is an IReadOnlyList<T>, of which there are a few options floating around the interwebs.&#160; It would look something like this:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IReadOnlyList</span>&lt;T&gt; : <span style="color: #2b91af">IEnumerable</span>&lt;T&gt;
{
    <span style="color: blue">int </span>IndexOf(T item);
    <span style="color: blue">bool </span>Contains(T item);
    <span style="color: blue">void </span>CopyTo(T[] array, <span style="color: blue">int </span>arrayIndex);

    <span style="color: blue">int </span>Count { <span style="color: blue">get</span>; }
    T <span style="color: blue">this</span>[<span style="color: blue">int </span>index] { <span style="color: blue">get</span>; }
} </pre>

[](http://11011.net/software/vspaste)

It’s not an ideal solution, but if you want immutable size _and_ immutable contents, this kind of direction will be the way to go.