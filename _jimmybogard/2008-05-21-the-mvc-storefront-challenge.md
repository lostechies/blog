---
id: 187
title: The MVC Storefront Challenge!
date: 2008-05-21T03:25:44+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/05/20/the-mvc-storefront-challenge.aspx
dsq_thread_id:
  - "264715739"
categories:
  - ASPNETMVC
  - DomainDrivenDesign
  - LINQ2SQL
---
In [Rob Conery&#8217;s](http://blog.wekeroad.com/) [recent post](http://blog.wekeroad.com/mvc-storefront/mvc-store-intermission2-over/) on the MVC Storefront example he&#8217;s been working on, he got some comment to basically toss out Linq2SQL and use NHibernate instead.

Blah.

How about the community does it instead?&nbsp; I&#8217;m not looking for an us vs. them or Linq2SQL vs. NHibernate battle, more of an intellectual experiment where we have two identical apps, built on two different ORM platforms.&nbsp; The goal would be to highlight NHibernate&#8217;s strengths and weaknesses, as well as Linq2SQL&#8217;s strengths and weaknesses through a comparison of the resulting architecture and design.

Personally, I&#8217;d like to start this one out by forking the original code and pairing with someone live.&nbsp; Maybe it can become a reference NHibernate/DDD app?&nbsp; Or maybe it will expose the naked truths of my complete lack of coding skills?&nbsp; Probably the latter.

The general idea would be to start with the use cases laid out in the screens, and go backwards from that.&nbsp; Many of the entities would probably remain the same, but the aggregates/roots/repositories would have a distinctly different feel.&nbsp; All driven from TDD of course.

As I noted earlier, I&#8217;d want this driven live pairing, so either in person (I&#8217;m in Austin, TX) or Skype-VNC sessions (if I can figure that stuff out).&nbsp; Some ground rules are:

  * All code is put in TDD 
      * Ping-pong style pairing prevents me from getting \*too\* plastered 
          * Follow DDD concepts, entities, value objects, repositories, blah blah blah 
              * Don&#8217;t knock me for subtly introducing my hilarious ultra-right-wing ideals as variable names (string NRA4EVER = &#8220;cold, dead hands&#8221;;)</ul> 
            If you&#8217;re interested, drop me a line here.&nbsp; WARNING: Dropping a line constitutes a binding legal contract and will result in a ninja squad administering an Evans and Beck tattoo on your knuckles in the dead of night.
            
            It should be a lot of fun, or a complete disaster, one of the two.&nbsp; But fun either way.