---
wordpress_id: 49
title: Decoupling Workflow And Forms With An Application Controller
date: 2009-04-18T18:04:41+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/04/18/decoupling-workflow-and-forms-with-an-application-controller.aspx
dsq_thread_id:
  - "262050653"
categories:
  - .NET
  - AppController
  - 'C#'
  - Design Patterns
  - git
  - Model-View-Presenter
  - Principles and Patterns
redirect_from: "/blogs/derickbailey/archive/2009/04/18/decoupling-workflow-and-forms-with-an-application-controller.aspx/"
---
One of the big problems I’ve been trying to solve recently, is in my current WinForms application that using a Model-View-Presenter setup. I have my workflow between forms coupled to the forms directly. That is, in order to get from MainForm to SubForm, I have code inside of MainForm instantiate SubForm and it’s Presenter. The nightmares of changing any part of the workflow because of this, are astounding. I won’t go into great detail on the problems. It should be sufficient to know that my form codebehind would often contain several hundred lines of code to create all the needed views and presenters for a workflow, per workflow.

### Building A Solution

There are two parts of the solution that I’m trying to use now, that are relatively new to me.

1) Use a good IoC container. I’m using [StructureMap](http://structuremap.sourceforge.net/Default.htm) at the moment. I’ve used Windsor in the past and don’t like some of the default conventions it has. StructureMap’s conventions fit very well with my personal style of development (at least in part because I’ve considered [Jeremy Miller](http://codebetter.com/blogs/jeremy.miller/) to be a mentor – via his blog, etc – for several years now). Although I have done IoC / DI / DIP before, I’ve not used a good IoC container in quite some time. I’ve primarily been using a [ServiceLocator](http://www.martinfowler.com/articles/injection.html#UsingAServiceLocator) and manual [Dependency Inversion](http://www.lostechies.com/blogs/derickbailey/archive/2008/10/07/di-and-ioc-creating-and-working-with-a-cloud-of-objects.aspx).

2) Set up an Application Controller to hide most of the coordination and infrastructure needs, including the IoC container, from the rest of the application. 

### Application Controller

