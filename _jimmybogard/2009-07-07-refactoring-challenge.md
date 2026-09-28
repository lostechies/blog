---
wordpress_id: 332
title: Refactoring challenge
date: 2009-07-07T02:42:47+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/07/06/refactoring-challenge.aspx
dsq_thread_id:
  - "264716252"
categories:
  - Refactoring
redirect_from: "/blogs/jimmy_bogard/archive/2009/07/06/refactoring-challenge.aspx/"
---
I don’t like messy, obfuscated code.&#160; But <strike>occasionally</strike> often, I write it anyway as I can’t quite see the right way to go.&#160; Today is one of those days where I can’t seem to get past some ugly code, none of my normal tricks seem to work.&#160; Instead of me doing any more work on it, I’m curious if anyone else has any ideas.&#160; Here’s the offending function, in the TypeMapMapper class from the trunk (R97) of the [AutoMapper codebase](http://code.google.com/p/automapperhome/):

<pre><span style="color: blue">public object </span>Map(<span style="color: #2b91af">ResolutionContext </span>context, <span style="color: #2b91af">IMappingEngineRunner </span>mapper)
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
            <span style="color: blue">foreach </span>(<span style="color: #2b91af">PropertyMap </span>propertyMap <span style="color: blue">in </span>context.TypeMap.GetPropertyMaps())
            {
                MapPropertyValue(context, mapper, mappedObject, propertyMap);
            }
        }

    }

    context.TypeMap.AfterMap(context.SourceValue, mappedObject);
    <span style="color: blue">return </span>mappedObject;
}</pre>

[](http://11011.net/software/vspaste)

Yes, it’s very, very long. Originally, there were four different exit points all over the place, but that made it difficult to do other things I needed (the BeforeMap and AfterMap calls).&#160; There’s just way too much going on here, so I’m curious if anyone out there in the æther has any other ideas.&#160; Feel free to post ideas here, or for those adventurous folks, submit a patch on the [AutoMapper group](http://groups.google.com/group/automapper-users).&#160; Frankly, it’s making me cross-eyed, so I’ll just turn away in shame.