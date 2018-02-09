---
wordpress_id: 154
title: Build Tools Roundup For .NET Systems
date: 2010-05-10T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/05/10/build-tools-for-net-systems-it-s-no-longer-a-question-of-features.aspx
dsq_thread_id:
  - "262295534"
categories:
  - .NET
  - Build Tools
  - Continuous Integration
  - Pragmatism
  - Product Reviews
  - Tools and Vendors
redirect_from: "/blogs/derickbailey/archive/2010/05/10/build-tools-for-net-systems-it-s-no-longer-a-question-of-features.aspx/"
---
It seems there is not shortage of build tools that are available for the .NET developer these days. Of course I’m quite partial to the Ruby + Rake + Albacore solution, being the big tuna behind albacore and all… but quite honestly that amount of choice makes me very happy. It seems there is a good tool for just about every different comfort zone in the .NET developer world. At this point in time, there’s not one right answer of which build tool to use. You don’t need to choose which tool to use based on what features and functionality it supports anymore. Rather, you can make the choices based on what your comfortable with – be it the runtime environment, the language to create build steps, the data specification, etc. Choice is good. Understanding what each choice offers is even better. Here’s my take on the current set of tools that I’m aware of and what the comfort zone of these tools are.

&#160;

### Nant: The Godfather Of .NET Build Systems

**Runtime:** .NET

**Build Configuration Language:** XML with extensions written in .NET

