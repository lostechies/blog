---
id: 542
title: 'Dependency Management in .Net: Using NuGet without Visual Studio'
date: 2011-09-20T03:40:25+00:00
author: Derek Greer
layout: post
guid: http://lostechies.com/derekgreer/?p=542
dsq_thread_id:
  - "419858883"
categories:
  - Uncategorized
tags:
  - NuGet
---
In my [last article](http://lostechies.com/derekgreer/2011/09/18/dependency-management-in-net/), I discussed some of my previous experiences with dependency management solutions and set forth some primary objectives I believe a dependency management tool should facilitate. In this article, I’ll show how I’m currently leveraging NuGet’s command line tool to help facilitate my dependency management goals.

First, it should be noted that NuGet was designed primarily to help .Net developers more easily discover, add, update, and remove dependencies to externally managed packages from within Visual Studio. It was not designed to support build-time, application-level dependency management outside of Visual Studio. While NuGet wasn’t designed for this purpose, I believe it currently represents the best available option for accomplishing these goals. 

## Approach 1

My team and I first started using NuGet for retrieving application dependencies at build-time a few months after its initial release, though we’ve evolved our strategy a bit over time. Our first approach used a batch file we named install-packages.bat that used NuGet.exe to process a single packages.config file located in the root of our source folder and download the dependencies into a standard \lib folder. We would then run the batch file after adding any new dependencies to the packages.config and proceed to make assembly references as normal from Visual Studio. We also use Mercurial as our VCS and added a rule to our .hgignore file to keep from checking in the downloaded assemblies. To ensure a freshly downloaded solution obtained all of its needed dependencies, we just added a call to our batch file from a Pre-build event in one of our project files. Voilà!

Here’s an example of our single packages.config file (note, it’s just a regular NuGet config file which it normally stores in the project folder): 

<pre class="brush:xml; gutter:false; wrap-lines:false; tab-size:2;">&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;packages&gt;
&lt;package id="Antlr" version="3.1.3.42154" /&gt;
&lt;package id="Castle.Core" version="2.5.1" /&gt;
&lt;package id="Iesi.Collections" version="3.2.0.4000" /&gt;
&lt;package id="NHibernate" version="3.2.0.4000" /&gt;
&lt;package id="FluentNHibernate" version="1.3.0.717" /&gt;
&lt;package id="Machine.Specifications" version="0.4.9.0" /&gt;
&lt;package id="Machine.Fakes" version="0.2.1.2" /&gt;
&lt;package id="Machine.Fakes.Moq" version="0.2.1.2" /&gt;
&lt;package id="Moq" version="4.0.10827" /&gt;
&lt;package id="Moq.Contrib" version="0.3" /&gt;
&lt;package id="SeleniumDotNet-2.0RC" version="3.0.0.0" /&gt;
&lt;package id="AutoMapper" version="1.1.0.118" /&gt;
&lt;package id="Autofac" version="2.4.5.724" /&gt;
&lt;package id="Autofac.Mvc3" version="2.4.5.724" /&gt;
&lt;package id="Autofac.Web" version="2.4.5.724" /&gt;
&lt;package id="CassiniDev" version="4.0.1.7" /&gt;
&lt;package id="NDesk.Options" version="0.2.1" /&gt;
&lt;package id="log4net" version="1.2.10" /&gt;
&lt;package id="MvcContrib.Mvc3.TestHelper-ci" version="3.0.60.0" /&gt;
&lt;package id="NHibernateProfiler" version="1.0.0.838" /&gt;
&lt;package id="SquishIt" version="0.7.1" /&gt;
&lt;package id="AjaxMin" version="4.13.4076.28499" /&gt;
&lt;package id="ExpectedObjects" version="1.0.0.0" /&gt;
&lt;package id="RazorEngine" version="2.1" /&gt;
&lt;package id="FluentMigrator" version="0.9.1.0" /&gt;
&lt;package id="Firefox" version="3.6.6" /&gt;
&lt;/packages></pre>

&nbsp;

Here’s the batch file we used: 

<pre class="brush:shell; gutter:false; wrap-lines:false; tab-size:2;">@echo off
set SCRIPT_DIR=%~dp0
set NUGET=%SCRIPT_DIR%..\tools\NuGet\NuGet.exe
set PACKAGES=%SCRIPT_DIR%..\src\packages.config
set DESTINATION=%SCRIPT_DIR%..\lib\
set LOCALCACHE=C:\Packages\
set CORPCACHE=//corpShare/Packages/
set DEFAULT_FEED="https://go.microsoft.com/fwlink/?LinkID=206669"

echo [Installing NuGet Packages]
if NOT EXIST %DESTINATION% mkdir %DESTINATION%

echo.
echo [Installing From Local Machine Cache]
%NUGET% install %PACKAGES% -o %DESTINATION% -Source %LOCALCACHE%

echo.
echo [Installing From Corporate Cache]
%NUGET% install %PACKAGES% -o %DESTINATION% -Source %CORPCACHE%

echo.
echo [Installing From Internet]
%NUGET% install %PACKAGES% -o %DESTINATION%

echo.
echo [Copying To Local Machine Cache]
xcopy /y /d /s %DESTINATION%*.nupkg %LOCALCACHE%

echo.
echo Done</pre>

&nbsp;

This batch file uses NuGet to retrieve dependencies first from a local cache, then from a corporate level cache, then from the default NuGet feed. It then copies any of the newly retrieved packages to the local cache.&nbsp; I don’t remember if NuGet had caching when this was first written, but it was decided to keep our own local cache due to the fact that NuGet only seemed to cache packages if retrieved from the default feed. We used the corporate cache as a sort of poor-man’s private repository for things we didn’t want to push up to the public feed.

The main drawback to this approach was that we had to keep up with all of the transitive dependencies. When specifying a packages.config file, NuGet.exe only retrieves the packages listed in the file. It doesn’t retrieve any of the dependencies of the packages listed in the file. 

## Approach 2

In an attempt to improve upon this approach, we moved the execution of NuGet.exe into our rake build. In doing so, we were able to eliminate the need to specify transitive dependencies by ditching the use of the packages.config file in favor of a Ruby dictionary. We also removed the Pre-Build rule in favor of just running rake prior to building in Visual Studio.

Here is our dictionary which we store in a packages.rb file: 

<pre class="brush:ruby; gutter:false; wrap-lines:false; tab-size:2;">packages = [
[ "FluentNHibernate",              "1.3.0.717" ],
[ "Machine.Specifications",        "0.4.9.0" ],
[ "Moq",                           "4.0.10827" ],
[ "Moq.Contrib",                   "0.3" ],
[ "Selenium.WebDriver",            "2.5.1" ],
[ "Selenium.Support",              "2.5.1" ],
[ "AutoMapper",                    "1.1.0.118" ],
[ "Autofac",                       "2.4.5.724" ],
[ "Autofac.Mvc3",                  "2.4.5.724" ],
[ "Autofac.Web",                   "2.4.5.724" ],
[ "NDesk.Options",                 "0.2.1" ],
[ "MvcContrib.Mvc3.TestHelper-ci", "3.0.60.0" ],
[ "NHibernateProfiler",            "1.0.0.912" ],
[ "SquishIt",                      "0.7.1" ],
[ "ExpectedObjects",               "1.0.0.0" ],
[ "RazorEngine",                   "2.1"],
[ "FluentMigrator",                "0.9.1.0"],
[ "Firefox",                       "3.6.6"],
[ "FluentValidation",              "3.1.0.0" ],
[ "log4net",                       "1.2.10" ]
]

configatron.packages = packages
</pre>

&nbsp;

Here’s the pertinent sections of our rakefile:

<pre class="brush:ruby; gutter:false; wrap-lines:false; tab-size:2;">require 'rubygems'
require 'configatron'

...

FEEDS = ["//corpShare/Packages/", "https://go.microsoft.com/fwlink/?LinkID=206669" ]

require './packages.rb'

task :default =&gt; ["build:all"]

namespace :build do

	task :all =&gt; [:clean, :dependencies, :compile, :specs, :package]	

	...


	task :dependencies do
		configatron.packages.each do | package |
			FEEDS.each do | feed | 
				!(File.exists?("#{LIB_PATH}/#{package[0]}")) and
					sh "#{TOOLS_PATH}/NuGet/nuget Install #{package[0]} -Version #{package[1]} -o #{LIB_PATH} -Source #{feed} -ExcludeVersion" do | cmd, results | cmd  end
			end
		end
	end

end</pre>

&nbsp;

Another change we made was to use the -ExcludeVersion switch to enable us to setup up the Visual Studio references one time without having to change them every time we upgrade versions. Ideally, I’d like to avoid having to reference transitive dependencies altogether, but I haven’t come up with a clean way of doing this yet. 

## Approach 2: Update

As of version 1.4, NuGet will now resolve a package&#8217;s dependencies (i.e. transitive dependencies) from any of the provided sources ([see workitem 603](http://nuget.codeplex.com/workitem/603)). This allows us to modify the above script to issue a single call to nuget:

<pre class="brush:ruby; gutter:false; wrap-lines:false; tab-size:2;">task :dependencies do
        configatron.packages.each do | package |
            !(File.exists?("#{LIB_PATH}/#{package[0]}")) and
                    feeds = FEEDS.map {|x|"-Source " + x }.join(' ')
                    sh "nuget Install #{package[0]} -Version #{package[1]} -o #{LIB_PATH} #{feeds} -ExcludeVersion" do | cmd, results | cmd  end
        end
    end
</pre>

## Summary

While NuGet wasn’t designed to support build-time, application-level dependency management outside of Visual Studio in the way demonstrated here, it suits my team’s needs for now. My hope is NuGet will eventually support these scenarios more directly.
