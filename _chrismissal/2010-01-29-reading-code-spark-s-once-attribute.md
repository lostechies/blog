---
id: 3374
title: Reading Code, Spark’s Once Attribute
date: 2010-01-29T02:39:00+00:00
author: Chris Missal
layout: post
guid: /blogs/chrismissal/archive/2010/01/28/reading-code-spark-s-once-attribute.aspx
dsq_thread_id:
  - "266466130"
categories:
  - ASP.NET MVC
  - Open Source
  - Reading Code
  - Spark
---
[<img style="border-right-width: 0px;margin: 0px 20px 0px 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="Spark-320" align="left" src="http://lostechies.com/chrismissal/files/2011/03/Spark320_thumb_0CE3D06E.png" width="240" height="90" />](http://lostechies.com/chrismissal/files/2011/03/Spark320_58AFA727.png)For those who don’t know what Spark is… Spark is an open source view engine for <a href="http://castleproject.org/monorail/" rel="nofollow">Castle’s MonoRail Project</a> (version 2.0 just recently released!) and <a href="http://www.asp.net/mvc/" rel="nofollow">ASP.NET MVC</a>. The creator of Spark, [Louis DeJardin](http://whereslou.com/), came up with the project in a comment left on a Phil Haack blog post amidst people complaining about the “tag soup” in the default view engine.

There’s a handy feature of Spark that allows you to specify a block of code that is only output one time to the overall view. This is especially nice when you have small partial files (similar to user controls if you prefer that term) that add some functionality that includes a JavaScript file. [The Spark ‘once’ attribute](http://sparkviewengine.com/documentation/expressions#Conditionalattributeonce) allows you to name an include that will only be rendered once per name.

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> &lt;script type=<span style="color: #006080">"text/javascript"</span> src=<span style="color: #006080">"jquery-lightbox.js"</span> once=<span style="color: #006080">"lightbox"</span>&gt;&lt;/script&gt;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> &lt;script type=<span style="color: #006080">"text/javascript"</span>&gt;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>   <span style="color: #008000">// ... do something</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span> &lt;/script&gt;</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        Later on, possibly in another partial, you might need this same functionality again. The second time around, you’re only going to render that script tag if it hasn’t yet been written out.
      </p>
      
      <p>
        This seemingly simple implementation in a view engine was interesting to me in that I was curious to find out how it was implemented. If it was easy, why wouldn’t something like this be in the default WebForms view engine?
      </p>
      
      <p>
        I thought I’d take a look by browsing through the Spark code…
      </p>
      
      <h2>
        How Spark Works
      </h2>
      
      <p>
        In very simple terms, the Spark view engine is a collection of TextWriters under a string parser; strings are read by the parser and turned into compiled code. Anytime you use a named content section, you’re essentially naming a TextWriter to which all that content under that name will be written. <em>(It really is a Dictionary of string keys for TextWriter values.)</em>
      </p>
      
      <p>
        When the view is parsed, Spark uses the <a href="http://en.wikipedia.org/wiki/Visitor_pattern" rel="nofollow">Visitor Pattern</a> to handle each node that is contained within the view. Below is the implementation of IsSpecialAttribute by the class <a href="http://github.com/loudej/spark/blob/master/src/Spark/Compiler/NodeVisitors/OnceAttributeVisitor.cs#LID14">OnceAttributeVisitor</a>. The visitor pattern is implemented in Spark in that there are different kinds of nodes that inherit from “Node”. Some of these classes need to tell their consumers whether or not they are “special”. Spark visits all nodes with 11 different Visitors, we’ll be looking at the OnceAttributeVisitor.
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">bool</span> IsSpecialAttribute(ElementNode element, AttributeNode attr)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">var</span> eltName = NameUtility.GetName(element.Name);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">if</span> (eltName == <span style="color: #006080">"test"</span> || eltName == <span style="color: #006080">"if"</span> || eltName == <span style="color: #006080">"elseif"</span> || eltName == <span style="color: #006080">"else"</span>)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>     <span style="color: #0000ff">if</span> (Context.Namespaces == NamespacesType.Unqualified)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>         <span style="color: #0000ff">return</span> attr.Name == <span style="color: #006080">"once"</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>     <span style="color: #0000ff">if</span> (attr.Namespace != Constants.Namespace)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>     <span style="color: #0000ff">var</span> nqName = NameUtility.GetName(attr.Name);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span>     <span style="color: #0000ff">return</span> nqName == <span style="color: #006080">"once"</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  15:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              After the code is parsed successfully, Spark will generate code from this translated view to be compiled. Any element that contains the ‘once’ attribute, like the script tag in the first code block, will create a call to a “Once()” function, passing in the value of the once attribute. (“lightbox” in our example above)
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">case</span> ConditionalType.Once:</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span>     {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>         CodeIndent(chunk)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>             .Write(<span style="color: #006080">"if (Once("</span>)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>             .WriteCode(chunk.Condition)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span>             .WriteLine(<span style="color: #006080">"))"</span>);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span>     }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    When that code is compiled, it’s turned into a derived type of <a href="http://github.com/loudej/spark/blob/master/src/Spark/SparkViewBase.cs#L91">SparkViewBase</a>, which, implements the Once method. The element that contains the ‘once’ attribute is only rendered if the Once method below returns true.
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> Once(<span style="color: #0000ff">object</span> flag)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">var</span> flagString = Convert.ToString(flag);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">if</span> (SparkViewContext.OnceTable.ContainsKey(flagString))</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   5:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   6:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   7:</span>     SparkViewContext.OnceTable.Add(flagString, <span style="color: #0000ff">null</span>);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   8:</span>     <span style="color: #0000ff">return</span> <span style="color: #0000ff">true</span>;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   9:</span> }</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          The underlying type of OnceTable is Dictionary<string, string>, basically, we’ll allow the output a string value if the string key hasn’t already been registered in the table. The first element that is added to the OnceTable “wins” and will be the only output for that given key of all the elements that contain the same value in their ‘once’ attribute. All subsequent occurrences with the same attribute value will be ignored.
                        </p>