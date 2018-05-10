---
wordpress_id: 117
title: A Response Concerning Semantics And Intention Revealing Code
date: 2010-03-19T18:16:57+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/03/19/a-response-concerning-semantics-and-intention-revealing-code.aspx
dsq_thread_id:
  - "265573778"
categories:
  - .NET
  - 'C#'
  - Craftsmanship
  - Design Patterns
  - Principles and Patterns
  - Quality
redirect_from: "/blogs/derickbailey/archive/2010/03/19/a-response-concerning-semantics-and-intention-revealing-code.aspx/"
---
[My previous post](https://lostechies.com/blogs/derickbailey/archive/2010/03/17/application-events-modeling-selection-vs-de-selection-as-separate-events.aspx) talked about some code that was using a null value to cause certain behavior. The general idea behind the post was questioning how I should go about remodeling that part of my code so that it would be more explicit. One of the comments questioned why I would want to change what I have and event stated that using null is the right thing to do for various reasons. It’s probably apparent that I don’t agree with that. Rather than just dismissing the comments or carrying on a very lengthy conversation in the comments about the assumptions that I was making in that post, I thought it would be better to address those assumptions in a separate post… so, here goes.

Specifically, the comment left by Diego says: 

> “_Passing null back to the listener of the event is better approach. It&#8217;s safe in the language, it&#8217;s semantics really means "nothing", it&#8217;s easy&#160; to check, it&#8217;s lightweight (costs an clean IntPtr)._ 
> 
> _Why would you think the user HAS to know something which he might not know. I think is way more straight to work with null&#160; than with empty object (null pattern).”_

I wand to address various parts of this comment individually. Each of the following sections represents a part of Diego’s comment and my response to it.

&#160;

### The Semantics Of Null

Diego is right about the semantics of null. It really does mean that nothing is there. It’s not an empty value or a blank. It really does mean that it doesn’t exist… think of Rock Biter’s [explanation of The Nothing](http://www.imdb.com/title/tt0088323/quotes?qt0283382) from [The Never Ending Story](http://en.wikipedia.org/wiki/The_NeverEnding_Story_%28film%29).&#160; The real question is not whether we understand the semantics of null, though. The real question is whether we are expressing the intentions of and identifying the semantics for the process and behavior that we are modeling. Take a look at this code sample. It represents the basic idea behind the original post, using a null value, but has the detail of what is being done taken out:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Handle(ProductCodeSelected productCodeSelected)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>   <span style="color: #0000ff">if</span> (productCodeSelected.ProductCode == <span style="color: #0000ff">null</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>   {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     <span style="color: #008000">// do something here, based on the product code being null</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>   }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>   <span style="color: #0000ff">else</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>   {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>     <span style="color: #008000">// do something here, based on the product code not being null</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>   }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        Now, given the semantics of null, what should the code in each of these sections do?
      </p>
      
      <p>
        If you asked me this question, I’d have to start asking a lot of questions about the event that was being raised. Why is the product code coming back as null? What does that really signify in this case? Does that mean the user didn’t want a product code selected? If so, do we need to do something special for the case where the user specifically opts for not having a product code? Or does that mean the selection was cleared, and we’re waiting for a new product code to be selected? Or does this mean that the product code selected was invalid or some reason, or not found in the database perhaps due to concurrency issues or some other reason?
      </p>
      
      <p>
        Now imagine having a hundred or a thousand null reference checks in your system. Each one of these checks will require the person reading the code to ask a series of questions surrounding the null reference check, specific to the situation at hand. That means that you now need to read, learn and remember hundreds or thousands of additional details so that you can easily switch your brain back into the context of each null reference check, when reading one. Good luck with that.
      </p>
      
      <p>
        Now compare that this these two code snippets, which represent option #1 and option #2 from the previous post:
      </p>
      
      <p>
        <strong>Option #1: A Single “Changed” Event</strong>
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Handle(ProductCodeChanged productCodeChanged)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>   <span style="color: #0000ff">if</span> (productCodeChanged.ChangeReason == ReasonForChange.Selected)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>   {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>     <span style="color: #008000">// do something here, based on the product code being selected</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>   }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>   <span style="color: #0000ff">else</span> <span style="color: #0000ff">if</span> (productCodeChanged.ChangeReason == ReasonForChange.DeSelected)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>   {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>     <span style="color: #008000">// do something here, based on the product code being de-selected</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>   }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              <strong>Option #2: Separate Events</strong>
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Handle(ProductCodeSelected productCodeSelected)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>   <span style="color: #008000">//do something here, based on the product code being selected</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span> }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Handle(ProductCodeDeSelected productCodeDeSelected)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   8:</span>   <span style="color: #008000">//do something here, based on the product code being selected</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   9:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    In both of these cases, the code has become significantly more intention revealing. The developer that is writing this code may still have to ask the initial questions about product code being not selected vs. being de-selected and waiting for a new selection, but any other developer that needs to come along and read this code will not have to ask those questions anymore. Both of these examples provide a very clear understanding of what has happened. The semantics between “Selected” and “DeSelected” in either case provide a level of understanding that a null reference check simply cannot provide when reading this code.
                  </p>
                  
                  <p>
                    Now imagine having a hundred or a thousand places in the code where the check is modeled using the language and semantics of the process in question, like either of these examples. The person reading the code doesn’t have to remember every last specific detail of the process in question because the code reveals the intentions through semantics and language. You’ll have to know more about the process and the business needs than you will have to know about the code structure and implementation. This will make it much easier for a person to read and understand the code, assuming that the person has a working knowledge of the business or process in question (and if you don’t have that… well, you’re in trouble in either case.)
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    Language Safety And The Null Object Pattern
                  </h3>
                  
                  <p>
                    Diego is right in that null is “safe” in the language because the language supports null references. But that doesn’t mean it’s safe from a runtime perspective or a developer / human perspective. I’ll defer to the “Semantics Of Null” and the “Null Object Pattern” sections for the issues I have with this. Language safety simply isn’t a good enough reason to do something, in my opinion. I want semantic safety as well. Of course, there’s no automated way of ensuring this. It requires human beings to interact with each other, discuss the semantics of the system, and model those semantics into the code. It’s certainly not the easy way out in terms of writing the code… but it certainly makes the code easier to read and understand for everyone else.
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    Having To Know
                  </h3>
                  
                  <p>
                    In this case, I meant to say that the developer who is reading the code has to know what’s going on and know the semantics that are supposed to be in place to understand the code. I guess I worded that a little funny, or maybe Diego is assuming that when he says “user” and “using” in the comment… either way, I’ll clarify what I mean.
                  </p>
                  
                  <p>
                    Start by referring back to the small code snippet from “The Semantics Of Null”.
                  </p>
                  
                  <p>
                    The problem I have with this code is not in writing it, actually. Given the requirements that I stated in the previous post, I would only need to ask a few of these questions to figure out what should be going on in this case. However, I only write code a fraction of the time compared to how often I read code. I’m far less concerned with whether or not it’s easier or faster to write this code with a null check than I am concerned with my own ability to easily read this code, and even more importantly, have someone else on my team read this code and understand it.
                  </p>
                  
                  <p>
                    In this case, I am likely causing a lot of pain and heartache for the other developers on my team. Anyone who is not familiar with this code already is likely going to have to ask the same questions that the person who wrote the code asked. At a minimum, they will have to read the code inside of the conditional blocks and figure out the semantics of the if statement based on the contents of those blocks.
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    The Null Object Pattern
                  </h3>
                  
                  <p>
                    I completely understand Diego’s issue with the <a href="http://en.wikipedia.org/wiki/Null_Object_pattern">null object pattern</a>. I’ve had the same concern many times in the past, and I’m still on the fence about whether or not I like this pattern. I have seen it’s usefulness in some situations, but in those situations I also the importance of the entire team using this pattern everywhere. If it’s only used in a few places in a codebase, it will get really confusing really fast. If, however, the entire team has standardized on “no null references, ever”, then the null object pattern is a great way to go about doing that.
                  </p>
                  
                  <p>
                    The issue I have with the null object pattern in this case is that it does not provide any additional semantics or intention revealing language in the code. compare these two code snippets:
                  </p>
                  
                  <p>
                    <strong>#1: Null Reference Check</strong>
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">if</span> (productCodeSelected.ProductCode == <span style="color: #0000ff">null</span>)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span>   <span style="color: #008000">// do something here, based on the product code being null</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span> }</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          <strong>#2: Null Object Pattern, Null check</strong>
                        </p>
                        
                        <div>
                          <div>
                            <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">if</span> (productCodeSelected.ProductCode.IsNull)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   2:</span> {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   3:</span>   <span style="color: #008000">// do something here, based on the product code being null</span></pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   4:</span> }</pre>
                            
                            <p>
                              <!--CRLF--></div> </div> 
                              
                              <p>
                                There are some advantages to the null object pattern from an OO perspective, and perhaps from an application perspective in other parts of the app. In this specific example, considering the ProductCodeSelected event that is going to execute this code, I see no distinct advantages of the null object pattern vs. a null reference. I think Diego was saying the same thing about the null object pattern, specifically, and I agree. The issue I have with both of these samples is the lack of intention revealing language, and the lack of implicit or explicit semantics in the code to help me understand the scenario that is being executed.
                              </p>
                              
                              <p>
                                Of course, the example in #2 is a poor use of the null object pattern. It would be a better use of OO techniques to not do the null check in this if statement. Rather, just have the Handler method work with the ProductCode without regard for it being null or not. At some point, it is likely that the .IsNull property will be checked, but it can be done for specific circumstances where it’s necessary to know if the object is “null” or not (such as validation).
                              </p>
                              
                              <p>
                                &#160;
                              </p>
                              
                              <h3>
                                Semantics, Semantics, Semantics
                              </h3>
                            </p></p> 
                            
                            <p>
                              I know a lot of people get tired of hearing semantic debates, pretty quickly… and to those that have ever worked with me, yes &#8211; there are times when <a href="http://martinfowler.com/articles/mocksArentStubs.html">I get tired of semantic debates and nit-picking</a>, too. 🙂 This is one case where I believe semantics are important, though. Code is read far more often than it is written. Creating code that is easy to read and easy to understand gives it a higher likelihood of being easy to change, and that is far more important than how quickly you can write the code for the first time.
                            </p>
                            
                            <p>
                              &#160;
                            </p>
                            
                            <h3>
                              Other Considerations
                            </h3>
                            
                            <p>
                              Don’t take this post as me saying you should never check for null references. There are times and places where it’s necessary. My point is that using null references in place of code that could have explicit understanding related to the reader through intention revealing language, is a bad design decision.
                            </p>
                            
                            <p>
                              The arguments that I’m presenting here can be applied to more than just null references, too. Any time you have the opportunity to make your code semantically correct according to the business or process being modeled, you are likely to have a better design in your system. This applies to null references just as much as it applies to our use of <a href="http://codebetter.com/blogs/david_laribee/archive/2008/07/08/super-models-part-2-avoid-mutators.aspx">properties vs methods</a>, <a href="http://en.wikipedia.org/wiki/Hungarian_notation">hungarian notation</a> and other archaic naming schemes, etc. etc. etc.
                            </p>
                            
                            <p>
                              And lastly, I’d like to thank Diego for his comment on my previous post. I realized that there were a lot of assumptions I was making in that post after reading his comment. Hopefully I’ve been able to explain those assumptions here, if only in a round-about manner.
                            </p>