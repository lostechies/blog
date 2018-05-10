---
wordpress_id: 111
title: 'Role Specific Interfaces: DIP And ISP In Action'
date: 2010-03-07T19:56:07+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/03/07/role-specific-interfaces-dip-and-isp-in-action.aspx
dsq_thread_id:
  - "275363510"
categories:
  - .NET
  - 'C#'
  - Model-View-Presenter
  - Principles and Patterns
redirect_from: "/blogs/derickbailey/archive/2010/03/07/role-specific-interfaces-dip-and-isp-in-action.aspx/"
---
I do most of my UI development – in ASP.NET WebForms and in WinForms – with a Model-View-Presenter setup. It helps me keep my application logic separate from my view implementations, makes it possible to unit test the presenters, etc. I also like to use custom controls – often with their own presenter &#8211; to help encapsulate UI related process and keep my UI implementations clean. The challenge with custom controls is getting them to converse to each other and getting the parent form to converse with the controls. My favorite way of solving this challenge is through simple [messaging patterns](https://lostechies.com/blogs/derickbailey/archive/2009/12/22/understanding-the-application-controller-through-object-messaging-patterns.aspx). This gives you a lot of control and ensures your system is nice and decoupled. Of course, there is a cost/benefit tradeoff that needs to be considered. There may not need the indirection and potential complexities that come along with those solutions. The system in question may not need a messaging system, event aggregator, command pattern or whatever else. There are times when its easier and makes more sense to forego these patterns and have the presenters talk directly to each other. 

&#160;

### Role Specific Interfaces

When the cost of the messaging pattern architecture out-weighs the benefits, stick to simple abstractions that still&#160; keep the presenters decoupled by one layer. This can easily be done with an interface or abstract base class in static languages like C#, Java and C++. However, don’t take the easy way out in this abstraction and creating a one-to-one mapping between the abstraction and the implementation. Doing so will create a semantic coupling between the two presenters. 

For example, the IProductCodeSelectionPresenter may have the following definition:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IProductCodeSelectionPresenter</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>   <span style="color: #0000ff">void</span> Initialize();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>   <span style="color: #0000ff">void</span> ProductCodeSelected(ProductCode code);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>   ProductCode GetSelectedProductCode();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>   <span style="color: #0000ff">void</span> SelectionCancelled();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>   <span style="color: #0000ff">void</span> SelectionConfirmed();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>&#160; </pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        Which of these methods should another presenter call in order to retrieve the ProductCode? Should GetSelectedProductCode be called? Does this method guarantee the view to select a product code was run and that the product code has been specified by the user? Or maybe the ProductCodeSelected method should be called instead, or Initialize or … This easy-to-create interface may cause semantic coupling by forcing another developer to look at the implementation in order to know which methods should be called, when.
      </p>
      
      <p>
        It would be better to define a role that the presenter is playing in the communication and create an interface that is specific to that role. In this situation, the name of the presenter provides some insight to what role the presenter is playing &#8211; product code selection. A simple role specific interface for this presenter may look like this:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IProductCodeSelector</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>   ProductCode GetProductCode();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              With an interface defined like this, a developer calling this code will not have any confusion on what needs to be called. There is no need to look at the implementation of the interface, and semantic coupling has been avoided. Making a call to this interface is easy.
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              The Interface Segregation Principle (ISP)
            </h3>
            
            <p>
              The driving principle in making the decision to create the role specific interface is often the <a href="https://lostechies.com/blogs/rhouston/archive/2008/03/14/ptom-the-interface-segregation-principle.aspx">Interface Segregation Principle</a> (ISP). This principles says that we should not force a client – the code that is calling out to our interface – to know about methods and properties that it does not need.
            </p>
            
            <p>
              In this case, the client code does not need to know that the interface sits on top of a presenter. Therefore, take the name “presenter” out of the interface that the client calls. This gives the interface more flexibility for the future and prevents the client code from knowing that a view and user input is likely to be the implementation. The client code also doesn’t need to know about the Initialize, ProductCodeSelected and other methods that the presenter has. These methods are specific to the interactions between the View implementation and the Presenter – a different role that the presenter is playing. By removing these methods from the interface, the client code is no longer bound to the knowledge of which methods should and should not be called, when.
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              The Dependency Inversion Principle (DIP)
            </h3>
            
            <p>
              The <a href="https://lostechies.com/blogs/jimmy_bogard/archive/2008/03/31/ptom-the-dependency-inversion-principle.aspx">Dependency Inversion Principle</a> (DIP) may also be at play in this scenario. DIP is not just about creating an abstraction and passing it into a constructor. That would only be dependency abstraction and dependency injection. Rather, DIP talks about abstraction ownership. In the case of a role specific interface, the owner of that interface is the code that depends on it – the client code that calls out to it.
            </p>
            
            <p>
              If another presenter, such as a ProductDefinitionPresenter, is the driving force behind the need to create the IProduceCodeSelector interface, then this presenter should own that abstraction. This means that the ProductDefinitionPresenter determines what that interface looks like. What methods and properties are available, and the name of the interface are all driven by the needs of the ProductDefinitionPresenter.
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ProductDefinitionPresenter</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>   <span style="color: #0000ff">private</span> IProductCodeSelector ProductCodeSelector;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>   <span style="color: #0000ff">public</span> ProductDefinitionPresenter(IProductCodeSelector productCodeSelector)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span>   {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span>     ProductCodeSelector = productCodeSelector;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   8:</span>   }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   9:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  10:</span>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SelectProductCode()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  11:</span>   {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  12:</span>     var productCode = ProductCodeSelector.GetProductCode();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  13:</span>     <span style="color: #008000">//do something with the productCode, here</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  14:</span>   }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  15:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    There is not syntax or markup that declares ProductDefinitionPresenter as the owner of this interface, in this example. That responsibility is left to the standards, conventions and organizational means of the system in question and the team that maintains it.
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    Other Considerations
                  </h3>
                  
                  <p>
                    Model-View-Presenter scenarios are not the only place that roles need to be considered. Any time two or more objects interact and there is a need for them to be decoupled, the roles that the objects are playing need to be considered. There are likely other principles and patterns that come into play when considering a role specific interface, as well. Each scenario’s needs must be considered for their own reasons, and ISP and DIP may not always be at play when defining an interface for an object. And role specific interfaces are not always needed. There are other benefits to creating interfaces or other abstractions that can be referenced in place of concrete implementations such as dependency injection, general decoupling, creating service layer or other context specific barriers, etc.
                  </p>