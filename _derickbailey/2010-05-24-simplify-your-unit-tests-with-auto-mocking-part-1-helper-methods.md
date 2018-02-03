---
wordpress_id: 161
title: 'Simplify Your Unit Tests With Auto Mocking: Part 1 – Helper Methods'
date: 2010-05-24T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/05/24/simplify-your-unit-tests-with-auto-mocking-part-1-helper-methods.aspx
dsq_thread_id:
  - "262068698"
categories:
  - .NET
  - AutoMocking
  - Behavior Driven Development
  - 'C#'
  - Ninject
  - Refactoring
  - RhinoMocks
  - Unit Testing
---
After working on the [Ninject.RhinoMocks automocking container](http://www.lostechies.com/blogs/derickbailey/archive/2010/05/21/ninject-rhinomocks-auto-mocking-container-for-net-3-5-and-compact-framework-3-5.aspx), I started using it in my current project right away and it wasn’t long before I started simplifying the usage of it with helper methods in my base test class. 

&#160;

### From “MockingKernel.Get<T>()” To “Get<T>()”

I got tired of calling MockingKernel.Get<MyClass>() all over the place, so I created a helper method in my base ContextSpecification class called Get<T>(). This method does nothing more than forward calls to the MockingKernel.Get method, but it could easily be enhanced to do something more – like caching the object retrieved, so that the IoC container is not always resolving (even though it resolves to a singleton).

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">protected</span> T Get&lt;T&gt;()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">return</span> MockingKernel.Get&lt;T&gt;();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        This is a small change, but it makes a lot of code easier to ready. Compare this:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> [Test]</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_do_that_thing()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     MockingKernel.Get&lt;IMyView&gt;().AssertWasCalled(v =&gt; v.ThatThing());</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              To this:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> [Test]</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_do_that_thing()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>     Get&lt;IMyView&gt;().AssertWasCalled(v =&gt; v.ThatThing());</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    A small amount of code reduction and a little easier to read.
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    From “Get<IMyView>().AssertWasCalled(…)” to “AssertWasCalled<IMyView>(…)”
                  </h3>
                  
                  <p>
                    After adding the Get<T> code, I realized that I could simplify the assertion even further by creating a helper method that would call Get<T> for me. RhinoMocks has two methods for AssertWasCalled. The first just takes the method and sets some defaults, like only expecting 1 call. The second allows you to specify method options for more advanced needs. I created to AssertWasCalled<T> methods to mimic the RhinoMocks methods and call Get<T> for me:
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">protected</span> <span style="color: #0000ff">void</span> AssertWasCalled&lt;T&gt;(Action&lt;T&gt; action)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span>     T mock = Get&lt;T&gt;();</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span>     mock.AssertWasCalled(action);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   5:</span> }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   6:</span>     </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   7:</span> <span style="color: #0000ff">protected</span> <span style="color: #0000ff">void</span> AssertWasCalled&lt;T&gt;(Action&lt;T&gt; action, Action&lt;IMethodOptions&lt;<span style="color: #0000ff">object</span>&gt;&gt; methodOptions)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   8:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   9:</span>     T mock = Get&lt;T&gt;();</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  10:</span>     mock.AssertWasCalled(action, methodOptions);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  11:</span> }</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          This allowed me to simplify my specs down even further:
                        </p>
                        
                        <div>
                          <div>
                            <pre><span style="color: #606060">   1:</span> [Test]</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_do_that_thing()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   3:</span> {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   4:</span>     AssertWasCalled&lt;IMyView&gt;(v =&gt; v.ThatThing());</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   5:</span> }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   6:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   7:</span> [Test]</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   8:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_do_the_other_thing_twice()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   9:</span> {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  10:</span>     AssertWasCalled&lt;IMyView&gt;(v =&gt; v.TheOtherThing(), mo =&gt; mo.Repeat.Twice());</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  11:</span> }</pre>
                            
                            <p>
                              <!--CRLF--></div> </div> 
                              
                              <p>
                                This is less code to read and easier to understand.
                              </p>
                              
                              <p>
                                &#160;
                              </p>
                              
                              <h3>
                                A Full Spec Example
                              </h3>
                              
                              <p>
                                With these helper methods in place, a full specification is much easier to read, now:
                              </p>
                            </p></p> </p> 
                            
                            <div>
                              <div>
                                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> when_doing_something_with_that_thing : ContextSpecification</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">   2:</span> {</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">protected</span> MyPresenter SUT;</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">   4:</span>     </pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> EstablishContext()</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">   6:</span>     {</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">   7:</span>         SUT = Get&lt;MyPresenter&gt;();</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">   8:</span>     }</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">   9:</span>     </pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  10:</span>     <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> When()</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  11:</span>     {</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  12:</span>         SUT.DoSomething();</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  13:</span>     }</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  14:</span>     </pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  15:</span>     [Test]</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  16:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_do_that_thing()</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  17:</span>     {</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  18:</span>         AssertWasCalled&lt;IMyView&gt;(v =&gt; v.ThatThing());</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  19:</span>     }</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  20:</span>&#160; </pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  21:</span>     [Test]</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  22:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_do_the_other_thing_twice()</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  23:</span>     {</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  24:</span>         AssertWasCalled&lt;IMyView&gt;(v =&gt; v.TheOtherThing(), mo =&gt; mo.Repeat.Twice());</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  25:</span>     }</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #606060">  26:</span> }</pre>
                                
                                <p>
                                  <!--CRLF--></div> </div> 
                                  
                                  <p>
                                    &#160;
                                  </p>
                                  
                                  <h3>
                                    But Wait! There’s More!
                                  </h3>
                                  
                                  <p>
                                    It gets even better! In tomorrow’s blog post – part 2 of simplifying unit tests with automocking – I’ll reduce the full specification code even further by eliminating the need to declare and setup the System Under Test (SUT).
                                  </p>