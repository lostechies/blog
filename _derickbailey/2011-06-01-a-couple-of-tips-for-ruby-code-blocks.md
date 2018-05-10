---
wordpress_id: 377
title: A Couple Of Tips For Ruby Code Blocks
date: 2011-06-01T13:16:36+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=377
dsq_thread_id:
  - "319739744"
pygment_cache_hash_1:
  - f5257856
pygment_cache_1:
  - '<div class="pygment code"></div>'
pygment_cache_hash_0:
  - f5257856
pygment_cache_0:
  - '<div class="pygment code"></div>'
categories:
  - Ruby
---
Ruby&#8217;s code blocks (a.k.a &#8220;lambdas&#8221; or anonymous functions in .net) are powerful little tools that get used everywhere, and for good reason. But, every now and then I run into a little trick or issue related to them. For example:

 

### Variable Scoping

Earlier today, I ran into a scoping issue related to ruby code blocks. Can you spot the error here?

<pre class="brush:ruby">def get_scored_value(key, code)

  @tests.each do |test|
    next unless test

    result = test[code]
    if result
      value = result.value
      break
    end

  end

  value = "N/A" unless value
  ScoredValue.new(value, key)
end
</pre>

 

It wasn&#8217;t obvious to me, for about 30 minutes of banging my head into my keyboard&#8230; the \`value\` variable is scoped to the \`do&#8230;end\` code block because that&#8217;s the first place that it gets initialized. Since it was scoped to the code block, the \`value = &#8220;N/A&#8221; unless value\` line was always evaluating false and always setting value to &#8220;N/A&#8221;. This was an easy fix, of course. Just initialize the variable outside of the code block and the magic of closures will take over.

<pre class="brush:ruby">def get_scored_value(key, code)
  value = nil

  @tests.each do |test|
    next unless test

    result = test[code]
    if result
      value = result.value
      break
    end

  end

  value = "N/A" unless value
  ScoredValue.new(value, key)
end
</pre>

 

I need to go back and re-read the [Metaprogramming Ruby](http://pragprog.com/titles/ppmetr/metaprogramming-ruby) sections on scope gates and blocks. There&#8217;s obviously some stuff that I&#8217;ve not remembered since the last time I picked up that book.

 

### Code Blocks vs Hashes

This is one that [Hugo Bonacci](https://twitter.com/#!/hugoware) mentioned on twitter a few days ago. He had an issue related to code blocks vs hashes:

<img title="Screen shot 2011-06-01 at 1.55.03 PM.png" src="https://lostechies.com/content/derickbailey/uploads/2011/06/Screen-shot-2011-06-01-at-1.55.03-PM.png" border="0" alt="Screen shot 2011 06 01 at 1 55 03 PM" width="372" height="421" />

The reason why this happens had never occurred to me before, but I have run into this problem in the same way he did on many occasions: code blocks and hashes can both use the { } curly brace to denote their beginning and end.

<pre class="brush:ruby">some_data = { :foo =&gt; "bar", :baz =&gt; "widget"}

[1..3].each { |i| puts i }
</pre>

 

If you have a method that wants a hash as the parameter and you want to specify that hash in-line with the method call, the following will fail:

<pre class="brush:ruby">def something(foo)
  foo.each { |k, v| puts "#{k}: #{v}" }
end

something { :foo =&gt; "bar" }
</pre>

 

Ruby will interpret this as a code block even though the developer intends it to be a hash, and it will crash:

<pre>SyntaxError: (irb):4: syntax error, unexpected tASSOC, expecting '}'
something { :foo =&gt; "bar" }
</pre>

 

Fortunately, the solution is simple, again. You can either omit the curly braces or wrap the method call with parenthesis:

<pre class="brush:ruby">def something(foo)
  foo.each { |k, v| puts "#{k}: #{v}" }
end

something :foo =&gt; "bar"
something({:foo =&gt; "bar"})
</pre>

 

I prefer to eliminate the curly braces, just to reduce the syntax noise of the method call.

I&#8217;m sure there are other little gotcha&#8217;s related to code blocks, as well. These are two that I&#8217;ve come across recently, though.