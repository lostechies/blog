---
wordpress_id: 3341
title: Ignoring Testing can be Explained, but Never Excused
date: 2009-01-26T13:11:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/01/26/ignoring-testing-can-be-explained-but-never-excused.aspx
dsq_thread_id:
  - "262174723"
categories:
  - Best Practices
  - Testing
---
 <img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;margin: 0px 0px 5px 10px;border-right-width: 0px" alt="gears2" src="//lostechies.com/chrismissal/files/2011/03/gears2_722BEA3B.jpg" width="285" align="right" border="0" height="338" />Many individuals that practice software development will tell you the same thing; testing is vital. I&rsquo;ve never worked at a place that &ldquo;requires&rdquo; <a title="Development Cycle" href="http://en.wikipedia.org/wiki/Test-driven_development#Test-Driven_Development_Cycle" target="_blank">automated testing</a>. Any of the testing that we&rsquo;ve automated was put in place as a way for our team to check ourselves. Those who have implemented it have understood its importance, and put something in place to benefit from it. In these cases, something is better is nothing. What I have dealt with at some jobs is testing as a manual process by the developer (and/or supervisors) to run the application and &ldquo;eye-ball&rdquo; the results. This isn&rsquo;t how testing should work, definitely not how automated testing works and how dare you even bring up the term TDD! 

If you don&rsquo;t have a build server (with an assumed automated test suite) or have a project for tests, or have unit tests at all, there may be reasons for this. **These reasons may be explained, but are never excused**. I&rsquo;ve heard or read the following:

  * Writing tests takes too long. 
  * Writing tests is hard. 
  * It&rsquo;s not my job to test. 
  * I&rsquo;m in a small shop. We don&rsquo;t do that. &#8212; or &#8212; It&rsquo;s only me on this project. I don&rsquo;t need tests. 

These are valid explanations, but they fail to address the reason that testing doesn&rsquo;t work for you. It&rsquo;s not the fault of testing, it&rsquo;s the fault of the situation you&rsquo;ve put yourself in or gotten yourself into.

### Writing Tests Takes Too Long

Tests do not take long to write. They&rsquo;re usually no more than a dozen lines of code per test. This excuse can easily be refuted by the fact that tests _should_ be quick to write. If they&rsquo;re not quick and easy, it&rsquo;s because your code base is composed of <a title="Testable code is is FAR BETTER than untestable code" href="/blogs/chrismissal/archive/2009/01/15/testing-your-code-to-test-yourself.aspx" target="_blank">code that is not testable</a>. If this is the case there are probably bigger problems with your project than the lack of tests. You&rsquo;ll need to look to <a title="Pablo's Topic of the Month - March: SOLID Principles" href="/blogs/chad_myers/archive/2008/03/07/pablo-s-topic-of-the-month-march-solid-principles.aspx" target="_blank">SOLID principles</a> to increase the quality of your code. This needs to be a pre-requisite to building or maintaining any project.

> _Explained due to lack of project structure or poor code._

### Writing Tests is Hard

Look for the most simple method you have in your project and write a test for it. You now have a way to ensure that this method works as expected when any other part of your project is changed.

<pre style="background: black;font-size:125%"><span style="background: black none repeat scroll 0% 0%;color: white">        </span><span style="background: black none repeat scroll 0% 0%;color: #ff8000">public bool </span><span style="background: black none repeat scroll 0% 0%;color: white">IsPreferredCustomer()<br />        {<br />            </span><span style="background: black none repeat scroll 0% 0%;color: #ff8000">if </span><span style="background: black none repeat scroll 0% 0%;color: white">(IsLifetimePreferred)<br />                </span><span style="background: black none repeat scroll 0% 0%;color: #ff8000">return true</span><span style="background: black none repeat scroll 0% 0%;color: white">;<br /><br />            </span><span style="background: black none repeat scroll 0% 0%;color: #ff8000">if </span><span style="background: black none repeat scroll 0% 0%;color: white">(ClubExpirationDate &lt; </span><span style="background: black none repeat scroll 0% 0%;color: #2b91af">DateTime</span><span style="background: black none repeat scroll 0% 0%;color: white">.Now)<br />                </span><span style="background: black none repeat scroll 0% 0%;color: #ff8000">return true</span><span style="background: black none repeat scroll 0% 0%;color: white">;<br /><br />            </span><span style="background: black none repeat scroll 0% 0%;color: #ff8000">return false</span><span style="background: black none repeat scroll 0% 0%;color: white">;<br />        }<br /></span></pre>

[](http://11011.net/software/vspaste)

Three simple tests can be written to ensure that this method does exactly what it is supposed to do. You create methods that checks each path through the method and asserts that the expected result is equal to the actual result.

> _Explained by lack of experience or laziness._

### It&rsquo;s not my Job to Test

Maybe the word &ldquo;test&rdquo; or &ldquo;tester&rdquo; is not in your job title. This doesn&rsquo;t excuse you from testing your code. You probably test it visually before handing it off or checking it in anyway. Why not write code that tests it? If you make changes later, you can ensure that you&rsquo;re not breaking previously tested code that worked. If at the very least, when you said in August that your code worked and now you added/modified something and it now &ldquo;isn&rsquo;t working&rdquo;, you&rsquo;ll be the first to know and the first to have the chance to fix it before handing it off to another team or even worse, a supervisor.

> _Explained by lack of commitment or carelessness._

### I Work in a Small Shop or I&rsquo;m the Only One on the Project

The problems with this argument are:

  1. You could be making yourself look bad. Even if you&rsquo;re doing a small project on your own. You probably want to ensure that your code is checked by itself. If you perform the development for a project and a year later the client hires somebody else to add to or modify your code. You have somewhat of a &ldquo;proof&rdquo; that your code works the way it should. This makes you a bit more credible for future work. 
  2. You also should add tests to your project because you care about your fellow developer. Have you ever been thrown head-first into a project to &ldquo;fix it&rdquo; and the project has no tests? You might be wanting to jump off a cliff instead. You have no idea what your changes will break because there is no guarantee that the code you modify isn&rsquo;t going to break working pieces of code. Adding tests is a way of paying it forward. Unfortunately for me, I&rsquo;ve never picked up a project that had previous tests in place. If I ever do, I will contact as many of the previous developers as possible and send them a thank you card! 

There is no reason a small team shouldn&rsquo;t be as confident of their code as a team of hundreds, or even thousands. Whether you&rsquo;re working on a project of <a title="Diseconomies of Scale and Lines of Code" href="http://www.codinghorror.com/blog/archives/000637.html" target="_blank">3,000 Lines of Code or 3,000,000 LOC</a>, the project is only as good as the work put into it.

> _Explained through the falsehood that small teams are not responsible for quality work._

### Have You Heard Enough Yet?

I feel like I&rsquo;m beating a dead horse. I also feel like <a title="When Should I Write Tests?" href="http://stevenharman.net/blog/archive/2008/12/17/when-should-i-write-tests.aspx" target="_blank">those who advocate testing</a> are also the only ones that have taken it up and actually done it. I&rsquo;ve never read an article by, or talked to a single person who has done unit testing successfully and not advocated it as being extremely important. Once you open Pandora&rsquo;s box, you can&rsquo;t go back; if you&rsquo;re testing, you don&rsquo;t know what you&rsquo;re missing.