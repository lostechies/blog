---
wordpress_id: 337
title: Refactoring Challenge Part 3 – Pattern Implementation
date: 2009-07-23T01:21:48+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/07/22/refactoring-challenge-part-3-pattern-implementation.aspx
dsq_thread_id:
  - "270055988"
categories:
  - Refactoring
---
In the [previous part](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/07/08/refactoring-challenge-part-2-preparation.aspx) to the refactoring challenge, I needed to structure the original implementation to a point where I could start applying other refactorings.&#160; Whenever I start to see a bunch of “if” statements or a big switch statement, this is a pretty strong smell that I need to reduce conditional complexity by moving towards some specific patterns.&#160; The big one I’m looking for is a combination of Strategy and Specification, mashed together in some sort of pipeline.&#160; The idea is to allow each strategy be responsible for both the decision to do work, and the work itself.&#160; You wind up with an interface something like:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IStrategySpec
</span>{
    <span style="color: blue">bool </span>IsMatch(<span style="color: #2b91af">SomeContext </span>context);
    <span style="color: blue">void </span>DoWork(<span style="color: #2b91af">SomeContext </span>context);
}</pre>

[](http://11011.net/software/vspaste)

If this looks familiar, I blogged a while back on [how we do model binding](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/03/17/a-better-model-binder.aspx) in our MVC applications.&#160; It’s the same pattern:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IFilteredModelBinder
</span>{
    <span style="color: blue">bool </span>IsMatch(<span style="color: #2b91af">Type </span>modelType);
    <span style="color: #2b91af">Object </span>BindModel(ControllerContext controllerContext, 
        ModelBindingContext bindingContext);
}</pre>

[](http://11011.net/software/vspaste)

And our convention-based input builders follow again the same pattern:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IInputBuilder
</span>{
    <span style="color: blue">bool </span>IsMatch(IInputSpec inputSpec);
    <span style="color: blue">string </span>BuiltHtml(IInputSpec inputSpec);
}</pre>

[](http://11011.net/software/vspaste)

By separating the implementation of each strategy from how it’s used, I can allow each design to grow independently.&#160; For example, in the input builder example, we can apply all sorts of design patterns to IInputBuilders, such as Template Method, Decorator and so on, and not change the underlying infrastructure that actually handles all of our IInputBuilders.

Back to our example, in my original method, I had two responsibilities in each conditional block:

  * Deciding if the ResolutionContext was a match for a specific scenario
  * If a match, execute some mapping strategy

So first, I’ll need something to encapsulate the original strategy, my IStrategySpec.&#160; That’s a terrible name, so I picked something a little more meaningful:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">ITypeMapObjectMapper
</span>{
    <span style="color: blue">object </span>Map(<span style="color: #2b91af">ResolutionContext </span>context, <span style="color: #2b91af">IMappingEngineRunner </span>mapper);
    <span style="color: blue">bool </span>IsMatch(<span style="color: #2b91af">ResolutionContext </span>context, <span style="color: #2b91af">IMappingEngineRunner </span>mapper);
}</pre>

[](http://11011.net/software/vspaste)

With my interface defined, I can create the individual mapping implementations.

### Creating the individual mappers

This part was especially easy, it’s just a matter of combining Extract Method and Move Method to move each conditional block and its corresponding mapping logic out to an individual class.&#160; For example, here is one that concerns using a custom mapping function:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomMapperStrategy </span>: <span style="color: #2b91af">ITypeMapObjectMapper
</span>{
    <span style="color: blue">public object </span>Map(<span style="color: #2b91af">ResolutionContext </span>context, <span style="color: #2b91af">IMappingEngineRunner </span>mapper)
    {
        <span style="color: blue">return </span>context.TypeMap.CustomMapper(context);
    }

    <span style="color: blue">public bool </span>IsMatch(<span style="color: #2b91af">ResolutionContext </span>context, <span style="color: #2b91af">IMappingEngineRunner </span>mapper)
    {
        <span style="color: blue">return </span>context.TypeMap.CustomMapper != <span style="color: blue">null</span>;
    }
}</pre>

[](http://11011.net/software/vspaste)

It’s quite simple, but one class encapsulates all logic and behavior concerning mapping using a custom mapping function.&#160; The other mappers were pulled out as well.&#160; One interesting scenario I ran into was where two mapping algorithms were very similar.&#160; I could then apply Template Method so that derived types only need to supply the pieces that changed:

<pre><span style="color: blue">public abstract class </span><span style="color: #2b91af">PropertyMapMappingStrategy </span>: <span style="color: #2b91af">ITypeMapObjectMapper
</span>{
    <span style="color: blue">public object </span>Map(<span style="color: #2b91af">ResolutionContext </span>context, <span style="color: #2b91af">IMappingEngineRunner </span>mapper)
    {
        <span style="color: blue">var </span>mappedObject = GetMappedObject(context, mapper);
        <span style="color: blue">if </span>(context.SourceValue != <span style="color: blue">null</span>)
            context.InstanceCache.Add(context, mappedObject);

        context.TypeMap.BeforeMap(context.SourceValue, mappedObject);
        <span style="color: blue">foreach </span>(<span style="color: #2b91af">PropertyMap </span>propertyMap <span style="color: blue">in </span>context.TypeMap.GetPropertyMaps())
        {
            MapPropertyValue(context, mapper, mappedObject, propertyMap);
        }

        <span style="color: blue">return </span>mappedObject;
    }

    <span style="color: blue">public abstract bool </span>IsMatch(<span style="color: #2b91af">ResolutionContext </span>context, <span style="color: #2b91af">IMappingEngineRunner </span>mapper);

    <span style="color: blue">protected abstract object </span>GetMappedObject(<span style="color: #2b91af">ResolutionContext </span>context, <span style="color: #2b91af">IMappingEngineRunner </span>mapper);</pre>

[](http://11011.net/software/vspaste)

This is a great example where because I picked a powerful seam of integration to begin with, I’m left with many more options for designing the individual mapping behaviors.

Once all my mappers were created, I now needed to refactor the original class to use these individual strategy classes instead.

### Implementing the pipeline

Instead of a bunch of conditional logic, all I really need now is a collection of mappers, and some logic to loop through them.&#160; The final mapper became quite small:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">TypeMapMapper </span>: <span style="color: #2b91af">IObjectMapper
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">ITypeMapObjectMapper</span>&gt; _mappers;

    <span style="color: blue">public </span>TypeMapMapper(<span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">ITypeMapObjectMapper</span>&gt; mappers)
    {
        _mappers = mappers;
    }

    <span style="color: blue">public object </span>Map(<span style="color: #2b91af">ResolutionContext </span>context, <span style="color: #2b91af">IMappingEngineRunner </span>mapper)
    {
        <span style="color: blue">var </span>mapperToUse = _mappers.First(objectMapper =&gt; objectMapper.IsMatch(context, mapper));
        <span style="color: blue">object </span>mappedObject = mapperToUse.Map(context, mapper);

        context.TypeMap.AfterMap(context.SourceValue, mappedObject);
        <span style="color: blue">return </span>mappedObject;
    }

    <span style="color: blue">public bool </span>IsMatch(<span style="color: #2b91af">ResolutionContext </span>context)
    {
        <span style="color: blue">return </span>context.TypeMap != <span style="color: blue">null</span>;
    }
}</pre>

[](http://11011.net/software/vspaste)

That’s it!&#160; I loop through all my dependent mapper, picking the first one that matches the context passed in.&#160; Next, I use that mapper to map from the source object to some destination object.&#160; AutoMapper also supports custom callbacks for before/after mapping events, so I call any potential callback before finally returning the mapped object.

With the responsibilities clearly separated between selecting and applying the mapping, and the actual conditions and mapping algorithms, I’ve allowed my design to grow in ways that won’t add to the overall complexity.&#160; In the original method, I would cringe if I needed to add more behavior to this specific mapping algorithm, it was just too complex.&#160; After the refactoring, it’s a lot more understandable as I can group and name each mapping algorithm separately.

So this area is a lot cleaner – but no rest for the weary, feature requests are causing me to go back to other places that need some tidying up.&#160; On a side note, I often get the question “When should I refactor?”&#160; I’m not a fan of refactoring code just because I feel like it – there has to be a need.&#160; The need is change.&#160; If code needs to change, that’s when it’s time to refactor.&#160; I needed to add a feature to the above class, so it was time to clean it up.