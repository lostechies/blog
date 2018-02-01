---
id: 441
title: The Arrow Anti-pattern
date: 2009-10-05T09:46:00+00:00
author: Derek Greer
layout: post
guid: http://www.aspiringcraftsman.com/2009/10/the-arrow-anti-pattern/
dsq_thread_id:
  - "315806382"
categories:
  - Uncategorized
tags:
  - Arrow
---
The Arrow Ani-pattern is a name given to the resulting structure produced by using excessive nested conditional operators. The following pseudo-code demonstrates why the name is apt:

<pre class="brush:csharp">if( ... )
{
    if( ... )
    {
        if( ... )
        {
            if( ... )
            {
                if( ... )
                {
                    //--&gt; do something
                }

            }
        }
    }
}
</pre>

The structure above becomes increasingly problematic as each additional nested condition adds to the cognitive load required to parse the represented logic. According to studies performed by Noam Chomsky and Gerald Weinberg in 1986, few people can easily understand more than three levels of nested conditional statements. It is therefore recommended that techniques for restructuring the code be sought out when this pattern begins to emerge.

## Guard Clauses

One approach to refactoring the arrow anti-pattern is to use guard clauses. Guard clauses are a form of assertion which makes a tangible contribution to the logic of the method. By restructuring nested conditional statements to successive conditional exit points, the code becomes easier to understand and eases further refactoring efforts such as method extraction or clause reordering.

<pre class="brush:csharp">void SomeProcess()
{
    if( ... )
        return;

    if( ... )
        return;

    if( ... )
        return;

    if( ... )
        return;

    if( ... )
        return;

    // do something
}
</pre>

## Method Extraction

Another approach especially suited to blocks comprised of nested looping structures is the extraction of segments into separate methods. For each block forming the body of a loop statement, extract the body into a separate method which can then be examined independently of the containing loop statement:

Before

<pre class="brush:csharp">void SomeProcess()
    {
        while( ... )
        {
            while( ... )
            {
                while( ... )
                {
                    while( ... )
                    {
                    }
                }
            }
        }
    }
</pre>

After

<pre class="brush:csharp">void SomeProcess()
    {
        while( ... )
        {
            MethodA();
        }
    }

    void MethodA()
    {
        while( ... )
        {
            MethodB();
        }
    }

    void MethodB()
    {
        while( ... )
        {
            MethodC();
        }
    }

    void MethodC()
    {
        while( ... )
        {
            MethodD();
        }
    }
</pre>

## Logical And/Or

In cases where the nested structure is comprised solely of checks against the state of an object, the conditions can be extracted into a collection of Boolean methods and combined to form a more concise and readable guard clause:

<pre class="brush:csharp">void SomeProcess()
{
    if(ConditionA() &&
          ConditionB() &&
          ConditionC() &&
          (ConditionD1() || ConditionD2()) &&
          ConditionE())
    {
        // do something
    }
}
</pre>

## Composite Specification Chain

As a variant to the previous technique, the Specification pattern can be used in the form of a composite specification chain to render a concise and readable guard clause. Using this technique, specification classes are written to test each case, and the resulting set of specifications are composed into a single composite specification which can evaluate the state of the given object. Due to the encapsulation of the evaluation logic in the form of separate specification classes, this technique has the added benefit of enabling substitution of the specification implementation via the Strategy pattern for test isolation or other variable composition needs.

<pre class="brush:csharp">void SomeProcess()
{
    ISpecification&lt;SomeType&gt; specification = new IsConditionA()
        .And(new IsConditionB())
        .And(new IsConditionC())
        .And(new IsConditionD1().Or(IsConditionD2()))
        .And(new IsConditionE());

    specification.IsSatisfiedBy(this).Then(() =&gt; { /* do something */ });
}
</pre>

## Conclusion

The techniques presented here are a few approaches to helping achieve more readable and maintainable code by eliminating the arrow anti-pattern. Through the judicious application of these techniques, developers can in small ways leave their code base cleaner than they found it.
