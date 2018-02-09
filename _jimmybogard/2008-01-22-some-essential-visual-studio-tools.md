---
wordpress_id: 133
title: Some essential Visual Studio tools
date: 2008-01-22T13:54:11+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/01/22/some-essential-visual-studio-tools.aspx
dsq_thread_id:
  - "264715520"
categories:
  - Tools
redirect_from: "/blogs/jimmy_bogard/archive/2008/01/22/some-essential-visual-studio-tools.aspx/"
---
Visual Studio for me personally is tough to use without some essential tools and add-ins installed.&nbsp; Having recently set up a dev machine, I became keenly aware of the pain of using a clean installation of Visual Studio.&nbsp; So I don&#8217;t forget next time, here are the add-ins I like to use:

  * [ReSharper](http://www.jetbrains.com/resharper/) 
      * [TestDriven.NET](http://www.testdriven.net/) 
          * [CoolCommands](http://download.deklarit.com/files/gmilano/coolcommands40.zip) 
              * [VsCmdShell](http://www.codeplex.com/VSCmdShell) 
                  * [Scott Bellware&#8217;s NUnit Code Snippets](http://specunit-net.googlecode.com/svn/trunk/tools/BellwareNUnit.snippet) 
                      * [Scott Bellware&#8217;s Test Name Macro](http://specunit-net.googlecode.com/svn/trunk/tools/ReplaceSpacesInTestNameWithUnderscores.macro.txt)</ul> 
                    There are plenty of other non-VS tools I use, but these are just to get me started inside Visual Studio.
                    
                    ### ReSharper
                    
                    ReSharper can be described as &#8220;crack for .NET developers&#8221;.&nbsp; Once you try it for a week, it&#8217;s nearly impossible to code without it.&nbsp; It affects productivity drastically, to the point that without it you might as well be coding with both hands tied behind your back.
                    
                    I think [Jeremy](http://codebetter.com/blogs/jeremy.miller/default.aspx) mentioned it somewhere that, he doesn&#8217;t take a .NET presenter seriously if they aren&#8217;t using some refactoring add-on to Visual Studio.&nbsp; Whenever I interact with a new team, it&#8217;s one of the first things I get everyone to install, it&#8217;s that important.
                    
                    ### TestDriven.NET
                    
                    TestDriven.NET is an add-on that makes TDD in Visual Studio a breeze.&nbsp; All I have to do is right-click and select &#8220;Run Test&#8221;:
                    
                     ![](http://grabbagoftimg.s3.amazonaws.com/tools_tdnet.PNG)
                    
                    The menu is context-sensitive, so I can run one test, an entire fixture, or tests in the entire solution.&nbsp; Wherever I click, that&#8217;s the scope to search for tests to run.
                    
                    ### CoolCommands
                    
                    Many times I&#8217;d try to do some operation in Visual Studio only to realize there wasn&#8217;t a menu command to do it.&nbsp; CoolCommands adds those much needed commands, like:
                    
                      * Collapse all projects 
                          * Command prompt here 
                              * Locate in solution explorer</ul> 
                            And several others.&nbsp; I use ReSharper&#8217;s &#8220;[Go to type by name](http://www.jetbrains.com/resharper/features/navigation_search.html#Go_to_Type_by_Name_full)&#8221; feature quite a bit, but many times I need to locate the file in the Solution Explorer.&nbsp; CoolCommands lets me do just that:
                            
                            ![](http://grabbagoftimg.s3.amazonaws.com/tools_cc1.PNG)
                            
                            ![](http://grabbagoftimg.s3.amazonaws.com/tools_cc2.PNG)&nbsp; 
                            
                            The installer is set up to target VS 2005, but [this post](http://geekswithblogs.net/SoftwareDoneRight/archive/2007/12/12/coolcommands-in-visual-studio-2008.aspx) contains instructions for installation on VS 2008 by making a small change to the setup batch script.
                            
                            ### VsCmdShell
                            
                            I&#8217;m a big fan of command-line builds, but sometimes it can get annoying dealing with an extra command prompt window.&nbsp; VsCmdShell puts the Visual Studio Command Shell right inside the IDE:
                            
                             ![](http://grabbagoftimg.s3.amazonaws.com/tools_cmd.PNG)
                            
                            Now I can run my command-line builds directly inside the IDE, making them that much easier to use.
                            
                            ### Scott Bellware&#8217;s TDD code snippets and VS macro
                            
                            ReSharper lets me create code from tests very easily, but what about the tests and specs themselves?&nbsp; Scott (no link anymore) created some VS code snippets and a VS macro to create new tests and name them well.&nbsp; Instead of posting screenshots, it&#8217;s easier if you head over to [JP&#8217;s blog](http://www.jpboodhoo.com/blog/default.aspx) and [check out the video](http://www.jpboodhoo.com/blog/ct.ashx?id=e2d2095b-2c07-411e-8791-a7d62ff3c7e1&url=http%3a%2f%2fwww.jpboodhoo.com%2fblog%2fcontent%2fbinary%2f2007%2fseptember%2f04%2fmacrotoaiddbddtestnamingstyle%2fMacros.html) he created of these add-ins in action.&nbsp; The code snippets and macro have made TDD and BDD about as smooth as it can get in Visual Studio.
                            
                            ### Not an exhaustive list
                            
                            Since my old dev machine is now kaput, I&#8217;m sure there are a few others that I&#8217;m missing.&nbsp; This set of add-ins does get me to a level where I feel that there is very little in the IDE working against me, which is always a good thing.