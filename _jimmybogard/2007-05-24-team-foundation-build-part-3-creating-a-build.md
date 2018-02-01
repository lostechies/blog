---
id: 24
title: 'Team Foundation Build, Part 3: Creating a Build'
date: 2007-05-24T15:31:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/05/24/team-foundation-build-part-3-creating-a-build.aspx
dsq_thread_id:
  - "267857632"
categories:
  - TeamBuild
  - VSTS
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/team-foundation-build-part-3-creating.html)._

In part 1 and 2 of this series, I gave an [overview of Team Foundation Build](http://www.lostechies.com/blogs/jimmy_bogard/archive/2007/05/22/team-foundation-build-part-1.aspx) and discussed [installation and configuration options](http://www.lostechies.com/blogs/jimmy_bogard/archive/2007/05/23/img-border-0-so-now-that-we-have-some.aspx).&nbsp; One thing I should note is that if a team needs to add custom tasks to the build that are in separate assemblies, these assemblies need to be copied to the build machine.&nbsp; That implies that the dev team probably needs administrator access to the build machine.

In VSTS, build definitions are called Build Types, and are created through the Team Explorer.&nbsp; Creating a Build Type is accomplished through a wizard, which will walk you through the steps of defining the build.&nbsp; So what does Team Build provide out of the box?&nbsp; Namely, what are the build steps involved?&nbsp; First, Team Build will:

  * Synchronize with source control 
      * Compile the application 
          * Run unit tests 
              * Perform code analysis 
                  * Release builds on a file server 
                      * Publish build reports</ul> 
                    So out of the box, we don&#8217;t have to worry about configuring source control, compiling, and other common tasks that we would otherwise need to define ourselves.&nbsp; When I launch the New Team Build Type Creation Wizard from Team Explorer, the wizard walks me through the following steps:
                    
                      * Create a new build type 
                          * Select the solutions to build 
                              * Select a configuration and platforms for build 
                                  * Select a build machine and drop location 
                                      * Select build options</ul> 
                                    I&#8217;ll walk through each of these steps one by one.
                                    
                                    ### Step 1: Create a new build type
                                    
                                    In the first screen, you need to specify the name of your Build Type.&nbsp; Unfortunately, all Build Types are grouped in one folder in source control, so we have to use names instead of folders to distinguish different builds.&nbsp; Naming conventions can help that situation, so something like <Application>\_<Version>\_<Region>_<BuildType> would work.&nbsp; In the past, I&#8217;ve defined several builds for the same application, like &#8220;Deploy&#8221;, &#8220;Nightly&#8221;, &#8220;CI&#8221;, etc.&nbsp; Build Type names can be a pain to change, so choose your Build Type names carefully.
                                    
                                    ### Step 2: Select the solutions to build
                                    
                                    Build Type definitions allow you to select one or more Visual Studio solutions to build.&nbsp; In most cases, you would have only one solution to build, but if there are more than one solution to build, you can select multiple and specify the order that each solution will be compiled.&nbsp; If SolutionA depends on SolutionB, just have SolutionB build before SolutionA.
                                    
                                    ### Step 3: Select a configuration and platforms for build
                                    
                                    In this screen, you can specify the project configuration you would like to build with.&nbsp; Typically this could be &#8220;DEBUG&#8221;, &#8220;RELEASE&#8221;, or any custom project configurations you might have.&nbsp; Typically, I might have a separate project configuration like &#8220;AUTOMATEDDEBUG&#8221; that might add code analysis.&nbsp; I usually leave the platform to &#8220;Any CPU&#8221;, but if you have specific platform requirements, this is where you would specify that.
                                    
                                    ### Step 4: Select a build machine and drop location
                                    
                                    When specifying the build machine, Team Build needs two pieces of information:
                                    
                                      * What is the name of the build machine? 
                                          * What directory on the build machine should I build in?</ul> 
                                        The build machine is the machine that has Team Build Service installed on it.&nbsp; The directory can be anything, but keep in mind that you don&#8217;t necessarily want all builds being built in the same directory.&nbsp; Team Build is good about separating builds in the file system, but I&#8217;ve had hard drives fill up when I had too many builds going on the same machine
                                        
                                        The other piece of information in this step is the drop location.&nbsp; When Team Build finishes compiling and testing, it will copy the files to a UNC share you specify here.&nbsp; Don&#8217;t worry, if you need additional files dropped, you can customize this later&nbsp;in the Build Type definition.
                                        
                                        ### Step 5: Select build options
                                        
                                        This step is entirely optional (but strongly recommended).&nbsp; You can specify that you would like this build to run tests and perform code analysis.&nbsp; If you select &#8220;Run test&#8221;, you will need to specify the test metadata file (*.vsmdi) and the test list to run.&nbsp; In my last project, we had over 1300 unit tests when I left, which was absolutely impossible to manage in a test list.&nbsp; We used [custom task](http://blogs.msdn.com/buckh/archive/2006/11/04/how-to-run-tests-without-test-metadata-files-and-test-lists-vsmdi-files.aspx) to specify our tests to run, which would use reflection to load the tests dynamically.
                                        
                                        The other option available is code analysis, which is important for enforcing coding guidelines and standards.&nbsp; Without code analysis turned on, you&#8217;ll probably have a different coding standard for every developer who touched the code.
                                        
                                        ### Step 6: Finish
                                        
                                        When you complete the wizard, two new files are created in source control:
                                        
                                          * TfsBuild.proj &#8211; this is the Build Type definition, where you&#8217;d put any customization 
                                              * WorkspaceMapping.xml &#8211; definition of the source control workspace, where you can change the build directory</ul> 
                                            You can find these files in the source control explorer in $/[Team Project]/TeamBuildType/[Build type name].&nbsp; Manually going through source control is a little bit of a pain if I want to edit the TfsBuild.proj file, so I use&nbsp;[Attrice&#8217;s Team Foundation Sidekick add-in](http://www.attrice.info/cm/tfs/TeamBuildAddin.htm), which lets my right-click and check out and check in directly from Team Explorer.
                                            
                                            So that&#8217;s it!&nbsp; To start a new build just right-click the Build Type in Team Explorer and select &#8220;Build&#8221;.&nbsp; Double-clicking the Build Type will bring up a list of all of the builds with their statuses.&nbsp; This is also where you can view&nbsp;the details of an&nbsp;individual build.
                                            
                                            In the next posts, I&#8217;ll detail some values, principles, and practices when it comes to automated builds, as well as some discussion on customizing and extending a Build Type definition.