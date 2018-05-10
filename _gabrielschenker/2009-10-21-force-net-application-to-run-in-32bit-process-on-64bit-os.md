---
wordpress_id: 30
title: Force .NET application to run in 32bit process on 64bit OS
date: 2009-10-21T15:40:36+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2009/10/21/force-net-application-to-run-in-32bit-process-on-64bit-os.aspx
dsq_thread_id:
  - "263908892"
categories:
  - How To
  - Misc
redirect_from: "/blogs/gabrielschenker/archive/2009/10/21/force-net-application-to-run-in-32bit-process-on-64bit-os.aspx/"
---
## Introduction

Our clients install our product on different environments. Some of them have 32bit server OS others have pure 64bit environments. Due to the lack of a 64bit version of a driver we use we have to run certain tools in 32bit mode. But since we do not want to have multiple versions of our product we had to find a possibility to force a .NET (command line) tool to run as a 32bit process on a 64bit OS (e.g. Windows Server 2003/2008).

## Solutions

### Set the platform target

The simplest solution is to set the **Platform Target** to be **x86** on the project properties (build register). 

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2011/03/image_thumb_2EEC8568.png" width="520" height="276" />](https://lostechies.com/content/gabrielschenker/uploads/2011/03/image_56930192.png) 

This will cause the compiler to set the 32Bit flag in the CLR header of the corresponding assembly. Every time we run this application no matter on what type of OS it will execute as a 32bit process. But this solution although simple and straight forward was not a viable solution for us since – as mentioned above – we want to have one and only one version of our product. Thus all components of our package have to be compiled with **Platform Target** set to **Any CPU**.

### Run in the context of IIS

If the application is running in the context of IIS then we can instruct IIS to run the application in a 32bit process. Of course this solution is not the right one for a command line tool…

To run a web application in 32bit mode on an 64bit OS open the **IIS Manager** and navigate to the application pool that the application should run in. Select the application pool and select “**Advance Settings…”.** In the Advanced Settings dialog set the “Enable 32-Bit Applications” to true.

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2011/03/image_thumb_7BB04BFE.png" width="459" height="222" />](https://lostechies.com/content/gabrielschenker/uploads/2011/03/image_6A3FEB26.png) 

### Use corflags.exe to set the bitness

You can flip the 32-bit flag on the assembly after-the-fact using a tool called CorFlags.exe, but that&#8217;s probably not a good idea for a long-term sustainable option. For the details about how to use CorFlags.exe see [this](http://msdn.microsoft.com/en-us/library/ms164699%28VS.80%29.aspx) link. E.g. to **set** the 32Bit flag open the Visual Studio command prompt, navigate to the directory where your assembly is and use this command

<div>
  <div>
    <pre>CorFlags.exe MyAssembly.exe /32Bit+</pre></p>
  </div>
</div>

and to **turn off**&#160; the 32Bit flag it would be

<div>
  <div>
    <pre>CorFlags.exe MyAssembly.exe /32Bit-</pre></p>
  </div>
</div>

### Create a shallow wrapper application

The solution we finally adapted was to build a shallow wrapper application whose platform target is set to x86 and which does nothing else than call the respective application. As already mentioned earlier the application is a command line tool and as such has an entry point defined as follows

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Program</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">int</span> Main(<span style="color: #0000ff">string</span>[] args)</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #008000">// ...</span></pre>
    
    <pre>    }</pre>
    
    <pre>    </pre>
    
    <pre>    <span style="color: #008000">// more code</span></pre>
    
    <pre>}</pre></p>
  </div>
</div>

Our wrapper application can now reference the wrapped application and execute it by using this code

<div>
  <div>
    <pre><span style="color: #0000ff">class</span> Program32</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">static</span> <span style="color: #0000ff">int</span> Main(<span style="color: #0000ff">string</span>[] args)</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">return</span> Program.Main(args);</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

<div>
  Since the “bitness” of the starting assembly determines the “bitness” of the process the whole application will run in a 32bit process.
</div></p> </p> 

But as always, having a solution makes you want to have more. What if we could create a generic 32bit wrapper application that can call any (command line) tool and force it to run in a 32bit process?

Something like this:

<div>
  <div>
    <pre>RunAs32Bit.exe /assembly:MyAssembly.exe /<span style="color: #0000ff">params</span>:<span style="color: #006080">"/connection:Oracle1 /user:joe /numThreads:4"</span></pre></p>
  </div>
</div>

What we finally came up is as simple as this

<div>
  <div>
    <pre><span style="color: #0000ff">static</span> <span style="color: #0000ff">int</span> Main(<span style="color: #0000ff">string</span>[] args)</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #008000">// load the assembly</span></pre>
    
    <pre>    var directory = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);</pre>
    
    <pre>    var assemblyName = Path.Combine(directory, args[0].Substring(10));</pre>
    
    <pre>    var assembly = Assembly.LoadFile(assemblyName);</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #008000">// find the entry point of the assembly</span></pre>
    
    <pre>    var type = assembly.GetTypes().FirstOrDefault(t =&gt; t.GetMethod(<span style="color: #006080">"Main"</span>) != <span style="color: #0000ff">null</span>);</pre>
    
    <pre>    var mi = type.GetMethod(<span style="color: #006080">"Main"</span>);</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #008000">// call the entry point of the wrapped assembly and forward the command line parameters</span></pre>
    
    <pre>    var arguments = args[1].Substring(8).Split(<span style="color: #006080">' '</span>);</pre>
    
    <pre>    var list = arguments.Where(a =&gt; a.Trim() != <span style="color: #006080">""</span>).ToArray();</pre>
    
    <pre>    <span style="color: #0000ff">return</span> (<span style="color: #0000ff">int</span>)mi.Invoke(type, <span style="color: #0000ff">new</span> <span style="color: #0000ff">object</span>[] { list });</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Note that for brevity I omitted the code to validate the command line parameters.