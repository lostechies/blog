---
wordpress_id: 74
title: ALT.NET Impressions
date: 2007-10-08T19:22:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/10/08/alt-net-impressions.aspx
dsq_thread_id:
  - "513173329"
categories:
  - altnetconf
redirect_from: "/blogs/jimmy_bogard/archive/2007/10/08/alt-net-impressions.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/10/altnet-impressions.html)._

The [ALT.NET Conference](http://altnetconf.com/)&nbsp;is over, and I&#8217;m exhausted.&nbsp; I&#8217;ve never been to a conference that consistently challenged my assumptions about software development.&nbsp; The amount of dialogue and debate that occurred was quite staggering, considering that most involved were birds of a feather, and the possibility of echo-chamber issues would seem to be fairly high.

### Open Space Format &#8211; Day 1

The conference was run in an [Open Space](http://www.openspaceworld.org/) format, which I&#8217;ve never been involved with before.&nbsp; No agenda was set before the first day, and no one was obligated to stay for an entire discussion.&nbsp; The conference started with a few ground rules and an explanation into Open Spaces, along with a short roundtable about the direction and purpose of the ALT.NET&nbsp;conference.

Between five and seven chairs were placed in the middle of the room.&nbsp; If you wanted to address the audience, you got up, sat in the chair, and said your piece.&nbsp; If you sat in the last available chair, someone else in the panel sat down.&nbsp; One chair was always available for someone to claim, and no one could talk in the audience.&nbsp; This provided a great continuous discussion for which anyone in the room could participate.&nbsp; Great questions and discussions centered around &#8220;What is ALT.NET?&#8221;, &#8220;Is ALT.NET divisive?&#8221;, &#8220;Is ALT.NET negative?&#8221;, and many others.

After this initial dialog, we proceeded to create the agenda.&nbsp; Those who wanted to talk about something wrote it down on one of the many post-it note pads scattered around the room, walking to the center of the room, and telling everyone what they wanted to convene about.&nbsp; Then they would put their post-it on an open space in the schedule at the front of the room.&nbsp; A long line formed for those proposing discussions next, and each put their post-its in an open slot in the schedule.&nbsp; When the spaces were filled, these post-its were put below where they could be sorted later.&nbsp; After all those that wanted to convene a discussion were through, all audience members were invited up to the schedule to initial post-it notes they found interesting.&nbsp; There around 6 or so rooms to convene discussions during each session, and all were filled by the end of the night.

Quite frankly, it was a astonishing that we went from no agenda to a very compelling one in about an hour with little or no planning or contention.&nbsp; But then again, this was my first Open Space conference.

### Day 2

The next morning, the schedule had gone through an iteration where many topics were consolidated, some were moved and&nbsp;some were removed based on the voting the previous night.&nbsp; Scott Guthrie&#8217;s MVC presentation was pushed back to accommodate the most audience members.&nbsp; No one needed to commit to any one topic per session, as they could use their own two feet to go to a different discussion.

#### First Session &#8211; Spreading passion and DSL&#8217;s

During the first session, I mostly attended a discussion concerning the problems of spreading passion and learning throughout the organization.&nbsp; Jean-Paul had some insight on inspiring passion, while Scott Hanselman mostly talked about making ALT.NET tools accessible.&nbsp; Dave Laribee talked about the importance of instilling values, but there was still a lot of negative vibes around&nbsp;the&nbsp;Morts.&nbsp; Mort&#8217;s shouldn&#8217;t be shunned or disdained, they should be embraced and included.&nbsp; The rest of the discussion concerned how to include Mort in the ALT.NET community.

Next, I headed to the DSL conversation that had folks like Martin Fowler, Scott Guthrie, Jeremy Miller and others.&nbsp; I only caught the tail end of the conversation, but Martin talked a little bit about the difficulties of fluent interfaces, the reasons behind them (no one knows yacc), and Scott mentioned that debugger visualizers can work around many of the pains of fluent interfaces.&nbsp; Fluent interfaces (as I ran into with NBehave) run into the issue where a continuous chain of method calls, no matter how you format it in the code, still turns into one line of executing code.&nbsp; If something fails and throws an exception, you don&#8217;t know what line it happens at and you can&#8217;t step into a specific method call.&nbsp; You have to step in and out of each fluent interface method call to get to whatever problem you have somewhere down the chain.

Martin again pointed out that this wouldn&#8217;t really be an issue if we just used true external DSLs and used tools like yacc or Boo to create them.&nbsp; Once you do that, however, you do lose much of the debugging support from Visual Studio.

#### Second Session &#8211; Intro to Boo and the BDD gauntlet

I hadn&#8217;t used a lot of Boo, and was very interested in the parsing and extension platform Boo provides.&nbsp; I&#8217;ve seen some work done on a Boo build system (BooBS, and don&#8217;t search for that one).&nbsp; That looked very intriguing to get rid a lot of the executable XML we have around in NAnt, MSBuild, XAML, Spring, and so on.&nbsp; Unfortunately, the discussion mostly covered the language features of Boo and not some of the more interesting core features of the Boo compiler, so I moved on to another session.

One of the newer topics in our space was BDD, which Scott Bellware convened a session on.&nbsp; However, when I walked into the room (with about 80 or so people in it), I saw Joe Ocampo in the center of the room and NBehave story definitions up on the projectors.&nbsp; Joe was taking a lot of heat from those in the audience questioning whether stories were BDD, whether executable stories were a good idea, and so on.&nbsp; I felt pretty rotten about the situation, as I was not around to help Joe explain our goals with NBehave.&nbsp; But I bought him a couple of beers that night, so I guess it evened out.&nbsp; I understand and even embrace Scott&#8217;s (Bellware) concerns that executable stories can hamper the conversation that a story is supposed to represent.&nbsp; But Hanselman came to the rescue to explain to Scott that these types of requirements and traceability&nbsp;are critical to many people, and those concerns shouldn&#8217;t be dismissed out of hand.&nbsp; Personally, I think if NBehave doesn&#8217;t provide value, it doesn&#8217;t have a reason to exist.&nbsp; However, what&#8217;s valuable varies widely from team to team.

I would have rather this discussion concern BDD than NBehave, since BDD is a new an interesting topic that isn&#8217;t widely understood.

Again, sorry Joe, my bad!

#### Third Session &#8211; Scott Guthrie is&nbsp;an MVC&nbsp;ninja

The third session mostly consisted of Scott&#8217;s presentation on a new MVC framework in development at Microsoft, due to be released as a beta in the next couple of weeks.&nbsp; Much has already been discussed about the specific architecture, so I won&#8217;t go into that.&nbsp; My specific impressions were:

  * I&#8217;ve never EVER heard &#8220;Rhino Mocks&#8221;, &#8220;StructureMap&#8221;, &#8220;NUnit&#8221;, &#8220;Spring&#8221;, or any other major OSS tool that the community uses mentioned in a presentation about MS technology.
  * I&#8217;ve never **EVER** seen an MS presentation actually USE one of these tools.&nbsp; Scott used NUnit to write tests for the controller before he ever created the view, which made me shed a single tear.
  * The first points always brought up were support for swappable, testable, mockable architectures, which the new MVC framework supports inside an out.&nbsp; There wasn&#8217;t a scenario that was brought up that wasn&#8217;t already available.
  * **For the first time in .NET, it seemed that MS listened, engaged, and adapted to feedback from the community to influence its decisions and core architecture of the framework.&nbsp; Testability, mockability, and embracing other&nbsp;OSS alternatives were first-class citizens in this brave new paradigm.&nbsp; Bravo!**

#### Fourth session &#8211; Hanselman knows IronPython (kinda) plus some DDD-jitsu

The next session mostly consisted of Scott Hanselman showing IronPython and IronRuby&nbsp;running on the MVC framework.&nbsp; Questions kept coming up about &#8220;will MS run RoR?&#8221;, but the answer was always &#8220;if the community wants that, they can do it, the tools are there.&#8221;&nbsp; Scott showed IronRuby on ASP.NET MVC, not RoR &#8230; on&nbsp;CLR &#8230; on&nbsp;IIS.&nbsp; It was all very interesting how he was able to get IronPython running on the MVC framework, and he showed us that it didn&#8217;t really take that much to get it up and running.&nbsp; Most of the talk was about the differences between the dynamic type model of the DLR and the static Type object of the CLR, and how to resolve the two.&nbsp; In the MVC framework, you specify that &#8220;I want to execute this view of&nbsp;Floogle type&#8221;, but Floogle type doesn&#8217;t exist yet since it&#8217;s a dynamic type.

I popped into a talk about MbUnit and xUnit.NET, got bored, and checked out another on DDD-jitsu.&nbsp; The DDD talk was interesting, as the core concepts were laid out and much discussion talked about how to introduce and implement these ideas.&nbsp; Dave Laribee stressed the importance of the later chapters talking about large-scale structures and&nbsp;bounded contexts.&nbsp; This pretty much ended the day

#### Later activities &#8211; Hanselman is a rock-jockey

I went to dinner at Chuy&#8217;s (love that Tex-Mex)&nbsp;with about 20 folks including Jeffrey Palermo, Martin Fowler, Scott Guthrie, Scott Hanselman, about 10 other people.&nbsp; It was rather strange to eat next to the voice of Hanselminutes, which I&#8217;ve listened to for so long.&nbsp; Scott Hanselman gave me a great tip on mapping directories to shares, to make my life easier with Windows Home Server.&nbsp; Scott doesn&#8217;t seem to like cats too much either&#8230;&nbsp; I also realized how much diabetes can affect someone&#8217;s daily life as Scott had to stop what he was doing and self-administer an insulin injection at the end of the meal.&nbsp; That was a good time for Scott to mention his [Diabetes Walk 2007](http://www.hanselman.com/blog/TeamHanselmanAndDiabetesWalk2007.aspx).&nbsp; It was amazing to me that Scott can be as successful as he is, even though this disease consumes so much of his daily life.

After dinner, most of the group headed to Main Event, which is similar to Dave and Busters or Jillian&#8217;s.&nbsp; Main Event has rock climbing, which all of us were eager to prove our mettle on.&nbsp; It was cool to see Scott Hanselman coach several of us up an intermediate course and ring the bell at the top.&nbsp; What was even weirder was it was only Scott&#8217;s first or second time to try rock climbing, and he was a complete natural.&nbsp; The rest of the night was spent at the pool tables with a few beers and a lot of great conversation.

It was a very long day, compounded with the fact that most of it was spent learning, debating, absorbing, arguing, and just trying to keep up.&nbsp; It proved very hard to sleep with so many conversations still buzzing around my head.

### Day 3

The final day started with some breakfast and a meeting outside to remind us all of the rules.&nbsp; Outside was a good idea, because no one looked very alert.

#### First Session&nbsp;&#8211; Bringing ALT.NET to the masses

This one was more of a continuation from the previous day&#8217;s &#8220;passion&#8221; talk, but with some folks from the MSDN magazine and architecture journal from MS.&nbsp; It was another great discussion with lots of ideas to bring ALT.NET to the masses, including:

  * Expanding the ALT.NET website to include a wiki, videos, and more introductory material with links to more detailed information (mostly to Ayende&#8217;s blog)
  * Creating demos or a starter kit that installed NHibernate, NUnit, CC.NET, and the full OSS stack locally.&nbsp; Basically, rewrite the PetStore starter kit to use ALT.NET ideas to provide&nbsp;a nice introduction and example application
  * Aligning the PnP group with the other events.&nbsp; We all know that agile stuff is happening inside MS, but we never hear about it at the MSDN events.

There were several other ideas, but I realized afterwards that a nice bound notebook is a great note-taking tool, better than &#8220;maybe I&#8217;ll remember&#8221;.

#### Second Session &#8211; Executable requirements nirvana &#8211; StoryTeller and NBehave

This talk started with Jeremy Miller discussing the problems and difficulties of FitNesse, such as:

  * Great for tabular data-driven tests, but not great for complex models
  * Difficult to integrate with source control
  * Breaks often with refactorings, as everything is string-based (similar to the problems with NMock)

He showed StoryTeller, along with some tests.&nbsp; It made running and authoring FitNesse integration tests much easier, but still had the issues that FitNesse has.

Next, Joe and I gave a demo of NBehave, as well as a good discussion on where its value is.&nbsp; Mainly:

  * It gets the language right
  * It integrates well with automation
  * It runs complex objects well
  * It has a very grokkable interface

However, there were some shortcomings in that NBehave doesn&#8217;t do well with tabular data, and much has to be copied and pasted to do so.&nbsp; Jeremy suggested an integration with StoryTeller and NBehave, or FitNesse and NBehave to allow users to run story-based integration and acceptance tests.&nbsp; At one point, Joe thought it was a good idea to show the code behind NBehave.&nbsp; It was too late to take the beers back that I had bought him the night before.

#### Closing the space

At the end of the conference, everyone gathered in the main room, and all had a chance to give share their final thoughts.&nbsp; It was an amazing experience, and even Scott Bellware got a little choked up at the end.&nbsp; We went to lunch afterwards at Saltgrass Steakhouse, where&nbsp;Roy Osherove and Rod Paddock shared a story about a dirty joke, which we found could be applied universally to any situation.&nbsp; The story itself is NSFW, so I&#8217;ll just have to relate it later.

### Final thoughts

This was by far the best conference I&#8217;ve attended, I can&#8217;t wait for the next one.&nbsp; I left excited and energized, glad to be around so many people with so much passion.&nbsp; The conversations were always engaging and inviting, and never closed or exclusive.&nbsp; Any one could jump in to any talk at any time, and challenge any assumption of the discussion.&nbsp; I think the ALT.NET community (if that name does indeed stick) proved that there is a vibrant community in .NET that can provide conversation and feedback to MS, and not just a lot of external, negative&nbsp;noise.&nbsp; While I mentioned a lot of names here, I wasn&#8217;t trying&nbsp;to name-drop but to show that this community is accessible and eager to engage with others.&nbsp; This was an important first step in creating a healthier, more inclusive community, and I hope it isn&#8217;t the last step.