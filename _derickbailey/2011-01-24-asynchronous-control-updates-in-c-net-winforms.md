---
id: 210
title: 'Asynchronous Control Updates In C#/.NET/WinForms'
date: 2011-01-24T17:22:01+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2011/01/24/asynchronous-control-updates-in-c-net-winforms.aspx
dsq_thread_id:
  - "262078423"
categories:
  - .NET
  - Async
  - 'C#'
  - WinForms
---
Every .NET WinForms project I&#8217;ve written, since .NET 2.0, has included some form of this code:

> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas;color: #0034ff">public<span style="color: #000000"> </span>static<span style="color: #000000"> </span>class<span style="color: #000000"> </span><span style="color: #31a2bd">ControlExtensions</span></pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas">{</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas"><span style="color: #0034ff">  public</span> <span style="color: #0034ff">static</span> <span style="color: #0034ff">void</span> Do&lt;TControl&gt;(<span style="color: #0034ff">this</span> TControl control, <span style="color: #31a2bd">Action</span>&lt;TControl&gt; action)</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas"><span style="color: #0034ff">    where</span> TControl: <span style="color: #31a2bd">Control</span></pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas">  {</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas"><span style="color: #0034ff">    if</span> (control.InvokeRequired)</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas">      control.Invoke(action, control);</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas"><span style="color: #0034ff">    else</span></pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas">      action(control);</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas">  }</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas">}</pre>

It&#8217;s a simple extension method that allows any UI control to update itself when called from an asynchronous method &#8211; whether it&#8217;s running from a [.BeginInvoke()](http://msdn.microsoft.com/en-us/library/system.windows.forms.control.begininvoke.aspx) call, a [BackgroundWorker](http://msdn.microsoft.com/en-us/library/system.componentmodel.backgroundworker.aspx), a [ThreadPool](http://msdn.microsoft.com/es-es/library/system.threading.threadpool.aspx) thread, or any other form of asynchronous call. It&#8217;s simple and effective in managing UI updates from asynchronous methods.

I&#8217;m currently using it to update a progress bar, like this:

> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas"><span style="color: #0034ff">private</span> <span style="color: #0034ff">void</span> SetProgress(<span style="color: #0034ff">int</span> percentage)</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas">{</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas">updateProgressBar.Do(ctl =&gt;</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas">{</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas">ctl.Value = percentage;</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas">});<br /></pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 9.5px Consolas">}</pre>

The best part is that it&#8217;s aware of the control type through the use of generics. You don&#8217;t have to cast from a generic Control type so that you can access the specific methods and properties of your specific control type.

I&#8217;m sure this code has been written and blogged about thousands of times (I may have even blogged it in the past&#8230; I don&#8217;t remember, honestly). I just wrote this code again, though, so I wanted to capture it someplace useful.