---
id: 138
title: 'Anonymous Types In C# Are A Crippled Hack'
date: 2010-04-14T12:00:00+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/04/14/anonymous-types-in-c-are-a-crippled-hack.aspx
dsq_thread_id:
  - "262068588"
categories:
  - .NET
  - Android
  - 'C#'
  - Java
---
I’ve been learning a bit of Java recently, reading [Unlocking Android](http://manning.com/ableson/) and playing with the [Android SDK](http://developer.android.com) to try and learn how to write apps for my [Droid](http://www.motorola.com/Consumers/US-EN/Consumer-Product-and-Services/Mobile-Phones/Motorola-DROID-US-EN). I have known, intellectually, about some of the key differences between .NET and Java for quite some times now – how Java doesn’t have properties, how events are done through an Observer pattern, and various other differences. Now that I’m trying to put some of these differences in practice, though, I find some of them to be very intriguing – especially the way events are handled.

Most of the sample code that I see with event handling in Android apps look like this:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> someButton.setOnClickListener(</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span>     <span style="color: #0000ff">new</span> OnClickListener(){</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>         <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> onClick(View v){</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>             <span style="color: #008000">//do something here to handle the click</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span> );</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        The setOnClickListener method expects a parameter of type OnClickListener with a method called onClick(View). Rather than declaring this as a full fledged class definition and instantiating it, we are using an anonymous type with inline instantiation. We are new’ing up an OnClickListener class and declaring the methods of the class instance inline with the object initializer.
      </p>
      
      <p>
        Now look at what we have to do in C#, by comparison:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SomeMethodSomewhere()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     someButton.SetOnClickListener(<span style="color: #0000ff">new</span> MyClickListener());</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span> }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> MyClickListener: OnClickListener</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>     <span style="color: #0000ff">public</span> override <span style="color: #0000ff">void</span> OnClick(View v)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>         <span style="color: #008000">//handle the click here</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              (Please don’t start complaining about my C# example not using the .NET event system saying that we don’t need anonymous types because we have delegates and multi-cast delegates. I’m well aware of delegates and the .NET eventing system. Honestly, I’m very happy with the .NET eventing system. It works very well and is easy to use. I show this example because it illustrates an apples-to-apples implementation difference between Java and C#.)
            </p>
            
            <p>
              The difference may be minor in this small example but it can be rather tedious to have to declare a new class for every single OnClickListener that we want to use. Even if we make OnClickListener an interface, such as IOnClickListener, we will have the same problem and have to declare a new class and implement that interface.
            </p>
            
            <p>
              The problem as I see it is that anonymous types in C# are a crippled, lame hack that were only put in place to <a href="http://msdn.microsoft.com/en-us/library/bb397696.aspx">support the functionality needed for LINQ queries</a>. We can’t declare methods on our anonymous types or instantiate an anonymous type that inherits from anything other than the default Object in C#. This severely limits the capabilities and possibilities of we can do with anonymous types. Honestly, other than ASP.NET MVC Routing declarations and LINQ queries, I have yet to see anyone use an anonymous type in C#.
            </p>
            
            <p>
              …
            </p>
            
            <p>
              Dear Microsoft,
            </p>
            
            <p>
              Please give us full fledged anonymous types in .NET/C# instead of the crippled hack that was put in place to support LINQ. I would especially love to instantiate an interface as an anonymous type:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> PleaseLetMeDoThis()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>     SomeMethod(<span style="color: #0000ff">new</span> ISomeInterface()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>     {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>         <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> DoIt()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span>         {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span>             <span style="color: #008000">//do something here.</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   8:</span>         }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   9:</span>     })</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  10:</span> }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  11:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  12:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SomeMethod(ISomeInterface something)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  13:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  14:</span>     something.DoIt();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  15:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    You’ve given us anonymous methods with delegates. You’ve given us read-only properties in anonymous types. It wouldn’t take that much work to marry the two concepts into a nice syntax like this.
                  </p>
                  
                  <p>
                    kthxbye,
                  </p>
                  
                  <p>
                    &#160;&#160;&#160; -Derick.
                  </p>