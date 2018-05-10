---
wordpress_id: 73
title: Alt.Net conference and Behavior Driven Design
date: 2007-10-07T06:31:58+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2007/10/07/alt-net-conference-and-behavior-driven-design.aspx
dsq_thread_id:
  - "262089708"
categories:
  - altnetconf
  - BDD (Behavior Driven Development)
redirect_from: "/blogs/joe_ocampo/archive/2007/10/07/alt-net-conference-and-behavior-driven-design.aspx/"
---
Today at the <a href="http://www.altnetconf.com/" target="_blank">Alt.Net conference</a> we discussed Behavior Driven Design. The debate was heated and there were varying opinions on “What is BDD?” and how to implement it. What I am worried about is that I think we did more harm than good with this session in bringing awareness to the .Net community regarding BDD. 

The discussion on BDD utilized a [Fish Bowl style](http://en.wikipedia.org/wiki/Fishbowl_(conversation)) forum. The issue that I saw from the onset is the bowl was too small for the amount of people that wanted to jump in. 

What I wanted to get out of the meeting was consensus on what does BDD mean to the .Net community. I think one of my mistakes in this discussion was to introduce [NBehave](http://www.codeplex.com/NBehave) at the beginning of the discussion and not focus on what BDD is and why you should use it over TDD. 

The NBehave framework introduces a Narrator assembly that exposes a [Story type](https://lostechies.com/blogs/joe_ocampo/archive/2007/07/15/more-bdd-xbehave-madness.aspx) for the collection of Agile stories. The contention point is should you do this? Don’t get me wrong debate is a wonderful medium to bring change and churn new ideas but it comes at a cost. The cost in this scenario was focus. I feel that a majority of the participants in this forum left confused and well frankly unimpressed, I can’t blame them. 

NBehave brings about a radical evolution of TDD and blurs the line between Acceptance Testing and traditional TDD. The inclusion of the Story Narrative was looked at as a high contention point and not applicable to all development contexts. This was the cultivating reason why we decided to break up the project into these 3 discrete assemblies. 

  * NBehave.Spec <This contains the specification assertion framework a.k.a. NSpec>
  * NBehave.Narrator <This contains the fluent Story type constructs >
  * NBehave.Runner <One console runner to run them all>

So if the Story types aren’t applicable to your given development context don’t use them. Use the NBehave.Spec instead. But it doesn’t have to stop there. You can apply a BDD mindset to your current test fixtures now as I have explained [here](https://lostechies.com/blogs/joe_ocampo/archive/2007/08/07/attempting-to-demystify-behavior-driven-development.aspx). 

My passion for BDD isn’t gone it is simply bruised. I think given the right facilitation, that the ideas and constructs of BDD can make a huge impact in the .Net community. And for those that attended the Alt.Net conference I apologize for the lack of clarity on the subject.