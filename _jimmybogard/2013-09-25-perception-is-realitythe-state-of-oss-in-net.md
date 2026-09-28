---
wordpress_id: 818
title: Perception is Reality–The state of OSS in .NET
date: 2013-09-25T13:29:25+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=818
dsq_thread_id:
  - "1795724727"
categories:
  - Community
  - OSS
---
A response to Amir Rajan’s post that [.NET OSS is DOA](http://amirrajan.net/meta/2013/09/19/perception-is-reality-dot-net-oss/).

The history of OSS in .NET is a long and winding road. It involves many different champions in the community, many different teams in Microsoft, and a very interesting sea change in the attitude towards OSS in large organizations.

At one point, MS employees were not allowed to look at OSS tools for fear of getting sued. This resulted in straight-up duplicate tools/frameworks/libraries being developed by Microsoft when there was no clear differentiator/advantage to the OSS tool that clearly dominated the space. This is really the Dark Ages of OSS at Microsoft, where these tools were created:

  * MSBuild over NAnt
  * MSTest over NUnit
  * TFS Source Control over SVN
  * EF over NHibernate

All of the tools on the right were clear “winners” in their respective space, and the tools on the left were more or less copies of the functionality the frameworks on the right provided. Some are less copies (EF has a LONG and interesting history, spanning multiple teams and even organizations).

I remember conversations with the PM on MSTest at ALT.NET Seattle many years ago, where a room full of NUnit/TestDriven.NET users were asking why MSTest was even created, as it was much, much slower and had fewer features than NUnit (and required a specific SKU in Visual Studio). The reality was that at the time MSTest was developed, its developers were not even allowed to _look_ at NUnit for fear of accidentally copying some functionality.

That was the reality back then, and the ALT.NET movement arose as a (temporarily) unified voice to more or less let Microsoft be aware that there is a set of OSS practitioners in .NET, they are getting upset at the direction of MS tooling, and that they were in danger of losing many of the “Alphas” to other frameworks and platforms, particularly Ruby and Rails.

### And then a lot of stuff happened

Microsoft is a container ship. It doesn’t turn on a dime, nickel, quarter, or even elephant. Shifting the attitudes and realities of such a disparate set of teams is really, really hard. You might have one team that embraces OSS rather quickly (ASP.NET) and some that might never (SQL).

It’s a complex group, but one thing is very, very clear: OSS is .NET is getting better. It has been getting better for many, many years, and will continue to get better.

A few examples.

jQuery has been fully supported by Microsoft, and they have abandoned their own library (ASP.NET Ajax), which was a direct competitor but inferior tool.

ASP.NET MVC is fully open source, accepting community contributions. You might wonder why ASP.NET MVC is even around, when another MVC tool existed at the time: Castle Monorail. To anyone that has actually used Castle Monorail, there is no mystery. ASP.NET MVC and Monorail aren’t direct competitors – they’re solving similar problems in different ways, and Monorail goes a lot further to provide a similar experience to Ruby on Rails.

.NET FINALLY has a package manager with NuGet. The OSS community had been trying for \*years\* to create a package manager. Some were more successful (OpenWrap), but there was no clear “winner”. I remember conversations at ALT.NET conferences about building a package manager, or using Gems, but nothing won. NuGet is fully open source, accepting community contributions.

A project that actually started as a side OSS project by an MS team member on GitHub is now a core part of ASP.NET (SignalR). This was UNTHINKABLE just a few years ago.

ASP.NET Web API started completely open source, back when it was WCF Rest Toolkit. Instead of re-inventing JSON seralization, the Web API team picked the clear “winner” in the .NET community, the OSS library JSON.NET. Again, this is **a complete 180 degree turn from the previous decade.**

### What about those other tools?

Amir’s post talks about MS creating Web API instead of just going with the clear “winner”. Besides his timeline being just plain wrong (that blank space where “nothing was happening”…_plenty_ was happening). He gives examples of Ruby tools:

  * RSpec
  * Sinatra

And that for some reason .NET developers should have just “jumped on board” building clones of those other frameworks. Do you know what .NET OSS developers were doing during that time? Actually using those Ruby tools!

Early on the OSS period in .NET, cloning was the norm. One just has to look at all the OSS tools that have a Java counterpart (jUnit, NUnit, Hibernate, NHibernate, Ant, NAnt). At .NET conferences I went to during that period, those other Ruby tools were being demonstrated. Some were cloned early (NBehave was an early clone of RBehave/RSpec), but TOO early because it wasn’t clear those tools had real value in .NET. I remember seeing demos of Sinatra years ago, and a lot of .NET developers telling each other, “we should have that in .NET!” Well, now we do, and have for quite a long time, and a much better version than a copycat could have been.

I don’t know how one makes the leap that Web API is a competitor to Nancy, but to call OSS DOA because of one dissimilar tool that didn’t “win” is absurd to the point of insulting to those actually working to further OSS in .NET. Service Stack and Nancy shouldn’t be compared to Web API, because they’re solving different problems in very, very different ways. If they were the better ways to solve the **same problem**, then they would have “won”. The timeline also ignores other OSS competitors that worked better with existing frameworks (Restfulie, for example).

You can point to your favorite tool and think it should dominate the space, but that’s really just an opinion. Plenty of OSS tools dominate spaces in the .NET ecosystem. But if you’re trying to create or promote a tool in an already a crowded space, you should really, really reset your expectations.

Calling OSS DOA because MS didn’t embrace Nancy or Service Stack or SASS/LESS is sorely misguided and dismisses the real work that has been going on for years in the .NET OSS community. OSS still has a ways to go in .NET, but the right people are in place, and more importantly, the right attitudes are in place at Microsoft. The long history of OSS in .NET is a murky one, but the present is clear and the future is bright.