---
wordpress_id: 696
title: 'Dependency Management in .Net: Offline Dependencies with NuGet Command Line Tool'
date: 2012-03-09T17:13:59+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=696
dsq_thread_id:
  - "605182120"
categories:
  - Uncategorized
tags:
  - NuGet
---
Today I stumbled upon Scott Haselman’s post: <a href="http://www.hanselman.com/blog/HowToAccessNuGetWhenNuGetorgIsDownOrYoureOnAPlane.aspx" target="_blank">How to access NuGet when NuGet.org is down (or you’re on a plane)</a> in which Scott discusses how he recovered from an issue with the nuget.org site being down during his demo at the Dallas Day of .Net.&nbsp;&nbsp; As it turns out, while NuGet stores packages it downloads in a local Cache folder within your AppData folder, it doesn’t actually use this cache by default.&nbsp; Scott was able to remedy the situation by adding his local cache as a source through the the Visual Studio Package Manager plugin. 

Last year, I wrote about my <a href="https://lostechies.com/derekgreer/2011/09/18/dependency-management-in-net/" target="_blank">philosophy for dependency management</a> and&nbsp; <a href="https://lostechies.com/derekgreer/2011/09/20/dependency-management-in-net-using-nuget-without-visual-studio/" target="_blank">how I use NuGet to facilitate dependency management</a> without using the Visual Studio plugin wherein I discuss using the NuGet.exe command line tool to manage .Net dependencies as part of my rake build.&nbsp; After reading Scott’s post, I got to wondering whether the NuGet.exe command line tool also had the same caching issue and after a bit of testing I discovered that it does.&nbsp; Since I, with the help of a former colleague, <a href="http://freshbrewedcode.com/joshbush/" target="_blank">Josh Bush</a>, have evolved the solution I wrote about previously a bit, I thought I’d provide an update to my approach which includes the caching fix.

As discussed in my previous article, I maintain a packages.rb file which serves as a central manifest of all the dependencies used project wide.&nbsp; Here’s one from a recent project:

<pre class="prettyprint">packages = [
[ "Machine.Specifications", "0.5.3.0" ],
[ "ExpectedObjects", "1.0.0.2" ],
[ "Moq", "4.0.10827" ],
[ "RabbitMQ.Client", "2.7.1" ],
[ "log4net", "1.2.11" ]
]

configatron.packages = packages
</pre>

&nbsp;

This is sourced by a rakefile which which is used by a task which installs any packages not already installed.

The basic template I use for my rakefile is as follows:

<pre class="prettyprint">require 'rubygems'
require 'configatron'
 
...

NUGET_CACHE= File.join(ENV['LOCALAPPDATA'], '/NuGet/Cache/') 
FEEDS = ["http://[corporate NuGet Server]:8000", "https://go.microsoft.com/fwlink/?LinkID=206669" ]
require './packages.rb'
 
task :default =&gt; ["build:all"]
 
namespace :build do
 
  task :all =&gt; [:clean, :dependencies, :compile, :specs, :package] 

  ...

  task :dependencies do
    feeds = FEEDS.map {|x|"-Source " + x }.join(' ')
    configatron.packages.each do | name,version |
      feeds = "-Source #{NUGET_CACHE} " + feeds unless !version
        packageExists = File.directory?("#{LIB_PATH}/#{name}")
        versionInfo="#{LIB_PATH}/#{name}/version.info"
        currentVersion=IO.read(versionInfo) if File.exists?(versionInfo)
        if(!packageExists or !version or !versionInfo or currentVersion != version) then
          versionArg = "-Version #{version}" unless !version
          sh "nuget Install #{name} #{versionArg} -o #{LIB_PATH} #{feeds} -ExcludeVersion" do | ok, results |
            File.open(versionInfo, 'w') {|f| f.write(version) } unless !ok
        end
      end
    end
  end
end
</pre>

&nbsp;

This version defines a NUGET\_CACHE variable which points to the local cache.&nbsp; In the dependencies task, I join all the feeds into a list of Sources for NuGet to check.&nbsp; I leave out the NUGET\_CACHE until I know whether or not a particular package specifies a version number. Otherwise, NuGet would simply check for the latest version which exists within the local cache.

To avoid having to change Visual Studio project references every time I update to a later version of a dependency, I use the –ExcludeVersion option.&nbsp; This means I can’t rely upon the folder name to determine whether the latest version is already installed, so I’ve introduced a version.info file.&nbsp; I imagine this is quite a bit faster than allowing NuGet to determine whether the latest version is installed, but I actually do this for a different reason.&nbsp; If you tell NuGet to install a package into a folder without including the version number as part of the folder and you already have the specified version, <a href="http://nuget.codeplex.com/workitem/1614" target="_blank">it uninstalls and reinstalls the package</a>.&nbsp; Without checking the presence of the correct version beforehand, NuGet would simply reinstall everything every time.

Granted, this rake task is far nastier than it needs to be.&nbsp; It should really only have to be this:

<pre class="prettyprint">task :dependencies do
    nuget.exe install depedencyManifest.txt –o lib
  end
</pre>

&nbsp;

Where the dependencyManifest file might look a little more like this:

<pre class="prettyprint">Machine.Specifications 0.5.3.0
ExpectedObjects 1.0.0.2
Moq 4.0.10827
RabbitMQ.Client 2.7.1
log4net 1.2.11
</pre>

&nbsp;

Nevertheless, I’ve been able to coerce the tool into doing what I want for the most part and it all works swimmingly once you get it set up.
