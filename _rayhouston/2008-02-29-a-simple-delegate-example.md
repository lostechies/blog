---
wordpress_id: 11
title: A Simple Delegate Example
date: 2008-02-29T03:32:21+00:00
author: Ray Houston
layout: post
wordpress_guid: /blogs/rhouston/archive/2008/02/28/a-simple-delegate-example.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/rhouston/archive/2008/02/28/a-simple-delegate-example.aspx/"
---
I was recently working on a code generator and I made use of some simple delegates and I thought that I would share a few ideas.

Some folks may be wondering what is a delegate.&nbsp; You can think of a delegate as a type safe function pointer. It&#8217;s a type which can be passed around like any other type and it can be invoked which calls the original method that it&#8217;s pointing to. Lets look at a delegate type declaration:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">delegate</span> <span style="color: #0000ff">void</span> DoSomething();</pre>
</div>

This basically creates a delegate type called DoSomething that can point to a method that takes no arguments and returns void. 

Say you have a method:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> HeresSomething()
{
    <span style="color: #008000">//put something here</span>
}
</pre>
</div>

then you can create a new instance of our delegate and have it point to that method like:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">DoSomething myDelegate = <span style="color: #0000ff">new</span> DoSomething(HeresSomething);</pre>
</div>

[ReSharper](http://www.jetbrains.com/resharper/) tells me that you can abbreviate this syntax like so:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">DoSomething myDelegate = HeresSomething;</pre>
</div>

Now myDelegate can be passed around and then executed just like a method which will call the real method HeresSomething():

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">myDelegate();</pre>
</div>

This becomes really valuable is when you have delegates that take arguments and return values as you will see in a moment.

In my particular real life case, I have some .NET data transfer objects (DTOs) which I want to code generate equivalent Flex ActionScript objects so I can move data back and forth via serialization. These DTOs can be complex types (objects within objects) so I will need to unwind the object hierarchy to determine what to generate.

Let&#8217;s look at an example without using delegates:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">class</span> TypeUnwinder
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Unwind(Type type, List&lt;Type&gt; allTypes)
    {
        <span style="color: #0000ff">if</span> (allTypes.Contains(type))
            <span style="color: #0000ff">return</span>;

        allTypes.Add(type);

        UnwindProperties(type, allTypes);
        UnwindMethods(type, allTypes);
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> UnwindProperties(Type type, List&lt;Type&gt; allTypes)
    {
        <span style="color: #0000ff">foreach</span> (PropertyInfo propertyInfo <span style="color: #0000ff">in</span> type.GetProperties())
        {
            Unwind(propertyInfo.PropertyType, allTypes);
        }
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> UnwindMethods(Type type, List&lt;Type&gt; allTypes)
    {
        <span style="color: #0000ff">foreach</span> (MethodInfo methodInfo <span style="color: #0000ff">in</span> type.GetMethods())
        {
            Unwind(methodInfo.ReturnType, allTypes);
            UnwindParameters(methodInfo, allTypes);
        }
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> UnwindParameters(MethodInfo methodInfo, List&lt;Type&gt; allTypes)
    {
        <span style="color: #0000ff">foreach</span> (ParameterInfo parameterInfo <span style="color: #0000ff">in</span> methodInfo.GetParameters())
        {
            Unwind(parameterInfo.ParameterType, allTypes);
        }
    }
}
</pre>
</div>

This code works ok but my real case is much more complex. I actually have to unwind a couple of different times for different reasons and I have multiple checks for attributes and I ignore certain types. I want to reuse my pattern of unwinding with different logic. I can do this using a delegate. Instead of passing a List around, I can have the UnwindType method simply call a delegate that takes a Type. The calling class supplies the delegate and figures out what to do with the Type when it&#8217;s called.

First I create a delegate that returns bool that takes one argument of type Type:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">delegate</span> <span style="color: #0000ff">bool</span> DoSomethingWithTypeDelegate(Type type);</pre>
</div>

Then we modify our class by removing the references to the List and have it take in an instance of our delegate in the constructor:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">class</span> TypeUnwinder2
{
    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> DoSomethingWithTypeDelegate doSomethingWithType;

    <span style="color: #0000ff">public</span> TypeUnwinder2(DoSomethingWithTypeDelegate doSomethingWithType)
    {
        <span style="color: #0000ff">this</span>.doSomethingWithType = doSomethingWithType;
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> UnwindType(Type type)
    {
        <span style="color: #0000ff">if</span>(!doSomethingWithType(type))
            <span style="color: #0000ff">return</span>;

        UnwindProperties(type);
        UnwindMethods(type);
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> UnwindProperties(Type type)
    {
        <span style="color: #0000ff">foreach</span> (PropertyInfo propertyInfo <span style="color: #0000ff">in</span> type.GetProperties())
        {
            UnwindType(propertyInfo.PropertyType);
        }
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> UnwindMethods(Type type)
    {
        <span style="color: #0000ff">foreach</span> (MethodInfo methodInfo <span style="color: #0000ff">in</span> type.GetMethods())
        {
            UnwindType(methodInfo.ReturnType);
            UnwindParameters(methodInfo);
        }
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> UnwindParameters(MethodInfo methodInfo)
    {
        <span style="color: #0000ff">foreach</span> (ParameterInfo parameterInfo <span style="color: #0000ff">in</span> methodInfo.GetParameters())
        {
            UnwindType(parameterInfo.ParameterType);
        }
    }
}
</pre>
</div>

Now a calling class can control what actually happens when a Type is hit (remember, this is just example code):

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">class</span> Program
{
    <span style="color: #0000ff">static</span> <span style="color: #0000ff">readonly</span> List&lt;Type&gt; types = <span style="color: #0000ff">new</span> List&lt;Type&gt;();

    <span style="color: #0000ff">static</span> <span style="color: #0000ff">void</span> Main(<span style="color: #0000ff">string</span>[] args)
    {
        TypeUnwinder2 unwinder = <span style="color: #0000ff">new</span> TypeUnwinder2(IndexType);

        unwinder.UnwindType(<span style="color: #0000ff">typeof</span>(SomeCustomTypeToUnwind));

        <span style="color: #0000ff">foreach</span> (Type type <span style="color: #0000ff">in</span> types)
        {
            Console.WriteLine(type.FullName);
        }
    }

    <span style="color: #0000ff">static</span> <span style="color: #0000ff">bool</span> IndexType(Type type)
    {
        <span style="color: #0000ff">if</span> (!types.Contains(type))
        {
            types.Add(type);
            <span style="color: #0000ff">return</span> <span style="color: #0000ff">true</span>;
        }

        <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>;            
    }
}
</pre>
</div>

Notice how we pass in IndexType to the TypeUnwinder2 constructor (the delegate is created for you). If we wanted to see the delegate, we could have done:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">TypeUnwinder2 unwinder = <span style="color: #0000ff">new</span> TypeUnwinder2(<span style="color: #0000ff">new</span> DoSomethingWithTypeDelegate(IndexType));</pre>
</div>

So adding a delegate allowed me to decouple my unwinding pattern from the work that happens as a result of the unwinding. Yeah!

Here&#8217;s a version that uses another delegate to reuse a single foreach loop. It&#8217;s a bit ridiculous , but it might be fun to decipher.

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">class</span> TypeUnwinder3
{
    <span style="color: #0000ff">private</span> DoSomethingWithTypeDelegate doSomethingWithType;

    <span style="color: #0000ff">public</span> TypeUnwinder3(DoSomethingWithTypeDelegate doSomethingWithType)
    {
        <span style="color: #0000ff">this</span>.doSomethingWithType = doSomethingWithType;
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> UnwindType(Type type)
    {
        <span style="color: #0000ff">if</span> (!doSomethingWithType(type))
            <span style="color: #0000ff">return</span>;

        UnwindItems(type.GetProperties(), UnwindProperty);
        UnwindItems(type.GetMethods(), UnwindMethod);
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> UnwindItems&lt;T&gt;(IEnumerable&lt;T&gt; items, Action&lt;T&gt; process)
    {
        <span style="color: #0000ff">foreach</span> (T item <span style="color: #0000ff">in</span> items)
        {
            process(item);
        }
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> UnwindProperty(PropertyInfo propertyInfo)
    {
        UnwindType(propertyInfo.PropertyType);
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> UnwindMethod(MethodInfo methodInfo)
    {
        UnwindType(methodInfo.ReturnType);
        UnwindItems(methodInfo.GetParameters(), UnwindParameter);
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> UnwindParameter(ParameterInfo parameterInfo)
    {
        UnwindType(parameterInfo.ParameterType);
    }
}
</pre>
</div>

<div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  Technorati Tags: <a href="http://technorati.com/tags/.NET" rel="tag">.NET</a>,<a href="http://technorati.com/tags/Delegates" rel="tag">Delegates</a>
</div>