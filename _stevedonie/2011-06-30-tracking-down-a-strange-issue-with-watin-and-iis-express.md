---
wordpress_id: 4771
title: Tracking down a strange issue with WatiN and IIS Express
date: 2011-06-30T09:21:44+00:00
author: Steve Donie
layout: post
wordpress_guid: http://lostechies.com/stevedonie/2011/06/30/tracking-down-a-strange-issue-with-watin-and-iis-express/
dsq_thread_id:
  - "346254456"
categories:
  - Continuous Integration
  - Testing
---
In my current project, we have a system that runs our Watin tests using NUnit. We also want to run the tests in our CI build, so we start IIS Express in a [SetUpFixture]. Today I was doing my check in dance and none of the watin tests were passing. It appeared to be a problem with IIS Express starting up, but it was completely unclear what the problem was. I would get a little balloon notification that there was a problem and offering more help if I clicked on it. The “more detailed” help was just this:

Could not load file or assembly &#8216;Microsoft.Web.Diagnostics, Version=7.9.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35&#8217; or one of its dependencies. The system cannot find the file specified.

Not really all that helpful.

So I started digging. I started adding diagnostics to the start of the IIS thread to see what it was doing. Then I ran that same command in a command prompt &#8211; aha! Much better!

<pre class="brush: plain;">C:\Users\Steve\work\client&gt;iisexpress.exe /path:"C:\client\src\Web" /port:8089
Copied template config file 'C:\client\lib\IISExpress\AppServer\applicationhost.config' to 'C:\Users\Steve\AppData\Local\Temp\iisexpress\applicationhost201141420241120.config'
Updated configuration file 'C:\Users\Steve\AppData\Local\Temp\iisexpress\applicationhost201141420241120.config' with given cmd line info.Starting IIS Express ...
Failed to call HttpAddUrl with http://localhost:8089/
Failed to register URL "http://localhost:8089/" for site "Development Web Site" application "/".   Error description: Theprocess cannot access the file because it is being used by another process. (0x80070020)Registration completed
Failed to process sites
Report ListenerChannel stopped due to failure; ProtocolId:http, ListenerChannelId:0HostableWebCore activation failed.
Unable to start iisexpress.

The process cannot access the file because it is being used by another process.
For more information about the error, run iisexpress.exe with the tracing switch enabled (/trace:error).

</pre>

So it isn’t completely clear from that either. The “cannot access the file because it is being used by another process” message is really referring to the port that IIS wants to listen on! That port number, 8089, was hard coded into my build script, and was taken by someone else! Rather than just pick a different port and move on, I wanted to see who it could be… the netstat command to the rescue. I used –b to show the name of the executable and –o to show the process ID.

<pre class="brush: plain;">C:\Users\Steve\work\client&gt;netstat -b -o

Active Connections

  Proto  Local Address          Foreign Address        State           PID
  TCP    127.0.0.1:1109         STEVEDONIE:19872       ESTABLISHED     4780
[Dropbox.exe]
&lt;snip&gt;…

[firefox.exe]
  TCP    127.0.0.1:8088         STEVEDONIE:8089        ESTABLISHED     8092
[googletalkplugin.exe]
  TCP    127.0.0.1:8088         STEVEDONIE:8108        ESTABLISHED     8092
[googletalkplugin.exe]
  TCP    127.0.0.1:8089         STEVEDONIE:8088        ESTABLISHED     7492
[firefox.exe]
  TCP    127.0.0.1:8108         STEVEDONIE:8088        ESTABLISHED     7492
[firefox.exe]
&lt;more snipped&gt;…


</pre>

Turns out it was the google talk plugin and firefox talking to each other on port 8088 and 8089. I think the google talk plugin is using a really bad port range &#8211; that is such a common range for developers to run alternate web servers on!

Now that the mystery is solved, how to fix it? I decided to pick a more obscure port to run IIS Express on. I ended up just choosing 18089.

Finally, I also updated the code that I am using to start IIS to do a couple of things better:  
1. After starting the process, wait a couple of seconds and then make sure the thread is running. If not, there&#8217;s no need to go any further.  
2. Redirect the stderr and stdout from the thread to the console, so that if there is a problem I&#8217;ll see what the problem is rather than just getting a stupid popup in the system notification area.