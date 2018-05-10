---
wordpress_id: 190
title: The Maybe Monad In Ruby
date: 2010-10-10T01:41:59+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/10/09/the-maybe-monad-in-ruby.aspx
dsq_thread_id:
  - "263258991"
categories:
  - Monads
  - Principles and Patterns
  - Ruby
redirect_from: "/blogs/derickbailey/archive/2010/10/09/the-maybe-monad-in-ruby.aspx/"
---
{% raw %}
Just for fun, I decided to see what a monad would look like in ruby. I chose to use the Maybe monad since that’s what I used in [my previous post on monads in C#](https://lostechies.com/blogs/derickbailey/archive/2010/09/29/monads-in-c-which-part-is-the-monad.aspx). Here’s what I came up with:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">class</span> Maybe</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span>   attr_accessor :value</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>   def initialize(value)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     <span style="color: #cc6633">@value</span> = value</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>   end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>   def get</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>     <span style="color: #0000ff">if</span> @value.nil?</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>       nil.to_maybe</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>     <span style="color: #0000ff">else</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>       yield(@value).to_maybe unless @value.nil?</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>     end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>   end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span> end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span> <span style="color: #0000ff">class</span> Object</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>   def to_maybe</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span>     Maybe.<span style="color: #0000ff">new</span> self</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  20:</span>   end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  21:</span> end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  22:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  23:</span> <span style="color: #0000ff">class</span> Foo</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  24:</span>   attr_accessor :bar</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  25:</span> end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  26:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  27:</span> <span style="color: #0000ff">class</span> Bar</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  28:</span>   attr_accessor :baz</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  29:</span> end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  30:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  31:</span> foo1 = Foo.<span style="color: #0000ff">new</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  32:</span> foo1.bar = Bar.<span style="color: #0000ff">new</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  33:</span> foo1.bar.baz = <span style="color: #006080">"something"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  34:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  35:</span> foo2 = Foo.<span style="color: #0000ff">new</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  36:</span> foo2.bar = nil</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  37:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  38:</span> result1 = foo1.to_maybe</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  39:</span>   .get{|f| f.bar}</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  40:</span>   .get{|b| b.baz}</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  41:</span>   .value || <span style="color: #006080">"nothing"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  42:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  43:</span> result2 = foo2.to_maybe</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  44:</span>   .get{|f| f.bar}</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  45:</span>   .get{|b| b.baz}</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  46:</span>   .value || <span style="color: #006080">"nothing"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  47:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  48:</span> puts <span style="color: #006080">"#{result1}"</span> #=&gt; something</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  49:</span> puts <span style="color: #006080">"#{result2}"</span> #=&gt; nothing</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        I find this code to be much easier to read and understand than the C# version even though the C# version makes a few of the monad formulae a little more apparent. For example, the binding function formula of (M t) –> (t –> M u) –> (M u) is fairly apparent when you look at a C# method signature like this:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> Maybe&lt;TResult&gt; Get&lt;TInput, TResult&gt;(Maybe&lt;TInput&gt; maybe, Func&lt;TInput, TResult&gt; func) { ... }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              In the ruby version, you don’t have the type declarations or the return value declaration, which gives us a little less of an immediate understanding that we are dealing with a monad. However, the tradeoff for this is that you get to keep your code very simple and you get to keep all of the binding functions for a given monad in the monads wrapper class. I’ve only implemented a get binding method, but you should be able to translate the other methods from the C# code fairly easily, using this example.
            </p>
            
            <p>
              One thing I did not need to implement in the ruby version was a return method with a default value as a parameter. Remember in the C# version how we wanted to either return the value stored in the monad wrapper or some default value is the monad wrapper did not container one? Well, it turns out the || operator in ruby gives us this functionality without having to create a special to do that. On line 41 when I call .value || “nothing”, this is the equivalent of calling the .Return(someDefault) method in the C# version.
            </p>
            
            <p>
              I suppose it’s not strictly necessary to add the .to_maybe method to the Object class, though. We could create a module to mix in to a specific object that we want, or we could just use the Maybe.new initializer… I put this method in there to make the final method chaining closer to the C# code that I started with. Perhaps that’s not such a wise idea, but I don’t know if it’s a bad idea or not… it works and it makes it easy to work with a maybe monad.
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              Handling Nil In Chained Calls: For <a href="http://twitter.com/bennage">@bennage</a>
            </h3>
            
            <p>
              In the process of implementing and testing this, I remembered a conversation that I had with Christopher Bennage about a month and a half ago (no, my memory of the date isn’t that good… i have the IM logs, still 🙂 ) where he was asking about a way to not throw exceptions when a nil is encountered in a chained call, in ruby. He wanted to write code like this:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> foo = bar.baz.widget.weeble.wobble</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    and have the code execute without error, even if baz or widget or any other part of the chain was nil. We discussed several options at the time, one of which involved a lot of nested blocks:
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> def check(foo)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span>   yield(foo) unless foo.nil?</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span> end</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   5:</span> check(myvar){|x| check(x.y){|y| y.z }}</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          This works, but it’s a bit ugly to read and difficult to understand with all the nested blocks – especially when you get more than 2 or 3 items deep.
                        </p>
                        
                        <p>
                          I also came up with a horrible, horrible way of using method_missing on the nil class to get it done… but it wasn’t a good solution. If you’d like to see what it was that I came up with, <a href="http://gist.github.com/535559">it’s available on this gist</a>. Please, please, PLEASE do NOT use this code… it’s awful.
                        </p>
                        
                        <p>
                          I think the maybe monad is what he was looking for, in the end. It’s not chained call syntax of “foo.bar.baz…”, but it gets the job done in a fairly elegant manner.
                        </p>
                        
                        <p>
                          &#160;
                        </p>
                        
                        <h3>
                          Is There A More Idiomatic Way To Do Monads In Ruby?
                        </h3>
                        
                        <p>
                          I haven’t actually done any searches for monads in ruby, yet. I wrote this code and this blog post “blind”, to see what I could come up with out of my own head. I’m wondering, though… is there a more idiomatic ruby way to do monads? I think I’ve incorporated a good number of ruby idioms already – especially the use of the || operator and the use of the implicit code blocks – but I’m thinking there may be more that I’m just not aware of.
                        </p>
{% endraw %}
