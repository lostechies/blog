---
wordpress_id: 570
title: 'Dependency Management in .Net: install2'
date: 2011-09-27T01:41:20+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=570
dsq_thread_id:
  - "426811324"
categories:
  - Uncategorized
---
Inspired by [Rob Reynolds](http://twitter.com/#!/ferventcoder)’ [awesome post](http://geekswithblogs.net/robz/archive/2011/07/15/extend-nuget-command-line.aspx) on extending NuGet’s command line, I decided to create my own extension for facilitating application-level, build-time retrieval of external dependencies along with all transitive dependencies. I struggled a bit with what to call the command since what it does is really what I believe the regular install command should be doing (i.e. installing transitive dependencies), so I decided to just call it install2. Here’s how to use it:

> **Step 1**: Install the NuGet Extension package by running the following command:
> 
> <pre class="brush:shell; gutter:false; wrap-lines:true;">$&gt; NuGet.exe Install /ExcludeVersion /OutputDir %LocalAppData%\NuGet\Commands AddConsoleExtension
</pre>
> 
> 
> 
> **Step 2**: Install the extension by running the following command:
> 
> <pre class="brush:shell; gutter:false; wrap-lines:false;">$&gt; NuGet.exe addExtension nuget.install2.extension
</pre>
> 
> 
> 
> **Step 3**: Create a plain-text packages file (e.g. dependencies.config) listing out all the dependencies you need. For example:
> 
> <pre class="brush:shell; gutter:false; wrap-lines:false;">NHibernate 3.2.0.4000
Moq
</pre>
> 
> 
> 
> **Step 4**: Execute Nuget with the install2 extension command:
> 
> <pre class="brush:shell; gutter:false; wrap-lines:false;">$&gt; NuGet.exe install2 dependencies.config
</pre>



If all goes well, you should see the following output:

<pre class="brush:shell; gutter:false; wrap-lines:false;">Attempting to resolve dependency 'Iesi.Collections (3.2.0.4000)'.
Successfully installed 'Iesi.Collections 3.2.0.4000'.
Successfully installed 'NHibernate 3.2.0.4000'.
Successfully installed 'Moq 4.0.10827'.
</pre>

Enjoy!
