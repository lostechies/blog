---
wordpress_id: 110
title: Dealing with primitive obsession
date: 2007-12-03T22:42:34+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/12/03/dealing-with-primitive-obsession.aspx
dsq_thread_id:
  - "264715458"
categories:
  - Refactoring
---
One code smell I tend to miss a lot is [primitive obsession](http://sis36.berkeley.edu/projects/streek/agile/bad-smells-in-code.html#Primitive+Obsession).&nbsp; Primitives are the building blocks of data in any programming language, such as strings, numbers, booleans, and so on.

Many times, primitives have special meaning, such as phone numbers, zip codes, money, etc.&nbsp; Nearly every time I encounter these values, they&#8217;re exposed as simple primitives:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Address
{
    <span class="kwrd">public</span> <span class="kwrd">string</span> ZipCode { get; set; }
}
</pre>
</div>

But there are special rules for zip codes, such as they can only be in a couple formats in the US: &#8220;12345&#8221; or &#8220;12345-3467&#8221;.&nbsp; This logic is typically captured somewhere away from the &#8220;ZipCode&#8221; value, and typically duplicated throughout the application.&nbsp; For some reason, I was averse to creating small objects to hold these values and their simple logic.&nbsp; I don&#8217;t really know why, as data objects&nbsp;tend to be highly cohesive and can cut down a lot of duplication.

Beyond what [Fowler](http://martinfowler.com/) [walks through](http://www.refactoring.com/catalog/replaceDataValueWithObject.html), I need to add a couple more features to my data object to make it really useful.

### Creating the data object

First I&#8217;ll need to create the data object by following the steps in [Fowler&#8217;s book](http://www.amazon.com/Refactoring-Improving-Existing-Addison-Wesley-Technology/dp/0201485672).&nbsp; I&#8217;ll make the ZipCode class a [DDD](http://domaindrivendesign.org/) [Value Object](http://www.lostechies.com/blogs/joe_ocampo/archive/2007/04/23/a-discussion-on-domain-driven-design-value-objects.aspx), and this is what I end up with:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Address
{
    <span class="kwrd">public</span> ZipCode ZipCode { get; set; }
}

<span class="kwrd">public</span> <span class="kwrd">class</span> ZipCode
{
    <span class="kwrd">private</span> <span class="kwrd">readonly</span> <span class="kwrd">string</span> _value;

    <span class="kwrd">public</span> ZipCode(<span class="kwrd">string</span> <span class="kwrd">value</span>)
    {
        <span class="rem">// perform regex matching to verify XXXXX or XXXXX-XXXX format</span>
        _value = <span class="kwrd">value</span>;
    }

    <span class="kwrd">public</span> <span class="kwrd">string</span> Value
    {
        get { <span class="kwrd">return</span> _value; }
    }
}
</pre>
</div>

This is pretty much where Fowler&#8217;s walkthrough stops.&nbsp; But there are some issues with this implementation:

  * Now more difficult to deal with Zip in its native format, strings
  * Zip codes used to be easier to display

Both of these issues can be easy to fix with the .NET Framework&#8217;s casting operators and available overrides.

### Cleaning it up

First, I&#8217;ll override the [ToString()](http://msdn2.microsoft.com/en-us/library/system.object.tostring.aspx) method and just output the internal value:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">string</span> ToString()
{
    <span class="kwrd">return</span> _value;
}
</pre>
</div>

Lots of classes, tools, and frameworks use the ToString method to display the value of an object, and now it will use the internal value of the zip code instead of just outputting the name of the type (which is the default).

Next, I can create some casting operators to go to and from System.String.&nbsp; Since zip codes are still dealt with mostly as strings in this system, I stuck with string instead of int or some other primitive.&nbsp; Also, many other countries have different zip code formats, so I stayed with strings.&nbsp; Here are the cast operators, both [implicit](http://msdn2.microsoft.com/en-us/library/z5z9kes2(VS.80).aspx) and [explicit](http://msdn2.microsoft.com/en-us/library/xhbhezf4(VS.80).aspx):

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">implicit</span> <span class="kwrd">operator</span> <span class="kwrd">string</span>(ZipCode zipCode)
{
    <span class="kwrd">return</span> zipCode.Value;
}

<span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">explicit</span> <span class="kwrd">operator</span> ZipCode(<span class="kwrd">string</span> <span class="kwrd">value</span>)
{
    <span class="kwrd">return</span> <span class="kwrd">new</span> ZipCode(<span class="kwrd">value</span>);
}
</pre>
</div>

I prefer **explicit** operators when converting **from** primitives, and **implicit** operators when converting **to** primitives.&nbsp; [FDG](http://www.amazon.com/Framework-Design-Guidelines-Conventions-Development/dp/0321246756) guidelines for conversion operators are:

> **DO NOT** provide a conversion operator if such conversion is not clearly expected by the end users.
> 
> **DO NOT** define conversion operators outside of a type&#8217;s domain.
> 
> **DO NOT** provide an implicit conversion if the conversion is potentially lossy.
> 
> **DO NOT** throw exceptions from implicit casts.
> 
> **DO** throw System.InvalidCastException if a call to a cast operator results in lossy conversion and the contract of the operator does not allow lossy conversions.

I meet all of these guidelines, so I think this implementation will work.

### End result

Usability with the changed ZipCode class is much improved now:

<div class="CodeFormatContainer">
  <pre>Address address = <span class="kwrd">new</span> Address();

address.ZipCode = <span class="kwrd">new</span> ZipCode(<span class="str">"12345"</span>); <span class="rem">// constructor</span>
address.ZipCode = (ZipCode) <span class="str">"12345"</span>; <span class="rem">// explicit operator</span>

<span class="kwrd">string</span> zip = address.ZipCode; <span class="rem">// implicit operator</span>

Console.WriteLine(<span class="str">"ZipCode: {0}"</span>, address.ZipCode); <span class="rem">// ToString method</span>
</pre>
</div>

Basically, my ZipCode class now&nbsp;&#8220;plays nice&#8221; with strings and code that expects strings.

With any hurdles out of the way for using simple data objects, I can eliminate a lot of duplication and scattered logic by creating small, specialized classes for all of the special primitives in my app.