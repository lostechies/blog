---
wordpress_id: 118
title: Targeting multiple environments through NAnt
date: 2008-01-02T20:49:13+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/01/02/targeting-multiple-environments-through-nant.aspx
dsq_thread_id:
  - "264715470"
categories:
  - Tools
---
One of the nice things about using a [command-line local build](http://grabbagoft.blogspot.com/2007/11/some-nant-tips.html)&nbsp;is that I can easily target multiple environments.&nbsp; Our configuration scheme is fairly straightforward, with all changes limited to one &#8220;web.config&#8221; file.

When I refer to multiple environments, I&#8217;m talking about many&nbsp;individual isolated deployment targets, such as production, integration, developer, local, etc.&nbsp; Each environment has its own database, services, maybe even domain.&nbsp; Sometimes I need to configure my local code to point to different environments, where maybe a defect shows up in production but not our integration environment.

A typical scenario might be that I have different database in each environment.&nbsp; Different databases means different connection strings, and my connection strings are stored in my &#8220;web.config&#8221; file.&nbsp; The problem is that the &#8220;web.config&#8221; file is stored in source control, and I don&#8217;t want to always check-in and check-out the file each time I want to target a different environment.

Additionally, I don&#8217;t want to have to _remember_ the connection string when I switch to a different environment.&nbsp; I want it all automated, and I want it to just work.

To point our local codebase at different environments, we apply a few tricks to NAnt to make it easy to switch back and forth between many environments.

### The command-line build

The first item we have set up is a command-line build and local deployment.&nbsp; Our environment is a too complex to have only solution compilation to be sufficient to actually run our app, so we use NAnt to build and run our software.&nbsp; To do this, I have a very simple &#8220;go.bat&#8221; batch file that calls NAnt with the appropriate command-line arguments:

<pre>@toolsnantNAnt.exe -buildfile:NBehave.build %*</pre>

When&nbsp;I call NAnt from the command-line,&nbsp;I can pass in multiple targets without needing&nbsp;to specify the build file or other arguments every time:

<pre>go clean test deploy</pre>

Now that I can easily call different targets in the build, I can use that mechanism to target different environments, doing something like this:

<pre>go PROD clean test deploy</pre>

### Configuring NAnt

To get a NAnt target to change my configuration, I need a few elements in place:

  * File to hold configuration entries 
      * Target to load configuration 
          * Tasks to&nbsp;apply configuration</ul> 
        The basic idea is that the &#8220;PROD&#8221; or &#8220;SIT&#8221; or &#8220;DEV&#8221; target will load up specific configuration properties.&nbsp; After compilation, these configuration properties will be inserted back into the web.config file.&nbsp; I will have a set of configuration properties for each environment that have the same name, but different values.
        
        #### Configuration settings file
        
        I like to keep my configuration settings in a separate build file, so I created an &#8220;environmentSettings.build&#8221; file to hold all of the settings for each environment:
        
        <div class="CodeFormatContainer">
          <pre>&lt;?xml version=<span class="str">"1.0"</span> encoding=<span class="str">"utf-8"</span>?&gt;
&lt;project name=<span class="str">"Environment Settings"</span> xmlns=<span class="str">"http://nant.sf.net/schemas/nant.xsd"</span>&gt;

  &lt;target name=<span class="str">"config-settings-PROD"</span>&gt;
    &lt;property name=<span class="str">"connection_string"</span> <span class="kwrd">value</span>=<span class="str">"Data Source=prddbsvr;Initial Catalog=AdventureWorks;Integrated Security=true"</span> /&gt;
  &lt;/target&gt;

  &lt;target name=<span class="str">"config-settings-SIT"</span>&gt;
    &lt;property name=<span class="str">"connection_string"</span> <span class="kwrd">value</span>=<span class="str">"Data Source=sitdbsvr;Initial Catalog=AdventureWorks;Integrated Security=true"</span> /&gt;
  &lt;/target&gt;

  &lt;target name=<span class="str">"config-settings-DEV"</span>&gt;
    &lt;property name=<span class="str">"connection_string"</span> <span class="kwrd">value</span>=<span class="str">"Data Source=(local);Initial Catalog=AdventureWorks;Integrated Security=true"</span> /&gt;
  &lt;/target&gt;

&lt;/project&gt;
</pre>
        </div>
        
        Two important items to note are:
        
          * Target names differ only by last part, the target environment 
              * Targets all define the same property, namely &#8220;connection_string&#8221;, but these values are different in each example</ul> 
            #### Selecting configuration
            
            Now that my configuration settings file is finished, it&#8217;s time to turn our attention back to the main build script file.&nbsp; I need to add targets to handle &#8220;PROD&#8221;, &#8220;SIT&#8221;, etc.&nbsp; Additionally, I want to define a property that has a default environment setting.
            
            The targets that handle &#8220;PROD&#8221;, etc. don&#8217;t need to do much other than re-define the environment setting property and load the targets from the new file.&nbsp; Here are those targets:
            
            <div class="CodeFormatContainer">
              <pre>&lt;property name=<span class="str">"target-env"</span> <span class="kwrd">value</span>=<span class="str">"DEV"</span> /&gt;

&lt;target name=<span class="str">"DEV"</span>&gt;
  &lt;property name=<span class="str">"target-env"</span> <span class="kwrd">value</span>=<span class="str">"DEV"</span> /&gt;
  &lt;call target=<span class="str">"load-config-settings"</span> /&gt;
&lt;/target&gt;

&lt;target name=<span class="str">"SIT"</span>&gt;
  &lt;property name=<span class="str">"target-env"</span> <span class="kwrd">value</span>=<span class="str">"SIT"</span> /&gt;
  &lt;call target=<span class="str">"load-config-settings"</span> /&gt;
&lt;/target&gt;

&lt;target name=<span class="str">"PROD"</span>&gt;
  &lt;property name=<span class="str">"target-env"</span> <span class="kwrd">value</span>=<span class="str">"PROD"</span> /&gt;
  &lt;call target=<span class="str">"load-config-settings"</span> /&gt;
&lt;/target&gt;

&lt;target name=<span class="str">"load-config-settings"</span> unless=<span class="str">"${target::has-executed('load-config-settings')}"</span>&gt;
  &lt;include buildfile=<span class="str">"${env-settings.file}"</span> /&gt;
&lt;/target&gt;

</pre>
            </div>
            
            The first thing to note here is the declaration of the &#8220;target-env&#8221; property at the top.&nbsp; That will be useful later on when making decisions based on the target environment.
            
            Next, I declare a set of targets named after my target environments, namely &#8220;DEV&#8221;, &#8220;SIT&#8221; and &#8220;PROD&#8221;.&nbsp; These are also the same names as the postfixes in the target names in my &#8220;environmentSettings.build&#8221; file I created earlier.&nbsp; In each of these targets, I override the &#8220;target-env&#8221; property with its new value, the target environment.&nbsp; Remember that in my &#8220;go.bat&#8221; file, all command-line arguments are targets to be executed by NAnt, so I have to create a specific target for each target environment I want to support.
            
            Finally, I call the &#8220;load-config-settings&#8221; target.&nbsp; Its responsibility is simply to load the environment settings build file I created earlier, but not to call any of its targets.&nbsp; The reason for the &#8220;unless&#8221; part is that NAnt does not allow you to declare the same targets twice, so I need to make sure that the &#8220;load-config-settings&#8221; target is only executed at most once.
            
            #### Loading and applying configuration
            
            Now that I have all of the targets loaded, I need to call the appropriate settings target and apply the configuration properties to the web.config file.&nbsp; This step is usually done post-compilation, but I can apply the settings any time after they are loaded:
            
            <div class="CodeFormatContainer">
              <pre>&lt;target name=<span class="str">"modify-web-config"</span>&gt;
  
  &lt;call target=<span class="str">"config-settings-${target-env}"</span> /&gt;

  &lt;xmlpoke
    file=<span class="str">"${deploy.dir}/Web.Config"</span>
    xpath=<span class="str">"/configuration/appSettings/add[@key='ConnectionString']/@value"</span>
    <span class="kwrd">value</span>=<span class="str">"${connection_string}"</span>
   /&gt;

&lt;/target&gt;
</pre>
            </div>
            
            First, this target calls &#8220;config-settings-XXXXX&#8221;, where the last part is filled in by the &#8220;target-env&#8221; property declared earlier.&nbsp; If I chose &#8220;SIT&#8221;, the &#8220;config-settings-SIT&#8221; target is called.&nbsp; If I chose &#8220;PROD&#8221;, the &#8220;config-settings-PROD&#8221; target is called.&nbsp; Recall also that the &#8220;config-settings-XXXX&#8221; targets all declare the same properties, but with different values.
            
            Finally, I use the xmlpoke task to modify the web.config file, giving it the new &#8220;connection_string&#8221; property value set up from the &#8220;config-settings-XXXX&#8221; target.
            
            Now, if I want to target different environments, all I need to do is put in the environment name when calling the batch script, such as &#8220;go SIT deploy-local&#8221;, and my local app now targets a different environment.&nbsp; If there are more complex things I need to do based on the target environment, all I need to do is check the &#8220;target-env&#8221; property.
            
            ### Wrapping it up
            
            There are many different ways to target different environments, such as web deployment projects and solution configuration.&nbsp; I found using NAnt integrated well with our command-line build and gave us a maintainable solution, as all build/deployment logic is hosted in one build script, instead of spread over many project or solution configurations.