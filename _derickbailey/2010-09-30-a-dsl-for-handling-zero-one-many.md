---
wordpress_id: 187
title: A DSL For Handling Zero, One, Many
date: 2010-09-30T20:13:35+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/09/30/a-dsl-for-handling-zero-one-many.aspx
dsq_thread_id:
  - "263968062"
categories:
  - .NET
  - 'C#'
  - DSL
---
All this talk about [refactoring to clean up code](http://www.lostechies.com/blogs/derickbailey/archive/2010/09/24/a-refactoring-explicit-modeling-and-reducing-duplication.aspx) and [monads to create pipelines](http://www.lostechies.com/blogs/derickbailey/archive/2010/09/29/monads-in-c-which-part-is-the-monad.aspx) has put me on a code composition kick… I wrote this code today:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">private</span> AddAssetResult HandleAssetFamily(SortContainer container, SystemAsset systemAsset)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     AddAssetResult result = <span style="color: #0000ff">null</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>     var assetFamilies = assetFamilyDao.GetByAssetType(systemAsset.AssetTypeId);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">if</span> (assetFamilies == <span style="color: #0000ff">null</span> || assetFamilies.Count == 0)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>         result = <span style="color: #0000ff">new</span> AddAssetResult(SortContainerResources.NoAssetFamily);</pre>
    
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
    
    <pre><span style="color: #606060">  11:</span>     <span style="color: #0000ff">if</span> (assetFamilies != <span style="color: #0000ff">null</span> && assetFamilies.Count &gt; 1)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>         result = <span style="color: #0000ff">new</span> AddAssetResult(SortContainerResources.MultipleAssetFamilies);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>     <span style="color: #0000ff">if</span> (assetFamilies != <span style="color: #0000ff">null</span> && assetFamilies.Count == 1)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>         var assetFamily = assetFamilies[0];</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span>         SetContainerFamily(container, assetFamily);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  20:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  21:</span>         result = VerifyFamilyIsCompatible(systemAsset, container);</pre>
    
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
    
    <pre><span style="color: #606060">  24:</span>     <span style="color: #0000ff">return</span> result;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  25:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        Being the good little geeky me that I am, I wanted to use my shiny new monads hammer to pound this code into shape. As I was thinking about the monads that I have come across in my reading and my current understanding of them, though, I decided that I should probably see if this problem is actually a nail before whacking it with my hammer. So… rather than forcing myself to do something that might be dumb, I decided to approach this code from a composition standpoint – because after all, that’s one of the things a monad gives me.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        Zero, One, Many
      </h3>
      
      <p>
        As I thought about the problem, I remembered an article that I read a long time about that talked about the three significant numbers: zero, one and many. The idea is that most of the time, you only need to pay attention to these three numbers. In looking at the above code, you can see that these are the exact numbers that I am paying attention to. This popped an idea for a DSL into my head and I pseudo-coded this into existence:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> var result = assetFamilies.CheckCount&lt;AddAssetResult&gt;()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span>     .WhenZero(() =&gt; <span style="color: #0000ff">new</span> AddAssetResult(SortContainerResources.NoAssetFamily))</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     .WhenOne(() =&gt; <span style="color: #0000ff">new</span> AddAssetResult(SortContainerResources.MultipleAssetFamilies))</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     .WhenMany(AddAssetWithFamily);</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              The idea was to have a fluent interface / DSL that allows me to pay attention to the three significant numbers that I need in my above scenario and compose the behavior of the system by stating what would happen for each of those numbers. It seems like a pretty good idea and I like the syntax (all C# ceremony aside, of course).
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              Adjusting For Reality
            </h3>
            
            <p>
              I expected to have to adjust this code for reality, of course. I wrote that above example in notepad just to bang it out without worrying about proper syntax and the actual constraints of C#.
            </p>
            
            <p>
              I found out that I needed to specify two generics parameters to the CheckCount extension method. I originally wanted to use IEnumerable as the “this” parameter of the extension method, but there is no Count on it and no way to get one without looping over the entire enumeration. So, I decided to accept that I needed to pass in an IEnumerable<T> as “this” to the extension method. That made the first line read like this:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> var result = assetFamilies.CheckCount&lt;AssetFamily, AddAssetResult&gt;()</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    Which should read like “check the count of asset families, and return an add asset result based on the count”.
                  </p>
                  
                  <p>
                    The next thing I had to do was add a .Result property to the DSL so that I could get the result out of the method chains. I also had to adjust the WhenOne method I was calling and I realized that I had the WhenOne and WhenMany cases switched. Fixing those items makes the entire call chain look like this:
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> var result = assetFamilies.CheckCount&lt;AssetFamily, AddAssetResult&gt;()</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span>     .WhenZero(() =&gt; <span style="color: #0000ff">new</span> AddAssetResult(SortContainerResources.NoAssetFamily))</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span>     .WhenOne(() =&gt; AddAssetWithFamily(systemAsset, container, assetFamilies[0]))</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span>     .WhenMany(() =&gt; <span style="color: #0000ff">new</span> AddAssetResult(SortContainerResources.MultipleAssetFamilies))</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   5:</span>     .Result;</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          Not too bad. It’s much better than the original code that I started with and I can live with this.
                        </p>
                        
                        <p>
                          &#160;
                        </p>
                        
                        <h3>
                          Implementing The DSL
                        </h3>
                        
                        <p>
                          I started with an extension method for the CheckCount call and then built out a small class called CountChecker. This class does the actual work of deciding which of the numeric methods should have it’s Func<T> called and stores the results of the one that is called. Since this is a method chaining situation, each of the When* methods that I chain will actually be called, but I only want to execute the Func<T> of the one that matches the actual count of the collection I’m examining. When that Fun<T> is called, I also want to store the result so that I can return it from the Result call at the end.
                        </p>
                        
                        <div>
                          <div>
                            <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">class</span> CountCheckerExtensions</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   2:</span> {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> CountChecker&lt;TResult&gt; CheckCount&lt;TCollectionType, TResult&gt;(<span style="color: #0000ff">this</span> IEnumerable&lt;TCollectionType&gt; enumerable)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   4:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   5:</span>         <span style="color: #0000ff">int</span> theCount = 0;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   6:</span>         <span style="color: #0000ff">if</span> (enumerable != <span style="color: #0000ff">null</span>)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   7:</span>             theCount = enumerable.Count();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   8:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> CountChecker&lt;TResult&gt;(theCount);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   9:</span>     }</pre>
                            
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
                            
                            <pre><span style="color: #606060">  12:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> CountChecker&lt;TResult&gt;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  13:</span> {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  14:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> <span style="color: #0000ff">int</span> theCount;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  15:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  16:</span>     <span style="color: #0000ff">public</span> TResult Result { get; <span style="color: #0000ff">private</span> set; }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  17:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  18:</span>     <span style="color: #0000ff">public</span> CountChecker(<span style="color: #0000ff">int</span> theCount)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  19:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  20:</span>         <span style="color: #0000ff">this</span>.theCount = theCount;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  21:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  22:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  23:</span>     <span style="color: #0000ff">public</span> CountChecker&lt;TResult&gt; WhenZero(Func&lt;TResult&gt; zeroAction)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  24:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  25:</span>         <span style="color: #0000ff">if</span> (theCount == 0)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  26:</span>             Result = zeroAction();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  27:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  28:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">this</span>;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  29:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  30:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  31:</span>     <span style="color: #0000ff">public</span> CountChecker&lt;TResult&gt; WhenOne(Func&lt;TResult&gt; oneAction)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  32:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  33:</span>         <span style="color: #0000ff">if</span> (theCount == 1)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  34:</span>             Result = oneAction();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  35:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  36:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">this</span>;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  37:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  38:</span>     </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  39:</span>     <span style="color: #0000ff">public</span> CountChecker&lt;TResult&gt; WhenMany(Func&lt;TResult&gt; manyAction)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  40:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  41:</span>         <span style="color: #0000ff">if</span> (theCount &gt; 1)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  42:</span>             Result = manyAction();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  43:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  44:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">this</span>;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  45:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  46:</span> }</pre>
                            
                            <p>
                              <!--CRLF--></div> </div> 
                              
                              <p>
                                It’s a simple implementation. Nothing terribly fancy, other than getting the count out of the IEnumerable<T> and passing it into the CountChecker constructor.
                              </p>
                              
                              <p>
                                &#160;
                              </p>
                            </p></p> 
                            
                            <h3>
                              Fluent Interface And DSL, But I Don’t Think This Is A Monad
                            </h3>
                            
                            <p>
                              I mentioned that I wanted to use my shiny new monad hammer on this problem, at the beginning of this post. In the end, I don’t think I did. I’m fairly certain that what I’ve implemented is just simple method chaining and/or a fluent interface to create a DSL. Does anyone have an opinion and expertise to say otherwise? I’d be interested in hearing why you think this is, or know it is not, a monad (I realize that I’m wearing monad colored glasses these days. I’m sure this obsession will pass soon enough).
                            </p>
                            
                            <p>
                              &#160;
                            </p>
                            
                            <h3>
                              Get The Source
                            </h3>
                            
                            <p>
                              If you’re interested in the source for this DSL and example, I put it up on Github’s gists. You can grab it all, here: <a title="https://gist.github.com/5cb0241ea0123b76fbb1" href="https://gist.github.com/5cb0241ea0123b76fbb1">https://gist.github.com/5cb0241ea0123b76fbb1</a>
                            </p>