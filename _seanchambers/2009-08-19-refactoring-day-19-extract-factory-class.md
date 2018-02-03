---
wordpress_id: 3213
title: 'Refactoring Day 19 : Extract Factory Class'
date: 2009-08-19T12:30:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/19/refactoring-day-19-extract-factory-class.aspx
dsq_thread_id:
  - "262353538"
categories:
  - Uncategorized
---
Todays refactoring was first coined by the <a href="http://www.dofactory.com" target="_blank">GangOfFour</a> and has many resources on the web that have different usages of this pattern. Two different aims of the factory pattern can be found on the GoF website <a href="http://dofactory.com/Patterns/PatternFactory.aspx" target="_blank">here</a> and <a href="http://dofactory.com/Patterns/PatternAbstract.aspx" target="_blank">here</a>.

Often in code some involved setup of objects is required in order to get them into a state where we can begin working with them. Uusally this setup is nothing more than creating a new instance of the object and working with it in whatever manner we need. Sometimes however the creation requirements of this object may grow and clouds the original code that was used to create the object. This is where a Factory class comes into play. For a full description of the factory pattern you can <a href="http://en.wikipedia.org/wiki/Factory_method_pattern" target="_blank">read more here</a>. On the complex end of the factory pattern is for creating families of objects using Abstract Factory. Our usage is on the basic end where we have one factory class creating one specific instance for us. Take a look at the code before:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> PoliceCarController</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">PoliceCar</span> New(<span class="kwrd">int</span> mileage, <span class="kwrd">bool</span> serviceRequired)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   5:</span>         PoliceCar policeCar = <span class="kwrd">new</span> PoliceCar();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   6:</span>         policeCar.ServiceRequired = serviceRequired;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   7:</span>         policeCar.Mileage = mileage;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   8:</span>&nbsp; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   9:</span>         <span class="kwrd">return</span> policeCar;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  10:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  11:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        <!--CRLF-->
      </p>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        As we can see, the new action is responsible for creating a PoliceCar and then setting some initial properties on the police car depending on some external input. This works fine for simple setup, but over time this can grow and the burden of creating the police car is put on the controller which isn&rsquo;t really something that the controller should be tasked with. In this instance we can extract our creation code and place in a Factory class that has the distinct responsibility of create instances of PoliceCar&rsquo;s
      </p>
      
      <div class="csharpcode-wrapper">
        <div class="csharpcode">
          <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">interface</span> IPoliceCarFactory</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   3:</span>     PoliceCar Create(<span class="kwrd">int</span> mileage, <span class="kwrd">bool</span> serviceRequired);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   4:</span> }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   5:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   6:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> PoliceCarFactory : IPoliceCarFactory</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   7:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   8:</span>     <span class="kwrd">public</span> PoliceCar Create(<span class="kwrd">int</span> mileage, <span class="kwrd">bool</span> serviceRequired)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   9:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  10:</span>         PoliceCar policeCar = <span class="kwrd">new</span> PoliceCar();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  11:</span>         policeCar.ReadForService = serviceRequired;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  12:</span>         policeCar.Mileage = mileage;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  13:</span>         <span class="kwrd">return</span> policeCar;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  14:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  15:</span> }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  16:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  17:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> PoliceCarController</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  18:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  19:</span>     <span class="kwrd">public</span> IPoliceCarFactory PoliceCarFactory { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  20:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  21:</span>     <span class="kwrd">public</span> PoliceCarController(IPoliceCarFactory policeCarFactory)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  22:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  23:</span>         PoliceCarFactory = policeCarFactory;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  24:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  25:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  26:</span>     <span class="kwrd">public</span> PoliceCar New(<span class="kwrd">int</span> mileage, <span class="kwrd">bool</span> serviceRequired)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  27:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  28:</span>         <span class="kwrd">return</span> PoliceCarFactory.Create(mileage, serviceRequired);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  29:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  30:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              &nbsp;
            </p>
            
            <p>
              Now that we have the creation logic put off to a factory, we can add to that one class that is tasked with creating instances for us without the worry of missing something during setup or duplicating code.
            </p>
            
            <p>
              &nbsp;
            </p>
            
            <p>
              <em>This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the </em><a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx"><em>original introductory post</em></a><em>.</em>
            </p>