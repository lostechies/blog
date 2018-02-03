---
wordpress_id: 3937
title: Running jQuery QUnit tests under Continuous Integration
date: 2008-09-18T22:23:54+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2008/09/18/running-jquery-qunit-tests-under-continuous-integration.aspx
dsq_thread_id:
  - "262090914"
categories:
  - JQuery
  - QUnit
  - teamcity
---
**UPDATE:** The code in this post is out of date. Read it for the explanation, but if you want to implement it, go grab <a href="https://github.com/robdmoore/NQUnit" target="_blank">NQUnit</a> via nuget.

## Setup

This post assumes you are already writing unit tests for your JavaScript code. If not, check out Chad&#8217;s post on <a href="http://www.lostechies.com/blogs/chad_myers/archive/2008/08/28/getting-started-with-jquery-qunit-for-client-side-javascript-testing.aspx" target="_blank">Getting Started with jQuery QUnit</a>. We use <a href="http://jquery.com/" target="_blank">jQuery</a> and QUnit at work, so my code examples are geared toward those frameworks. However, the approach should be very easy to adapt to your JavaScript framework of choice. 

## Overview

A good continuous integration server will let you run your automated tests, fail the build if a test fails, and publish a report of the test results. For all of that to work, your CI tool needs to be able to run the tests from a command-line and harvest the output in a form that it understands. One problem is that JavaScript testing frameworks like QUnit require you to open an HTML page in a browser to run and view the test results. You can certainly launch an HTML page in a browser from a command line ("start mypage.htm"), but you won&#8217;t be able to feed the results back to the CI server. We can get around this by using a tool like WatiN to control the browser from NUnit (or some other test framework which is supported by your CI server). WatiN allows you to spawn an instance of Internet Explorer, navigate to a URL, inspect the contents of the rendered DOM, and shutdown the browser, all from within an NUnit test.

## A simple solution

Our first approach was to modify the QUnit test runner script so that it would create an element named TESTRESULTS that held the number of failed tests. We could then run the HTML page containing our tests and use WatiN to verify that TESTRESULTS contained a 0. An entire page of QUnit tests would be reported by NUnit as a single test. Either all of the QUnit tests passed making the single NUnit test pass, or any QUnit test failed and the NUnit test failed. You can see an example of this approach in my comment on Chad’s post referenced earlier. There are two problems with this approach: your total test count is inaccurate (you could have hundreds of QUnit tests which only show up as a single test in the CI test report), and more importantly, it is not immediately obvious which test failed, since it could have been any one of the many QUnit tests within a page.

## Our current approach

A better approach would be to have a single NUnit test for each QUnit test. However, manually writing an NUnit test for each QUnit test sounds like a nightmare. What we need is a way to generate test cases dynamically. MbUnit supports this natively with its Factory attribute. We can get the same behavior in NUnit using the <a href="http://www.nunit.org/index.php?p=iterativeTest" target="_blank">IterativeTest add-in</a> (get the source and compile it against your version of NUnit). It allows you to specify a factory method that supplies a series of values to a single test method. When NUnit loads the class with this test method, it will create a separate test case for each value passed to the test method (if your factory method returns 3 values, you will have 3 test cases).

The full code to our test fixture is at the bottom of this post. The method GetQUnitTestResults takes an HTML page name as input and returns a series of QUnitTest instances. Each QUnitTest instance contains the details of an individual QUnit test run: the filename, the test name, the result, and any related failure message. The method RunQUnitTests is the actual factory method used by the IterativeTest add-in, and allows me to easily add new QUnit HTML pages without having to create new test methods. The gory details of parsing the DOM for the QUnit results are in grabTestResultsFromWebPage. Its not my proudest piece of code, but it gets the job done (for now). This is likely the only method you would need to change if you were using a JavaScript test framework other than QUnit.

Using this approach, we now get an accurate reflection of our test count, as each QUnit test is counted with every other NUnit test. Even better, when a test fails, we get detailed information about exactly which test failed and why. This is the output of a run that has a failing test:

<div>
  <pre>------ Test started: Assembly: DovetailCRM.IntegrationTesting.dll ------

