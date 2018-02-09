---
wordpress_id: 3158
title: Choosing a JavaScript Framework
date: 2007-12-16T13:39:57+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2007/12/16/choosing-a-javascript-framework.aspx
dsq_thread_id:
  - "268123756"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2007/12/16/choosing-a-javascript-framework.aspx/"
---
Before I dive into details of details I found in each framework I think it would be best to highlight features of each framework. In case you&#8217;ve been living under a rock, a javascript framework makes it easier for you to write complex javascript code. Almost all of them provide an effects framework for snazzy visual effects along with AJAX support for making remote updates/calls to your server. When writing any javascript in this day and age it is almost a requirement to have one of these handy frameworks in your toolkit.&nbsp;Like any new technology, many different variables are taken into account when making a decision. I will try to highlight as many of these variables in this posting.

&#8211; jQuery : [http://jquery.com/](http://jquery.com/ "http://jquery.com/")

  * supports method chaining 
      * basic methods for dom traversal, find(), gt(), lt(), next(), parent(), siblings()&nbsp;etc.. 
          * excellent&nbsp;documentation 
              * limited examples 
                  * has effects built in 
                      * very easy to use and get started&nbsp; 
                          * size at ~20kb</ul> </ul> 
                        &#8211; Prototype/Scriptaculous : [http://www.prototypejs.org/](http://www.prototypejs.org/ "http://www.prototypejs.org/")
                        
                          * supports method chaining 
                              * poor documentation besides API docs 
                                  * hardly any examples 
                                      * effects are accomplished via scriptaculous 
                                          * scriptaculous about 30kb 
                                              * size about 15kb</ul> </ul> 
                                            &#8211; Yahoo! User Interface : [http://developer.yahoo.com/yui/](http://developer.yahoo.com/yui/ "http://developer.yahoo.com/yui/")
                                            
                                              * uses namespaces to accomplish tasks. i.e. YAHOO.util.DOM, YAHOO.util.Effects 
                                                  * utils seperated out into files to load only what you need 
                                                      * backed by a large corporation 
                                                          * excellent documentation (almost too much) 
                                                              * good support for modern browsers 
                                                                  * extremely small footprint when compressed (3kb per feature) (about 20kb for everything)</ul> </ul> 
                                                                MooTools/MooEffects : [http://mootools.net/](http://mootools.net/ "http://mootools.net/")
                                                                
                                                                  * API Documentation 
                                                                      * Limited examples 
                                                                          * size&nbsp;at&nbsp;20kb</ul> </ul> 
                                                                        &nbsp;
                                                                        
                                                                        The frameworks that I specifically looked at were Prototype/Scriptaculous, jQuery and YUI. I have used MooTools in the past but not recently. I played briefly with some other frameworks such as dojo toolkit. I just didn&#8217;t have enough time to download and play with all the frameworks as each has it&#8217;s own learning curve that is usually pretty steep. I would have liked to review them all but this was not possible.
                                                                        
                                                                        The first thing in the whole scenario is to decide what is most important to you from the framework. Is it file size of the framework? Support for different types of browsers? Documentation and Samples? For instance, if I were building an application that will only be used internally in my organization by a specific browser (IE7) then I would probably want to use the framework with the best support for IE7. If it is a widely used application across all browsers then perhaps speed and file size would be more important.
                                                                        
                                                                        As far as support for modern browsers go when testing Firefox/Safari 3 and IE 7, the differences are negligible. Almost all the major javascript frameworks have good support for the 3 major browsers. If you need to support other more exotic browsers then you would have to choose the framework more wisely.
                                                                        
                                                                        When I chose a framework for a recent set of projects the most important thing to me was the amount of documentation. Everything else was taken into account but documentation would allow me to learn the framework quickly and easily. YUI was clearly the framework that had to most massive amount of documentation. With step by step instructions on how to setup each effect/feature from the javascript include all the way up to the actual js code. YUI almost has TOO much documentation as when you start reading through the docs they throw so many documentation sources at you that your head spins. All in all, YUI had the best documentation with jQuery next and prototype last.
                                                                        
                                                                        The next thing I took into account was how efficient each framework was as far as code goes. I made a sample of a javascript that captures a link click, traverses the dom to find the parent element with a specific class name, slides down that div and makes an AJAX call which updates another div. jQuery was clearly the winner here. Although jQuery code is more cryptic and harder to read, it is extremely efficient. It took about 50 lines of code to accomplish this in prototype versus only 25 lines in jQuery. I was amazed at this and it definitely warmed be up more to jQuery. Particularly in the AJAX calls. Prototype and other frameworks require a pretty verbose function to make an ajax call. You can shorten it but it is much more verbose then it needs to be. jQuery accomplishes an ajax update by simply calling mydiv.load(). This was very neat as this is the most common ajax call that I use. One thing I did have a problem with was using $.ajax calls with Castle MonoRail. NVelocity interpets $. as a variable and thus removes it from the output. To work around this you just need to set a literal in nvelocity like so: #set($ajax = &#8220;$.&#8221;), then you can use $ajax in your js code and it will be replaced with the proper jquery string at runtime.
                                                                        
                                                                        Another thing to take into account is groups/irc channels that support these frameworks. All the major ones have irc channels on irc.freenode.net and every framework has a Yahoo/Google group for the corresponding framework. These are good avenues to ask for help once you can&#8217;t get something to work correctly and are stumped.
                                                                        
                                                                        All in all, I will be moving forward with jQuery as it just felt natural once I picked it up and started running with it. I ran into less problems and accomplished more tasks faster then I could with the other frameworks. YMMV depending on your requirements. Hopefully this will help a couple of people out that head down the same path that I have traveled down in the last couple of weeks!