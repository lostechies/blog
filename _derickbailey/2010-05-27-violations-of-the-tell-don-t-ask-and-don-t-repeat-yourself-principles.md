---
wordpress_id: 164
title: Violations Of The “Tell, Don’t Ask” and “Don’t Repeat Yourself” Principles?
date: 2010-05-27T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/05/27/violations-of-the-tell-don-t-ask-and-don-t-repeat-yourself-principles.aspx
dsq_thread_id:
  - "266523870"
categories:
  - .NET
  - Analysis and Design
  - AntiPatterns
  - 'C#'
  - Principles and Patterns
redirect_from: "/blogs/derickbailey/archive/2010/05/27/violations-of-the-tell-don-t-ask-and-don-t-repeat-yourself-principles.aspx/"
---
In the last few years, I’ve written a lot of code that looks like this:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> IsThisATellDontAskViolation</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> DoBadThings()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>   {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">if</span> (something.CanHandle(anotherThing))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>       var response = something.GetThatFromIt(anotherThing);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>       DoSomethingWithTheResponse(response);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>     <span style="color: #0000ff">else</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>       DoSomethingElse();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>   }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        Look at lines 5 and 7, specifically. In this code, I’ve got a call being made to a dependency to check whether or not the dependency can handle whatever it is I want to send to it. If the dependency can handle it, I call another method on the same object, passing in the same parameter and expecting to be given a result of the processing.
      </p>
      
      <p>
        This code bothers me, honestly, but I find myself constantly writing it. It appears to me, to be a violation of both the <a href="http://www.pragprog.com/articles/tell-dont-ask">Tell, Don’t Ask</a> and <a href="http://en.wikipedia.org/wiki/Don%27t_repeat_yourself">Don’t Repeat Yourself</a> (DRY) principles. I don’t like how the class questions the dependency and then has it do something based on the response. This seems like a violation of Tell, Don’t Ask and is clearly falling back to simple procedural programming techniques. Then, having the same “anotherThing” variable passed into another method on the same dependency object seems like its violating DRY. Why should I have to pass the same thing to the same object twice?
      </p>
      
      <p>
        Another example of this type of code can be found in my <a href="http://github.com/derickbailey/presentations-and-training/tree/master/SOLID%20Principles%20-%20Step%20By%20Step%20Code/">SOLID Principles presentation and sample code</a>. In the <a href="http://en.wikipedia.org/wiki/Open/closed_principle">Open Closed Principle</a>, I create the following code:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> GetMessageBody(<span style="color: #0000ff">string</span> fileContents)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>   <span style="color: #0000ff">string</span> messageBody = <span style="color: #0000ff">string</span>.Empty;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>   <span style="color: #0000ff">foreach</span>(IFileFormatReader formatReader <span style="color: #0000ff">in</span> _formatReaders)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>   {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">if</span> (formatReader.CanHandle(fileContents))</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>       messageBody = formatReader.GetMessageBody(fileContents);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>   }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>   <span style="color: #0000ff">return</span> messageBody;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              You can clearly see the same pattern with the CanHandle method on like 6 and the GetMessageBody method on line 8. For the same reasons, this code bothers me. It always has, but I’ve never done anything to correct it.
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              Is This A Violation Of Tell, Don’t Ask And/Or DRY?
            </h3>
            
            <p>
              Ultimately, that’s what I’m asking… are these code samples violating those principles? … and Why or Why Not? I would love to hear your opinion in the comments here or as your own blog post.
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              One Possible Solution
            </h3>
            
            <p>
              Assuming that this is a violation of those principles (and I’m all ears, listening for reasons why it is or is not), I have one solution that I’ve used a number of times for a similar scenario. Rather than having a method to check if the dependency can handle the data sent to it, just have one method that either processes the data or doesn’t, but tells you whether or not it did through the returned object.
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Response&lt;T&gt;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> RequestWasHandled { get; <span style="color: #0000ff">private</span> set; }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>   <span style="color: #0000ff">public</span> T Data {get; <span style="color: #0000ff">private</span> set;}</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>   <span style="color: #0000ff">public</span> Response(<span style="color: #0000ff">bool</span> requestWasHandled, T data)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span>   {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span>     RequestWasHandled = requestWasHandled;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   8:</span>     Data = data;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   9:</span>   }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  10:</span> }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  11:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  12:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> TellDontAskCorrection</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  13:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  14:</span>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> DoGoodThings()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  15:</span>   {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  16:</span>     var response = something.GetThatFromIt(anotherThing);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  17:</span>     <span style="color: #0000ff">if</span> (response.RequestWasHandled)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  18:</span>       DoSomethingWithTheResponse(response.Data);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  19:</span>     <span style="color: #0000ff">else</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  20:</span>       DoSomethingElse();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  21:</span>   }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  22:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    This works. I’ve used it a number of times in a number of different scenarios and it has helped clean up some ugly code in some places. There is still an if-then statement in the DoGoodThings method but that may not be avoidable and may not be an issue since the method calls in the two if-then parts are very different. I don’t think this is <em>the</em> solution to the problems, though. It’s only one possible solution that works in a few specific contexts.
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    Looking For Other Solutions
                  </h3>
                  
                  <p>
                    What are some of the patterns, practices and modeling techniques that you are using to prevent Tell, Don’t Ask and DRY violations? Not just for the scenario that I’ve shown here, but for any given scenario where you find yourself wanting to introduce procedural logic that should be encapsulated into the object being called. I would love to see examples of the code you are dealing with and the solutions to that scenario. Please share – here in the comments (please use Pastie or Github Gist or something else that formats the code nicely if you have more than a couple lines of code, though) or in your own blog, etc.
                  </p>