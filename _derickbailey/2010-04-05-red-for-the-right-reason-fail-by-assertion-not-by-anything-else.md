---
id: 132
title: 'Red For The Right Reason: Fail By Assertion, Not By Anything Else'
date: 2010-04-05T12:16:00+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/04/05/red-for-the-right-reason-fail-by-assertion-not-by-anything-else.aspx
dsq_thread_id:
  - "262068578"
categories:
  - .NET
  - 'C#'
  - Principles and Patterns
  - Test Automation
  - Unit Testing
---
[Thomas Weller](http://www.thomas-weller.de/) commented on my [Red/Green/Refactor For The Right Reasons](http://www.lostechies.com/blogs/derickbailey/archive/2010/03/25/red-green-refactor-for-the-right-reasons.aspx) post and asked me to explain why I don’t think a throwing a NotImplementedException is a good reason for a test to be red. It’s a good question, one that I questioned for a long time, and something that is worth talking about on it’s own rather than just replying in the original comment stream. To get things started, here is Thomas’ comment:

> _Hi Derick,_
> 
> _"A “Throw NotImplementedException();” is never the right reason" for a test to be red !? I&#8217;m not sure I&#8217;m buying that. I don&#8217;t exactly understand the problem with that approach._
> 
> _Having a test being red because of a NotImplementedException tells me that my test set up is right and the test fails only because the method under test is not yet implemented &#8211; and that&#8217;s exactly what I want. The effect is the same that you get when hard-coding a return value, only that you don&#8217;t depend on a specific value and you get the code for free with R#. -&#160; Or, in your words: If the test fails because of a NotImplementedException, it is red for the right reasons (at least in my eyes&#8230;)._
> 
> _I use this approach regularly in TDD and I made very good experiences with it &#8211; especially because with a NotImplementedException a test will NEVER become green for the wrong reasons, and therefore there will be no danger that it is overlooked in the (sometimes hectic) production process._
> 
> _This is no religion, of course. But I don&#8217;t really get your arguments at this point (while I&#8217;m totally d&#8217;accord with the rest of your post). Maybe you could clarify a bit more on that&#8230;_
> 
> _Regards_
> 
> _Thomas_

&#160;

### The Underlying Principle: Fail By Assertion, Not By Anything Else

The underlying principle behind why a NotImplementedException is never the right reason to fail is that it does not let an assertion fail the test. A test must be able to fail because an assertion caused it to fail, and for no other reason. We must prove that the test fails because the assertion did not find the expected values or interactions, or we do not know that the test can fail for the right reasons. Any other reason for failure is an abnormal condition that tells us we have something wrong with our code.

&#160;

### Test For Your Needs, Not The Framework’s Functionality

Throwing a NotImplementedException as the red part of your red/green/refactor is doing nothing more than proving that the .NET framework can throw exceptions and that your testing framework can fail a test when an exception is thrown. 

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> [Test]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Test_Foo()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>   var result = Foo();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>   Assert.AreEqual(60, result);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">int</span> Foo()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>   <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> NotImplementedException();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        This test doesn’t fail for the right reason because it does let the assertion fail the test. It does not show that an abnormal condition exists between our expectations and the implementation other than to say that the method has not yet been implemented. It is only proving that an exception will fail the test, which is not something we need test. The unit tests that the testing framework was written with will prove that a test can fail when an exception is caught.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        A Simple State Based Test
      </h3>
      
      <p>
        In this test, we are asking an object to do some work which results in it’s own state being modified.
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> [Test]</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> A_State_Test()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>   var myObj = <span style="color: #0000ff">new</span> MyObject();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>   myObj.DoSomething();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>   Assert.AreEqual(60, myObj.SomeState);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              If the DoSomething method throws a NotImplementedException, we know that we have not yet implemented it but we do not know that the test can fail because the assertion failed. If we don’t let the assert fail because the value of myObj.SomeState is not what we expected, then we can have no confidence that this test will fail for the right reasons.
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              A Simple Interaction Test
            </h3>
            
            <p>
              In this test, we are asking an object to do some work and then expecting that it will interact with another object via an interface. The assertion is made against the interaction by checking to see if the correct method was called on the interface.
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> [Test]</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> An_Interaction_Test()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>   var anotherObject = MockRepository.CreateMock&lt;IAmThatThing&gt;();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>   var myObject = <span style="color: #0000ff">new</span> MyObject(anotherObject);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span>   myObj.DoSomething();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span>   anotherObject.AssertWasCalled(ao =&gt; ao.ThatThing());</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   8:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    If the DoSomething method throws a NotImplementedException here, the method called ThatThing() on the IAmThatThing interface may not be called, but we don’t actually know that it was not called. We are not proving that the method is not called and that the assertion can fail the test. Rather, we are only proving that an exception can fail the test.
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    Complex Test Scenarios
                  </h3>
                  
                  <p>
                    f the object being tested has a private method and let put a NotImplementedException into that private method, we have not proven that the method being called is not yet implemented. In fact, we have no certainty of which method in the object is not implemented until we look at the stack trace that is produced by the exception being thrown. If, on the other hand, the private method is expected to return a specific value under the specific circumstances that were set up by the public method being called from the test then we can return a value that is known to be incorrect and the assertion will fail for the right reason.
                  </p>
                  
                  <p>
                    If we are dealing with a more complex set of dependencies and interactions then the NotImplementedException becomes more and more of an obstruction to the tests for every assertion that we have. Having an exception will fail the test when we have 5 asserts against interactions means that we have 5 tests that are failing for an invalid reason.
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    False Positives, False Negatives
                  </h3>
                  
                  <p>
                    A false positive exists when a test passes for the wrong reasons, and a false negative exists when a test fails for the wrong reasons. Thomas said this about false positives in his comment:
                  </p>
                  
                  <blockquote>
                    <p>
                      <em>because with a NotImplementedException a test will NEVER become green for the wrong reasons, and therefore there will be no danger that it is overlooked in the (sometimes hectic) production process.</em>
                    </p>
                  </blockquote>
                  
                  <p>
                    He is right about that, no doubt. A NotImplementedException certainly will prevent false positives while it is in place, but there are two problems that I see with this statement:
                  </p>
                  
                  <ol>
                    <li>
                      You are introducing false negatives, which are just as dangerous as false positives. Since the test is failing because of an exception and not because an assertion found an abnormality, the test failure is a false negative
                    </li>
                    <li>
                      You have not prevented false positives, only postponed them. Once the NotImplementedException is removed, the code is open to the possibility of false positives
                    </li>
                  </ol>
                  
                  <p>
                    We must be diligent about preventing false positives and false negatives, both, not just false positives.
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    When To Test For Exceptions
                  </h3>
                  
                  <p>
                    There are times when it’s important to do both positive and negative testing around exceptions… when your code throws them. This example shows that we expect a process to not throw any exceptions under one condition, and we expect it to throw an exception under another condition.
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> [Test]</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Dont_Throw_Exceptions()</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span>   var myObject = <span style="color: #0000ff">new</span> MyObject();</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   5:</span>   Exception caughtException = <span style="color: #0000ff">null</span>;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   6:</span>   <span style="color: #0000ff">try</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   7:</span>   {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   8:</span>     myObject.DoSomething(withThisCondition);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   9:</span>   }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  10:</span>   <span style="color: #0000ff">catch</span>(Exception ex)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  11:</span>   {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  12:</span>     caughtException = ex;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  13:</span>   }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  14:</span>   Assert.IsNull(caughtException);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  15:</span> }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  16:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  17:</span> [Test]</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  18:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Throw_Exceptions()</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  19:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  20:</span>   var myObject = <span style="color: #0000ff">new</span> MyObject();</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  21:</span>   Exception caughtException = <span style="color: #0000ff">null</span>;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  22:</span>   <span style="color: #0000ff">try</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  23:</span>   {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  24:</span>     myObject.DoSomething(basedOnAnotherCondition);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  25:</span>   }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  26:</span>   <span style="color: #0000ff">catch</span>(Exception ex)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  27:</span>   {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  28:</span>     caughtException = ex;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  29:</span>   }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  30:</span>   Assert.IsNotNull(caughtException);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  31:</span> }</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          These tests are valid because they will fail is the assertion fails (and yes I know about the various attributes that can be put on the tests to expect/not expect an exception. This is an example of the principle, not the implementation detail)
                        </p>
                        
                        <p>
                          &#160;
                        </p>
                        
                        <h3>
                          When To Use NotImplementedException
                        </h3>
                        
                        <p>
                          I’m not saying that you shouldn’t use not implemented exceptions at all, or that I never use them. I actually do use them on occasion, but for a very specific purpose: to remind myself that I have not yet implemented the method in question. I find it very convenient to do this when I’m about to leave my workstation or change my current train of thought to something else for a while. Having the NotImplementedException in place will be a big red flag to tell me that I was not yet done when I was interrupted and went on to do something else. When I do this, though, I am specifically stating that the method is not yet implemented and that I need to re-engage myself in the context of the code and the tests to figure out where I left off and continue. It’s not a sign that my test fails for the right reason, it’s a sign that I left in the middle of something that needs to be completed.
                        </p>
                        
                        <p>
                          &#160;
                        </p>
                        
                        <h3>
                          Thanks Thomas!
                        </h3>
                        
                        <p>
                          I’d like to say thanks for questioning this. In the process of of thinking about this and writing it up, I had to dig deep into the principles and beliefs that I hold for test-first development. My first draft of this response contained a bunch of extraneous nonsense that had nothing to do with the real issue, then around 75% of the way through this that I had the “aha!” moment and wrote down the underlying principle of fail by assertion, not anything else. From that revelation, I was able to cut the nonsense and unrelated content and solidify my own understanding of why I don’t think a NotImplementedException is red for the right reason.
                        </p>
                        
                        <p>
                          Thanks, Thomas. Without your questions and comments I may not have had this little revelation.
                        </p>