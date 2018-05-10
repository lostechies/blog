---
wordpress_id: 83
title: How A .NET Developer Hacked Out A Rake Task
date: 2009-09-17T15:19:49+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/09/17/how-a-net-developer-hacked-out-a-rake-task.aspx
dsq_thread_id:
  - "262272694"
categories:
  - .NET
  - 'C#'
  - Craftsmanship
  - Lambda Expressions
  - Rake
  - Ruby
redirect_from: "/blogs/derickbailey/archive/2009/09/17/how-a-net-developer-hacked-out-a-rake-task.aspx/"
---
I spent the last two days having my brain melted by [Scott Bellware](http://blog.scottbellware.com/), in a crash course on [Ruby](http://www.ruby-lang.org), [Rake](http://rake.rubyforge.org/), [RSpec](http://rspec.info/), [Selenium](http://seleniumhq.org/), web UI test automation best practices, and all-around uber-normal-person-language-oriented development. It was great! After the first 7 hour day, I felt like I had been awake for 24 hours. After the second 8 hour day, I felt like I actually knew something about Ruby and good web UI test automation practices.

&#160;

### Will The Real Rake Task Please Stand Up

In the conversations and snappy banter that ensued during and after the sessions, Scott and I talked a little about Rake and building what he referred to as ‘real’ Rake tasks instead of the ‘not-Rakeish’ tasks that most people build. By ‘not-Rakeish’, Scott was talking about our propensity as .NET developers to make everything a class and make heavy use of the “system.Object of Rake: the ‘task’”. This point is illustrated by a google search of ‘[build custom rake task](http://lmgtfy.com/?q=build+custom+rake+task)’. Practically every result that comes up will show you how to use “task :somename do … end” and call “rake :somename”.

Whether or not you think using standard ruby objects in a standard rake ‘task’ is ‘Rakeish’ or not, isn’t really the point. Of course that works. Yes, many people do it that way, because it works. The point Scott was making is that professional tools like RSpec and Selenium don’t provide tasks in that way.&#160; We don’t see these simple constructs being used. Rather, we see professional tasks being built so that we can call something more like this:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> Spec::Rake::SpecTask.<span style="color: #0000ff">new</span> <span style="color: #0000ff">do</span> |t|</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span>   t.ruby_opts = [<span style="color: #008000">'-rtest/unit']</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>   t.spec_files = FileList[<span style="color: #008000">'test/**/*_test.rb']</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span> <span style="color: #0000ff">end</span></pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        That conversation with Scott and some other conversations around the idea of <a href="https://lostechies.com/blogs/derickbailey/archive/2009/04/08/how-a-net-developer-learned-ruby-and-rake-to-build-net-apps-in-windows.aspx">building .NET solutions with Rake</a> got me thinking about how we could build a much more ‘professional’, ‘real’ Rake task to call out to MSBuild. While I have not yet put this solution together, I have spent some time learning how to build tasks such as the RSpec ‘SpecTask’ shown above. Not surprisingly, it’s a very simple endeavor. I honestly don’t claim to understand exactly why everything in my hacked-together custom task is set up the way it is, but I have a pretty good idea of what’s going on, at this point. So, I wanted to share my newfound knowledge and hopefully inspire some of the .NET Rake building people out there to create something a little more ‘Rakeish’, rather than just using the default ‘task :whatever’ syntax and calling into an ‘MSBuild’ object.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        Defining A Custom Rake Task Using TaskLib
      </h3>
      
      <p>
        Since I was unable to find any good info via my google search, I started examining the RSpec rake task and the Selenium rake tasks that were installed via the gems. The first thing I found is that I needed to have the ‘rake’ and ‘rake/tasklib’ files, so that I could create a class that inherits from ‘TaskLib’. For example, I can create a task called “FooTask” like this:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> require <span style="color: #008000">'rake'</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> require <span style="color: #008000">'rake/tasklib'</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span> <span style="color: #0000ff">class</span> FooTask &lt; Rake::TaskLib</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span> <span style="color: #0000ff">end</span></pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              This basic definition gives me a task that I can use via Rake. However, it doesn’t really do anything yet and doesn’t even have a name that we can call from rake.
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              Giving The Task A Name
            </h3>
            
            <p>
              To set up a good task name to use, we need to include a ‘:name’ accessor (think auto property in c#) and parameter in the initializer. This name will be used later, to tell the TaskLib base class what the name of the task is, at runtime.
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">class</span> FooTask &lt; Rake::TaskLib</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span>   attr_accessor :name</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>   def initialize(name = :some_default_name)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>     @name = name</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>   <span style="color: #0000ff">end</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span> <span style="color: #0000ff">end</span></pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    Notice the ‘:some_default_name"’ – this does exactly what it sounds like… sets the default name of the task. In this case, we are literally giving the name a default of ‘some_default_name’. We are then setting the @name (which has been automatically generated by the ‘attr_accessor :name’ usage… again, this is like an auto property in C#).
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    Letting The Task Do Custom Work
                  </h3>
                  
                  <p>
                    If we want to provide the ability for the user of the task to actually do some work, we need to include the lambda block evaluation that ruby has built in. This is done by yielding self if a lambda block is present, in the constructor.
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> def initialize(name = :test)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span>   @name = name</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span>   yield self <span style="color: #0000ff">if</span> block_given?</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span> <span style="color: #0000ff">end</span></pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          this block of code let’s us call our custom task with a ‘do … end lambda’ block
                        </p>
                        
                        <div>
                          <div>
                            <pre><span style="color: #606060">   1:</span> FooTask.<span style="color: #0000ff">new</span> <span style="color: #0000ff">do</span> |t|</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   2:</span>  #<span style="color: #0000ff">do</span> stuff <span style="color: #0000ff">with</span> t, here</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   3:</span> <span style="color: #0000ff">end</span></pre>
                            
                            <p>
                              <!--CRLF--></div> </div> 
                              
                              <p>
                                The ‘|t|’ in this code refers to the actual FooTask instance that we yielded (‘self’), and will let us have access to all of the methods in the FooTask object, once we add some.
                              </p>
                              
                              <p>
                                &#160;
                              </p>
                              
                              <h3>
                                Defining The Default Work To Do
                              </h3>
                              
                              <p>
                                In all of the custom rake tasks that I have examined so far, I have found a method called ‘define’ that appears to be a standard convention for rake tasks as the location of code that gets executed by the custom task that we are creating. This method calls the TaskLib method ‘task’ with a name parameter (the name we supplied in the initializer) and then does the work. For example, RSpec does all of it’s spec parsing and running from here, and Selenium does all of it’s server initializing or shutdown here. For this example, we’re just going to print some junk out to the screen.
                              </p>
                              
                              <div>
                                <div>
                                  <pre><span style="color: #606060">   1:</span> def define</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   2:</span>   task name <span style="color: #0000ff">do</span></pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   3:</span>     puts <span style="color: #008000">'some test being printed'</span></pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   4:</span>   <span style="color: #0000ff">end</span></pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   5:</span> <span style="color: #0000ff">end</span></pre>
                                  
                                  <p>
                                    <!--CRLF--></div> </div> 
                                    
                                    <p>
                                      The ‘task name’ code is important here, as it provide rake with the knowledge of the task’s name, so that we can call it from the rake command line.
                                    </p>
                                    
                                    <p>
                                      &#160;
                                    </p>
                                    
                                    <h3>
                                      Running What We Have
                                    </h3>
                                    
                                    <p>
                                      At this point, we have enough code in place to run the sample rake task. Create a ‘rakefile’ with all of the above code, then add code similar to how we called the ‘SpecTask’ earlier. The contents of the rakefile should be:
                                    </p>
                                    
                                    <div>
                                      <div>
                                        <pre><span style="color: #606060">   1:</span> require <span style="color: #008000">'rake'</span></pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   2:</span> require <span style="color: #008000">'rake/tasklib'</span></pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   3:</span>&#160; </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   4:</span> <span style="color: #0000ff">class</span> FooTask &lt; Rake::TaskLib</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   5:</span>&#160; </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   6:</span>   attr_accessor :name</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   7:</span>&#160; </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   8:</span>   def initialize(name = :test)</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   9:</span>     @name = name</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  10:</span>     yield self <span style="color: #0000ff">if</span> block_given?</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  11:</span>     define</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  12:</span>   <span style="color: #0000ff">end</span></pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  13:</span>&#160; </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  14:</span>   def define</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  15:</span>     task name <span style="color: #0000ff">do</span></pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  16:</span>       puts <span style="color: #008000">'some test being printed'</span></pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  17:</span>     <span style="color: #0000ff">end</span></pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  18:</span>   <span style="color: #0000ff">end</span></pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  19:</span> <span style="color: #0000ff">end</span></pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  20:</span>&#160; </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  21:</span> FooTask.<span style="color: #0000ff">new</span> :my_task <span style="color: #0000ff">do</span></pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  22:</span> <span style="color: #0000ff">end</span></pre>
                                        
                                        <p>
                                          <!--CRLF--></div> </div> 
                                          
                                          <p>
                                            Notice that we are giving the task a new name when we call ‘FooTask.new :my_task’. The name is being set to ‘my_task’. We can now run the task from rake via a shell prompt (command prompt in windows):
                                          </p>
                                          
                                          <p>
                                            <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_686300B0.png" width="365" height="157" />
                                          </p>
                                          
                                          <p>
                                            So we now have a custom rake task that is much more ‘Rakeish’. However, it’s still not terribly useful. There is no way to get data into the task and there is no way to call any dependencies before this task.
                                          </p>
                                          
                                          <p>
                                            &#160;
                                          </p>
                                          
                                          <h3>
                                            Adding Data To The Task
                                          </h3>
                                          
                                          <p>
                                            To add data, methods, or do something useful with the task, we can use all the usual ruby ways – methods with parameters, with ‘=’ assignment, attr_accessors, etc etc. For simplicity, let’s use an attr_accessor to create a ‘property’ (I know, it’s not really a property in Ruby, but it sure behaves like one). We’ll add an accessor call ‘:data’ and we’ll have the define method write that data out instead of our hard coded string.
                                          </p>
                                          
                                          <div>
                                            <div>
                                              <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">class</span> FooTask &lt; Rake::TaskLib</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   2:</span>&#160; </pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   3:</span>   attr_accessor :name, :data</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   4:</span>&#160; </pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   5:</span>   def initialize(name = :test)</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   6:</span>     @name = name</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   7:</span>     yield self <span style="color: #0000ff">if</span> block_given?</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   8:</span>     define</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   9:</span>   <span style="color: #0000ff">end</span></pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">  10:</span>&#160; </pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">  11:</span>   def define</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">  12:</span>     task name <span style="color: #0000ff">do</span></pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">  13:</span>       puts @data</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">  14:</span>     <span style="color: #0000ff">end</span></pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">  15:</span>   <span style="color: #0000ff">end</span></pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">  16:</span> <span style="color: #0000ff">end</span></pre>
                                              
                                              <p>
                                                <!--CRLF--></div> </div> 
                                                
                                                <p>
                                                  Adding the data accessor will let us use the ‘|t|’ yielded to our task at runtime, like this:
                                                </p>
                                                
                                                <div>
                                                  <div>
                                                    <pre><span style="color: #606060">   1:</span> FooTask.<span style="color: #0000ff">new</span> :my_task <span style="color: #0000ff">do</span> |t|</pre>
                                                    
                                                    <p>
                                                      <!--CRLF-->
                                                    </p>
                                                    
                                                    <pre><span style="color: #606060">   2:</span>   t.data = <span style="color: #006080">"I'm using the data accessor!"</span></pre>
                                                    
                                                    <p>
                                                      <!--CRLF-->
                                                    </p>
                                                    
                                                    <pre><span style="color: #606060">   3:</span> <span style="color: #0000ff">end</span></pre>
                                                    
                                                    <p>
                                                      <!--CRLF--></div> </div> 
                                                      
                                                      <p>
                                                        Now when we run the task again, we get this output:
                                                      </p>
                                                      
                                                      <p>
                                                        <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_67F6CDBB.png" width="385" height="169" />
                                                      </p>
                                                      
                                                      <p>
                                                        Using this basic pattern, along with other methods, accessors, etc. we can begin to create a task that can do much more for us by allowing the user of the task to provide configuration of the task at runtime.
                                                      </p>
                                                      
                                                      <p>
                                                        &#160;
                                                      </p>
                                                      
                                                      <h3>
                                                        Calling Dependency Tasks
                                                      </h3>
                                                      
                                                      <p>
                                                        The last thing I want to show for now, is how to add the ability to call task dependencies when calling our custom task.
                                                      </p>
                                                      
                                                      <p>
                                                        In the ‘task :somename’ style of usage, we may want to call other tasks as dependencies of ‘somename’. This is done by using a lambda with the task names. For example:
                                                      </p>
                                                      
                                                      <div>
                                                        <div>
                                                          <pre><span style="color: #606060">   1:</span> task :somename =&gt; [:somedepdency, :anotherdependency, :whatever, :etc] <span style="color: #0000ff">do</span></pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">   2:</span>  # <span style="color: #0000ff">do</span> stuff here</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">   3:</span> <span style="color: #0000ff">end</span></pre>
                                                          
                                                          <p>
                                                            <!--CRLF--></div> </div> 
                                                            
                                                            <p>
                                                              This code would call the ‘somedependency’, ‘anotherdependency’, ‘whatever’, and ‘etc’ tasks before running the ‘somename’ task.
                                                            </p>
                                                            
                                                            <p>
                                                              To provide this same dependency execution in our custom task, we first need to provide a way to specify the dependencies. We can do this by adding a second parameter to the initializer, with a default value that shows we have no dependencies, and then calling the that parameter as a method or hash of methods after storing it in another accessor.
                                                            </p>
                                                            
                                                            <div>
                                                              <div>
                                                                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">class</span> FooTask &lt; Rake::TaskLib</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   2:</span>&#160; </pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   3:</span>   attr_accessor :name, :task_dependencies, :data</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   4:</span>&#160; </pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   5:</span>   def initialize(name = :test, task_dependencies = {})</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   6:</span>     @name = name</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   7:</span>     yield self <span style="color: #0000ff">if</span> block_given?</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   8:</span>     @task_dependencies = task_dependencies</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   9:</span>     define</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">  10:</span>   <span style="color: #0000ff">end</span></pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">  11:</span>&#160; </pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">  12:</span>   def define</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">  13:</span>     task name =&gt; task_dependencies <span style="color: #0000ff">do</span></pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">  14:</span>       puts @data</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">  15:</span>     <span style="color: #0000ff">end</span></pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">  16:</span>   <span style="color: #0000ff">end</span></pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">  17:</span> <span style="color: #0000ff">end</span></pre>
                                                                
                                                                <p>
                                                                  <!--CRLF--></div> </div> 
                                                                  
                                                                  <p>
                                                                    Notice the additional ‘task_dependencies’ accessor, the assignment of an empty hash as the default value in the initializer, storage of the parameter in the ‘task_dependencies’ accessor variable, and then the ‘ => task_dependencies’ lambda execution in the define method. This basic code set allows us to specify a number of dependent tasks and have them executed prior to our custom task executing.
                                                                  </p>
                                                                  
                                                                  <p>
                                                                    To set a dependency for this task, we only need to add the task names as the second parameter to the constructor in our rakefile. Here’s example rakefile with all of our code, a simple task to use as a dependency, and our custom task being called with that dependency.
                                                                  </p>
                                                                  
                                                                  <div>
                                                                    <div>
                                                                      <pre><span style="color: #606060">   1:</span> require <span style="color: #008000">'rake'</span></pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">   2:</span> require <span style="color: #008000">'rake/tasklib'</span></pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">   3:</span>&#160; </pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">   4:</span> <span style="color: #0000ff">class</span> FooTask &lt; Rake::TaskLib</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">   5:</span>&#160; </pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">   6:</span>   attr_accessor :name, :task_dependencies, :data</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">   7:</span>&#160; </pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">   8:</span>   def initialize(name = :test, task_dependencies = {})</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">   9:</span>     @name = name</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  10:</span>     yield self <span style="color: #0000ff">if</span> block_given?</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  11:</span>     @task_dependencies = task_dependencies</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  12:</span>     define</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  13:</span>   <span style="color: #0000ff">end</span></pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  14:</span>&#160; </pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  15:</span>   def define</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  16:</span>     task name =&gt; task_dependencies <span style="color: #0000ff">do</span></pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  17:</span>       puts @data</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  18:</span>     <span style="color: #0000ff">end</span></pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  19:</span>   <span style="color: #0000ff">end</span></pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  20:</span> <span style="color: #0000ff">end</span></pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  21:</span>&#160; </pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  22:</span> FooTask.<span style="color: #0000ff">new</span> :my_task, :call_me_first <span style="color: #0000ff">do</span> |t|</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  23:</span>   t.data = <span style="color: #006080">"I'm using the data accessor!"</span></pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  24:</span> <span style="color: #0000ff">end</span></pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  25:</span>&#160; </pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  26:</span> task :call_me_first <span style="color: #0000ff">do</span></pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  27:</span>   puts <span style="color: #006080">"I'm called first, because I'm the dependency!"</span></pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">  28:</span> <span style="color: #0000ff">end</span></pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF--></div> </div> 
                                                                        
                                                                        <p>
                                                                          The output of this task with its dependency is this:
                                                                        </p>
                                                                        
                                                                        <p>
                                                                          <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_678A9AC6.png" width="424" height="169" />
                                                                        </p>
                                                                        
                                                                        <p>
                                                                          &#160;
                                                                        </p>
                                                                        
                                                                        <h3>
                                                                          Moving On
                                                                        </h3>
                                                                        
                                                                        <h3>
                                                                        </h3>
                                                                      </p></p> </p> </p> </p> </p> 
                                                                      
                                                                      <p>
                                                                        Now that we have all of the core parts of a real, ‘Rakeish’ custom task in place, we can easily move our FooTask out into it’s own ‘FooTask.rb’ file and have it be a required file in our Rakefile. We could even package this up as a gem and have it be available for installation via the gem system. However, this is not a professional quality task, at this point. There are no tests written for this task, and it doesn’t really do anything valuable other than show how to hack together a custom rake task.
                                                                      </p>
                                                                      
                                                                      <p>
                                                                        I hope that this little tutorial will at least provide some inspiration to the rest of my Rake using .NET developing colleagues out there in the world, though. I’d really like to see (and will probably build and distribute) a much more professional ‘MSBuild’ rake task, based on this new found knowledge. There are plenty of MSBuild ruby objects out there… it shouldn’t be that difficult to convert it into a rake task and put some unit tests around it.
                                                                      </p>