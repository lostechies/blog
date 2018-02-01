---
id: 3938
title: 'The Rhino.Mocks&#8217; AssertWasCalled method does work'
date: 2008-09-25T14:08:28+00:00
author: Joshua Flanagan
layout: post
guid: /blogs/joshuaflanagan/archive/2008/09/25/the-rhino-mocks-assertwascalled-method-does-work.aspx
dsq_thread_id:
  - "262113124"
categories:
  - RhinoMocks
  - StructureMap
---
</p> 

This behavior is probably clearly specified somewhere, but somehow it has been non-obvious to the four people on our team to the point that we were leaning toward banning its use. I didn’t want to go that far, so figured I better figure out the rules.

I’m referring to the AssertWasCalled extension method in Rhino.Mocks that allows the Arrange/Act/Assert style of testing. We found that sometimes it would behave how we expected, and sometimes it would not, with no apparent explanation. I finally realized that it probably had something to do with how the mock objects were created, so I wrote this simple test:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> [TestFixture]</pre>
    
    <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> AssertCalledTester</pre>
    
    <pre><span style="color: #606060">   3:</span> {</pre>
    
    <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">private</span> Dictionary&lt;<span style="color: #0000ff">string</span>, IDependency&gt; dependencies;</pre>
    
    <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">private</span> MockRepository mocks;</pre>
    
    <pre><span style="color: #606060">   6:</span>&#160; </pre>
    
    <pre><span style="color: #606060">   7:</span>     [SetUp]</pre>
    
    <pre><span style="color: #606060">   8:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Setup()</pre>
    
    <pre><span style="color: #606060">   9:</span>     {</pre>
    
    <pre><span style="color: #606060">  10:</span>         mocks = <span style="color: #0000ff">new</span> MockRepository();</pre>
    
    <pre><span style="color: #606060">  11:</span>         dependencies = <span style="color: #0000ff">new</span> Dictionary&lt;<span style="color: #0000ff">string</span>, IDependency&gt;()</pre>
    
    <pre><span style="color: #606060">  12:</span>        {</pre>
    
    <pre><span style="color: #606060">  13:</span>            {<span style="color: #006080">"GenerateMock"</span>, MockRepository.GenerateMock&lt;IDependency&gt;()},</pre>
    
    <pre><span style="color: #606060">  14:</span>            {<span style="color: #006080">"GenerateStub"</span>, MockRepository.GenerateStub&lt;IDependency&gt;()},</pre>
    
    <pre><span style="color: #606060">  15:</span>            {<span style="color: #006080">"StrictMock"</span>, <span style="color: #0000ff">this</span>.mocks.StrictMock&lt;IDependency&gt;()},</pre>
    
    <pre><span style="color: #606060">  16:</span>            {<span style="color: #006080">"DynamicMock"</span>, <span style="color: #0000ff">this</span>.mocks.DynamicMock&lt;IDependency&gt;()},</pre>
    
    <pre><span style="color: #606060">  17:</span>            {<span style="color: #006080">"Stub"</span>, <span style="color: #0000ff">this</span>.mocks.Stub&lt;IDependency&gt;()},</pre>
    
    <pre><span style="color: #606060">  18:</span>        };</pre>
    
    <pre><span style="color: #606060">  19:</span>     }</pre>
    
    <pre><span style="color: #606060">  20:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  21:</span>     [RowTest]</pre>
    
    <pre><span style="color: #606060">  22:</span>     [Row(<span style="color: #006080">"GenerateMock"</span>)]</pre>
    
    <pre><span style="color: #606060">  23:</span>     [Row(<span style="color: #006080">"GenerateStub"</span>)]</pre>
    
    <pre><span style="color: #606060">  24:</span>     [Row(<span style="color: #006080">"StrictMock"</span>)]</pre>
    
    <pre><span style="color: #606060">  25:</span>     [Row(<span style="color: #006080">"DynamicMock"</span>)]</pre>
    
    <pre><span style="color: #606060">  26:</span>     [Row(<span style="color: #006080">"Stub"</span>)]</pre>
    
    <pre><span style="color: #606060">  27:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> When_does_it_work(<span style="color: #0000ff">string</span> mockStyle)</pre>
    
    <pre><span style="color: #606060">  28:</span>     {</pre>
    
    <pre><span style="color: #606060">  29:</span>         var dependency = dependencies[mockStyle];</pre>
    
    <pre><span style="color: #606060">  30:</span>         var caller = <span style="color: #0000ff">new</span> Caller(dependency);</pre>
    
    <pre><span style="color: #606060">  31:</span>         caller.Go();</pre>
    
    <pre><span style="color: #606060">  32:</span>         dependency.AssertWasCalled(d =&gt; d.DoSomething());</pre>
    
    <pre><span style="color: #606060">  33:</span>     }</pre>
    
    <pre><span style="color: #606060">  34:</span> }</pre>
    
    <pre><span style="color: #606060">  35:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  36:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Caller</pre>
    
    <pre><span style="color: #606060">  37:</span> {</pre>
    
    <pre><span style="color: #606060">  38:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IDependency dependency;</pre>
    
    <pre><span style="color: #606060">  39:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  40:</span>     <span style="color: #0000ff">public</span> Caller(IDependency dependency)</pre>
    
    <pre><span style="color: #606060">  41:</span>     {</pre>
    
    <pre><span style="color: #606060">  42:</span>         <span style="color: #0000ff">this</span>.dependency = dependency;</pre>
    
    <pre><span style="color: #606060">  43:</span>     }</pre>
    
    <pre><span style="color: #606060">  44:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  45:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Go()</pre>
    
    <pre><span style="color: #606060">  46:</span>     {</pre>
    
    <pre><span style="color: #606060">  47:</span>         dependency.DoSomething();</pre>
    
    <pre><span style="color: #606060">  48:</span>     }</pre>
    
    <pre><span style="color: #606060">  49:</span> }</pre>
    
    <pre><span style="color: #606060">  50:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  51:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IDependency</pre>
    
    <pre><span style="color: #606060">  52:</span> {</pre>
    
    <pre><span style="color: #606060">  53:</span>     <span style="color: #0000ff">void</span> DoSomething();</pre>
    
    <pre><span style="color: #606060">  54:</span> }</pre></p>
  </div>
</div>

The results (3 out of 5 tests fail) clearly illustrated the source of our problems: AssertWasCalled only works automatically if you create your mocks using the new static MockRepository methods. <a href="http://ayende.com/Blog/archive/2008/05/16/Rhino-Mocks--Arrange-Act-Assert-Syntax.aspx" target="_blank">Ayende’s initial announcement of the feature</a> used these static methods, but it wasn’t explicit that they were required. They just appeared to be convenience methods. However, reading into the comments, I see that Ayende posted on 6/14/08 that the static methods are indeed special:

> The static methods are returning an object that can be used without record/replay. It is already in replay mode, which is needed to use the AAA syntax.

If aren’t using the static methods (or are using something like <a href="http://codebetter.com/blogs/jeremy.miller/archive/2008/02/09/automocker-in-structuremap-2-5.aspx" target="_blank">StructureMap’s RhinoAutoMocker</a> where the mocks are created for you), you can still utilize AssertWasCalled as long as you call ReplayAll() before the “act” phase of your test. For example, in the code above I can add “mocks.ReplayAll()” before line 31 to get 4 out of the 5 tests to pass. The only one that fails is the one that uses a StrictMock, which isn’t too worrisome.