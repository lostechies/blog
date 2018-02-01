---
id: 333
title: 'Refactoring challenge Part 1 &#8211; Examination'
date: 2009-07-08T02:51:45+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/07/07/refactoring-challenge-part-1-examination.aspx
dsq_thread_id:
  - "264716233"
categories:
  - Refactoring
---
Most of the time I post code on my blog, it’s something I’m proud of.&#160; Other times, it’s code I didn’t write, which I promptly lambaste.&#160; In my [last post](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/07/06/refactoring-challenge.aspx), I threw up code I did write, but couldn’t see the design coming out.&#160; From the responses, I think I have some direction.&#160; But first, let’s take a closer look at the design issues with the original code, and try to catalog the code smells.&#160; This should give us direction on how we need to refactor it.&#160; Here’s the original code:

<pre><span style="color: blue">public object </span>Map(ResolutionContext context, IMappingEngineRunner mapper)
{
    <span style="color: blue">object </span>mappedObject = <span style="color: blue">null</span>;
    <span style="color: blue">var </span>profileConfiguration = mapper.ConfigurationProvider.GetProfileConfiguration(context.TypeMap.Profile);

    <span style="color: blue">if </span>(context.TypeMap.CustomMapper != <span style="color: blue">null</span>)
    {
        context.TypeMap.BeforeMap(context.SourceValue, mappedObject);
        mappedObject = context.TypeMap.CustomMapper(context);
    }
    <span style="color: blue">else if </span>(context.SourceValue != <span style="color: blue">null </span>|| !profileConfiguration.MapNullSourceValuesAsNull)
    {
        <span style="color: blue">if </span>(context.DestinationValue == <span style="color: blue">null </span>&& context.InstanceCache.ContainsKey(context))
        {
            mappedObject = context.InstanceCache[context];
        }
        <span style="color: blue">else
        </span>{
            <span style="color: blue">if </span>(context.DestinationValue == <span style="color: blue">null</span>)
            {
                mappedObject = mapper.CreateObject(context.DestinationType);
                <span style="color: blue">if </span>(context.SourceValue != <span style="color: blue">null</span>)
                    context.InstanceCache.Add(context, mappedObject);
            }
            <span style="color: blue">else
            </span>{
                mappedObject = context.DestinationValue;
            }

            context.TypeMap.BeforeMap(context.SourceValue, mappedObject);
            <span style="color: blue">foreach </span>(PropertyMap propertyMap <span style="color: blue">in </span>context.TypeMap.GetPropertyMaps())
            {
                MapPropertyValue(context, mapper, mappedObject, propertyMap);
            }
        }

    }

    context.TypeMap.AfterMap(context.SourceValue, mappedObject);
    <span style="color: blue">return </span>mappedObject;
}</pre>

[](http://11011.net/software/vspaste)

So let’s list out the code smells, there are quite a few.

#### No tests

I forgot to post the tests, but even more telling, I only really have large-grained, scenario based tests that cover this class.&#160; No unit tests, and that problem starts to show here, as tests would have surfaced the code smells earlier.

#### Feature Envy

There’s lots of poking around the ResolutionContext object (which is responsible for holding all information pertaining to a mapping operation).&#160; For example, the first nested “if” asks the ResolutionContext a lot of things that don’t seem to make any sense by themselves.&#160; Additionally, it’s not clear at all what each conditional has to do with the work being done.

#### 

#### Long Method

This should be quite obvious.&#160; For me, the ideal maximum method length is about 10 lines.&#160; That’s pretty much the limit of my understanding of what’s going on.&#160; Any more than that, and I have to put too much context into my head.

#### Conditional Complexity

Way too much branching going on here, and even worse, it looks like arrowhead programming.&#160; Flip it sideways, it looks like a mountain range with all the indention.&#160; The cyclomatic complexity is off the charts here, and a tool like NDepend would let me know right away where my maintenance problems will be.

Those are a lot of code smells, but each one has their corresponding refactoring to take care of it.&#160; In retrospect, I’m not sure why I just didn’t look for code smells in the first place.&#160; In the next few posts, I’ll apply refactorings one by one to get to my destination – clean code.