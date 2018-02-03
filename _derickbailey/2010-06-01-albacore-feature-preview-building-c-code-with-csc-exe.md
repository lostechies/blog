---
wordpress_id: 166
title: 'Albacore Feature Preview: Building C# Code With CSC.exe'
date: 2010-06-01T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/06/01/albacore-feature-preview-building-c-code-with-csc-exe.aspx
dsq_thread_id:
  - "262206493"
categories:
  - .NET
  - Albacore
  - 'C#'
  - Rake
  - Unit Testing
  - Vim
---
I’ve been meaning to do this for a very long time… it’s been asked for multiple times and it’s been on my list of things to do for a very long time… but it’s finally happening! I’m finally putting a ‘csc’ task into albacore so that you can build your c# code directly from the **c**&#8211;**s**harp **c**ompiler (csc.exe). 

&#160;

### A Simple Example

Here’s a small sample of what a rakefile might look like, using the csc task:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> csc :build <span style="color: #0000ff">do</span> |csc|</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span>   csc.command = <span style="color: #006080">"csc.exe"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>   csc.compile FileList[<span style="color: #006080">"src/**/*.cs"</span>].exclude(<span style="color: #006080">"src/**/*Specs.cs"</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>   csc.output = <span style="color: #006080">"myproject.dll"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>   csc.target = :library</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span> end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span> csc :build_tests =&gt; [:build] <span style="color: #0000ff">do</span> |csc|</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>   csc.command = <span style="color: #006080">"csc.exe"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>   csc.compile FileList[<span style="color: #006080">"src/**/*Specs.cs"</span>]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>   csc.output = <span style="color: #006080">"myproject.specs.dll"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>   csc.target = :library</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>   csc.references <span style="color: #006080">"myproject.dll"</span>, <span style="color: #006080">"nunit.framework.dll"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span> end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span> nunit :test =&gt; [:build_tests] <span style="color: #0000ff">do</span> |nunit|</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span>   nunit.command = <span style="color: #006080">"nunit-console.exe"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>   nunit.assemblies <span style="color: #006080">"myproject.specs.dll"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span> end</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        there are three tasks here: build, build_tests, and test.
      </p>
      
      <ol>
        <li>
          the <strong>build</strong> task will build all .cs files that do not end with “Specs.cs” and will produce a dll called “myproject.dll”
        </li>
        <li>
          the <strong>build_tests</strong> task will build all of the unit tests by compiling al files that end with “Specs.cs”, referencing the “myproject.dll” as well as “nunit.framework.dll” and producing a file called “myproject.specs.dll”
        </li>
        <li>
          and the <strong>test</strong> task will run the tests that are found in “myproject.specs.dll”
        </li>
      </ol>
      
      <p>
        It’s a fairly simple script but that’s the point. By using a FileList to specify what files should be included / excluded from compilation, you can use naming conventions to determine what will or won’t be built into any given assembly. This means there is no need to have separate “tests” folder or project. You can have your tests living in files right next to the things that are being tested. With proper naming conventions being followed (whatever conventions your team wants to use), you don’t have to worry about your tests being built into your production code.
      </p>
      
      <p>
        &#160;
      </p>
      
      <h3>
        A Work In Progress
      </h3>
      
      <p>
        This is still a work in progress and not an official announcement of the csc task’s availability. The example above shows almost everything that the csc task is currently capable of… and as you can see, it doesn’t have a lot of the csc command line features built into it, yet. If you’d like to help add features and functionality, the task is currently being built in the dev branch of the albacore repository.
      </p>
      
      <p>
        If you’d like to follow the progress of the csc task without wading through all the other work going on in the dev branch, I’ve started a small project over on github, called <a href="http://github.com/derickbailey/vimbacore">vimbacore</a>. This is my personal playground for trying out two things: c# coding in vim (not just <a href="http://www.lostechies.com/blogs/derickbailey/archive/2010/04/23/using-vim-as-your-c-code-editor-from-visual-studio.aspx">using vim from visual studio</a>… but, <a href="http://www.lostechies.com/blogs/louissalin/archive/2010/05/22/code-kata-setup.aspx">only using vim</a>), and the csc task in albacore. If you would like to see the evolution of the csc task in albacore, you can watch this project. I’m going to try and keep it up to date with new features and functionality related to the csc task and use this example project as a means of determining what features and functionality the csc task needs.
      </p>