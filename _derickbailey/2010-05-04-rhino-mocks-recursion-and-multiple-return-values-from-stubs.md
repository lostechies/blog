---
wordpress_id: 152
title: 'Rhino Mocks: Recursion And Multiple Return Values From Stubs'
date: 2010-05-04T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/05/04/rhino-mocks-recursion-and-multiple-return-values-from-stubs.aspx
dsq_thread_id:
  - "262065466"
categories:
  - .NET
  - Analysis and Design
  - AppController
  - Behavior Driven Development
  - 'C#'
  - Tools and Vendors
  - Unit Testing
redirect_from: "/blogs/derickbailey/archive/2010/05/04/rhino-mocks-recursion-and-multiple-return-values-from-stubs.aspx/"
---
A coworker and I were recently working on some recursive code in a WinForms app that followed these basic steps: 

  1. Show a form
  2. If the return status was a certain value, show another form
  3. If the return status from the 2nd form was a certain value, repeat from Step 1

This creates a nice little recursion that allows a user to flip back and forth between two forms (a “Launch” view and a “Login” view). Here’s a simplified version of the code that we wrote:</p> 

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> ShowLaunchView()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     var result = AppController.RequestReply&lt;ShowLaunchView, LaunchViewResult&gt;();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">if</span> (result.Status == LaunchStatus.LoginRequested)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>       ShowLoginView();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     <span style="color: #008000">//handle other status values here</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> ShowLoginView()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>     var result = AppController.RequestReply&lt;ShowLoginView, LoginViewResult&gt;();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>     <span style="color: #0000ff">if</span> (result.Status == LoginStatus.Cancelled)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>       ShowLaunchView();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>     <span style="color: #008000">//handle other status values here</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        For those that are unfamiliar with my <a href="http://www.lostechies.com/blogs/derickbailey/archive/2009/12/22/understanding-the-application-controller-through-object-messaging-patterns.aspx">application controller</a>, you can read more about that and the associated <a href="http://www.lostechies.com/blogs/derickbailey/archive/2010/04/15/adding-request-reply-to-the-application-controller.aspx">RequestReply</a> method in previous posts.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        Multiple Return Values From A Rhino Mocks Stub
      </h3>
      
      <p>
        In order to test the logic of this process correctly, we need to have the first form return a result of Ok and the the second form return a result of Ok, then the when the first form is shown again, it must return a result other than Ok. If we continue returning Ok over and over and over again, we’ll end up in an infinite loop and our test will crash.
      </p>
      
      <p>
        To do this, we can use the the .Repeat statements in Rhino Mocks, to tell our stub how many times to return what value. Rhino Mocks will pay attention to the .Repeat calls and set up the stub to return the specified values, in the specified order, that many times. For example:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> var myObject = MockRepository.GenerateMock&lt;ISomeObject&gt;();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> myObject.Stub(m =&gt; m.DoSomething()).Return(someValue).Repeat.Once();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span> myObject.Stub(m =&gt; m.DoSomething()).Return(anotherValue);</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              This code will set up the first call to myObject.DoSomething() so that it returns someValue. The second call will then return anotherValue. All calls after that will return the default value for the return type from the method. It’s important to note that if you do not specify the number of times to repeat for the first stub, then the second stub will simply overwrite the first one. The .Repeat.Once() call tells rhino mocks to create a sequence of stubs in the order that they are created.
            </p>
            
            <p>
              Rhino mocks lets you string .Repeat calls together as many times as you need to, as well:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> var myObject = MockRepository.GenerateMock&lt;ISomeObject&gt;();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> myObject.Stub(m =&gt; m.DoSomething()).Return(someValue).Repeat.Once();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span> myObject.Stub(m =&gt; m.DoSomething()).Return(anotherValue).Repeat.Twice();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span> myObject.Stub(m =&gt; m.DoSomething()).Return(thirdValue).Repeat.Once();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span> myObject.Stub(m =&gt; m.DoSomething()).Return(fourthValue).Repeat.Times(5);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span> myObject.Stub(m =&gt; m.DoSomething()).Return(lastValue);</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    This example would set up myObject for 10 calls. Ok, that may be a little extreme, but it illustrates the point. 🙂
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    Stubbing The Recursive Calls
                  </h3>
                  
                  <p>
                    Using the .Repeat syntax to set up the number of calls we expect, a simple unit test for the ShowLaunchView and ShowLoginView code may look like this:
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> [Test]</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> when_cancelling_a_login_should_show_the_launch_view()</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span>     var appController = MockRepository.GenerateMock&lt;IApplicationController&gt;();</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   5:</span>     </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   6:</span>     <span style="color: #008000">//setup the two launch view calls that we expect</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   7:</span>     appController.Stub(ac =&gt; ac.RequestReply&lt;ShowLaunchView, LaunchViewResult())</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   8:</span>         .Return(<span style="color: #0000ff">new</span> LaunchViewResult(LaunchStatus.LoginRequested)).Repeat.Once();</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   9:</span>     appController.Stub(ac =&gt; ac.RequestReply&lt;ShowLaunchView, LaunchViewResult())</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  10:</span>         .Return(<span style="color: #0000ff">new</span> LaunchViewResult(LaunchStatus.Exit));</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  11:</span>         </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  12:</span>     <span style="color: #008000">//setup the one call to the login view we expect</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  13:</span>     appController.Stub(ac =&gt; ac.RequestReply&lt;ShowLoginView, LoginViewResult&gt;())</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  14:</span>         .Return(<span style="color: #0000ff">new</span> LoginViewResult(LoginStatus.Cancelled));</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  15:</span>         </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  16:</span>     var SUT = <span style="color: #0000ff">new</span> ApplicationStartupWorkflow(appController);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  17:</span>     SUT.ShowLaunchView();</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  18:</span> }</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          Here is what happens in this test:
                        </p>
                        
                        <ol>
                          <li>
                            App controller is told to show the launch view and return a launch view result. The first stub for the launch view call returns a result with a status of LoginRequested
                          </li>
                          <li>
                            The conditional statement checks for LoginRequeted, finds it, and calls ShowLoginView
                          </li>
                          <li>
                            App controller is told to show the login view and return a login view result. The only stub for the login view call returns a result with a status of Cancelled
                          </li>
                          <li>
                            The conditional statement checks for Cancelled, finds it and calls ShowLaunchView
                          </li>
                          <li>
                            App controller is told to show the launch view again and return another launch view result. This time, the second stub for the launch view call is used because the first one has already repeated for the number of times that we specified. The second stub returns a status of Exit which does not match the conditional, therefore the method exits and our test completes.
                          </li>
                        </ol>
                        
                        <p>
                          &#160;
                        </p>
                        
                        <h3>
                          Much Nicer Than What I’ve Previously Done
                        </h3>
                        
                        <p>
                          This may be old news to those who have been using Rhino Mocks forever (… so what’s my excuse? I’ve been using RM for 3+ years now…) but it was a small learning moment for my coworker and I, last week. I’m happy to have learned this so that I can stop writing manual stubs for sequential return value needs. It is easier to maintain the rhino mocks generated stubs and keeps the test code cleaner, in my opinion.
                        </p>