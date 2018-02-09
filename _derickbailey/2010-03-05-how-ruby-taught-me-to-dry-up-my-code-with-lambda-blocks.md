---
wordpress_id: 109
title: How Ruby Taught Me To DRY Up My Code With Lambda Blocks
date: 2010-03-05T20:32:25+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/03/05/how-ruby-taught-me-to-dry-up-my-code-with-lambda-blocks.aspx
dsq_thread_id:
  - "262068478"
categories:
  - .NET
  - 'C#'
  - Lambda Expressions
  - Model-View-Presenter
  - Pragmatism
  - Principles and Patterns
  - Ruby
redirect_from: "/blogs/derickbailey/archive/2010/03/05/how-ruby-taught-me-to-dry-up-my-code-with-lambda-blocks.aspx/"
---
I’ve been working in Ruby for my Albacore project over the last 6 or 8 months, and taking every chance I can find to learn how to really use the language effectively. One of the benefits I’m seeing in a dynamic language like Ruby is the ability to really [DRY](http://en.wikipedia.org/wiki/DRY) up your code through it’s [dynamic](http://en.wikipedia.org/wiki/Dynamic_typing#Dynamic_typing)/[duck type](http://en.wikipedia.org/wiki/Duck_typing) system, and through [metaprogramming](http://www.pragprog.com/titles/ppmetr/metaprogramming-ruby). 

I’ve noticed in my ruby code that I tend to see repeated patterns of implementation in a different light. Rather than seeing the things that make each repetition of the pattern different, I tend to see the things that make each repetition of the pattern the same. I notice the same structure used with different variable name, the same method calls used with different parameters, and context specific method calls as the outliers that made me duplicate the code in the first place. When I see these patterns, my mind begins to run down the path of “this code is duplicated… how can I eliminate that duplication?” Whereas in C#, I almost immediately see the differences as “these are different calls based on the context and I can’t eliminate this repeated pattern of code because of the unique calls each has to make.” 

I’m not sure why my mind has been operating this way with C#, but I know that is has been doing this for a very long time. I’ve often written the same pattern of code 6 or 8 times, or more in some cases – especially when it comes to UI code and event handlers from UI controls. I wrote a prime example of repeated patterns in C# just today, on a UI that has 4 ComboBox controls on it. Each combobox has a SelectedIndexChanged event handler that gets the selected value and pushes it to the presenter via a presenter method that is specific to the value being pushed. Here’s the code in all it’s glorious duplication:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">void</span> cboTypes_SelectedIndexChanged(<span style="color: #0000ff">object</span> sender, EventArgs e)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     TeardownComboBoxEvents();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     var lookup = cboTypes.SelectedItem <span style="color: #0000ff">as</span> Lookup;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">if</span> (lookup != <span style="color: #0000ff">null</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>         _presenter.TypeSelected(lookup);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>     SetupComboBoxEvents();</pre>
    
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
    
    <pre><span style="color: #606060">  14:</span> <span style="color: #0000ff">void</span> cboGroups_SelectedIndexChanged(<span style="color: #0000ff">object</span> sender, EventArgs e)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>     TeardownComboBoxEvents();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>     var lookup = cboGroups.SelectedItem <span style="color: #0000ff">as</span> Lookup;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span>     <span style="color: #0000ff">if</span> (lookup != <span style="color: #0000ff">null</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  20:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  21:</span>         _presenter.GroupSelected(lookup);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  22:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  23:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  24:</span>     SetupComboBoxEvents();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  25:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  26:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  27:</span> <span style="color: #0000ff">void</span> cboCategories_SelectedIndexChanged(<span style="color: #0000ff">object</span> sender, EventArgs e)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  28:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  29:</span>     TeardownComboBoxEvents();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  30:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  31:</span>     var lookup = cboCategories.SelectedItem <span style="color: #0000ff">as</span> Lookup;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  32:</span>     <span style="color: #0000ff">if</span> (lookup != <span style="color: #0000ff">null</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  33:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  34:</span>         _presenter.CategorySelected(lookup);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  35:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  36:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  37:</span>     SetupComboBoxEvents();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  38:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  39:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  40:</span> <span style="color: #0000ff">void</span> cboCodes_SelectedIndexChanged(<span style="color: #0000ff">object</span> sender, EventArgs e)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  41:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  42:</span>     TeardownComboBoxEvents();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  43:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  44:</span>     var lookup = cboCodes.SelectedItem <span style="color: #0000ff">as</span> Lookup;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  45:</span>     <span style="color: #0000ff">if</span> (lookup != <span style="color: #0000ff">null</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  46:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  47:</span>         _presenter.CodeSelected(lookup);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  48:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  49:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  50:</span>     SetupComboBoxEvents();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  51:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        When I wrote this code and looked back at it, I had my usual feeling of “well, these presenter calls are specific the the context of the combox being selected, so I can’t really do anything to eliminate this repeated pattern of code.” I even went so far as to think “man, if this were Ruby, I wouldn’t have any issue killing this repeated pattern.”&#160; That’s when a little voice in the back of my head started shouting at me and I realized that I could eliminate the duplication in C# just as easily as I could in Ruby with the use of anonymous delegates.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        Method Blocks And Anonymous Delegates
      </h3>
      
      <p>
        One of the techniques I often use in Ruby to help dry up repeated code is ruby’s method blocks &#8211; basically an anonymous delegate in C#. These two code samples are functionality equivalent…
      </p>
      
      <p>
        <strong>Ruby Method Block With Named Parameter</strong>
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> def my_method(&block)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span>   name = <span style="color: #006080">"derick"</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>   block.call(name) unless block.nil?</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span> end</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span> my_method <span style="color: #0000ff">do</span> |name|</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>   puts <span style="color: #006080">"the name is: #{name}"</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span> end</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              <strong>C# Anonymous Delegate (Lambda) With Named Parameter</strong>
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> MyMethod(Action&lt;<span style="color: #0000ff">string</span>&gt; block)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>   <span style="color: #0000ff">string</span> name = <span style="color: #006080">"derick"</span>;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>   <span style="color: #0000ff">if</span> (block != <span style="color: #0000ff">null</span>)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>     block(name);</pre>
                
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
                
                <pre><span style="color: #606060">   8:</span> MyMethod(name =&gt; {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   9:</span>   Console.WriteLine(<span style="color: #006080">"the name is: "</span> + name);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  10:</span> });</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    Eliminating This Repeated Pattern
                  </h3>
                  
                  <p>
                    After I finally decided to listen to that little voice shouting at me and use my tools to their full extent, I rewrote the event handlers into the following code, using an Action delegate and anonymous lambda block to execute the context specific presenter calls.
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> LookupSelected(ComboBox comboBox, Action&lt;Lookup&gt; presenterCall)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span>     TeardownComboBoxEvents();</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   5:</span>     var lookup = comboBox.SelectedItem <span style="color: #0000ff">as</span> Lookup;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">if</span> (lookup != <span style="color: #0000ff">null</span>)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   7:</span>     {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   8:</span>         presenterCall(lookup);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   9:</span>     }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  10:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  11:</span>     SetupComboBoxEvents();</pre>
                      
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
                      
                      <pre><span style="color: #606060">  14:</span> <span style="color: #0000ff">void</span> cboTypes_SelectedIndexChanged(<span style="color: #0000ff">object</span> sender, EventArgs e)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  15:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  16:</span>     LookupSelected(cboTypes, l =&gt; _presenter.AssetTypeSelected(l));</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  17:</span> }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  18:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  19:</span> <span style="color: #0000ff">void</span> cboGroups_SelectedIndexChanged(<span style="color: #0000ff">object</span> sender, EventArgs e)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  20:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  21:</span>     LookupSelected(cboGroups, l =&gt; _presenter.GroupSelected(l));</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  22:</span> }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  23:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  24:</span> <span style="color: #0000ff">void</span> cboCategories_SelectedIndexChanged(<span style="color: #0000ff">object</span> sender, EventArgs e)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  25:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  26:</span>     LookupSelected(cboCategories, l =&gt; _presenter.CategorySelected(l));</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  27:</span> }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  28:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  29:</span> <span style="color: #0000ff">void</span> cboGroups_SelectedIndexChanged(<span style="color: #0000ff">object</span> sender, EventArgs e)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  30:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  31:</span>     LookupSelected(cboGroups, l =&gt; _presenter.GroupSelected(l));</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  32:</span> }</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          &#160;
                        </p>
                        
                        <h3>
                          Lessons Learned
                        </h3>
                        
                        <p>
                          This certainly isn’t anything extraordinary, mind you. I’ve written methods with delegates and lambda blocks more often than I can remember. This code is not complex, it’s not difficult to write, it’s not difficult to read or understand. But that’s the beauty of it. It’s simple, elegant, and eliminates the repeated pattern that I was creating. There are probably some additional tweaks I could make, honestly, but I also want to keep in mind the readability and understandability of the code – not just how often a pattern is repeated.
                        </p>
                        
                        <p>
                          The significance of this is not in the code that I wound up writing, but in how I came to that decision. My exposure to ruby and my predisposition to see repeated patterns of code in ruby as duplication that should be eliminated finally made a jump across the neuro-pathways of my brain into C# land. I was able to take a paradigm from a different language and different set of optimizations and capabilities, and redefine my own understanding of the current paradigms and capabilities of this situation. That kind of cross-breading and transfer of knowledge is critical to our ability to come up with new and creative solutions in situations where we believe we already have mastery.
                        </p>
                        
                        <p>
                          Do yourself a favor – learn a new paradigm of development or whatever your job entails. You’ll never truly be able to say “use the right tool for the job” unless you actually know how to use the tools available, and you never know when the paradigms of one tool will cross the boundaries of your experience and begin to show you new solutions to existing problems.
                        </p>