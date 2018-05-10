---
wordpress_id: 31
title: Writing a profiler for Silverlight applications – Part 1
date: 2009-11-26T19:42:28+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2009/11/26/writing-a-profiler-for-silverlight-applications-part-1.aspx
dsq_thread_id:
  - "263908898"
categories:
  - How To
  - introduction
  - Mono
  - Mono Cecil
  - MSIL
  - Silverlight
redirect_from: "/blogs/gabrielschenker/archive/2009/11/26/writing-a-profiler-for-silverlight-applications-part-1.aspx/"
---
</p> 

In this article I want to discuss the steps needed to instrument a Silverlight assembly such as that it can be profiled. To achieve this task I use Mono Cecil, a library from the Mono platform which is an open source implementation of .NET.

## Introduction

In my company we have a very complex Silverlight application. This application is highly dynamic and fully asynchronous. Lately we encountered some performance problems on slower PCs. Unfortunately there doesn’t yet exist any decent profiler for Silverlight applications. Since &#8211; as I already mentioned &#8211; our application is rather complex it is difficult to impossible to analyze this application thoroughly without a good profiling tool. We have tried various ways to track down the problems by e.g. manually adding trace code or by writing profiling interceptors for all our classes that are registered in the IoC container. With this methods we were able to track some hotspots but these were only the tips of an iceberg.

While discussing with a coworker who showed me what he is doing with the aid of the Mono Cecil library I suddenly realized: “I can write my own profiler!”. 

