---
id: 4053
title: 'How We Do Things &#8211; Evolving our TDD/BDD Practice'
date: 2009-10-07T14:17:00+00:00
author: Scott Reynolds
layout: post
guid: /blogs/scottcreynolds/archive/2009/10/07/how-we-do-things-tdd-bdd.aspx
categories:
  - how we do it
  - Management
  - mentoring
  - software
  - SOLID
  - team
  - Testing
---
_This content comes solely from my experience, study, and a lot of trial and error (mostly error). I make no claims stating that which works for me will work for you. As with all things, your mileage may vary, and you will need to apply all knowledge through the filter of your context in order to strain out the good parts for you. Also, feel free to call BS on anything I say. I write this as much for me to learn as for you._

_This is part 4 of the [How We Do Things](/blogs/scottcreynolds/archive/2009/10/04/how-we-do-things-preamble-and-contents.aspx) series._

Today we&#8217;re going to talk about how we evolved our TDD practice, the troubles we faced along the way, and where we stand now.

I already mentioned that when we started this project oh so many years ago we did not construct it with TDD, and I&#8217;ve mentioned how well (from the user perspective anyway) it turned out. So, let&#8217;s dispel any notions that I&#8217;ve ever said that no software can be successful that wasn&#8217;t built with TDD, because the flagship of my career was.

However, I will qualify that by saying that now, when the team has to go into that old code to modify it, we curse ourselves constantly for not having done TDD. I can say with confidence that had the system been designed with TDD as we practice it now that changes would be easier to make, and the code would be easier to understand 5 years later.

But practices evolve, and that&#8217;s what this series is about, non?

### Many False Starts

<div style="text-align:center">
  <img src="//lostechies.com/scottreynolds/files/2011/03/DarthTesting.png" alt="DarthTesting.png" border="0" width="350" height="300" />
</div>

Now we started with every intention of doing TDD. We made an effort, but it fell by the wayside very quickly as pressures mounted. At the time I had only a very surface understanding of TDD and had not been a full-time practitioner at any point. The other programmer on the team at the time was a fresh out of high school kid with very little experience. We weren&#8217;t pair programming, and I lacked the knowledge and experience to mentor the TDD practice, so it was essentially a non-starter.

For a while we did do unit and integration testing in test-after (TAD) form, but that fell apart as well. We fell into the trap of optimizing the &#8220;code complete&#8221; workflow at the expense of test coverage.

