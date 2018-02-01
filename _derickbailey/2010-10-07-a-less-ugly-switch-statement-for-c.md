---
id: 189
title: 'A Less Ugly Switch Statement For C#'
date: 2010-10-07T21:31:51+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/10/07/a-less-ugly-switch-statement-for-c.aspx
dsq_thread_id:
  - "262975664"
categories:
  - .NET
  - 'C#'
  - Refactoring
---
I know switch statements are considered “evil” because they are very procedural code, they violate the Open-Closed Principle, etc etc. But every now and then I don’t see a need to do anything more than a switch statement because the complexity of the scenario does not need anything more, and the code’s maintainability is not going to be so adversely affected by it.

I had such a case today, when examining the “Status” value – an enum – that is found on the data structure returned by a web service call. Here’s the original code:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">switch</span> (newContainer.Status)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">case</span> ScannedAssetState.ConfirmAssetRemove:</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>             ConfirmAssetRemove(newContainer.TagInfo, assetTag);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>             <span style="color: #0000ff">break</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>     <span style="color: #0000ff">case</span> ScannedAssetState.Error:</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>             View.ShowError(newContainer.Errors.FirstOrDefault());</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>             <span style="color: #0000ff">break</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>     <span style="color: #0000ff">case</span> ScannedAssetState.Success:</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>             RestartWithNewContainer(newContainer.TagInfo);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>             <span style="color: #0000ff">break</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>     <span style="color: #0000ff">default</span>:</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  20:</span>             Init(newContainer.TagInfo);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  21:</span>             <span style="color: #0000ff">break</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  22:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  23:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        Though this code isn’t horrible, I do tend to hate the excessive syntax of switch statements. So… I wrote a simple fluent API to condense this code. Here’s the end result:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> Switch.On(newContainer.Status)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span>     .Case(ScannedAssetState.ConfirmAssetRemove, () =&gt; ConfirmAssetRemove(newContainer.TagInfo, assetTag))</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     .Case(ScannedAssetState.Error, () =&gt; View.ShowError(newContainer.Errors.FirstOrDefault()))</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     .Case(ScannedAssetState.Success, () =&gt; RestartWithNewContainer(newContainer.TagInfo))</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>     .Default(() =&gt; Init(newContainer.TagInfo));</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              And here’s the simple way I implemented it:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">class</span> Switch</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> Switch&lt;T&gt; On&lt;T&gt;(T <span style="color: #0000ff">value</span>)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>     {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> Switch&lt;T&gt;(<span style="color: #0000ff">value</span>);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span>     }</pre>
                
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
                
                <pre><span style="color: #606060">   9:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Switch&lt;T&gt;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  10:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  11:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">bool</span> hasBeenHandled;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  12:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> T <span style="color: #0000ff">value</span>;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  13:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  14:</span>     <span style="color: #0000ff">public</span> Switch(T <span style="color: #0000ff">value</span>)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  15:</span>     {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  16:</span>         <span style="color: #0000ff">this</span>.<span style="color: #0000ff">value</span> = <span style="color: #0000ff">value</span>;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  17:</span>     }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  18:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  19:</span>     <span style="color: #0000ff">public</span> Switch&lt;T&gt; Case(T comparisonValue, Action action)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  20:</span>     {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  21:</span>         <span style="color: #0000ff">if</span> (AreEqual(<span style="color: #0000ff">value</span>, comparisonValue))</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  22:</span>         {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  23:</span>             hasBeenHandled = <span style="color: #0000ff">true</span>;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  24:</span>             action();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  25:</span>         }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  26:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">this</span>;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  27:</span>     }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  28:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  29:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Default(Action action)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  30:</span>     {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  31:</span>         <span style="color: #0000ff">if</span> (!hasBeenHandled)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  32:</span>             action();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  33:</span>     }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  34:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  35:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">bool</span> AreEqual(T actualValue, T comparisonValue)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  36:</span>     {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  37:</span>         <span style="color: #0000ff">return</span> Equals(actualValue, comparisonValue);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  38:</span>     }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  39:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    I’m sure the AreEqual method could use some work to make it more robust, but it satisfied my current need just fine.
                  </p>
                  
                  <p>
                    Of course, this code is nothing ground-breaking and I’m sure plenty of people will tell me how much worse it is than the original, and how I should have / could have avoided a switch statement in the first place… Meh… It was a fun little exercise. We’ll see how long it actually lives in my code base.
                  </p>