---
wordpress_id: 180
title: Design And Testability
date: 2010-09-10T16:28:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/09/10/design-and-testability.aspx
dsq_thread_id:
  - "262569158"
categories:
  - .NET
  - Behavior Driven Development
  - 'C#'
  - Community
  - Pragmatism
  - Principles and Patterns
  - RSpec
  - Ruby
  - Telerik
  - Tools and Vendors
  - Unit Testing
---
In the line of business applications that I build, it&rsquo;s considered good practice to use a test-first approach; Test-Driven Development, Behavior-Driven Development, or whatever you want to call it. Write a test, verify that it fails for the right reasons, make it pass, refactor the code to ensure it&rsquo;s up to all required standards. How a person goes about doing the implementation of the tests and the code to fulfill the tests depends largely on the platform, language and testing tools used. Each platform has different needs and different ways of approaching the idea of &ldquo;testability&rdquo; in code. Some languages require specific design decisions to enable testable code, while other languages pretty much guarantee that your code will be testable &ndash; even if some designs are easier to test than others.

&nbsp;

### Design And Testability In Ruby

If I were writing some code in Ruby, I could easily test this:

<div style="border: 1px solid silver;text-align: left;padding: 4px;line-height: 12pt;background-color: #f4f4f4;margin: 20px 0px 10px;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;overflow: auto;cursor: text">
  <div style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   1:</span> <span style="color: #0000ff">class</span> Foo</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   2:</span>   def bar</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   3:</span>     baz = Baz.<span style="color: #0000ff">new</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   4:</span>     baz.do_something</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   5:</span>   end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   6:</span> end</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        &nbsp;
      </p>
      
      <p>
        There are a number of options for being able to test the behavior of the Foo class&rsquo;s .bar method. I could use the nature of Ruby&rsquo;s open-type system and just replace the initializer and do_something method on the Baz class; I could use <a href="http://rspec.info/documentation/mocks/">RSpec and it&rsquo;s built in mocking syntax</a>; I could use the <a href="http://github.com/derickbailey/not_a_mock">not-a-mock</a> gem (which is my preference) to stub the methods; etc.
      </p>
      
      <p>
        We essentially get testability in ruby for &ldquo;free&rdquo; &ndash; it&rsquo;s built into the dynamic nature of the language. Other dynamic languages such as Python, etc, also give us testable code by nature of the language. We are not required to do anything special to create code that is &ldquo;testable&rdquo;. Now that doesn&rsquo;t mean all code is easily tested, though. There are still design principles and paradigms that will make your code easier to test, which also tends to lead to code that is easier to understand. The point, though, is that you don&rsquo;t have to do anything special to isolate the behavior of the Foo class from the implementation of the Baz class in the above example.
      </p>
      
      <p>
        &nbsp;
      </p>
      
      <h3>
        Design And Testability In C#
      </h3>
      
      <p>
        Looking at the equivalent code in C#, we would say that this code is not &ldquo;testable&rdquo; from the perspective of unit tests:
      </p>
      
      <div style="border: 1px solid silver;text-align: left;padding: 4px;line-height: 12pt;background-color: #f4f4f4;margin: 20px 0px 10px;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;overflow: auto;cursor: text">
        <div style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Foo</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   3:</span>     <span style="color: #0000ff">public</span> void Bar()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   4:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   5:</span>         <span style="color: #0000ff">var</span> Baz = <span style="color: #0000ff">new</span> Baz();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   6:</span>         Baz.DoSomething();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   7:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   8:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              By all the principles, practices, and design standards that we preach in C# / .NET, this code is not testable because of the hard dependency on the Baz object and it&rsquo;s implementation.
            </p>
            
            <p>
              There are a significant number of principles that are being violated in these few lines of executable behavior, and we would need to change the code in a very significant way to create something that is &ldquo;testable&rdquo;. We would need to introduce an abstraction over Baz &ndash; but ensure that the Foo class owns the abstraction so we don&rsquo;t violate the Dependency Inversion principle. And we would need to introduce Inversion Of Control and some form of Dependency Injection to ensure that Foo is not directly dependent on Baz&rsquo;s implementation (neither the constructor nor the DoSomething method&rsquo;s implementation). The resulting code, to be &ldquo;testable&rdquo; by all accounts, would look something like this:
            </p>
            
            <div style="border: 1px solid silver;text-align: left;padding: 4px;line-height: 12pt;background-color: #f4f4f4;margin: 20px 0px 10px;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;overflow: auto;cursor: text">
              <div style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Foo</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   2:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   3:</span>   <span style="color: #0000ff">private</span> doSomething;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   4:</span>   </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   5:</span>   <span style="color: #0000ff">public</span> Foo(IDoSomething doSomething)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   6:</span>   {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   7:</span>     this.doSomething = doSomething;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   8:</span>   }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   9:</span>   </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  10:</span>   <span style="color: #0000ff">public</span> void Bar()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  11:</span>   {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  12:</span>     doSomething.DoSomething();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  13:</span>   }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  14:</span> }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  15:</span>&nbsp; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  16:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IDoSomething</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  17:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  18:</span>     void DoSomething();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  19:</span> }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  20:</span>&nbsp; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  21:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Baz: IDoSomething</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  22:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  23:</span>     <span style="color: #0000ff">public</span> void DoSomething()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  24:</span>     {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  25:</span>       <span style="color: #008000">// ... whatever this does...</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  26:</span>     }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">  27:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    (Note: I included the shell of the implementation for Baz in this example &ndash; but those extra few lines of code don&rsquo;t diminish the expansion of the rest of the code. I included it to show the requirement of implementing the interface on the Baz class.)
                  </p>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <h3>
                    <span style="text-decoration: line-through">Angels And Demons</span>
                  </h3>
                  
                  <p>
                    <span style="text-decoration: line-through">As a person who dabbles in ruby and that community, I get the sense that we applaud </span><a href="http://en.wikipedia.org/wiki/Yukihiro_Matsumoto"><span style="text-decoration: line-through">Matz</span></a><span style="text-decoration: line-through"> for the open nature of ruby, allowing the great minds of people like </span><a href="http://blog.davidchelimsky.net/"><span style="text-decoration: line-through">David Chelimsky</span></a><span style="text-decoration: line-through"> to develop tools like </span><a href="http://rspec.info/"><span style="text-decoration: line-through">RSpec</span></a><span style="text-decoration: line-through"> with it&rsquo;s built in mocking capabilities. We have the freedom to express the intent of our code without the significant ceremony of the abstraction, dependency inversion, and &ldquo;testable&rdquo; code the we say is required in C#. These people are the heroes &ndash; the angels &#8211; of the ruby community, held in high esteem because they have made the art of &ldquo;testable&rdquo; code approachable by anyone that can write code. And they deserve our applause for these efforts, without question. The tools and capabilities in Ruby and RSpec are quite wonderful and I enjoy working with them.</span>
                  </p>
                  
                  <p>
                    <span style="text-decoration: line-through">Why, then, do we demonize companies with tools like </span><a href="http://www.telerik.com/products/mocking.aspx"><span style="text-decoration: line-through">Telerik&rsquo;s JustMock</span></a><span style="text-decoration: line-through">, </span><a href="http://www.typemock.com/"><span style="text-decoration: line-through">Typemock&rsquo;s various offerings</span></a><span style="text-decoration: line-through">, and </span><a href="http://research.microsoft.com/en-us/projects/pex/"><span style="text-decoration: line-through">Microsoft &ldquo;Pex and Moles</span></a><span style="text-decoration: line-through">&rdquo; for providing the same capabilities in C# / .NET? Why do we attack people like </span><a href="http://weblogs.asp.net/rosherove/"><span style="text-decoration: line-through">Roy Osherove</span></a><span style="text-decoration: line-through"> and dismiss his contributions to the community? Have we become so dogmatic about our &ldquo;principles&rdquo; and &ldquo;standards&rdquo; that we no longer have a sense of pragmatism or exploration and questioning? Has the &ldquo;alt.net&rdquo; community become &ldquo;dogma.net&rdquo;, &ldquo;elitist.net&rdquo;, or &ldquo;hate.net&rdquo; as so many others have suggested, for so many years? What value do we truly gain &ndash; other than the admiration and awe of the people that wish they were &ldquo;smart enough&rdquo; to point out the &ldquo;flaws&rdquo; &ndash; through this continuous disregard for what is a valid perspective and approach to software development in .NET?</span>
                  </p>
                  
                  <p>
                    (<b>Edit:</b> the above content create a whirlwind of comments that would have been better off on another communication channel. I should not have taken the tone and stance that I did with this section. The LosTechies community should not be a place where I rant and say these types of incendiary things. As such, I&rsquo;ve decided to moderate the comments from this post and strike out the above section. Please do not comment on this section, on this blog anymore. I&rsquo;ll remove the comments. Please continue commenting on the rest of the post, though, as I believe it is still valid.)
                  </p>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <h3>
                    What&rsquo;s The Point?
                  </h3>
                  
                  <p>
                    I honestly ask &ndash; why? &hellip; or, why not? If I can write this test in rspec:
                  </p>
                  
                  <div style="border: 1px solid silver;text-align: left;padding: 4px;line-height: 12pt;background-color: #f4f4f4;margin: 20px 0px 10px;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;overflow: auto;cursor: text">
                    <div style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">
                      <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   1:</span> Baz.should_receive(:do_something)</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          or write this test in typemock:
                        </p>
                        
                        <div style="border: 1px solid silver;text-align: left;padding: 4px;line-height: 12pt;background-color: #f4f4f4;margin: 20px 0px 10px;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;overflow: auto;cursor: text">
                          <div style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible">
                            <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   1:</span> <span style="color: #0000ff">var</span> fake = Isolate.Fake.Instance&lt;Baz&gt;();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   2:</span> Isolate.Swap.NextInstance&lt;Baz&gt;().With(Fake);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: white;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   3:</span> <span style="color: #008000">//... run the foo.Bar method, here</span></pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;text-align: left;padding: 0px;line-height: 12pt;background-color: #f4f4f4;margin: 0em;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt;overflow: visible"><span style="color: #606060">   4:</span> Isolate.Verify.WasCalledWithAnyArguments(() =&gt; fake.DoSomething());</pre>
                            
                            <p>
                              <!--CRLF--></div> </div> 
                              
                              <p>
                                why shouldn&rsquo;t I write that one in typemock? Why should we applaud the ruby community for it&rsquo;s contributions and not the .NET community that has given us the same core capabilities. Is it because the capabilities to do this are not &ldquo;free&rdquo; in a static language? Is it because we&rsquo;re afraid of the profiling API that is required to do this in .NET? Is it because we&rsquo;ve become dogmatic instead of pragmatic? Is it because TypeMock is expensive? or is there a legitimate reason that we have emotional reactions and cry-foul the possibilities that these tools introduce?
                              </p>
                              
                              <p>
                                &nbsp;
                              </p>
                              
                              <h3>
                                Searching &hellip;
                              </h3>
                              
                              <p>
                                I don&rsquo;t know the answers. I&rsquo;m asking because I want to find the answers. And yes, I recognized that I still have an attachment to the abstractions and interfaces. I&rsquo;m not gong to go spend the $ on TypeMock or JustMock today, but at least I&rsquo;m asking the question in an open and honest manner. I hope the rest of the <divisive-name>.NET community will join in and begin to question everything we hold sacred. We might actually learn something if we do.
                              </p>