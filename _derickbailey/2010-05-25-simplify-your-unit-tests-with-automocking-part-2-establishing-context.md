---
wordpress_id: 162
title: 'Simplify Your Unit Tests With Automocking: Part 2 &#8211; Establishing Context'
date: 2010-05-25T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/05/25/simplify-your-unit-tests-with-automocking-part-2-establishing-context.aspx
dsq_thread_id:
  - "262379475"
categories:
  - .NET
  - AutoMocking
  - Behavior Driven Development
  - 'C#'
  - Ninject
  - Refactoring
  - RhinoMocks
  - Unit Testing
redirect_from: "/blogs/derickbailey/archive/2010/05/25/simplify-your-unit-tests-with-automocking-part-2-establishing-context.aspx/"
---
Following my [helper methods in the base context specification](https://lostechies.com/blogs/derickbailey/archive/2010/05/24/simplify-your-unit-tests-with-auto-mocking-part-1-helper-methods.aspx) class that we use, I decided to simplify the entire process of setting the context in which the tests are running. Specifically, I wanted to get rid of the constant declaration and instantiation of the System Under Test (SUT) field – the class that is having it’s method called to ensure it behaves correctly.

&#160;

### A Base Context With SUT Setup

Instead of having to manually call out to the MockingKernel directly, to retrieve the system under test (SUT), like this:</p> 

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
    
    <pre><span style="color: #606060">  20:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        I added a generics version of the ContextSpecification class to our set of spec helpers. I took the EstablishContext method out of the above code and dropped it into a ContextSpecification<T>:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ContextSpecification&lt;T&gt;: ContextSpecification</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">protected</span> T SUT;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> EstablishContext()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>         SUT = MicroKernel.Get&lt;T&gt;();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              Now I can declare a spec without having to setup an EstablishContext method, if I don’t need one, and I don’t need to declare a protected SUT field:
            </p>
          </p></p> 
          
          <div>
            <div>
              <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> when_doing_something_with_that_thing : ContextSpecification&lt;MyPresenter&gt;</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   2:</span> {</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> When()</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   4:</span>     {</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   5:</span>         SUT.DoSomething();</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   6:</span>     }</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   7:</span>     </pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   8:</span>     [Test]</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   9:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_do_that_thing()</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">  10:</span>     {</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">  11:</span>         AssertWasCalled&lt;IMyView&gt;(v =&gt; v.ThatThing());</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">  12:</span>     }</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">  13:</span> }</pre>
              
              <p>
                <!--CRLF--></div> </div> 
                
                <p>
                  If I do need to set up additional code – stub methods, for example, I can still override the EstablishContext method. I just need to make sure I call to the base.EstablishContext so that I still get my SUT setup.
                </p>
                
                <div>
                  <div>
                    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> EstablishContext()</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   2:</span> {</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">base</span>.EstablishContext();</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   4:</span>     Get&lt;ISomeService&gt;().Stub(v =&gt; v.ThisThingIsCalled()).Return("some <span style="color: #0000ff">value</span>);</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   5:</span> }</pre>
                    
                    <p>
                      <!--CRLF--></div> </div> 
                      
                      <p>
                        &#160;
                      </p>
                      
                      <h3>
                        A Complete Example
                      </h3>
                      
                      <p>
                        The complete example that yesterday’s post ended with is even easier to read, now. I’ve eliminated another chunk of code and the test gets straight to the heart of what is happening – the behavior of the system.
                      </p>
                      
                      <div>
                        <div>
                          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> when_doing_something_with_that_thing : ContextSpecification&lt;MyPresenter&gt;</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   2:</span> {</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> When()</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   4:</span>     {</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   5:</span>         SUT.DoSomething();</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   6:</span>     }</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   7:</span>     </pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   8:</span>     [Test]</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   9:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_do_that_thing()</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  10:</span>     {</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  11:</span>         AssertWasCalled&lt;IMyView&gt;(v =&gt; v.ThatThing());</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  12:</span>     }</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  13:</span>&#160; </pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  14:</span>     [Test]</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  15:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_do_the_other_thing_twice()</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  16:</span>     {</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  17:</span>         AssertWasCalled&lt;IMyView&gt;(v =&gt; v.TheOtherThing(), mo =&gt; mo.Repeat.Twice());</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  18:</span>     }</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  19:</span> }</pre>
                          
                          <p>
                            <!--CRLF--></div> </div> 
                            
                            <p>
                              &#160;
                            </p>
                            
                            <h3>
                              Other Considerations
                            </h3>
                            
                            <p>
                              I’m obviously very happy with what I’ve been able to do with the <a href="https://lostechies.com/blogs/derickbailey/archive/2010/05/21/ninject-rhinomocks-auto-mocking-container-for-net-3-5-and-compact-framework-3-5.aspx">Ninject.RhinoMocks automocking container</a>. However, there is a potential danger in using an auto mocking container. Stay tuned for tomorrow’s post to find out more about that danger and how you can help your team avoid it.
                            </p>