---
wordpress_id: 64
title: New favorite deployment method
date: 2007-09-21T20:50:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/09/21/new-favorite-deployment-method.aspx
dsq_thread_id:
  - "267286118"
categories:
  - Tools
redirect_from: "/blogs/jimmy_bogard/archive/2007/09/21/new-favorite-deployment-method.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/09/new-favorite-deployment-method.html)._

Having run into so many crazy errors from installing MSI&#8217;s, I&#8217;ve settled on a new favorite deployment mechanism: NAnt (or MSBuild).&nbsp; Here&#8217;s how it works:

  * Package application and build scripts into one ZIP file 
      * Package any tools needed for the build (NAnt, NUnit, etc.) 
          * Package a bootstrapper batch file that calls NAnt and your build file with the appropriate targets 
              * Run the batch file</ul> 
            Pros
            
              * Install script can be the same script as run on a local dev box 
                  * Can package NAnt along with application, so no need to install any tools on their machine 
                      * More robust than XCopy deployment 
                          * Far fewer headaches than with MSI deployment 
                              * No need for proprietary scripting languages to do complex work, instead use open-source, standard tasks 
                                  * No more Wise script or InstallScript</ul> 
                            Cons
                            
                              * Not for commercial products 
                                  * MSI&#8217;s do take care of a lot of boilerplate tasks 
                                      * MSI&#8217;s have rollback and uninstall built in 
                                          * Though with custom actions, still a pain
                                          * Nice UI 
                                              * Familiar interface</ul> 
                                            Here&#8217;s what my final ZIP file looks like:
                                            
                                              * Product-Dist.zip 
                                                  * Product.zip (zipped up application) 
                                                      * Tools 
                                                          * NAnt 
                                                              * NUnit</ul> 
                                                              * install.build 
                                                                  * Install.bat 
                                                                      * Uninstall.bat 
                                                                          * Go.bat</ul> </ul> 
                                                                    What&#8217;s really cool is that the structure of the distribution zip file matches my local structure, so installing locally is the exact same as installing on a clean box.&nbsp; Also, I can deploy NUnit and the tests, so I can run tests on deployed machines for some extra build verification.