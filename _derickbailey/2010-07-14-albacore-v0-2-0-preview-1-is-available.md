---
id: 173
title: Albacore v0.2.0 Preview 1 Is Available
date: 2010-07-14T21:17:15+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/07/14/albacore-v0-2-0-preview-1-is-available.aspx
dsq_thread_id:
  - "263052929"
categories:
  - .NET
  - Albacore
  - Build Tools
  - Rake
  - Ruby
---
A few days ago I pushed a preview version of Albacore up to RubyGems. The intention of doing a preview release was to show everyone the new direction that Albacore is heading and to get feedback from the community on that direction. Things are far from complete in this preview… there is a lot of work that I still want to pack in before the final release of v0.2.0… but there’s already enough change that has occurred, that I think it is time to start getting feedback and making improvements based on that. 

&#160;

### Installing The Preview

This is all you need to install the preview version:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> gem install albacore --pre</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        The inclusion of ‘&#8211;pre’ on the command line will tell the gem system that you want to install the latest preview version of albacore. You will then need to modify your rake file to use the preview version (v0.2.0.preview1):
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> require <span style="color: #006080">'rubygems'</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> gem <span style="color: #006080">'albacore'</span>, <span style="color: #006080">'=v0.2.0.preview1'</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span> require <span style="color: #006080">'albacore'</span></pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              The second line tells the gem system to use the specific version of Albacore that you want, when the Albacore gem is required.
            </p>
            
            <p>
              &#160;
            </p>
            
            <p>
              With all that being said, here’s what you can expect from the preview…
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              Reduced Syntax For Several Attributes
            </h3>
            
            <p>
              Many of the tasks that Albacore includes are what we call ‘command line tasks’ – these are tasks that call out to a command line tool. In previous releases, all of these tasks had their command line executable (or script or whatever) set through an attribute called ‘.path_to_command’. This lengthy name is hard to type and hard to remember if you don’t use it on a regular basis. With that in mind, we reduced the attribute to ‘.command’. For example:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> nunit :test <span style="color: #0000ff">do</span> |nunit|</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span>   nunit.command = <span style="color: #006080">"tools/nunit/nunit-console.exe"</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>   # other settings here</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span> end</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    A few other tasks have had similar overhauls to specific attributes. the Unzip task, for example, has attributes renamed to ‘.file’ and ‘.destination’ to represent the zip file you want to unzip and where you want the contents sent. These changes should simplify your tasks a little and make them easier to read.
                  </p>
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    A Few New Tasks
                  </h3>
                  
                  <p>
                    In addition to the <a href="http://www.lostechies.com/blogs/derickbailey/archive/2010/06/01/albacore-feature-preview-building-c-code-with-csc-exe.aspx">CSC task that I’ve already mentioned on this blog</a>, there is also a new SpecflowReport task that let’s you run reports from <a href="http://www.specflow.org/">specflow</a>.
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> specflowreport :specflow <span style="color: #0000ff">do</span> |sfr|</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span>   sfr.command = <span style="color: #006080">"path/to/specflow.exe"</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span>   sfr.projects <span style="color: #006080">"path/to/something.csproj"</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span>   sfr.reports <span style="color: #006080">"nunitexecutionreport"</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   5:</span>   sfr.options <span style="color: #006080">"/out:specs.html"</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   6:</span> end</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          &#160;
                        </p>
                        
                        <p>
                          &#160;
                        </p>
                        
                        <h3>
                          Default To .NET 4 For MSBuild And CSC
                        </h3>
                        
                        <p>
                          FINALLY!!!!
                        </p>
                        
                        <p>
                          I do have to apologize to the community of Albacore users for taking so long to get this done. I should have done it in a previous release, but I kept tell myself “no no… I’ll get v0.2.0 out the door soon…” … sorry about that. At long last, though, you no longer have to do any <a href="http://dejanfajfar.wordpress.com/2010/07/12/albacore-and-net-4-0/">hard coded paths</a> to make it work with .NET 4.
                        </p>
                        
                        <p>
                          Not using .NET 4? Don’t worry! v0.2.0 will make your life easier, still! You can easily change framework versions with one simple statement in your task definition:
                        </p>
                        
                        <div>
                          <div>
                            <pre><span style="color: #606060">   1:</span> msbuild :build <span style="color: #0000ff">do</span> |msb|</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   2:</span>   msb.use :net35</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   3:</span>   # other configuration here</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   4:</span> end</pre>
                            
                            <p>
                              <!--CRLF--></div> </div> 
                              
                              <p>
                                The .use(version) method is now available on the MSBuild and CSC tasks and let’s you specify which version of .NET you want to use when calling out to the command line. Here’s the current list of supported versions:
                              </p>
                              
                              <ul>
                                <li>
                                  <strong>:net2</strong> or <strong>:net20</strong> for v2.0.50727
                                </li>
                                <li>
                                  <strong>:net35</strong> for v3.5
                                </li>
                                <li>
                                  <strong>:net4</strong> or <strong>:net40</strong> for v4.0.30319
                                </li>
                              </ul>
                              
                              <p>
                                Need another version? Drop us a line or submit a patch and we’ll get it added. (I know that this isn’t anywhere near the complete list. This is what I have on my machine, right now.)
                              </p>
                              
                              <p>
                                &#160;
                              </p>
                              
                              <h3>
                                A New Configuration System
                              </h3>
                              
                              <p>
                                This is one of the things I’m most excited about and hopefully something that will make your life even easier, with Albacore. There is a new configuration system that let’s you configure defaults for any attribute of any task in one simple place. Always using .Net 3.5 with MSBuild and don’t want to specify it in every msbuild task? no problem… Always want to use the same .command or .options with nunit? No problem… want to set the .log_level for every task? no problem…
                              </p>
                              
                              <div>
                                <div>
                                  <pre><span style="color: #606060">   1:</span> Albacore.configure <span style="color: #0000ff">do</span> |config|</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   2:</span>   config.log_level = :verbose</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   3:</span>   config.msbuild.use :net35</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   4:</span>   config.nunit <span style="color: #0000ff">do</span> |nunit|</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   5:</span>     nunit.command = <span style="color: #006080">"path/to/nunit-console.exe"</span></pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   6:</span>     nunit.options <span style="color: #006080">"/noshadow"</span></pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   7:</span>   end</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   8:</span>   # additional task configuration here</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   9:</span> end</pre>
                                  
                                  <p>
                                    <!--CRLF--></div> </div> 
                                    
                                    <p>
                                      This Albacore.configure method can be called at the top of your rakefile and it will set the specified attributes for the specified tasks, on every instance of that task, to this default. Of course, you can still override any individual setting within any individual task definition.
                                    </p>
                                    
                                    <p>
                                      In addition to the .configure method, this release of Albacore also makes it easy to configure any specific task through code, using a hash.
                                    </p>
                                    
                                    <div>
                                      <div>
                                        <pre><span style="color: #606060">   1:</span> msbuild_settings = {</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   2:</span>   :properties =&gt; {:configuration =&gt; :release},</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   3:</span>   :targets =&gt; [:clean, :build]</pre>
                                        
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
                                        
                                        <pre><span style="color: #606060">   6:</span> msbuild <span style="color: #0000ff">do</span> |msb|</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   7:</span>   msb.update_attributes msbuild_settings</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   8:</span> end</pre>
                                        
                                        <p>
                                          <!--CRLF--></div> </div> 
                                          
                                          <p>
                                            Now you can set virtually any attribute of any task through code, outside of the task definition. You only need to provide a hash to the .update_attributes method on the task object.
                                          </p>
                                          
                                          <p>
                                            &#160;
                                          </p>
                                          
                                          <h3>
                                            A Better Internal Structure
                                          </h3>
                                          
                                          <p>
                                            I don’t want to bore everyone with a lot of detail here, but it is worth mentioning. Many of the individual modules that have previously been used in Albcore task objects have been consolidated into a single ‘AlbacoreModel’ module. In addition, many other changes have gone into the other modules to help clean them up, significantly. This is important not just for the current developers of Albacore, but also for the future developers and contributors. It will make life easier and allow others to extend Albacore with less trouble.
                                          </p>
                                          
                                          <p>
                                            &#160;
                                          </p>
                                          
                                          <h3>
                                            A Few Tasks Have Been Killed
                                          </h3>
                                          
                                          <p>
                                            This is probably going to be the most controversial thing that I’ve done in Albacore…
                                          </p>
                                          
                                          <p>
                                            After a lot of thought and consideration about the focus of Albacore should be, I came to the conclusion that I want to help build the best set of <em>build</em> related tools for the .NET workd, running in Ruby / Rake. What this means is that I don’t think Albacore should be in the business of deployment. There are some tremendous deploy related gems already available and I want to encourage the use of those instead of having half-baked, 2nd class deployment capabilities built into Albacore.
                                          </p>
                                          
                                          <p>
                                            In addition to this, I also realized that there are a few tasks that just don’t add any value. They are either duplicating functionality from somewhere else, or muddying the functionality that was intended.
                                          </p>
                                          
                                          <p>
                                            With all that being said, here are the tasks that have been killed, and why:
                                          </p>
                                          
                                          <ul>
                                            <li>
                                              <b>rename</b>: provides no value. just use ‘FileUtils.mv’ in a regular task. you get more options and better support from the ruby community with the FileUtils module <p>
                                                </li> 
                                                
                                                <li>
                                                  <b>ssh</b>: deploy related, which is not albacore&#8217;s "core". albacore is a build related framework, not deployment. suggest users switch to capistrano and webistrano if the want ssh stuff. <p>
                                                    </li> 
                                                    
                                                    <li>
                                                      <b>sftp</b>: same as ssh <p>
                                                        </li> 
                                                        
                                                        <li>
                                                          <b>expandtemplates</b>: while this is (mostly) functional and does provide some value, it&#8217;s a hack that i put together because i wasn&#8217;t aware of the existing templating solutions out there. ERB is built into to ruby and there are so many more available if people want them. I would suggest a switch to ERB or one of the other template systems if you need a templating solution. <p>
                                                            </li> 
                                                            
                                                            <li>
                                                              <strong>plink:</strong> I was on the fence about deleting this one, since it is a command line tool for a specific tool (PuTTY). However, I decided to kill it because it is ultimate a deploy related tool – an SSH client. <p>
                                                                </li> </ul> 
                                                                
                                                                <p>
                                                                  Now, just because these have been officially removed from Albacore, doesn’t mean you are out of luck if you are using them… at least, not long-term. Check out the “what to expect in the future” to see how you’ll be able to revive these tasks (if you so desire) in the near future.
                                                                </p>
                                                                
                                                                <p>
                                                                  &#160;
                                                                </p>
                                                                
                                                                <h3>
                                                                  And Much Much More
                                                                </h3>
                                                                
                                                                <p>
                                                                  There’s a lot more that has happened than this list can show – many miniscule details to give Albacore a much more solid feel to it. For a complete list of what has changed, check out the <a href="http://github.com/derickbailey/Albacore/issues/closed#sort=updated">“v0.2.0” label on the Github Issues page</a> – specifically look at the “Closed” tags to see what has been done (though the list of closed issues will continue to grow, while the preview 1 release will not change. I may release another preview as progress is made).
                                                                </p>
                                                                
                                                                <p>
                                                                  &#160;
                                                                </p>
                                                                
                                                                <h3>
                                                                  What To Expect In The Future
                                                                </h3>
                                                                
                                                                <p>
                                                                  One of the things I want to do for the final release (probably really soon, cause I need this…) is create a very simple plug-in architecture to allow end-users of Albacore to add functionality. I want to create a system that is easy to extend and easy to change. I want to allow the system to grow and change with your needs, not just the needs of those who are speaking up on the mailing list or StackOverflow or whatever. If you want to re-add the ExpandTemplates task, if you want to re-add the SSH or SFTP task, or if you want to re-create them or create something new in a meaningful manner that suits your environment’s needs better, I want to make it easy for you.
                                                                </p>
                                                                
                                                                <p>
                                                                  The work that has gone into, and is still going on in, the refactoring of the internal structure in Albacore is going to facilitate a lot of this. In addition to that, there will be a simple drag-n-drop folder that you can add to any project anywhere on your system, and Albacore will pick up and automatically call ‘require’ on all ruby files in that folder.&#160; This code isn’t available, yet… you’ll have to wait for another preview (or maybe the final release if that happens sooner than expected) but it will be there. I need this functionality for myself and I’m sure others will take advantage of it, too.
                                                                </p>
                                                                
                                                                <p>
                                                                  In addition to the plug-in system, there will be other changes and details on a smaller scale: some additional work will be done on the CSC task; a few more bugs will be fixed; a few other tasks will have more options; and we’ll continue restructuring and fixing up the internal structure of Albacore, too.
                                                                </p>
                                                                
                                                                <p>
                                                                  As always, if you’re interested in contributing to Albacore in any way, head on over to <a href="http://albacorebuild.net">http://albacorebuild.net</a> and you can find links to the discussion group, source code, wiki, and much more.
                                                                </p>