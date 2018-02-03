---
wordpress_id: 43
title: Constrained generic extension methods
date: 2007-07-20T20:30:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/07/20/constrained-generic-extension-methods.aspx
dsq_thread_id:
  - "273988065"
categories:
  - 'C#'
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/07/constrained-generic-extension-methods.html)._

When I first saw extension methods, a new feature in C# 3.0, I was a bit skeptical.&nbsp; It seemed like yet another language feature shoehorned in to support LINQ.&nbsp; After going a few rounds with the technology, it actually looks quite promising.&nbsp; For a full explanation of extension methods and what scenarios they can enable, check out [Scott Guthrie&#8217;s](http://weblogs.asp.net/scottgu/) [post on the subject](http://weblogs.asp.net/scottgu/archive/2007/03/13/new-orcas-language-feature-extension-methods.aspx).

#### Making the extension method generic

First, let&#8217;s examine the original example from Scott&#8217;s post, which adds an &#8220;In&#8221; method to test whether an item is in a collection:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">bool</span> In(<span class="kwrd">this</span> <span class="kwrd">object</span> o, IEnumerable items)
{
    <span class="kwrd">foreach</span> (<span class="kwrd">object</span> item <span class="kwrd">in</span> items)
    {
        <span class="kwrd">if</span> (item.Equals(o))
            <span class="kwrd">return</span> <span class="kwrd">true</span>;
    }

    <span class="kwrd">return</span> <span class="kwrd">false</span>;
}</pre>
</div>

The &#8220;In&#8221; method will be added to all objects, including&nbsp;primitive value types such as&nbsp;&#8220;int&#8221; and&nbsp;&#8220;double&#8221;.&nbsp; Here&#8217;s a sample snippet using &#8220;int&#8221;:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">int</span>[] values = {5, 6, 10};

<span class="kwrd">bool</span> isInArray = 7.In(values);</pre>
</div>

The value &#8220;isInArray&#8221; evaluates to &#8220;false&#8221;, as the number 7 isn&#8217;t in the array.&nbsp; So what&#8217;s wrong with this code?&nbsp; The problem is that the &#8220;In&#8221; method uses the type &#8220;object&#8221; to extend types, but that will cause boxing when the number 7 is [boxed to an object](http://www.codersource.net/csharp_boxing_unboxing.html) for the extension method call.&nbsp; Generics can prevent boxing from occurring, so let&#8217;s change the extension method to be generic:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">bool</span> In&lt;T&gt;(<span class="kwrd">this</span> T o, IEnumerable&lt;T&gt; items)
{
    <span class="kwrd">foreach</span> (T item <span class="kwrd">in</span> items)
    {
        <span class="kwrd">if</span> (item.Equals(o))
            <span class="kwrd">return</span> <span class="kwrd">true</span>;
    }

    <span class="kwrd">return</span> <span class="kwrd">false</span>;
}</pre>
</div>

Now when I call &#8220;In&#8221;,&nbsp;the method will use &#8220;int&#8221; instead of &#8220;object&#8221;,&nbsp;and no boxing will occur.&nbsp; Additionally, since I used&nbsp;the generic&nbsp;IEnumerable<T> type, I will get&nbsp;some additional compile-time validation, so I won&#8217;t be able to do things like this:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">string</span>[] values = {<span class="str">"5"</span>, <span class="str">"6"</span>, <span class="str">"10"</span>};

<span class="kwrd">bool</span> isInArray = 7.In(values); <span class="rem">// Compile time error!</span></pre>
</div>

I can now lean on the compiler to do some type checking for me.&nbsp; What about some more interesting scenarios, where I want to extend some complex types?

#### Adding constraints to a generic extension method

I&#8217;d like to add some complex comparison operators to certain types, say something like &#8220;IsLessThanOrEqualTo&#8221;.&nbsp; I&#8217;d like to extend types that implement both IComparable<T> _and_ IEquatable<T>.&nbsp; That is, the extension method should only show up for types that implement both interfaces.&nbsp; I can&#8217;t declare both types with the &#8220;this&#8221; modifier parameter.&nbsp; How can I accomplish this?&nbsp; The trick is to make the method generic, and add constraints:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">bool</span> IsLessThanOrEqualTo&lt;T&gt;(<span class="kwrd">this</span> T lValue, T <span class="kwrd">value</span>)
    <span class="kwrd">where</span> T : IComparable&lt;T&gt;, IEquatable&lt;T&gt;
{
    <span class="kwrd">return</span> lValue.CompareTo(<span class="kwrd">value</span>) &lt; 0 || lValue.Equals(<span class="kwrd">value</span>);
}</pre>
</div>

This&nbsp;extension method&nbsp;lets me write code such as:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">int</span> x = 5;
<span class="kwrd">int</span> y = 10;

<span class="kwrd">bool</span> isLte = x.IsLessThanOrEqualTo(y);
Assert.IsTrue(isLte);</pre>
</div>

This gives me a few advantages:

  * The available constraints are the same as any other generic type or method (struct, class, new(), <base class>, <interface>, and naked type constraints) 
      * Using multiple constraints lets me constrain the method to types that fulfill **all** the constraints, such as the two interfaces in the above example 
          * The signature of type T inside the generic method combines the members of&nbsp;**all** of the constraints. 
              * All of the methods of IComparable<T> and IEquatable<T> are available to me in the above example.
              * **The IDE filters the constraints in IntelliSense, and I won&#8217;t even see&nbsp;extension methods whose constraints&nbsp;my variable doesn&#8217;t fulfill**</ul> 
            What this allows me to do in real world situations is to target specific scenarios by filtering through constraints.&nbsp; Instead of using only 1 type in the &#8220;this&#8221; parameter, I can target objects that derive from a certain class, implement several interfaces, etc.&nbsp; By making the class generic, interactions with the method will be strongly typed and will avoid boxing conversions and unnecessary casting.
            
            To see the constraints fail, what happens when we try to call the IsLessThanOrEqualTo with a class that only _partially_ fulfills the constraints?&nbsp; Here&#8217;s the bare-bones class:
            
            <div class="CodeFormatContainer">
              <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Account : IComparable&lt;Account&gt;
{
    <span class="kwrd">public</span> <span class="kwrd">int</span> CompareTo(Account other)
    {
        <span class="kwrd">return</span> 0;
    }
}</pre>
            </div>
            
            I try to compile the following code:
            
            <div class="CodeFormatContainer">
              <pre>Account account = <span class="kwrd">new</span> Account();
Account other = <span class="kwrd">new</span> Account();

account.IsLessThanOrEqualTo(other); <span class="rem">// Compile time error!</span></pre>
            </div>
            
            It won&#8217;t compile, since Account only implements IComparable<T>, and not IEquatable<T>.&nbsp; This wouldn&#8217;t happen while authoring the code, as IntelliSense doesn&#8217;t even show the IsLessThanOrEqualTo method.
            
            I should note that if I don&#8217;t constrain the generic extension method, any instance of any type will have the method available for use, which may or may not be desirable.
            
            #### Conclusion
            
            Generic types and methods can be very helpful in eliminating boxing and unboxing as well as casting that clutters up the code.&nbsp; Extension methods allow me to add functionality to types that I may not have access to changing.&nbsp; By combining generic, constrained methods and extension methods, I get the power of extension methods with the flexibility of generic methods.