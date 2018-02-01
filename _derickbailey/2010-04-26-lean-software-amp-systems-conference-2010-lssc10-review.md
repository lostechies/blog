---
id: 147
title: 'Lean Software &#038; Systems Conference 2010 (#LSSC10) Review'
date: 2010-04-26T18:22:43+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/04/26/lean-software-amp-systems-conference-2010-lssc10-review.aspx
dsq_thread_id:
  - "262068654"
categories:
  - Community
  - Continuous Improvement
  - Kaizen
  - Kanban
  - Lean Systems
  - LSSC
  - LSSC10InfoQ
  - Management
  - Networking
  - Presentations
---
Last week I attended (and presented at) the Lean Software & Systems Conference in Atlanta and it was well worth the trip! Everything from the keynote speakers to the individual sessions, from the hotel accommodations to the conference rooms, was well organized creating an environment of learning, collaboration, open discussion and true progress in the continuous improvement of software development and related processes.

&#160;

### Tuesday: David Anderson’s Kanban Book Launch

Tuesday evening kicked off the week for me, with David Anderson holding a book launch party for his new Kanban book which is now [available on Amazon.com](http://www.amazon.com/Kanban-David-J-Anderson/dp/0984521402):

[<img style="border-bottom: 0px;border-left: 0px;margin: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_48712FC5.png" width="168" height="168" />](http://www.amazon.com/Kanban-David-J-Anderson/dp/0984521402) 

I had the pleasure of being one of the reviewers of the manuscript during the last year or so and was invited to the book launch party. It was a fun gathering of tremendously talented people with discussions ranging over a wide variety of subjects. The book itself is all about using a Kanban system to facilitate change management in a software development organization. It’s a great read and a very informative book. I’ll be putting together a full review of the final version one I finish it. 

After the book launch, [Joe Ocampo](http://agilejoe.lostechies.com) and I took a very lost taxi out to a dive bar and met up with [Dave Laribee](http://laribee.com/) and [Steve Harman](http://stevenharman.net/) from [VersionOne](http://www.versionone.com/). [Dan Lash](http://twitter.com/danlash) was also there – apparently he had joined up with V1 two days earlier and was on his first trip to this weekly meeting at the bar. I hadn’t seen any of those three guys since the KaizenConference in Austin back in ‘08 so it was good to catch up with them (and yes, I still have Dan’s sun glasses from that conference around here somewhere :). The night was filled with cheap drinks, plenty of laughter and some great discussion with old friends and new ones (such as [Tim Wingfield](http://twitter.com/timwingfield), etc).

&#160;

### Wednesday: Don Reinertsen’s Keynote

This was probably the single most mind-blowing speech that I heard at the conference. Packed in front of a room of nearly 200 people who were wanting to learn about lean software development, [Don Reinertsen](http://twitter.com/DReinertsen) stood up and showed us in very great detail how we were selling ourselves short if we were assuming lean systems to the be the end goal instead of [one of many waypoints](http://twitter.com/derickbailey/status/12575275847) on a lifetime journey of software development. 

The two big points that I took from this presentation were the ideas of a software development being a network of processing steps instead of a linear progression, and that we need to be finding the sweet-spot between over-testing (every line of code gets its own test or test suite run) and not testing enough (1,000+ lines of code with only 1 test) based on the economic factors of testing.

Some other high points in Don’s keynote were captured via my tweets:

  * eliminate variability is potentially the most toxic idea for product developers. [#LSSC10](http://twitter.com/search?q=%23LSSC10) [8:12 AM Apr 21st](http://twitter.com/derickbailey/status/12575387154)
  * eliminating variability will eliminate value from product development [#LSSC10](http://twitter.com/search?q=%23LSSC10) [8:13 AM Apr 21st](http://twitter.com/derickbailey/status/12575460112)
  * how much code do you write before you test? 1 line is inefficient, 1K lines is begging failure. find the sweet spot of adding value [#LSSC10](http://twitter.com/search?q=%23LSSC10) [8:17 AM Apr 21st](http://twitter.com/derickbailey/status/12575661133)
  * defect prevention AND defect inspection / correction, not either/or. minimize cost of both. example:do you use spell checker? 🙂 [#LSSC10](http://twitter.com/search?q=%23LSSC10) [8:20 AM Apr 21st](http://twitter.com/derickbailey/status/12575777115)
  * don&#8217;t turn off your brain and assume defect prevention is always the better option. examine cost of prevention vs. correction. [#LSSC10](http://twitter.com/search?q=%23LSSC10) [8:20 AM Apr 21st](http://twitter.com/derickbailey/status/12575802855)
  * one-piece flow is not always the best thing. find the sweet spot between transaction cost and holding cost [#LSSC10](http://twitter.com/search?q=%23LSSC10) [8:24 AM Apr 21st](http://twitter.com/derickbailey/status/12575991944)
  * the "TPS Emergency Room" &#8230; this is hilariously scary. doctors doing "stop the line" and "WIP Limits" in ER&#8230; NO THANKS! 🙂 [#LSSC10](http://twitter.com/search?q=%23LSSC10) [8:28 AM Apr 21st](http://twitter.com/derickbailey/status/12576168192)
  * WIP limits needs to be balanced by cost of delay for the things that need to be done. [#LSSC10](http://twitter.com/search?q=%23LSSC10) [8:30 AM Apr 21st](http://twitter.com/derickbailey/status/12576245194)
  * WIP Limits:you wouldn&#8217;t shut the ER doors when an ear-ache patient comes in while a heart attack patient waits outside. [#LSSC10](http://twitter.com/search?q=%23LSSC10) [8:30 AM Apr 21st](http://twitter.com/derickbailey/status/12576294967)
  * non-linear flow of work advised by emergent information to better understand economic impact of work being done [#LSSC10](http://twitter.com/search?q=%23LSSC10) [8:32 AM Apr 21st](http://twitter.com/derickbailey/status/12576346115)
  * fun times making fun of 5S in product development. 🙂 let&#8217;s outline the location for the stapler on everyone&#8217;s desk! [#LSSC10](http://twitter.com/search?q=%23LSSC10) [8:43 AM Apr 21st](http://twitter.com/derickbailey/status/12576953294)
  * use dynamic wip constraints, not static wip constraints, for product development [8:49 AM Apr 21st](http://twitter.com/derickbailey/status/12577234063)
  * create quality by iteration, not by defect prevention [#LSSC10](http://twitter.com/search?q=%23LSSC10) [8:50 AM Apr 21st](http://twitter.com/derickbailey/status/12577274096)
  * batch size: imagine TCP/IP sending 1 bit as the payload for every packet. you would never get anything done. [#LSSC10](http://twitter.com/search?q=%23LSSC10) [8:58 AM Apr 21st](http://twitter.com/derickbailey/status/12577668988)
  * optimal batch size balances payload size against overhead of packets [#LSSC10](http://twitter.com/search?q=%23LSSC10) [8:58 AM Apr 21st](http://twitter.com/derickbailey/status/12577687811)
  * responsibility for quality is on the sender / receiver, not the nodes in the network [#LSSC10](http://twitter.com/search?q=%23LSSC10) [9:01 AM Apr 21st](http://twitter.com/derickbailey/status/12577838531)
  * in other words iterate and communicate to build quality by getting rapid feedback from customer instead of forcing defect prevention [#LSSC10](http://twitter.com/search?q=%23LSSC10) [9:02 AM Apr 21st](http://twitter.com/derickbailey/status/12577931501)
  * how can a delivery become 30 days late in 1 day? easy: a 30 day test cycle fails on the 29th day. [#LSSC10](http://twitter.com/search?q=%23LSSC10) [9:05 AM Apr 21st](http://twitter.com/derickbailey/status/12578083247)
  * pure self organization is chaos. need alignment and direction with goals to allow initiative to succeed [#LSSC10](http://twitter.com/search?q=%23LSSC10) [9:24 AM Apr 21st](http://twitter.com/derickbailey/status/12579075926)

For anyone that missed it, there will be a video posted at some point. You will want to watch this over and over and over again. After that, most of the day for me was spent in the software engineering track. 

I got to see some great info and amazing tools that [Joshua Kerievsky](http://twitter.com/JoshuaKerievsky) is building and learn some great techniques for limiting the amount of time that we spend in “refactoring rash” – where the refactoring bar (think Resharper and Eclipse refactoring tools) is littered with red dots. The tools that Joshua is building are amazing and I’m looking forward to them being available in Visual Studio (still in the planning stages, unfortunately). You can see the tools that Joshua is building over at [http://www.industriallogic.com/](http://www.industriallogic.com/ "http://www.industriallogic.com/") and there will be a video posted of his presentation, as well.

That evening, Pillar (home of people like Mike Cottmeyer) sponsored a conference reception at a restaurant called Aja. It was great food, good drinks, an awesome atmosphere and phenomenal discussion with more tremendously smart people. I got to spend a lot of time talking with [Paul Rayner](http://twitter.com/virtualgenius), who gave a session on motivation in software development earlier that day. I don’t remember if there was video of his session or not, but I’m pretty sure every session was recorded in some way. This is another one that you won’t want to miss, and was the only non-software engineering track session that I attended on Wednesday.

… there was my presentation at the end of the software engineering tracks, as well. I’ll post about that separately.

&#160;

### Thursday: Brickell Key Awards And Git

Thursday morning had a keynote speech by Bob Charette – the original lean software development innovator. Bob’s first published article on lean software development was done back in the mid-90’s and his experience and expertise were apparent during the keynote. I was not quite as mesmerized as I was with Don Reinertsen, honestly, but I was still very engaged in this presentation. Bob did a great job of spelling out risk management in software development and had several very interesting points to make. The big thing I took away from this presentation was “assumptions are risks that we have accepted” – which will be the subject of my next blog post.

During lunch on Thursday, all speakers and conference staff were treated to lunch at a local restaurant. At the end of the lunch, David Anderson announced a new awards program from the LSSC – the Brickell Key awards. This award is modeled after the Gordon Pask award for the Agile Alliance and is intended to recognize those that are truly pushing the boundaries and expanding our knowledge and capabilities. There were two award recipients this year: David Joyce and Alisson Vale. You can read the full story and find links to the acceptance speeches here: [http://www.limitedwipsociety.org/2010/04/25/brickell-key-awards-recognizes-kanban-community-contributions/](http://www.limitedwipsociety.org/2010/04/25/brickell-key-awards-recognizes-kanban-community-contributions/ "http://www.limitedwipsociety.org/2010/04/25/brickell-key-awards-recognizes-kanban-community-contributions/")

I also had the pleasure of talking to Don Reinertsen directly while we waited for lunch. We got onto the subject of value in automated tests, from his keynote, and I came away from that conversation with several ideas about how to maximize the value in automated test suites. I’m hoping to get these thoughts organized into something a little more substantial this week, and post about it.

There were some great sessions on Thursday as well – which I seem to have missed. The sessions I attended were good, mind you… but the constant cheering and clapping from sessions in other rooms gave me a hint that I was sitting in the wrong ones. Specifically, Alisson Vale’s session was the one getting claps and cheers. I’m really looking forward to watching this video – especially knowing that he received a Brickell Key award.

Thursday dinner and evening was the most fun I had outside of the conference. Joe Ocampo and I went to dinner with Chris Hefley and Steven (i can’t remember your last name! sorry!) from Bandit Software – the guys that make the LeanKit Kanban tool. We went to [Fogo De Chao](http://www.fogodechao.com/) – a Brazillian Churrascaria. We discussed a lot of great stuff from software and process tools to git source control, etc – all while stuffing ourselves with great food and wine. After walking back to the hotel, we all met in Chris / Steven’s room and Joe and I did a few hours of [ad-hoc git training](http://twitter.com/derickbailey/status/12683242396) for them. This was a lot of fun. We got to show some of the great things that git does, over subversion, and got to see a few dozen of those “WOOOoooaaahhh…” moments in Chris as he realized just how easy and powerful git is compared to subversion. I’m fairly certain that we converted Chris and Steven in those few hours. 🙂

&#160;

### Friday: Estimating And Almost Being Stuck In Atlanta

I spent most of Friday morning wandering between the open spaces sessions and a few experience reports. The only participation I had in the open spaces was in the session on estimating. I had posted a question about how to do estimates correctly since there seems to be a general air of “estimates are evil” in the lean software movement. This particular session was one of the few [disappointments that I had at the conference](http://twitter.com/derickbailey/status/12703345560). I came in late to the conversation, honestly, but after sitting and listening for a bit I didn’t feel like my issues had been brought up yet. So I started asking questions and I received very little in terms of useful information. Most of what I heard in response was the same old agile and lean estimation platitudes and people trying to convince me that I have to use an abstraction instead of time based estimating. One of the specific problems that my team faces is dealing with experience in the estimates. 1 person may say it will take 3 hours and be accurate for them, while another person may say it will take 20 hours and be accurate for him as well. The difference is the experience in the system, the domain, and in careers in general and its a valid difference that can’t be shoved aside with platitudes about abstracting away from time based estimates. In the end, all estimates are a measure of time. … There were two good suggestions that I heard, though… one from Joe Ocampo (not during this session, but after during a discussion with him) and one from someone who’s name I don’t remember during this session. The idea was to scale the estimates by the person giving it. If the uber-experienced person says an estimate is 3 hours, and the not so experienced person says the estimate is 20 hours, there is a scale of 3:20 that can be applied between the people. We can call the estimate a “3” hour estimate and then scale it according to the person doing the actual work. An interesting side effect of this is that we begin to recognize the potential problems of assigning certain work to certain people. If a bug or feature needs to be delivered immediately in order to maximize value, then we may need to give that work to the person who can do it faster. Having this scale in place will help us identify who should work on what, according to the value of that work vs time.

I got to see Tim Wingfield’s experience report on Friday, as well. He did a great job and showed a tremendous amount of learning and growth through the several years of experience that he has under his belt. He also had a great perspective on “sometimes do scrum, sometimes do flow/kanban” depending on which of those fit the situation and circumstances. This is something that tends to be lost on the lean / kanban crowd. We all have to remember that context is king, though, and what works in one situation may not work in another situation.

After saying my goodbyes to everyone and thanking David Anderson for putting the conference together, I was off to the airport to head home. On the MARTA train ride to the airport, I sat next to [Jason Yip](http://jchyip.blogspot.com/) (a Thoughtworks Australia employee) and had some great discussion with him, ranging from my presentation to iPhone/Android development, and martial arts and exercise. I’m glad to have had those conversations with Jason and was inspired to get off my butt and start exercising again. While I would prefer to find some way to make my life more active with physical fitness being a side effect of my lifestyle, I’ll start with the reality that I just need to get off my butt and go.

… and I almost got stuck in Atlanta for what could have been a very, very long time. Apparently I made a mistake in arranging my travel for the conference. Instead of booking my return flight for Friday, April 23rd, I had accidentally booked it for Friday, May 28th! As much as I would have loved to stay in Atlanta for another month (and I work from home, so I could have still been at work while there), I really missed my family and wanted to get home. So, I shelled out the $450 to get the same flights for that day and made it home at the expected time anyways. In the future, though, I’ll be sure to watch the pop up calendar on Travelocity’s website a little more closely. 🙂

&#160;

### Conclusion: I Hope To See You There Next Year!

Even with the things that went wrong for me personally (watch this blog for a full description…), I have to say the conference was a tremendous success! David Anderson and his phenomenal cast of organizers, contributors and helpers put on a great conference. I definitely want to attend next year’s event which is rumored to be happening in Las Angeles, CA. I hope to see more of a technical crowd next year, including you my dear readers. Even if that doesn’t pan out, I know the conference will turn out great.