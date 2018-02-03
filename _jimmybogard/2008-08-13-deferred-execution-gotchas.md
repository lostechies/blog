---
wordpress_id: 216
title: Deferred execution gotchas
date: 2008-08-13T12:08:35+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/08/13/deferred-execution-gotchas.aspx
dsq_thread_id:
  - "264715905"
categories:
  - 'C#'
  - LINQ
---
I was trying to be clever the other day and try to chain assertions on an array:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>This_does_not_work()
{
    <span style="color: blue">var </span>items = <span style="color: blue">new</span>[] {1, 2, 3, 4, 5};
    items
        .Each(x =&gt; x.ShouldBeLessThan(0))
        .Each(x =&gt; x.ShouldBeGreaterThan(10));
}
</pre>

[](http://11011.net/software/vspaste)

I did this by writing an Each extension method that I&#8217;ve seen in about a hundred different variations.&nbsp; However, mine was a _special_ implementation, and special as in it didn&#8217;t quite work as intended:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">IEnumerable</span>&lt;T&gt; Each&lt;T&gt;(<span style="color: blue">this </span><span style="color: #2b91af">IEnumerable</span>&lt;T&gt; items, <span style="color: #2b91af">Action</span>&lt;T&gt; action)
{
    <span style="color: blue">foreach </span>(<span style="color: blue">var </span>item <span style="color: blue">in </span>items)
    {
        action(item);
        <span style="color: blue">yield return </span>item;
    }
}
</pre>

[](http://11011.net/software/vspaste)

Clever, clever, I iterate over the items, performing the action for each item, and finally yielding the item back again (for further processing).&nbsp; To my surprise, the above test passed (when it should have failed).

After putting in some Debug.WriteLines, I found that none of the actions were ever executed.&nbsp; This is because of deferred execution.&nbsp; With deferred execution, the operations aren&#8217;t executed until you try and iterate over the results.

You can try and iterate over the results by doing a foreach, or calling another method that does something similar like ToArray().&nbsp; Here&#8217;s the modified test that fails as expected:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>This_fails_as_expected_but_quite_ugly()
{
    <span style="color: blue">var </span>items = <span style="color: blue">new</span>[] {1, 2, 3, 4, 5};
    items
        .Each(x =&gt; x.ShouldBeLessThan(0))
        .Each(x =&gt; x.ShouldBeGreaterThan(10))
        .ToArray();
}
</pre>

[](http://11011.net/software/vspaste)

It works, but now I have to call a ToArray method to force an iteration over the collection.&nbsp; Ugly, as it obscures the intent of the test with technical details of deferred execution.

I could bypass deferred execution by not using custom iterators:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">IEnumerable</span>&lt;T&gt; Each&lt;T&gt;(<span style="color: blue">this </span><span style="color: #2b91af">IEnumerable</span>&lt;T&gt; items, <span style="color: #2b91af">Action</span>&lt;T&gt; action)
{
    <span style="color: blue">foreach </span>(<span style="color: blue">var </span>item <span style="color: blue">in </span>items)
    {
        action(item);
    }

    <span style="color: blue">return </span>items;
}
</pre>

[](http://11011.net/software/vspaste)

This works just fine, with no need to get clever with a [custom iterator](http://flimflan.com/blog/ThePowerOfYieldReturn.aspx) (the yield return business).&nbsp; If I decided to get even more clever, and I wanted to keep the deferred execution for whatever reason, I can add yet another extension method:

<pre><span style="color: blue">public static void </span>Iterate&lt;T&gt;(<span style="color: blue">this </span><span style="color: #2b91af">IEnumerable</span>&lt;T&gt; items)
{
    <span style="color: blue">foreach </span>(<span style="color: blue">var </span>item <span style="color: blue">in </span>items)
    {
    }
}
</pre>

[](http://11011.net/software/vspaste)

And now I can be more explicit in my tests that I need to iterate the results:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>This_does_work_and_is_not_so_ugly()
{
    <span style="color: blue">var </span>items = <span style="color: blue">new</span>[] {1, 2, 3, 4, 5};
    items
        .Each(x =&gt; x.ShouldBeLessThan(0))
        .Each(x =&gt; x.ShouldBeGreaterThan(10))
        .Iterate();
}
</pre>

[](http://11011.net/software/vspaste)

This test fails as expected, without needing to do a ToArray call that obscures intent.

It turns out that I&#8217;m far more likely to do something like a map or reduce than just performing an action on a collection.&nbsp; I&#8217;m doing a lot more Func than Action in real-world code.&nbsp; Another example that clever is not always simple.