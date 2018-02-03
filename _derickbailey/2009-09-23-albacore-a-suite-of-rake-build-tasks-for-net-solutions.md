---
wordpress_id: 87
title: 'Albacore: A Suite Of Rake Build Tasks For .NET Solutions'
date: 2009-09-23T15:14:23+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/09/23/albacore-a-suite-of-rake-build-tasks-for-net-solutions.aspx
dsq_thread_id:
  - "262068374"
categories:
  - .NET
  - Albacore
  - 'C#'
  - Continuous Integration
  - git
  - Rake
  - Ruby
---
[<img style="border-right-width: 0px;margin: 0px 25px 0px 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="Albacore Tuna - http://www.flickr.com/photos/djs1021/3906751541/" align="left" src="http://lostechies.com/derickbailey/files/2011/03/image_10AB210C.png" width="316" height="210" />](http://www.flickr.com/photos/djs1021/3906751541/) After my [previous post on building a “real” rake task](http://www.lostechies.com/blogs/derickbailey/archive/2009/09/17/how-a-net-developer-hacked-out-a-rake-task.aspx), I decided to dive in head first and learn how to get this stuff done. I chose to drive the tasks out via rspec, through a TDD process, and I created a couple of rake tasks that are proving to be quite useful to me: an msbuild task and an assembly info generate task. Yeah, I know that this has been done to death, at this point. During the trials and tribulations of me getting down and dirty with ruby, rake, gemspec, rspec, etc, I came across some libraries that already do exactly what I set out to do.

  * Rubicant: [http://github.com/mendicantx/rubicant](http://github.com/mendicantx/rubicant "http://github.com/mendicantx/rubicant") 
  * Rake-dotnet: [http://github.com/petemounce/rake-dotnet](http://github.com/petemounce/rake-dotnet "http://github.com/petemounce/rake-dotnet") 
  * Rake-Me: [http://github.com/agross/rake-me](http://github.com/agross/rake-me "http://github.com/agross/rake-me")&#160;
  * Raken: [http://github.com/stevenharman/raken](http://github.com/stevenharman/raken "http://github.com/stevenharman/raken") 
  * etc. etc. etc. 

The point is, I know I am re-inventing the wheel. So, why did I decide to continue with my efforts, and actually produce Albacore? First and foremost, I did it so that I would have an excuse and good reason to really dive down deep into what it takes to produce a high quality, valuable toolset using ruby, rake, rspec, etc. I wanted to learn, and wanted to find out what I could and could not do easily with these tools. 

With the idea of using Albacore as a way for me to learn all of these tools, I don’t plan on giving up on this toolset and using another one. I have enjoyed the process of learning and creating something useful in a new framework, and I can see a lot of value in what I’ve already created. The end result has multiple benefits and was well worth the effort. 

So, with all that in mind, I present to you: **Albacore – A Suite of Rake Build Tasks for .NET Solutions.**

****

### What Is Albacore?

The sub-title and everything I’ve stated so far, really do give this away. I wanted to have a suite of rake tasks that I can use for my .net solutions. In the process of creating this suite, though, I wanted to avoid the mistake of duplicating a lot of code between the rake tasks and the underlying object model that gets executed by the tasks. I’ve taken the time to learn how the rake tasks work and how to properly create an ultra-simple, light-weight task wrapper around an object model that does the real work.

At the time of this writing, there are two primary tasks Albacore includes: MSBuiltTask and AssemblyInfoTask.

**MSBuildTask**: This task is used to build your .NET solutions. Internally, this task calls out to the MSBuild command line. This will allow you to run the task against a .NET solution directly, or against an MSBuild file or anything else that the MSBuild exe allows you to build.

**AssemblyInfoTask**: This task is used to generate your assembly information – version, copyright, title, description, etc. The assembly info task writes the attributes that you supply out to the file that you specify. At this time, the only language that this task supports is C#. I don’t have any use for a VB or other .NET language version of this task, so I have not provided any mechanisms to write into other languages. If there is sufficient interest in other languages, though, I’ll work with those who are interested to create a language option.

&#160;

### How Do I Get Albacore?

If you would like to use Albacore for your rake tasks, all you need to do is install the gem via github’s gem server. To do this, follow these instructions:

**1. Setup github as a gem source.** Open a command prompt for ruby, and run this command: 

> _gem source –a_ [_http://gems.github.com_](http://gems.github.com) __

This will add github as a source repository for you to install ruby gems from. The good news is, you only have to do this one. After you add this source, you will be able to pull any gem you want from github, whenever you want.

**2. Install the Albacore Gem.** Open a command prompt if you don’t have one open already, and run this command:

> _gem install derickbailey-Albacore_

Be careful to get the spelling of my name correct (one “r”) and the capitalization of Albacore correct. This will install the library on your local box and you will be ready to use it.

&#160;

### How Do I Use Albacore?

To use Albacore on your project, be sure you have it installed first. Then you only need to 

> _require ‘albacore’_ 

in your rakefile, and you can get started. Here is the example that I have included in the default rakefile in the albacore gem:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> require <span style="color: #008000">'albacore'</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span> <span style="color: #0000ff">namespace</span> :albacore <span style="color: #0000ff">do</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>     </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     desc <span style="color: #006080">"Run a complete Albacore build sample"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     task :sample =&gt; [<span style="color: #008000">'albacore:assemblyinfo', 'albacore:msbuild']</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>     </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>     desc <span style="color: #006080">"Run a sample build using the MSBuildTask"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>     Rake::MSBuildTask.<span style="color: #0000ff">new</span>(:msbuild) <span style="color: #0000ff">do</span> |msb|</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>         msb.properties :configuration =&gt; :Debug</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>         msb.targets [:Clean, :Build]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>         msb.solution = <span style="color: #006080">"lib/spec/support/TestSolution/TestSolution.sln"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>     <span style="color: #0000ff">end</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>     </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>     desc <span style="color: #006080">"Run a sample assembly info generator"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>     Rake::AssemblyInfoTask.<span style="color: #0000ff">new</span>(:assemblyinfo) <span style="color: #0000ff">do</span> |asm|</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span>         asm.version = <span style="color: #006080">"0.1.2.3"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>         asm.company_name = <span style="color: #006080">"a test company"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span>         asm.product_name = <span style="color: #006080">"a product name goes here"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  20:</span>         asm.title = <span style="color: #006080">"my assembly title"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  21:</span>         asm.description = <span style="color: #006080">"this is the assembly description"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  22:</span>         asm.copyright = <span style="color: #006080">"copyright some year, by some legal entity"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  23:</span>         asm.custom_attributes :SomeAttribute =&gt; <span style="color: #006080">"some value goes here"</span>, :AnotherAttribute =&gt; <span style="color: #006080">"with some data"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  24:</span>         </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  25:</span>         asm.output_file = <span style="color: #006080">"lib/spec/support/AssemblyInfo/AssemblyInfo.cs"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  26:</span>     <span style="color: #0000ff">end</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  27:</span> <span style="color: #0000ff">end</span></pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        I’ve included this example build of the Albacore tasks in the rakefile at the root of the gem installation, as well as all of the rspec tests for the library. With this, you can run the tests or the sample builds directly from the rakefile, in the installation folder of the gem.
      </p>
      
      <p>
        You can run this sample with the following command(s):
      </p>
      
      <blockquote>
        <p>
          <em>“rake albacore:sample”</em> – runs all of the tasks from Albacore
        </p>
        
        <p>
          <em>“rake albacore:msbuild”</em> – only runs the msbuild task
        </p>
        
        <p>
          <em>“rake albacore:assemblyinfo”</em> &#8211; only runs the assembly info generator task
        </p>
      </blockquote>
      
      <p>
        I’m also planning to maintain the Albacore wiki on the github page, with instructions on how to install it, how to use the individual tasks, etc. You can get the link to the github project in the next section of this post.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        Can I Get The Albacore Source Code?
      </h3>
      
      <p>
        Yes! I’m doing this as an open source (<a href="http://opensource.org/licenses/mit-license.php">MIT license</a>) project on my github account. You can grab the source code, fork it to your github account, or do whatever else the magic of git + github lets you do. If you add something useful, fix a bug, or make something more ‘ruby-like’ or more clear and understandable, just let me know and I’ll see about merging your changes into the main project!
      </p>
    </p>
    
    <blockquote>
      <p>
        <a href="http://github.com/derickbailey/Albacore"><strong>http://github.com/derickbailey/Albacore</strong></a><strong> </strong>
      </p>
    </blockquote>
    
    <p>
      &#160;
    </p>
    
    <h3>
      What’s Next?
    </h3>
    
    <p>
      I am planning to continue extending Albacore, as the needs of my projects continue to evolve. Right now, these two basic tasks are enough to get me off the ground and running. The future will likely bring NCover, NUnit, and other tasks into the mix, as my teams have a need for them.
    </p>
    
    <p>
      &#160;
    </p>
    
    <p>
      <font size="1">(albacore tuna photo by <a href="http://www.flickr.com/photos/djs1021/3906751541/">daviddesign</a>. used here under a </font><a href="http://www.flickr.com/photos/djs1021/3906751541/sizes/l/#cc_license"><font size="1">creative commons license</font></a><font size="1">)</font>
    </p>