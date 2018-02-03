---
wordpress_id: 338
title: 'Refactoring challenge #2 – functionally illiterate'
date: 2009-07-27T01:37:25+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/07/26/refactoring-challenge-2-functionally-illiterate.aspx
dsq_thread_id:
  - "270056105"
categories:
  - Refactoring
---
In the [last refactoring challenge](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/07/06/refactoring-challenge.aspx), I had a problem with some nasty conditional complexity.&#160; To be honest, the challenge was a subtle way to crowdsource new features in AutoMapper, but hey, it worked.&#160; One of the hard parts of being a sole contributor to an OSS project is that I lose the benefits of teammates and pair programming, to be able to bounce design ideas around and brainstorm solutions.&#160; So instead, I’ll just post my problems here.

The next issue I’m trying to address is the ability to configure the matching algorithm AutoMapper uses to determine that member Foo matches up to another member Foo on two separate types.&#160; Right off the bat, we could simply match by name.&#160; But, AutoMapper has one killer piece of functionality, the ability to flatten source member names to destination member names, so that “src.Foo.Bar.Bazz.Bam” can map to “dest.FooBarBazzBam”, or “dest.FooBarBazz.Bam”, or “dest.FooBar.BazzBam”, or “dest.Foo.Bar.Bazz.Bam”.&#160; But in taking Ayende’s advice to [JFHCI](http://ayende.com/Blog/archive/2008/08/21/Enabling-change-by-hard-coding-everything-the-smart-way.aspx), I wound up hardcoding a lot of the algorithm to match as well.&#160; It’s all encapsulated in one class, but it’s not easy to change.

To get to where I want to go, such as being able to supply postfixes to accept (src.CustomerId matching to dest.Customer), I need to shore up the searching algorithm to make it more understandable.&#160; All mapping configuration is contained in a TypeMap class, created by this method:

<pre><span style="color: blue">public </span><span style="color: #2b91af">TypeMap </span>CreateTypeMap(<span style="color: #2b91af">Type </span>sourceType, <span style="color: #2b91af">Type </span>destinationType)
{
    <span style="color: blue">var </span>sourceTypeInfo = GetTypeInfo(sourceType);
    <span style="color: blue">var </span>destTypeInfo = GetTypeInfo(destinationType);

    <span style="color: blue">var </span>typeMap = <span style="color: blue">new </span><span style="color: #2b91af">TypeMap</span>(sourceTypeInfo, destTypeInfo);

    <span style="color: blue">foreach </span>(<span style="color: #2b91af">IMemberAccessor </span>destProperty <span style="color: blue">in </span>destTypeInfo.GetPublicReadAccessors())
    {
        <span style="color: blue">var </span>resolvers = <span style="color: blue">new </span><span style="color: #2b91af">LinkedList</span>&lt;<span style="color: #2b91af">IValueResolver</span>&gt;();

        <span style="color: blue">if </span>(MapDestinationPropertyToSource(resolvers, sourceTypeInfo, destProperty.Name))
        {
            typeMap.AddPropertyMap(destProperty, resolvers);
        }
    }
    <span style="color: blue">return </span>typeMap;
}</pre>

