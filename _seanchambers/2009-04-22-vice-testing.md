---
id: 3193
title: ‘Vice’ Testing
date: 2009-04-22T03:55:00+00:00
author: Sean Chambers
layout: post
guid: /blogs/sean_chambers/archive/2009/04/21/vice-testing.aspx
dsq_thread_id:
  - "268123860"
categories:
  - Uncategorized
---
Refactoring to tests is no easy task. The largest problem that you run into is moving around code with no feedback as to whether you are breaking modules other than doing very high level user/functional testing directly against the UI. This makes the first step of refactoring to tests the most difficult to take.

Before I begin describing the technique at hand I would like to prefix it with a disclaimer and a warning: **DO NOT** use this to replace actual unit tests. This type of testing should **ONLY** be used as a baseline so that you can start to do larger refactorings that could potentially break portions of code. This gives you the start of a safety net, albeit a pretty flimsy one.

Awhile back [Joe Ocampo](/blogs/joe_ocampo/default.aspx) mentioned a technique that Michael Feathers called &lsquo;vice&rsquo; testing. I recently came across an [article on infoq where Ian Roughley calls it Logging Seam Testing](http://www.infoq.com/articles/Utilizing-Logging). At the core, it&rsquo;s the same thing just named a little differently. The article on infoq is in java, so I created a utility to do the same thing in c# that you can find in my [github repository here](http://github.com/schambers/vice/tree/master). Here is a [direct download link to a zip archive](http://github.com/schambers/vice/zipball/master).

This is quite the interesting technique. One thing to note: I have yet to use this technique myself, so please take it with a grain of salt. Seems like this could work well for extremely tightly coupled, monolithic code and wouldn&rsquo;t necessarily fit for every scenario. I could see this being a good fit while trying to reduce cyclomatic complexity or breaking large methods/classes into smaller ones. That being said, let&rsquo;s dive in.

The basic idea here is you want to get some form of tests into your code, but it&rsquo;s much too difficult to break dependencies and create seams to get unit tests in. That&rsquo;s where vice testing comes in. It&rsquo;s actually very simple and straightforward. The process goes like this.

  1. Determine what it is that you want to test, in this sample its the amount of deductions and the amount paid to an employee via an Employee.Pay method
  2. Insert logging statements in your production code that simply log internal state of an object. In the example it is deduction total, salary and &lsquo;completed&rsquo;
  3. Write a test that sets up the class under test, intializes the log4net logger, sets the expectations to be met
  4. Execute the method on the class under test and assert that all expectations were met via the ViceAppender class

First let&rsquo;s look at the actual test code that would do the work for us: 

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> [TestFixture]</pre>
    
    <pre><span class="lnum">   2:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> EmployeeTests</pre>
    
    <pre><span class="lnum">   3:</span> {</pre>
    
    <pre><span class="lnum">   4:</span>     <span class="kwrd">private</span> ViceAppender _viceAppender;</pre>
    
    <pre><span class="lnum">   5:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   6:</span>     [TestFixtureSetUp]</pre>
    
    <pre><span class="lnum">   7:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> TestFixtureSetUp()</pre>
    
    <pre><span class="lnum">   8:</span>     {</pre>
    
    <pre><span class="lnum">   9:</span>         _viceAppender = <span class="kwrd">new</span> ViceAppender(<span class="kwrd">new</span> log4net.Layout.SimpleLayout());</pre>
    
    <pre><span class="lnum">  10:</span>         log4net.Config.BasicConfigurator.Configure(_viceAppender);</pre>
    
    <pre><span class="lnum">  11:</span>     }</pre>
    
    <pre><span class="lnum">  12:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  13:</span>     [Test]</pre>
    
    <pre><span class="lnum">  14:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> employee_is_paid_expected_amount()</pre>
    
    <pre><span class="lnum">  15:</span>     {</pre>
    
    <pre><span class="lnum">  16:</span>         _viceAppender.AddVerification(<span class="str">"deduction total="</span> + 70m);</pre>
    
    <pre><span class="lnum">  17:</span>         _viceAppender.AddVerification(<span class="str">"salary="</span> + 330m);</pre>
    
    <pre><span class="lnum">  18:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  19:</span>         IList&lt;<span class="kwrd">decimal</span>&gt; _deductions = <span class="kwrd">new</span> List&lt;<span class="kwrd">decimal</span>&gt;();</pre>
    
    <pre><span class="lnum">  20:</span>         _deductions.Add(50m);</pre>
    
    <pre><span class="lnum">  21:</span>         _deductions.Add(20m);</pre>
    
    <pre><span class="lnum">  22:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  23:</span>         var employee = <span class="kwrd">new</span> Employee(400m, _deductions);</pre>
    
    <pre><span class="lnum">  24:</span>         employee.Pay();</pre>
    
    <pre><span class="lnum">  25:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  26:</span>         _viceAppender.PrintExpectations();</pre>
    
    <pre><span class="lnum">  27:</span>         Assert.IsTrue(_viceAppender.Verify(), <span class="str">"Expectations not met"</span>);</pre>
    
    <pre><span class="lnum">  28:</span>     }</pre>
    
    <pre><span class="lnum">  29:</span> }</pre>
  </div>
</div>

  
In the example you can see that I am initializing a log4net logger and setting some configuration on it. Then you setup verifications on the ViceAppender class that matches expectations added to your class along with the expected internal state that will result from the input.

Here is the Pay method from the Employee class: 

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">private</span> ILog _log = LogManager.GetLogger(<span class="kwrd">typeof</span>(Employee));</pre>
    
    <pre><span class="lnum">   2:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   3:</span> <span class="kwrd">public</span> <span class="kwrd">void</span> Pay()</pre>
    
    <pre><span class="lnum">   4:</span> {</pre>
    
    <pre><span class="lnum">   5:</span>     <span class="rem">// bunch of code outside the scope of this test</span></pre>
    
    <pre><span class="lnum">   6:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   7:</span>     <span class="kwrd">foreach</span> (var deduction <span class="kwrd">in</span> _deductions)</pre>
    
    <pre><span class="lnum">   8:</span>         _salaryPerWeek -= deduction;</pre>
    
    <pre><span class="lnum">   9:</span>         </pre>
    
    <pre><span class="lnum">  10:</span>     _log.Info(<span class="str">"deduction total="</span> + _deductions.Sum());</pre>
    
    <pre><span class="lnum">  11:</span>     _log.Info(<span class="str">"salary="</span> + _salaryPerWeek);</pre>
    
    <pre><span class="lnum">  12:</span>     _log.Info(<span class="str">"completed"</span>);</pre>
    
    <pre><span class="lnum">  13:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  14:</span>     <span class="rem">// more code we don't want to test right now</span></pre>
    
    <pre><span class="lnum">  15:</span> }</pre>
  </div>
</div>

Now that we have the expected output, you can now assert what was dumped to a log file and determine if your tests are passing or not. This is achieved pretty easily with a simple Expectation class and a derived Appender class that is called ViceAppender. We have a &lsquo;Verify&rsquo; method here that will iterate over the logging statements using the message as a key and see if the expected message is actually in the logger. The verify method returns a boolean to indicate if all expectations were met during the test run. The message is used as the key on a dictionary. Therefore the message needs to match exactly in order to match an expectation.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">bool</span> Verify()</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">bool</span> result = <span class="kwrd">true</span>;</pre>
    
    <pre><span class="lnum">   4:</span>     <span class="kwrd">foreach</span> (<span class="kwrd">string</span> key <span class="kwrd">in</span> _verifications.Keys)</pre>
    
    <pre><span class="lnum">   5:</span>         <span class="kwrd">if</span> (!_verifications[key].WasCalled)</pre>
    
    <pre><span class="lnum">   6:</span>             result = <span class="kwrd">false</span>;</pre>
    
    <pre><span class="lnum">   7:</span>&nbsp; </pre>
    
    <pre><span class="lnum">   8:</span>     <span class="kwrd">return</span> result;</pre>
    
    <pre><span class="lnum">   9:</span> }</pre>
  </div>
