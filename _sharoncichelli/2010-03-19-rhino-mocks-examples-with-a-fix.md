---
wordpress_id: 3863
title: Rhino Mocks Examples, with a fix
date: 2010-03-19T02:35:00+00:00
author: Sharon Cichelli
layout: post
wordpress_guid: /blogs/sharoncichelli/archive/2010/03/18/rhino-mocks-examples-with-a-fix.aspx
dsq_thread_id:
  - "263371005"
categories:
  - Rhino Mocks
  - Unit Testing
redirect_from: "/blogs/sharoncichelli/archive/2010/03/18/rhino-mocks-examples-with-a-fix.aspx/"
---
Jon Kruger created an excellent [explanation of Rhino Mocks, using unit tests](http://jonkruger.com/blog/2010/03/12/how-to-use-rhino-mocks-documented-through-tests/) to demonstrate and illuminate the syntax and capabilities. (Found via [@gar3t](http://twitter.com/gar3t).) It needs one small correction, which I&#8217;d like to write about here so that I can link to and support Jon&#8217;s work, and because it gives the opportunity to clarify a subtle distinction between mocks and stubs and verified expectations.

First, go check out [Jon&#8217;s code](https://github.com/JonKruger/RhinoMocksExamples/raw/master/src/RhinoMocksExamples/RhinoMocksExamples/RhinoMocksTests.cs), then come back here.

The problem lies in the following test. I can comment out the part that looks like it is satisfying the assertions, yet the test still passes&mdash;a false positive.

<div style="font-family: Courier New;font-size: 8pt;color: black;background: white;border: 1px solid #ccc;overflow: auto;width: 550px">
  <pre style="margin: 0px">[<span style="color: #2b91af">Test</span>]</pre>
  
  <pre style="margin: 0px"><span style="color: blue">public</span> <span style="color: blue">void</span> Another_way_to_verify_expectations_instead_of_AssertWasCalled()</pre>
  
  <pre style="margin: 0px">{</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: blue">var</span> stub = <span style="color: #2b91af">MockRepository</span>.GenerateStub&lt;<span style="color: #2b91af">ISampleClass</span>&gt;();</pre>
  
  <pre style="margin: 0px">&nbsp;</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: green">// Here I'm setting up an expectation that a method will be called</span></pre>
  
  <pre style="margin: 0px">&nbsp; stub.Expect(s =&gt; s.MethodThatReturnsInteger(<span style="color: #a31515">"foo"</span>)).Return(5);</pre>
  
  <pre style="margin: 0px">&nbsp;</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: green">//Sneaky Sharon comments out the "Act" part of the test:</span></pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: green">//var output = stub.MethodThatReturnsInteger("foo");</span></pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: green">//Assert.AreEqual(5, output);</span></pre>
  
  <pre style="margin: 0px">&nbsp;</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: green">// ... and now I'm verifying that the method was called</span></pre>
  
  <pre style="margin: 0px">&nbsp; stub.VerifyAllExpectations();</pre>
  
  <pre style="margin: 0px">}</pre>
</div>

In translation, that test says: Create a fake ISampleClass; set up an expectation that a method will be called; <s>call that method</s> do nothing; verify that your expectations were met (and flag the test as a failure if they weren&#8217;t). Shoot. Worse than not having my expectations met is not realizing they&#8217;re not being met. Reminds me of my college boyfriend.

There are two things to fix here. The first is that this test is a little solipsistic. If you create a mock, tell the mock to act, and verify things about the mock&#8230; all you&#8217;re testing are mocks. Instead, you want your tests to exercise _real_ code. The &#8220;system under test,&#8221; i.e., the class being tested, should be part of your production code. Its dependencies are what get mocked, so that you can verify proper interactions with those dependencies. Let&#8217;s fix the solipsism before going on to the second issue.

As originally written, the expectation would be satisfied by the &#8220;Act&#8221; (as in Arrange-Act-Assert) part of the test. It says, &#8220;Call this method. Did I just call this method? Oh, good.&#8221; Instead, you want to ensure the system under test correctly interacts with its friends,&nbsp;using Rhino Mocks&#8217; AssertWasCalled and Expect methods. We need a real class that takes the stubbed class and calls a method on the stubbed class, and we&#8217;ll write unit tests around the real class.

<div style="font-family: Courier New;font-size: 8pt;color: black;background: white;border: 1px solid #ccc;overflow: auto;width: 550px">
  <pre style="margin: 0px"><span style="color: blue">public</span> <span style="color: blue">class</span> <span style="color: #2b91af">MyRealClass</span></pre>
  
  <pre style="margin: 0px">{</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: blue">public</span> <span style="color: blue">void</span> ActOnTheSampleClass(<span style="color: #2b91af">ISampleClass</span> sampleClass)</pre>
  
  <pre style="margin: 0px">&nbsp; {</pre>
  
  <pre style="margin: 0px">&nbsp; }</pre>
  
  <pre style="margin: 0px">}</pre>
</div>

Here&#8217;s the re-written test, verifying how my real class interacts with the ISampleClass interface.

<div style="font-family: Courier New;font-size: 8pt;color: black;background: white;border: 1px solid #ccc;overflow: auto;width: 550px">
  <pre style="margin: 0px">[<span style="color: #2b91af">Test</span>]</pre>
  
  <pre style="margin: 0px"><span style="color: blue">public</span> <span style="color: blue">void</span> Another_way_to_verify_expectations_instead_of_AssertWasCalled()</pre>
  
  <pre style="margin: 0px">{</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: blue">var</span> stub = <span style="color: #2b91af">MockRepository</span>.GenerateStub&lt;<span style="color: #2b91af">ISampleClass</span>&gt;();</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: blue">var</span> systemUnderTest = <span style="color: blue">new</span> <span style="color: #2b91af">MyRealClass</span>();</pre>
  
  <pre style="margin: 0px">&nbsp;</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: green">// Here I'm setting up an expectation that a method will be called</span></pre>
  
  <pre style="margin: 0px">&nbsp; stub.Expect(s =&gt; s.MethodThatReturnsInteger(<span style="color: #a31515">"foo"</span>)).Return(5);</pre>
  
  <pre style="margin: 0px">&nbsp;</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: green">// Tell the system to act (which, if it is working correctly, </span></pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: green">// will call a method on the ISampleClass.</span></pre>
  
  <pre style="margin: 0px">&nbsp; systemUnderTest.ActOnTheSampleClass(stub);</pre>
  
  <pre style="margin: 0px">&nbsp;</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: green">// ... and now I'm verifying that the method was called</span></pre>
  
  <pre style="margin: 0px">&nbsp; stub.VerifyAllExpectations();</pre>
  
  <pre style="margin: 0px">}</pre>
</div>

This test will still pass, despite the fact that my real class does not currently call any methods on the ISampleClass interface. This points to the second issue to fix. In Rhino Mocks, expectations on stubs are not verified; only mocks are verified. If an object is created with GenerateStub instead of GenerateMock, then its VerifyAllExpectations method doesn&#8217;t do anything. This is non-obvious because the AssertWasCalled and AssertWasNotCalled methods on a stub _will_ behave the way you want them to.

In Rhino Mocks, a stub can keep track of its interactions and assert that they happened, but it cannot record expectations and verify they were met. A mock can do both these things. 

That is how they are implemented in Rhino Mocks. If you were holding firm to the ideas in Fowler&#8217;s [Mocks Aren&#8217;t Stubs](http://martinfowler.com/articles/mocksArentStubs.html) article, I think stubs would implement neither VerifyAll nor AssertWasCalled. Semantically, verifying expectations and asserting interactions are synonymous, if you ask me; therefore, stubs shouldn&#8217;t do either one.

Back to Jon Kruger&#8217;s tests. If we call GenerateMock instead of GenerateStub, the test will fail properly with an ExpectationViolationException.

<div style="font-family: Courier New;font-size: 8pt;color: black;background: white;border: 1px solid #ccc;overflow: auto;width: 550px">
  <pre style="margin: 0px">[<span style="color: #2b91af">Test</span>]</pre>
  
  <pre style="margin: 0px"><span style="color: blue">public</span> <span style="color: blue">void</span> Another_way_to_verify_expectations_instead_of_AssertWasCalled()</pre>
  
  <pre style="margin: 0px">{</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: blue">var</span> stub = <span style="color: #2b91af">MockRepository</span>.GenerateMock&lt;<span style="color: #2b91af">ISampleClass</span>&gt;();</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: blue">var</span> systemUnderTest = <span style="color: blue">new</span> <span style="color: #2b91af">MyRealClass</span>();</pre>
  
  <pre style="margin: 0px">&nbsp;</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: green">// Here I'm setting up an expectation that a method will be called</span></pre>
  
  <pre style="margin: 0px">&nbsp; stub.Expect(s =&gt; s.MethodThatReturnsInteger(<span style="color: #a31515">"foo"</span>)).Return(5);</pre>
  
  <pre style="margin: 0px">&nbsp;</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: green">// Tell the system to act (which, if it is working correctly, </span></pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: green">// will call a method on the ISampleClass.</span></pre>
  
  <pre style="margin: 0px">&nbsp; systemUnderTest.ActOnTheSampleClass(stub);</pre>
  
  <pre style="margin: 0px">&nbsp;</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: green">// ... and now I'm verifying that the method was called</span></pre>
  
  <pre style="margin: 0px">&nbsp; stub.VerifyAllExpectations();</pre>
  
  <pre style="margin: 0px">}</pre>
</div>

Now that we&#8217;re red, let&#8217;s get to green. Change the system under test so that it does its job as expected.

<div style="font-family: Courier New;font-size: 8pt;color: black;background: white;border: 1px solid #ccc;overflow: auto;width: 550px">
  <pre style="margin: 0px"><span style="color: blue">public</span> <span style="color: blue">class</span> <span style="color: #2b91af">MyRealClass</span></pre>
  
  <pre style="margin: 0px">{</pre>
  
  <pre style="margin: 0px">&nbsp; <span style="color: blue">public</span> <span style="color: blue">void</span> ActOnTheSampleClass(<span style="color: #2b91af">ISampleClass</span> sampleClass)</pre>
  
  <pre style="margin: 0px">&nbsp; {</pre>
  
  <pre style="margin: 0px">&nbsp; &nbsp; sampleClass.MethodThatReturnsInteger(<span style="color: #a31515">"foo"</span>);</pre>
  
  <pre style="margin: 0px">&nbsp; }</pre>
  
  <pre style="margin: 0px">}</pre>
</div>

Wahoo, a passing test that we can rely on.

The two key points from this exercise are:

  1. [Describing Rhino Mocks with unit tests](http://jonkruger.com/blog/2010/03/12/how-to-use-rhino-mocks-documented-through-tests/) is a cool way to explain a topic. Let&#8217;s have more executable documentation, eh?
  2. Expectations on stubs aren&#8217;t verified, so beware of falsely passing tests.