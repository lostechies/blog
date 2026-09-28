---
wordpress_id: 186
title: 'Monads in C#: Which Part Is The Monad?'
date: 2010-09-30T02:31:07+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/09/29/monads-in-c-which-part-is-the-monad.aspx
dsq_thread_id:
  - "262222485"
categories:
  - .NET
  - 'C#'
  - Monads
  - Principles and Patterns
redirect_from: "/blogs/derickbailey/archive/2010/09/29/monads-in-c-which-part-is-the-monad.aspx/"
---
In [my previous post on refactoring some code](https://lostechies.com/blogs/derickbailey/archive/2010/09/24/a-refactoring-explicit-modeling-and-reducing-duplication.aspx), several people responded in the comments and via twitter that I should look at the Maybe<T> monad as an option. Now, I have to be honest… the potty-humor-teenager in me wants to giggle a little every time I hear, read, or say “monad”… but I’m sure that’s old news at this point. I’ve heard a lot about these things and I’ve never really had a reason to understand them until now. At least, that’s what I thought… but once I started reading about them and how they can be applied in C#, I realized that I’ve probably been using them for a long time and didn’t know it. In fact, LINQ is pretty much a DSL around monads… granted, I’ve never used the LINQ DSL, but I use the extension methods that come with LINQ pretty regularly.

Given all that, I’ve been doing some r&d to learn how to implement my own monadic method chaining goodness, and I’ve come to a point where I’m not actually sure which parts of the code are the monads and which parts are implementation details that are side effects of doing this in C#. I’m hoping you, dear reader, can help me understand this. I’m writing this blog post as a learning tool for myself – not only to ask questions, but also to see what I can learn by solidifying my knowledge into a concrete form: this blog post. 

&#160;

### Implementing Maybe<T>

Based on several articles and blog posts that I’ve read, I decided to implement the canonical Maybe<T> example. This made sense because that’s what people suggested I look at, and it also seems to be a very popular example. What I came up with is the following Maybe<T> class:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">sealed</span> <span style="color: #0000ff">class</span> Maybe&lt;T&gt;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> Maybe&lt;T&gt; None = <span style="color: #0000ff">new</span> Maybe&lt;T&gt;(<span style="color: #0000ff">default</span>(T));</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">private</span> T <span style="color: #0000ff">value</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">public</span> T Value</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>         get</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>             <span style="color: #0000ff">return</span> <span style="color: #0000ff">value</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>         set { <span style="color: #0000ff">this</span>.<span style="color: #0000ff">value</span> = <span style="color: #0000ff">value</span>; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> HasValue</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span>         get</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span>             <span style="color: #0000ff">bool</span> hasValue = <span style="color: #0000ff">false</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  20:</span>             <span style="color: #0000ff">if</span> (Value != <span style="color: #0000ff">null</span> && !Value.Equals(<span style="color: #0000ff">default</span>(T)))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  21:</span>                 hasValue = <span style="color: #0000ff">true</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  22:</span>             <span style="color: #0000ff">return</span> hasValue;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  23:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  24:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  25:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  26:</span>     <span style="color: #0000ff">public</span> Maybe(T <span style="color: #0000ff">value</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  27:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  28:</span>         Value = <span style="color: #0000ff">value</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  29:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  30:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        This allows me to check whether I have a value or not, and get that value when I want to. (Note that I did not use the built in Nullable<T> from .NET because that class has a “where T: struct” clause on the generics type so I would not be able to use it on a Class type).
      </p>
      
      <p>
        Next, I implemented several extension methods that I found <a href="http://devtalk.net/csharp/chained-null-checks-and-the-maybe-monad/">via this article by Dmitri Nesteruk</a>.
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">class</span> MaybeExtensions</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> Maybe&lt;T&gt; ToMaybe&lt;T&gt;(<span style="color: #0000ff">this</span> T input)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> Maybe&lt;T&gt;(input);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> Maybe&lt;TResult&gt; Get&lt;TInput, TResult&gt;(<span style="color: #0000ff">this</span> Maybe&lt;TInput&gt; maybe, Func&lt;TInput, TResult&gt; func)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>         Maybe&lt;TResult&gt; result;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>         <span style="color: #0000ff">if</span> (maybe.HasValue)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>             result = <span style="color: #0000ff">new</span> Maybe&lt;TResult&gt;(func(maybe.Value));</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>         <span style="color: #0000ff">else</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span>             result = Maybe&lt;TResult&gt;.None;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  15:</span>         <span style="color: #0000ff">return</span> result;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  16:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  17:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  18:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> Maybe&lt;TInput&gt; If&lt;TInput&gt;(<span style="color: #0000ff">this</span> Maybe&lt;TInput&gt; maybe, Func&lt;TInput, <span style="color: #0000ff">bool</span>&gt; func)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  19:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  20:</span>         Maybe&lt;TInput&gt; result;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  21:</span>         <span style="color: #0000ff">if</span> (maybe.HasValue && func(maybe.Value))</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  22:</span>             result = maybe;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  23:</span>         <span style="color: #0000ff">else</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  24:</span>             result = Maybe&lt;TInput&gt;.None;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  25:</span>         <span style="color: #0000ff">return</span> result;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  26:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  27:</span>     </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  28:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> TResult Return&lt;TInput, TResult&gt;(<span style="color: #0000ff">this</span> Maybe&lt;TInput&gt; maybe, Func&lt;TInput, TResult&gt; func, TResult defaultValue)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  29:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  30:</span>         TResult result = defaultValue;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  31:</span>         <span style="color: #0000ff">if</span> (maybe.HasValue)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  32:</span>             result = func(maybe.Value);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  33:</span>         <span style="color: #0000ff">return</span> result;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  34:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  35:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              And lastly, I put together a sample that uses these methods:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> var foo = <span style="color: #0000ff">new</span> Foo();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span> var output = foo.ToMaybe()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>     .Get(SomeMethodToRetrieveABar)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>     .If(CheckSomethingComplexWithBarHere)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span>     .Get(r =&gt; r.Baz)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span>     .Return(z =&gt; z.Name, <span style="color: #006080">"nothing here. move along"</span>);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   8:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   9:</span> Console.WriteLine(output);</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    In this example, if any of the method calls or funcs returns a null, I will end up with “nothing here. move along” as the text written to my console. However, if none of them produces a null value, then I will end up retrieving the Baz.Name property from my object graph (which looks like: Foo, Foo.Bar, Bar.Baz, Baz.Name).
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    A Long, Confusing Definition Of Monad
                  </h3>
                  
                  <p>
                    Now that I have this in place, I find myself asking… which part of this is the actual monad? <a href="http://en.wikipedia.org/wiki/Monad_%28functional_programming%29">According to Wikipedia, a monad</a>:
                  </p>
                  
                  <blockquote>
                    <p>
                      <em>is a kind of abstract data type constructor used to represent computations (instead of data in the domain model). Monads allow the programmer to chain actions together to build a pipeline, in which each action is decorated with additional processing rules provided by the monad. Programs written in functional style can make use of monads to structure procedures that include sequenced operations, or to define arbitrary control flows (like handling concurrency, continuations, or exceptions). </em>
                    </p>
                    
                    <p>
                      <em>Formally, a monad is constructed by defining two operations (bind and return) and a type constructor M that must fulfill several properties to allow the correct composition of monadic functions (i.e. functions that use values from the monad as their arguments). The return operation takes a value from a plain type and puts it into a monadic container of type M. The bind operation performs the reverse process, extracting the original value from the container and passing it to the associated next function in the pipeline. </em>
                    </p>
                    
                    <p>
                      <em>A programmer will compose monadic functions to define a data-processing pipeline. The monad acts as a framework, as it&#8217;s a reusable behavior that decides the order in which the specific monadic functions in the pipeline are called, and manages all the undercover work required by the computation. The bind and return operators interleaved in the pipeline will be executed after each monadic function returns control, and will take care of the particular aspects handled by the monad.</em>
                    </p>
                  </blockquote>
                  
                  <p>
                    When I first read this, I got lost… very lost. So I started reading other articles by other developers. However, it wasn’t until I had actually implemented the Maybe<T> and a few other examples of what I think are monadic functions, that I started to understand what this text and those other articles are talking about. But I’m still not completely sure, here… so I want to pick out a few key parts of the above text and use them to analyze the code I wrote, hopefully identifying the actual monads in my sample code.
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    Return And Bind
                  </h3>
                  
                  <p>
                    When I first started reading the Maybe<T> examples, I thought it was the Maybe<T> class itself that was the monad. After all, the second paragraph in the above text talks about putting values into a container and extracting them, calling this Return and Bind, respectfully. In the case of Maybe<T>, that seems fairly obvious: I’m putting a value into the Maybe<T> class through the constructor, which should be the Return part, and then I’m extracting the value through the .Value property, which should be the Bind part. The problem I ran into is that the Dmitri Nesteruk article I linked to (where I got the extension methods) does not use a Maybe<T> class. This article uses the extension methods entirely, and yet it claims to be monads. I assume Dmitri knows what he is talking about and therefore my assumption of Maybe<T> being the monad is incorrect.
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    Monadic Functions
                  </h3>
                  
                  <p>
                    The third paragraph in the above text begins to give me a better picture, I think. “A programmer will compose monadic functions to define a data-processing pipeline.” Aha! Perhaps it is the actual extension methods that are the monads? Or at least, these are the monadic function that this paragraph refers to. But I don’t think that the extension methods are themselves the monad because the paragraph goes on to talk about the monad being a framework in which monadic functions are chained together. It also says the monad itself manages the order of execution. So then the monad isn’t the individual methods.
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    Are Monads In C# A Concept More Than A Construct?
                  </h3>
                  
                  <p>
                    I’m starting to get the feeling that a monad implemented in C# is more of a concept or aggregation of ideas and implementation detail, than an explicit construct. Given everything that the wikipedia article says, given all the examples I’ve looked at, and given the example that I show above, I think the actual monad is the aggregation of the extension methods, the Maybe<T> and calling them in the specific order that I have laid out in my code. Therefore, this sample code is the actual monad:
                  </p>
                </p>
                
                <div>
                  <div>
                    <pre><span style="color: #606060">   1:</span> var output = foo.ToMaybe()</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   2:</span>     .Get(SomeMethodToRetrieveABar)</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   3:</span>     .If(CheckSomethingComplexWithBarHere)</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   4:</span>     .Get(r =&gt; r.Baz)</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   5:</span>     .Return(z =&gt; z.Name, <span style="color: #006080">"nothing here. move along"</span>);</pre>
                    
                    <p>
                      <!--CRLF--></div> </div> 
                      
                      <p>
                        This code represents is the pipeline of monadic functions, put together in the specific order that they will be called, using the monadic extension methods that I created around the Maybe<T> type. Therefore, the concept of a monad is represented in this implementation detail.
                      </p>
                      
                      <p>
                        &#160;
                      </p>
                      
                      <h3>
                        Return And Bind, Again
                      </h3>
                      
                      <p>
                        If a monad in C# is more of a concept – more like a design pattern where the intention is critical in determining which specific pattern was used – then this would also reconcile my questioning of Dmitri’s article. It’s not the individual methods that are the monad – it’s the pipelined execution and examples that he gives that are the actual monad. In his article, for example, he shows this code:
                      </p>
                      
                      <div>
                        <div>
                          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">string</span> postCode = <span style="color: #0000ff">this</span>.With(x =&gt; person)</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   2:</span>     .If(x =&gt; HasMedicalRecord(x))]</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   3:</span>     .With(x =&gt; x.Address)</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   4:</span>     .Do(x =&gt; CheckAddress(x))</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   5:</span>     .With(x =&gt; x.PostCode)</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   6:</span>     .Return(x =&gt; x.ToString(), <span style="color: #006080">"UNKNOWN"</span>);</pre>
                          
                          <p>
                            <!--CRLF--></div> </div> 
                            
                            <p>
                              This is the monad, itself, just like my code right above it is the monad. In Dmitri’s example and methods, he is not using a generics class to Return and Bind as my example does. Rather, he is allowing the language to implicitly Return and Bind.
                            </p>
                            
                            <p>
                              When the With method is called in Dmitri’s code, this is implicitly the first Return of the monad; not because the With method itself is the Return, but because this is the first part of the monad and the value is being wrapped into a type that the monadic functions can understand. It just happens to be, in this case, that the monadic functions can take any type through the use of generics in C#. In my example code, the .ToMaybe() method is the explicit Return portion of the monad. I am explicitly wrapping the value in a type that my monadic extension methods can use.
                            </p>
                            
                            <p>
                              (<strong>Note:</strong> don’t confuse the “Return” method at the end of the pipeline with the “Return” concept of a monad. They aren’t the same. The Return method is just a poorly named method in this case, because it muddies the waters and makes it seem like this is the Return concept in the monad.)
                            </p>
                            
                            <p>
                              The Bind occurs every time a monadic function is called. In Dmitri’s code, Bind is again implicit. Because the generics type system in C# allows us to pass any type we want, we don’t have to explicitly Bind the value to the method calls. We can simply pass them along. In my example code, though, I am explicitly doing the Bind when I retrieve the .Value and pass it into the func delegate: func(maybe.Value). This is the Bind portion.
                            </p>
                            
                            <p>
                              After the Bind occurs, we once again Return the wrapped value. Again, Dmitri’s code does this implicitly with generics and I do it explicitly with my Maybe<T> class.
                            </p>
                            
                            <p>
                              &#160;
                            </p>
                            
                            <h3>
                              Will The Real Monad Please Stand Up?
                            </h3>
                            
                            <p>
                              How am I doing, here? How close am I? How far off? What detail am I missing? I’m still trying to get my head completely wrapped around all of this and I really want to some additional expert opinion weighed in on this. Please, please PLEASE let me know where I’ve gone wrong and what I need to do to correct my understanding! Everything I’ve said so far seems to make sense to me, so far. I hope it makes sense to the experts and to the people that are trying to learn this stuff, too.
                            </p>
                            
                            <p>
                              &#160;
                            </p>
                            
                            <h3>
                              Resources On Monads In .NET
                            </h3>
                            
                            <p>
                              Here’s the articles and blog posts that I’ve looked at, so far, that have helped me in my journey. Hopefully this will help others, as well.
                            </p>
                            
                            <ul>
                              <li>
                                <a title="http://weblogs.asp.net/podwysocki/archive/2008/10/13/functional-net-linq-or-language-integrated-monads.aspx" href="http://weblogs.asp.net/podwysocki/archive/2008/10/13/functional-net-linq-or-language-integrated-monads.aspx">http://weblogs.asp.net/podwysocki/archive/2008/10/13/functional-net-linq-or-language-integrated-monads.aspx</a>
                              </li>
                              <li>
                                <a title="http://murrayon.net/2010/09/maybe-from-murray-monads.html" href="http://murrayon.net/2010/09/maybe-from-murray-monads.html">http://murrayon.net/2010/09/maybe-from-murray-monads.html</a>
                              </li>
                              <li>
                                <a title="http://devtalk.net/csharp/chained-null-checks-and-the-maybe-monad/" href="http://devtalk.net/csharp/chained-null-checks-and-the-maybe-monad/">http://devtalk.net/csharp/chained-null-checks-and-the-maybe-monad/</a>
                              </li>
                              <li>
                                <a title="http://blogs.msdn.com/b/wesdyer/archive/2008/01/11/the-marvels-of-monads.aspx" href="http://blogs.msdn.com/b/wesdyer/archive/2008/01/11/the-marvels-of-monads.aspx">http://blogs.msdn.com/b/wesdyer/archive/2008/01/11/the-marvels-of-monads.aspx</a>
                              </li>
                            </ul>
                            
                            <p>
                              If anyone else has other great resources and links on Monads in .NET (especially monads in C#), please post them in the comments here or in your own blog with a link back to this post.
                            </p>