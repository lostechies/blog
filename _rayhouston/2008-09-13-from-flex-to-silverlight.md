---
wordpress_id: 23
title: From Flex to Silverlight
date: 2008-09-13T14:52:06+00:00
author: Ray Houston
layout: post
wordpress_guid: /blogs/rhouston/archive/2008/09/13/from-flex-to-silverlight.aspx
categories:
  - Uncategorized
---
A couple of years ago my company started development on a web product that had designs for a very rich user interface. We started out building a AJAX HTML based application and realized very soon that we were having to work really hard to make HTML and CSS do what we wanted it to do and in many cases it just wasn&#8217;t happening.

Our UI designer was doing prototypes in [Flex](http://www.adobe.com/products/flex/) (which I didn&#8217;t know what it was at the time) but his stuff was really cool and we starting talking about it. I was skeptical about Flex at first, but it turned out to be a real platform for developing rich Internet applications. Anyway, to make a very long story short, we chose Flex as the front end of our .NET web application.

In the beginning Flex was cool. It gave us a strongly typed object oriented language (ActionScript 3) and IDE support in Eclipse. We were able to develop some really slick things in a fraction of the effort if we would have done them using DHTML/CSS. It was good, but working in Flex did have its negatives as well. Some of the things that we struggled with were

  * We&#8217;re .NET folks, so there was a learning curve 
      * Extra time in working with two IDE&#8217;s to develop in (Eclipse and Visual Studio for Flex and .NET respectfully) 
          * The IDE plug-in was very buggy 
              * No refactoring support 
                  * No real testing support 
                      * Compiles painfully slow on large projects 
                          * Not a lot of support from Adobe when we would have problems</ul> 
                        I had been keeping my eye on [Silverlight](http://silverlight.net/) waiting to see how it was all going to play out. When the first beta of 2.0 came out, we started looking at it hard. Then in April at [ALT.NET](http://altdotnet.org/) Seattle, I had the opportunity to steal a few moments of [Scott Guthrie&#8217;s](http://weblogs.asp.net/scottgu/) time and ask him about what to expect from Silverlight in the future. The guy&#8217;s enthusiasm about what they were doing completely sold me. We started our Silverlight project that following week and haven&#8217;t looked back.
                        
                        I&#8217;m truly digging Silverlight. It is amazing to be able to write .NET code that runs in the browsers. I even forget that I&#8217;m working in a browser sometimes. There are a few things we miss from Flex, but nothing we couldn&#8217;t create ourselves without too much effort. Some of the things we now get to take advantage of are
                        
                          * All the C# language features 
                              * Passing .NET types to and from the server 
                                  * Reflection 
                                      * Testing Tools 
                                          * We able to use [Resharper](http://www.jetbrains.com/resharper/) (can I get a &#8220;heck yeah&#8221; for this one?) 
                                              * Support of Microsoft</ul> 
                                            That last point is really important. Microsoft made us part of their early adopters program and we so have good channels of communication with the team. We tried to do something like that with Adobe, but I guess we never talked to the right person.
                                            
                                            I think the Silverlight team has done a great job and I&#8217;m looking forward to the future releases.
                                            
                                            <div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
                                              Technorati Tags: <a href="http://technorati.com/tags/Silverlight" rel="tag">Silverlight</a>,<a href="http://technorati.com/tags/.NET" rel="tag">.NET</a>,<a href="http://technorati.com/tags/Flex" rel="tag">Flex</a>
                                            </div>