---
wordpress_id: 418
title: Automating scheduled tasks
date: 2010-06-17T13:26:33+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/06/17/automating-scheduled-tasks.aspx
dsq_thread_id:
  - "264716531"
categories:
  - Tools
---
Back in the day, I used to develop scheduled tasks by writing my own task scheduler and batch execution program.&#160; I don’t think at the time I knew about the [Task Scheduler](http://msdn.microsoft.com/en-us/library/aa383614(VS.85).aspx) service built in to Windows.&#160; It support just about any scheduling algorithm I could throw at it, outside of building dependent or cascading tasks.

For build automation, I often want to create, stop and start these scheduled tasks.&#160; Luckily, there’s a handy command-line tool to do so: [schtasks.exe](http://msdn.microsoft.com/en-us/library/bb736357(VS.85).aspx).&#160; Not only can you administer tasks on your own machine, but other machines as well.&#160; This is perfect for build and deployment automation, where I need to not only copy files, but execute SQL migration scripts, start/stop services, and power down/up scheduled tasks.

The command-line tool lets you do quite a few things:

  * Create a task
  * Delete a task
  * Run a task
  * End a task
  * Query a task for status/information
  * Modify a task

I typically don’t create the tasks, as that really only needs to happen once.&#160; However, it would be fairly trivial for me to do so, and have all of the task setup driven through automation.

One thing I like to do is disable batch jobs before the deployment happens, then turn them all back on.&#160; I don’t want to do this with _all_ the tasks there, so I use NAnt to pull from a text file of the scheduled tasks I’m interested in.&#160; However, I don’t want to disable running tasks, as I want to just let them finish and have the build stop:

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">echo </span><span style="color: red">message</span><span style="color: blue">=</span>"<span style="color: blue">Disabling batch jobs...</span>" <span style="color: blue">/&gt;
&lt;</span><span style="color: #a31515">foreach </span><span style="color: red">item</span><span style="color: blue">=</span>"<span style="color: blue">Line</span>" <span style="color: red">in</span><span style="color: blue">=</span>"<span style="color: blue">batchjobs.txt</span>" <span style="color: red">property</span><span style="color: blue">=</span>"<span style="color: blue">taskName</span>"<span style="color: blue">&gt;
    &lt;</span><span style="color: #a31515">exec </span><span style="color: red">program</span><span style="color: blue">=</span>"<span style="color: blue">schtasks.exe</span>" 
                <span style="color: red">commandline</span><span style="color: blue">=</span>"<span style="color: blue">/Query /TN ${taskName} /FO TABLE /NH</span>" 
                <span style="color: red">output</span><span style="color: blue">=</span>"<span style="color: blue">task.txt</span>" <span style="color: blue">/&gt;
    &lt;</span><span style="color: #a31515">loadfile </span><span style="color: red">file</span><span style="color: blue">=</span>"<span style="color: blue">task.txt</span>" <span style="color: red">property</span><span style="color: blue">=</span>"<span style="color: blue">batchjob.info</span>" <span style="color: blue">/&gt;
    &lt;</span><span style="color: #a31515">exec </span><span style="color: red">program</span><span style="color: blue">=</span>"<span style="color: blue">schtasks.exe</span>" 
                <span style="color: red">commandline</span><span style="color: blue">=</span>"<span style="color: blue">/CHANGE /TN ${taskName} /DISABLE</span>" 
                <span style="color: red">if</span><span style="color: blue">=</span>"<span style="color: blue">${string::contains(batchjob.info, 'Ready')}</span>"<span style="color: blue">/&gt;
&lt;/</span><span style="color: #a31515">foreach</span><span style="color: blue">&gt;</span></pre>

[](http://11011.net/software/vspaste)In this NAnt snippet, I loop through the batch jobs I care about.&#160; I then call the “schtasks.exe”, querying the tasks status by name and outputting the result in the form of a table to a “task.txt” file.&#160; Next, I load that file into a NAnt property.&#160; Finally, I use the “/CHANGE” switch to disable the scheduled task, but ONLY IF its status is “Ready” and not “Running” or something else.

Next, I’ll run through the batch jobs file again, this time querying for any task that hasn’t been disabled.&#160; If there are any, I’ll just fail the build.&#160; I could sleep the build script, and poll until the task completes.

Once the build is done, I’ll enable all the configured scheduled tasks:

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">echo </span><span style="color: red">message</span><span style="color: blue">=</span>"<span style="color: blue">Enabling batch jobs...</span>" <span style="color: blue">/&gt;
&lt;</span><span style="color: #a31515">foreach </span><span style="color: red">item</span><span style="color: blue">=</span>"<span style="color: blue">Line</span>" <span style="color: red">in</span><span style="color: blue">=</span>"<span style="color: blue">batchjobs.txt</span>" <span style="color: red">property</span><span style="color: blue">=</span>"<span style="color: blue">taskName</span>"<span style="color: blue">&gt;
    &lt;</span><span style="color: #a31515">exec </span><span style="color: red">program</span><span style="color: blue">=</span>"<span style="color: blue">schtasks.exe</span>" <span style="color: red">commandline</span><span style="color: blue">=</span>"<span style="color: blue">/CHANGE /TN ${taskName} /ENABLE</span>" <span style="color: blue">/&gt;
&lt;/</span><span style="color: #a31515">foreach</span><span style="color: blue">&gt;</span></pre>

[](http://11011.net/software/vspaste)

Build automation can really cut down on those launch-night headaches and uncertainty.&#160; Having a good command-line tool goes a long way to enabling easy build automation scripts.