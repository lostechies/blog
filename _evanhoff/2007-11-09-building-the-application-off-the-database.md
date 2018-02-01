---
id: 23
title: Building the Application off the Database
date: 2007-11-09T21:53:02+00:00
author: Evan Hoff
layout: post
guid: /blogs/evan_hoff/archive/2007/11/09/building-the-application-off-the-database.aspx
categories:
  - Uncategorized
---
</p> 

> A couple things are bothering me this morning. I had a potential&nbsp;client asking me about IdeaBlade from DevForce as a possible application framework. I looked at their developer&#8217;s guide for about 15 minutes and it was enough for me to go thumbs emphatically down. 
> 
> Specifically, I wouldn&#8217;t want to touch it because it: 
> 
> * Creates the &#8220;Domain Model&#8221; directly from the database with a designer&nbsp;tool. I&#8217;ve always detested this model. I think it forces or at least&nbsp;tempts you into BDUF. Incremental changes are clumsy when you have to&nbsp;fire up the designer GUI instead of just making a code change. It&#8217;s&nbsp;easier to do evolutionary design with POCO&#8217;s than it is to constantly&nbsp;morph the database and regenerate. Lastly, for anything remotely&nbsp;complex I almost always find a reason to make the Domain Model&nbsp;structure deviate from the physical database structure. Locking the two&nbsp;things together almost always lead to one model or the other sucking. 

**There can really only be 1 true model.** It either exists in the database or in the application. If you generate off the data model, it is the one true model. I have yet to see an implementation that will roundtrip between the two&#8211;ie..generate off the data model but then update the data model off app changes. Without roundtrips, it just reinforces the &#8220;one true model&#8221; stigma. 

You can see the same problem with code generation. If the code generation doesn&#8217;t support roundtripping, the templates basically have to become the &#8220;one true source&#8221; that you work with and around (partial classes, etc). They become the central driving concept in development. 

My personal opinion is that **you are better off realizing what the one true model is and not fighting the current**. That&#8217;s also why I really don&#8217;t enjoy generating the app off the database. I much prefer making POCOs the one true model. 

In the &#8220;one true model&#8221;, **you do have to make compromises so that you don&#8217;t trash the other model all to hell**, but that&#8217;s about the best I&#8217;ve found you can do. After you learn one modelling paradigm (or both) really well, the incompatibilities really start to show. 

In short, I agree with you&#8211;although it&#8217;s not an argument of BDUF to me. It&#8217;s an argument of how I choose to work and where I find the most power lies (for tackling complexity with the least amount of effort and greatest robustness/agility to change). 

This argument also has built in assumptions though. I&#8217;m assuming there is complexity or a high rate of change. If an app invalidates those assumptions, my argument has no wind (and I would reevaluate my tooling). For example, without complexity (Forms over data), the two models can basically be mirror images. 

> I want to say that this type of &#8220;spit out an application&#8221; to match the&nbsp;database is only useful for simple CRUD apps, and not very many systems&nbsp;really fit that description. 

Agreed, unless the developer is more DBA than programmer. 😉 

> * It&#8217;s an ActiveRecord approach and that still bugs me to have data&nbsp;access stuff jumbled up in my Domain Model. I know that argument never&nbsp;dies, but is it really that hard to use NHibernate like ORM&#8217;s with a&nbsp;Unit of Work? 

No. It&#8217;s not. (Oops. Was that rhetorical?) 

> * Mobile Objects: I bump into this from time to time. The idea that&nbsp;systems are easier to build if the same set of domain objects can run&nbsp;on both client and server. It saves duplication on validation and&nbsp;that&#8217;s cool, but the idea of running the same domain model on both&nbsp;client and server smacks of very tight coupling to me. This DevForce&nbsp;thing, Astoria, CSLA.Net and whatnot just smell wrong. I say that the&nbsp;domain model should follow from behavior, not data structure, and the&nbsp;behavior could easily be different from client to server side. When&nbsp;I&#8217;ve seen CSLA stuff running on the server side the code looks way too&nbsp;busy because of all the extra StartEdit() blah, blah stuff that&#8217;s there&nbsp;for running on the client side. 

I&#8217;ll defer to Fowler on this one. To quote him: 

Fowler&#8217;s First Law of Distributed Object Design:   
Don&#8217;t distribute your objects! 

Or to pull a more choice quote, &#8220;this design sucks like an inverted hurricane&#8221;.   
<http://www.ddj.com/architect/184414966> 

> I&#8217;m not a big SOA fan, but having some loose coupling between a desktop&nbsp;client and the backing services is just plain good fundamental design. 

Screw SOA. It&#8217;s just good design. 

> What do you guys think? Am I being too harsh, or not being open&nbsp;minded? I really don&#8217;t want anything to do with this kind of solution&nbsp;but you never know&#8230; 

**You don&#8217;t have to give yourself a lobotomy to be open-minded.** 

Why are they picking this tool in the first place? Does it give them a strategic advantage over their competitors? If there&#8217;s no business reason, they should be having a conversation with you (the expert) on what you know works (and what you know can be effective when building the app). If that&#8217;s the case, **tell them to put the shiny thing back&nbsp;in the store window where it belongs**.