**URL:** [http://nant.sourceforge.net/](http://nant.sourceforge.net/ "http://nant.sourceforge.net/")

Nant is the old-school guy on the .NET block, having grown up over on Java road. This is the original .NET build tool that so many others wanted to be or wanted to be better than. If you’ve used any build tools for more than a few years in .NET, you’ve probably used Nant at least once. There are a lot of extensions and add-ons to Nant, including a user contributions project, several visual tools designed to abstract away the xml, some conventions based add-ons that make nant easier, etc. If you need to do it in your build process, chances are there is a plugin or a blog post that tells you how to do it with Nant.

Nant was originally a copy of the Java Ant build tool but quickly took its own directions in implementation becoming the defacto build tool in .NET for several years. With it’s heavy reliance on xml and its roots tracing back to java, most “enterprise” developers chose Nant because of it’s familiarity from the Java world. 

**Example:** Build a solution

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">&lt;</span><span style="color: #800000">target</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="compile"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span>        <span style="color: #0000ff">&lt;</span><span style="color: #800000">echo</span> <span style="color: #ff0000">message</span><span style="color: #0000ff">="Build my solution!"</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>        <span style="color: #0000ff">&lt;</span><span style="color: #800000">msbuild</span> <span style="color: #ff0000">project</span><span style="color: #0000ff">="src/mysolution.sln"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>               <span style="color: #0000ff">&lt;</span><span style="color: #800000">arg</span> <span style="color: #ff0000">value</span><span style="color: #0000ff">="/property:Configuration=release"</span> <span style="color: #0000ff">/&gt;</span>                                  </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>               <span style="color: #0000ff">&lt;</span><span style="color: #800000">arg</span> <span style="color: #ff0000">value</span><span style="color: #0000ff">="/t:Rebuild"</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>        <span style="color: #0000ff">&lt;/</span><span style="color: #800000">msbuild</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span> <span style="color: #0000ff">&lt;/</span><span style="color: #800000">target</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        &#160;
      </p>
      
      <h3>
        UppercuT: You Won’t Know What Hit You
      </h3>
      
      <p>
        <strong>Runtime:</strong> .NET (Nant) with extensions to call out to other platforms such as Ruby/Rake.
      </p>
      
      <p>
        <strong>Build Configuration Language:</strong> None for simple builds. XML/Nant, Ruby, and Powershell for extended scenarios
      </p>
      
      <p>
        <strong>URL:</strong> <a title="http://code.google.com/p/uppercut/" href="http://code.google.com/p/uppercut/">http://code.google.com/p/uppercut/</a>
      </p>
      
      <p>
        If you’re going to use Nant and you don’t need to do anything “unusual”, then you should be using UppercuT. This is an add-on that makes Nant so easy to use, you don’t even need to know how to use Nant. UppercuT makes good on it’s promises, too. It really is <em>that</em> easy to get a build up and running because you don’t need to know anything other than the basic conventions that it uses to find your solutions, tests, etc.
      </p>
      
      <p>
        From the project’s homepage:
      </p>
      
      <blockquote>
        <p>
          <a name="&quot;Professional_builds_in_moments,_not_days!&quot;"></a>
        </p>
        
        <p>
          <a name="&quot;Professional_builds_in_moments,_not_days!&quot;"><font color="#000000"><em>It seeks to solve both maintenance concerns and ease of build to help you concentrate on what you really want to do: write code. Upgrading the build should take seconds, not hours. And that is where UppercuT will beat any other automated build system hands down. </em></font></a>
        </p>
      </blockquote>
      
      <p>
        UppercuT is targeted at those who want all of the power and stability that Nant provides, but don’t want to deal with a ton of XML and build script definitions.
      </p>
      
      <p>
        <strong>Example:</strong> No, really… this project makes building with Nant so easy, you don’t need to configure any tasks for most things. Check out the website for more information.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        MSBuild: Bringing ‘One Microsoft Way’ To Your Build System
      </h3>
      
      <p>
        <strong>Runtime:</strong> .NET
      </p>
      
      <p>
        <strong>Build Configuration Language:</strong> XML with extensions written in .NET
      </p>
      
      <p>
        <strong>URL:</strong> <a title="http://msdn.microsoft.com/en-us/library/0k6kkbsd.aspx" href="http://msdn.microsoft.com/en-us/library/0k6kkbsd.aspx">http://msdn.microsoft.com/en-us/library/0k6kkbsd.aspx</a>
      </p>
      
      <p>
        Microsoft’s own build tool – if you’re using visual studio, you’re already using MSBuild. Unless you’re calling directly into the compiler for your language &#8211; such as csc.exe for c# – you are probably using MSBuild in your build process. With VS2005 and later, all .sln and .proj files are msbuild files… or, at least they can be interpreted by msbuild. MSBuild is more than just a solution builder for visual studio, though. It is a complete build system in the same vein as Nant. As much as I love to hate msbuild and it’s associated tools (such as Team Foundation Server and MSTest) I have to give Microsoft credit for getting a build tool into the hands of every .NET developer on the planet.
      </p>
      
      <p>
        In recent years, MSBuild has become the standard build tool for shops that are not allowed to use open source, or want to stick with paid-for-support tools from Microsoft.
      </p>
      
      <p>
        <strong>Example:</strong> Clean and build your solution (“borrowed” <a href="http://rhysc.blogspot.com/2010/05/msbuild-101.html">from RhysC</a>)
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">&lt;</span><span style="color: #800000">Project</span> <span style="color: #ff0000">DefaultTargets</span><span style="color: #0000ff">="Clean"</span> <span style="color: #ff0000">xmlns</span><span style="color: #0000ff">="http://schemas.microsoft.com/developer/msbuild/2003"</span> <span style="color: #ff0000">ToolsVersion</span><span style="color: #0000ff">="3.5"</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span>   <span style="color: #0000ff">&lt;</span><span style="color: #800000">Import</span> <span style="color: #ff0000">Project</span><span style="color: #0000ff">="$(MSBuildExtensionsPath)MSBuildCommunityTasksMSBuild.Community.Tasks.Targets"</span><span style="color: #0000ff">/&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>  </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>   <span style="color: #0000ff">&lt;</span><span style="color: #800000">PropertyGroup</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">&lt;</span><span style="color: #800000">ApplicationName</span><span style="color: #0000ff">&gt;</span>MySolutionApplicationName<span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">&lt;</span><span style="color: #800000">SolutionFile</span><span style="color: #0000ff">&gt;</span>..$(ApplicationName).slnSolutionFile<span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>   PropertyGroup<span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>   <span style="color: #0000ff">&lt;</span><span style="color: #800000">Target</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">="Clean"</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>     <span style="color: #0000ff">&lt;</span><span style="color: #800000">MSBuild</span> <span style="color: #ff0000">Targets</span><span style="color: #0000ff">="Clean"</span> <span style="color: #ff0000">Projects</span><span style="color: #0000ff">="$(SolutionFile)"</span><span style="color: #0000ff">/&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>   Target<span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>   <span style="color: #0000ff">&lt;</span><span style="color: #800000">Target</span> <span style="color: #ff0000">Name</span><span style="color: #0000ff">="Build"</span> <span style="color: #ff0000">DependsOnTargets</span><span style="color: #0000ff">="Clean;"</span> <span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>     <span style="color: #0000ff">&lt;</span><span style="color: #800000">MSBuild</span> <span style="color: #ff0000">Targets</span><span style="color: #0000ff">="Rebuild"</span> <span style="color: #ff0000">Projects</span><span style="color: #0000ff">="$(SolutionFile)"</span> <span style="color: #ff0000">Properties</span><span style="color: #0000ff">="Configuration=Release;"</span> <span style="color: #0000ff">/&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>   Target<span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span> <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Project</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              &#160;
            </p>
            
            <h3>
              Psake: The PowerShell Drink Of Choice
            </h3>
            
            <p>
              <strong>Runtime:</strong> Powershell / .NET
            </p>
            
            <p>
              <strong>Build Configuration Language:</strong> Powershell Script (C#)
            </p>
            
            <p>
              <strong>URL:</strong> <a title="http://github.com/JamesKovacs/psake" href="http://github.com/JamesKovacs/psake">http://github.com/JamesKovacs/psake</a>
            </p>
            
            <p>
              Psake (pronouced like the Japanese rice wine alcohol) is a suite of PowerShell scripts that lets you write .NET code as powershell scripts (.ps1 files) and modules. Since powershell is built into current versions of windows server and desktop operating systems, it is quick and mostly painless to get up and running. It leverages the existing command line knowledge and code writing capabilities of developers by integrating both of those skillsets into one solution. If you want a native windows command line that provides power and capbilties along the lines of a bash shell in *nix, with a build system geared toward the power user, powershell and Psake are your solution.
            </p>
            
            <p>
              <strong>Example:</strong> Clean your solution then build it (“borrowed” from <a href="http://www.gangleri.net/2009/02/24/Psake.aspx">Alan Bradley</a>)
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> task <span style="color: #0000ff">default</span> -depends Build</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span> task Build -depends Clean{</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>   msbuild <span style="color: #006080">"C:UsersAlanCodePowerShellpsakeHelloWorldHelloWorld.sln"</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span> }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span> task Clean {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   8:</span>   msbuild <span style="color: #006080">"C:UsersAlanCodePowerShellpsakeHelloWorldHelloWorld.sln"</span> /t:clean</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   9:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    &#160;
                  </p>
                  
                  <h3>
                    Rake: The ‘Cool’ Kid
                  </h3>
                  
                  <p>
                    <strong>Runtime:</strong> Ruby, IronRuby for .NET, JRuby for Java, etc
                  </p>
                  
                  <p>
                    <strong>Build Configuration Language:</strong> Ruby / Rake DSL
                  </p>
                  
                  <p>
                    <strong>URL:</strong> <a title="http://rake.rubyforge.org/" href="http://rake.rubyforge.org/">http://rake.rubyforge.org/</a>
                  </p>
                  
                  <p>
                    … I’ll be the first to tell you that I can’t give an objective opinion about ruby… so keep that in mind. 🙂
                  </p>
                  
                  <p>
                    Ruby and Rake have been shaking up the .NET world for a few years now, with many of .NET’s best and brightest jumping ship away from the classic .NET build systems for this one. It seems that all the ‘alt’ kids and cool cats are heading for these green pastures and with Microsoft having released IronRuby v1.0 recently, there is even more potential for the popularity of this system in .NET. With the flexibility of the Ruby language, the built in gem system and the thousands of available libraries, the potential functionality within a rake build script is staggering.
                  </p>
                  
                  <p>
                    Rake, like Psake, is targeted at the command-line-junky that wants to get things done quickly but doesn’t feel constrained to the Microsoft-only tools.
                  </p>
                  
                  <p>
                    <strong>Example:</strong> Calling out to MSBuild to build a solution
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> task :<span style="color: #0000ff">default</span> <span style="color: #0000ff">do</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span>   msbuild = <span style="color: #006080">"C:/Windows/Microsoft.NET/Framework/v3.5/msbuild.exe"</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span>   return_code = system <span style="color: #006080">"#{msbuild} src/example.sln /p:configuration=release /target:clean;build /asdfasdf"</span></pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span>   fail <span style="color: #006080">"msbuild failed!"</span> unless return_code == 0</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   5:</span> end</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          &#160;
                        </p>
                        
                        <h3>
                          Albacore: Dolphin-Safe Rake Tasks For .NET Systems
                        </h3>
                        
                        <p>
                          <strong>Runtime:</strong> Ruby / Rake + various command line tools
                        </p>
                        
                        <p>
                          <strong>Build Configuration Language:</strong> Ruby / Rake Tasks
                        </p>
                        
                        <p>
                          <strong>URL:</strong> <a href="http://albacorebuild.net">http://albacorebuild.net</a>
                        </p>
                        
                        <p>
                          … Do I really need to say anything, here? I suppose I should, being the big tuna behind this project. 🙂
                        </p>
                        
                        <p>
                          Albacore is a suite of Rake tasks that targets the most common needs for .NET systems at build-time, including some configuration management and package & deployment tools. What started as a “hey wouldn’t it be cool if…” conversation has quickly turned into a growing community of contributors and users around the world. There’s a lot of cooperation between the albacore tasks and the other popular build systems, too, with tasks that call out to nant and msbuild for example. The UppercuT project even has rake / albacore integration built into it. This cooperation with other systems makes the choice of which tool to use less important, as you can use the right tool for the job at hand, all from one central location.
                        </p>
                        
                        <p>
                          Albacore is targeted at the Rake users that want to get their .NET system builds up and running quickly, while still allowing the full flexibility and capabilities of the Rake system.
                        </p>
                        
                        <p>
                          <strong>Example:</strong> Build and test a solution
                        </p>
                        
                        <div>
                          <div>
                            <pre><span style="color: #606060">   1:</span> require <span style="color: #006080">'albacore'</span></pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   2:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   3:</span> task :<span style="color: #0000ff">default</span> =&gt; [:build, :unittests]</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   4:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   5:</span> msbuild :build <span style="color: #0000ff">do</span> |msb|</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   6:</span>   msb.solution = <span style="color: #006080">"src/example.sln"</span></pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   7:</span>   msb.targets :clean, :build</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   8:</span>   msb.properties :configuration =&gt; :release</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   9:</span> end</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  10:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  11:</span> nunit :unittests <span style="color: #0000ff">do</span> |nunit|</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  12:</span>   nunit.path_to_command = <span style="color: #006080">"nunit/nunit-console.exe"</span></pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  13:</span>   nunit.assemblies <span style="color: #006080">"src/tests/bin/release/tests.dll"</span></pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  14:</span> end</pre>
                            
                            <p>
                              <!--CRLF--></div> </div> 
                              
                              <p>
                                &#160;
                              </p>
                              
                              <h3>
                                Bake: The Sexy Little DSL; and Phantom: So Simple, It’s Scary
                              </h3>
                              
                              <p>
                                <strong>Runtime:</strong> .NET
                              </p>
                              
                              <p>
                                <strong>Build Configuration Language:</strong> Boo DSL for builds
                              </p>
                              
                              <p>
                                <strong>URL:</strong> <a title="http://code.google.com/p/boo-build-system/" href="http://code.google.com/p/boo-build-system/">http://code.google.com/p/boo-build-system/</a> and <a title="http://github.com/JeremySkinner/Phantom" href="http://github.com/JeremySkinner/Phantom">http://github.com/JeremySkinner/Phantom</a>&#160;
                              </p>
                              
                              <p>
                                … At this point, I’m not sure about the state of this project or it’s adoption in the real world. Does anyone know if it’s still alive and/or being used anywhere? You may be better off looking at the <a href="http://github.com/JeremySkinner/Phantom/">Phantom build system</a>, which is similar to Bake, but appears to be an active project.
                              </p>
                              
                              <p>
                                Bake is “A build system written in Boo, inspired by Rake.”. It’s based on the Boo language – an object oriented DSL creation language for the .NET runtime. Also known as the “<u>Boo</u> <u>B</u>uild <u>S</u>ystem”, this particular project was subject to quite a bit of potty humor for a while, before <a href="http://ayende.com/Blog/archive/2008/01/26/From-BooBS-to-Bake.aspx">being renamed to Bake</a>. 🙂 The Boo language allows you to write your own Domain Specific Language (DSL) to run on the .NET platform, and Bake provides a DSL specifically for builds.
                              </p>
                              
                              <p>
                                Bake and Phantom are targeted at the .NET developer that wants a simple DSL for creating builds, want a Rake like syntax, but want to keep the runtime dependency limited to the .NET platform.
                              </p>
                              
                              <p>
                                <strong>Example:</strong> Using Phantom to build and test a solution
                              </p>
                              
                              <div>
                                <div>
                                  <pre><span style="color: #606060">   1:</span> target compile:</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   2:</span>   msbuild(file: <span style="color: #006080">"path/to/somefile.sln"</span>, configuration: <span style="color: #006080">"release"</span>)</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   3:</span>&#160; </pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   4:</span> target test:</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   5:</span>   test_assemblies = (<span style="color: #006080">"path/to/testassembly.dll"</span>, <span style="color: #006080">"path/to/AnotherTestAssembly.dll"</span>)</pre>
                                  
                                  <p>
                                    <!--CRLF-->
                                  </p>
                                  
                                  <pre><span style="color: #606060">   6:</span>   nunit(assemblies: test_assemblies, toolpath: <span style="color: #006080">"path/to/nunit.console.exe"</span> })</pre>
                                  
                                  <p>
                                    <!--CRLF--></div> </div> 
                                    
                                    <p>
                                      &#160;
                                    </p>
                                    
                                    <h3>
                                      Fake: The Functional Build System
                                    </h3>
                                    
                                    <p>
                                      <strong>Runtime:</strong> .NET
                                    </p>
                                    
                                    <p>
                                      <strong>Build Configuration Language:</strong> F#
                                    </p>
                                    
                                    <p>
                                      <strong>URL:</strong> <a title="http://bitbucket.org/forki/fake/wiki/Home" href="http://bitbucket.org/forki/fake/wiki/Home">http://bitbucket.org/forki/fake/wiki/Home</a>
                                    </p>
                                    
                                    <p>
                                      Fake is the F# build system – a functional language that run on the .NET platform with a DSL for builds on top of it. Fake provides <em>“all benefits of the .NET Framework and functional programming can be used, including the extensive class library, powerful debuggers and integrated development environments like Visual Studio 2008 or SharpDevelop, which provide syntax highlighting and code completion.</em>”
                                    </p>
                                    
                                    <p>
                                      Fake is targeted as developers who like the simplicity and elegance of a functional language and still want the powerful and capabilities of the .NET runtime and tooling.
                                    </p>
                                    
                                    <p>
                                      <strong>Example:</strong> Running NUnit tests
                                    </p>
                                    
                                    <div>
                                      <div>
                                        <pre><span style="color: #606060">   1:</span> (* define test dlls *)</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   2:</span> let testDlls = !+ (testDir + <span style="color: #006080">@"/Test.*.dll"</span>) |&gt; Scan</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   3:</span>  </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   4:</span> Target? NUnitTest &lt;-</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   5:</span>     fun _ -&gt; </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   6:</span>         testDlls</pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   7:</span>           |&gt; NUnit (fun p -&gt; </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   8:</span>                       {p with </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">   9:</span>                          ToolPath = nunitPath; </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  10:</span>                          DisableShadowCopy = <span style="color: #0000ff">true</span>; </pre>
                                        
                                        <p>
                                          <!--CRLF-->
                                        </p>
                                        
                                        <pre><span style="color: #606060">  11:</span>                          OutputFile = testDir + <span style="color: #006080">"TestResults.xml"</span>})</pre>
                                        
                                        <p>
                                          <!--CRLF--></div> </div> 
                                          
                                          <p>
                                            &#160;
                                          </p>
                                          
                                          <h3>
                                            Make: The One. The Original.
                                          </h3>
                                          
                                          <p>
                                            <strong>Runtime:</strong> everywhere (usually associated with C/C++ though)
                                          </p>
                                          
                                          <p>
                                            <strong>Build Configuration Language:</strong> Make files
                                          </p>
                                          
                                          <p>
                                            <strong>URL (the best one I know of):</strong> <a title="http://en.wikipedia.org/wiki/Make_%28software%29" href="http://en.wikipedia.org/wiki/Make_%28software%29">http://en.wikipedia.org/wiki/Make_%28software%29</a>
                                          </p>
                                          
                                          <p>
                                            Make isn’t old-school… that’s like saying cave drawings are old school email letters or instant messages. No, Make isn’t old school… it’s the original. Make is the grand daddy of all the build systems and deserves our respect. Although I doubt that the original make system could do much more for a .NET developer than shell out to a command line tool, there are dozens (if not hundreds or thousands) of Make ancestors that are likely to be very capable in building .NET code. The namesake alone is still alive and well, with Rake – the “Ruby Make” system, Bake – the “Boo Make” system, Fake – the “F# Make”, etc. All of us – every developer that works in any modern language – owe a lot to Make for getting us started way back when. Whether or not you realize it, you are using a tool that has it’s roots in Make.
                                          </p>
                                          
                                          <p>
                                            &#160;
                                          </p>
                                          
                                          <h3>
                                            How Do I Know Which To Choose?!
                                          </h3>
                                          
                                          <p>
                                            With all of these options available making choices can be a daunting task. What it ultimately comes down to, though, is what you and your team are comfortable with. I love to push albacore as a build too for .NET as anyone that knows me will attest. However, I have also been known to say that it’s the wrong choice for some teams. Getting a build script and an automated build in place, combined with a Continuous Integration server, is the goal. Picking the build tool to do that is an implementation detail that should not get in the way of the goal. If your team does not have ruby / rake experience, albacore might not be the right tool for you. If your team does not like xml, Psake might be the right tool for you. You need to understand what your team is capable of today and what they want to be capable of tomorrow, to understand which tool is right for you.
                                          </p>