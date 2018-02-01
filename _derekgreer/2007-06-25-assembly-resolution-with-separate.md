---
id: 451
title: Assembly Resolution with Separate AppDomains
date: 2007-06-25T20:20:00+00:00
author: Derek Greer
layout: post
guid: http://www.aspiringcraftsman.com/2007/06/assembly-resolution-with-separate-appdomains/
dsq_thread_id:
  - "315803637"
categories:
  - Uncategorized
tags:
  - Assembly Resolution
---
It’s been quite a while since my last post. This was primarily due to an extremely busy schedule I kept last year and the fact that I relocated for a new job about 6 months ago. This has kept me quite preoccupied in all that goes with getting settled into a new city, job, and home. I thought I’d try to get back into the swing of things by sharing a recent obstacle I encountered involving Assembly resolution.

I recently designed a search framework at my new company which allows for differing teams to develop Add-Ins to provide search capabilities for an existing host application. I’ve designed a number of plug-in frameworks in the past, but this particular application presented me with an interesting challenge.

The issue I encountered involved the loading of Add-In assemblies within the context of a separate AppDomain. Normally this wouldn’t be an issue, but due to a custom assembly loading process used by the host application, my framework encountered problems loading dependency resources required by some of the Add-In assemblies.

The hosting application which my search framework was designed for is itself an Add-In based framework very much like the Composite UI Application Block (and was in fact one of the projects which lead to the development of the CAB by the P&P; team). The host application was designed to load its modules into the load-from context from folders denoting the version number of the module. This was done to allow multiple versions of a single module to be present within a single install of the application. To allow multiple modules to share assemblies, the host application provides a common folder which is interrogated upon the raising of the default AppDomain’s AssemblyResolve event.

Once loaded, my search framework made calls to a reflection utility to find and load its own Add-Ins from a configurable list of folder locations. I designed this utility to search for Add-Ins within a separate AppDomain to prevent the search process from loading assemblies into the default domain solely to interrogate the assemblies for the proper types. Upon successfully completing the search process, the utility returns a list of types to the default domain and unloads the separate domain.

This was all well and good until I attempted to load an Add-In assembly which contained dependencies on assemblies installed in the host application’s special common assembly folder. The default domain could resolve the assembly due to the handler wired to the AssemblyResolve event, but the new AppDomain wasn’t wired to resolve assemblies from this special folder. The result was that the loading of the prospective Add-In assembly failed since all of its dependencies couldn’t be resolved.

There are several potential solutions to such a problem, but the best will depend on your particular application type.

One solution to this issue would be to handle the AssemblyResolve event in the new AppDomain to search the same folders used by the default domain. A shortcoming of this approach would be that it would duplicate code thereby leaving the process open to becoming out of sync with the default domain’s process. The potential for this problem becomes more likely for composite applications where different components of the application are maintained by multiple development teams. Because this involves the duplication of code, this solution would not be advised.

Another approach would be to use the same AssemblyResolve event handler used by the default domain to resolve assemblies for the new AppDomain. Of course, this would first presume the event handler was publically accessible to the reflection utility code. This might be an acceptable solution for applications maintained by a single development team, but would be somewhat fragile for composite applications maintained by multiple teams. The shortcoming of this approach is that building in such a dependency would lead to future incompatibility errors if the default domain’s process changed the name or accessibility of the handler in a future release.

Both of these options have the advantage of containing the load process within the context of the new AppDomain, but have similar disadvantages in their dependencies on the default domain’s loading process.

The solution I settled on was to handle the AssemblyResolve event in the new AppDomain, but to marshal the resolution process back to the default AppDomain. I did this by first providing a reference to the default AppDomain from the code running in the new AppDomain. I then used the DoCallback() method of the default AppDomain from within my new AssemblyResolve handler to call a method which performed a simple Assembly.Load() on the missing assembly. Because the code was running in the default AppDomain, it triggered the handler registered by the hosting application since the assembly didn’t exist in the GAC or the application’s bin folder. I then used the SetData() and GetData() methods on the default AppDomain reference to store and retrieve the resulting assembly’s codebase and was then able to load the assembly into the load-from context from the new domain.

The drawback to this approach is that it does still carry with it a minimal potential of loading assemblies into the default domain which would not otherwise have been loaded during the lifetime of the executing process. This would happen if a non-matching assembly was interrogated by the Add-In search process which had a dependency on a shared assembly in one of the special folders provided by the host application, but which would not have otherwise been loaded for some other reason … a rare case in my situation. Overall, this was the most robust solution for my particular needs.
