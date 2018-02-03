---
wordpress_id: 144
title: 'Resource Usage: IoC Containers And Large Object Graphs'
date: 2010-04-21T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/04/21/resource-usage-ioc-containers-and-large-object-graphs.aspx
dsq_thread_id:
  - "262068677"
categories:
  - .NET
  - 'C#'
  - Design Patterns
  - Principles and Patterns
---
In my about [adding request/reply to the app controller](/blogs/derickbailey/archive/2010/04/15/adding-request-reply-to-the-application-controller.aspx), I talked about some resource usage problems that IoC containers can introduce if they are not used properly. Here&rsquo;s that original text, again:

> In a system that makes heavy use of an IoC container for automatic dependency injection, it is very easy for resource usage to get out of hand. For example, if an IoC container is used to instantiate a form and its presenter, and that presenter relies on 3 different interfaces that are implemented by other presenters with each of those presenters relying on an interface that is implemented by another form as well as other interfaces that are implemented by yet more presenters with views&hellip; the resource utilization of a system such as this quickly gets out of hand. In this example, there are a minimum of 4 forms that are instantiated and injected into presenters &ndash; and that only accounts for the second level of forms in the system. As the system becomes larger and the number of forms and other resource intensive objects being instantiated on start up can quickly get out of hand. This is especially dangerous in a limited resource platform, such as the Compact Framework for Windows Mobile devices &ndash; which is the context in which my team is currently using the application controller and these patterns.

I went on to talk about how the request/reply and command pattern implementations in my app controller would help to alleviate this problem by lazy loading the command and request handlers through an IoC container. All of this is still true, of course. I&rsquo;m only repeating this because I felt that it was worth bringing to the foreground of it&rsquo;s own post instead of hiding in the background of another subject matter.

In addition to the lazy loaded command and request handlers, though, there are other ways of making an IoC container behave and keep resource usage down to a minimum.

&nbsp;

### Autofac And Binding To A Func<T>

Joskha pointed out in the comments of the request/reply post that IoC containers like Autofac &ldquo;can auto generate Func<T> dependencies given a registration of T.&rdquo;&nbsp; The idea is to register a Func<T> that returns the instance of the object or interface. As a pseudo-code example (not for any real IoC container, just to express the intent of the idea via code):

