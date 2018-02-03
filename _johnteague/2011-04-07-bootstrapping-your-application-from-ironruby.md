---
wordpress_id: 55
title: Bootstrapping Your Application From IronRuby
date: 2011-04-07T17:55:51+00:00
author: John Teague
layout: post
wordpress_guid: http://lostechies.com/johnteague/2011/04/07/bootstrapping-your-application-from-ironruby/
dsq_thread_id:
  - "273770967"
categories:
  - iron ruby
tags:
  - Iron Ruby
---
<p class="brush:ruby">
  I think one of the best use cases for IronRuby is to use it as an automation tool and scripting platform for your domain application. The first hurdle I had to make this possible was Bootstrapping the application so that it can run from the IronRuby runtime. Among other things we need to initialize StructureMap and AutoMapper. Because you&#8217;re executing the IR.exe in it&#8217;s own AppDomain, there a couple of thing you have to do first.
</p>

<p class="brush:ruby">
  Using StructureMap from IronRuby StructureMap can be loaded and accessed from IR without difficulty. But I find the syntax to use generic methods in IronRuby a bit noisy. So I made a simple module that wraps the StructureMap generic methods. We see these used in a minute.
</p>

<pre>require 'StructureMap'
include StructureMap
#module to hide the IronRuby generic noise
module ObjectFactoryModule
    def get_instance type_name
        ObjectFactory.method(:get_instance).of(type_name).call
    end
    def inject(type,instance)
        ObjectFactory.method(:inject).of(type).call(instance)
    end
    def eject(type)
        ObjectFactory.method(:eject_all_instances_of).of(type).call
    end

    def replace(type,instance)
        ObjectFactory.method(:eject_all_instances_of).of(type).call
        ObjectFactory.method(:inject).of(type).call(instance)
    end
end</pre>

&nbsp;

## Config files are your enemy

Because IronRuby runs in its own AppDomain, it is impossible to directly access your config files from IR without some serious [hackery](http://vaderpi.com/blog/?p=609). But this it is not impossible to get around this if you encapsulate application settings behind an interface, with the default implementation getting values from configuration files. We have a very simple interface:

You can create a ruby class that implements the IApplicationSettings interface by including the interface.

&nbsp;

<pre>require 'PropertyRegistration.Common'
include PropertyRegistration::Common
include ObjectFactoryModule
class ScriptingApplicationSettings
    include IApplicationSettings

    def EventSourceDBConnectionString
        return 'Data Source=localhost;Initial Catalog=db;Integrated Security=SSPI'
    end
    def ViewModelConnectionString
        return 'Data Source=localhost;Initial Catalog=db;Integrated Security=SSPI'
    end
    def FasTrackDbConnectionString
        return 'Data Source=localhost;Initial Catalog=db;Integrated Security=SSPI'
    end
    def CurrentSessionContextClass
        return 'thread_static'
    end
    def ViewModelDefaultSchema
        return '[PropertyRegistration_ViewSource].[dbo]'
    end
    def LoadZipcodeDatabaseData
        return false
    end
end</pre>

&nbsp;

Now here&#8217;s the cool part we can inject the ruby class into structuremap so that it will be the implementation of IApplicationSettings.

<pre>$LOAD_PATH &lt;&lt; File.dirname(__FILE__) + "/assemblies"
require 'Rake'
dlls = FileList.new(File.join(File.dirname(__FILE__),"assemblies/*.dll"))
dlls.each {|f|require f}
require 'StructureMap'
require 'ObjectFactoryModule.rb'
require 'ApplicationSettings.rb'
require 'PropertyRegistration.DataLoader'

include ObjectFactoryModule
include PropertyRegistration::DataLoader::Application
include StructureMap

#bootstrapper, loading StructureMap registries and other stuff
BootStrapper.startup

settings = ScriptingApplicationSettings.new
# ejecting IApplicationSettings and replacing with ruby class
replace PropertyRegistration::Common::IApplicationSettings, settings</pre>

&nbsp;

Now, we have loaded all of our assemblies, Called our bootstrapper to initialize StructureMap and everything else. Then we replaced the default implementation of IApplicationSettings with our Ruby implementation and our application is none the wiser. We can now use the IApplicationSettings from StructureMap as well as any classes that have it as a dependency.

exporter = get_instance(DataLoader::SchemaExporter)
  
exporter.generate_schema

There was more work involved getting everything to run from Rake, but this is the basic wiring and the other stuff is not really important.

I have bigger plans for using IronRuby with my applications. This was the first step. I&#8217;ll post more as my journey continues.