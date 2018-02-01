---
id: 296
title: Unicode in regular expressions
date: 2009-03-17T01:03:23+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/03/16/unicode-in-regular-expressions.aspx
dsq_thread_id:
  - "268027361"
categories:
  - 'C#'
---
Wow, what an interesting blog post title!&#160; Two technologies, each scintillating by itself, when brought together have more energy than a 1988 GnR concert.

A feature request came up in AutoMapper to support international characters.&#160; On the surface, that might seem simple, were it not for AutoMapper’s flattening feature.&#160; AutoMapper requires zero configuration for flattened mappings, as long as the names all match up (minus all those dots).&#160; The trick came into figuring out how to take a destination member and search the source type members, taking into account that .NET PrefersPascalCasingForPublicMembers.

So what could this match to?&#160; Any permutation of putting that dot anywhere in the chain.&#160; And if it goes down the chain in one spot (PrefersPascal.Casing.ForPublic.Memberz) and misses, it needs to go back and search another vector.

Long story short, I’m no algorithms expert, so the best option I could come up with is one where I just split a string based on uppercase characters, instead of one. character. at. a. time.&#160; Yes, I’d love to hear a better way.

In any case, my regular expression was a little too assuming:

<pre><span style="color: blue">string</span>[] matches = <span style="color: #2b91af">Regex</span>.Matches(nameToSearch, <span style="color: #a31515">"[A-Z][a-z0-9]*"</span>)</pre>

[](http://11011.net/software/vspaste)

That’s all fine and dandy in the States, but not in other countries, as the list of valid characters for members is much larger than this.&#160; Suppose I’m trying to map this flattened DTO:

<pre><span style="color: blue">private class </span><span style="color: #2b91af">Order
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">Customer </span>Customer { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}

<span style="color: blue">private class </span><span style="color: #2b91af">Customer
</span>{
    <span style="color: blue">public string </span>Æøå { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}

<span style="color: blue">private class </span><span style="color: #2b91af">OrderDto
</span>{
    <span style="color: blue">public string </span>CustomerÆøå { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

It _should_ match the Customer property, then the…other…property.&#160; I can’t just use the normal “A-Z” assumption.&#160; Instead, I can use the [Unicode](http://www.unicode.org/Public/UNIDATA/UCD.html) general categories substitutions.&#160; Unicode defines general categories for characters, such as uppercase, lowercase, titlecase (Turkey), numbers and so on.&#160; To match these as a group in regular expressions, I can use a substitution, which in .NET is “p{_name_}”, where _name_ is the name of the substitution.&#160; For more character classes and substitutions, check out [the MSDN documentation](http://msdn.microsoft.com/en-us/library/20bw873z.aspx).

With that in hand, I can use the substitutions for uppercase and lowercase:

<pre><span style="color: blue">string</span>[] matches = <span style="color: #2b91af">Regex</span>.Matches(nameToSearch, <span style="color: #a31515">@"p{Lu}[p{Ll}0-9]*"</span>)</pre>

[](http://11011.net/software/vspaste)

Now if I was being thorough, I might look up the rest of the valid Unicode characters in members.&#160; But no, enough double-insanity for one day.