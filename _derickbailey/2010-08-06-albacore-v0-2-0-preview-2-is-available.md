---
wordpress_id: 177
title: Albacore v0.2.0 Preview 2 Is Available
date: 2010-08-06T19:42:26+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/08/06/albacore-v0-2-0-preview-2-is-available.aspx
dsq_thread_id:
  - "265409339"
categories:
  - Albacore
  - Rake
redirect_from: "/blogs/derickbailey/archive/2010/08/06/albacore-v0-2-0-preview-2-is-available.aspx/"
---
I’ve pushed another preview release of [albacore](http://albacorebuild.net) up to [rubygems.org](http://rubygems.org/gems/albacore/versions/0.2.0.preview2). This release builds on the changes that I talked about in the [Preview 1 Notes](http://www.lostechies.com/blogs/derickbailey/archive/2010/07/14/albacore-v0-2-0-preview-1-is-available.aspx) and adds (what I think is) some great new capabilities for contributors and end-users, both.

&#160;

## Installing The Preview

This is all you need to install the preview version:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> gem install albacore --pre</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        The inclusion of ‘&#8211;pre’ on the command line will tell the gem system that you want to install the latest preview version of albacore. You will then need to modify your rake file to use the preview version (v0.2.0.preview2):
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">require</span> <span style="color: #006080">'rubygems'</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> gem <span style="color: #006080">'albacore'</span>, <span style="color: #006080">'=0.2.0.preview2'</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span> <span style="color: #0000ff">require</span> <span style="color: #006080">'albacore'</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>&#160; </pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              The second line tells the gem system to use the specific version of Albacore that you want, when the Albacore gem is required.
            </p>
            
            <p>
              &#160;
            </p>
            
            <h2>
              A Refocus (Again)
            </h2>
            
            <p>
              In the preview 1 notes, I talked about a few tasks being removed and gave a reason why – to focus albacore down to it’s core of build related tasks. In the time since then, there has been numerous discussions of this on the albacore mailing list. The end result of the discussion was a realization that the focus of albacore should not be “build” vs deploy tasks, but “high quality, value adding” tasks related to building .NET based systems. This shift in focus came after some great counterpoints and discussion on how build vs. deploy is often a gray area, and how splitting out into multiple gems for these concerns would likely be a bad thing in the long run. Rather than focus on an arbitrary distinction such as build vs. deploy, we are now moving forward with the idea that the tasks we do include should be of the highest quality and should add significant value. We shouldn’t repeat a task or a capability that is found elsewhere in ruby or a ruby gem unless we are creating something that is truly valuable and unique in comparison.
            </p>
            
            <p>
              Note that the tasks listed as going away in the preview 1 notes are still going away. We are simply re-stating why they are going away: they didn’t add value, or they duplicated functionality that can be found elsewhere.
            </p>
            
            <p>
              &#160;
            </p>
            
            <h2>
              Albacore Task Updates
            </h2>
            
            <p>
              There are not a lot of task updates in this preview release, but the ones that are there are fairly significant.
            </p>
            
            <h2>
            </h2>
            
            <p>
              &#160;
            </p>
            
            <h3>
              CSC Task
            </h3>
            
            <p>
              A handful of new options have been put into this task, which should hopefully make it close to if not ready for prime-time. I imagine that we’ll still need some additional options, but this version of the csc task is on the right track.
            </p>
            
            <p>
              The new options include:
            </p>
            
            <ul>
              <li>
                <strong>debug</strong>: tell csc whether or not (and how much) debug information to put into the assembly.
              </li>
              <li>
                <strong>define</strong>: set compiler symbols for your builds
              </li>
              <li>
                <strong>doc</strong>: generate xml documentation for your assembly
              </li>
              <li>
                <strong>optimize</strong>: optimize the code in your assembly
              </li>
              <li>
                <strong>resources</strong>: embed resources into your assembly. this is a simple version that only embeds files directly. no options for identifier or accessibility exist, yet.
              </li>
            </ul>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> csc :build <span style="color: #0000ff">do</span> |csc|</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span>   csc.resources <span style="color: #006080">"file1"</span>, <span style="color: #006080">"file2"</span>, ... <span style="color: #006080">"fileN"</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>   csc.debug = <span style="color: #0000ff">true</span> <span style="color: #008000"># true, false, :full, :pdbonly</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>   csc.define :whatever, :something, :etc</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>   csc.doc = <span style="color: #006080">"path/to/docfile.xml"</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span>   csc.optimize = <span style="color: #0000ff">true</span> <span style="color: #008000"># true or false</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span> end</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    For more information on these options, see the <a href="http://msdn.microsoft.com/en-us/library/6ds95cz0%28v=VS.80%29.aspx">csc command line documentation</a>.
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    SQLCmd Task
                  </h3>
                  
                  <p>
                    A few new attributes have been added to this task that will make it easier to use and add more options for authentication. These options include:
                  </p>
                  
                  <ul>
                    <li>
                      <strong>trusted_connection</strong>: use a trusted connection instead of supplying a username and password
                    </li>
                    <li>
                      <strong>batch_abort</strong>: “on error batch abort” – causes sqlcmd to return a failure code if any of the scripts run encounters an error
                    </li>
                  </ul>
                  
                  <p>
                    There are some behavioral changes related to these options, as well. If you do not specify a username and password, then the sqlcmd task will default to a trusted connection. This means you don’t need to specify any authentication information or options when setting up your sqlcmd tasks and sqlcmd will assume you want to use a trusted connection. If you specify a username OR password, though, the sqlcmd task will assume you do not want a trusted connection. You can manually override the trusted connection behavior by specify .trusted_connection in your tasks.
                  </p>
                  
                  <p>
                    Batch abort will be assumed, by default, if you provide more than one script for sqlcmd to run. You can override this behavior by explicitly setting .batch_abort to false in your tasks.
                  </p>
                  
                  <p>
                    And finally, the task will search your “program files” folder for SQL Server 2005 or 2008 if you don’t specify a .command attribute, directly. Note that it currently does not look in the “x86” program files folder on x64 machines. That will be done hopefully in the next release (preview or final release of v0.2.0).
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> sqlcmd :runscripts <span style="color: #0000ff">do</span> |sql|</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span>   sql.trusted_connection = <span style="color: #0000ff">true</span> <span style="color: #008000"># or false</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span>   sql.batch_abort = <span style="color: #0000ff">true</span> <span style="color: #008000"># or false</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span> end</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          For more information on the new options, see the <a href="http://msdn.microsoft.com/en-us/library/ms162773.aspx">sqlcmd documentation</a>.
                        </p>
                        
                        <p>
                          &#160;
                        </p>
                        
                        <h3>
                          AssemblyInfo Task
                        </h3>
                        
                        <p>
                          To support attributes that need more complex parameters or have other complex needs, a .custom_attributes attribute has been added to the assemblyinfo task.
                        </p>
                        
                        <div>
                          <div>
                            <pre><span style="color: #606060">   1:</span> assemblyinfo <span style="color: #0000ff">do</span> |asm|</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   2:</span>   asm.custom_data(</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   3:</span>     <span style="color: #006080">'[assembly: XmlnsDefinition("http://www.acme.com", "Acme.Common.I18N")]'</span>,</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   4:</span>     <span style="color: #006080">'[assembly: XmlnsDefinition("http://www.acme.com", "Acme.Views.Helpers")]'</span></pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   5:</span>   )</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   6:</span> end</pre>
                            
                            <p>
                              <!--CRLF--></div> </div> 
                              
                              <p>
                                &#160;
                              </p>
                              
                              <h2>
                                Internal Cleanup And A Plug-In System
                              </h2>
                              
                              <p>
                                This release has a lot of internal cleanup of the codebase, the way tasks are created, the handling of the Albacore.configure block along with the code that plugs into it, and much more. In addition to removing many of the files that used to make up albacore (as they were no longer needed), we also reduced the size of the gem from ~400K downto ~40K by filtering out additional files that are not necessary at runtime. This means albacore will download and install faster than ever! This should also reduce the amount of time it takes to load the albacore codebase in your rake tasks.
                              </p>
                              
                              <p>
                                The net result of the cleanup effort has produced a lot of good results: a reduction in the number of files that represent that albacore framework; an easier to work with framework that allows tasks to be created with only a simple include statement; and a plug-in system that allows contributors and end-users with specific needs not currently baked into albacore to develop their own tasks and plug directly into the albacore configuration with ease.
                              </p>
                              
                              <p>
                                &#160;
                              </p>
                              
                              <h3>
                                Custom Tasks
                              </h3>
                              
                              <p>
                                It’s now easier than ever to task advantage of the albacore features and create your own rake tasks. I’ve talked about how simple it is to create your own rake tasks, already, but the albacore framework gives you more than just a way to create tasks. It also gives you access to a unified logger, the configuration api, easy-to-create and use hash and array attributes for your object model, and more.
                              </p>
                              
                              <p>
                                To create your own task with the albacore framework, you only need to do a few things:
                              </p>
                              
                              <ol>
                                <li>
                                  “include AlbacoreTask”. this module will bring most of the albacore functionality into your class and it will create a custom rake task for you, using the name of your class.
                                </li>
                                <li>
                                  a no-args initializer. all albacore task classes need to have an initializer that can be run with no parameters. you can allow optional parameters if you want.
                                </li>
                                <li>
                                  an execute method. all albacore task classes need to have an execute method – again, with no parameters – so that the task can call .execute on your class
                                </li>
                              </ol>
                              
                              <p>
                                I’ve built a small example task to replace the old ‘expandtemplates’ task (which is deprecated in v0.2.0). This new version of the task uses the build in ERB functionality of ruby and accepts a hash as the key / value data to populate the ERB template.
                              </p>
                              
                              <div>
                                <div>
                                  <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">require</span> <span style="color: #006080">'erb'</span></pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   2:</span>&#160; </pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   3:</span> <span style="color: #0000ff">class</span> ExpandTemplate</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   4:</span>   <span style="color: #0000ff">include</span> AlbacoreTask</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   5:</span>&#160; </pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   6:</span>   attr_accessor :template, :output</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   7:</span>   attr_hash :settings</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   8:</span>&#160; </pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   9:</span>   def execute</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  10:</span>     expand_template(@template, @output, @settings)</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  11:</span>   end</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  12:</span>&#160; </pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  13:</span>   def expand_template(template_file, output_file, settings)</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  14:</span>     template = File.read template_file</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  15:</span>&#160; </pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  16:</span>     vars = OpenStruct.<span style="color: #0000ff">new</span>(settings)</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  17:</span>     vars_binding = vars.send(:binding)</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  18:</span>&#160; </pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  19:</span>     erb = ERB.<span style="color: #0000ff">new</span> template</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  20:</span>     output = erb.result(vars_binding)</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  21:</span>&#160; </pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  22:</span>     File.open(output_file, <span style="color: #006080">"w"</span>) <span style="color: #0000ff">do</span> |file|</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  23:</span>       puts <span style="color: #006080">"Generating #{file.path}"</span></pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  24:</span>       file.write(output)</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  25:</span>     end</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  26:</span>   end</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">  27:</span> end</pre>
                                  
                                  <p>
                                    <!--CRLF--></div> </div> 
                                    
                                    <p>
                                      Once you have this class defined in a file, you only need to “require” it in your rakefile (or you can put this class directly in your rakefile if you want). The inclusion of “AlbacoreTask” on line 4 will automatically create an “expandtemplate” task for you. You can then call the task like any other albacore or other rake task:
                                    </p>
                                    
                                    <div>
                                      <div>
                                        <pre><span style="color: #606060">   1:</span> expandtemplate :appconfig <span style="color: #0000ff">do</span> |tmp|</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   2:</span>   tmp.template = <span style="color: #006080">"templates/app.config.template"</span></pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   3:</span>   tmp.output = Files[:output] + <span style="color: #006080">".config"</span></pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   4:</span>   tmp.settings( </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   5:</span>     :mysetting =&gt; <span style="color: #006080">"this is some settings"</span>,</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   6:</span>     :connectionstring =&gt; <span style="color: #006080">"some connection string"</span></pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   7:</span>   )</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   8:</span> end</pre>
                                        
                                        <p>
                                          <!--CRLF--></div> </div> 
                                          
                                          <p>
                                            To see this example do it’s thing, take a look at my <a href="http://github.com/derickbailey/vimbacore">vimbacore project on github</a>. It’s my playground where I test out a lot of the new features and functionality of albacore, and I’ve included this (and a config example) in that project.
                                          </p>
                                          
                                          <p>
                                            &#160;
                                          </p>
                                          
                                          <h3>
                                            Custom Task Names
                                          </h3>
                                          
                                          <p>
                                            There are times when you want to name a task’s class one thing, but you want to have the task method (the method that you call in your rakefile) named something else. An example of this in albacore is the “nunit” task. The class that runs and defines this task is actually called NunitTestRunner. To avoid having tasks with long, ugly names like that, you can specify one (or more) task method names in your class by specifying a “TaskName” constant prior to the “include AlbacoreTask” line in your class. Here’s how the NunitTestRunner class is defined:
                                          </p>
                                          
                                          <div>
                                            <div>
                                              <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">class</span> NUnitTestRunner</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   2:</span>   TaskName = :nunit</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   3:</span>   <span style="color: #0000ff">include</span> AlbacoreTask</pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   4:</span>   <span style="color: #008000"># ...</span></pre>
                                              
                                              <p>
                                                <!--CRLF-->
                                              </p>
                                              
                                              <pre><span style="color: #606060">   5:</span> end</pre>
                                              
                                              <p>
                                                <!--CRLF--></div> </div> 
                                                
                                                <p>
                                                  The use of “TaskName = :nunit” instructs albacore to create the task method “nunit” instead of “nunittestrunner”. You can also specify multiple names if you want aliases for your task:
                                                </p>
                                                
                                                <div>
                                                  <div>
                                                    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">class</span> MyCustomTask</pre>
                                                    
                                                    <p>
                                                      <!--CRLF-->
                                                    </p>
                                                    
                                                    <pre><span style="color: #606060">   2:</span>   TaskName = [:task1, :task2, :taskN]</pre>
                                                    
                                                    <p>
                                                      <!--CRLF-->
                                                    </p>
                                                    
                                                    <pre><span style="color: #606060">   3:</span>   <span style="color: #0000ff">include</span> AlbacoreTask</pre>
                                                    
                                                    <p>
                                                      <!--CRLF-->
                                                    </p>
                                                    
                                                    <pre><span style="color: #606060">   4:</span> end</pre>
                                                    
                                                    <p>
                                                      <!--CRLF--></div> </div> 
                                                      
                                                      <p>
                                                        This will create 3 task methods that you can use from your rakefile: task1, task2 and taskN.
                                                      </p>
                                                      
                                                      <div>
                                                        <div>
                                                          <pre><span style="color: #606060">   1:</span> task1 :foo <span style="color: #0000ff">do</span> |t|</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">   2:</span>  <span style="color: #008000"># ...</span></pre>
                                                          
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
                                                          
                                                          <pre><span style="color: #606060">   5:</span> task2 :bar <span style="color: #0000ff">do</span> |t|</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">   6:</span>  <span style="color: #008000"># ...</span></pre>
                                                          
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
                                                          
                                                          <pre><span style="color: #606060">   9:</span> taskN :baz <span style="color: #0000ff">do</span> |t|</pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  10:</span>  <span style="color: #008000"># ...</span></pre>
                                                          
                                                          <p>
                                                            <!--CRLF-->
                                                          </p>
                                                          
                                                          <pre><span style="color: #606060">  11:</span> end</pre>
                                                          
                                                          <p>
                                                            <!--CRLF--></div> </div> 
                                                            
                                                            <p>
                                                              &#160;
                                                            </p>
                                                            
                                                            <h3>
                                                              Custom Configuration
                                                            </h3>
                                                            
                                                            <p>
                                                              The Albacore.configure block also support plug-in capabilities. All you need to do is create a ruby module that includes “Albacore::Configuration” and your module will automatically become part of the Albacore.configure block. Here’s an example that doesn’t really do much (again, this example is in my <a href="http://github.com/derickbailey/vimbacore">vimbacore project</a>) but illustrates how simple it is:
                                                            </p>
                                                            
                                                            <div>
                                                              <div>
                                                                <pre><span style="color: #606060">   1:</span> module ExpandTemplateConfig</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   2:</span>   <span style="color: #0000ff">include</span> Albacore::Configuration</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   3:</span>&#160; </pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   4:</span>   def expandtemplate</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   5:</span>     puts <span style="color: #006080">"..........Albacore.configure.expandtemplate was called. This is a demonstration of the configuration plugin system.rnrn"</span></pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   6:</span>   end</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF-->
                                                                </p>
                                                                
                                                                <pre><span style="color: #606060">   7:</span> end</pre>
                                                                
                                                                <p>
                                                                  <!--CRLF--></div> </div> 
                                                                  
                                                                  <p>
                                                                    You can then call .expandtemplate in the Albacore.configure block:
                                                                  </p>
                                                                  
                                                                  <div>
                                                                    <div>
                                                                      <pre><span style="color: #606060">   1:</span> Albacore.configure <span style="color: #0000ff">do</span> |config|</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">   2:</span>   config.expandtemplate</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF-->
                                                                      </p>
                                                                      
                                                                      <pre><span style="color: #606060">   3:</span> end</pre>
                                                                      
                                                                      <p>
                                                                        <!--CRLF--></div> </div> 
                                                                        
                                                                        <p>
                                                                          Like I said – this example doesn’t do much. But it does illustrate how simple it is to create a plugin for the configuration system.
                                                                        </p>
                                                                        
                                                                        <p>
                                                                          &#160;
                                                                        </p>
                                                                        
                                                                        <h3>
                                                                          Automatic Configuration Mixins
                                                                        </h3>
                                                                        
                                                                        <p>
                                                                          If you are creating your own tasks using albacore, you can have your configuration options automatically mixed in by placing your config module in a “config” folder next to the file that your task is defined in. Look at the way I’ve set up the vimbacore project:
                                                                        </p>
                                                                        
                                                                        <p>
                                                                          <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_397B074E.png" width="908" height="149" />
                                                                        </p>
                                                                        
                                                                        <p>
                                                                          and the config folder:
                                                                        </p>
                                                                        
                                                                        <p>
                                                                          <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_58BDAE21.png" width="905" height="146" />
                                                                        </p>
                                                                        
                                                                        <p>
                                                                          The file names are important for the config module to be automatically included. Name the config file after the task’s class with “config” at the end of it. In this case the class is named “ExpandTemplate” so the config file is located in ./config/expandtemplateconfig.rb
                                                                        </p>
                                                                        
                                                                        <p>
                                                                          By adhering to that simple layout, your config module will be loaded up and runtime. Combine this with the “include Albacore::Configuration” that I mentioned agove, and you have automatic Albacore.configure mixins!
                                                                        </p>
                                                                        
                                                                        <p>
                                                                          &#160;
                                                                        </p>
                                                                        
                                                                        <h2>
                                                                          Moving Forward…
                                                                        </h2>
                                                                        
                                                                        <p>
                                                                          As the final release of v0.2.0 approaches, we’ll be working to do additional clean up on the albacore functionality, add more options to existing tasks, and create a few new tasks. We’ll also be documenting the albacore functionality so that others can take advantage of it without having to read through the source of existing tasks. We want to make albacore easy to use and highly customizable, and that requires a comprehensive set of documents describing how to access the functionality in albacore.
                                                                        </p>