[](http://11011.net/software/vspaste)

This isn’t the ugly part, it’s the MapDestinationPropertyToSource that’s the beast.&#160; But as you can see above, all I really do is loop through the destination properties, trying to find a match on the source type.&#160; But again like I had with the mapping execution, I have a bit of nastiness in the matching:

<pre><span style="color: blue">private bool </span>MapDestinationPropertyToSource(<span style="color: #2b91af">LinkedList</span>&lt;<span style="color: #2b91af">IValueResolver</span>&gt; resolvers, <span style="color: #2b91af">TypeInfo </span>sourceType, <span style="color: blue">string </span>nameToSearch)
{
    <span style="color: blue">var </span>sourceProperties = sourceType.GetPublicReadAccessors();
    <span style="color: blue">var </span>sourceNoArgMethods = sourceType.GetPublicNoArgMethods();

    <span style="color: #2b91af">IValueResolver </span>resolver = FindTypeMember(sourceProperties, sourceNoArgMethods, nameToSearch);

    <span style="color: blue">bool </span>foundMatch = resolver != <span style="color: blue">null</span>;

    <span style="color: blue">if </span>(!foundMatch)
    {
        <span style="color: blue">string</span>[] matches = <span style="color: #2b91af">Regex</span>.Matches(nameToSearch, <span style="color: #a31515">@"p{Lu}[p{Ll}0-9]*"</span>)
            .Cast&lt;<span style="color: #2b91af">Match</span>&gt;()
            .Select(m =&gt; m.Value)
            .ToArray();

        <span style="color: blue">for </span>(<span style="color: blue">int </span>i = 0; i &lt; matches.Length - 1; i++)
        {
            <span style="color: #2b91af">NameSnippet </span>snippet = CreateNameSnippet(matches, i);

            <span style="color: #2b91af">IMemberAccessor </span>valueResolver = FindTypeMember(sourceProperties, sourceNoArgMethods, snippet.First);

            <span style="color: blue">if </span>(valueResolver == <span style="color: blue">null</span>)
            {
                <span style="color: blue">continue</span>;
            }

            resolvers.AddLast(valueResolver);

            foundMatch = MapDestinationPropertyToSource(resolvers, GetTypeInfo(valueResolver.MemberType), snippet.Second);

            <span style="color: blue">if </span>(foundMatch)
            {
                <span style="color: blue">break</span>;
            }

            resolvers.RemoveLast();
        }
    }
    <span style="color: blue">else
    </span>{
        resolvers.AddLast(resolver);
    }

    <span style="color: blue">return </span>foundMatch;
}</pre>

[](http://11011.net/software/vspaste)

Again, problems with conditional complexity, and even more, cyclomatic complexity with the loop continuation/breaking.&#160; The actual matching is quite easy to do:

<pre><span style="color: blue">private static </span><span style="color: #2b91af">IMemberAccessor </span>FindTypeMember(<span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">IMemberAccessor</span>&gt; modelProperties, <span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">MethodInfo</span>&gt; getMethods, <span style="color: blue">string </span>nameToSearch)
{
    <span style="color: #2b91af">IMemberAccessor </span>pi = modelProperties.FirstOrDefault(prop =&gt; NameMatches(prop.Name, nameToSearch));
    <span style="color: blue">if </span>(pi != <span style="color: blue">null</span>)
        <span style="color: blue">return </span>pi;

    <span style="color: blue">string </span>getName = <span style="color: #a31515">"Get" </span>+ nameToSearch;
    <span style="color: #2b91af">MethodInfo </span>mi = getMethods.FirstOrDefault(m =&gt; (NameMatches(m.Name, getName)) || NameMatches(m.Name, nameToSearch));
    <span style="color: blue">if </span>(mi != <span style="color: blue">null</span>)
        <span style="color: blue">return new </span><span style="color: #2b91af">MethodAccessor</span>(mi);

    <span style="color: blue">return null</span>;
}

<span style="color: blue">private static bool </span>NameMatches(<span style="color: blue">string </span>memberName, <span style="color: blue">string </span>nameToMatch)
{
    <span style="color: blue">return </span><span style="color: #2b91af">String</span>.Compare(memberName, nameToMatch, <span style="color: #2b91af">StringComparison</span>.OrdinalIgnoreCase) == 0;
}

<span style="color: blue">private static </span><span style="color: #2b91af">NameSnippet </span>CreateNameSnippet(<span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: blue">string</span>&gt; matches, <span style="color: blue">int </span>i)
{
    <span style="color: blue">return new </span><span style="color: #2b91af">NameSnippet
               </span>{
                   First = <span style="color: #2b91af">String</span>.Concat(matches.Take(i + 1).ToArray()),
                   Second = <span style="color: #2b91af">String</span>.Concat(matches.Skip(i + 1).ToArray())
               };
}

<span style="color: blue">private class </span><span style="color: #2b91af">NameSnippet
</span>{
    <span style="color: blue">public string </span>First { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>Second { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

I’ve hardcoded the method prefix option (i.e., GetValue() maps to a property called Value), and that would be easy to switch out.&#160; But since I’m in the middle of needing to change all of the matching algorithm, I figured I’d go ahead and take care of the MapDestinationPropertyToSource.&#160; It’s quite complex, with the looping, linked list, and recursion.&#160; But algorithms are definitely not my strong suit, more modeling and patterns.

Given the recursive nature of the matching algorithm, I’m assuming that a better solution exists, but’s it’s probably functional in nature.&#160; Unfortunately, I’m functionally illiterate, but I’m sure some more enterprising folks have a better solution.&#160; So here’s the challenge – fix the “MapDestinationPropertyToSource” method, so it actually makes some sense when I come back to it later.