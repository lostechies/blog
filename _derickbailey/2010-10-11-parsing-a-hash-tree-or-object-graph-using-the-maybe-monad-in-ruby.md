---
wordpress_id: 191
title: Parsing A Hash Tree (Or Object Graph) Using The Maybe Monad In Ruby
date: 2010-10-11T04:06:45+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/10/11/parsing-a-hash-tree-or-object-graph-using-the-maybe-monad-in-ruby.aspx
dsq_thread_id:
  - "265217740"
categories:
  - Monads
  - Ruby
redirect_from: "/blogs/derickbailey/archive/2010/10/11/parsing-a-hash-tree-or-object-graph-using-the-maybe-monad-in-ruby.aspx/"
---
I was playing around with [the maybe monad that I wrote in my last post](https://lostechies.com/blogs/derickbailey/archive/2010/10/09/the-maybe-monad-in-ruby.aspx), and it occurred to me that I might be able to parse out a object graph and grab a value from that graph with the monad. For example, look at this hash tree:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> stuff = { </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span>   :foo =&gt; {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     :bar =&gt; nil</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>   },</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>   :bar =&gt; {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     :baz =&gt; :whatever,</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>     :what =&gt; {:ever =&gt; nil }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>   }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        There’s nothing terribly special about this tree… it’s just a bunch of name / value pairs… leafs and branches. It’s a typical tree structure.
      </p>
      
      <p>
        What is interesting – to me at least – is the ugly code that I usually write to parse through a tree like this. It always involves a number of if-then statements that are nested inside of each other in order find the specific value or values that I’m looking for. What I wanted to do, instead, was see if I could use the maybe monad in a nested, structured manner to parse the tree and find the values that I want. The interesting thing is that the monad can only return one value… so I had to decide on how to approach this. I decided to return the first value I ran into. In this case, the :bar/:baz node has a value of :whatever, so that’s what it should return.
      </p>
      
      <p>
        Using the code blocks from the monad’s get method, I can nest additional maybe monads:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> stuff.to_maybe.get{|s| s[:foo].to_maybe.get{|f| f.bar }.value }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              Note that i have to return the .value of the nested monad, or it will end up wrapping a maybe type inside of a maybe type.
            </p>
            
            <p>
              Then, by using some well place || or operators, I can branch the parsing of the tree and either return the first value if one was found, or return the next value.
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> stuff.to_maybe.get{|s|</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span>   s[:foo].to_maybe.get{|f| f[:bar]}.value} ||</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>   s[:bar].to_maybe.get{|b| b[:baz]}.value}</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    This will either return the :foo/:bar value if a value is found, or it will return the :bar/:baz value if one is found.
                  </p>
                  
                  <p>
                    The final parsing structure to check all of the possible leaves for values, and return the first one that is found to have a value, looks like this:
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> result = stuff.to_maybe.get{ |s| </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span>   s[:foo].to_maybe.get{ |f| f[:bar] }.value ||</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span>   s[:bar].to_maybe.get{ |b| </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span>     b[:baz].to_maybe.get{ |z| z}.value ||</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   5:</span>     b[:what].to_maybe.get{ |w| w[:ever]}.value</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   6:</span>   }.value</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   7:</span> }.value || <span style="color: #006080">"nothing"</span></pre>
                      
                      <p>
                        <!--CRLF--></div> </div>
                      </p></p> 
                      
                      <p>
                        Of course, this isn’t limited to hash trees. You can easily parse object graphs in the same way. I just picked hash in this case because it’s a situation I’ve run into a lot. And honestly, this code is still a little difficult to read… it definitely needs some cleanup work. Overall, I think it’s a step in the right direction on improving the horrible if-then code that I’ve been writing around these types of tree structures, but I’m sure it can be done better.
                      </p>
                      
                      <p>
                        So, what can I do to make this code even cleaner and easier to understand? Or am I barking up the wrong tree on this, and need to find a different approach for a cleaner solution?
                      </p>