IterativeTest addin loaded.
TestCase <span style="color: #006080">'DovetailCRM.IntegrationTesting.Web.JavaScript.JavaScriptTester.QUnit([tageditortester.htm] Post tag change to server module: should post the tag Name and item Id)'</span>
failed: 
  the item that <span style="color: #0000ff">is</span> tagged expected: 42 actual: 0
  Expected: collection containing <span style="color: #006080">"pass"</span>
  But was:  &lt; <span style="color: #006080">"fail"</span> &gt;
    D:codebluesourceDovetailCRM.IntegrationTestingWebJavaScriptJavaScriptTesters.cs(128,0): at DovetailCRM.IntegrationTesting.Web.JavaScript.QUnitTestHelpers.ShouldPass(QUnitTest theTest)
    D:codebluesourceDovetailCRM.IntegrationTestingWebJavaScriptJavaScriptTesters.cs(29,0): at DovetailCRM.IntegrationTesting.Web.JavaScript.JavaScriptTester.QUnit(Object current)


100 passed, 1 failed, 0 skipped, took 16.48 seconds.</pre>
</div>

## Notes

  * NUnit add-ins must be compiled against the version of NUnit you are using. Make sure you have the same version of NUnit on your developer desktops and the CI server. We standardized on NUnit 2.4.7 simply because that was the latest version supported by <a href="http://www.testdriven.net/" target="_blank">TestDriven.NET</a>.
  * The IterativeTest add-in must be in the _addins_ sub-folder of the folder that contains your nunit-console.exe. If you want to run the tests via TestDriven.NET, you’ll also want to put a copy of the add-in in <ProgramFiles>TestDriven.NET 2.0NUnit2.4addins
  * While there is a way to get the TeamCity custom NUnit runner to load add-ins (using /addin:), I ran into trouble getting it all to work with WatiN as well. I discovered a <a href="http://www.jetbrains.net/confluence/display/TCD4/TeamCity+Addin+for+NUnit" target="_blank">JetBrains add-in for NUnit</a> that allows nunit-console.exe to report progress to TeamCity in the same way as their custom runner. While it isn’t supposed to be available until TeamCity 4.0, I found the necessary files in <a href="http://jetbrains.net/tracker/issue/TW-5104" target="_blank">this patch</a> (see the Attachments section) which enables NUnit 2.4.7 support to TeamCity 3.1.

