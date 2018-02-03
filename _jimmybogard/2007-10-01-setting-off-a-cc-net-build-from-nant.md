---
wordpress_id: 69
title: Setting off a CC.NET build from NAnt
date: 2007-10-01T13:00:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/10/01/setting-off-a-cc-net-build-from-nant.aspx
dsq_thread_id:
  - "283720910"
categories:
  - Tools
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/10/setting-off-ccnet-build-from-nant.html)._

One of the new features in [CruiseControl.NET](http://confluence.public.thoughtworks.org/display/CCNET/Welcome+to+CruiseControl.NET) are [integration queues with priorities](http://confluence.public.thoughtworks.org/display/CCNET/Integration+Queues).&nbsp; By default, all projects can execute concurrently, but sometimes, I want to have a master build execute first, then dependent builds next.&nbsp;&nbsp;This is fairly easy to do, using the integration queues, priorities, and force build publishers.

However, I have a strange situation where I actually need to force a build from a [NAnt](http://nant.sourceforge.net/) script (don&#8217;t ask).&nbsp; There aren&#8217;t any command-line tools to execute CCNET builds, so I couldn&#8217;t use the <exec> task to accomplish this.&nbsp; Instead, I&#8217;ll create a custom NAnt task.&nbsp; To do this, I&#8217;ll need to create a new C# project and reference three key assemblies:

  * NAnt.Core.dll 
      * ThoughtWorks.CruiseControl.Core.dll 
          * ThoughtWorks.CruiseControl.Remote.dll</ul> 
        From there, it&#8217;s just a matter of creating a custom task&nbsp;to call into the CCNET API:
        
        <div class="CodeFormatContainer">
          <pre>[TaskName(<span class="str">"ccnet"</span>)]
<span class="kwrd">public</span> <span class="kwrd">class</span> CCNet : Task
{
    <span class="kwrd">private</span> <span class="kwrd">string</span> _server;
    <span class="kwrd">private</span> <span class="kwrd">int</span> _portNumber = 21234;
    <span class="kwrd">private</span> <span class="kwrd">string</span> _project;

    [TaskAttribute(<span class="str">"server"</span>, Required = <span class="kwrd">true</span>)]
    <span class="kwrd">public</span> <span class="kwrd">string</span> Server
    {
        get { <span class="kwrd">return</span> _server; }
        set { _server = <span class="kwrd">value</span>; }
    }

    [TaskAttribute(<span class="str">"portnumber"</span>, Required = <span class="kwrd">false</span>)]
    <span class="kwrd">public</span> <span class="kwrd">int</span> PortNumber
    {
        get { <span class="kwrd">return</span> _portNumber; }
        set { _portNumber = <span class="kwrd">value</span>; }
    }

    [TaskAttribute(<span class="str">"project"</span>, Required = <span class="kwrd">true</span>)]
    <span class="kwrd">public</span> <span class="kwrd">string</span> ProjectName
    {
        get { <span class="kwrd">return</span> _project; }
        set { _project = <span class="kwrd">value</span>; }
    }

    <span class="kwrd">protected</span> <span class="kwrd">override</span> <span class="kwrd">void</span> ExecuteTask()
    {
        RemoteCruiseManagerFactory factory = <span class="kwrd">new</span> RemoteCruiseManagerFactory();
        <span class="kwrd">string</span> url = <span class="kwrd">string</span>.Format(<span class="str">"tcp://{0}:{1}/CruiseManager.rem"</span>, Server, PortNumber);
        ICruiseManager mgr = factory.GetCruiseManager(url);

        <span class="kwrd">string</span> proj = mgr.GetProject(ProjectName);

        mgr.ForceBuild(ProjectName);
    }
}
</pre>
        </div>
        
        The custom NAnt task needs at least two pieces of information to connect to the CCNET server:
        
          * Server name 
              * Project name</ul> 
            If the remoting port is different than the default (21234), I&#8217;ll need to specify that as well.&nbsp; Now I can execute a CCNET build with this simple NAnt task:
            
            <pre><span style="color: blue">&lt;</span><span style="color: #a31515">ccnet</span><span style="color: blue"> </span><span style="color: red">server</span><span style="color: blue">=</span>"<span style="color: blue">buildserver</span>"<span style="color: blue"> </span><span style="color: red">project</span><span style="color: blue">=</span>"<span style="color: blue">Ecommerce CI</span>"<span style="color: blue"> /&gt;</span></pre>
            
            I&#8217;d still rather use the integration queues, priorities, and publishers, but the NAnt task will work for me in a more complex scenario.