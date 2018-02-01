---
id: 342
title: Late-Bound Invocations with DynamicMethod
date: 2009-08-06T01:05:13+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/08/05/late-bound-invocations-with-dynamicmethod.aspx
dsq_thread_id:
  - "264716267"
categories:
  - 'C#'
---
When I was looking at improving AutoMapper performance, I initially focused on just the “getter” side of the mapping equation.&#160; At its core, you map between types by getting a value from one member and setting it on the other.&#160; I was already familiar with expression trees, so I went with an extension of Nate Kohari’s method of doing code generation by using [expression trees to do late-bound invocation](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/06/17/more-on-late-bound-invocations-with-expression-trees.aspx).&#160; However, you can’t really do this with setters.&#160; This won’t compile, for example:

<pre><span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Action</span>&lt;<span style="color: #2b91af">Source</span>, <span style="color: blue">int</span>&gt;&gt; expr = (src, value) =&gt; src.Value = value;</pre>

[](http://11011.net/software/vspaste)

You’ll get a fun compile error of:

<pre>error CS0832: An expression tree may not contain an assignment operator</pre>

[](http://11011.net/software/vspaste)

Now, it’s possible to generate an expression tree to call a setter for a property, as a setter is really just method underneath the covers.&#160; But it’s not possible in C# 3.0 to set fields with expression trees.&#160; For this, I need another approach, so I decided to get my feet wet with Lightweight Code Generation using the [DynamicMethod](http://msdn.microsoft.com/en-us/library/system.reflection.emit.dynamicmethod.aspx) approach.

### Getting a template

DynamicMethod works by compiling IL into a strongly-typed delegate.&#160; You code the IL however you like with an IL generator, then call DynamicMethod to create a delegate for you.&#160; In my case, I wanted a delegate to set a property value on an object.&#160; But because types aren’t known at compile-time in AutoMapper, only at runtime, my generated method must only work in terms of “object”.&#160; To get an idea of the IL I wanted to write, I just created a method that did exactly what I wanted, for some sample types:

<pre><span style="color: blue">private void </span>DoItWithProperty(<span style="color: blue">object </span>source, <span style="color: blue">object </span>value)
{
    ((<span style="color: #2b91af">Source</span>)source).Value = (<span style="color: blue">int</span>)value;
}</pre>

[](http://11011.net/software/vspaste)

Notice that I’ll have to handle unboxing here, the value passed in could be anything, a reference or a value type.&#160; That also means that boxing happens when calling this method.&#160; But, boxing is just a way of life in a world where I have to deal with types and methods at runtime.&#160; To get a template, I viewed this compiled method in Reflector:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_41CE5D64.png" width="588" height="222" />](http://lostechies.com/jimmybogard/files/2011/03/image_1B6C7A19.png) 

I don’t really know what all of these IL codes mean (any of them, actually), but I can make a meaningful guess at them.&#160; I can see the casting and unboxing, as well as calling the setter method.&#160; Now that I have a template for my method, I can create a more generalized version for my needs.

### IL generation with DynamicMethod

To get my IL generation going, I wanted a named delegate type for the result of compiling my methods:

<pre><span style="color: blue">internal delegate void </span><span style="color: #2b91af">LateBoundFieldSet</span>(<span style="color: blue">object </span>target, <span style="color: blue">object </span>value);
<span style="color: blue">internal delegate void </span><span style="color: #2b91af">LateBoundPropertySet</span>(<span style="color: blue">object </span>target, <span style="color: blue">object </span>value);</pre>

[](http://11011.net/software/vspaste)

These two delegates will hold functions that can take any object and set the correct property/field using the value supplied.&#160; I wanted a factory to generate setters given any PropertyInfo or FieldInfo I give it, since these are the things I’m working with when mapping.&#160; First, I’ll need my DynamicMethod:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">LateBoundPropertySet </span>CreateSet(<span style="color: #2b91af">PropertyInfo </span>property)
{
    <span style="color: blue">var </span>method = <span style="color: blue">new </span><span style="color: #2b91af">DynamicMethod</span>(<span style="color: #a31515">"Set" </span>+ property.Name, <span style="color: blue">null</span>, <span style="color: blue">new</span>[] { <span style="color: blue">typeof</span>(<span style="color: blue">object</span>), <span style="color: blue">typeof</span>(<span style="color: blue">object</span>) }, <span style="color: blue">true</span>);</pre>

[](http://11011.net/software/vspaste)

I don’t need to name my dynamic method, but I do anyway.&#160; The next couple of parameters describe the signature of the method I’m creating, which is a void (object, object) method.&#160; The final parameter lets me skip any kinds of visibility checks, so I can get access to private accessors and whatnot.

With my DynamicMethod ready, I get the IL generator for it:

<pre><span style="color: blue">var </span>gen = method.GetILGenerator();</pre>

[](http://11011.net/software/vspaste)

And write the IL I need using this IL generator:

<pre><span style="color: blue">var </span>sourceType = property.DeclaringType;
<span style="color: blue">var </span>setter = property.GetSetMethod(<span style="color: blue">true</span>);

gen.Emit(<span style="color: #2b91af">OpCodes</span>.Ldarg_0); <span style="color: green">// Load input to stack
</span>gen.Emit(<span style="color: #2b91af">OpCodes</span>.Castclass, sourceType); <span style="color: green">// Cast to source type
</span>gen.Emit(<span style="color: #2b91af">OpCodes</span>.Ldarg_1); <span style="color: green">// Load value to stack
</span>gen.Emit(<span style="color: #2b91af">OpCodes</span>.Unbox_Any, property.PropertyType); <span style="color: green">// Unbox the value to its proper value type
</span>gen.Emit(<span style="color: #2b91af">OpCodes</span>.Callvirt, setter); <span style="color: green">// Call the setter method
</span>gen.Emit(<span style="color: #2b91af">OpCodes</span>.Ret);</pre>

[](http://11011.net/software/vspaste)

I put a bunch of comments in, as I can’t read IL and grok a program from it.&#160; Because I use the PropertyInfo’s types for the correct casting operations, my DynamicMethod will be tailored to exactly what my destination type and member types are.&#160; With the correct IL in, all that’s left is to create a delegate from my DynamicMethod and return it:

<pre><span style="color: blue">var </span>result = (<span style="color: #2b91af">LateBoundPropertySet</span>)method.CreateDelegate(<span style="color: blue">typeof</span>(<span style="color: #2b91af">LateBoundPropertySet</span>));

<span style="color: blue">return </span>result;</pre>

[](http://11011.net/software/vspaste)

With that handle to the LateBoundPropertySet delegate, I can do very efficient late-bound sets, where I only would know the types at runtime:

<pre><span style="color: blue">var </span>sourceType = <span style="color: blue">typeof </span>(<span style="color: #2b91af">Source</span>);
<span style="color: #2b91af">PropertyInfo </span>property = sourceType.GetProperty(<span style="color: #a31515">"Value"</span>);
<span style="color: #2b91af">LateBoundPropertySet </span>callback = <span style="color: #2b91af">DelegateFactory</span>.CreateSet(property);

<span style="color: blue">var </span>source = <span style="color: blue">new </span><span style="color: #2b91af">Source</span>();
callback(source, 5);

source.Value.ShouldEqual(5);</pre>

[](http://11011.net/software/vspaste)

When I did some profiling, I found that the strongly-typed delegate (i.e., Action<Source, int>) was _very_ close to the runtime of just setting directly.&#160; It was also on par with a lot of the numbers I read online.&#160; However, with the boxing/unboxing I have to do, I get not as good numbers, but waaaay better than reflection:

<pre>Raw:80000
MethodInfo:15780000
LCG:330000</pre>

[](http://11011.net/software/vspaste)

Numbers are in ticks.&#160; While raw setters are about 200 times faster than plain old reflection, LCG clocks in at around 50 times faster.&#160; That’s a lot faster, but the boxing and unboxing winds up taking quite a bit more time, at least in the case of value types.

### The completed code

Here’s the complete factory methods for setting both fields and properties:

<pre><span style="color: blue">public delegate void </span><span style="color: #2b91af">LateBoundFieldSet</span>(<span style="color: blue">object </span>target, <span style="color: blue">object </span>value);
<span style="color: blue">public delegate void </span><span style="color: #2b91af">LateBoundPropertySet</span>(<span style="color: blue">object </span>target, <span style="color: blue">object </span>value);

<span style="color: blue">public static </span><span style="color: #2b91af">LateBoundFieldSet </span>CreateSet(<span style="color: #2b91af">FieldInfo </span>field)
{
    <span style="color: blue">var </span>sourceType = field.DeclaringType;
    <span style="color: blue">var </span>method = <span style="color: blue">new </span><span style="color: #2b91af">DynamicMethod</span>(<span style="color: #a31515">"Set" </span>+ field.Name, <span style="color: blue">null</span>, <span style="color: blue">new</span>[] { <span style="color: blue">typeof</span>(<span style="color: blue">object</span>), <span style="color: blue">typeof</span>(<span style="color: blue">object</span>) }, <span style="color: blue">true</span>);
    <span style="color: blue">var </span>gen = method.GetILGenerator();
    
    gen.Emit(<span style="color: #2b91af">OpCodes</span>.Ldarg_0); <span style="color: green">// Load input to stack
    </span>gen.Emit(<span style="color: #2b91af">OpCodes</span>.Castclass, sourceType); <span style="color: green">// Cast to source type
    </span>gen.Emit(<span style="color: #2b91af">OpCodes</span>.Ldarg_1); <span style="color: green">// Load value to stack
    </span>gen.Emit(<span style="color: #2b91af">OpCodes</span>.Unbox_Any, field.FieldType); <span style="color: green">// Unbox the value to its proper value type
    </span>gen.Emit(<span style="color: #2b91af">OpCodes</span>.Stfld, field); <span style="color: green">// Set the value to the input field
    </span>gen.Emit(<span style="color: #2b91af">OpCodes</span>.Ret);

    <span style="color: blue">var </span>callback = (<span style="color: #2b91af">LateBoundFieldSet</span>)method.CreateDelegate(<span style="color: blue">typeof</span>(<span style="color: #2b91af">LateBoundFieldSet</span>));

    <span style="color: blue">return </span>callback;
}

<span style="color: blue">public static </span><span style="color: #2b91af">LateBoundPropertySet </span>CreateSet(<span style="color: #2b91af">PropertyInfo </span>property)
{
    <span style="color: blue">var </span>method = <span style="color: blue">new </span><span style="color: #2b91af">DynamicMethod</span>(<span style="color: #a31515">"Set" </span>+ property.Name, <span style="color: blue">null</span>, <span style="color: blue">new</span>[] { <span style="color: blue">typeof</span>(<span style="color: blue">object</span>), <span style="color: blue">typeof</span>(<span style="color: blue">object</span>) }, <span style="color: blue">true</span>);
    <span style="color: blue">var </span>gen = method.GetILGenerator();

    <span style="color: blue">var </span>sourceType = property.DeclaringType;
    <span style="color: blue">var </span>setter = property.GetSetMethod(<span style="color: blue">true</span>);

    gen.Emit(<span style="color: #2b91af">OpCodes</span>.Ldarg_0); <span style="color: green">// Load input to stack
    </span>gen.Emit(<span style="color: #2b91af">OpCodes</span>.Castclass, sourceType); <span style="color: green">// Cast to source type
    </span>gen.Emit(<span style="color: #2b91af">OpCodes</span>.Ldarg_1); <span style="color: green">// Load value to stack
    </span>gen.Emit(<span style="color: #2b91af">OpCodes</span>.Unbox_Any, property.PropertyType); <span style="color: green">// Unbox the value to its proper value type
    </span>gen.Emit(<span style="color: #2b91af">OpCodes</span>.Callvirt, setter); <span style="color: green">// Call the setter method
    </span>gen.Emit(<span style="color: #2b91af">OpCodes</span>.Ret);

    <span style="color: blue">var </span>result = (<span style="color: #2b91af">LateBoundPropertySet</span>)method.CreateDelegate(<span style="color: blue">typeof</span>(<span style="color: #2b91af">LateBoundPropertySet</span>));

    <span style="color: blue">return </span>result;
}</pre>

[](http://11011.net/software/vspaste)

Fields were slightly different, but I followed the same pattern of 1) write a template method, 2) view in Reflector and 3) transpose IL code into the IL generator.&#160; This optimization drastically lowered the time AutoMapper spends on actually setting values, to the point where I could focus on other places to optimize.

What’s interesting about this code is that you could extend it even more to translate Expression<Func<TObject, TMember>> into late-bound invocation methods, potentially greatly helping out those times where you’re using a lot of strongly-typed reflection to do both metadata and execution.