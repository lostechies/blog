---
id: 89
title: 'Albacore: Breaking Changes In Location Of Executables'
date: 2009-10-04T19:20:20+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2009/10/04/albacore-breaking-changes-in-location-of-executables.aspx
dsq_thread_id:
  - "262068362"
categories:
  - Albacore
  - Rake
  - Refactoring
  - Ruby
---
I was working on cleaning up [Albacore](http://github.com/derickbailey/Albacore) this weekend, and I noted that both the NCoverConsole and MSBuild tasks in Albacore both require the location of the .exe, to execute. The MSBuild task defaults itself to the .NET 3.5 SP1 folder, if none is specified, but the NCoverConsole task requires the path to be specified. With both of these requiring a path to the .exe file, it made sense to consolidate the functionality of storing the location and executing the command in a module. This would help to ensure consistency across all the tasks that need to execute something on the command line. 

&#160;

### Breaking Change: ‘path\_to\_exe’ is now ‘path\_to\_command’

In the process of putting together the basic module for this, I decided that ‘path\_to\_exe’ is not the right setting name. Rather, ‘path\_to\_command’ is more appropriate, in case someone wants to use a .bat, .cmd or other executable file extension. 

MSBuildTask:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> desc <span style="color: #006080">"Run a sample build using the MSBuildTask"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> Rake::MSBuildTask.<span style="color: #0000ff">new</span>(:msbuild) <span style="color: #0000ff">do</span> |msb|</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>   msb.path_to_command = <span style="color: #006080">"C:/Windows/Microsoft.Net/Framework/v3.5/MSBuild.exe"</span>  </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>   msb.properties :configuration =&gt; :Debug</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>   msb.targets [:Clean, :Build]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>   msb.solution = <span style="color: #006080">"lib/spec/support/TestSolution/TestSolution.sln"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span> end</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        NCoverConsoleTask:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> desc <span style="color: #006080">"Run a sample NCover Console code coverage"</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> Rake::NCoverConsoleTask.<span style="color: #0000ff">new</span>(:ncoverconsole) <span style="color: #0000ff">do</span> |ncc|</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>   ncc.path_to_command = <span style="color: #006080">"lib/spec/support/Tools/NCover-v3.2/NCover.Console.exe"</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>   ncc.log_level = :verbose</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>   ncc.output = {:xml =&gt; <span style="color: #006080">"lib/spec/support/CodeCoverage/test-coverage.xml"</span>}</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>   ncc.working_directory = <span style="color: #006080">"lib/spec/support/CodeCoverage"</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>     </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>   nunit = NUnitTestRunner.<span style="color: #0000ff">new</span>(<span style="color: #006080">"lib/spec/support/Tools/NUnit-v2.5/nunit-console.exe"</span>)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>   nunit.log_level = :verbose</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>   nunit.assemblies &lt;&lt; <span style="color: #006080">"assemblies/TestSolution.Tests.dll"</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>   nunit.options &lt;&lt; <span style="color: #006080">'/noshadow'</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>     </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span>   ncc.testrunner = nunit</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  15:</span> end</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              &#160;
            </p>
            
            <h3>
              Breaking Change: no second parameter for MSBuildTask.New
            </h3>
            
            <p>
              Also – to keep things a little more consistent, I decided to remove the second parameter from the MSBuildTask initializer. You can no longer specify the path to the msbuild.exe in the initializer. Rather, you should specify it in the settings of the task, as shown in the above example.
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              Feedback Welcome
            </h3>
            
            <p>
              I always welcome feedback, especially with this project being in such an early stage and with so few tasks available, so far. If you liked the optional MSBuildTask initializer parameter, if you think path_to_exe is a better name, or if you have any other questions, comments, or suggestions, please drop me a line. The easiest way to do that is over on the <a href="http://github.com/derickbailey/Albacore/issues">Albacore Issues list</a>, or through ‘Contact’ link in the sidebar of this page.
            </p>