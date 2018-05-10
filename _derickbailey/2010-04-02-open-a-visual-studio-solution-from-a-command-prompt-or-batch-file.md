---
wordpress_id: 130
title: Open A Visual Studio Solution From A Command Prompt Or Batch File
date: 2010-04-02T13:47:34+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/04/02/open-a-visual-studio-solution-from-a-command-prompt-or-batch-file.aspx
dsq_thread_id:
  - "262068536"
categories:
  - .NET
  - Command Line
  - Visual Studio
redirect_from: "/blogs/derickbailey/archive/2010/04/02/open-a-visual-studio-solution-from-a-command-prompt-or-batch-file.aspx/"
---
I got this idea from the [MassTransit](https://github.com/phatboyg/MassTransit) source code… it’s a good idea because I’m an aspiring keyboard junkie and I’m tired of mouse clicking my way to my solution files. (Note: the MT “open.bat” file is significantly more complicated than what I need or what this post talks about. I got the _idea_, not the implementation, from MT.)

I have 2 solutions in my source tree that I use on a very regular basis. They share a common root folder called “Source” and I run my local git repository from the sources folder which means I usually have a git bash window open in the source folder. I recently got tired of having to click around the folder structure to open the solution I want when I need it – especially when I am closing / reopening the solution whenever I pull the latest code down to my local machine (I HATE the Visual Studio “reload” dialog boxes. It’s faster and easier to close the solution and reload, IMO).

So, in an effort to be a keyboard junkie, I created these two batch files in my source folder – one for each solution. They let me open the solution I want without having to use the mouse and without having to traverse the folder structure. The contents of each batch file is this:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> start MySolutionFolder/MySolution.sln /D MySolutionFolder/</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        The “start” command will launch the default program associated with the file that is specified – in this case, the solution file I want. The “/D {folder}” option sets the working directory for the app that is launched. I’m not sure if I really need to specify the /D option, but I feel safe having done it, so it’s in there. 🙂
      </p>
      
      <p>
        With my two batch files setup like this – one for each solution – I can run them from my git bash shell or a command prompt or powershell. Yet another way to prevent a handful of mouse clicks and folder navigation slowness.
      </p>