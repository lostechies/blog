---
wordpress_id: 88
title: Albacore AssemblyInfo Task vs. Nant Assembly Info Generator
date: 2009-09-29T15:06:48+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/09/29/albacore-assemblyinfo-task-vs-nant-assembly-info-generator.aspx
dsq_thread_id:
  - "262068354"
categories:
  - .NET
  - Albacore
  - Productivity
  - Rake
  - Ruby
---
Here’s one of the reasons I like Rake and my custom Rake tasks that I’m building into [Albacore](http://github.com/derickbailey/Albacore), so much. 

To generate some assembly information such as version, company name, copyright, etc., you need to do this with nant:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">&lt;?</span><span style="color: #800000">xml</span> <span style="color: #ff0000">version</span><span style="color: #0000ff">="1.0"</span>?<span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">&lt;</span><span style="color: #800000">project</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="Assembly Version Info Generator"</span> <span style="color: #ff0000">default</span><span style="color: #0000ff">="buildVersionInfo"</span> <span style="color: #ff0000">basedir</span><span style="color: #0000ff">="."</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">&lt;</span><span style="color: #800000">target</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="buildVersionInfo"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>         <span style="color: #0000ff">&lt;</span><span style="color: #800000">asminfo</span> <span style="color: #ff0000">output</span><span style="color: #0000ff">=".SomeFolderAssemblyInfo.cs"</span> <span style="color: #ff0000">language</span><span style="color: #0000ff">="CSharp"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>             <span style="color: #0000ff">&lt;</span><span style="color: #800000">imports</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">import</span> <span style="color: #ff0000">namespace</span><span style="color: #0000ff">="System.Reflection"</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>             <span style="color: #0000ff">&lt;/</span><span style="color: #800000">imports</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>             <span style="color: #0000ff">&lt;</span><span style="color: #800000">attributes</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">attribute</span> <span style="color: #ff0000">type</span><span style="color: #0000ff">="AssemblyCompanyAttribute"</span> <span style="color: #ff0000">value</span><span style="color: #0000ff">="MyCompany, Inc."</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">attribute</span> <span style="color: #ff0000">type</span><span style="color: #0000ff">="AssemblyProductAttribute"</span> <span style="color: #ff0000">value</span><span style="color: #0000ff">="MyProduct"</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">attribute</span> <span style="color: #ff0000">type</span><span style="color: #0000ff">="AssemblyVersionAttribute"</span> <span style="color: #ff0000">value</span><span style="color: #0000ff">="0.0.0.0"</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">attribute</span> <span style="color: #ff0000">type</span><span style="color: #0000ff">="AssemblyCopyrightAttribute"</span> <span style="color: #ff0000">value</span><span style="color: #0000ff">="Copyright (c)2009 MyCompany, Inc. All Rights Reserved."</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>             <span style="color: #0000ff">&lt;/</span><span style="color: #800000">attributes</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>         <span style="color: #0000ff">&lt;/</span><span style="color: #800000">asminfo</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>     <span style="color: #0000ff">&lt;/</span><span style="color: #800000">target</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span> <span style="color: #0000ff">&lt;/</span><span style="color: #800000">project</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        To do the same thing with Albacore, you only need this:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> desc <span style="color: #006080">"Assembly Version Info Generator"</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> Rake::AssemblyInfoTask.<span style="color: #0000ff">new</span>(:assemblyinfo) <span style="color: #0000ff">do</span> |<span style="color: #0000ff">asm</span>|</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">asm</span>.output_file = <span style="color: #006080">"./SomeFolder/AssemblyInfo.cs"</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">asm</span>.company_name = <span style="color: #006080">"MyCompany, Inc."</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">asm</span>.product_name = <span style="color: #006080">"MyProduct"</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">asm</span>.version = <span style="color: #006080">"0.0.0.0"</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>     <span style="color: #0000ff">asm</span>.copyright = <span style="color: #006080">"Copyright (c)2009 MyCompany, Inc. All Rights Reserved."</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span> end</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              I’ll take the half-the-size, easier-to-read lines of no <a href="http://www.codinghorror.com/blog/archives/001114.html">angle-bracket-tax</a> where I can write real code, any day.
            </p>