## The Code

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> [TestFixture]</pre>
    
    <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> JavaScriptTester</pre>
    
    <pre><span style="color: #606060">   3:</span> {</pre>
    
    <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">private</span> IE _ie;</pre>
    
    <pre><span style="color: #606060">   5:</span>&#160; </pre>
    
    <pre><span style="color: #606060">   6:</span>     [TestFixtureSetUp]</pre>
    
    <pre><span style="color: #606060">   7:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> TestFixtureSetUp()</pre>
    
    <pre><span style="color: #606060">   8:</span>     {</pre>
    
    <pre><span style="color: #606060">   9:</span>         _ie = TestBrowser.GetInternetExplorer();</pre>
    
    <pre><span style="color: #606060">  10:</span>     }</pre>
    
    <pre><span style="color: #606060">  11:</span>    </pre>
    
    <pre><span style="color: #606060">  12:</span>     [IterativeTest(<span style="color: #006080">"RunQUnitTests"</span>)]</pre>
    
    <pre><span style="color: #606060">  13:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> QUnit(<span style="color: #0000ff">object</span> current)</pre>
    
    <pre><span style="color: #606060">  14:</span>     {</pre>
    
    <pre><span style="color: #606060">  15:</span>         ((QUnitTest)current).ShouldPass();</pre>
    
    <pre><span style="color: #606060">  16:</span>     }</pre>
    
    <pre><span style="color: #606060">  17:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  18:</span>     <span style="color: #0000ff">public</span> IEnumerable RunQUnitTests()</pre>
    
    <pre><span style="color: #606060">  19:</span>     {</pre>
    
    <pre><span style="color: #606060">  20:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span>[]</pre>
    
    <pre><span style="color: #606060">  21:</span>                    {</pre>
    
    <pre><span style="color: #606060">  22:</span>                        <span style="color: #006080">"ContextMenuTester.htm"</span>,</pre>
    
    <pre><span style="color: #606060">  23:</span>                        <span style="color: #006080">"FilterControlTester.htm"</span>,</pre>
    
    <pre><span style="color: #606060">  24:</span>                        <span style="color: #006080">"RepeaterControlTester.htm"</span>,</pre>
    
    <pre><span style="color: #606060">  25:</span>                        <span style="color: #006080">"FinderTester.htm"</span>,</pre>
    
    <pre><span style="color: #606060">  26:</span>                        <span style="color: #006080">"ConsoleScriptTester.htm"</span>,</pre>
    
    <pre><span style="color: #606060">  27:</span>                        <span style="color: #006080">"tageditortester.htm"</span>,</pre>
    
    <pre><span style="color: #606060">  28:</span>                        <span style="color: #006080">"CrudFormTester.htm"</span></pre>
    
    <pre><span style="color: #606060">  29:</span>                    }.SelectMany(page =&gt; GetQUnitTestResults(page));</pre>
    
    <pre><span style="color: #606060">  30:</span>     }</pre>
    
    <pre><span style="color: #606060">  31:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  32:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  33:</span>     <span style="color: #0000ff">public</span> IEnumerable&lt;QUnitTest&gt; GetQUnitTestResults(<span style="color: #0000ff">string</span> testPage)</pre>
    
    <pre><span style="color: #606060">  34:</span>     {</pre>
    
    <pre><span style="color: #606060">  35:</span>         TestFixtureSetUp();</pre>
    
    <pre><span style="color: #606060">  36:</span>         _ie.GoTo(<span style="color: #0000ff">string</span>.Format(<span style="color: #006080">"http://localhost/Content/scripts/tests/{0}"</span>, testPage));</pre>
    
    <pre><span style="color: #606060">  37:</span>         _ie.WaitForComplete(5);</pre>
    
    <pre><span style="color: #606060">  38:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  39:</span>         <span style="color: #0000ff">return</span> grabTestResultsFromWebPage(testPage);</pre>
    
    <pre><span style="color: #606060">  40:</span>     }</pre>
    
    <pre><span style="color: #606060">  41:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  42:</span>     <span style="color: #0000ff">public</span> IEnumerable&lt;QUnitTest&gt; grabTestResultsFromWebPage(<span style="color: #0000ff">string</span> testPage)</pre>
    
    <pre><span style="color: #606060">  43:</span>     {</pre>
    
    <pre><span style="color: #606060">  44:</span>         <span style="color: #008000">// BEWARE: This logic is tightly coupled to the structure of the HTML generated by the QUnit testrunner</span></pre>
    
    <pre><span style="color: #606060">  45:</span>         <span style="color: #008000">// Also, this could probably be greatly simplified with a couple well-crafted xpath expressions</span></pre>
    
    <pre><span style="color: #606060">  46:</span>         var testOL = _ie.Elements.Filter(Find.ById(<span style="color: #006080">"tests"</span>))[0] <span style="color: #0000ff">as</span> ElementsContainer;</pre>
    
    <pre><span style="color: #606060">  47:</span>         <span style="color: #0000ff">if</span> (testOL == <span style="color: #0000ff">null</span>) <span style="color: #0000ff">yield</span> <span style="color: #0000ff">break</span>;</pre>
    
    <pre><span style="color: #606060">  48:</span>         var documentRoot = XDocument.Load(<span style="color: #0000ff">new</span> StringReader(makeXHtml(testOL.OuterHtml))).Root;</pre>
    
    <pre><span style="color: #606060">  49:</span>         <span style="color: #0000ff">if</span> (documentRoot == <span style="color: #0000ff">null</span>) <span style="color: #0000ff">yield</span> <span style="color: #0000ff">break</span>;</pre>
    
    <pre><span style="color: #606060">  50:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  51:</span>         <span style="color: #0000ff">foreach</span> (var listItem <span style="color: #0000ff">in</span> documentRoot.Elements())</pre>
    
    <pre><span style="color: #606060">  52:</span>         {</pre>
    
    <pre><span style="color: #606060">  53:</span>             var testName = listItem.Elements().First( x =&gt; x.Name.Is(<span style="color: #006080">"strong"</span>)).Value;</pre>
    
    <pre><span style="color: #606060">  54:</span>             var resultClass = listItem.Attributes().First(x =&gt; x.Name.Is(<span style="color: #006080">"class"</span>)).Value;</pre>
    
    <pre><span style="color: #606060">  55:</span>             var failedAssert = String.Empty;</pre>
    
    <pre><span style="color: #606060">  56:</span>             <span style="color: #0000ff">if</span> (resultClass == <span style="color: #006080">"fail"</span>)</pre>
    
    <pre><span style="color: #606060">  57:</span>             {</pre>
    
    <pre><span style="color: #606060">  58:</span>                 var specificAssertFailureListItem = listItem.Elements()</pre>
    
    <pre><span style="color: #606060">  59:</span>                     .First(x =&gt; x.Name.Is(<span style="color: #006080">"ol"</span>)).Elements()</pre>
    
    <pre><span style="color: #606060">  60:</span>                     .First(x =&gt; x.Name.Is(<span style="color: #006080">"li"</span>) && x.Attributes().First(a=&gt; a.Name.Is(<span style="color: #006080">"class"</span>)).Value == <span style="color: #006080">"fail"</span>);</pre>
    
    <pre><span style="color: #606060">  61:</span>                 <span style="color: #0000ff">if</span> (specificAssertFailureListItem != <span style="color: #0000ff">null</span>)</pre>
    
    <pre><span style="color: #606060">  62:</span>                 {</pre>
    
    <pre><span style="color: #606060">  63:</span>                     failedAssert = specificAssertFailureListItem.Value;</pre>
    
    <pre><span style="color: #606060">  64:</span>                 }</pre>
    
    <pre><span style="color: #606060">  65:</span>             }</pre>
    
    <pre><span style="color: #606060">  66:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  67:</span>             <span style="color: #0000ff">yield</span> <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> QUnitTest</pre>
    
    <pre><span style="color: #606060">  68:</span>                              {</pre>
    
    <pre><span style="color: #606060">  69:</span>                                  FileName = testPage,</pre>
    
    <pre><span style="color: #606060">  70:</span>                                  TestName = removeAssertCounts(testName),</pre>
    
    <pre><span style="color: #606060">  71:</span>                                  Result = resultClass, Message = failedAssert</pre>
    
    <pre><span style="color: #606060">  72:</span>                              };</pre>
    
    <pre><span style="color: #606060">  73:</span>         }</pre>
    
    <pre><span style="color: #606060">  74:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  75:</span>     }</pre>
    
    <pre><span style="color: #606060">  76:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  77:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">string</span> makeXHtml(<span style="color: #0000ff">string</span> html)</pre>
    
    <pre><span style="color: #606060">  78:</span>     {</pre>
    
    <pre><span style="color: #606060">  79:</span>         <span style="color: #0000ff">return</span> html.Replace(<span style="color: #006080">"class=pass"</span>, <span style="color: #006080">"class="pass""</span>)</pre>
    
    <pre><span style="color: #606060">  80:</span>             .Replace(<span style="color: #006080">"class=fail"</span>, <span style="color: #006080">"class="fail""</span>)</pre>
    
    <pre><span style="color: #606060">  81:</span>             .Replace(<span style="color: #006080">"id=tests"</span>, <span style="color: #006080">"id="tests""</span>);</pre>
    
    <pre><span style="color: #606060">  82:</span>     }</pre>
    
    <pre><span style="color: #606060">  83:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  84:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  85:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">string</span> removeAssertCounts(<span style="color: #0000ff">string</span> fullTagText)</pre>
    
    <pre><span style="color: #606060">  86:</span>     {</pre>
    
    <pre><span style="color: #606060">  87:</span>         <span style="color: #0000ff">if</span> (fullTagText == <span style="color: #0000ff">null</span>) <span style="color: #0000ff">return</span> String.Empty;</pre>
    
    <pre><span style="color: #606060">  88:</span>         <span style="color: #0000ff">int</span> parenPosition = fullTagText.IndexOf(<span style="color: #006080">'('</span>);</pre>
    
    <pre><span style="color: #606060">  89:</span>         <span style="color: #0000ff">if</span> (parenPosition &gt; 0)</pre>
    
    <pre><span style="color: #606060">  90:</span>         {</pre>
    
    <pre><span style="color: #606060">  91:</span>             <span style="color: #0000ff">return</span> fullTagText.Substring(0, parenPosition - 1);</pre>
    
    <pre><span style="color: #606060">  92:</span>         }</pre>
    
    <pre><span style="color: #606060">  93:</span>         <span style="color: #0000ff">return</span> fullTagText;</pre>
    
    <pre><span style="color: #606060">  94:</span>     }</pre>
    
    <pre><span style="color: #606060">  95:</span> }</pre>
    
    <pre><span style="color: #606060">  96:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  97:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> QUnitTest</pre>
    
    <pre><span style="color: #606060">  98:</span> {</pre>
    
    <pre><span style="color: #606060">  99:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> FileName { get; set; }</pre>
    
    <pre><span style="color: #606060"> 100:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> TestName { get; set; }</pre>
    
    <pre><span style="color: #606060"> 101:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> Result { get; set; }</pre>
    
    <pre><span style="color: #606060"> 102:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> Message { get; set; }</pre>
    
    <pre><span style="color: #606060"> 103:</span>&#160; </pre>
    
    <pre><span style="color: #606060"> 104:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">string</span> ToString()</pre>
    
    <pre><span style="color: #606060"> 105:</span>     {</pre>
    
    <pre><span style="color: #606060"> 106:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">string</span>.Format(<span style="color: #006080">"[{0}] {1}"</span>, FileName, TestName);</pre>
    
    <pre><span style="color: #606060"> 107:</span>     }</pre>
    
    <pre><span style="color: #606060"> 108:</span> }</pre>
    
    <pre><span style="color: #606060"> 109:</span>&#160; </pre>
    
    <pre><span style="color: #606060"> 110:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">class</span> QUnitTestHelpers</pre>
    
    <pre><span style="color: #606060"> 111:</span> {</pre>
    
    <pre><span style="color: #606060"> 112:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">void</span> ShouldPass(<span style="color: #0000ff">this</span> QUnitTest theTest)</pre>
    
    <pre><span style="color: #606060"> 113:</span>     {</pre>
    
    <pre><span style="color: #606060"> 114:</span>         Assert.That(theTest.Result.Split(<span style="color: #006080">' '</span>), Has.Member(<span style="color: #006080">"pass"</span>), theTest.Message);</pre>
    
    <pre><span style="color: #606060"> 115:</span>     }</pre>
    
    <pre><span style="color: #606060"> 116:</span>&#160; </pre>
    
    <pre><span style="color: #606060"> 117:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">bool</span> Is(<span style="color: #0000ff">this</span> XName xname, <span style="color: #0000ff">string</span> name)</pre>
    
    <pre><span style="color: #606060"> 118:</span>     {</pre>
    
    <pre><span style="color: #606060"> 119:</span>         <span style="color: #0000ff">return</span> xname.ToString().Equals(name, StringComparison.OrdinalIgnoreCase);</pre>
    
    <pre><span style="color: #606060"> 120:</span>     }</pre>
    
    <pre><span style="color: #606060"> 121:</span> }</pre></p>
  </div>
