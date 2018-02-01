---
id: 113
title: 'Semantic Code: Migrating From A Chatty Interface To A Simple One With A Data Transfer Object'
date: 2010-03-15T18:40:45+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/03/15/semantic-code-migrating-from-a-chatty-interface-to-a-simple-one-with-a-data-transfer-object.aspx
dsq_thread_id:
  - "262068513"
categories:
  - .NET
  - Analysis and Design
  - 'C#'
  - Principles and Patterns
---
I’ve worked on several C#/Compact Framework/WinForms projects for handheld devices over the years – most of which have involved a require for users wearing gloves to be able to type on a virtual keyboard. It’s not terribly difficult to implement this from a functional / UI standpoint and there are probably some controls that can be purchased to do this. In one particular project, though, we had a custom virtual keyboard abstracted through an interface with 8 write-only properties used for the various options in the keyboard, and a read-write property for the text being input (it allows you to specify an existing value or start with an empty value). That interface definition looked like this:</p> 

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IVirtualKeyboard</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">void</span> Run();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">string</span> InputText { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     KeyboardMode KeyboardMode { set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">int</span> MaxInputLength { set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>     <span style="color: #0000ff">bool</span> AllowSwitch { set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>     <span style="color: #0000ff">bool</span> ShowCancelInsteadOfSwitch { set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>     <span style="color: #0000ff">string</span> SpecialCharacters { set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>     KeyboardEmptyValueHandlingOptions EmptyValueHandlingOption { set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>     <span style="color: #0000ff">string</span> ValidationMessage { set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>     ISpecification&lt;<span style="color: #0000ff">string</span>&gt; ValidationSpecification { set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        This interface got the job done. It provided all of the needed functionality and configuration options for the virtual keyboard to operate as expected. But it did so in a very chatty manner – far too many properties were being set on the interface directly, causing the interface to be less understandable than it should be.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        Separate Functionality From Configuration With A DTO
      </h3>
      
      <p>
        If the majority of the properties on this interface are write-only, why not make this interface a lot less chatty and provide a simple data transfer object (DTO) for the options? The IVirtualKeyboard interface becomes much easier to understand when changed like this:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IVirtualKeyboard</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">void</span> Run();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">string</span> InputText { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">void</span> Configure(VirtualKeyboardOptions options);</pre>
          
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
          
          <pre><span style="color: #606060">   8:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> VirtualKeyboardOptions</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>     KeyboardMode KeyboardMode { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>     <span style="color: #0000ff">int</span> MaxInputLength { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>     <span style="color: #0000ff">bool</span> AllowSwitch { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>     <span style="color: #0000ff">bool</span> ShowCancelInsteadOfSwitch { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span>     <span style="color: #0000ff">string</span> SpecialCharacters { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  15:</span>     KeyboardEmptyValueHandlingOptions EmptyValueHandlingOption { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  16:</span>     <span style="color: #0000ff">string</span> ValidationMessage { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  17:</span>     ISpecification&lt;<span style="color: #0000ff">string</span>&gt; ValidationSpecification { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  18:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              (Note that the properties are no longer write-only. They have to be read by the virtual keyboard’s implementation, so they need to be read-write. )
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              Writing Semantic Code
            </h3>
            
            <p>
              The interface, while easier to understand, still doesn’t provide the ‘self documenting’ type of knowledge that we’re looking for, though. There’s no indication of when the Run method needs to be called vs Configure vs reading / writing the input text. This can be solved by consolidating the interface even further and giving the one remaining method a better name:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IVirtualKeyboard</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">string</span> GetInputWithConfiguration(VirtualKeyboardOptions options);</pre>
                
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
                
                <pre><span style="color: #606060">   6:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> VirtualKeyboardOptions</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   8:</span>     <span style="color: #0000ff">string</span> DefaultText { get; set; }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   9:</span>     KeyboardMode KeyboardMode { get; set; }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  10:</span>     <span style="color: #0000ff">int</span> MaxInputLength { get; set; }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  11:</span>     <span style="color: #0000ff">bool</span> AllowSwitch { get; set; }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  12:</span>     <span style="color: #0000ff">bool</span> ShowCancelInsteadOfSwitch { get; set; }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  13:</span>     <span style="color: #0000ff">string</span> SpecialCharacters { get; set; }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  14:</span>     KeyboardEmptyValueHandlingOptions EmptyValueHandlingOption { get; set; }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  15:</span>     <span style="color: #0000ff">string</span> ValidationMessage { get; set; }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  16:</span>     ISpecification&lt;<span style="color: #0000ff">string</span>&gt; ValidationSpecification { get; set; }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  17:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    The GetInputWithConfiguration method provides a lot more information about what is happening – it provides semantics that indicate what the method is going to do, through its method signature. The name itself and the return type of string gives the developer using the interface knowledge that the virtual keyboard will be configured with the options specified, displayed for input from the user and have the resulting input returned. (Notice that there is also a new DefaultText property on the options class, to specify the default value of the virtual keyboard, if any… a small, but important detail.)
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    What’s The Real Value, Here?
                  </h3>
                  
                  <p>
                    There are several reasons why these changes provide value. Any one reason on its own would not really create enough value to warrant the changes, but when you start adding them together, the benefits become clear.
                  </p>
                  
                  <p>
                    <strong>1. Self Documenting Code</strong>
                  </p>
                  
                  <p>
                    The original interface into the virtual keyboard is not terribly easy to read or understand at first glance. You have to sift through a number of properties to figure out what they are used for, and you may even need to break open the implementation of the code to figure out when to call what. By changing the interface to a single method with a very clear name and an options class as the parameter, the interface semantics and been clarified and its easy to understand at a glance.
                  </p>
                  
                  <p>
                    <strong>2. No Semantic Coupling</strong>
                  </p>
                  
                  <p>
                    Semantic coupling is a horrendous problem because it requires the user of an API to know the implementation of that API. A developer that wishes to use the original virtual keyboard interface may have to dig into the implementation of that interface in order to know when to call which methods and properties. The semantics of code should be provided by the signature of the API, not the implementation. By consolidating the InputText property with the Run and Configure methods, the GetInputWithConfiguration method is achieving this goal – it provides all the information the API user needs without having to dig into the implementation.
                  </p>
                  
                  <p>
                    <strong>3. Changing Options Is Easier</strong>
                  </p>
                  
                  <p>
                    If (when) the options for the virtual keyboard need to change, it will be easier to change them in an options DTO rather than the virtual keyboard interface if for no other reason than the readability of the code. Changes to the options won’t affect the simplicity or readability of the core interface being called. (Note: I had originally thought it would be easier to change from a versioning perspective – fewer places to change, easier to update clients that depend on the interface &#8211; but there is no additional benefit here that I can see, at this point.)
                  </p>
                  
                  <p>
                    <strong>4. Client Code Can Pass Options Around</strong>
                  </p>
                  
                  <p>
                    Any client code that used the original IVirtualKeyboard is required to manually setup the configuration of the virtual keyboard by specifying any value (other than defaults) via the write-only properties. There is no way to setup an group of options and pass that option list around in code. By switching to a DTO, the options list can be set once and used many times. If there are several places in the system that need the same options, a single options class can be setup in one location and all of the places that need that option list can access it without having to map the options to the keyboard’s interface manually. An instance of the VirtualKeyboardOptions class would only need to be available via a mechanism that allows access from the code that needs it (could be IoC, could be static, could be singleton, could be … many different options).
                  </p>
                  
                  <p>
                    <strong>5. Role Specific Interface</strong>
                  </p>
                  
                  <p>
                    Though the origina IVirtualKeyboard interface in this post is already specific to the role being played, there are going to be other cases where a chatty interface is an indication of the need for <a href="http://www.lostechies.com/blogs/derickbailey/archive/2010/03/07/role-specific-interfaces-dip-and-isp-in-action.aspx">role specific interfaces</a>. The code may be easier to understand and additional benefits can be found by separating the various roles that an object plays into explicit interface definitions. (The actual code that I based this post on was in direct need of a role specific interface – the methods and options that I presented here were taken from an IVirtualKeyboardPresenter interface, which had more methods and properties on it in support of the presenter’s needs. I simplified the code in this post for the sake of focusing on the other benefits outlined here.)
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    Other Considerations
                  </h3>
                  
                  <p>
                    There are times when the single DTO as a parameter for configuration just won’t work. Continuing the virtual keyboard example, if the keyboard needs to be reconfigured while it is displayed and in use, then the single method call would likely not work. Methods to change the configuration based on the needs of the scenario would have to be added.
                  </p>
                  
                  <p>
                    There may also be times when a chatty interface is not an issue. For example, a presenter in a model-view-presenter setup may have a large number of methods due to the size and/or complexity of the view that it is running. However, it is usually worth the time and effort to see if a large number of methods and properties can be consolidated or separated into multiple responsibilities. That same MVP setup may be better suited as multiple user controls, each with their own view and presenter, used to compose the final screen with the functionality needed.
                  </p>
                  
                  <p>
                    As with every other tool in the toolbox, be sure that the one you are wielding is being used for the right job in the right context. Not every interface needs to be (or can be) boiled down into a single method call with a DTO.
                  </p>