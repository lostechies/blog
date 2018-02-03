---
wordpress_id: 4204
title: 'Quick Tip: Parse String to Nullable Value'
date: 2010-01-23T16:39:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2010/01/23/quick-tip-parse-string-to-nullable-value.aspx
dsq_thread_id:
  - "263918333"
categories:
  - Uncategorized
---
When you&#8217;re dealing with a system like SharePoint that returns most
  
data as strings, it&#8217;s common to want to parse the data back into a
  
useful numeric format. The .NET framework offers several options to
  
achieve this, namely the static methods on `System.Convert` and the static `Parse()` methods on the various value types. However, these are limited in that they turn `null`
  
string values into the default for the given type (0, false, etc) and
  
they throw exceptions to indicate failure, which might be a performance
  
concern.

Often, a better option is to use the static `TryParse()`
  
method provided by most value types (with the notable exception of
  
enumerations). These follow the common pattern of returning a boolean
  
to indicate success and using an `out` parameter to return the value. While much better suited for what we&#8217;re trying to achieve, the `TryParse`
  
pattern requires more plumbing than I care to see most of the time&mdash;I
  
just want the value. To that end, I put together a simple extension
  
method to encapsulate the pattern:

<pre>public delegate bool TryParser&lt;T&gt;(string value, out T result) where T : struct;<br /><br />public static T? ParseWith&lt;T&gt;(this string value, TryParser&lt;T&gt; parser) where T : struct<br />{<br />    T result;<br />    if (parser(value, out result))<br />        return result;<br />    return null;<br />}</pre>

The `struct` constraint on `T` is required to align with the constraint on the `Nullable<T>` returned by the method.

We can now greatly simplify our efforts to parse nullable values:

<pre>var myIntPropStr = properties.BeforeProperties["MyIntProp"] as string;<br />var myIntProp = myPropStr.ParseWith&lt;int&gt;(int.TryParse);<br />if(myIntProp == null)<br />    throw new Exception("MyIntProp is empty!");</pre>

One quirk of this technique is that Visual Studio usually cannot infer `T` from just the `TryParse`
  
method because of its multiple overloads. One option would be to write
  
a dedicated method for each value type, but I would view this as
  
unnecessary cluttering of the `string` type. Your mileage may vary.