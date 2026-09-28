---
wordpress_id: 140
title: Adding Request / Reply To The Application Controller
date: 2010-04-15T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/04/15/adding-request-reply-to-the-application-controller.aspx
dsq_thread_id:
  - "262068626"
categories:
  - .NET
  - Analysis and Design
  - AppController
  - 'C#'
  - Compact Framework
  - CQRS
  - Design Patterns
  - Messaging
  - Pragmatism
  - Principles and Patterns
redirect_from: "/blogs/derickbailey/archive/2010/04/15/adding-request-reply-to-the-application-controller.aspx/"
---
Back in December of 2009 I had a post on using various [messaging patterns within an application controller](https://lostechies.com/blogs/derickbailey/archive/2009/12/22/understanding-the-application-controller-through-object-messaging-patterns.aspx) as part of an application’s architecture. One of the patterns that I distinctly left out was request/reply. At the time I had not yet implemented a good solution for it. Since then I’ve tried several variations of implementations but had not found anything that I liked for various reasons. However, during a conversation with a coworker today that touched on many different subjects the concept of request/reply came up again. He came up with a quick hack that would allow him to get it done with the existing app controller’s .Execute() method and his idea sparked another idea for a full fledged request/reply implementation. This time, I liked the results that I came up with and I added it to our application controller.

&#160;

### The [Request / Reply](http://www.enterpriseintegrationpatterns.com/RequestReply.html) Pattern

[<img style="border-bottom: 0px;border-left: 0px;margin: 0px 10px 0px 0px;border-top: 0px;border-right: 0px" border="0" alt="image" align="left" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_451AE86F.png" width="81" height="49" />](http://www.enterpriseintegrationpatterns.com/RequestReply.html) When two applications communicate via [_Messaging_](http://www.enterpriseintegrationpatterns.com/Messaging.html), the communication is one-way. The applications may want a two-way conversation.

**When an application sends a message, how can it get a response from the receiver? **Send a pair of _Request-Reply_ messages, each on its own channel.****

The request / reply pattern has a use case that is very similar to a command pattern. It is used for decoupling a part of a process and calling out to an external part of your system or another system altogether. There are a few distinct differences between a command and a request/reply, though. Namely, those differences are:

  * A command is a one way fire and forget and does not need to execute on the same thread, while a request / reply is assumed to block the calling thread while waiting for a reply
  * A command has no direct response, while a request has a response

A command should be able to run asynchronously – imagine if your boss had to wait for you to finish the software before they could do anything else. Nothing would ever get done. A request / reply on the other hand, may block the requesting object while it waits for a reply. This is akin to your boss asking you to print out a report so they can take it to a management meeting. They need to wait for you to return with the report before the continue on into the meeting. It is also possible for a request / reply to run asynchronously and for a command to run synchronously of course. How your system implements these two patterns is a matter of the needs of the system in question.

There are likely other differences to consider and there may be scenarios where these differences don’t hold true, but this is generally a good way to distinguish between a command and a request/reply.

&#160;

### When To Use It

The request / reply pattern is used when you need to have a conversation with another part of a system, or a completely different system, and you do not want to couple the two systems together. In the context of an application controller and object messaging patterns, there are times when all we want to do is make a call from one object to another and get a response that we can use. One example of this is having a confirmation dialog for deleting an item. We need to be able to pop up a confirmation message to the user and have the user’s response determine what the system does next. However, we may not want to couple the object that needs the information to the object that can provide the information. In such a case, it would be awkward to have our object call out to Application.Execute to show the dialog and then have the dialog call Application.Raise with an event that the first object listens to. From a technical standpoint this works perfectly fine, but from an understandability and correct use of patterns standpoint, it is very awkward. After all, why should a developer be forced to make two application controller calls and handle an application event when all they want to do is call a method on an object and get a return value?

To solve this problem and decouple the object from the dialog while still providing a simple, the request/reply pattern can be used:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> SomeResponseData response = appController.RequestReply&lt;SomeRequestData, SomeResponseData&gt;(<span style="color: #0000ff">new</span> SomeRequestData());</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> DoSomethingWithTheResponse(response);</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        &#160;
      </p>
      
      <h3>
        When Not To Use It
      </h3>
      
      <p>
        There are still going to be occasions where it is better to have two objects coupled to each other through a more direct form of abstraction, such as a role-specific interface. A good example of this is the <a href="https://lostechies.com/blogs/derickbailey/archive/2010/03/15/semantic-code-migrating-from-a-chatty-interface-to-a-simple-one-with-a-data-transfer-object.aspx">virtual keyboard that I previously talked about</a>. In that scenario, the form that was needing input from the virtual keyboard was better off making the call directly to the role specific interface, IVirtualKeyboard. Technically speaking it would have worked for the form to call out to a request / reply implementation. The issue in this case was the cost / benefit of the additional layers of indirection and abstraction vs. the need to just call a method and get a response.
      </p>
      
      <p>
        The cost / benefit of abstraction and indirection is an important part of deciding when to use request / reply within a system. There is no clear-cut rule of when it is absolutely wrong to use request / reply in this case, like there is when communicating with external systems. It takes judgment calls by the team that is using the patterns and the team should try to set standards on when and where request / reply is used within the context of the system they are building.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        Request/Reply vs. Command+Event
      </h3>
      
      <p>
        There are times when the right thing to do is a command + an event, rather than a request/reply. A good scenario for this is an asynchronous process. While it is certainly possible from a technical standpoint and may be appropriate in some circumstances, doing a request / reply asynchronously generally goes against the norms of this pattern. Instead, an asynchronous command can be executed and allowed to run on it’s own. Then, when that command has completed it may raise an event that the original caller subscribes to.
      </p>
      
      <p>
        In this scenario it is important to understand that the command being executed may not be the object that raises the event. By having an event handler in an object, the object is stating that it does not necessarily care where the event data comes from – only that it expects to receive that event data at some point in time. With that in mind, calling out to a command still does not have the implication of returning data. Only the expectation of receiving the event data, as evidenced by the presence of the event handler, implies the need for data to be sent to the object.
      </p>
      
      <p>
        &#160;
      </p>
    </p>
    
    <h3>
      Additional Benefits
    </h3>
    
    <p>
      There is an added benefit to using this pattern, related to the use of IoC containers. Part of the conversation that lead to this solution was the need to reduce resource usage in the compact framework application that my team is currently building.
    </p>
    
    <p>
      In a system that makes heavy use of an IoC container for automatic dependency injection, it is very easy for resource usage to get out of hand. For example, if an IoC container is used to instantiate a form and its presenter, and that presenter relies on 3 different interfaces that are implemented by other presenters with each of those presenters relying on an interface that is implemented by another form as well as other interfaces that are implemented by yet more presenters with views… the resource utilization of a system such as this quickly gets out of hand. In this example, there are a minimum of 4 forms that are instantiated and injected into presenters – and that only accounts for the second level of forms in the system. As the system becomes larger and the number of forms and other resource intensive objects being instantiated on start up can quickly get out of hand. This is especially dangerous in a limited resource platform, such as the Compact Framework for Windows Mobile devices – which is the context in which my team is currently using the application controller and these patterns.
    </p>
    
    <p>
      A good command and request / reply implementation can help solve this problem and also provide additional use cases for these patterns. If the application controller’s .Execute and .RequestReply methods use an IoC container in their implementation to instantiate the objects that handle the processing, then we can avoid the unnecessary instantiation of objects. When a call to an interface occurs directly, it is assumed that the interface has an implementation (even if it’s a proxy implementation). When a call to the application controller’s .Execute or .RequestReply methods are made, though, the only object that has an implementation at the time of the call is the application controller and its direct dependencies. When the application controller receives the calls, it uses the IoC container to instantiate the objects that need to be run… essentially lazy loading the required resources.
    </p>
    
    <p>
      A solution such as this will not only cut down on initial resource utilization, but will also help to create a system that appears to be more responsive to the user. Rather than taking 10 to 20 seconds to load all resources and consuming those resources at the beginning of an application’s life, an implementation like this can distribute that time into smaller chunks across the functionality that is called, when that functionality is needed. For example, if the system in question has 10 different buttons and each button uses a command or request / reply, then the 10 to 20 seconds of resource loading will be cut into 1 to 2 seconds of resource load when at the time that the user clicks a button. This gives the user a sense of the application being more responsive because the application starts up faster and only takes a small hit on each button press.
    </p>
    
    <p>
      &#160;
    </p>
    
    <h3>
      The Implementation
    </h3>
    
    <p>
      The implementation for this functionality is fairly simple. We need a few new interfaces and a new method on the application controller. Then the objects that want to provide the request/reply functionality will need to take advantage of those interfaces.
    </p>
    
    <div>
      <div>
        <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IRequestData&lt;TResponse&gt; { }</pre>
        
        <p>
          <!--CRLF--></div> </div> 
          
          <p>
            This first interface is nothing more than a marker interface for the request data objects. The reason for this interface’s existence is to provide type safety during the calls to the application controller’s .RequestReply method. Without this interface defined as such, the .RequestReply method call would not be able to provide the needed information on the type of the return value. This would cause a semantic coupling in the calls to the method because the developer would have to know what the response type is supposed to be. By requiring this interface for the request objects, though, the C# compiler will tell the developer if they are looking for the correct response data type.
          </p>
          
          <p>
            The response objects, on the other hand, have no marker interface. They can be anything from a string, int or other primitive types, to full fledged classes and interfaces, etc.
          </p>
          
          <div>
            <div>
              <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IRequestHandler&lt;TRequest, TResponse&gt;</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   2:</span>   <span style="color: #0000ff">where</span> TRequest : IRequestData&lt;TResponse&gt;</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   3:</span> {</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   4:</span>     TResponse ProcessRequest(TRequest request);</pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   5:</span> }</pre>
              
              <p>
                <!--CRLF--></div> </div> 
                
                <p>
                  The IRequestHandler interface is used to process the request object and return the response value. Note that the TRequest generics type uses a clause to specify that it must be an IRequestData<TResponse>. This is how the compiler knows to check the type of the return data when making the call to the .RequestReply method on the application controller.
                </p>
                
                <div>
                  <div>
                    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IApplicationController</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   2:</span> {</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   3:</span>     <span style="color: #008000">//existing method definitions go here</span></pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   4:</span>&#160; </pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   5:</span>     TResponse RequestReply&lt;TRequest, TResponse&gt;(TRequest request) <span style="color: #0000ff">where</span> TRequest : IRequestData&lt;TResponse&gt;</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   6:</span> }</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   7:</span>&#160; </pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   8:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ApplicationController: IApplicationController</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">   9:</span> {</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">  10:</span>     <span style="color: #008000">//existing implementation goes here</span></pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">  11:</span>     </pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">  12:</span>     <span style="color: #0000ff">public</span> TResponse RequestReply&lt;TRequest, TResponse&gt;(TRequest request)</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">  13:</span>         <span style="color: #0000ff">where</span> TRequest : IRequestData&lt;TResponse&gt;</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">  14:</span>     {</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">  15:</span>         var handler = Container.TryGetInstance&lt;IRequestHandler&lt;TRequest, TResponse&gt;&gt;();</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">  16:</span>         <span style="color: #0000ff">return</span> handler.ProcessRequest(request);</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">  17:</span>     }</pre>
                    
                    <p>
                      <!--CRLF-->
                    </p>
                    
                    <pre><span style="color: #606060">  18:</span> }</pre>
                    
                    <p>
                      <!--CRLF--></div> </div> 
                      
                      <p>
                        These are the changes to the IApplicationController and ApplicationController interface, assuming the use of StructureMap as the IoC container. There is nothing terribly special here, other than the interface method that is defined needs to have the same clause on the TRequest generics type.
                      </p>
                      
                      <p>
                        &#160;
                      </p>
                      
                      <h3>
                        A Simple Example Of Use
                      </h3>
                      
                      <p>
                        This code may not actually do anything, but it does show the use of the functionality.
                      </p>
                      
                      <div>
                        <div>
                          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> SomeRequestData : IRequestData&lt;SomeResponseData&gt;</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   2:</span> {</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   3:</span>     <span style="color: #008000">//some relevant properties and method for the request data, goes here</span></pre>
                          
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
                          
                          <pre><span style="color: #606060">   6:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> SomeResponseData</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   7:</span> {</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   8:</span>     <span style="color: #008000">//some relevant properties and methods for the response data, goes here</span></pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">   9:</span> }</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  10:</span>&#160; </pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  11:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> SomeRequestHandler : IRequestHandler&lt;SomeRequestData, SomeResponseData&gt;</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  12:</span> {</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  13:</span>&#160; </pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  14:</span>     <span style="color: #0000ff">public</span> SomeResponseData ProcessRequest(SomeRequestData request)</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  15:</span>     {</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  16:</span>         <span style="color: #008000">//handle the request here and process it, producing a response</span></pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  17:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> SomeResponseData();</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  18:</span>     }</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  19:</span>&#160; </pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  20:</span> }</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  21:</span>&#160; </pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  22:</span>&#160; </pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  23:</span> <span style="color: #008000">//this class makes use of the request/reply functionality</span></pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  24:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> DoStuff</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  25:</span> {</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  26:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Foo()</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  27:</span>     {</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  28:</span>         IApplicationController appController = <span style="color: #0000ff">null</span>; <span style="color: #008000">// = get my AppController however i want</span></pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  29:</span>         <span style="color: #008000">//make the request/reply call and get the response</span></pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  30:</span>         SomeResponseData response = appController.RequestResponse&lt;SomeRequestData, SomeResponseData&gt;(<span style="color: #0000ff">new</span> SomeRequestData());</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  31:</span>         DoSomethingWithTheResponse(response);</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  32:</span>     }</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre><span style="color: #606060">  33:</span> }</pre>
                          
                          <p>
                            <!--CRLF--></div> </div> 
                            
                            <p>
                              Note that this code explicitly supplies the type of the TRequest and TResponse data. Without providing these the C# compiler won’t be able to determine what types to use. However, providing the wrong return type for the request will also produce a compiler error thanks to the generics clauses that we added to the IRequestData<T> interface.
                            </p>
                            
                            <p>
                              &#160;
                            </p>
                            
                            <h3>
                              Download The Reference Implementations
                            </h3>
                            
                            <p>
                              The <a href="https://github.com/derickbailey/appcontroller">appcontroller</a> and <a href="https://github.com/derickbailey/appcontroller.cf">appcontroller.cf</a> implementations over at github will be updated with this functionality, shortly. Feel free to take the source code directly from this blog post or grab it from there.
                            </p>