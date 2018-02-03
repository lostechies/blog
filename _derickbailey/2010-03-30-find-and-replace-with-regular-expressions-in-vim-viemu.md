---
wordpress_id: 127
title: Find And Replace With Regular Expressions In Vim / ViEmu
date: 2010-03-30T18:38:32+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/03/30/find-and-replace-with-regular-expressions-in-vim-viemu.aspx
dsq_thread_id:
  - "262068529"
categories:
  - .NET
  - 'C#'
  - Productivity
  - Refactoring
  - Vim
---
Here’s another entry in my how-i-saved-a-few-hundred-keystrokes blog posts on using [Vim](http://www.vim.org/) / [ViEmu](http://www.viemu.com/) with Visual Studio. 

&#160;

### The Code That Needs To Change

I’ve got a data access method that is mapping around 50 fields into an object from a data table. I’m in the process of changing the code from raw reads off the data table’s indexer with Convert.To… statements into a data reader with my [type safe data reader](http://www.lostechies.com/blogs/derickbailey/archive/2010/03/15/a-type-safe-idatareader-wrapper.aspx) being used. There are 9 lines of code that read and convert to an Int32 and around as many for DateTime, Decimal, String and a few others. 

Here’s the Int32 portion of the code, to make it easier to see what’s going on:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> Record MapOneFrom(IDataReader dataReader)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     var dr = <span style="color: #0000ff">new</span> TypeSafeDataReader(dataReader);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     var record = <span style="color: #0000ff">new</span> Record();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>     record.Id = Convert.ToInt32(dataRow[<span style="color: #006080">"Id"</span>]);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>     record.Action = _actionRepository.GetById(Convert.ToInt32(dataRow[<span style="color: #006080">"ActionId"</span>]));</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>     record.User = _userRepository.GetById(Convert.ToInt32(dataRow[<span style="color: #006080">"UserId"</span>]));</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>     record.Location = _locationRepository.GetById(Convert.ToInt32(dataRow[<span style="color: #006080">"LocationId"</span>]));</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>     record.OriginLocation = _locationRepository.GetById(Convert.ToInt32(dataRow[<span style="color: #006080">"OriginLocationId"</span>]));</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>     record.BuildingId = Convert.ToInt32(dataRow[<span style="color: #006080">"BuildingId"</span>]);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>     record.PersonId = Convert.ToInt32(dataRow[<span style="color: #006080">"PersonId"</span>]);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>     record.UseStateIdForDelivers = Convert.ToInt32(dataRow[<span style="color: #006080">"UseStateIdForDelivers"</span>]);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>     record.UseStateIdForReturns = Convert.ToInt32(dataRow[<span style="color: #006080">"UseStateIdForReturns"</span>]);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span>     <span style="color: #008000">//insert a lot more reading / converting for DateTime, String, Decimal, etc.</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span>     <span style="color: #0000ff">return</span> record;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  20:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        I want to change all of the code that reads:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> Convert.ToInt32(dataRow[<span style="color: #006080">"some column name"</span>])</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              to:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> dr.GetInt32(<span style="color: #006080">"some column name"</span>)</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    without having to manually copy & paste, re-type the same thing, or adjust the column name in the quotes, as I would have done in the past.
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    The Regex Find And Replace
                  </h3>
                  
                  <p>
                    I’ve known about Vim / ViEmu’s ability to do regular expression find and replace for a while, so I figured this would be a good time to learn. I found some good instructions on using regular expressions with find and replace with Vim / ViEmu via Google and after some playing around with it to learn the differences in the regex syntax compared to what I’m used to in .NET, I was able to once again save myself a few hundred keystrokes in a scenario.
                  </p>
                  
                  <p>
                    Here’s the find & replace that I issued to accomplish what I wanted for my Int32 conversion:
                  </p>
                  
                  <blockquote>
                    <p>
                      <strong>:%s/Convert.ToInt32(dataRow[(“.*”)])/dr.GetInt32(1)/g</strong>
                    </p>
                  </blockquote>
                  
                  <p>
                    I’ll leave it up to the reader to do the research on the syntax for find and replace, and regular expressions in vim. Anyone who has done regular expressions in .NET will immediately question the syntax of this expression, though… it took me about 15 minutes of trying to figure this out, honestly. But once I did figure it out, I was able to quickly and easily replace all of the code in question for my Int32 data reading. The result looks like this:
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> Record MapOneFrom(IDataReader dataReader)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span>     var dr = <span style="color: #0000ff">new</span> TypeSafeDataReader(dataReader);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   5:</span>     var record = <span style="color: #0000ff">new</span> Record();</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   6:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   7:</span>     record.Id = dr.GetInt32(<span style="color: #006080">"Id"</span>);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   8:</span>     record.Action = _actionRepository.GetById(dr.GetInt32(<span style="color: #006080">"ActionId"</span>));</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   9:</span>     record.User = _userRepository.GetById(dr.GetInt32(<span style="color: #006080">"UserId"</span>));</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  10:</span>     record.Location = _locationRepository.GetById(dr.GetInt32(<span style="color: #006080">"LocationId"</span>));</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  11:</span>     record.OriginLocation = _locationRepository.GetById(dr.GetInt32(<span style="color: #006080">"OriginLocationId"</span>));</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  12:</span>     record.BuildingId = dr.GetInt32(<span style="color: #006080">"BuildingId"</span>);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  13:</span>     record.PersonId = dr.GetInt32(<span style="color: #006080">"PersonId"</span>);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  14:</span>     record.UseStateIdForDelivers = dr.GetInt32(<span style="color: #006080">"UseStateIdForDelivers"</span>);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  15:</span>     record.UseStateIdForReturns = dr.GetInt32(<span style="color: #006080">"UseStateIdForReturns"</span>);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  16:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  17:</span>     <span style="color: #008000">//insert a lot more reading / converting for DateTime, String, Decimal, etc.</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  18:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  19:</span>     <span style="color: #0000ff">return</span> record;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">  20:</span> }</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          Now repeat that same find and replace pattern, specifying String or DateTime or whatever else I need instead of Int32, and I’m good to go!
                        </p>
                        
                        <p>
                          &#160;
                        </p>
                        
                        <h3>
                          I’m Really Starting To Love ViEmu
                        </h3>
                        
                        <p>
                          I spend most of my vim-time in ViEmu… I haven’t used gVim or macVim very much (yet) but I’m learning pretty quickly while still having a safety net in Visual Studio. I’m also falling in love with ViEmu and the whole idea of Vim in general. Especially when I just found yet another way to save myself several hundred keystrokes &#8211; approximately 300+ keystrokes for each find and replace in this case, for a total of well over 1,200 keystrokes saved!
                        </p>
                        
                        <p>
                          If you still haven’t tried out Vim or ViEmu yet, you owe it to yourself and your eventual-productivity-improvement to do so. It really is worth the hype.
                        </p>