As time went on my understanding of TDD grew. I got more involved in the community and started practicing more on my own. I credit [Scott Bellware](http://blog.scottbellware.com/), [Dave Laribee](http://codebetter.com/blogs/david_laribee/), [Ray Lewallen](http://codebetter.com/blogs/raymond.lewallen/default.aspx), and [Jeremy Miller](http://codebetter.com/blogs/jeremy.miller/default.aspx) primarily for either directly or indirectly influencing and increasing my knowledge of the practice.

When adopting any advanced practice it is incredibly important to have masters to learn from. This is true in programming and elsewhere. These guys, whether via their blogs, or conversations, or actually sharing code helped me immensely in bootstrapping my testing practice.

As a team leader, it&#8217;s also important that you have the tools to mentor your team in a new practice. My folly the first few times we started (and quickly stopped) doing TDD was not being able to do that mentoring, but trying anyway. It broke down quickly.

Eventually we started picking up TDD again. It wasn&#8217;t a 100% thing, but we were making the effort, and I was doing a much better job leading the way. I was actually working with my team to help them write tests rather than simply giving the directive and some links to read. I was educating them on OO principles that would help them understand how tests can drive design, rather than letting them flounder.

This is all not to say that I did everything perfectly, in fact rather the opposite. I didn&#8217;t understand how many disciplines were at play for successful TDD adoption at first, and I take full blame for not having the leadership ability to get them there sooner.

We went along like this doing TDD, though at times very fragile and na&iuml;ve TDD, on new development where it was easy. It wasn&#8217;t until after Scott introduced me to Context/Specification (c/s) at one of the early alt.net events that everything seemed to click. I came back from that event and gathered my team, which had grown to 3, in a room where we pair programmed as a group for several days and explored c/s and BDD together. By the end of that week it was as if a light went on for us collectively, and our testing practice from that point on was much more robust.

As new members joined the team we immediately went into mentoring on c/s. At the time we weren&#8217;t pair programming as a rule yet though, so it was difficult. We also were still dealing with a significant legacy code problem and putting tests around new things to interact with old things that weren&#8217;t all that testable was difficult to say the least.

Frustration finally set in for us and we set about making our legacy codebase more testable. We didn&#8217;t have time or budget to do this all in one fell swoop, so we did what any good team does&#8230;refactored as we went. Slowly but surely we started getting comfortable with a few patterns that we could employ to refactor our legacy code for tests while adding new features or fixing bugs, and our TDD practice really started to get teeth.

### The Catalyst &#8211; Pair Programming

<div style="text-align:center">
  <img src="//lostechies.com/scottreynolds/files/2011/03/pairpong.png" alt="pairpong.png" border="0" width="350" height="300" />
</div>

When we finally introduced pair programming as a regular practice (more on this in a later post) we started to see a real uptick in the understanding and appropriate application of TDD and c/s. Mentoring by the more experienced team members was happening in real-time, as code was being written, and understanding skyrocketed. There were other benefits to pairing as well, but again, that&#8217;s a later post in the series.

Suffice it to say, if I had to do it over again we would have introduced pair programming far earlier, and our testing practice wouldn&#8217;t have suffered from so many false starts for so long.

### a\_monkey\_wrench

We were sailing along pretty well with our TDD and c/s practice in our c# WinForms applications, which was the bulk of what we did. Then we had some shifts in corporate priorities that saw us doing a lot more web work. Rather than go with the .net platform, we chose Ruby on Rails for this. We&#8217;ll talk about how we choose tech in a later part of this series as well.

The thing with going RoR was that it was totally new for us on a lot of levels. We hadn&#8217;t done any significant web-based work in years. I hadn&#8217;t touched the web since 2001 myself. Plus we were a total .net shop up until that point, and this was a completely new language, on a completely new platform. We had to learn ruby, rails, ajax, apache, linux, and a whole slew of related technologies.

It turned out that trying to throw RSpec and TDD into the mix was just too much for us, and we were at near zero productivity. We were under pressure to produce this first project, and prove that Rails was going to be a viable option for us going forward, so I made the call to suspend TDD for this project.

Some of you may call this a weak decision, and I totally get that. However, I had to make a choice, and the choice was very difficult. At the end, I chose to suspend a practice that we believe strongly in to get some velocity on learning all this new stuff and producing code.

By the end of the project, we were feeling the pain of a no-test environment. We got through it, and once again we definitely produced some working, amazing (to the user) software. But the combination of not being experienced with ruby and rails and not having tests took its toll toward the end as we found ourselves struggling to maintain and add to what we had done.

### Asking for help

After the successful completion of the pilot project, we knew we would be moving forward with rails for a major web project that would have a big impact on the business.

We also knew we didn&#8217;t want to move forward with this major project without having our BFF TDD at our side, so we needed help to bootstrap the practice in ruby and rails to match what we did in c# and .net.

We started going down the road of learning RSpec and using Cucumber for acceptance testing, but the workflow felt foreign to us, and we weren&#8217;t able to find a rhythm that we liked.

We called Scott Bellware and brought him down to give a day of intense training for the full team in context/specification for rails with RSpec and Selenium.

Scott came in and gave us a great day of training and helped us solidify our practices in web testing and TDD for ruby and rails. By the end of the day we were all exhausted, but we had a great start down what we felt was the right path (I owe you a guest post on this too Scott, I haven&#8217;t forgotten).

Now this new project is moving forward rapidly, with TDD happening. The spot we&#8217;ve found that we like (for now) is that we do c/s in rspec for models, but don&#8217;t really TDD our controllers. The controllers get tested by the higher level selenium-driven scenario tests, and if they&#8217;re being constructed right, they should just be middlemanning things between the view and the model. We write the selenium scenarios in c/s style ahead of time to drive out what&#8217;s expected to happen, so for us, this practice appears to be working fairly well. I think we will be revisiting it however, in the spirit of continuous improvement, as we come up against places where we have holes in the practice.

### Wrapping it up

So, the TLDR version: we didn&#8217;t always do TDD, and we had a lot of false starts along the way. I learned that it takes a lot of hands-on leadership to get it rolling, not just directive. If I had to do it over again, pairing practice would have been in place first, because it would have made it a TON easier. I also would have made sure that I was more in a place with my personal knowledge and experience of the practice before foisting it upon my team.

The practice has evolved massively over the last 4 or 5 years, and it has not been easy. But it has been worth it. This is anecdotal. I have no real numbers for you. But I do know that the pulse of my team is that life is better with TDD than without, and in the case where someone goes off on their own and does something without it, they usually come back when they have to maintain or extend it and say &#8220;man, I wish I had done TDD here&#8221;. To me, that&#8217;s proof enough.

<!-- Technorati Tags Start -->

Technorati Tags:
  
<a href="http://technorati.com/tag/how                   3e                   7o                  11t" rel="tag">how we do it</a>, <a href="http://technorati.com/tag/improvement" rel="tag">improvement</a>, <a href="http://technorati.com/tag/lean" rel="tag">lean</a>, <a href="http://technorati.com/tag/management" rel="tag">management</a>, <a href="http://technorati.com/tag/quality" rel="tag">quality</a>, <a href="http://technorati.com/tag/software" rel="tag">software</a>, <a href="http://technorati.com/tag/team" rel="tag">team</a>, <a href="http://technorati.com/tag/planning" rel="tag">planning</a>, <a href="http://technorati.com/tag/tdd" rel="tag">tdd</a>, <a href="http://technorati.com/tag/bdd" rel="tag">bdd</a>, <a href="http://technorati.com/tag/testing" rel="tag">testing</a> 

<!-- Technorati Tags End -->