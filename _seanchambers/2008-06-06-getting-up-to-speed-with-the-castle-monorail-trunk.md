---
wordpress_id: 3176
title: Getting up to speed with the Castle.MonoRail trunk
date: 2008-06-06T11:40:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2008/06/06/getting-up-to-speed-with-the-castle-monorail-trunk.aspx
dsq_thread_id:
  - "262830160"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2008/06/06/getting-up-to-speed-with-the-castle-monorail-trunk.aspx/"
---
Over the last couple of months there have been a slew of great refactorings done on the castle monorail trunk. Some of these refactorings were inspired by ASP.Net MVC changes such as the new routing module. I have just now started to play with monorail trunk so I am by no means an expert on the changes that were done there. If you are interested in getting up to speed as well. The best thing to do is get a fresh copy of the monorail trunk and start looking through the source code specifically on Controller, EngineContext, ControllerContext and IController. After looking at the changes for only an hour or so and updating a project up to the monorail trunk, I can already get a good idea of where things logically should belong now.


  


**General Changes**


  



  


  * 
  
    <DIV>
      The controller class has been split up into Controller and ControllerContext. A good deal of Controller &#8220;metadata&#8221; has been moved to ControllerContext. In addition, an IController interface has been created that is now used within all the Castle services.
    </DIV>
    
    
  
      * 
  
        <DIV>
          RailsEngineContext has been renamed to simply EngineContext.
        </DIV>
        
        
  
          * 
  
            <DIV>
              The ExecuteEnum has been renamed to ExecuteWhen which makes more sense to me.
            </DIV>
            
            
  
              * 
  
                <DIV>
                  Certain services have been removed from the Controller
                </DIV>
            
            
  
              * 
  
                <DIV>
                  The EngineContextModule has ceased to exist
                </DIV></UL>
            
            
  
            **Routing Functionality**
            
            
  
            This is the coolest part of the refactorings. Instead of relying on ugly xml configuration for our routes, we can now configure them within our HttpApplication class using the PatternRoute class. This was the hardest portion to find documentation on. There are some postings on the castle project google group that helped me along. You can find the [posting here](http://groups.google.com/group/castle-project-devel/browse_thread/thread/55c12e2fda84d999/7e01f48ca88d4ffd?#7e01f48ca88d4ffd). In addition to reading that, the best way to get familiar with the new routing functionality is to download the trunk and take a look at the Routing tests. They are pretty descriptive and allowed me to wrap my head around them. To outline some of the routing functionality I have an example of a route in one of my applications:
            
            
  
            <DIV>
              <br /> 
              
              <DIV>
                <PRE><SPAN>   1:</SPAN> rules.Add(<SPAN>new</SPAN> PatternRoute(<SPAN>&#8220;/&lt;controller&gt;/&lt;action&gt;&#8221;</SPAN>)</PRE>
                
                <PRE><SPAN>   2:</SPAN>     .DefaultForAction().Is(<SPAN>&#8220;index&#8221;</SPAN>));</PRE>
              </DIV>
            </DIV>
            
            
  
            The rules class is an instance of RoutingModuleEx.Engine that you can obtain in your global application. We then pass the Add method a new PatternRoute. This is where we define the route to match.
            
            
  
            This route will match anything followed by anything,&nbsp;It will then map anything between <controller>, and pass it along as the controller parameter, and pass along <action> as the action parameter. If no action is passed, a default of &#8220;index&#8221; will be applied. Specifying a parameter as [something] makes it optional, while <something> is a required parameter. The thing that took me a minute to understand is, when constructing the route, anything you make as a parameter is passed along to the action at hand. This means that if you have a parameter to your action that is someThing, you can place it in your route and that part of the url will be passed along as that parameter. To display this I have another example:
            
            
  
            <DIV>
              <br /> 
              
              <DIV>
                <PRE><SPAN>   1:</SPAN> rules.Add(<SPAN>new</SPAN> PatternRoute(<SPAN>&#8220;/something/&lt;parent&gt;/&lt;param2&gt;/&lt;param3&gt;/&#8221;</SPAN>)</PRE>
                
                <PRE><SPAN>   2:</SPAN>     .DefaultForController().Is(<SPAN>&#8220;somecontroller&#8221;</SPAN>)</PRE>
                
                <PRE><SPAN>   3:</SPAN>     .DefaultForAction().Is(<SPAN>&#8220;view&#8221;</SPAN>));</PRE>
              </DIV>
            </DIV>
            
            
  
              
            This route is a little more complex. To get a better idea of how this works, take a look at the associated action signature:
            
            
  
            <DIV>
              <br /> 
              
              <DIV>
                <PRE><SPAN>   1:</SPAN> <SPAN>public</SPAN> <SPAN>void</SPAN> View(<SPAN>string</SPAN> parent, <SPAN>string</SPAN> param2, <SPAN>string</SPAN> param3);</PRE>
              </DIV>
            </DIV>
            
            
  
              
            As you can see from this example, you can name the parameters to pass along to the action. On that same note, you can specify parameters that aren&#8217;t included in the url like so:
            
            
  
            <DIV>
              <br /> 
              
              <DIV>
                <PRE><SPAN>   1:</SPAN> rules.Add(<SPAN>new</SPAN> PatternRoute(<SPAN>&#8220;/area/&lt;param1&gt;&#8221;</SPAN>)</PRE>
                
                <PRE><SPAN>   2:</SPAN>     .DefaultForController().Is(<SPAN>&#8220;someOthercontroller&#8221;</SPAN>)</PRE>
                
                <PRE><SPAN>   3:</SPAN>     .DefaultForAction().Is(<SPAN>&#8220;view&#8221;</SPAN>)</PRE>
                
                <PRE><SPAN>   4:</SPAN>     .DefaultFor(<SPAN>&#8220;someOtherParam&#8221;</SPAN>).Is(<SPAN>&#8220;someValue&#8221;</SPAN>));</PRE>
              </DIV>
            </DIV>
            
            
  
              
            In this example we are calling the view action on SomeOtherController that would take a signature as follows:
            
            
  
            <DIV>
              <br /> 
              
              <DIV>
                <PRE><SPAN>   1:</SPAN> <SPAN>public</SPAN> <SPAN>void</SPAN> View(<SPAN>string</SPAN> param1, <SPAN>string</SPAN> someOtherParam);</PRE>
              </DIV>
            </DIV>
            
            
  
              
            As you can see, the someOtherParam will always have a static value that we define. Not sure if this would be useful to most people but I have already had a use for it when constructing dynamic routes.
            
            
  
            One of the more complex parts of the refactorings is definately the routing. There are quite a few posts on them on the Castle Project Users Group and the Development Group so do some searches there if you have more questions about the routes.
            
            
  
            That&#8217;s it for now. Next time we can dive more into the refactorings and changes on the trunk. Feel free to ask any questions!</p>