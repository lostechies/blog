---
wordpress_id: 118
title: .NET Stack Traces And Anonymous Methods
date: 2010-03-19T21:05:06+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/03/19/net-stack-traces-and-anonymous-methods.aspx
dsq_thread_id:
  - "262068506"
categories:
  - .NET
  - 'C#'
  - Debugging
  - Stack Trace
---
I learned a little more about stack traces in .NET today… in a very painful manner… but, lesson learned! Hopefully someone else will be able to learn this lesson without having to spend 4 hours on it like I did. Take a look at this stack trace that I was getting in my Compact Framework app, today:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> System.NullReferenceException</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span>       Message=<span style="color: #006080">"NullReferenceException"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>       StackTrace:</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>            at TrackAbout.Mobile.UI.CustomControls.TABaseUserControl.&lt;EndInit&gt;b__8(Object o, EventArgs e)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>            at System.ComponentModel.Component.Dispose(Boolean disposing)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>            at System.Windows.Forms.Control.Dispose(Boolean disposing)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>            at TrackAbout.Mobile.UI.Views.BaseForms.TAForm.Dispose(Boolean disposing)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>            at TrackAbout.Mobile.UI.Views.GeneralActions.SetExpirationDateView.Dispose(Boolean disposing)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>            at System.ComponentModel.Component.Dispose()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>            etc.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>            etc.</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>            ...</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        In this stack trace, on line 4, is one very important detail: an anonymous method signature and the parent method that defines it. After several hours of debugging and finally turning on the “catch all” feature for CLR exceptions in Visual Studio, I discovered that line 4 actually translates to this code:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">virtual</span> <span style="color: #0000ff">void</span> EndInit()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     ParentForm = FormUtils.GetParentFormOf(<span style="color: #0000ff">this</span>) <span style="color: #0000ff">as</span> TAForm;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">if</span> (ParentForm == <span style="color: #0000ff">null</span>) <span style="color: #0000ff">return</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>     ParentForm.Closing += FormClose;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>     ParentForm.Activated += (o, e) =&gt; ParentActivatedHandler(o, e);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>     ParentForm.Deactivate += (o, e) =&gt; ParentDeactivateHandler(o, e);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>     ParentForm.Disposed += (o, e) =&gt; ParentDisposedHandler(o, e); </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>     <span style="color: #0000ff">if</span> (ControlEndInit != <span style="color: #0000ff">null</span>)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>         ControlEndInit(<span style="color: #0000ff">this</span>, EventArgs.Empty);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  15:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              Let me translate this line stack trace into this method… the namespace in the stacktrace is obvious… so is the username. The first part to note is the <strong><EndInit></strong>. Apparently this means that the EndInit method contains the code that is throwing the exception, but is not actually firing the code that is causing the exception. The next part is where we find what is throwing the exception. Apparently <strong>b__8(Object o, EventArgs e)</strong> tells me that the failing code in question is an anonymous method. The CLR naming of this method seems cryptic, but also seems like it might be something useful…
            </p>
            
            <p>
              Examining the entire method call: <strong>TrackAboutControl.<EndInit>b__8(Object o, EventArgs e) w</strong>hat I understand this to be saying is “The EndInit method is defining an anonymous method with a standard event signature at line 8 of the method.” Now I’m not entire sure that “line 8 of the method” is what this anonymous method name means… but it fits in this case… it matches up to the line that was causing the problem.
            </p>
            
            <p>
              The problem in this specific case was that this line had a null reference: <strong>ParentForm.Disposed += (o, e) => ParentDisposedHandler(o, e);</strong>
            </p>
            
            <p>
              The ParentDisposedHandler is defined as an event earlier in the class, and since it had no subscribers, it was null. That was easy to fix… just add a null ref check or define the event with a default value of “= delegate{ }”.
            </p>
            
            <p>
              So… 4 hours into debugging this issue, it turned out to be 1 line of anonymous method calls. The stack trace was cryptic and confusing to me at first. I hope to retain this lesson and hope to be able to pass this on to someone else that sees a cryptic stack trace such as this, and same someone the same heartache and headache that I went through today.
            </p>