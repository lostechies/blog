---
id: 269
title: DotNetFringe 2015 Recap From a Former .NET Developer
date: 2015-04-16T22:03:06+00:00
author: Ryan Rauh
layout: post
guid: https://lostechies.com/ryanrauh/?p=269
dsq_thread_id:
  - "3687862105"
categories:
  - Uncategorized
---
# DotNetFringe 2015 Recap From a Former .NET Developer

As some may or may not know, I have quite the storied past in .NET. The year was 2008 and I just landed my first job as an internal IT developer for a largeish corporation in San Antonio, TX. The first project I was on was a WinForms application written in C#, .NET 2.X if I recall correctly. It was built using [CAB](https://msdn.microsoft.com/en-us/library/ff648747.aspx), CAB was a rather complicated and possibly controversal project from the Microsoft Patterns and Practices team. I was young and rather new to programming, it was my first &#8220;REAL&#8221; line of business app and I was very excited to just be making money doing what I loved.

Most of the code base was not very good by my standards today, but it suited our team well enough. The project had all the classic problems that largely don&#8217;t exist in the .NET ecosystem anymore (at least I hope). It used all of the _evil_ things that folks in the Alt.NET community we&#8217;re trying to fight against.

  * Stored procedures
  * Heavy use of inheritence
  * No tests
  * Shared _developement_ database
  * Magic strings **everywhere**
  * Click once deployements from a developers workstation
  * TFS

We were a small team lead by the quintessential expert beginner, but at the time I **loved** it. We were still doing a lot of good things, but I strived for more. I was a furocious seeker of knowledge, it was a **GREAT** time to be a .NET developer. There were so many of us with the same shared pain, I read every blog post I could get my hands on. I&#8217;d refresh [CodeBetter](https://codebetter.com), [Los techies](https://lostechies.com), etc all day. Enevitably I landed at the legendary blog of [Jeremy D Miller](https://twitter.com/jeremydmiller), the shade tree developer. [The Build Own CAB Series](http://codebetter.com/jeremymiller/2007/07/26/the-build-your-own-cab-series-table-of-contents/) spoke directly to my pains at work. I&#8217;m not sure if anyone else at the time fought so hard against stored procedures. His twitter debates about them were legendary. I think back on how badly he was attacked on twitter about it and it most have been hard, others too, it was a hard hard hard fight. At the time I didn&#8217;t fully understand the problems, but I certainly benefited from that effort. His efforts truly spoke to me, I told myself &#8220;I want to work at Dovetail someday, I want to learn from the best.&#8221;

This lead me to attend Pablo&#8217;s Fiesta in February 2010. I remember getting off of the plane and renting a car to go down to the Holiday Inn near the conference. There I ran into [Dru Sellers](https://twitter.com/drusellers) and he says, &#8220;Hey, would you like to join me for lunch, I&#8217;m going to Chuy&#8217;s with my good friend Jeremy Miller&#8221;. I was blown away, hells yeah I want to come with you. Afterward he said invited me to join him on a visit to the Dovetail offices, it was like a dream come true, I was there when Chad Myers, Jeremy Miller, and Josh Flanagan were giving [Phil Haack](https://twitter.com/haacked) the very first demo of [FubuMVC](http://mvc.fubu-project.org/). I was there to see Dru give the first demo of Nubular (which inspired NuGet). It was there I met [Ryan Kelley](https://twitter.com/ryankelley) and we became known as &#8220;[The two Ryan&#8217;s](http://codebetter.com/jeremymiller/2011/05/03/good-introduction-to-fubumvc-from-the-two-ryans/)&#8220;

In 2011 I went to work for Dovetail and I had achieved my goal. I finally made it and for two great years I got to work with my programming heros Jeremy Miller, Chad Myers, and Dru Sellers. In those two years me and the rest of the FubuMVC team built some awesome truly innovative things, we tried to boil the ocean so to speak.

  * Bottles
  * Command line parsing with model binding
  * Multi view engine support
  * Controllers without base classes
  * IoC all the way down 
  * Html conventions
  * Content negotiation

In 2013, I left Dovetail, moved to ruby and formed my company [HuBoard, Inc](https://huboard.com) but I&#8217;ve always kept my eye on the community and I&#8217;m still friends with many people in the community.

> Why all this history, get the point man

I tell you all the history, because that was the theme of #DotNetFringe in a large part. There was a lot of history in that conference ballroom. The people there were the people that fought tooth and nail to get MSFT to embrace open source.

There was a panel where a lot of that history came out, I&#8217;ll have to go back and watch some of the videos but the &#8220;shocker&#8221; of the panel was when [Scott Hanselman](https://twitter.com/shanselman) called [James Nugent](https://twitter.com/jen20).

> Elitist and mean

That will be a moment in the history of open source in .NET for me. It&#8217;s history just like the time [Rob Conery](http://rob.conery.io/) called the Alt.NET community a bunch of assholes on stage. There are a lot of sins that Microsoft has not atoned for **and** to put it bluntly there are a lot of **mean** people in the community that need to be nicer.

All of that _history_, is all **the drama history** it&#8217;s just the past so to speak, it&#8217;s meaningless in the grand scheme of the true historic moment. We won!

## **Microsoft open sourced .NET**

The real **history** is:

  * the day NuGet took its first community contribution. 
  * the day Azure tools developed out in the open on GitHub 
  * the day ASP.NET MVC hit GitHub 
  * the day [@kangaroo](https://github.com/kangaroo) [merged OSX support into coreclr](https://github.com/dotnet/coreclr/pull/105)

That is the only history that matters. There are a lot of people that are afraid of the past and they shouldn&#8217;t be. It&#8217;s open source now and there is no going back.

![Point of no return](https://s3.amazonaws.com/f.cl.ly/items/1B3c2s3x1K3l0n3S1o1O/Image%202015-04-16%20at%203.51.54%20PM.png)

They have reached the point of no return, Microsoft has a hard task ahead but if they mess it up, the community will fork it. It happened to NodeJS with io.js and it seems to be working just fine for them. I don&#8217;t want that to happen, but **open source will win**.

I for one am excited and any other current or former .NET developers should be too. Java is a huge disappointment if you move over from a strong C# background. There are problems that compiled, strongly typed, **fast as hell** languages are really really good at and I can wait for .NET versions of java technologies like Apache Storm and Hadoop.

Things I&#8217;m excited for:

  * static linking the CLR
  * apt-get install CLR
  * CLR support for languages on the JVM 
      * clojure.NET
      * scala.NET
      * ruby.NET
      * etc
  * .NET + Linux == Happiness 
      * vagrant
      * ssh
      * debian packages
      * FastCGI (nginx)
  * Storm.NET
  * Hadoop.NET

Things you should expect and thus not be mean to people about:

  * Tooling that doesn&#8217;t support windows 
      * version managers like rbenv, rvm, nodenv for .NET
  * Noobies 
  * former .NETers returning 
  * Java converts

It&#8217;s my opinion that the CLR is better than the JVM and hopefully Microsoft handles .NET better than Oracle has handled the JVM.

For me, I&#8217;m letting the past go.

I&#8217;ve realized **I have a chip on my shoulder too** and DotNetFringe was the therapy I needed to get over it and let it go.

In closing, don&#8217;t be mean, the drama history is not history it&#8217;s just the past.

Cheers&#8217;s to the true history, **.NET is open source**!

Cheers&#8217;s to the future, I can&#8217;t wait for the next DotNetFringe