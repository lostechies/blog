---
wordpress_id: 4323
title: On Comparing Current Tools to Futureware
date: 2008-05-20T03:55:13+00:00
author: Evan Hoff
layout: post
wordpress_guid: /blogs/evan_hoff/archive/2008/05/19/on-comparing-current-tools-to-futureware.aspx
categories:
  - Uncategorized
---
I&#8217;m going to take a quote from <a href="http://blogs.msdn.com/dsimmons/" target="_blank">Daniel Simmons</a> on [why we should use the Entity Framework](http://blogs.msdn.com/dsimmons/archive/2008/05/17/why-use-the-entity-framework.aspx).

I&#8217;m not specifically interested in his comparison with NHibernate because I think the following is true of many current O/RMs (whatever your personal flavor happens to be).&nbsp; I am, however,&nbsp;going to quote it because it caught my attention.

> The big difference between the EF and nHibernate is around the Entity Data Model (EDM) and the **long-term vision** for the data platform we are building around it.

The biggest problem with comparisons like this is that you can&#8217;t compare unwritten software with something that&#8217;s already in production today.&nbsp; The false assumption underlying this is that the current breed of O/RMs will stand still while Microsoft magically comes from behind to deliver an innovative platform.&nbsp; It just doesn&#8217;t happen like that.

So how does the EF differentiate from the current breed of O/RMs?&nbsp; Apparently, it doesn&#8217;t.&nbsp; That&#8217;s slated for the next version.

Here are a few other reactions that I agree with, that hit my RSS reader today:

  * <a href="http://weblogs.asp.net/fbouma/archive/2008/05/19/why-use-the-entity-framework-yeah-why-exactly.aspx" target="_blank">Why use the Entity Framework? Yeah, why exactly?</a> 
      * <a href="http://codebetter.com/blogs/jeremy.miller/archive/2008/05/19/what-dan-simmons-forgot-to-tell-you-about-the-entity-framework.aspx" target="_blank">Reaction from Jeremy Miller</a> 
          * <a href="http://devlicio.us/blogs/rob_eisenberg/archive/2008/05/18/why-ef.aspx" target="_blank">Why EF?</a> 
              * <a href="http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/05/19/more-entity-framework-thoughts.aspx" target="_blank">More Entity Framework Thoughts</a> 
                  * <a href="http://codebetter.com/blogs/gregyoung/archive/2008/05/19/ef-long-term-plans.aspx" target="_blank">EF Long Term Plans</a> 
                      * <a href="http://codebetter.com/blogs/david_laribee/archive/2008/05/19/entity-framework-our-albatross.aspx" target="_blank">Entity Framework: Our Albatross</a> 
                          * [Rewriting the Entity Framework Source Control Support](http://www.ayende.com/Blog/archive/2008/05/19/Reviewing-the-Entity-Framework-Source-Control-Support.aspx) </ul> 
                        In short, the Entity Framework is a 1.0 release.&nbsp; Expect from that what you will.
                        
                        Let&#8217;s just hope that the next version (or two) will hit somewhere near the mark&#8211;although I do have really big concerns about some of the design decisions they are pushing (such as reusing the models all over the place).&nbsp; It sounds like an expensive and delicate design to maintain.&nbsp; Smearing any kind of structure or model (data, object, or conceptual) makes change to that model&nbsp;quite a bit more expensive.
                        
                        That is, in fact, software design 101.&nbsp; David Parnas was <a href="http://www.idemployee.id.tue.nl/g.w.m.rauterberg/presentations/parnas-1972.pdf" target="_blank">writing about it</a> all the way back in 1972.
                        
                        > Long-term we are working to build EDM awareness into a variety of other Microsoft products so that if you have an Entity Data Model, you should be able to **automatically create REST-oriented web services over that model** (ADO.Net Data Services aka Astoria), write reports against that model (Reporting Services), synchronize data between a server and an offline client store where the data is moved atomically as entities even if those entities draw from multiple database tables on the server, create workflows from entity-aware building blocks, etc. etc
                        
                        While it often seems like a good idea to expose things like entities to the outside world (it&#8217;s reuse, right?).&nbsp; The illusion quickly gets shattered when you start looking at how things will change in the future.&nbsp; Sharing data models usually means spreading the associated logic around.&nbsp; Spreading logic around means duplication.&nbsp; Duplication is costly to maintain.&nbsp; It also has very real coupling issues.&nbsp; 
                        
                        Also, if adding a new field to the Customer entity requires many changes (both in your app and in your consumer&#8217;s apps), you&#8217;ve done a piss poor job of design (think: sharing internal models across service boundaries).
                        
                        But not only that, but I find that this type of thinking leads <a href="http://msdn.microsoft.com/en-us/library/ms978509.aspx" target="_blank">straight into CRUD</a>.
                        
                        I&#8217;m going to stop here&nbsp;because I&#8217;m quickly winding my way into a design death spiral.&nbsp; And I think you get my point.