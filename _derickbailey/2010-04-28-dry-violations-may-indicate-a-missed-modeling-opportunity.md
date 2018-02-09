---
wordpress_id: 149
title: DRY Violations May Indicate A Missed Modeling Opportunity
date: 2010-04-28T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/04/28/dry-violations-may-indicate-a-missed-modeling-opportunity.aspx
dsq_thread_id:
  - "262068663"
categories:
  - .NET
  - Analysis and Design
  - AntiPatterns
  - 'C#'
  - Principles and Patterns
redirect_from: "/blogs/derickbailey/archive/2010/04/28/dry-violations-may-indicate-a-missed-modeling-opportunity.aspx/"
---
In [a previous blog post](http://www.lostechies.com/blogs/derickbailey/archive/2010/03/17/application-events-modeling-selection-vs-de-selection-as-separate-events.aspx), I talked about some potential options for modeling an “item selected” event and a “item de-selected” event. In that post, I suggested a couple of options and stated which one I thought was the right way to do things: model the de-selected even explicitly. The conversation in the comments was quite interesting and provided some great info on when / where / why to use both options.&#160; Fast forward almost a month and a half, and I never actually implemented the explicit modeling for the de-selected event. I left the code as it was originally, using a null value in the selected event data to signify the de-selected or “none” selected event… and now it’s come back to haunt me.

&#160;

### Multiple Item Selected Events Exposing A Bug

A new requirement came in that causing me to change how the code in question behaved. Rather than having a single item selected event based on the last drop down list on the screen, I now needed two item selected events: 1 for the next to last drop down list, and 1 for the last drop down list. These two events are prioritized. A simple version of the prioritization can be stated like this:

  * if the user selects an item in the next to last drop down list only, then this is the data we need to use 
  * if the user selects an item in the last drop down list, then this is the data we need to use 

This is a simplified implementation of the process, but reflects my code very accurately (I’ve only removed a few lines of code that are not pertinent to the example and in-lined one method call to keep it simple for this example). Can you spot the bug in this code based on the stated requirements?

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> AssetTypeSelected(Lookup assetTypeLookup)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     AssetType assetType = <span style="color: #0000ff">null</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">if</span> (assetTypeLookup.Value != selectOne.Value)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>         assetType = assetTypeRepository.GetById(assetTypeLookup.Value);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>         var productCodes = productCodeRepository.GetByAssetType(assetType);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>         <span style="color: #0000ff">if</span> (productCodes.Count == 1)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>           appController.Raise(<span style="color: #0000ff">new</span> AssetClassified(productCodes[0]));</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>     appController.Raise(<span style="color: #0000ff">new</span> AssetClassified(assetType));</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        (<strong>Note:</strong> The calls to the appController.Raise method are the events being fired. ‘AssetClassified’ represents the ‘selected’ event that I am referring to.)
      </p>
      
      <p>
        The bug is related to lines 9 and 11. In the scenario where a user selects an asset type and there is only 1 product code available for that asset type, the system will auto-select the product code. The previous requirements stated that we should use the product code data if it is selected, however, this code will always publish the asset classification (item selected) event for the asset type last. Therefore, the product code selection will never be used for the classification.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        A Quick Fix And A DRY Violation
      </h3>
      
      <p>
        A tester found the bug in this code recently, and I was tasked with fixing it. The quick-fix solution was easy enough:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> AssetTypeSelected(Lookup assetTypeLookup)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     AssetType assetType = <span style="color: #0000ff">null</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     AssetClassified assetClassified = <span style="color: #0000ff">null</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">if</span> (assetTypeLookup.Value != selectOne.Value)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>         assetType = assetTypeRepository.GetById(assetTypeLookup.Value);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>         assetClassified = <span style="color: #0000ff">new</span> AssetClassified(assetType);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>         var productCodes = productCodeRepository.GetByAssetType(assetType);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>         <span style="color: #0000ff">if</span> (productCodes.Count == 1)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>           assetClassified = <span style="color: #0000ff">new</span> AssetClassified(productCodes[0]);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span>     <span style="color: #0000ff">else</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  15:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  16:</span>         assetClassified = <span style="color: #0000ff">new</span> AssetClassified(assetType);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  17:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  18:</span>     appController.Raise(assetClassified);    </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  19:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              The thing to note is that I realized I needed to duplicate the call to new AssetClassified(assetType)); on line 8 and line 18. The reason for this is that when an asset type is selected from the drop list, I have to classify the item by the asset type before checking for a product code and whether or not I should auto-classify based on a single product code being available. If the user has selected nothing in the list, then the asset classification is de-selected. Since I have modeled de-selection by a null value, I need to ensure that I am raising the even with a null value. I can’t pass “null” directly to the AssetClassified class because it has an overloaded constructor &#8211; one for product codes and one for asset types, forcing me to specify the type via a variable that evaluates to null in this case.
            </p>
            
            <p>
              The end result is duplicated code – a violation of the <a href="http://en.wikipedia.org/wiki/Don%27t_repeat_yourself">Don’t Repeat Yourself</a> (DRY) principle.
            </p>
            
            <p>
              &#160;
            </p>
          </p>
          
          <h3>
            Eliminating The DRY Violation With Proper Modeling
          </h3>
          
          <p>
            I find myself coming round full circle to the original options and ‘the right way’ that I listed in that post almost a month and a half ago, realizing that if I had modeled the de-selected event as it’s own explicit object, I could have potentially avoided this situation. At the very least, the need to separate selected and de-selected would have given me a little more insight and allowed me more opportunity to see that I was introducing a bug in the original version of the code, above. Part of the reason for this is that in my effort to eliminate DRY violations in the original code at the top of this post, I did not want more than one place where I called appController.Raise(new AssetClassified(assetType)). I put this call at the very end of the method so that it would only be done once and would have the value of null or the actual asset type value being passed into it based on the previous code in the method. It was through this effort to eliminate DRY violations that I wound up causing DRY violations when my needs changed. If I had modeled an explicit AssetDeclassified event from the start, I would have been forced to make two separate calls to the appController.Raise – one for the AssetClassified and one for the AssetDeclassified events.
          </p>
          
          <p>
            Look at the following code, for example, where the asset de-classification (de-selection of an asset type) is modeled as it’s own event:
          </p>
          
          <div>
            <div>
              <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> AssetTypeSelected(Lookup assetTypeLookup)</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   2:</span> {</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">if</span> (assetTypeLookup.Value != selectOne.Value)</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   4:</span>     {</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   5:</span>         AssetClassified assetClassified = <span style="color: #0000ff">null</span>;</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   6:</span>         </pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   7:</span>         var assetType = assetTypeRepository.GetById(assetTypeLookup.Value);</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   8:</span>         assetClassified = <span style="color: #0000ff">new</span> AssetClassified(assetType);</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   9:</span>&#160; </pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">  10:</span>         var productCodes = productCodeRepository.GetByAssetType(assetType);</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">  11:</span>         <span style="color: #0000ff">if</span> (productCodes.Count == 1)</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">  12:</span>           assetClassified = <span style="color: #0000ff">new</span> AssetClassified(productCodes[0]);</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">  13:</span>           </pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">  14:</span>         appController.Raise(assetClassified);</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">  15:</span>     }</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">  16:</span>     <span style="color: #0000ff">else</span></pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">  17:</span>     {</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">  18:</span>         appController.Raise(<span style="color: #0000ff">new</span> AssetDeclassified());</pre>
              
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
                  This code provides the same functionality as the previous DRY violation code, but does so with two distinct events on line 14 and line 18. I am no longer paying attention to null values as the indication of whether an asset has been de-classified, and I am not concerned with DRY violations between these two lines of code because they are obviously raising different events now.
                </p>
                
                <p>
                  The new version of the code doesn’t just provide the same functionality without violating DRY, though. I would go so far as to say is espouses additional principles in that it models the selected vs. de-selected events as first class citizens, separately, thus preventing Single Responsibility, Liskov Substitution, DRY, and other principle violations. I also gained new opportunities to simplify and clean up the AssetTypeSelected method, providing additional places to model explicit concepts as method calls within the code. For example, the contents of the positive-path in the if statement could be extracted into a “ClassifyAsset()” method call, simplifying the AssetTypeSelected method and making it easier to read. I also have to model the product code de-selection de-selection. By providing an explicit AssetDeclassified event, both the asset type and product code de-selection needs can be solved without having to resort to semantic coupling – requiring the developer to know that they should pass in a null value event when de-selecting the product code or asset type.
                </p>
                
                <p>
                  &#160;
                </p>
                
                <h3>
                  Explicit Modeling Is Not Just For Readability
                </h3>
                
                <p>
                  The lesson that I’m taking from this experience is that explicit modeling doesn’t just help create code that is easier to read and understand. It can also help us prevent a number of principle violations. In this specific case it was the DRY principle violation that tipped me off to the problems, but once I started digging into it I realized that there were a number of other principles being violated as well. The original solution, while functional, was simply causing more problems and more headaches by coupling too many things together. A simple solution of modeling the two concepts, selected and de-selected, as their own events went a long way and really helped me clean up the code.
                </p>