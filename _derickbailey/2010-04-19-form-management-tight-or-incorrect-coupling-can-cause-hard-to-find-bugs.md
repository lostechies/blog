---
wordpress_id: 142
title: 'Form Management: Tight Or Incorrect Coupling Can Cause Hard To Find Bugs'
date: 2010-04-19T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/04/19/form-management-tight-or-incorrect-coupling-can-cause-hard-to-find-bugs.aspx
dsq_thread_id:
  - "262068624"
categories:
  - .NET
  - AntiPatterns
  - AppController
  - 'C#'
  - Compact Framework
  - Principles and Patterns
---
A coworker and I ran into this code in some of our WinForms in our Compact Framework (.net 3.5) application:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> LaunchForm: Form</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #008000">//a bunch of other form/view related stuff</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> Login()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>         LoginForm loginForm = <span style="color: #0000ff">new</span> LoginForm();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>         loginForm.Owner = <span style="color: #0000ff">this</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>         DialogResult result = loginForm.ShowDialog();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>         DialogResult = result;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>     }</pre>
    
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
    
    <pre><span style="color: #606060">  14:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> LoginForm: Form</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>     <span style="color: #008000">//a bunch of other form/view related stuff</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span>     </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> Completed()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  20:</span>         DialogResult = DialogResult.OK;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  21:</span>         ShowRolesForm form = <span style="color: #0000ff">new</span> ShowRolesForm();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  22:</span>         form.ShowDialog();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  23:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  24:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        Can you spot the bug? No, it’s not some style issue or architectural best practice… there is an application-crashing bug in this code.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        A Memory Leak And An Exception
      </h3>
      
      <p>
        According to <a href="http://msdn.microsoft.com/en-us/library/c7ykbedk.aspx">the MSDN documentation</a>, setting the DialogResult of a dialog modal window will cause the ShowDialog call to return the value but will not cause the form to close. Instead, it just hides the form. Since the LoginForm is immediately calling out to the ShowRolesForm form after setting the DialogResult, the LoginForm is still held in memory because the ShowRolesForm form is blocking the LoginForm’s thread and it can’t exit.
      </p>
      
      <p>
        This causes two problems:
      </p>
      
      <ol>
        <li>
          <strong>Memory Leak:</strong> Until ShowRolesForm closes or returns a DialogResult, LoginForm is held in memory… if ShowRolesForm is the main window that the user interacts with, you essentially have a memory leak with the LoginForm still being around
        </li>
        <li>
          <strong>Exception:</strong> ShowDialogForm still returns it’s result immediately when LoginForm set it’s own DialogResult value. When LaunchForm receives that value it tries to set it’s own DialogResult value. But since LoginForm is still alive and is still parented by LaunchForm, LaunchForm is not allowed to set a dialog result yet – the runtime thinks that LoginForm is still the top most dialog stack which causes LaunchForm to throw an exception when it tries to set it’s DialogResult, crashing the app.
        </li>
      </ol>
      
      <p>
        &#160;
      </p>
      
      <h3>
        Decouple Your Workflow From Your Forms
      </h3>
      
      <p>
        The solution to this situation is fairly straightforward: <a href="http://www.lostechies.com/blogs/derickbailey/archive/2009/04/18/decoupling-workflow-and-forms-with-an-application-controller.aspx">decouple the workflow</a> of <a href="http://www.lostechies.com/blogs/derickbailey/archive/2010/04/12/coupling-is-your-friend.aspx">your system from the forms in your system</a>. I’ve talked about this process a number of times on my blog and you can read all my posts on the <a href="http://www.lostechies.com/blogs/derickbailey/archive/tags/AppController/default.aspx">Application Controller</a> for information on how to go about doing this from a larger perspective.
      </p>
      
      <p>
        In this particular case, a simple object to control the flow between LaunchForm, LoginForm and ShowRolesForm will do what we need. Each form should make sure to .Close() itself before setting the DialogResult.
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> SomeWorkflowService</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Run()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>         var launchForm = <span style="color: #0000ff">new</span> LaunchForm();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>         var launchResult = launchForm.ShowDialog();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>         launchForm.Dispose();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>         </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>         <span style="color: #008000">//do something to check the launchResult here and determine</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>         <span style="color: #008000">//if we need to go on</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>         </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>         var loginForm = <span style="color: #0000ff">new</span> LoginForm();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>         var loginResult = loginForm.ShowDialog();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span>         loginForm.Dispose();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  15:</span>         </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  16:</span>         <span style="color: #008000">//do something to check the loginResult here and determine</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  17:</span>         <span style="color: #008000">//if we need to go on</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  18:</span>         </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  19:</span>         var showRolesForm = <span style="color: #0000ff">new</span> ShowRolesForm();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  20:</span>         var showRolesResult = showRolesForm.ShowDialog();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  21:</span>         showRolesForm.Dispose();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  22:</span>         </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  23:</span>         <span style="color: #008000">//do something with the showRolesResult here</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  24:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  25:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              If you are using a form management class (something I haven’t talked about yet, but am planning to do), make sure the form manager is calling .Dispose() on the form that returned a dialog result.
            </p>