---
wordpress_id: 3936
title: Monkey patching rake for use with TeamCity
date: 2008-09-10T22:08:54+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2008/09/10/monkey-patching-rake-for-use-with-teamcity.aspx
dsq_thread_id:
  - "262113109"
categories:
  - Ruby
  - teamcity
---
We use Ruby’s <a href="http://rake.rubyforge.org/" target="_blank">rake</a> as our build automation tool.&#160; It provides a nice, XML-free way to define logical groupings of steps to perform, with dependency resolution.

We use JetBrain’s <a href="http://www.jetbrains.com/teamcity/" target="_blank">TeamCity</a> as our continuous integration server. It has a neat feature that provides real-time reporting of build progress. TeamCity does not have any built-in support for rake*, so we use the simpleRunner build runner which allows you to kick off any process. However, when using the simpleRunner, you do not get any progress updates, since TeamCity doesn’t really know what is going on within your custom process.

Turns out, this is really easy to fix. TeamCity has a <a href="http://www.jetbrains.net/confluence/display/TCD3/Build+Script+Interaction+with+TeamCity" target="_blank">very simple API</a> which allows a build script to interact with it. You just have to send specially formatted text messages to standard out (the console). For example, writing the following text to the console from your build script will cause the message “Starting compilation” to appear as the build status (on the project website, or the notification tray):

<pre>##teamcity[progressStart 'Starting compilation']</pre>

Now, it would be pretty annoying if we had to litter these messages throughout our build script. Fortunately, in ruby, classes are open by default. This means we can add or change behavior of existing classes, even if we do not have control over the source. In this case, I want to change the Execute method on Rake’s Task class so that it sends a message to TeamCity when a task starts and finishes. I use <a href="http://blog.jayfields.com/2006/12/ruby-alias-method-alternative.html" target="_blank">Jay Fields’ example of redefining a method</a> that still needs to call its original implemention (thanks to <a href="http://stevenharman.net/" target="_blank">Steven Harman</a> for the help via twitter). I created a file [TeamCity.rb] with the following contents in the same directory as our RAKEFILE:

module TeamCity
    
  
&#160;&#160;&#160; de<font face="Courier New">f teamcity_progress(task)<br /> <br />&#160;&#160;&#160;&#160;&#160;&#160;&#160; teamcity_service_message &#8216;progressStart&#8217;, task </p> 

<p>
  &#160;&#160;&#160;&#160;&#160;&#160;&#160; yield
</p>

<p>
  &#160;&#160;&#160;&#160;&#160;&#160;&#160; teamcity_service_message &#8216;progressFinish&#8217;, task
</p>

<p>
  &#160;&#160;&#160; end </font>
</p>

<p>
  <font face="Courier New">&#160;&#160;&#160; def teamcity_service_message(message, message_value)<br /> <br />&#160;&#160;&#160;&#160;&#160;&#160;&#160; puts "##teamcity[#{message} &#8216;#{message_value}&#8217;]" </p> 
  
  <p>
    &#160;&#160;&#160; end
  </p>
  
  <p>
    end </font>
  </p>
  
  <p>
    <font face="Courier New">class Rake::Task<br /> <br />&#160;&#160;&#160; include TeamCity </p> 
    
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160; old_execute = self.instance_method(:execute) </font>
    </p>
    
    <p>
      <font face="Courier New">&#160;&#160;&#160;&#160;&#160;&#160; define_method(:execute) do |args|<br /> <br />&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; teamcity_progress("Executing #{name} rake task") { old_execute.bind(self).call(args) } </p> 
      
      <p>
        &#160;&#160;&#160;&#160;&#160;&#160; end
      </p>
      
      <p>
        end</font>
      </p>
      
      <p>
        I then conditionally include this patch (so that we do not see all of the annoying TeamCity messages when running the build locally) with the following line in our RAKEFILE:
      </p>
      
      <p>
        <font face="Courier New">require &#8216;TeamCity.rb&#8217; if ENV["teamcity.dotnet.nunitlauncher"]</font>
      </p>
      
      <p>
        I just arbitrarily picked an environment variable that I know is defined when run within TeamCity, that is not defined on our local machines. There is probably a more appropriate/universally applicable environment variable which indicates “running in TeamCity”.
      </p>
      
      <p>
        We now can see near real-time which rake task is currently running on the CI server. This can be nice when you are trying to fix a broken build, and you want to know if the current build has successfully passed the step that caused the failure. And yeah, it was also a fun way to explore monkey patching with ruby.
      </p>
      
      <p>
        * There is actually an <a href="http://blogs.jetbrains.com/teamcity/2008/03/27/teamcity-rake-build-runner-eap-is-open/" target="_blank">EAP for a Rake Build Runner</a>, which I did not find out about until doing some research for this post. From the description, it sounds more geared toward people actually building ruby applications, which does not include us. All of our code is C#/.NET – only our build script is in ruby. However, its probably worth investigating further.
      </p>