</div>

  
Also on the ViceAppender I have the PrintExpectations() method that outputs the expectations to the Console: 

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">void</span> PrintExpectations()</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">foreach</span> (<span class="kwrd">string</span> message <span class="kwrd">in</span> _verifications.Keys)</pre>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <pre><span class="lnum">   5:</span>         var sb = <span class="kwrd">new</span> StringBuilder();</pre>
    
    <pre><span class="lnum">   6:</span>         sb.Append(<span class="str">"Logger called '"</span>)</pre>
    
    <pre><span class="lnum">   7:</span>             .Append(message)</pre>
    
    <pre><span class="lnum">   8:</span>             .Append(<span class="str">"'. Was Called? '"</span>)</pre>
    
    <pre><span class="lnum">   9:</span>             .Append(_verifications[message].WasCalled)</pre>
    
    <pre><span class="lnum">  10:</span>             .Append(<span class="str">"'"</span>);</pre>
    
    <pre><span class="lnum">  11:</span>&nbsp; </pre>
    
    <pre><span class="lnum">  12:</span>         Console.WriteLine(sb.ToString());</pre>
    
    <pre><span class="lnum">  13:</span>     }</pre>
    
    <pre><span class="lnum">  14:</span> }</pre>
  </div>
</div>

Produces the following output:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> Logger called <span class="str">'deduction total=70'</span>. Was Called? <span class="str">'True'</span></pre>
    
    <pre><span class="lnum">   2:</span> Logger called <span class="str">'salary=330'</span>. Was Called? <span class="str">'True'</span></pre>
  </div>
</div>

The benefit from doing this type of testing is no modification of the class under test needs to take place. All you need to add is logging statements and a field for getting at the ILog instance. This gives you a solid foundation to begin doing refactoring.

This could be viewed as integration tests as well as unit testing because your class under test may leak into other portions of code. Make sure you make your scope of your test as narrow as possible to combat the problem. This is a good place to start, but use wisely. It&rsquo;s not meant to be a long term solution and can be abused just like any other technique.

After typing out some code and playing with it for awhile, You could get this to work without even using a logging utility and just make one yourself. The java example on infoq used the java equivalent of log4net so I did the same here. One other thing I left out was that Ian in his infoq article had the ability to assert on expectations that were called when not expected. While this is a good feature, I decided it was a little overkill for a simple example and left it out for brevity.