Martin Fowler’s PoEAA book says this about [Application Controllers](http://martinfowler.com/eaaCatalog/applicationController.html):

> _“Some applications contain a significant amount of logic about the screens to use at different points, which may involve invoking certain screens at certain times in an application. This is the wizard style of interaction, where the user is led through a series of screens in a certain order. In other cases we may see screens that are only brought in under certain conditions, or choices between different screens that depend on earlier input._ 
> 
> _To some degree the various Model View Controller input controllers can make some of these decisions, but as an application gets more complex this can lead to duplicated code as several controllers for different screens need to know what to do in a certain situation._ 
> 
> _You can remove this duplication by placing all the flow logic in an Application Controller. Input controllers then ask the Application Controller for the appropriate commands for execution against a model and the correct view to use depending on the application context.”_

For the last month or two, I’ve been trying to [find as much information as possible](http://www.google.com/search?q=Application+Controller), on Application Controller, with little to no luck in finding any information on WinForms development. Then Dino Esposito posted an article on “[The Presenter in MVP Implementations](http://dotnetslackers.com/articles/designpatterns/The-Presenter-in-MVP-Implementations.aspx)” over at DotNetSlackers where he discusses the idea of introducing an Application Controller into an MVP application, to control the workflow. This was exactly what I was looking for… or so I thought. After playing around with the structure that he introduces, I found myself wanting more – specifically wanting a better decoupling of the workflow from the AppController.

### My Application Controller Implementation

After working with various ideas for the last month, I finally have an example implementation that I’m happy with. The core of the sample is the Application Controller, of course. Surprisingly, it is a very simple implementation. The primary functionality that I ended up needing in my Application Controller, is the ability to execute an [ICommand<T>](http://www.lostechies.com/blogs/derickbailey/archive/2008/11/19/ptom-command-and-conquer-your-ui-coupling-problems.aspx) interface, and publish an event via an [EventAggregator](http://martinfowler.com/eaaDev/EventAggregator.html). Both the ICommand<T> and EventAggregator that I use, are heavily influenced by Jeremy Miller’s [Build Your Own CAB](http://codebetter.com/blogs/jeremy.miller/archive/2007/07/25/the-build-your-own-cab-series-table-of-contents.aspx) series.

<div>
  <div>
    <pre><span style="color: #0000ff">using</span> EventAggregator;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #0000ff">using</span> StructureMap;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>&#160;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #0000ff">namespace</span> ApplicationControllerExample.AppController</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>{</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>&#160;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ApplicationController : IApplicationController</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>&#160;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   <span style="color: #0000ff">private</span> IContainer Container { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   <span style="color: #0000ff">private</span> IEventPublisher EventPublisher { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>&#160;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   <span style="color: #0000ff">public</span> ApplicationController(IContainer container, IEventPublisher eventPublisher)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>     Container = container;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>     EventPublisher = eventPublisher;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>     </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>     Container.Inject&lt;IApplicationController&gt;(<span style="color: #0000ff">this</span>);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>&#160;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Execute&lt;T&gt;(T commandData)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>     ICommand&lt;T&gt; command = Container.TryGetInstance&lt;ICommand&lt;T&gt;&gt;();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>     <span style="color: #0000ff">if</span> (command != <span style="color: #0000ff">null</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>       command.Execute(commandData);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>&#160;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Raise&lt;T&gt;(T eventData)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>     EventPublisher.Publish(eventData);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>&#160;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>&#160;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>}</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        I also included an IApplicationController interface definition, for easy Dependency Injection, etc. This interface is a core part of my complete solution, and is referenced by all of my Presenters.
      </p>
      
      <div>
        <div>
          <pre><span style="color: #0000ff">namespace</span> ApplicationControllerExample.AppController</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>{</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IApplicationController</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>   <span style="color: #0000ff">void</span> Execute&lt;T&gt;(T commandData);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>   <span style="color: #0000ff">void</span> Raise&lt;T&gt;(T eventData);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre> }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>}</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <h3>
              Reference IApplicationController From The Presenters
            </h3>
            
            <p>
              With this in place, I can now set up my Presenters to use the IApplicationController instead of having direct references to ICommand<T> objects, or the IEventPublisher object. This allows me to simplify the dependency list in many of the presenters that I have – especially the “Menu” presenter that has 20 or 30 menu commands… one command for each menu item.
            </p>
            
            <p>
              When a Presenter needs to kick off a workflow or raise an event, all it needs to do is call out to the IApplicationController. This allowed the individual presenters and WinForms to be decoupled from the workflow.
            </p>
            
            <div>
              <div>
                <pre><span style="color: #0000ff">using</span> ApplicationControllerExample.AppController;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #0000ff">using</span> ApplicationControllerExample.Model;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #0000ff">using</span> EventAggregator;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>&#160;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #0000ff">namespace</span> ApplicationControllerExample.App</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>{</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>&#160;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> MainPresenter: IEventHandler&lt;SomeEventData&gt;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>&#160;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   <span style="color: #0000ff">private</span> IMainView View { get; set; }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   <span style="color: #0000ff">private</span> IApplicationController AppController { get; set; }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>&#160;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   <span style="color: #0000ff">public</span> MainPresenter(IMainView mainView, IApplicationController appController)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>     View = mainView;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>     AppController = appController;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>     View.Presenter = <span style="color: #0000ff">this</span>;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>&#160;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Run()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>     View.Run();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>&#160;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> DoSomething()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>     AppController.Execute(<span style="color: #0000ff">new</span> SomeCommandData());</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>&#160;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SomethingElseIsHappening()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>     AppController.Raise(<span style="color: #0000ff">new</span> SomeEventData(<span style="color: #006080">"Something done here"</span>));</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>&#160;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Handle(SomeEventData eventData)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>     View.SaySomething(eventData.Message);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>   }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre> }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>&#160;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre>}</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    The call to AppController.Raise() will use the EventAggregator to publish an event of type SomeEventData. In this case, I have the very same presenter registered to handle the event, which isn’t terribly exciting – but it does illustrate the point of it working.
                  </p>
                  
                  <h3>
                    Building An ICommand<T> And Workflow Service
                  </h3>
                  
                  <p>
                    The call to AppController.Execute(), in the above Presenter example, will load up the ICommand<SomeCommandData> object from StructureMap and execute it. The ICommand<SomeCommandData> interface is implemented by an explicit object. This is where I would include any workflow definition that I need to start up and run.
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #0000ff">namespace</span> ApplicationControllerExample.Model</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre>{</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> SomeCommand: ICommand&lt;SomeCommandData&gt;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre>   <span style="color: #0000ff">private</span> ISomeWorkflowService WorkflowService { get; set; }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre>&#160;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre>   <span style="color: #0000ff">public</span> SomeCommand(ISomeWorkflowService workflowService)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre>   {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre>     WorkflowService = workflowService;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre>   }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre>&#160;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Execute(SomeCommandData commandData)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre>   {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre>     WorkflowService.Run();</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre>   }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre> }</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre>}</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          Since I am using StructureMap to instantiate this object, it will inject the ISomeWorkflowService registered instance for me, which depends on a role specific interface called IPartOfTheProcess.
                        </p>
                      </p></p> 
                      
                      <div>
                        <div>
                          <pre><span style="color: #0000ff">namespace</span> ApplicationControllerExample.App</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre>{</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> SomeWorkflowService: ISomeWorkflowService</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre> {</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre>   <span style="color: #0000ff">private</span> IPartOfTheProcess PartOfTheProcess { get; set; }</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre>&#160;</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre>   <span style="color: #0000ff">public</span> SomeWorkflowService(IPartOfTheProcess partOfTheProcess)</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre>   {</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre>     PartOfTheProcess = partOfTheProcess;</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre>   }</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre>&#160;</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Run()</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre>   {</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre>     PartOfTheProcess.DoThatThing();</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre>   }</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre> }</pre>
                          
                          <p>
                            <!--CRLF-->
                          </p>
                          
                          <pre>}</pre>
                          
                          <p>
                            <!--CRLF--></div> </div> 
                            
                            <h3>
                              Looping Back To The App Controller
                            </h3>
                            
                            <p>
                              The IPartOfTheProcess interface is implemented by another Presenter. This Presenter depends on the IApplicationController interface. By having that dependency, I can start the chain all over again. The "SecondaryPresenter” can call out the AppController and execute another command or raise another event to be published.
                            </p>
                            
                            <div>
                              <div>
                                <pre><span style="color: #0000ff">using</span> ApplicationControllerExample.AppController;</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #0000ff">using</span> ApplicationControllerExample.Model;</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>&#160;</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre><span style="color: #0000ff">namespace</span> ApplicationControllerExample.App</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>{</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> SecondaryPresenter: IPartOfTheProcess</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre> {</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>   <span style="color: #0000ff">private</span> ISecondaryView View { get; set; }</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>   <span style="color: #0000ff">private</span> IApplicationController AppController { get; set; }</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>&#160;</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>   <span style="color: #0000ff">public</span> SecondaryPresenter(ISecondaryView view, IApplicationController appController)</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>   {</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>     View = view;</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>     AppController = appController;</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>     View.Presenter = <span style="color: #0000ff">this</span>;</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>   }</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>&#160;</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> DoThatThing()</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>   {</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>     View.Run();</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>   }</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>&#160;</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Whatever()</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>   {</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>     AppController.Raise(<span style="color: #0000ff">new</span> SomeEventData(<span style="color: #006080">"you did what?"</span>));</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>   }</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>&#160;</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> ThatThingHappened(<span style="color: #0000ff">string</span> s)</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>   {</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>     AppController.Raise(<span style="color: #0000ff">new</span> SomeEventData(<span style="color: #006080">"click-o-that menu"</span>));</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>   }</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre> }</pre>
                                
                                <p>
                                  <!--CRLF-->
                                </p>
                                
                                <pre>}</pre>
                                
                                <p>
                                  <!--CRLF--></div> </div> 
                                  
                                  <h3>
                                  </h3>
                                  
                                  <h3>
                                    Conclusions
                                  </h3>
                                  
                                  <p>
                                    I think you get the idea by now… by including the IApplicationController dependency in my presenters, I no longer have to worry about coupling my specific presenters to any part of the workflow, or my workflow to any specific presenters. And notice that I haven’t even mentioned the WinForms that I’ve implemented for the I(whatever)View interfaces. I don’t care anymore. I implement a view interface however I want to, and register that Implementation with StructureMap.
                                  </p>
                                  
                                  <p>
                                    The combination of a good IoC container (pick the one you like; it doesn’t have to be StructureMap), an Application Controller, and some good old Dependency Inversion and Interface Separation (with a healthy dose other <a href="http://www.lostechies.com/blogs/chad_myers/archive/2008/03/07/pablo-s-topic-of-the-month-march-solid-principles.aspx">SOLID principles</a>), can really help to decouple a system, very quickly.
                                  </p>
                                  
                                  <p>
                                    I’m quite happy with this little example, at this point. It is helping me to solve some of the most painful coupling problems that I’ve had in the last 9+ months of my current project. I’m sure I will run into situation in the future, where this simple ApplicationController needs to be extended, though.
                                  </p>
                                  
                                  <h3>
                                    Download The Example App
                                  </h3>
                                  
                                  <p>
                                    As a side note – I used this example app as an opportunity to not only learn the ApplicationController pattern, but also to learn <a href="http://git-scm.com/">Git source control</a>, using <a href="http://code.google.com/p/msysgit/">msysgit</a>. With that in mind, I decided to <a href="http://www.kernel.org/pub/software/scm/git/docs/git-push.html">push</a> the sample app out to <a href="https://github.com/">GitHub</a>.
                                  </p>
                                  
                                  <p>
                                    If you would like to download the entire codebase for this sample, and see how it all comes together to create a working program, you can get it here:
                                  </p>
                                  
                                  <p>
                                    <a title="http://github.com/derickbailey/appcontroller/tree/master" href="http://github.com/derickbailey/appcontroller/tree/master"><strong><font size="4">http://github.com/derickbailey/appcontroller/tree/master</font></strong></a>
                                  </p>