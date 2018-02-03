---
wordpress_id: 37
title: 'BDD Question: Low Level Behavior And Wrapper Methods?'
date: 2009-02-19T22:01:19+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/02/19/bdd-question-low-level-behavior-and-wrapper-methods.aspx
dsq_thread_id:
  - "262068043"
categories:
  - .NET
  - Behavior Driven Development
  - 'C#'
  - Unit Testing
---
I have a service object with an interface explicitly defined for it. I like this because it let’s me unit test the things that need the service without having to worry about the implementation detail of the actual service. 

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IMyService</pre>
    
    <pre>{</pre>
    
    <pre>  <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> DoSomething();</pre>
    
    <pre>  <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> AnotherThingHere();</pre>
    
    <pre>}</pre></p>
  </div>
</div>

When I get to the implementation of this service and I start specifying the behavior through my specification/tests, I create a class that has a dependency on another interface – ISomeRepository. This repository is used in both methods of the actual service implementation. 

For the “AnotherThingHere” method, I end up with several specification/tests because that method has some good business logic in it. 

For the “DoSomething” method, though, the real implementation is only a pass-through to the repository and my specification/test ends up looking like this:

<div>
  <div>
    <pre>[TestFixture]</pre>
    
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> When_doing_something: ContextSpecification</pre>
    
    <pre>{</pre>
    
    <pre> </pre>
    
    <pre> ISomeRepository repo;</pre>
    
    <pre>&#160;</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Context()</pre>
    
    <pre> {</pre>
    
    <pre>   repo = MockRepository.GenerateMock&lt;ISomeRepository&gt;();</pre>
    
    <pre>   IMyService myService = <span style="color: #0000ff">new</span> MyService(repo);</pre>
    
    <pre>&#160;</pre>
    
    <pre>   myService.DoSomething();</pre>
    
    <pre> }</pre>
    
    <pre>&#160;</pre>
    
    <pre> [Test]</pre>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_do_something()</pre>
    
    <pre> {</pre>
    
    <pre>   repo.AssertWasCalled(r =&gt; r.DoSomething());</pre>
    
    <pre> }</pre>
    
    <pre>&#160;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

I know this specification is necessary because I am using the “DoSomething” method of IMyService in other parts of the system. I think there is value in having an IMyService interface explicitly because it simplified the specification/tests for the parts of the system that need to use it, and decoupled the system to a point that made it much easier to code and change.

So my question is, do you see any real value in a specification/test name like “When doing something, should do something”? or should I be looking at this test from a different “style” or perspective? 

I think this specification/test is valuable, but I also think the test name and observation name are silly since they say the same thing. Advice? Different naming suggestions? What am I missing or just not seeing? or is this ok and I’m just running on 25% brain power due to lack of sleep today?