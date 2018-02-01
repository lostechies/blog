---
id: 33
title: Why ‘Should Attach View To Presenter’ Is An Invalid Unit Test / Observation.
date: 2009-02-05T20:16:48+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2009/02/05/why-should-attach-view-to-presenter-is-an-invalid-unit-test-observation.aspx
dsq_thread_id:
  - "262068032"
categories:
  - .NET
  - Analysis and Design
  - Behavior Driven Development
  - 'C#'
  - Model-View-Presenter
  - Principles and Patterns
  - Unit Testing
---
I’ve written a lot of specification tests like this in the last three years, from a UI / Workflow perspective, with Model-View-Presenter as my core UI architecture:

<div>
  <div>
    <pre>[TestFixture]</pre>
    
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> When_starting_some_process()</pre>
    
    <pre>{</pre>
    
    <pre>&#160;</pre>
    
    <pre> IMyView view;</pre>
    
    <pre> MyPresenter presenter;</pre>
    
    <pre>&#160;</pre>
    
    <pre> [Setup]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Setup()</pre>
    
    <pre> {</pre>
    
    <pre>   <span style="color: #008000">//...setup code and execute stuff for the test here</span></pre>
    
    <pre>   view = MockRepository.GenerateMock&lt;IMyView&gt;();</pre>
    
    <pre>   presenter = <span style="color: #0000ff">new</span> MyPresenter(view);</pre>
    
    <pre>&#160;</pre>
    
    <pre>   presenter.StartSomeProcess();</pre>
    
    <pre> } </pre>
    
    <pre>&#160;</pre>
    
    <pre> [Test]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_attach_the_view_to_the_presenter()</pre>
    
    <pre> {</pre>
    
    <pre>   presenter.View.ShouldNotBeNull();</pre>
    
    <pre> }</pre>
    
    <pre>&#160;</pre>
    
    <pre> [Test]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_show_something()</pre>
    
    <pre> {</pre>
    
    <pre>   view.AssertWasCalled(v =&gt; v.ShowSomething(something));</pre>
    
    <pre> }</pre>
    
    <pre>&#160;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

### The Devil In These Details

I had one of those ‘aha!’ moments yesterday where several of my nagging suspicions and annoyances at writing specification tests like this example finally gelled into a coherent understanding. That understanding is easily stated by saying that the test, “Should\_attach\_the\_view\_to\_the\_presenter” is invalid and should never be written. There are a number of reasons for this.

  1. In practicing BDD, the technical jargon that is leaking into the test is irrelevant to the real value that is intended with this specification
  2. In practicing any form of TDD, the implementation detail of attaching a view to a presenter creates a brittle test – I care about the API and how the system really works, not a very technical, implementation detail like this.
  3. Exposing the “View” property of the Presenter object is a violation of encapsulation and an ‘over-intimate’ smell. My test has far too much fine detail, granular knowledge of what’s going on behind the scenes, to really be of any practical value
  4. Finally – and possibly outweighing all other reasons combined – it’s simply not necessary.

Look at the second test: “Should\_show\_something”. It’s actually using the view. Presumably, the “StartSomeProcess” method on the presenter is going to call a method on the view – that’s why we are asserting that the method on the view was called. If this is true, then it can be safely assumed that not having a view attached to the presenter would throw a null reference exception when trying to call that method on the view.

If not having the view attached to the presenter results in a null reference exception for the other test, then we have a valid reason for that test to fail. We certainly can’t say that the view’s method was called when the view is null. Therefore, testing to ensure that we have a view attached to the presenter is a duplication of effort. We’re only proving what we have already proved transitively, via another test. 

### Beauty And Meaning In Simplicity

Assuming that this is all true, we can remove that test entirely. Our specification now looks like this:

<div>
  <div>
    <pre>[TestFixture]</pre>
    
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> When_starting_some_process()</pre>
    
    <pre>{</pre>
    
    <pre>&#160;</pre>
    
    <pre> IMyView view;</pre>
    
    <pre> MyPresenter presenter;</pre>
    
    <pre>&#160;</pre>
    
    <pre> [Setup]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Setup()</pre>
    
    <pre> {</pre>
    
    <pre>   <span style="color: #008000">//...setup code and execute stuff for the test here</span></pre>
    
    <pre>   view = MockRepository.GenerateMock&lt;IMyView&gt;();</pre>
    
    <pre>   presenter = <span style="color: #0000ff">new</span> MyPresenter(view);</pre>
    
    <pre>&#160;</pre>
    
    <pre>   presenter.StartSomeProcess();</pre>
    
    <pre> }</pre>
    
    <pre> </pre>
    
    <pre> [Test]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_show_something()</pre>
    
    <pre> {</pre>
    
    <pre>   view.AssertWasCalled(v =&gt; v.ShowSomething(something));</pre>
    
    <pre> }</pre>
    
    <pre>&#160;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

It’s one less test to deal with, yet is as expressive and meaningful. In fact, I would say it is more meaningful because we have avoided all of the problems I listed. I’m reminded of a quote by <a href="http://en.wikipedia.org/wiki/Alan_Cooper" target="_blank">Alan Cooper</a>:

> _“No matter how beautiful, no matter how cool your interface, it would be better if there were less of it.”_

Although I think he was specifically addressing User interfaces in this quote, it is applicable to <u>all</u> interfaces – programmatic, user, etc. Simplicity and subtleness is the key. I know I’m not the first person to talk about this problem, why it’s a problem, or the solution. I’m only claiming that I finally had that ‘aha!’ moment and realized why so many others have talked about this before.