<div style="border: 1px solid silver;margin: 20px 0px 10px;padding: 4px;overflow: auto;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;cursor: text">
  <div style="border-style: none;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> ISomething { }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   2:</span>&nbsp; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   3:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> SomeImplementation: ISomething { }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   4:</span>&nbsp; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   5:</span> <span style="color: #008000">//pseudo-code for an IoC container registration</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   6:</span> RegisterWithFunc&lt;ISomething&gt;(() =&gt; {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   7:</span>     <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> SomeImplementation();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   8:</span> });</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        This will have the same lazy-load effect that I talked about previously by injecting a proxy class into the ISomething dependency and calling the registered Func<T> from the proxy as soon as it is accessed by anything.&nbsp; Joshka stated that Autofac can do this. I&rsquo;m fairly sure Ninject can do this, too. I&rsquo;m not sure about StructureMap, Unity, Spring.NET or any of the other .NET containers, though. Can someone else confirm the different containers?
      </p>
      
      <p>
        For those containers that may not have this capability build in, though, it&rsquo;s not terribly difficult to set this up manually.
      </p>
      
      <p>
        &nbsp;
      </p>
      
      <h3>
        Proxying A Single Method
      </h3>
      
      <p>
        This solution was originally posted in my complaint about <a href="/blogs/derickbailey/archive/2010/04/14/anonymous-types-in-c-are-a-crippled-hack.aspx">C# anonymous types being crippled</a>. <a href="http://www.adverseconditionals.com/">Harry M</a> suggested a workaround that uses a delegate in a generic proxy class that would let us sort-of have anonymous types in C#. The suggestion was a good one and I ended up using it not for anonymous types, but as a way to provide lazy-loading proxies to my IoC container&rsquo;s registration.
      </p>
      
      <p>
        Here&rsquo;s the code that Harry posted in the comment:
      </p>
      
      <div style="border: 1px solid silver;margin: 20px 0px 10px;padding: 4px;overflow: auto;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;cursor: text">
        <div style="border-style: none;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ActionClickListener: OnClickListener</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   3:</span>    Action&lt;View&gt; _action;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   4:</span>    </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   5:</span>    <span style="color: #0000ff">public</span> ActionClickListener(Action&lt;View&gt; action)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   6:</span>    {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   7:</span>           _action = action</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   8:</span>    }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   9:</span>    </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  10:</span>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> OnClick(View v)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  11:</span>    {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  12:</span>        _action(v);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  13:</span>    }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  14:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              In this particular code example, the OnClickListener base class would provide an OnClick(Vew v) method definition, which is implemented by calling out to an Action<View> that we passed into the constructor. <a href="http://mattmc3.blogspot.com/">Mattmc3</a> then provided a usage example a few comments later:
            </p>
            
            <div style="border: 1px solid silver;margin: 20px 0px 10px;padding: 4px;overflow: auto;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;cursor: text">
              <div style="border-style: none;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   1:</span> OnClickListener ocl = <span style="color: #0000ff">new</span> ActionClickListener(</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   2:</span>     <span style="color: #0000ff">delegate</span>(View v) {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   3:</span>         <span style="color: #008000">// do whatever I want to here</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   4:</span>         <span style="color: #008000">// Console.WriteLine("delegate");</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   5:</span>     }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   6:</span> );</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    We can use this code as a proxy class to lazy load our dependency in the same way the Func<T> functionality in Autofac works without actually needing that functionality baked into our IoC container. All we need is the ability to register a specific instance of an object against our interface or base class type. In this case, our pseudo-code registration would look like this:
                  </p>
                  
                  <div style="border: 1px solid silver;margin: 20px 0px 10px;padding: 4px;overflow: auto;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;cursor: text">
                    <div style="border-style: none;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">
                      <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   1:</span> <span style="color: #008000">//pseudo-code for an IoC container registration</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   2:</span> RegisterInstance&lt;OnClickListener&gt;(ocl);</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          Here we are registering the ocl instance of the ActionClickListener as the type of object to return for the OnClickListener base class. When the OnClickListener is injected into an object that expects it and that object calls the .OnClick method of the OnClickListener base class, our proxy class (ActionClickListener) will call the code that was defined in the constructor&rsquo;s Action<View> delegate. This, again, allows us to lazy load the the real dependencies at runtime.
                        </p>
                        
                        <p>
                          &nbsp;
                        </p>
                        
                        <h3>
                          Proxying A Complete Interface
                        </h3>
                        
                        <p>
                          You can easily combine the Action<T> of the previous example with a full interface proxy using the Func<T> idea from Autofac, as well:
                        </p>
                        
                        <div style="border: 1px solid silver;margin: 20px 0px 10px;padding: 4px;overflow: auto;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;cursor: text">
                          <div style="border-style: none;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IAnotherInterface</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   2:</span> {    </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   3:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Execute();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   4:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SomethingElse();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   5:</span> }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   6:</span>&nbsp; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   7:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> MyPresenter</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   8:</span> {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   9:</span>     <span style="color: #0000ff">private</span> IAnotherInterface _iDoSomethingSpecific;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  10:</span>     <span style="color: #0000ff">public</span> MyPresenter(IAnotherInterface iDoSomethingSpecific)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  11:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  12:</span>         _iDoSomethingSpecific = iDoSomethingSpecific;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  13:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  14:</span>     </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  15:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> DoWhatever()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  16:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  17:</span>         _iDoSomethingSpecific.Execute();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  18:</span>         _iDoSomethingSpecific.SomethingElse();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  19:</span>     }    </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  20:</span> }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  21:</span>&nbsp; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  22:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> TheProxy: IAnotherInterface</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  23:</span> {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  24:</span>     Func&lt;IAnotherInterface&gt; _lazyLoad;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  25:</span>     IAnotherInterface _something;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  26:</span>     </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  27:</span>     <span style="color: #0000ff">public</span> SpecificCommandProxy(Func&lt;IAnotherInterface&gt; lazyLoad)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  28:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  29:</span>         _lazyLoad = lazyLoad</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  30:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  31:</span>     </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  32:</span>     <span style="color: #0000ff">private</span> IAnotherInterface EnsureSomething()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  33:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  34:</span>         <span style="color: #0000ff">if</span> (_something == <span style="color: #0000ff">null</span>)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  35:</span>         {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  36:</span>             _something = _lazyLoad();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  37:</span>         }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  38:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  39:</span>     </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  40:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Execute()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  41:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  42:</span>         EnsureSomething();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  43:</span>         <span style="color: #0000ff">return</span> _something.Execute();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  44:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  45:</span>     </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  46:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SomethingElse()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  47:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  48:</span>         EnsureSomething();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  49:</span>         <span style="color: #0000ff">return</span> _something.SomethingElse();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  50:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  51:</span> }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  52:</span>&nbsp; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  53:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ActualImplementation: IAnotherInterface</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  54:</span> {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  55:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Execute()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  56:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  57:</span>         <span style="color: #008000">//do the real processing, here</span></pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  58:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  59:</span>     </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  60:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SomethingElse()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  61:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  62:</span>         <span style="color: #008000">//more processing of the real stuff goes here</span></pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  63:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  64:</span> }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  65:</span>&nbsp; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  66:</span> <span style="color: #008000">//pseudo-code to register with a full proxy</span></pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  67:</span> Register&lt;IAnotherInterface&gt;(<span style="color: #0000ff">new</span> TheProxy(() =&gt; {<span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> ActualImplementation(); }));</pre>
                            
                            <p>
                              <!--CRLF--></div> </div> 
                              
                              <p>
                                This example provides a complete implementation of the Func<T> capabilities that Autofac has built into it and allows a full interface to be proxy&rsquo;d rather than just a single method proxy like the example from Harry M.
                              </p>
                              
                              <p>
                                &nbsp;
                              </p>
                              
                              <h3>
                                Other Resource Management Solutions
                              </h3>
                              
                              <p>
                                I&rsquo;m fairly sure that other IoC containers and general IoC container best practices will include other methods of managing resources. Perhaps your IoC container has an auto-proxy for lazy loading in a manner that is similar to NHibernate. Or StructureMap, for example, has the concept of type interceptors built in, which would easily allow you to build a lazy loading proxy.
                              </p>
                              
                              <p>
                                What resource management techniques do you use with your IoC container(s)?
                              </p>