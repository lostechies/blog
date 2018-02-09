---
wordpress_id: 33
title: 'Take 2: Why we use SOLID in static languages and how we get the same functionality for cheap in dynamic languages'
date: 2009-11-19T22:46:17+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2009/11/19/take-2-why-we-use-solid-in-static-languages-and-how-we-get-the-same-functionality-for-cheap-in-dynamic-languages.aspx
dsq_thread_id:
  - "425624388"
categories:
  - Dynamic Langs
  - Python
  - SOLID
redirect_from: "/blogs/rssvihla/archive/2009/11/19/take-2-why-we-use-solid-in-static-languages-and-how-we-get-the-same-functionality-for-cheap-in-dynamic-languages.aspx/"
---
One of the things we do pretty well at Los Techies is explaining SOLID principles and why they make our code more maintainable and if you’re not familiar with our work on SOLID,&#160; read <a href="http://www.lostechies.com/blogs/chad_myers/archive/2008/03/07/pablo-s-topic-of-the-month-march-solid-principles.aspx" target="_blank">Chad Meyer&#8217;s post</a> to get an understanding on the Los Techies perspective. Now that you’ve taken a bit of time to read that the following chart takes SOLID’s benefits and then shows how they apply to dynamic languages:

&#160;

<table border="2" cellspacing="0" cellpadding="2" width="413">
  <tr>
    <td valign="top">
      Principle
    </td>
    
    <td valign="top" width="121">
      Primary Benefit
    </td>
    
    <td valign="top">
      Secondary Benefit
    </td>
    
    <td valign="top" width="86">
      What dynamic langs do to replace said principle
    </td>
  </tr>
  
  <tr>
    <td valign="top">
      Single Responsibility Principle (SRP)
    </td>
    
    <td valign="top" width="121">
      Classes are in understandable units
    </td>
    
    <td valign="top">
      Testability
    </td>
    
    <td valign="top" width="86">
      Nothing
    </td>
  </tr>
  
  <tr>
    <td valign="top">
      Open-Closed Principle (OCP)
    </td>
    
    <td valign="top" width="121">
      Flexibility
    </td>
    
    <td valign="top">
      Guidance
    </td>
    
    <td valign="top" width="86">
      can override anything globally (monkey patch)
    </td>
  </tr>
  
  <tr>
    <td valign="top">
      Liskov Substitution Principle (LSP)
    </td>
    
    <td valign="top" width="121">
      Not bleeding subclass specific knowledge everywhere
    </td>
    
    <td valign="top">
      Least surprise
    </td>
    
    <td valign="top" width="86">
      Nothing
    </td>
  </tr>
  
  <tr>
    <td valign="top">
      Interface Segregation Principle (ISP)
    </td>
    
    <td valign="top" width="121">
      Interfaces are in understandable units
    </td>
    
    <td valign="top">
      Less work for interface implementation
    </td>
    
    <td valign="top" width="86">
      everything’s an interface (duck typing)
    </td>
  </tr>
  
  <tr>
    <td valign="top">
      Dependency Inversion Principle(DIP)
    </td>
    
    <td valign="top" width="121">
      Flexibility
    </td>
    
    <td valign="top">
      Testability
    </td>
    
    <td valign="top" width="86">
      can override anything globally (monkey patch)
    </td>
  </tr>
</table>

&#160;

The above is my opinion and I’m sure people will beat me to death because I’m just some dude not many people know about,&#160; but I think I’ve got a grasp of what SOLID means in C# and I’ve grappled with it from a practical perspective.

You’ll note when it comes to LSP and SRP dynamic languages really give you nothing at all, but OCP, ISP, and DI benefits wise are supplanted by language features in python, ruby, etc.&#160; How does this happen? In the case of ISP and “duck typing” this should be pretty obvious, but in the cases of OCP, DIP

&#160;

DIP/OCP testability achieved through C#:

