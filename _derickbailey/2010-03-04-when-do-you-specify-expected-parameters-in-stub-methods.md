---
wordpress_id: 108
title: When Do You Specify Expected Parameters In Stub Methods?
date: 2010-03-04T22:20:10+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/03/04/when-do-you-specify-expected-parameters-in-stub-methods.aspx
dsq_thread_id:
  - "262068439"
categories:
  - .NET
  - Behavior Driven Development
  - 'C#'
  - Pragmatism
  - Principles and Patterns
  - Unit Testing
redirect_from: "/blogs/derickbailey/archive/2010/03/04/when-do-you-specify-expected-parameters-in-stub-methods.aspx/"
---
I’m writing a spec with a mock object that mock object returns data to the class under test. In these situations, I don’t bother asserting that my mock object’s method was called because I know that if it’s not called the data I need in the class under test won’t be there and I’ll end up having other unexpected behavior. This falls under the general guideline of ‘test output and interactions, not input’. 

In this specific situation, I am taking a value from user input and using that value to load up some data from a mock repository. I find myself wondering if I should specify the value that is being passed into the mock object’s method so that the mock will only return the data I need if the method is called with the right value. To illustrate in code, here are the two different ways I could do this.

1. Always return the data from the stubbed method call:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">private</span> IAssetGroupRepository GetAssetGroupRepository()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     var repo = Mock&lt;IAssetGroupRepository&gt;();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>     AssetGroups = <span style="color: #0000ff">new</span> List&lt;Lookup&gt;();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     repo.Stub(r =&gt; r.GetGroupLookups(Arg&lt;<span style="color: #0000ff">int</span>&gt;.Is.Anything)).Return(AssetGroups);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">return</span> repo;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        2. Only return the data from the stubbed method when the right argument is found:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> IAssetGroupRepository GetAssetGroupRepository()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     var repo = Mock&lt;IAssetGroupRepository&gt;();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     AssetGroups = <span style="color: #0000ff">new</span> List&lt;Lookup&gt;();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>     repo.Stub(r =&gt; r.GetGroupLookups(1)).Return(AssetGroups);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">return</span> repo;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              The difference is on line 5 – the use of Is.Anything vs. a literal value of 1. It seems that the arguments should be specified when it matters what the arguments are… when the arguments are going to determine whether or not the right thing is being done. In this situation, it seems to me that the argument is important. If I’m not specifying the value that was selected when calling the GetGroupLookups, then my code has failed to account for the user’s input and it will likely produce the wrong behavior. The counterpoint to this is that the test where this stub definition lives becomes a little more brittle.
            </p>
            
            <p>
              So the question is when should I return the data no matter what arguments are used vs. when should I only return the data when the right arguments are used? I know the answer is “it depends”, as that’s the only valid answer to any code question. 🙂 But I’m looking for some input from the rest of the world on when they do / don’t require the right arguments and why.
            </p>