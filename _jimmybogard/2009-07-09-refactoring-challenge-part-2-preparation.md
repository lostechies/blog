---
id: 334
title: Refactoring challenge Part 2 – Preparation
date: 2009-07-09T02:22:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/07/08/refactoring-challenge-part-2-preparation.aspx
dsq_thread_id:
  - "264716232"
categories:
  - Refactoring
---
Other posts in this series:

  * [Refactoring challenge – cry for help](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/07/06/refactoring-challenge.aspx)
  * [Part 1 – Examination](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/07/07/refactoring-challenge-part-1-examination.aspx)

In the last part of this series, I took a closer look at the code smells found by commenters, which included:

  * No tests
  * Feature envy
  * Conditional complexity
  * Long method

All of these code smells can be found in the two main refactoring books out there, Fowler’s [Refactoring](http://www.amazon.com/exec/obidos/ASIN/0201485672) and Kerievsky’s [Refactoring to Patterns](http://www.informit.com/store/product.aspx?isbn=0321213351).&#160; A while back, I created a handy [smells-to-refactorings quick reference guide](http://s3.amazonaws.com/grabbagoftimg/Smells%20to%20Refactorings.pdf) for those sticky situations where I don’t have the books handy.&#160; But before I address any of the code smells, I need to prepare for the refactorings.&#160; The main refactorings I’m looking at are ones to move towards the Strategy and Chain of Responsibility patterns, but these only really become apparent when the code at hand is rather uniform.

To fix this problem, I first need to flatten out all of those if statements in the original code.&#160; The code after flattening all the if statements out now looks like this:

<pre><span style="color: blue">public object </span>Map(<span style="color: #2b91af">ResolutionContext </span>context, <span style="color: #2b91af">IMappingEngineRunner </span>mapper)
{
    <span style="color: blue">object </span>mappedObject = <span style="color: blue">null</span>;
    <span style="color: blue">var </span>profileConfiguration = mapper.ConfigurationProvider.GetProfileConfiguration(context.TypeMap.Profile);

    <span style="color: blue">if </span>(context.TypeMap.CustomMapper != <span style="color: blue">null</span>)
    {
        context.TypeMap.BeforeMap(context.SourceValue, mappedObject);
        mappedObject = context.TypeMap.CustomMapper(context);
    }
    <span style="color: blue">else if </span>((context.SourceValue == <span style="color: blue">null </span>&& profileConfiguration.MapNullSourceValuesAsNull))
    {
        mappedObject = <span style="color: blue">null</span>;
    }
    <span style="color: blue">else if </span>(context.DestinationValue == <span style="color: blue">null </span>&& context.InstanceCache.ContainsKey(context))
    {
        mappedObject = context.InstanceCache[context];
    }
    <span style="color: blue">else if </span>(context.DestinationValue == <span style="color: blue">null</span>)
    {
        mappedObject = mapper.CreateObject(context.DestinationType);
        <span style="color: blue">if </span>(context.SourceValue != <span style="color: blue">null</span>)
            context.InstanceCache.Add(context, mappedObject);

        context.TypeMap.BeforeMap(context.SourceValue, mappedObject);
        <span style="color: blue">foreach </span>(<span style="color: #2b91af">PropertyMap </span>propertyMap <span style="color: blue">in </span>context.TypeMap.GetPropertyMaps())
        {
            MapPropertyValue(context, mapper, mappedObject, propertyMap);
        }
    }
    <span style="color: blue">else
    </span>{
        mappedObject = context.DestinationValue;

        context.TypeMap.BeforeMap(context.SourceValue, mappedObject);
        <span style="color: blue">foreach </span>(<span style="color: #2b91af">PropertyMap </span>propertyMap <span style="color: blue">in </span>context.TypeMap.GetPropertyMaps())
        {
            MapPropertyValue(context, mapper, mappedObject, propertyMap);
        }
    }


    context.TypeMap.AfterMap(context.SourceValue, mappedObject);
    <span style="color: blue">return </span>mappedObject;
}</pre>

[](http://11011.net/software/vspaste)

By flattening my conditional statements, I can now much more easily apply other refactorings.&#160; But in the process, I wound up creating more duplication, so we need to amend our code smell list.&#160; With our updated list, here’s the planned refactorings:

  * Feature envy – Extract/Move method
  * Conditional complexity – Replace conditional logic with strategy/chain of responsibility
  * Long method – Same as above
  * Duplicated code – Form template method

It turns out at one point I had to do the exact same refactorings on another large piece in AutoMapper, one that chose different mapping algorithms to use (type maps, direct assignment, arrays, dictionaries, lists, etc.).&#160; In the next post, I’ll fix the feature envy code smell.