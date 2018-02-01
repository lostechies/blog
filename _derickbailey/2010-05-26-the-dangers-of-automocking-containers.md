---
id: 163
title: The Dangers Of AutoMocking Containers
date: 2010-05-26T12:00:00+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/05/26/the-dangers-of-automocking-containers.aspx
dsq_thread_id:
  - "262967533"
categories:
  - .NET
  - Analysis and Design
  - AntiPatterns
  - AutoMocking
  - 'C#'
  - Craftsmanship
  - Quality
---
[Louis Salin](http://www.lostechies.com/blogs/louissalin/default.aspx) commented on my original post about the [Ninject.RhinoMocks automocking container](http://www.lostechies.com/blogs/derickbailey/archive/2010/05/21/ninject-rhinomocks-auto-mocking-container-for-net-3-5-and-compact-framework-3-5.aspx), and brought up a very good point. Here is his comment, reproduced in full:

> _I&#8217;ve heard (or read&#8230;) that automocking is equivalent to taking weight loss pills while still eating cheesburgers for breakfast. Okay, I just made that up!_
> 
> _My point is, and I&#8217;m in no way in a position to opine on the matter, that the pain of mocking might be due to design issues. Hiding the pain with a tool won&#8217;t make the cause go away._
> 
> _So maybe in this case it&#8217;s a very benign use of an automocker, but as the code base grows, the automocker will hide pain points that would otherwise become immediately obvious, no?_

Louis has a good point and it is one that I have argued in the past to justify why I have not used an auto mocking container. However, I stand by my response in the comments of that post:

> _yeah, that&#8217;s the "big problem" that people complain about when they say auto mocking containers are bad. honestly, that&#8217;s a pretty weak excuse for not teaching developers how to spot too many dependencies as a part of bad design. trust your team. if they get it wrong, teach them right._

The “pain of mocking” that Louis is referring to is most often the need to mock a significant number of things in order to get a class spun up for testing. It may be painful or tedious or however you want to describe it, to get all of the things you need setup in order to get a class under test. But just because you can ignore that pain with an automocking container, doesn’t mean you will.

Before I expand on my response, though, let’s look at an example of what the problem really is.

&#160;

### A Simple Specification

This is the same sample specification that I ended yesterday’s blog post with. It’s small, easy to read and easy to understand. There is nothing really wrong with this code, in my opinion.

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> when_doing_something_with_that_thing : ContextSpecification&lt;MyPresenter&gt;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> When()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>         SUT.DoSomething();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>     </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>     [Test]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_do_that_thing()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>         AssertWasCalled&lt;IMyView&gt;(v =&gt; v.ThatThing());</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>     [Test]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_do_the_other_thing_twice()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span>         AssertWasCalled&lt;IMyView&gt;(v =&gt; v.TheOtherThing(), mo =&gt; mo.Repeat.Twice());</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        The problem that an automocking container hides is not this code, but what this code potentially hides in the implementation.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        A Complex Implementation
      </h3>
      
      <p>
        Now take a look at one possibility for the implementation of the MyPresenter class used in the above specification:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> MyPresenter</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">private</span> IMyView view;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">private</span> ISomeService someService;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">private</span> IAnotherService anotherService;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">private</span> IMoreService moreService;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>     <span style="color: #0000ff">private</span> ISomeRepository someRepository;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>     <span style="color: #0000ff">private</span> IAnotherRepository anotherRepository;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>     <span style="color: #0000ff">private</span> IMoreRepository moreRepository;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>     <span style="color: #0000ff">private</span> IValidator&lt;SomeData&gt; someDataValidator;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>     <span style="color: #0000ff">private</span> IValidator&lt;MoreData&gt; moreDataValidator;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>     <span style="color: #0000ff">private</span> IValidator&lt;AnotherData&gt; anotherDataValidator;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>     <span style="color: #0000ff">private</span> SomeData someData;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span>     <span style="color: #0000ff">private</span> AnotherData anotherData;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  15:</span>     <span style="color: #0000ff">private</span> MoreData moreData;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  16:</span>     </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  17:</span>     <span style="color: #0000ff">public</span> MyPresenter(</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  18:</span>         IMyView view,</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  19:</span>         ISomeService someService,</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  20:</span>         IAnotherService anotherService,</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  21:</span>         IMoreService moreService,</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  22:</span>         ISomeRepository someRepository,</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  23:</span>         IAnotherRepository anotherRepository,</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  24:</span>         IMoreRepository moreRepository,</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  25:</span>         IValidator&lt;SomeData&gt; someDataValidator,</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  26:</span>         IValidator&lt;MoreData&gt; moreDataValidator,</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  27:</span>         IValidator&lt;AnotherData&gt; anotherDataValidator</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  28:</span>     )</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  29:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  30:</span>         <span style="color: #0000ff">this</span>.view = view;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  31:</span>         <span style="color: #0000ff">this</span>.someService = someService;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  32:</span>         <span style="color: #0000ff">this</span>.anotherService = anotherService;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  33:</span>         <span style="color: #0000ff">this</span>.moreService = moreService;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  34:</span>         <span style="color: #0000ff">this</span>.someRepository = someRepository;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  35:</span>         <span style="color: #0000ff">this</span>.anotherRepository = anotherRepository;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  36:</span>         <span style="color: #0000ff">this</span>.moreRepository = moreRepository;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  37:</span>         <span style="color: #0000ff">this</span>.someDataValidator = someDataValidator;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  38:</span>         <span style="color: #0000ff">this</span>.moreDataValidator = moreDataValidator;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  39:</span>         <span style="color: #0000ff">this</span>.anotherDataValidator = anotherDataValidator;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  40:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  41:</span>     </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  42:</span>     <span style="color: #008000">// ... methods and implementation details go here</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  43:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              That’s 40 lines of code just to get the object constructed! ARGH! that’s AWFUL! There are so many things wrong with just the member variables listed in the constructor of this class… and I haven’t even begun to imagine what the implementation of any methods on this class may look like. Quite honestly, I don’t want to think about what they may look like.
            </p>
            
            <p>
              Now imagine that this code uses a couple of abstract base classes instead of all interfaces for the dependencies. Replace the three validators, for example, with abstract base classes. What happens when each of these base classes requires 2 constructor arguments for their own dependencies? The auto mocking container will go ahead and wire them up as well, and pass them into the abstract base classes so that the objects can be mocked. Now, instead of having 10 objects being mocked, we have 16. If any of those dependencies are objects with their own dependencies… well, I think you get the picture. The object graph being automocked in this scenario is horrendous and wreaks of bad design left and right.
            </p>
            
            <p>
              But because we have an automocking container, we don’t care about that bad design, right? We’ll just let it slip and go on about our business because the pain of that horrendous mess is hidden away at test time. Our tooling of choice makes it easy to get away with poor design… or so the argument goes.
            </p>
          </p>
          
          <p>
            &#160;
          </p>
          
          <h3>
            The Truth About Auto Mocking Containers
          </h3>
          
          <p>
            There is nothing inherently evil in auto mocking containers. They are not “bad” and using them is not “wrong”. Sure, they can be abused and you can do damage with them. The same thing is true of baseball bats, eggs, automatic rifles, and thousands upon thousands of other tools. Scott Bellware has quoted Ani DeFranco on the subject of tools, more than a few times: “every tool is a weapon if you hold it right”.&#160;
          </p>
          
          <p>
            Now… let me restate my opinion on the problem that Louis is referring to, keeping in mind that I used to cite this exact reason for my not wanting to use an auto mocking container.
          </p>
          
          <blockquote>
            <p>
              <strong>Auto mocking containers do not facilitate poor design or horrendous implementation. Poor design and horrendous implementation skill, in the person designing and implementing the code, does.</strong>
            </p>
          </blockquote>
          
          <p>
            That’s it, right there. The notion that an automocking container will let someone design and implement that pile of garbage, while not using one won’t let them or will expose the problem, is ridiculous.
          </p>
          
          <p>
            Speaking as a person who used to write garbage like this (and still does, occasionally, I’ll admit), I know that not using an automocking container will not prevent you from doing this. It will not make the problems more obvious if you don’t use an automocking container, and you will not inherently write better code without one. A software developer who writes code like this is not going to know the problems they are causing just because they have to declare and instantiate the 10 mock objects that this code needs to be tested. Developers write code like this because that’s the kind of code they right… no other reason. Now, there might be a lot of reasons why they write code like this… but that’s a completely different set of subjects.
          </p>
          
          <p>
            “a poor craftsman blames his tools” … “with great power comes great responsibility” … “(insert other overused and abused quotes here)”
          </p>
          
          <p>
            &#160;
          </p>
          
          <h3>
            One Last Note
          </h3>
          
          <p>
            I wanted to note, specifically, that this post is <em>not</em> directed at Louis or anyone in particular. Louis is only the guy that prompted the discussion and not a person that I would single out for writing bad code.
          </p>