This is my first project using the [Mono Cecil](http://www.mono-project.com/Cecil) library. In this project we only need the Mono.Cecil.dll assembly.

Please note that the techniques presented here can be used for any type of assembly and are not restricted to Silverlight assemblies.

## First Step – discovering all types and its members

I want visit all members of all my types in the assembly that I want to instrument for profiling purposes. The first code snippet I use to test my intent is

<div class="csharpcode">
  <pre><span class="kwrd">public</span> <span class="kwrd">void</span> Parse(Assembly assembly)</pre>
  
  <pre>{</pre>
  
  <pre>    var assemblyDef = AssemblyFactory.GetAssembly(assembly.Location);</pre>
  
  <pre>    Console.WriteLine(<span class="str">"Assembly {0}"</span>, assemblyDef.Name);</pre>
  
  <pre>&#160;</pre>
  
  <pre>    <span class="kwrd">foreach</span> (TypeDefinition type <span class="kwrd">in</span> assemblyDef.MainModule.Types)</pre>
  
  <pre>    {</pre>
  
  <pre>        <span class="kwrd">if</span> (type.Name == <span class="str">"&lt;Module&gt;"</span>) <span class="kwrd">continue</span>;</pre>
  
  <pre>&#160;</pre>
  
  <pre>        Console.WriteLine(<span class="str">"Type {0}"</span>, type.Name);</pre>
  
  <pre>        <span class="kwrd">foreach</span> (MethodDefinition method <span class="kwrd">in</span> type.Methods)</pre>
  
  <pre>        {</pre>
  
  <pre>            Console.WriteLine(<span class="str">"Method {0}"</span>, method.Name);</pre>
  
  <pre>        }</pre>
  
  <pre>    }</pre>
  
  <pre>}</pre>
</div>

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

The above code uses the Mono.Cecil assembly and just prints all members of all types&#160; of the assembly passed as a parameter to the method. I specifically want to verify that even private methods and automatic properties are discovered correctly. Please note that a property is nothing else than a pair of a setter and a getter method. The type I am analyzing is defined as follows

<pre><span class="kwrd">public</span> <span class="kwrd">class</span> TestClass
{
    <span class="kwrd">public</span> TestClass()
    {
        Console.WriteLine(<span class="str">"Constructor of TestClass"</span>);
    }

    <span class="kwrd">public</span> <span class="kwrd">void</span> PublicVoidFunction()
    {
        
    }

    <span class="kwrd">protected</span> <span class="kwrd">int</span> ProtectedIntFunction()
    {
        <span class="kwrd">return</span> 0;
    }

    <span class="kwrd">private</span> <span class="kwrd">decimal</span> PrivateDecimalFunction()
    {
        <span class="kwrd">return</span> 1.0m;
    }

    <span class="kwrd">public</span> <span class="kwrd">string</span> AutomaticProperty { get; set; }

    <span class="kwrd">private</span> <span class="kwrd">string</span> standardProperty;
    <span class="kwrd">public</span> <span class="kwrd">string</span> StandardProperty
    {
        get { <span class="kwrd">return</span> standardProperty; }
        set { standardProperty = <span class="kwrd">value</span>; }
    }
}</pre>

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

and the output generated is

[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2011/03/image_thumb_779D6967.png" width="291" height="215" />](https://lostechies.com/content/gabrielschenker/uploads/2011/03/image_5F0DCC17.png) 

We can immediately see that everything is listed as expected except for the constructor. How can I get hold on the constructor? It turns out that the type definition does have a constructors collection which provides me exactly the information needed

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }</p> 

<pre><span class="kwrd">foreach</span> (MethodDefinition method <span class="kwrd">in</span> type.Constructors)
{
    Console.WriteLine(<span class="str">"Constructor {0}"</span>, method);
}</pre>

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

Now it will be interesting to know if I can also discover anonymous functions since we use them very intensively in our code base. It is thus absolutely mandatory to also instrument those functions. And it turns out that Cecil indeed discovers them. If I have the following method call

<pre>MethodWithAFunctionParameter(i =&gt;
                                 {
                                     var random = <span class="kwrd">new</span> Random((<span class="kwrd">int</span>) DateTime.Now.Ticks);
                                     <span class="kwrd">return</span> i &lt; random.Next(100);
                                 });</pre>

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

This anonymous function is discovered and output as follows

[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2011/03/image_thumb_5DC93338.png" width="286" height="57" />](https://lostechies.com/content/gabrielschenker/uploads/2011/03/image_251E892B.png) 

The first part of the name <PublicVoidFunction> is taken from the method that contains the anonymous function definition.

## Second step – Injecting instrumentation code

Ok, now I have everything to start with my instrumentation. This will be the harder part since I have to inject some code into every discovered method. The code has to be in MSIL. I will have some code at the beginning of each method and some at the end of each method. I will call the former pre-invocation code and the latter post-invocation code.

To avoid any unnecessary complexity my pre- and post-invocation code should be as simple as possible. Thus I decided to just make a parameter less call to a (static) method of a specific class. This class will contain all logic needed to profile my application. In my sample I call this class ProfileInfoTracker and the static methods I want to call are WhenEnteringMethod and WhenLeavingMethod.

Thus each instrumented method of my assembly will look like this void sample function

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> PublicVoidFunction()</pre>
    
    <pre>{</pre>
    
    <pre>    ProfileInfoTracker.WhenEnteringMethod();</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #008000">// user code...</span></pre>
    
    <pre>&#160;</pre>
    
    <pre>    ProfileInfoTracker.WhenLeavingMethod();</pre>
    
    <pre>}</pre></p>
  </div>
</div>

or this function returning a result

<div>
  <div>
    <pre><span style="color: #0000ff">protected</span> <span style="color: #0000ff">int</span> ProtectedIntFunction()</pre>
    
    <pre>{</pre>
    
    <pre>    ProfileInfoTracker.WhenEnteringMethod();</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #008000">// user code...</span></pre>
    
    <pre>    <span style="color: #008000">// ...</span></pre>
    
    <pre>    result = ...</pre>
    
    <pre>&#160;</pre>
    
    <pre>    ProfileInfoTracker.WhenLeavingMethod();</pre>
    
    <pre>    <span style="color: #0000ff">return</span> result;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Before fumbling around with IL code I implemented a reference method including the pre- and post-invocation code in C# and compiled it. Then I analyzed the output in [Reflector](http://www.red-gate.com/products/reflector/).

This is the method I analyzed in C#

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> PublicVoidFunction()</pre>
    
    <pre>{</pre>
    
    <pre>    ProfileInfoTracker.WhenEnteringMethod();</pre>
    
    <pre>    Random random = <span style="color: #0000ff">new</span> Random((<span style="color: #0000ff">int</span>) DateTime.Now.Ticks);</pre>
    
    <pre>    Thread.Sleep(random.Next(50));</pre>
    
    <pre>    ProfileInfoTracker.WhenLeavingMethod();</pre>
    
    <pre>}</pre></p>
  </div>
</div>

and this is the very same method in IL code

<div>
  <div>
    <pre>.method <span style="color: #0000ff">public</span> hidebysig instance <span style="color: #0000ff">void</span> PublicVoidFunction() cil managed</pre>
    
    <pre>{</pre>
    
    <pre>    .maxstack 3</pre>
    
    <pre>    .locals init (</pre>
    
    <pre>        [0] <span style="color: #0000ff">class</span> [mscorlib]System.Random random,</pre>
    
    <pre>        [1] valuetype [mscorlib]System.DateTime time)</pre>
    
    <pre>    L_0000: call <span style="color: #0000ff">void</span> Instrumenter.ProfileInfoTracker::WhenEnteringMethod()</pre>
    
    <pre>    L_0005: nop </pre>
    
    <pre>    L_0006: call valuetype [mscorlib]System.DateTime [mscorlib]System.DateTime::get_Now()</pre>
    
    <pre>    L_000b: stloc.1 </pre>
    
    <pre>    L_000c: ldloca.s time</pre>
    
    <pre>    L_000e: call instance int64 [mscorlib]System.DateTime::get_Ticks()</pre>
    
    <pre>    L_0013: conv.i4 </pre>
    
    <pre>    L_0014: newobj instance <span style="color: #0000ff">void</span> [mscorlib]System.Random::.ctor(int32)</pre>
    
    <pre>    L_0019: stloc.0 </pre>
    
    <pre>    L_001a: ldloc.0 </pre>
    
    <pre>    L_001b: ldc.i4.s 50</pre>
    
    <pre>    L_001d: callvirt instance int32 [mscorlib]System.Random::Next(int32)</pre>
    
    <pre>    L_0022: call <span style="color: #0000ff">void</span> [mscorlib]System.Threading.Thread::Sleep(int32)</pre>
    
    <pre>    L_0027: nop </pre>
    
    <pre>    L_0028: call <span style="color: #0000ff">void</span> Instrumenter.ProfileInfoTracker::WhenLeavingMethod()</pre>
    
    <pre>    L_002d: ret </pre>
    
    <pre>}</pre></p>
  </div>
</div>

The interesting parts for me are the two lines at L\_0000 and L\_0028. I will have to use Mono Cecil to inject those statements in each and every method of the assembly I want to instrument.

It turns out that there is a very limited amount of documentation available for Mono Cecil. This made my start a little bit slow. But after I waded through those upfront difficulties the usage is straight forward. 

I can create such an IL call instruction with the following code

<div>
  <div>
    <pre><span style="color: #0000ff">private</span> Instruction CreateCallInstruction(CilWorker worker, <span style="color: #0000ff">string</span> methodName)</pre>
    
    <pre>{</pre>
    
    <pre>    var methodInfo = <span style="color: #0000ff">typeof</span>(ProfileInfoTracker).GetMethod(methodName);</pre>
    
    <pre>    var methodReference = assembly.MainModule.Import(methodInfo);</pre>
    
    <pre>    <span style="color: #0000ff">return</span> worker.Create(OpCodes.Call, methodReference);</pre>
    
    <pre>}</pre></p>
  </div>
</div>

the above method has two parameters. The first one is the CIL worker object which I can get for via the MethodReference of the method I am currently instrumenting

<div>
  <div>
    <pre>var worker = methodReference.Body.CilWorker;</pre></p>
  </div>
</div>

The second parameter is the name of the method I want to call on the target class which in our case is just the ProfileInfoTracker class.

With the aid of the CIL worker I can the create my desired IL call instruction (the WhenEnteringMethod and well as the WhenLeavingMethod call).

To instrument the current method I can now use the following code

<div>
  <div>
    <pre><span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> InstrumentMethod(MethodDefinition method)</pre>
    
    <pre>{</pre>
    
    <pre>    AddPreInvocationCode(method);</pre>
    
    <pre>    AddPostInvocationCode(method);</pre>
    
    <pre>}</pre>
    
    <pre>&#160;</pre>
    
    <pre><span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> AddPreInvocationCode(MethodDefinition method)</pre>
    
    <pre>{</pre>
    
    <pre>    var worker = method.Body.CilWorker;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    var callMethod = CreateCallInstruction(worker, <span style="color: #006080">"WhenEnteringMethod"</span>);</pre>
    
    <pre>&#160;</pre>
    
    <pre>    var lastInstruction = method.Body.Instructions[0];</pre>
    
    <pre>    worker.InsertBefore(lastInstruction, callMethod);</pre>
    
    <pre>}</pre>
    
    <pre>&#160;</pre>
    
    <pre><span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> AddPostInvocationCode(MethodDefinition method)</pre>
    
    <pre>{</pre>
    
    <pre>    var worker = method.Body.CilWorker;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    var callMethod = CreateCallInstruction(worker, <span style="color: #006080">"WhenLeavingMethod"</span>);</pre>
    
    <pre>&#160;</pre>
    
    <pre>    var lastInstruction = method.Body.Instructions[method.Body.Instructions.Count - 1];</pre>
    
    <pre>    worker.InsertBefore(lastInstruction, callMethod);</pre>
    
    <pre>&#160;</pre>
    
    <pre>    ReplaceJumpToLastInstructionWithJumpToPostInvocationCall(method, lastInstruction, callMethod);</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Note that the pre-invocation call is added as very first instruction of the method boy whereas the post-invocation call instruction is added as second-last instruction; right before the “ret” OpCode.

Also not the call to the method ReplaceJumpToLastInstructionWithJumpToPostInvocationCall. If inside the method (previous to instrumenting it) there is a jump to the last op code (the ret statement) we have to replace this jump with a jump to our post-invocation call. This can be achieved like this

<div>
  <div>
    <pre><span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> ReplaceJumpToLastInstructionWithJumpToPostInvocationCall(MethodDefinition method, Instruction lastInstruction, Instruction callMethod)</pre>
    
    <pre>{</pre>
    
    <pre>    var jumpInstructions = method.Body.Instructions.Cast&lt;Instruction&gt;()</pre>
    
    <pre>        .Where(i =&gt; i.Operand == lastInstruction);</pre>
    
    <pre>    jumpInstructions.ForEach(i =&gt; i.Operand = callMethod);</pre>
    
    <pre>}</pre></p>
  </div>
</div>

## Summary

In this article I have discussed how the Mono Cecil library can be used to instrument an existing .NET assembly and make it ready to be profiled. In the next post I will discuss the gathering and analysis of profiling data.