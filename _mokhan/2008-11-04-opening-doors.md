---
id: 22
title: Opening Doors
date: 2008-11-04T19:27:33+00:00
author: Mo Khan
layout: post
guid: /blogs/mokhan/archive/2008/11/04/opening-doors.aspx
categories:
  - Design Patterns
---
</p> 

[joshka](http://bitfed.com/) left a comment on my [previous post](http://mokhan.ca/blog/2008/11/04/Intercepting+Business+Transactions.aspx) that reads&#8230;

_"&#8230; Can you talk about the Application Context and IKey stuff a little in a future post?"_

The IKey<T> interface defines a contract for different keys that are put into a dictionary. It depends on the implementation of the key to know how to parse its value out of the dictionary.

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IKey</span>&lt;T&gt;
{
    <span style="color: blue">bool </span>is_found_in(<span style="color: #2b91af">IDictionary </span>items);
    T parse_from(<span style="color: #2b91af">IDictionary </span>items);
    <span style="color: blue">void </span>remove_from(<span style="color: #2b91af">IDictionary </span>items);
    <span style="color: blue">void </span>add_value_to(<span style="color: #2b91af">IDictionary </span>items, T value);
}</pre>

[](http://11011.net/software/vspaste)An implementation of the key that we used for shoving an ISession into the HttpContext.Items collection is the TypedKey<T>. It creates a unique key based on type T.

<pre><span style="color: blue">internal class </span><span style="color: #2b91af">TypedKey</span>&lt;T&gt; : <span style="color: #2b91af">IKey</span>&lt;T&gt;
{
    <span style="color: blue">public bool </span>is_found_in(<span style="color: #2b91af">IDictionary </span>items)
    {
        <span style="color: blue">return </span>items.Contains(create_unique_key());
    }

    <span style="color: blue">public </span>T parse_from(<span style="color: #2b91af">IDictionary </span>items)
    {
        <span style="color: blue">return </span>(T) items[create_unique_key()];
    }

    <span style="color: blue">public void </span>remove_from(<span style="color: #2b91af">IDictionary </span>items)
    {
        <span style="color: blue">if </span>(is_found_in(items))
        {
            items.Remove(create_unique_key());
        }
    }

    <span style="color: blue">public void </span>add_value_to(<span style="color: #2b91af">IDictionary </span>items, T value)
    {
        items[create_unique_key()] = value;
    }

    <span style="color: blue">public bool </span>Equals(<span style="color: #2b91af">TypedKey</span>&lt;T&gt; obj)
    {
        <span style="color: blue">return </span>!ReferenceEquals(<span style="color: blue">null</span>, obj);
    }

    <span style="color: blue">public override bool </span>Equals(<span style="color: blue">object </span>obj)
    {
        <span style="color: blue">if </span>(ReferenceEquals(<span style="color: blue">null</span>, obj)) <span style="color: blue">return false</span>;
        <span style="color: blue">if </span>(ReferenceEquals(<span style="color: blue">this</span>, obj)) <span style="color: blue">return true</span>;
        <span style="color: blue">if </span>(obj.GetType() != <span style="color: blue">typeof </span>(<span style="color: #2b91af">TypedKey</span>&lt;T&gt;)) <span style="color: blue">return false</span>;
        <span style="color: blue">return </span>Equals((<span style="color: #2b91af">TypedKey</span>&lt;T&gt;) obj);
    }

    <span style="color: blue">public override int </span>GetHashCode()
    {
        <span style="color: blue">return </span>GetType().GetHashCode();
    }

    <span style="color: blue">private string </span>create_unique_key()
    {
        <span style="color: blue">return </span>GetType().FullName;
    }
}</pre>

[](http://11011.net/software/vspaste)It knows how to add a value in to the dictionary using it as the key, and how to parse values from the dictionary using it. The application context can be an adapter around the HttpContext, or a hand rolled context for win forms. An implementation on the web might look like&#8230;.

<pre><span style="color: blue">public class </span><span style="color: #2b91af">WebContext </span>: <span style="color: #2b91af">IApplicationContext
</span>{
    <span style="color: blue">public bool </span>contains&lt;T&gt;(<span style="color: #2b91af">IKey</span>&lt;T&gt; key)
    {
        <span style="color: blue">return </span>key.is_found_in(<span style="color: #2b91af">HttpContext</span>.Current.Items);
    }

    <span style="color: blue">public void </span>add&lt;T&gt;(<span style="color: #2b91af">IKey</span>&lt;T&gt; key, T value)
    {
        key.add_value_to(<span style="color: #2b91af">HttpContext</span>.Current.Items, value);
    }

    <span style="color: blue">public </span>T get_value_for&lt;T&gt;(<span style="color: #2b91af">IKey</span>&lt;T&gt; key)
    {
        <span style="color: blue">return </span>key.parse_from(<span style="color: #2b91af">HttpContext</span>.Current.Items);
    }

    <span style="color: blue">public void </span>remove(<span style="color: #2b91af">IKey</span>&lt;<span style="color: #2b91af">ISession</span>&gt; key)
    {
        key.remove_from(<span style="color: #2b91af">HttpContext</span>.Current.Items);
    }
}</pre>

[](http://11011.net/software/vspaste)

When running your integration tests, you can swap out the implementation with an implementation specific to running unit tests.