&#160;

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    <span style="color:#008800"><b>public</b></span>&#160;<span style="color:#008800"><b>class</b></span>&#160;<span style="color:#bb0066"><b>FooBar</b></span><span style="color:#008800"><b>{</b></span></p> 
    
    <p>
      &#160;&#160;&#160;&#160;<span style="color:#008800"><b>private</b></span>&#160;IFooService&#160;_service;
    </p>
    
    <p>
      &#160;&#160;&#160;&#160;<span style="color:#008800"><b>public</b></span>&#160;<span style="color:#0066bb"><b>FooBar</b></span>(IFooService&#160;service)<span style="color:#008800"><b>{</b></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;_service&#160;=&#160;service;<br /> &#160;&#160;&#160;&#160;<span style="color:#008800"><b>}</b></span>
    </p>
    
    <p>
      &#160;&#160;&#160;&#160;<span style="color:#008800"><b>public</b></span>&#160;<span style="color:#008800"><b>void</b></span>&#160;<span style="color:#0066bb"><b>DoFoo</b></span>()<span style="color:#008800"><b>{</b></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;_service.run();<br /> &#160;&#160;&#160;&#160;<span style="color:#008800"><b>}</b></span><br /> <span style="color:#008800"><b>}</b></span>
    </p>
    
    <p>
      <span style="color:#888888">//testcode<br /> </span><span style="color:#336699"><br /> [TestFixture]</span><br /> <span style="color:#008800"><b>public</b></span>&#160;<span style="color:#008800"><b>class</b></span>&#160;<span style="color:#bb0066"><b>FooBarSpec</b></span><span style="color:#008800"><b>{</b></span><br /> <span style="color:#336699">&#160;&#160;<br /> &#160;&#160;[Test]</span><br /> &#160;&#160;<span style="color:#008800"><b>public</b></span>&#160;<span style="color:#008800"><b>void</b></span>&#160;<span style="color:#0066bb"><b>should_call_fooservice</b></span>()<span style="color:#008800"><b>{</b></span><br /> &#160;&#160;&#160;&#160;&#160;var&#160;mockfoo&#160;=&#160;<span style="color:#008800"><b>new</b></span>&#160;Mock<IFooService>();&#160;&#160;<br /> &#160;&#160;&#160;&#160;&#160;var&#160;foobar&#160;=&#160;<span style="color:#008800"><b>new</b></span>&#160;FooBar(mockfoo.<span style="color:#888888"><b>object</b></span>);<br /> &#160;&#160;&#160;&#160;&#160;foobar.DoFoo();<br /> &#160;&#160;&#160;&#160;&#160;mockfoo.Verify(foo=>foo.run())<br /> &#160;&#160;&#160;&#160;&#160;&#160;<br /> &#160;&#160;&#160;<span style="color:#008800"><b>}</b></span>
    </p>
    
    <p>
      <span style="color:#008800"><b>}</b></span> </div> </div> 
      
      <p>
        DIP/OCP equivalent testability achieved through Python:
      </p>
      
      <p>
        &#160;
      </p>
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
        <div style="font-family:consolas,lucida console,courier,monospace">
          <span style="color:#008800"><b>class</b></span>&#160;<span style="color:#bb0066"><b>FooBar</b></span>(<span style="color:#003388">object</span>):</p> 
          
          <p>
            &#160;&#160;&#160;&#160;<span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>DoFoo</b></span>(<span style="color:#003388">self</span>):<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;service&#160;=&#160;FooService()<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;service.run()
          </p>
          
          <p>
            <span style="color:#888888">#test&#160;code</span><br /> <span style="color:#008800"><b>import</b></span>&#160;<span style="color:#bb0066"><b>unittest</b></span>
          </p>
          
          <p>
            <span style="color:#008800"><b>class</b></span>&#160;<span style="color:#bb0066"><b>TestFooBar</b></span>(unittest.TestCase):
          </p>
          
          <p>
            &#160;&#160;&#160;&#160;<span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>runmock</b></span>(<span style="color:#003388">self</span>):<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#003388">self</span>.fooservice_run_was_called&#160;=&#160;<span style="color:#003388">True</span>
          </p>
          
          <p>
            &#160;&#160;&#160;&#160;<span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>test_do_fooservice_is_called</b></span>(<span style="color:#003388">self</span>):<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;originalrun&#160;=&#160;FooService.run&#160;<span style="color:#888888">#storing&#160;the&#160;original&#160;method&#160;in&#160;a&#160;variable&#160;</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;FooService.run&#160;=&#160;<span style="color:#003388">self</span>.runmock&#160;&#160;<span style="color:#888888">#&#160;I&#8217;m&#160;globally&#160;overriding&#160;the&#160;method&#160;call&#160;FooService.run&#160;AKA&#160;Monkey&#160;Patch</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;FooBar().DoFoo()<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;FooService.run&#160;=&#160;originalrun&#160;<span style="color:#888888">#globally&#160;put&#160;it&#160;back&#160;to&#160;where&#160;it&#160;was&#160;AKA&#160;Monkey&#160;Patch</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>assert</b></span>&#160;<span style="color:#003388">self</span>.fooservice_run_was_called<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; </div> </div> 
            
            <p>
              Now rightfully you may say the Python version has a few more lines of code, and it certainly can be considered ugly…but don’t you see that I replaced an <strong>entire mocking library</strong> in a few lines of code.&#160; There are also mocking libraries and monkey patch libraries for Python that would shorten my line of code count further.&#160; Testability and flexibility dovetail, but the <strong>global accessibility of class definitions </strong>is understandably hard to grasp for the static mindset (it took me months), so we’ll continue on to flexibility:
            </p>
            
            <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
              <div style="font-family:consolas,lucida console,courier,monospace">
                <span style="color:#008800"><b>public</b></span>&#160;<span style="color:#008800"><b>interface</b></span>&#160;IOutput<span style="color:#008800"><b>{</b></span><br /> &#160;&#160;<br /> &#160;&#160;<span style="color:#008800"><b>void</b></span>&#160;<span style="color:#0066bb"><b>save</b></span>(<span style="color:#888888"><b>string</b></span>&#160;fileloc,&#160;ResultObjects[]&#160;results);</p> 
                
                <p>
                  <span style="color:#008800"><b>}</b></span>
                </p>
                
                <p>
                  <span style="color:#008800"><b>public</b></span>&#160;<span style="color:#008800"><b>class</b></span>&#160;<span style="color:#bb0066"><b>XmlOutput</b></span>:IOutput&#160;<span style="color:#008800"><b>{</b></span><br /> &#160;<br /> &#160;&#160;&#160;<span style="color:#008800"><b>public</b></span>&#160;<span style="color:#008800"><b>void</b></span>&#160;<span style="color:#0066bb"><b>save</b></span>(<span style="color:#888888"><b>string</b></span>&#160;fileloc,&#160;ResultObjects[]&#160;results)<span style="color:#008800"><b>{</b></span><br /> &#160;&#160;&#160;&#160;<span style="color:#888888">//&#160;place&#160;xml&#160;specific&#160;code&#160;here<br /> </span><span style="color:#008800"><b>}</b></span>
                </p>
                
                <p>
                  <span style="color:#008800"><b>public</b></span>&#160;<span style="color:#008800"><b>class</b></span>&#160;<span style="color:#bb0066"><b>HtmlOutput</b></span>:&#160;IOutput&#160;<span style="color:#008800"><b>{</b></span><br /> &#160;<br /> &#160;&#160;&#160;<span style="color:#008800"><b>public</b></span>&#160;<span style="color:#008800"><b>void</b></span>&#160;<span style="color:#0066bb"><b>save</b></span>(<span style="color:#888888"><b>string</b></span>&#160;fileloc,&#160;ResultObjects[]&#160;results)<span style="color:#008800"><b>{</b></span><br /> &#160;&#160;&#160;&#160;<span style="color:#888888">//&#160;place&#160;html&#160;specific&#160;code&#160;here<br /> </span><span style="color:#008800"><b>}</b></span>
                </p>
                
                <p>
                  <span style="color:#008800"><b>public</b></span>&#160;<span style="color:#008800"><b>class</b></span>&#160;<span style="color:#bb0066"><b>TestRunner</b></span>&#160;<span style="color:#008800"><b>{</b></span><br /> &#160;<br /> &#160;&#160;<span style="color:#008800"><b>private</b></span>&#160;IOutput&#160;_output;<br /> &#160;&#160;<span style="color:#008800"><b>private</b></span>&#160;ITests&#160;_tests;<br /> &#160;&#160;<span style="color:#008800"><b>public</b></span>&#160;<span style="color:#0066bb"><b>StoreTestResults</b></span>(IOutput&#160;output,&#160;ITests&#160;tests)<span style="color:#008800"><b>{</b></span><br /> &#160;&#160;&#160;&#160;_output&#160;=&#160;output;<br /> &#160;&#160;&#160;&#160;_tests&#160;=&#160;tests; <br /> &#160;&#160;<span style="color:#008800"><b>}</b></span><br /> &#160;&#160;<span style="color:#008800"><b>public</b></span>&#160;<span style="color:#008800"><b>void</b></span>&#160;<span style="color:#0066bb"><b>RunTestsFromDir</b></span>(<span style="color:#888888"><b>string</b></span>&#160;testdirectory,&#160;<span style="color:#888888"><b>string</b></span>&#160;outfile)<span style="color:#008800"><b>{</b></span><br /> &#160;&#160;<br /> &#160;&#160;&#160;&#160;var&#160;results&#160;=&#160;_tests.GetResults(testdirectory);<br /> &#160;&#160;&#160;&#160;_output.save(outputfile,&#160;results)<br /> &#160;&#160;<span style="color:#008800"><b>}</b></span>
                </p>
                
                <p>
                  <span style="color:#888888">//later&#160;on&#160;we&#160;use&#160;IoC&#160;containers&#160;to&#160;make&#160;this&#160;chain&#160;easy&#160;<br /> </span><br /> pubilc&#160;<span style="color:#008800"><b>static</b></span>&#160;<span style="color:#008800"><b>void</b></span>&#160;<span style="color:#0066bb"><b>main</b></span>(<span style="color:#888888"><b>string</b></span>[]&#160;args)<span style="color:#008800"><b>{</b></span>
                </p>
                
                <p>
                  &#160;&#160;<span style="color:#888888">//&#160;imagine&#160;contextual&#160;resolution&#160;is&#160;happening&#160;intelligently&#160;<br /> </span>&#160;<span style="color:#888888">//&#160;on&#160;the&#160;resolver&#160;because&#160;someone&#160;did&#160;some&#160;cool&#160;stuff&#160;in&#160;windsor<br /> </span>&#160;&#160;var&#160;runner&#160;=&#160;testcontainer.Resolve<TestRunner>();<br /> &#160;&#160;runner.RunTestsFromDir(args[<span style="color:#0000DD"><b></b></span>],&#160;args[<span style="color:#0000DD"><b>1</b></span>]);<br /> <span style="color:#008800"><b>}</b></span> </div> </div> 
                  
                  <p>
                    &#160;
                  </p>
                  
                  <p>
                    In Python with “monkey patching” everything is “Open For Extension” and dependencies can “always” be injected. A code sample based on my last blog post but extended to include some more complete client code follows:
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      <span style="color:#888888">#in&#160;module&#160;outputlib</span><br /> <span style="color:#008800"><b>class</b></span>&#160;<span style="color:#bb0066"><b>Output</b></span>(<span style="color:#003388">object</span>):<br /> &#160;&#160;<span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>save</b></span>(fileloc,&#160;results):<br /> &#160;&#160;&#160;&#160;<span style="color:#008800"><b>pass</b></span></p> 
                      
                      <p>
                        <span style="color:#008800"><b>class</b></span>&#160;<span style="color:#bb0066"><b>XmlOutput</b></span>(<span style="color:#003388">object</span>):<br /> &#160;&#160;<span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>save</b></span>(fileloc,results):<br /> &#160;&#160;&#160;&#160;&#160;<span style="color:#dd2200">&#8220;&#8221;&#8221;xml&#160;specific&#160;logic&#160;here&#8221;&#8221;&#8221;</span><br /> &#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>pass</b></span>
                      </p>
                      
                      <p>
                        <span style="color:#008800"><b>class</b></span>&#160;<span style="color:#bb0066"><b>HtmlOutput</b></span>(<span style="color:#003388">object</span>):<br /> &#160;&#160;<span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>save</b></span>(fileloc,results):<br /> &#160;&#160;&#160;&#160;&#160;<span style="color:#dd2200">&#8220;&#8221;&#8221;xml&#160;specific&#160;logic&#160;here&#8221;&#8221;&#8221;</span><br /> &#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>pass</b></span>
                      </p>
                      
                      <p>
                        <span style="color:#008800"><b>class</b></span>&#160;<span style="color:#bb0066"><b>TestRunner</b></span>(<span style="color:#003388">object</span>):
                      </p>
                      
                      <p>
                        &#160;&#160;<span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>run_tests_from_dir</b></span>(testdirectory,&#160;outfile):<br /> &#160;&#160;&#160;&#160;tests&#160;=&#160;Tests()<br /> &#160;&#160;&#160;&#160;output&#160;=&#160;Output()<br /> &#160;&#160;&#160;&#160;output.save(&#160;&#160;outfile&#160;&#160;,&#160;tests.get_results(testdirectory)
                      </p>
                      
                      <p>
                        <span style="color:#888888">#rest&#160;of&#160;the&#160;script</span>
                      </p>
                      
                      <p>
                        <span style="color:#008800"><b>import</b></span>&#160;<span style="color:#bb0066"><b>sys</b></span><br /> <span style="color:#008800"><b>import</b></span>&#160;<span style="color:#bb0066"><b>outputlib</b></span>&#160;<span style="color:#008800"><b>as</b></span>&#160;<span style="color:#bb0066"><b>o</b></span>
                      </p>
                      
                      <p>
                        testdirectory&#160;=&#160;sys.argv[<span style="color:#0000DD"><b>1</b></span>]<br /> outfile&#160;=&#160;sys.argv[<span style="color:#0000DD"><b>2</b></span>]<br /> <span style="color:#008800"><b>if</b></span>&#160;outfile.endswith(<span style="color:#dd2200">&#8220;xml&#8221;</span>):<br /> &#160;&#160;o.Output&#160;=&#160;o.XmlOutput&#160;<span style="color:#888888">#globally&#160;override&#160;calls&#160;to&#160;Output&#160;with&#160;XmlOutput.&#160;AKA&#160;Monkey&#160;Patch</span><br /> <span style="color:#008800"><b>elif</b></span>&#160;outfile.endswith(<span style="color:#dd2200">&#8220;html&#8221;</span>):<br /> &#160;&#160;o.Output&#160;=&#160;o.HtmlOutput&#160;<span style="color:#888888">#globally&#160;override&#160;calls&#160;to&#160;Output&#160;with&#160;HtmlOutput&#160;AKA&#160;Monkey&#160;Patch</span><br /> runner&#160;=&#160;o.TestRunner()<br /> runner.run_tests_from_dir(testdirectory,&#160;outfile) </div> </div> 
                        
                        <p>
                          Again this is longer code than the c# example.. but we’ve replaced an <strong>entire IoC container</strong> and whatever custom code we would have had to add to create custom dependency resolver for selecting HTML or XML output options has now been replaced by a simple if else if conditional at the beginning of the code base execution. <strong> Now all calls in this runtime, from any module, that reference the Output class will use XmlOutput or HtmlOutput instead</strong>, all with “monkey patching”.
                        </p>
                        
                        <p>
                          Hopefully, from here the rest of the dominos will fall into place once you get the concepts above, and the things we rely on SOLID for are in some cases already there in dynamic languages. Consequentially, my dynamic code looks (now) nothing like my static code because I no longer have to use DI/IoC to achieve my desired flexibility and access to use proper unit tests.
                        </p>