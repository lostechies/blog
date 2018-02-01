---
id: 225
title: Building arrays in StructureMap 2.5
date: 2008-09-03T12:08:05+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/09/03/building-arrays-in-structuremap-2-5.aspx
dsq_thread_id:
  - "264715899"
categories:
  - StructureMap
---
Although it was possible in previous versions of StructureMap, the new fluent interface for StructureMap configuration in version 2.5 allows easy configuration of array type constructor parameters.&nbsp; For example, consider a simple order processor pipeline:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">OrderPipeline
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IOrderPipelineStep</span>[] _steps;

    <span style="color: blue">public </span>OrderPipeline(<span style="color: #2b91af">IOrderPipelineStep</span>[] steps)
    {
        _steps = steps;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">IOrderPipelineStep</span>[] Steps
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>_steps; }
    }

    <span style="color: blue">public </span><span style="color: #2b91af">OrderPipelineResponse </span>Execute(<span style="color: #2b91af">OrderPipelineRequest </span>request)
    {
        <span style="color: #2b91af">OrderPipelineResponse </span>response = <span style="color: blue">null</span>;
        <span style="color: blue">foreach </span>(<span style="color: blue">var </span>step <span style="color: blue">in </span>_steps)
        {
            response = step.ExecuteStep(request);
            <span style="color: blue">if </span>(!response.IsSuccessful)
                <span style="color: blue">return </span>response;
        }
        <span style="color: blue">return </span>response;
    }
}
</pre>

[](http://11011.net/software/vspaste)

This pipeline takes an array of pipeline steps.&nbsp; Given a pipeline request, which may contain information necessary for the steps, it executes each of the steps in order.&nbsp; If any of the responses is not successful, the pipeline stops executing and returns the current response.

No where in this pipeline do we see which steps should be created.&nbsp; Some steps may require service location from StructureMap, while others may not have any dependencies.&nbsp; In any case, we want the construction of the pipeline steps for the pipeline to be external from the pipeline, as we can see it&#8217;s only concerned with executing steps.

But _someone_ has to be concerned with which steps can be executed.&nbsp; For many of our dependencies, the [DefaultConventionScanner](http://www.lostechies.com/blogs/chad_myers/archive/2008/06/11/neat-tricks-with-structuremap.aspx) is all we need to construct our dependencies.&nbsp; With an array parameter, there is no way StructureMap could automatically figure out which dependencies to create, and which order.&nbsp; Instead, we can create a custom Registry to configure our dependency:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">PipelineRegistry </span>: <span style="color: #2b91af">Registry
</span>{
    <span style="color: blue">protected override void </span>configure()
    {
        ForRequestedType&lt;<span style="color: #2b91af">OrderPipeline</span>&gt;()
            .TheDefault.Is.OfConcreteType&lt;<span style="color: #2b91af">OrderPipeline</span>&gt;()
            .TheArrayOf&lt;<span style="color: #2b91af">IOrderPipelineStep</span>&gt;()
            .Contains(x =&gt;
                          {
                              x.OfConcreteType&lt;<span style="color: #2b91af">ValidationStep</span>&gt;();
                              x.OfConcreteType&lt;<span style="color: #2b91af">SynchronizationStep</span>&gt;();
                              x.OfConcreteType&lt;<span style="color: #2b91af">RoutingStep</span>&gt;();
                              x.OfConcreteType&lt;<span style="color: #2b91af">PersistenceStep</span>&gt;();
                          });
    }
}
</pre>

[](http://11011.net/software/vspaste)

In this Registry, I tell StructureMap first what the requested and default concrete types are.&nbsp; Next, I tell StructureMap that the array of IOrderPipelineStep contains a set of concrete types.&nbsp; The Contains method takes a delegate, so I can use a lambda to configure all of the individual concrete types.&nbsp; Each step is created in the order I specify in the lambda block.&nbsp; Here&#8217;s the passing test:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_construct_the_pipeline_steps_correctly()
{
    <span style="color: #2b91af">StructureMapConfiguration
        </span>.ScanAssemblies()
        .IncludeTheCallingAssembly()
        .With&lt;<span style="color: #2b91af">DefaultConventionScanner</span>&gt;();

    <span style="color: blue">var </span>pipeline = <span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">OrderPipeline</span>&gt;();

    pipeline.Steps.Length.ShouldEqual(4);
    pipeline.Steps[0].ShouldBeOfType(<span style="color: blue">typeof </span>(<span style="color: #2b91af">ValidationStep</span>));
    pipeline.Steps[1].ShouldBeOfType(<span style="color: blue">typeof </span>(<span style="color: #2b91af">SynchronizationStep</span>));
    pipeline.Steps[2].ShouldBeOfType(<span style="color: blue">typeof </span>(<span style="color: #2b91af">RoutingStep</span>));
    pipeline.Steps[3].ShouldBeOfType(<span style="color: blue">typeof </span>(<span style="color: #2b91af">PersistenceStep</span>));
}
</pre>

[](http://11011.net/software/vspaste)

Notice that I did not need to specify the individual Registry.&nbsp; StructureMap scans the given assemblies for Registries, and automatically adds them to the configuration.&nbsp; Next, I ask StructureMap for an instance of the OrderPipeline.&nbsp; Again, nowhere do we see any code for constructing the correct list of IOrderPipelineSteps, this is encapsulated in our Registry.&nbsp; Finally, the rest of the test asserts that both the correct steps were created, and in the right order.

With the new fluent interface in StructureMap 2.5, I get a nice declarative interface to configure all of the special dependencies.&nbsp; Although the DefaultConventionScanner picks up almost all of my dependencies, in some special cases I still need to configure them.&nbsp; Array dependencies are created simply enough just with a lambda specifying the correct steps.