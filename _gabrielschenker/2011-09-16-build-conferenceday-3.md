---
wordpress_id: 70
title: BUILD conference–day 3
date: 2011-09-16T09:58:27+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/2011/09/16/build-conferenceday-3/
dsq_thread_id:
  - "416599564"
categories:
  - BUILD
  - Conference
  - Windows
---
## The future of C#

Yesterday Anders Hejlsberg gave a talk about future directions of C# and VB.Net. He started with look back and then immediately dive into the new features of C# 5.0 which is part of VS 2011 and .NET 4.5. The most prominent new feature is of course the direct language support for asynchronous programming. The compiler provides two new keywords **async** and **await** which doesn’t sound exciting at all but in reality dramatically simplifies the way we developers can write “fast and fluid” code. Instead of dealing with threads, thread synchronization and callback functions ourselves we can now write fully asynchronous code in a sequential way. The compiler will do the heavy lifting for us and convert this “sequential and seemingly synchronous” code into a sequence of asynchronous calls and their corresponding continuations.

If you think that this is not worth talking about then try to write a sequence of asynchronous calls that depend on each other. And make sure that you provide adequate exception handling.

During his presentation Anders Hejlsberg also revealed some details about the future version of C# and he announced that a first developer preview will be available in about 4 weeks. The main part of the upcoming version of C# is a completely new compiler which is written in C# and can be used as a service. The project has the code name Rosalyn.

This “compiler as a service” will be of tremendous value for various scenarios. All kinds of tools, utilities or plugins will be able the leverage the compilers capabilities to their favor. Some samples are

  * Intellisense, code coloring will leverage the output of the parser part of the compiler 
      * Refactoring tools like Resharper do not have to provide their own parser any more and can leverage the compiler 
          * Compile and execute scripts or code snippets (provided e.g. as string) on the fly 
              * Future versions of Visual Studio will leverage the compiler and provide an interactive console for C# 
                  * Automatically translating code from one language to another; Anders demoed the translation from C# to VB.NET and vice versa 
                      * Meta programming a la Boo or Ruby will be possible 
                          * etc.</ul> 
                        I think this new compiler will once again dramatically improve the development experience with C# (and VB.NET). 
                        
                        ## The new XAML editor in VS 2011
                        
                        If you have worked with WPF or Silverlight in Visual Studio 2010 or 2008 you know that the XAML editor was extremely slow and limited in its functionality. Now that has changed dramatically in VS 2011. First of all the new XAML editor is backed by the same engine (or at least part of it) as Expression Blend. The editor now runs in its own process to not compromise the stability and availability of VS. The editing capabilities have tremendously improved and members of the VS team&nbsp; confirmed me that they are tuning the editor as much as possible and make it performing well also in very large project with many assets.
                        
                        ## Expression Blend for HTML5/CSS applications
                        
                        Expression Blend is now available in a new flavor. HTML5/CSS3 based Metro style applications can now be visually designed in Blend. Many of the new CSS3 features are fully supported by this new editor. Not only is Expression Blend a layout tool but it fully supports the interactive mode (that is JavaScript is executed) which is very important in scenarios where most of the page is rendered dynamically, driven by JavaScript.