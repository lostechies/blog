---
id: 85
title: An Alternate Way To Handle Task Dependencies In Custom Rake Tasks
date: 2009-09-18T00:30:25+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2009/09/17/an-alternate-way-to-handle-task-dependencies-in-custom-rake-tasks.aspx
dsq_thread_id:
  - "262068337"
categories:
  - Craftsmanship
  - Lambda Expressions
  - Rake
  - Ruby
---
Earlier today, [I showed how to create a custom Rake task from the base TaskLib](http://www.lostechies.com/blogs/derickbailey/archive/2009/09/17/how-a-net-developer-hacked-out-a-rake-task.aspx), so that we can use more than just simple “task :name” syntax for our rake tasks. In that example, I showed how to add explicit support for task dependencies by adding a second parameter to the initializer of our custom task:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> attr_accessor :name, :task_dependencies</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span> def initialize(name = :some_name, task_dependencies = {})</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>   @name = name</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>   @task_dependencies = task_dependencies</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>   yield self <span style="color: #0000ff">if</span> block_given?</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>   define</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span> <span style="color: #0000ff">end</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span> def define</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>   task name =&gt; task_dependencies <span style="color: #0000ff">do</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>     #... some code here</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>   <span style="color: #0000ff">end</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span> <span style="color: #0000ff">end</span></pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        This code works, as shown earlier and provides the ability to execute dependency tasks prior to this one:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> FooTask.<span style="color: #0000ff">new</span> :somename, [:someothertask, :andanother] <span style="color: #0000ff">do</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span>   # ... task detail here</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span> <span style="color: #0000ff">end</span></pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              It turns out there is a much less explicit, much more ruby-ish way to do the same thing. It seems that rake understands that the name of the task (the :name accessor) is to be treated as if it were a method. Since all methods in ruby have an implicit lambda block, as we’ve seen, we don’t have to include the explicit version of the :task_dependencies in our code. We can simplify the custom task and remove all of the :task_dependencies usage. Then we only need to call the => lamba when setting the name of the task in our rake file.
            </p>
            
            <p>
              This example task, with no explicit :task_dependencies works the same as the example from the earlier post, today:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">class</span> FooTask &lt; Rake::TaskLib</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span>     </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>     attr_accessor :name</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>     </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>     def initialize(name = :test)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span>         @name = name</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span>         yield self <span style="color: #0000ff">if</span> block_given?</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   8:</span>         define</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   9:</span>     <span style="color: #0000ff">end</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  10:</span>     </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  11:</span>     def define</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  12:</span>         task name <span style="color: #0000ff">do</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  13:</span>             puts <span style="color: #008000">'I Run Second'</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  14:</span>         <span style="color: #0000ff">end</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  15:</span>     <span style="color: #0000ff">end</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  16:</span>     </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  17:</span> <span style="color: #0000ff">end</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  18:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  19:</span> FooTask.<span style="color: #0000ff">new</span> :foo =&gt; [:bar] <span style="color: #0000ff">do</span></pre>
                
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
                
                <pre><span style="color: #606060">  22:</span> task :bar <span style="color: #0000ff">do</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  23:</span>     puts <span style="color: #008000">'I Run First'</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  24:</span> <span style="color: #0000ff">end</span></pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    The result of running ‘rake foo’ on this code, is this:
                  </p>
                  
                  <p>
                    <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_0ABDF510.png" width="387" height="179" />
                  </p>
                  
                  <p>
                    As you can see, the dependency task of ‘:bar’ is executed first, as expected.
                  </p>
                  
                  <p>
                    Considering everything that I’ve been learning about ruby in the last few days, I have to say that this feels more like the ruby way of coding. It is far less explicit, reduced code, still as functional, and has the syntax of a standard ‘task :foo => :bar do’ call that most rake users are familiar with.
                  </p>