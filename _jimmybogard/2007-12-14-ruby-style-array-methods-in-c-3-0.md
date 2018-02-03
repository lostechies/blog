---
wordpress_id: 113
title: 'Ruby-style Array methods in C# 3.0'
date: 2007-12-14T21:12:06+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/12/14/ruby-style-array-methods-in-c-3-0.aspx
dsq_thread_id:
  - "264715462"
categories:
  - 'C#'
---
A while back I played with [Ruby-style loops in C# 3.0](http://grabbagoft.blogspot.com/2007/10/ruby-style-loops-in-c-30.html).&nbsp; This sparked my jealousy of other fun Ruby constructs that I couldn&#8217;t find in C#, and a couple of them&nbsp;are the &#8220;each&#8221; and &#8220;each\_with\_index&#8221; methods for arrays.&nbsp; Here&#8217;s an example, from [thinkvitamin.com](http://www.thinkvitamin.com/):

<pre>my_vitamins = ['b-12', 'c', 'riboflavin']

my_vitamins.each do |vitamin|
  puts "#{vitamin} is tasty!"
end
=&gt; b-12 is tasty!
=&gt; c is tasty!
=&gt; riboflavin is tasty!</pre>

With both Arrays and List<T> in .NET, this is already possible:&nbsp;

<div class="CodeFormatContainer">
  <pre><span class="kwrd">string</span>[] myVitamins = {<span class="str">"b-12"</span>, <span class="str">"c"</span>, <span class="str">"riboflavin"</span>};

Array.ForEach(myVitamins,
    (vitamin) =&gt;
    {
        Console.WriteLine(<span class="str">"{0} is tasty"</span>, vitamin);
    }
);

var myOtherVitamins = <span class="kwrd">new</span> List&lt;<span class="kwrd">string</span>&gt;() { <span class="str">"b-12"</span>, <span class="str">"c"</span>, <span class="str">"riboflavin"</span> };

myOtherVitamins.ForEach(
    (vitamin) =&gt;
    {
        Console.WriteLine(<span class="str">"{0} is very tasty"</span>, vitamin);
    }
);
</pre>
</div>

There are a few problems with these implementations, however:

  * Inconsistent between types 
      * IEnumerable<T> left out 
          * Array has a static method, whereas List<T> is instance 
              * Index is unknown</ul> 
            Since T[] implicitly implements IEnumerable<T>, we can create a simple extension method to handle any case.
            
            ### Without index
            
            I still like the &#8220;Do&#8221; keyword in Ruby to signify the start of a block, and I&#8217;m not a fan of the readability (or &#8220;solubility&#8221;, whatever) of the &#8220;ForEach&#8221; method.&nbsp; Instead, I&#8217;ll borrow from the loop-style syntax I created in the previous post&nbsp;that uses a &#8220;Do&#8221; method:
            
            <div class="CodeFormatContainer">
              <pre>myVitamins.Each().Do(
    (vitamin) =&gt;
    {
        Console.WriteLine(<span class="str">"{0} is tasty"</span>, vitamin);
    }
);
</pre>
            </div>
            
            To accomplish this, I&#8217;ll need something to add the &#8220;Each&#8221; method, and something to provide the &#8220;Do&#8221; method.&nbsp; Here&#8217;s what I came up with:
            
            <div class="CodeFormatContainer">
              <pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">class</span> RubyArrayExtensions
{
    <span class="kwrd">public</span> <span class="kwrd">class</span> EachIterator&lt;T&gt;
    {
        <span class="kwrd">private</span> <span class="kwrd">readonly</span> IEnumerable&lt;T&gt; values;

        <span class="kwrd">internal</span> EachIterator(IEnumerable&lt;T&gt; values)
        {
            <span class="kwrd">this</span>.values = values;
        }

        <span class="kwrd">public</span> <span class="kwrd">void</span> Do(Action&lt;T&gt; action)
        {
            <span class="kwrd">foreach</span> (var item <span class="kwrd">in</span> values)
            {
                action(item);
            }
        }
    }

    <span class="kwrd">public</span> <span class="kwrd">static</span> EachIterator&lt;T&gt; Each&lt;T&gt;(<span class="kwrd">this</span> IEnumerable&lt;T&gt; values)
    {
        <span class="kwrd">return</span> <span class="kwrd">new</span> EachIterator&lt;T&gt;(values);
    }
}
</pre>
            </div>
            
            The &#8220;Each&#8221; generic method is an extension method that extends anything that implements IEnumerable<T>, which includes arrays, List<T>, and many others.&nbsp; IEnumerable<T> is ripe for extension, as .NET 3.5 introduced dozens of extension methods for it in the System.Linq.Enumerable class.&nbsp; With these changes, I now have a consistent mechanism to perform an action against an array or list of items:
            
            <div class="CodeFormatContainer">
              <pre><span class="kwrd">string</span>[] myVitamins = { <span class="str">"b-12"</span>, <span class="str">"c"</span>, <span class="str">"riboflavin"</span> };

myVitamins.Each().Do(
    (vitamin) =&gt;
    {
        Console.WriteLine(<span class="str">"{0} is tasty"</span>, vitamin);
    }
);

var myOtherVitamins = <span class="kwrd">new</span> List&lt;<span class="kwrd">string</span>&gt;() { <span class="str">"b-12"</span>, <span class="str">"c"</span>, <span class="str">"riboflavin"</span> };

myOtherVitamins.Each().Do(
    (vitamin) =&gt;
    {
        Console.WriteLine(<span class="str">"{0} is very tasty"</span>, vitamin);
    }
);
</pre>
            </div>
            
            ### With index
            
            Ruby also has a &#8220;each\_with\_index&#8221; method for arrays, and in this case, there aren&#8217;t any existing methods on System.Array or List<T> to accomplish this.&nbsp; With extension methods, this is still trivial to accomplish.&nbsp; I now just include the index whenever executing the callback to the Action<T, int> passed in.&nbsp; Here&#8217;s the extension method with the index:
            
            <div class="CodeFormatContainer">
              <pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">class</span> RubyArrayExtensions
{
    <span class="kwrd">public</span> <span class="kwrd">class</span> EachWithIndexIterator&lt;T&gt;
    {
        <span class="kwrd">private</span> <span class="kwrd">readonly</span> IEnumerable&lt;T&gt; values;

        <span class="kwrd">internal</span> EachWithIndexIterator(IEnumerable&lt;T&gt; values)
        {
            <span class="kwrd">this</span>.values = values;
        }

        <span class="kwrd">public</span> <span class="kwrd">void</span> Do(Action&lt;T, <span class="kwrd">int</span>&gt; action)
        {
            <span class="kwrd">int</span> i = 0;
            <span class="kwrd">foreach</span> (var item <span class="kwrd">in</span> values)
            {
                action(item, i++);
            }
        }
    }

    <span class="kwrd">public</span> <span class="kwrd">static</span> EachWithIndexIterator&lt;T&gt; EachWithIndex&lt;T&gt;(<span class="kwrd">this</span> IEnumerable&lt;T&gt; values)
    {
        <span class="kwrd">return</span> <span class="kwrd">new</span> EachWithIndexIterator&lt;T&gt;(values);
    }
}
</pre>
            </div>
            
            The only difference here is I keep track of an index to send back to the delegate passed in from the client side, which now looks like this:
            
            <div class="CodeFormatContainer">
              <pre><span class="kwrd">string</span>[] myVitamins = { <span class="str">"b-12"</span>, <span class="str">"c"</span>, <span class="str">"riboflavin"</span> };

myVitamins.EachWithIndex().Do(
    (vitamin, index) =&gt;
    {
        Console.WriteLine(<span class="str">"{0} cheers for {1}!"</span>, index, vitamin);
    }
);

var myOtherVitamins = <span class="kwrd">new</span> List&lt;<span class="kwrd">string</span>&gt;() { <span class="str">"b-12"</span>, <span class="str">"c"</span>, <span class="str">"riboflavin"</span> };

myOtherVitamins.EachWithIndex().Do(
    (vitamin, index) =&gt;
    {
        Console.WriteLine(<span class="str">"{0} cheers for {1}!"</span>, index, vitamin);
    }
);
</pre>
            </div>
            
            This now outputs:
            
            <pre>0 cheers for b-12!
1 cheers for c!
2 cheers for riboflavin!
0 cheers for b-12!
1 cheers for c!
2 cheers for riboflavin!</pre>
            
            ### Pointless but fun
            
            I don&#8217;t think I&#8217;d ever introduce these into production code, as it&#8217;s never fun to drop new ways to loop on other&#8217;s laps.&nbsp; If anything, it shows how even parentheses can hinder readability, even if the method names themselves read better.
            
            In any case, I now have a simple, unified mechanism to perform an action against _any_ type that implements IEnumerable<T>, which includes arrays and List<T>.