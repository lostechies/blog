---
wordpress_id: 175
title: How To Build Custom Rake Tasks; The Right Way
date: 2010-07-26T21:04:46+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/07/26/how-to-build-custom-rake-tasks-the-right-way.aspx
dsq_thread_id:
  - "262110356"
categories:
  - Albacore
  - Rake
redirect_from: "/blogs/derickbailey/archive/2010/07/26/how-to-build-custom-rake-tasks-the-right-way.aspx/"
---
A long time ago (last year) I wrote a few blog posts that talked about how I was going about creating some custom rake tasks. This turned out to be the beginning of my albacore project and I’ve been working on that project for nearly a year now. It’s been a lot of fun and I’ve learned a lot in the process of creating and maintaining it. One of the things I learned recently is that the way I am currently handling task creation – the way that I talked about in those posts – is not the best way to do it. There is, in fact, a much easier way to create a custom rake task: the _Rake::Task.define_task_ method.

&#160;

### A Simple Rake Task

The following code creates a rake task called “foo”, then defines a task named :bar and sets it up to run as the default task.

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> def foo(*args, &block)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span>   Rake::Task.define_task(*args, &block)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span> end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span> foo :bar <span style="color: #0000ff">do</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>   puts <span style="color: #006080">"this is coming from the task called :bar, which is a foo task"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span> end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span> task :<span style="color: #0000ff">default</span> =&gt; [:bar] </pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        Lines 1 through 3 show how simple it actually is to define a rake task. Obviously I haven’t done anything useful with this task, but it illustrates the point.&#160; The call to Rake::Task.define_task on line 2 is where the real magic happens. Well, ok… there’s nothing magical about this… at all. I’ve defined a method on line 1 and I’ve called that method on line 5. the name :bar is passed into the *args parameter and the do … end block is passed into the &block parameter. Both of those are then passed into the define_task method. Running <em>rake</em> on this rakefile produces the simple message that you see in the <em>puts</em> statements on line 6.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        A Useful Rake Task
      </h3>
      
      <p>
        At this point, any valid ruby code you want can be used to define a rake task. You only need to provide a minimum of a name to the define_task method and you’re good to go. The code block to define the method body is optional and can be provided by any code that you want. You can also take different parameters than the define_task needs, as long as you provide what define_task needs when it needs it.
      </p>
      
      <p>
        For example, you could easily create a very simple task to copy files, like this:
      </p>
    </p>
    
    <div>
      <div>
        <pre><span style="color: #606060">   1:</span> def copy(name, src, dest, *args)</pre>
        
        <p>
          <!--CRLF-->
        </p>
        
        <pre><span style="color: #606060">   2:</span>   args || args = []</pre>
        
        <p>
          <!--CRLF-->
        </p>
        
        <pre><span style="color: #606060">   3:</span>   args.insert 0, name</pre>
        
        <p>
          <!--CRLF-->
        </p>
        
        <pre><span style="color: #606060">   4:</span>   </pre>
        
        <p>
          <!--CRLF-->
        </p>
        
        <pre><span style="color: #606060">   5:</span>   body = proc {</pre>
        
        <p>
          <!--CRLF-->
        </p>
        
        <pre><span style="color: #606060">   6:</span>     FileList[src].each <span style="color: #0000ff">do</span> |f|</pre>
        
        <p>
          <!--CRLF-->
        </p>
        
        <pre><span style="color: #606060">   7:</span>       puts <span style="color: #006080">"Copying #{f} To #{dest}"</span></pre>
        
        <p>
          <!--CRLF-->
        </p>
        
        <pre><span style="color: #606060">   8:</span>       FileUtils.cp f, dest</pre>
        
        <p>
          <!--CRLF-->
        </p>
        
        <pre><span style="color: #606060">   9:</span>     end</pre>
        
        <p>
          <!--CRLF-->
        </p>
        
        <pre><span style="color: #606060">  10:</span>   }</pre>
        
        <p>
          <!--CRLF-->
        </p>
        
        <pre><span style="color: #606060">  11:</span>   Rake::Task.define_task(*args, &body)</pre>
        
        <p>
          <!--CRLF-->
        </p>
        
        <pre><span style="color: #606060">  12:</span> end</pre>
        
        <p>
          <!--CRLF-->
        </p>
        
        <pre><span style="color: #606060">  13:</span>&#160; </pre>
        
        <p>
          <!--CRLF-->
        </p>
        
        <pre><span style="color: #606060">  14:</span> copy :copysomefiles, <span style="color: #006080">"*.rb"</span>, <span style="color: #006080">"/temp/"</span></pre>
        
        <p>
          <!--CRLF-->
        </p>
        
        <pre><span style="color: #606060">  15:</span>&#160; </pre>
        
        <p>
          <!--CRLF-->
        </p>
        
        <pre><span style="color: #606060">  16:</span> task :<span style="color: #0000ff">default</span> =&gt; [:copysomefiles]</pre>
        
        <p>
          <!--CRLF--></div> </div> 
          
          <p>
            Line 11 will copy all of the .rb files from the current folder into the temp folder on the root of your drive… more importantly, though, it is a first class citizen in the rake task list, giving you all the capabilities of task depdenencies, parameterized tasks, etc.
          </p>
          
          <div>
            <div>
              <pre><span style="color: #606060">   1:</span> copy :copyoutput =&gt; [:initialize, :build, :test], <span style="color: #006080">"**/*.rb"</span>, <span style="color: #006080">"/myproject/"</span></pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   2:</span>&#160; </pre>
              
              <p>
                <!--CRLF-->
              </p>
              
              <pre><span style="color: #606060">   3:</span> task :<span style="color: #0000ff">default</span> =&gt; :copyoutput</pre>
              
              <p>
                <!--CRLF--></div> </div> 
                
                <p>
                  This simple snippet sets up a :copyoutput task with 3 dependencies and then sets up the default task to run it.
                </p>
                
                <p>
                  &#160;
                </p>
                
                <h3>
                  Cleaning Up
                </h3>
                
                <p>
                  I’m glad I found this… it is going to greatly simplify the things I have been doing to create rake tasks – especially when it comes to Albacore. The code that I have in Albacore’s create_task method is pretty ugly, involves inheritance and a few other hacks that I’m not so fond of. The worst of it, though, is that it’s very difficult to change because it’s hard to see what’s really happening. Simplifying things down into small methods that call Rake::Task.define_task should greatly improve the infrastructure of Albacore, though.
                </p>
                
                <p>
                  I hope this information is useful for others, as well. If even one person has that “aha!” moment and realizes how easy it is to create your own rake tasks, than this blog post has done it’s job. 🙂
                </p>