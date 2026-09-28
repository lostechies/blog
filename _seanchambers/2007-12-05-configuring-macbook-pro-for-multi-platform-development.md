---
wordpress_id: 3155
title: Configuring MacBook Pro for multi-platform development
date: 2007-12-05T16:03:04+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2007/12/05/configuring-macbook-pro-for-multi-platform-development.aspx
dsq_thread_id:
  - "271235344"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2007/12/05/configuring-macbook-pro-for-multi-platform-development.aspx/"
---
I received a MacBook Pro yesterday from my boss. He purchased a new one and I got his old one. I was ecstatic. The memory and small screen/keyboard was really holding me back on my MacBook. With the larger display (15&#8243;) and large keyboard I have already found that the MBP is much easier to use then a MB. Couple that with the fact that it is actually lighter than a MB, I&#8217;m sold.

This is just a little log of the steps I went through to setup my MBP with a RoR development environment and a VMWare Fusion Bootcamp Partition for Visual Studio and any other supporting apps I need that is still in Windows.

Here&#8217;s a list of things that I installed for both OS&#8217;s

Apple

  * Ruby on Rails Environment already installed on Leopard! 
      * TextMate 
          * FireFox with FireBug (definately a must) 
              * Freemind (Mind mapping software for notes and brainstorming) 
                  * Cord (Remote Desktop software) 
                      * Colloquy (IRC channel so I can hang out in #alt.net on freenode) 
                          * svnX (svn is installed on leopard by default, but I like having a GUI sometimes) 
                              * Mac OSX Software Updates (to get Boot Camp)</ul> 
                            Windows
                            
                              * Windows Updates (like 36 of em) 
                                  * Visual Studio 2005 
                                      * VisualSVN 
                                          * ReSharper for Visual Studio 
                                              * TortoiseSVN 
                                                  * SQL Server Management Studio 
                                                      * Windows Live Writer</ul> 
                                                    When setting up the development environment on the Apple I was going to install MySQL to use for RoR development but after some searching I found out that MySQL has not yet released an install for MySQL on Leopard yet. This didn&#8217;t matter though because RoR uses Sqlite by default.
                                                    
                                                    So the first step was to transfer files from my old macbook to my new MBP. If you are migrating from an old mac and have the benefit of coming from leopard then the easiest path would be to perform a backup to an external hdd and then use migration assistant to restore to your new macbook with time machine. In my instance I didn&#8217;t have enough data to justify this so I simply just backed everything up to dvd and popped it in my new macbook pro.
                                                    
                                                    Next task was to get Bootcamp installed. A couple of coworkers and myself experimented with VMWare Fusion in a couple of different configurations in the past and the best performance is to install windows on a bootcamp partition and then run the bootcamp partition within vmware. I created a 15gb partition and I was off.
                                                    
                                                    After installed Bootcamp and Windows XP, I then rebooted into Leopard and installed VMWare Fusion. When fusion was finished installing the Bootcamp Partition will automatically show up under the list of available virtual machines too boot from.
                                                    
                                                    The rest is pretty much self explanatory. Enjoy!