</div></p> </p> 

It makes use of our TestBrowser class, which is just a simple wrapper around WatiN’s IE object.

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">class</span> TestBrowser</pre>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">readonly</span> <span style="color: #0000ff">object</span> LOCK_ROOT = <span style="color: #0000ff">new</span> <span style="color: #0000ff">object</span>();</pre>
    
    <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> IE _browser;</pre>
    
    <pre><span style="color: #606060">   5:</span>&#160; </pre>
    
    <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> IE GetInternetExplorer()</pre>
    
    <pre><span style="color: #606060">   7:</span>     {</pre>
    
    <pre><span style="color: #606060">   8:</span>         <span style="color: #0000ff">if</span>( _browser == <span style="color: #0000ff">null</span> )</pre>
    
    <pre><span style="color: #606060">   9:</span>         {</pre>
    
    <pre><span style="color: #606060">  10:</span>             <span style="color: #0000ff">lock</span>(LOCK_ROOT)</pre>
    
    <pre><span style="color: #606060">  11:</span>             {</pre>
    
    <pre><span style="color: #606060">  12:</span>                 <span style="color: #0000ff">if</span>( _browser == <span style="color: #0000ff">null</span> )</pre>
    
    <pre><span style="color: #606060">  13:</span>                 {</pre>
    
    <pre><span style="color: #606060">  14:</span>                     IE.Settings.AutoMoveMousePointerToTopLeft = <span style="color: #0000ff">false</span>;</pre>
    
    <pre><span style="color: #606060">  15:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  16:</span>                     _browser = (IE)BrowserFactory.Create(BrowserType.InternetExplorer);</pre>
    
    <pre><span style="color: #606060">  17:</span>                     _browser.ShowWindow(NativeMethods.WindowShowStyle.Hide);</pre>
    
    <pre><span style="color: #606060">  18:</span>                 }</pre>
    
    <pre><span style="color: #606060">  19:</span>             }</pre>
    
    <pre><span style="color: #606060">  20:</span>         }</pre>
    
    <pre><span style="color: #606060">  21:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  22:</span>         <span style="color: #0000ff">return</span> _browser;</pre>
    
    <pre><span style="color: #606060">  23:</span>     }</pre>
    
    <pre><span style="color: #606060">  24:</span> }</pre></p>
  </div>
</div>