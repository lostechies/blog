---
wordpress_id: 335
title: No Fluff Just Stuff roundup
date: 2009-07-14T12:54:54+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/07/14/no-fluff-just-stuff-roundup.aspx
dsq_thread_id:
  - "264716244"
categories:
  - NFJS
redirect_from: "/blogs/jimmy_bogard/archive/2009/07/14/no-fluff-just-stuff-roundup.aspx/"
---
This past weekend, the [No Fluff Just Stuff](http://www.nofluffjuststuff.com/home/main) event came to town, and this humble .NET author infiltrated the Java ranks.&#160; This was my first NFJS event, and first of any Java event.&#160; In fact, I’ve never opened Eclipse or wrote a single line of Java.&#160; However, I’m extremely interested how other communities are solving the same problems as us (the .NET world), so I was really looking forward to seeing what kinds of innovation were coming out of the Java space.

The really interesting observation that I found that while in some respects the Java community has moved past many of the issues the .NET community faces, in some respects they are replaying the same mistakes.&#160; And, like all conferences, I couldn’t get to all the sessions I wanted.&#160; Here are the ones I _could_ get to:

### Friday

The NFJS seem to abhor pointlessness.&#160; This was no less evident in the opening welcome, which lasted ALL OF 15 MINUTES.&#160; Real quick, “thanks for coming, our agenda is on the back of your nametag”.&#160; No lovey-dovey, hippie kumbayas, nor any narcissistic hero-worship keynotes.&#160; Very refreshing.&#160; Instead, we jump straight into the first session.

#### Domain-Driven Design and Development In Practice – Code Generation, Srini Penchikala

I came in with high hopes, but left a little disappointed.&#160; The premise behind this talk was that DDD requires a ton of boilerplate code.&#160; Entities, DAOs, Repositories, Hibernate configuration, and so on.&#160; This would be a lot of work for developers to do, and with a large workforce, DDD would be hard to try and implement company-wide.&#160; The creation of the boilerplate code would come from the business, in the form of a specification of “here are the nouns, and here are their attributes”.

But if code generation is really a solution, why not go with a convention-based framework that doesn’t need boilerplate code?&#160; After all, the applications where DDD really shined for me is where there were no opportunities for boilerplate code as the domain was complex!&#160; This is also the conclusion of the presenter, who at the end of the talk, basically said, “or you can use one of these convention-based frameworks like Rails, Django, Grails, etc. etc.&#160; At that point, it looked like trying to use a screwdriver to hammer a nail.

#### Test-Driven Design, Neal Ford

First off, Neal is an awesome presenter.&#160; In his talk, Neal demonstrated a very simple feature, and TDD influences design by showing both a Test-First, and Test-After approach.&#160; The problem was to determine if a number is a perfect number.&#160; The Test-After approach yielded something very familiar – a single static method, filled with special cases.&#160; It wasn’t too terribly hard to understand, but seemed rather complex.&#160; With the test-after approach, design issues were forced very early, yielding a much different result.

What’s even more interesting is the effect TDD had when a new requirement came up – deficient and abundant numbers.&#160; TDD elicited a more flexible design, not intentionally, but because simple, testable designs are easy to adapt.&#160; Neal then promptly went off the deep end, advocating reflection to test private members.&#160; No.

If you ever get a chance to catch Neal give a talk, I highly recommend it.&#160; Neal is a great speaker, and teacher.

#### The Productive Programmer, Neal Ford

Encouraged by his TDD talk, I stuck around for Neal’s talk on being productive.&#160; This talk was divided up between mechanical strategies, using tools to work for you, using the keyboard and so on, and strategies with habits, such as not checking email every 5 minutes.&#160; One of the more interesting ideas was the idea of a “quiet time”, where between the hours of 9 and 3 (excluding lunch), email, IM, Twitter, RSS readers and so on were switched off for greater focus.&#160; It took quite a bit of discipline, but I did find myself concentrating a lot more.

On the flip side, I found myself needing to take regular breaks to get up and walk around.&#160; I could keep a mental flow state for about an hour before I needed physical exercise to give my brain some rest.&#160; All it took was lots of liquids to have some biological encouragement to do so.&#160; This was quite the firehose session, so I gave up notes after awhile as Neal’s slide deck contained all the reference I needed.

Friday ended with a keynote from Venkat Subramanian.&#160; While it was entertaining and informative, I don’t remember a single thing from it.&#160; Other than Java developers seem to have a self-loathing aspect.&#160; They seem to love the Java platform, but not the Java language.

### Saturday

Saturday presented a lot of opportunities to learn how Java developers deliver value, so I tried to expose myself to as many completely alien ideas as possible.

#### GWT: An Introduction, David Geary

I’ve heard of the Google Web Toolkit, but never looked any further other than wonder why it was the same acronym as Given When Then.&#160; The idea behind GWT is to create AWT/SWT/Swing-like applications (think WinForms) in a special version of Java, and have it compile to JavaScript.&#160; Java compiled to JavaScript, quite interesting.&#160; GWT has a lot of widgets out of the box, and it would be quite similar to developing WebForms applications in C# that compiled to JavaScript.

This meant that you could develop in a language you understand well, and have guaranteed cross-browser JavaScript support.&#160; Interesting idea, but I haven’t built component-based websites in a while, and I quite like HTML and JavaScript.

Because jQuery is awesome.

#### Groovier Spring, Scott Leberknight

Groovy is an interesting language, as it is a dynamic, scripted language that can talk and be compiled to Java.&#160; The other interesting thing is that straight-up Java can be compiled into Groovy, providing a nice transition to a dynamic language.

Combined with Spring, all I heard was this:</p> 

Except replace “Malkovich” with “annotations”.&#160; The evolution of Spring, evidently, is to litter your code with annotations (i.e., attributes).&#160; There were a few interesting ideas here, such as using IoC to inject scripts for dynamic behavior.&#160; The example given was document generation, where you could load scripts into the database, and IoC would automatically get the latest script.&#160; Because Groovy plays well with Java, it all worked out.

#### 

#### Real World Hibernate Tips, Nathaniel Schutta

I got nothing out of this one, except to note a few Hibernate features that aren’t in NHibernate, yet.

#### Git Going with Distributed Version Control, Matthew McCullough

A great “getting started” presentation for Git, this one had me convinced.&#160; Most of the presentations I’ve seen so far focus way too much on the “how”, but hardly any on the “why”.&#160; Matthew walked through scenarios showing how distributed version control would not only mitigate some issues, but other issues would completely drop off.

Interestingly, our team is now practicing Branch-Per-Feature, with Hudson as our branch builds, and Git could really help us out there.&#160; Other places it can help is where I’m driving down a refactoring, and some defect comes in.&#160; I could easily commit a branch, roll back to trunk in a snap.&#160; I’m planning on running on Git myself for a week or two in a pilot program of sorts.

### Sunday

One other interesting thing behind NFJS is that neither Saturday nor Sunday had any kind of opening welcome.&#160; It went straight into sessions.

#### IZero: Starting Projects the Right Way, Stuart Halloway

IZero, or Iteration Zero, are all the things you need to do _before_ you start writing software.&#160; This talk wound up being a session on Q&A on how Stuart does agile.&#160; It’s always interesting to see how other folks do Agile, but there’s nothing really that interesting to report here.

#### Taking Agile from Tactics to Strategy, Stuart Halloway

This was a far more interesting talk, as much of Agile talks only about running iterations/releases.&#160; But, lots more needs to go on outside of that.&#160; During this talk, I ran into an old colleague in the hallway, so I need to review this talk again.

#### Hacking Your Brain for Fun and Profit, Nathaniel Schutta

For once, it was nice to get a session that had absolutely no code, or the word “agile” in its premise.&#160; This talk centered around how we can be more productive, and went over things like sleeping habits, exercise, and how our daily habits affect our effectiveness at work.&#160; It was and entertaining talk, and pointed me to quite a few new books to check out, Such as “Brain Rules”, “Pragmatic Thinking and Learning”, “Outliers” and more.

Also, the book du jour was “[Daemon](http://thedaemon.com/)” – which I highly recommend.

#### Programming Clojure, Stuart Halloway

Stuart is an excitable guy.&#160; Get him talking about Clojure, and he’s _real_ excitable.&#160; Clojure is a Lisp, with again interoperability with Java.&#160; It was more insight into functional languages, and how we can blend strengths of multiple languages on a single platform.

While all of the functional features of C# are nice, having something like F# as a first-class citizen in .NET rounds out the development story.&#160; .NET should never be about C#, as all languages have their strengths and weaknesses.&#160; Stuart showed quite a bit on how Clojure blew languages like Groovy, Ruby and Java out of the water.

### Wrapping it up

NFJS was a great conference because of three reasons:

  * The speakers were excellent
  * The facility was excellent
  * The organizers were excellent

I plan on attending **at least one non-.NET conference a year**, and I hope more in the .NET space do so as we mature as a community.&#160; Every community runs the serious risk of becoming an echo chamber.&#160; But as languages are shared more and more across platforms (Ruby is a great example), these barriers are broken down more and more.

One other thing NFJS did well was spacing out talks.&#160; Instead of trying to cram everything in one long day, talks actually had BREAKS between them!&#160; Imagine that.&#160; It set a much more reasonable pace, and allowed for conversations between talks.

The other big impression I got was how much Java developers seemed to move beyond Java as a language to Java as a platform.&#160; This has always been one of .NET’s strengths, and pushing more languages as first-class citizens and rounding out the interop story will allow .NET to innovate in far more areas.