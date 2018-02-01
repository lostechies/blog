---
id: 121
title: Eliminating Repetitious Coding With Vim / ViEmu And Macros
date: 2010-03-24T13:28:58+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/03/24/eliminating-repetitious-coding-with-vim-viemu-and-macros.aspx
dsq_thread_id:
  - "262068527"
categories:
  - .NET
  - 'C#'
  - Refactoring
  - Tools and Vendors
  - Vim
---
Anyone that has been [following me on twitter](http://twitter.com/derickbailey) recently is probably aware that I’ve been trying to learn [Vim](http://www.vim.org/) and [ViEmu for Visual Studio](http://www.viemu.com/). It’s been a very slow, somewhat painful learning process, but I think it is finally starting to pay off. I won’t bore you with most of the details as you can find plenty of stories on people’s converting to vim, around the web. What I did want to share was that I just learned how to cut down on serious code repetition using vim’s macros.

&#160;

### The Code That Needs To Change

Here’s the code that I started with. It’s from the code behind of a view implementation in a Model-View-Presenter setup.

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SelectCategory(Lookup category)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     cboCategories.SelectedItem = category;</pre>
    
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
    
    <pre><span style="color: #606060">   6:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SelectGroup(Lookup group)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>     cboGroups.SelectedItem = group;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SelectAssetType(Lookup assetType)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>     cboTypes.SelectedItem = assetType;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SelectProductCode(Lookup productCode)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>     cboProductCodes.SelectedItem = productCode;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        Notice that each of these 4 methods is basically the same line of code – just applied to a different combobox, with a differen Lookup object being selected. It’s not exactly rocket science, here… pretty straight forward.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        Bugs And Refactoring
      </h3>
      
      <p>
        There’s a bug in some of the surrounding code caused by the combobox “IndexChanged” events being fired every time I set the selected item with this code. Additionally, there are some visual artifacts that are semi-related to this code (due to this code running on the Compact Framework for Windows Mobile and Windows CE devices) and I want to clean them up.
      </p>
      
      <p>
        To fix these issues, I need to call a “TearDownComboBoxEvents()” as the first line of each method, and then call “Application.DoEvents()” and “SetupComboBoxEvents()” as the last two lines of each method. Rather than re-type those three lines of code over and over again, I want to extract them into a method that each of the above methods will call, providing the correct combobox and item to the method. This code provides that functionality:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> SetSelectedItem(ComboBox comboBox, Lookup lookup)</pre>
          
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
          
          <pre><span style="color: #606060">   4:</span>     comboBox.SelectedItem = lookup;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>     Application.DoEvents();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>     SetupComboBoxEvents();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              &#160;
            </p>
            
            <h3>
              Putting It All Together With A ViEmu Macro
            </h3>
            
            <p>
              Now that I have the method I want to call, I just need to make each of the Select methods from the first code snippet pass in the right combobox and lookup item. A few weeks ago… well, ok… yesterday morning… I would have manually modified each of these methods. This would involve re-typing “SetSelectedItem” 4 times (or at least copy & pasting it 4 times), deleting the “.SelectedItem = “ 4 times, adding a comma between the combobox name and the lookup variable 4 times, and inserting a closing parenthesis just in front of the closing semi-colon 4 times… all while using the arrow keys dozens of times to move my cursor around to make those changes.
            </p>
            
            <p>
              That’s a lot of repetition and I really wanted to learn how to avoid it… so… in comes our new hero, Vim/ViEmu and macros! Here’s what I did to solve this with a macro. First, I set my cursor (in “Normal” mode) on the very first character of the “cboCategories” variable in line 3 of the first code snippet. I then recorded this macro:
            </p>
            
            <blockquote>
              <p>
                <strong>qaiSetSelectedItem(<esc>2wc3w,<esc>$i)<esc>q</strong>
              </p>
            </blockquote>
            
            <p>
              After recording that macro, I was able to place my cursor (again, in “Normal” mode) on the first character of each of the subsequent combobox variables in the other 3 Select methods and run the macro by typing:
            </p>
            
            <blockquote>
              <p>
                <strong>@a</strong>
              </p>
            </blockquote>
            
            <p>
              that’s right… 2 characters to replay the macro I just wrote. That’s 30+ keystrokes boiled down into 2 for all of the subsequent method call changes! I save 90+ keystrokes by recording this macro and replaying it against the other 3 lines that needed it. You want to talk about <a href="http://en.wikipedia.org/wiki/Don%27t_repeat_yourself">DRY code</a>? Yeah, let’s talk about DRY code <em>writing</em> for a bit&#8230; 🙂
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              The resulting Code
            </h3>
            
            <p>
              Here’s the results of running this macro on the methods:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SelectCategory(Lookup category)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>     SetSelectedItem(cboCategories, category);</pre>
                
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
                
                <pre><span style="color: #606060">   6:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SelectGroup(Lookup group)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   8:</span>     SetSelectedItem(cboGroups, group);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   9:</span> }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  10:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  11:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SelectAssetType(Lookup assetType)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  12:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  13:</span>     SetSelectedItem(cboTypes, assetType);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  14:</span> }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  15:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  16:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SelectProductCode(Lookup productCode)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  17:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  18:</span>     SetSelectedItem(cboProductCodes, productCode);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  19:</span> }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  20:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  21:</span> <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> SetSelectedItem(ComboBox comboBox, Lookup lookup)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  22:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  23:</span>     TeardownComboBoxEvents();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  24:</span>     comboBox.SelectedItem = lookup;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  25:</span>     Application.DoEvents();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  26:</span>     SetupComboBoxEvents();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  27:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    It’s all correct… each method is calling SetSelectedItem with the right combobox and the right lookup object.
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    “That Was Easy”
                  </h3>
                  
                  <p>
                    This is quite possibly the most basic of useful macros that I could imagine… yet look how powerful it was. It prevented me from having to copy & paste and then change all the variable names to the correct ones, or re-type the same thing over and over again. I’m not even using anything more than some very basic movements in that macro: move 2 words, change 3 words, move to the end of the line… those are the only movements I’m using… no special cool extra awesome sauce here… just some simple ‘move my cursor a few paces’. Because the code I was working with had a regular pattern to it, I was able to easily craft a macro that accounted for the contextual differences in each of the methods that needed to be changed.
                  </p>
                  
                  <p>
                    If you’re still not sold on the power of Vim/ViEmu… well… have fun with those 90+ extra keystrokes. I’ll keep my Vim/ViEmu, thankyouverymuch. 🙂
                  </p>