---
wordpress_id: 583
title: 'Improving the Git Windows experience: Downloads'
date: 2012-02-01T18:22:47+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/02/01/improving-the-git-windows-experience-downloads/
dsq_thread_id:
  - "560528755"
categories:
  - git
  - Mercurial
---
I love Git. It’s very powerful tool that lets me bend my repository to my will, with commands and features that blow the other source control providers I’ve used out of the water.

However, the tooling just doesn’t do it justice. From the download, installation, integration and CLI experience, it always feels like (in Windows land) that you’re playing in someone else’s back yard.

Over the next few posts, I’m going to compare the experience of using Git with that of Mercurial, who has, in my opinion, lesser features, but a much MUCH better experience.

### The Mercurial download experience

Let’s look at searching and downloading the Mercurial client. When I google “Mercurial” or “Mercurial Windows” or “Mercurial Windows Download” or variants, two of the top results are the [official Mercurial home page](http://mercurial.selenic.com/), or the official Windows client, [TortoiseHg](http://tortoisehg.bitbucket.org/).

From there, I want to download Mercurial. Both websites offer very clear ways of doing so. The Mercurial site:

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2012/02/image_thumb.png" width="644" height="231" />](https://lostechies.com/content/jimmybogard/uploads/2012/02/image.png)

And the Tortoise Hg site:

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2012/02/image_thumb1.png" width="644" height="371" />](https://lostechies.com/content/jimmybogard/uploads/2012/02/image1.png)

Two very large “download buttons”. These buttons are interesting in that:

  * They link **directly** to the file to be downloaded. 
      * They both link to the **exact same installer** 
          * They know what OS you’re using, and display the correct installer accordingly</ul> 
        TortoiseHg is the official Hg client for Windows, and includes:
        
          * The command line interface 
              * Windows Explorer integration 
                  * Visual tools (Workbench etc.) 
                      * Visual Studio integration 
                          * Merge tools</ul> 
                        It’s a completely out-of-the box client that includes EVERYTHING that you might need to run Mercurial, all in one package, and consistently presented to the end user.
                        
                        Next, let’s look at the Git download experience.
                        
                        ### The Git download experience
                        
                        When searching for Git downloads, you’re primarily directed to one of two sites – [the official Git site](http://git-scm.com/), or the [official Git tools site for Windows](http://code.google.com/p/msysgit/), hosted on Google Code (and also GitHub, curiously enough). The Git site is clean enough:
                        
                        [<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2012/02/image_thumb2.png" width="644" height="375" />](https://lostechies.com/content/jimmybogard/uploads/2012/02/image2.png)
                        
                        Except I have 3 download links instead of one. Not a big deal most of the time, but already choices are presented to the end user over the Mercurial site. Clicking on the Windows link takes me to this page:
                        
                        [<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2012/02/image_thumb3.png" width="644" height="283" />](https://lostechies.com/content/jimmybogard/uploads/2012/02/image3.png)
                        
                        Instead of linking me directly to the installer file to download immediately, I’m directed to the downloads page of the Google Code site, where I am presented with yet even more options. There is nothing in this screen that screams “THIS IS THE INSTALLER YOU WANT IGNORE THE OTHERS”. As someone new to Git, how do I know which to choose? Probably the first one, and most people would choose the first one, but **presenting choices here is pointless and confusing**.
                        
                        Not to mention, I’m whisked away to a site that has nothing to do with the original Git site. The official Git site didn’t mention “msysgit” but now I’m on the msysgit Google Code site. Even more confusing is that the file has the name “preview” in it, and the installer is labeled as “Beta”. So is the right one or not? I might be inclined to search for the last “good” release and not a beta/preview one.
                        
                        The Git installer is also less featured than the Mercurial one. The official Git Windows tools include:
                        
                          * Windows Explorer integration (very limited) 
                              * A CLI through the Git Bash or directly in a command prompt 
                                  * Visual tools (OK tools)</ul> 
                                However, I typically don’t point folks to the official Git client. Instead, I point them to Git Extensions, a more fully featured toolset that includes:
                                
                                  * Windows Explorer integration 
                                      * Visual Studio integration 
                                          * Richer visual tools 
                                              * Bundled merge tool 
                                                  * Bundled Git installer</ul> 
                                                This isn’t the official Git Windows client, so you basically have to know it exists to find it. Almost none of the online tutorials recommend it, even though it matches much more closely to what Mercurial provides out of the box.
                                                
                                                ### Improving the Git download experience
                                                
                                                In two easy steps:
                                                
                                                  * Have the official Windows client be as full featured as the Hg one. Could just start with Git Extensions and go from there. 
                                                      * Copy the Mercurial website’s behavior</ul> 
                                                    In short, **prefer Simplicity over Choices**. Have defaults, and obvious ways to get to the non-defaults.