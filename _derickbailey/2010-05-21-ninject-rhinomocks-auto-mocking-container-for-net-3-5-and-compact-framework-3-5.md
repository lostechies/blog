---
wordpress_id: 159
title: 'Ninject.RhinoMocks: Auto Mocking Container For .NET 3.5 and Compact Framework 3.5'
date: 2010-05-21T21:49:23+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/05/21/ninject-rhinomocks-auto-mocking-container-for-net-3-5-and-compact-framework-3-5.aspx
dsq_thread_id:
  - "262980730"
categories:
  - .NET
  - Behavior Driven Development
  - Brownfield
  - 'C#'
  - Compact Framework
  - Ninject
  - RhinoMocks
  - Unit Testing
redirect_from: "/blogs/derickbailey/archive/2010/05/21/ninject-rhinomocks-auto-mocking-container-for-net-3-5-and-compact-framework-3-5.aspx/"
---
Earlier today, I decided I was tired of calling RhinoMocks directly. I love RhinoMocks. It’s a great tool and I don’t want to write tests without it (or another mocking framework like Moq or whatever…). But I’m tired of all the boring “declare a variable here, mock the object there, pass the object to the constructor here” junk that I have to do to get a mock object into my class under test. 

Here’s an example of what I’m talking about:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> when_doing_something: basecontext</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>   <span style="color: #0000ff">private</span> ISomeView View;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>   <span style="color: #0000ff">private</span> SomePresenter Presenter;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> EstablishContext()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>   {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>       View = MockRepository.GenerateMock&lt;IView&gt;();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>       Presenter = <span style="color: #0000ff">new</span> Presenter(View);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>   }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>   </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> When()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>   {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>       Presenter.DoSomething();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>   }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>   </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span>   [Test]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_show_something()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span>   {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  20:</span>     View.AssertWasCalled(v =&gt; v.ShowThatThing());</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  21:</span>   }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  22:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        Line 3: declare a variable here<br /> <br />Line 8: mock the object here
      </p>
      
      <p>
        Line 9: pass it to the class under test
      </p>
      
      <p>
        Line 20: assert against it
      </p>
      
      <p>
        It’s even more annoying when I have to mock things that I don’t care about, or when I have 5 or 6 or more things to mock (and yes, I know that having that many dependencies is a design smell. I’m not working on a pure greenfield app, so I don’t have the luxury of designing everything ‘correctly’).
      </p>
      
      <p>
        … what can I say… I’m lazy. I’d rather ignore the ceremony of declaring the variable, mocking it and passing it to my class. Let me get my class and ask for the mock if I need it. I’m not trying to do anything crazy or bad, or let myself get away with poor design problems. I’m just trying to reduce the amount of code that I have to write in my tests. Maybe it’s the ruby developer in me, lashing out against the ceremony of C# again… whatever it is, I want an auto-mocking container for <a href="http://github.com/ninject/ninject">ninject</a> and <a href="http://www.ayende.com/projects/rhino-mocks/downloads.aspx">rhino mocks</a>.
      </p>
      
      <p>
        Now I know there is a general sense of “NO!!!!!” in the alt.net crowd these days… but I don’t understand that. Just because you <em>can</em> abuse a tool, doesn’t mean you should or will. <a href="http://www.lostechies.com/blogs/derickbailey/archive/2010/02/03/branch-per-feature-how-i-manage-subversion-with-git-branches.aspx">I like wielding triple-edged swords with poison-tip spikes on the handle.</a> It give me power and flexibility to get things done… and yes, the occasional debilitating injury… but hey, a little pain just means I’m learning what not to do, right? 🙂
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        Automocking With Ninject And RhinoMocks
      </h3>
      
      <p>
        After doing a bit of googling, I found <a href="http://stackoverflow.com/questions/1818302/auto-mock-container-rhino-mocks-and-ninject">a stack overflow question</a> with the basic code to get this running. I had a hard time getting that to work, though, so I scrapped it and started fresh from a copy of <a href="http://github.com/ninject/ninject.moq">ninject.moq</a>. A little while later, I have a basic working auto-mocking container for ninject and rhino mocks.
      </p>
      
      <p>
        Now I can create a MockingKernel in my basecontext class and change my test code to run like this:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> when_doing_something: basecontext</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>   <span style="color: #0000ff">private</span> SomePresenter Presenter;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> EstablishContext()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>   {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>       Presenter = mockingKernel.Get&lt;SomePresenter&gt;();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>   }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>   </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> When()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>   {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>       Presenter.DoSomething();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>   }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span>   </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  15:</span>   [Test]</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  16:</span>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> it_should_show_something()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  17:</span>   {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  18:</span>     mockingKernel.Get&lt;IView&gt;().AssertWasCalled(v =&gt; v.ShowThatThing());</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  19:</span>   }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  20:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              Line 18: get the view and assert against it
            </p>
            
            <p>
              There’s only a few lines of code difference in this simple example, so it seems like a wash. When you are dealing with multiple dependencies, though, it makes the code much easier to write.
            </p>
            
            <p>
              As a real-world example, after implementing this, I was able to reduce my test code by about 12 lines because I only needed 2 of the mocked objects for assertions. The rest of them were there for ‘support’ and other behaviors, but needed to be there to prevent null reference exceptions. With the auto mocking container in place, I didn’t need to declare a variable, mock, or pass the other dependencies into the class under test. I let the auto-mocking container do that for me.
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              Ninject.RhinoMocks And Ninject.RhinoMocks.CF
            </h3>
            
            <p>
              If you’d like to use this functionality, you can grab the source code from github. There are two different version available – one for full .net 3.5 and another for .net 3.5 compact framework.
            </p>
            
            <p>
              Please note, though, that I wrote this code for me and built in the behavior that I wanted. All mocked objects are essentially singleton instances so every time you request one from the kernel, it returns the same one. Be sure to call kernel.Reset(); in your teardown, so you don’t get mock objects bleeding over between test fixtures.
            </p>
            
            <p>
              Also note that this code is a bit of a hack, as I am not entirely sure about the implementation needs of ninject. I’ve asked for Ian Davis’ input on the code and he’s said he’ll review it… but until that happens, and until I get a chance to “clean up” the code, there’s no promises about the quality of this work.
            </p>
            
            <p>
              &#160;
            </p>
            
            <p>
              <strong>Ninject.RhinoMocks:</strong>
            </p>
            
            <ul>
              <li>
                .NET: v3.5, Full Framework
              </li>
              <li>
                URL: <a title="http://github.com/derickbailey/ninject.rhinomocks" href="http://github.com/derickbailey/ninject.rhinomocks">http://github.com/derickbailey/ninject.rhinomocks</a>
              </li>
              <li>
                Ninject: v2.0.1
              </li>
              <li>
                RhinoMocks: v3.6
              </li>
            </ul>
            
            <p>
              &#160;
            </p>
            
            <h4>
              <strong>Ninject.RhinoMocks.CF:</strong>
            </h4>
            
            <ul>
              <li>
                .NET: v3.5, Compact Framework
              </li>
              <li>
                URL: <a href="http://github.com/derickbailey/ninject.rhinomocks.cf">http://github.com/derickbailey/ninject.rhinomocks.cf</a>
              </li>
              <li>
                Ninject: v2.0.1, compiled for Compact Framework
              </li>
              <li>
                RhinoMocks: v3.5 compiled for Compact Framework, with Castle.Core and Castle.DynamicProxy2 as separate dlls
              </li>
            </ul>