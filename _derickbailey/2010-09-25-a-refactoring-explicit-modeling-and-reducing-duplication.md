---
wordpress_id: 185
title: 'A Refactoring: Explicit Modeling And Reducing Duplication'
date: 2010-09-25T00:52:18+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/09/24/a-refactoring-explicit-modeling-and-reducing-duplication.aspx
dsq_thread_id:
  - "264727987"
categories:
  - .NET
  - 'C#'
  - Principles and Patterns
  - Refactoring
redirect_from: "/blogs/derickbailey/archive/2010/09/24/a-refactoring-explicit-modeling-and-reducing-duplication.aspx/"
---
A coworker showed me a method that had a series of guard clauses at the top and a series of sequential steps that had to be processed after that. All of the guard clauses and sequential steps were executed the same way – call a method, get the result, check the result status, return if errors have occurred. 

Here’s a mock-up of what the original code he showed me looked like:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> Result DoStuff(Something something, Whatever whatever, WhoCares whocares, DoesntMatter doesntMatter)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     Result result;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>     </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">if</span> ((result = GuardClause1(something) != <span style="color: #0000ff">null</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>         <span style="color: #0000ff">return</span> result;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>         </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>     <span style="color: #0000ff">if</span> ((result = GuardClause2(whatever) != <span style="color: #0000ff">null</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>         <span style="color: #0000ff">return</span> result;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>     </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>     <span style="color: #0000ff">if</span> ((result = Step1(whoCares) != <span style="color: #0000ff">null</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>         <span style="color: #0000ff">return</span> result;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>     result = Step2(doesntMatter);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>     </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>     <span style="color: #0000ff">return</span> result;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        He had me looking at the code so that I could make suggestions on how to improve. He already recognized the code as being less-than-ideal, but wanted to see what my reactions and suggestions were. I had several reactions when I saw it:
      </p>
      
      <ul>
        <li>
          Implicit modeling of error status with nulls is a bad idea
        </li>
        <li>
          Too much duplication of code
        </li>
        <li>
          Too many return statements. Try to get this down to 1 return (though I generally make exceptions for guard clauses)
        </li>
        <li>
          Overall, difficult to read, understand and really know what is happening
        </li>
      </ul>
      
      <p>
        I’ve covered most of these items before, and I don’t want to repeat the same information. However, I will link back to the places where I’ve talked about them. What I really want to do is walk through the process of refactoring the code from the original example above, into an example that takes advantage of .Net’s delegates to provide code that is much more declarative in nature, and much easier to understand and work with.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        Implicit vs Explicit Modeling
      </h3>
      
      <p>
        I’ve already talked about <a href="http://www.lostechies.com/blogs/derickbailey/archive/2010/03/17/application-events-modeling-selection-vs-de-selection-as-separate-events.aspx">explicitly modeling</a> in your code, so I <a href="http://www.lostechies.com/blogs/derickbailey/archive/2010/04/28/dry-violations-may-indicate-a-missed-modeling-opportunity.aspx">won’t repeat all of that</a>, here. You can go read those previous posts for my general opinion on the subject (which is to say, you should explicitly model your state instead of using nulls). In this particular instance, I suggested using a .Status on the Result class to indicate whether or not the step completed successfully or not.
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> Result DoStuff(Something something, Whatever whatever, WhoCares whocares, DoesntMatter doesntMatter)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     Result result;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>     result = GuardClause1(something);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">if</span> (result.Status == ResultStatus.Error)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>         <span style="color: #0000ff">return</span> result;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>         </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>     result = GuardClause2(whatever);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>     <span style="color: #0000ff">if</span> (result.Status == ResultStatus.Error)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>         <span style="color: #0000ff">return</span> result;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>     </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>     result = Step1(whoCares);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span>     <span style="color: #0000ff">if</span> (result.Status == ResultStatus.Error)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  15:</span>         <span style="color: #0000ff">return</span> result;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  16:</span>         </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  17:</span>     result = Step2(doesntMatter);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  18:</span>     </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  19:</span>     <span style="color: #0000ff">return</span> result;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  20:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              This is a pretty simple change, but it has the adverse affect of creating more code duplication: the if statement checking the status is now the same after each call.
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              Reducing Duplication
            </h3>
            
            <p>
              I’ve also talked about <a href="http://www.lostechies.com/blogs/derickbailey/archive/2010/03/05/how-ruby-taught-me-to-dry-up-my-code-with-lambda-blocks.aspx">the use of Delegates to help reduce code duplication</a> before. In this particular case, original code used the same if-then statement, with the exception of the value that was assigned to ‘result’. The first refactoring shows us that the if-then statement actually is the same one, over and over again. The only thing that we need to vary is the method that is executed to obtain the result. With .Net’s delegates – in particular, the Func<T> delegate &#8211; we can easily do that. However, there is a small gotcha to this. If we extracted the code into a method that takes a single Func<Result> as the parameter, then we don’t gain anything. We won’t actually reduce the duplication. In fact, this would only make the code worse:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> Result DoStuff(Something something, Whatever whatever, WhoCares whocares, DoesntMatter doesntMatter)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>     Result result;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>     </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>     result = ProcessStep(() =&gt; GuardClause1(something));</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">if</span> (result.Status == ResultStatus.Error)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span>         <span style="color: #0000ff">return</span> result;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   8:</span>         </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   9:</span>     <span style="color: #008000">// ... other steps here</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  10:</span>         </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  11:</span>     <span style="color: #0000ff">return</span> result;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  12:</span> }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  13:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  14:</span> <span style="color: #0000ff">public</span> Result ProcessStep(Func&lt;Result&gt; step)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  15:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  16:</span>     <span style="color: #0000ff">return</span> step();    </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  17:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    Since the DoStuff method has to return the result if there was an error, we still need the if-then statement checking the status. This only served to move the execution of the step into the ProcessStep method, without providing any reduction in the code duplication. To correct this, we can send in a params array of Func<Step> and loop through them, executing and verifying the result, one step at a time.
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> Result ProcessSteps(param func&lt;Result&gt;[] steps)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span>     Result result = <span style="color: #0000ff">null</span>;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">foreach</span>(step <span style="color: #0000ff">in</span> steps)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   5:</span>     {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   6:</span>         result = step();</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   7:</span>         <span style="color: #0000ff">if</span> (result.Status == ResultStatus.Error)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   8:</span>             <span style="color: #0000ff">return</span> result;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   9:</span>     }    </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  10:</span>     <span style="color: #0000ff">return</span> result;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  11:</span> }</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          In this code, we loop through the steps and execute each of them. If any of them encounters an error, we immediately return the result. If none of the steps that we executed errors, we return the final result received from the final step. With this method in place, we can now compose our original method with the guard clauses and the individual steps, like this:
                        </p>
                        
                        <div>
                          <div>
                            <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> Result DoStuff(Something something, Whatever whatever, WhoCares whocares, DoesntMatter doesntMatter)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   2:</span> {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">return</span> ProcessSteps(</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   4:</span>         () =&gt; GuardClause1(something),</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   5:</span>         () =&gt; GuardClause2(whatever),</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   6:</span>         () =&gt; Step1(whoCares),</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   7:</span>         () =&gt; Step2(doesntMatter)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   8:</span>     );</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   9:</span> }</pre>
                            
                            <p>
                              <!--CRLF--></div> </div> 
                              
                              <p>
                                &#160;
                              </p>
                              
                              <h3>
                                Too Many Return Statements
                              </h3>
                              
                              <p>
                                I’m not sure that I’ve ever talked about this particular standard. I strongly believe in limiting the number of exit points (return statements or otherwise) that a method can have. The closer you can get to 1 exit point, the better. The reason for this is to ensure that the code is easier to work with and easier to understand. Having a series of return statements like the original example shows creates a number of potential problems – well, ok… this example is actually pretty easy to understand since the code is so clean. However, I have had to work with methods that container multiple nested if-then statements and loops, with many different exit points in the mix. It becomes very difficult to work with and to know exactly what will be returned, when. On top of that, it’s a very procedural way of working.
                              </p>
                              
                              <p>
                                At this point the code in the Reducing Duplication section is fairly well organized with only 2 exit points. I would not be opposed to this code if it comes down to the choice of readable and understandable code vs. a single exit point. To reduce the exit points in this example, we can take advantage of the break keyword. This allows us to exit the loop that we are in, immediately. The final version of the ProcessSteps method looks like this:
                              </p>
                              
                              <div>
                                <div>
                                  <pre><span style="color: #606060">   1:</span> Result ProcessSteps(param func&lt;Result&gt;[] steps)</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   2:</span> {</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   3:</span>     Result result = <span style="color: #0000ff">null</span>;</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">foreach</span>(step <span style="color: #0000ff">in</span> steps)</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   5:</span>     {</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   6:</span>         result = step();</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   7:</span>         <span style="color: #0000ff">if</span> (result.Status == ResultStatus.Error)</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   8:</span>             <span style="color: #0000ff">break</span>;</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   9:</span>     }    </pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  10:</span>     <span style="color: #0000ff">return</span> result;</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  11:</span> }</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  12:</span>&#160; </pre>
                                  
                                  <p>
                                    <!--CRLF--></div> </div> 
                                    
                                    <p>
                                      &#160;
                                    </p>
                                    
                                    <h3>
                                      Readability and Understandability
                                    </h3>
                                    
                                    <p>
                                      I said that my original reaction to the code included concerns about being able to read and understand the code. It was difficult to see everything that was going on and it was hard to understand why the null checks were in place without talking to the developer that wrote the code. Throughout the process of refactoring this code, though, we continuously made steps to improve the readability and understandability. The end result created a code base that lets use easily extend the functionality by adding additional steps in the DoStuff method, while leaving the process of executing and verifying the results to the ProcessSteps method. Now if we need to change either of those concerns, we can do so without having the repeat the change and without affecting the other concern. We can compose the process with our individual steps and leave the infrastructure of executing them as an implementation detail that can change independently (to a certain extent, of course).
                                    </p>
                                    
                                    <p>
                                      &#160;
                                    </p>
                                  </p></p> </p> 
                                  
                                  <h3>
                                    One Example, One Lesson…
                                  </h3>
                                  
                                  <p>
                                    Remember that this only one example of one specific scenario where these specific refactorings are the right ones to use. Every situation must be evaluated for it’s own needs. There’s not doubt that the usefulness of these specific refactorings will vary with every situation that you run into. However, understanding how to move code from a procedural, difficult to understand and work into a state where it is easy to understand and easy to see what is happening, is very valuable. Hopefully you will be able to take a few points away from this example and be able to apply some new ideas to your specific contexts.
                                  </p>
                                  
                                  <p>
                                    If you only learn one thing from this post, though, it should be that refactoring code to a clean structure is a step by step process. If I had shown the unit tests around the DoStuff method, then I would have been able to prove that the functionality of this method did not deteriorate at any point during our changes. We methodically changed one element of the internal code structure, one after another, until we ended with a solution that still passed all tests and provided a much better code base to work with.
                                  </p>