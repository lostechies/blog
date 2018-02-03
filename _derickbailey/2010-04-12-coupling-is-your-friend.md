---
wordpress_id: 136
title: Coupling Is Your Friend
date: 2010-04-12T21:59:29+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/04/12/coupling-is-your-friend.aspx
dsq_thread_id:
  - "266390768"
categories:
  - .NET
  - AntiPatterns
  - AppController
  - 'C#'
  - Principles and Patterns
  - Workflow
---
[My SOLID article in Code Magazine](http://www.code-magazine.com/Article.aspx?quickid=1001061) talks about the concept of coupling as one of the object oriented principles that we are striving to get right. 

> “_Coupling is not inherently evil. If you don’t have some amount of coupling, your software will not do anything for you. You need well-known points of interaction between the pieces of your system. Without them, you cannot create a system of parts that can work together, so you should not strive to eliminate coupling entirely. Rather, your goal in software development should be to attain the correct level of coupling while creating a system that is functional, understandable (readable by humans), and maintainable._” (originally published in the [Jan/Feb 2010 issue of CODE Magazine](http://www.code-magazine.com/DisplayIssue.aspx?id=07eb54e6-16c1-4681-8d5e-824096a6f77a))

I was reminded of this today, during a conversation with some coworkers when we realized that our efforts to decouple several screens from each other had led us to very tightly couple the workflow of the process we were implementing with the screen in that process. Be careful not to miss out on some important modeling opportunities in your efforts to decouple your system. You may end up decoupling the original pieces that you were concerned with only to end up coupling those same pieces to something that should have been made explicit.

In our specific instance we were having problems getting data from one screen to another. Each of our screens was decoupled from the next via calls out to the [application controller](http://www.lostechies.com/blogs/derickbailey/archive/2009/12/22/understanding-the-application-controller-through-object-messaging-patterns.aspx). For example:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Login()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     ApplicationController.Execute&lt;Login&gt;();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        This would open the Login screen from a button click on another screen.
      </p>
      
      <p>
        We were having problems figuring out how to get the login information back to the calling screen because the Execute method has no return value. We could have used the event aggregator with the .Raise method on the app controller, but this seems a little hackish. Why should we have to call out to a third party object just to get a return value from should rightfully be a simple method call? In the end we realized that we were so concerned with decoupling the screens from each other that we missed the opportunity to correctly model the processes that we were dealing with. By introducing an object that property encapsulated the process of calling out to the login screen and <a href="http://www.lostechies.com/blogs/derickbailey/archive/2009/05/19/result-lt-t-gt-directing-workflow-with-a-return-status-and-value.aspx">handling the results</a> of the login effort we were able to resolve the issues, maintain the decoupling between the forms and create <a href="http://www.lostechies.com/blogs/derickbailey/archive/2010/03/19/a-response-concerning-semantics-and-intention-revealing-code.aspx">a more explicit model</a> and body of knowledge within our code.
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> StartupController()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     <span style="color: #008000">//pass dependencies in through the constructor, here</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Run()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>         RunLaunch();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>     </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> RunLaunch()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>         var launchResult = _launch.Run();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>         <span style="color: #0000ff">switch</span> (launchResult.Data)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span>         {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  15:</span>             <span style="color: #0000ff">case</span> LaunchActions.Login:</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  16:</span>             {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  17:</span>                 RunLogin();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  18:</span>             }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  19:</span>             <span style="color: #008000">//other actions here</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  20:</span>         }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  21:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  22:</span>     </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  23:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> RunLogin()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  24:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  25:</span>         var loginResult = _login.Run();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  26:</span>         <span style="color: #0000ff">switch</span> (loginResult.Data)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  27:</span>         {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  28:</span>             <span style="color: #0000ff">case</span> LoginActions.Cancel:</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  29:</span>             {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  30:</span>                 RunLaunch();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  31:</span>             }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  32:</span>             <span style="color: #008000">//other actions here</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  33:</span>         }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  34:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  35:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              Our efforts to decouple the screens were misguided because we were stuck with the mentality of “decouple this code” when we should have had the mentality of “couple this code correctly”. Once we got past this mental block, though, our problems were easy to solve.
            </p>