---
wordpress_id: 4052
title: 'How We Do Things &#8211; Planning Part 2'
date: 2009-10-06T05:12:05+00:00
author: Scott Reynolds
layout: post
wordpress_guid: /blogs/scottcreynolds/archive/2009/10/06/how-we-do-things-planning-part-2.aspx
categories:
  - how we do it
  - lean
  - Management
  - software
  - team
redirect_from: "/blogs/scottcreynolds/archive/2009/10/06/how-we-do-things-planning-part-2.aspx/"
---
_This content comes solely from my experience, study, and a lot of trial and error (mostly error). I make no claims stating that which works for me will work for you. As with all things, your mileage may vary, and you will need to apply all knowledge through the filter of your context in order to strain out the good parts for you. Also, feel free to call BS on anything I say. I write this as much for me to learn as for you._

_This is part 3 of the [How We Do Things](https://lostechies.com/blogs/scottcreynolds/archive/2009/10/04/how-we-do-things-preamble-and-contents.aspx) series._

In the last post I talked about the various evolutions of planning the team has been through over the last few years. This post is about what we do now. Take a moment to read the last one to catch up on what the picture below is about.

### The Planning Space-Time Continuum

<div style="text-align:center">
  <img src="https://lostechies.com/content/scottreynolds/uploads/2011/03/planningtimeline.jpg" alt="planningtimeline.jpg" border="0" width="523" height="272" />
</div>

The basic gist here is that as items move from right to left they become more well-known, more defined, and more likely to actually be worked on.

### JIT Planning Next Work To Be Done

We&#8217;ve come to a point where we plan, basically, as much work as we need to plan to keep work in progress until the next time we want to plan. I&#8217;ll try to make that a little less esoteric.

We intend to plan a week&#8217;s worth of work at a time, give or take. The acceptable threshold is typically anywhere between 3 days and 8. Usually this takes the form of planning just one or two minimal marketable features (MMFs &#8211; more on these in another post) depending on size. There&#8217;s a lot of &#8220;feel&#8221; to this, and that feel stems from having established a pretty rhythmic workflow and from having same(ish)-sized stories (more on that in another post as well).

Mechanically, the planning meeting looks like this: representative team members (usually myself, one or more BAs, the developers that will work on the MMFs, and a QA person) will get together and go through the stories that need to get worked on next. We&#8217;ll do a story workshop of sorts where we flesh out details of acceptance criteria, surface any issues or further questions, actually plan out some tests, and determine if the stories are appropriately sized.

If any questions or blocking issues come up at this time we will deal with them then and there by either talking them out, or if necessary tracking down the right people to answer the questions. If we can&#8217;t get the answers right away we figure out if we can get started without them and trust that someone will have the answer by the time we get to that point. This will spin up a thread for a BA or myself to go track someone down in the lab or elsewhere in the organization, set up a meeting, and do that whole thing.

This planning is unscheduled and happens as needed. If we are running low on work today, we&#8217;ll schedule a planning meeting for tomorrow morning. They usually last no more than 30 minutes unless there&#8217;s a lot of design discussion to be had.

### Near-Term Planning &#8211; The Rolling Wave

<div style="text-align:center">
  <img src="https://lostechies.com/content/scottreynolds/uploads/2011/03/rollingwave.jpg" alt="rollingwave.jpg" border="0" width="375" height="250" />
</div>

The planning in the prior section is directly seeded by the planning done in this section. This is the next segment of the continuum to the right, and represents the picture of what we will probably be working on sometime in the next month.

This stage of planning doesn&#8217;t directly involve any developers or testers unless specific questions arise. At this point the BAs and I are sketching out the stories at a higher, not quite as detailed level, and stitching them together to form MMFs. We are figuring out what questions need to be asked and where these MMFs will fall in the slightly larger picture. Here is where we are evaluating priorities of features and roughly determining when they will be started. In short, we have about a month&#8217;s worth of stories, give or take, in states somewhere between fine and coarse-grained detail, with priorities, and we&#8217;re fairly confident that we will get to them in the next month. This is what a scrum team might call their product backlog.

This planning happens on a schedule every Monday morning. We go through requests, evaluate them, evaluate work in progress, and determine which stories to add finer detail to and queue up for the next work planning session.

This is a variation of [Rolling Wave planning](http://jrothman.com/blog/mpd/2004/05/rolling-wave-planning.html) in that we don&#8217;t necessarily keep the &#8220;wave&#8221; the same size at all times, and we don&#8217;t make detailed work plans for the items in the wave. There&#8217;s also no guarantee that items move linearly from the end of the wave toward the beginning as time passes, since we allow for priority shifts within this space. In some ways, it&#8217;s more like a rolling cloud than a rolling wave, but I don&#8217;t know if I&#8217;m qualified to make up a new project management term.

Some weeks, like this week, we may not bring any new stories into the wave at all. We may sit down, go through the backlog, look at work in progress, evaluate current conditions, and determine that we don&#8217;t need to spend any time adding more work to the wave. To me, this is perfectly acceptable in the spirit of eliminating waste. We aren&#8217;t adding more inventory when we don&#8217;t need it, and we aren&#8217;t wasting motion defining things when there&#8217;s no immediate requirement. Sometimes our wave can get as lean as to only have a week or two in it, and sometimes it can bloat up to 6 to 8 weeks. We use this wave as our buffer to adapt to changing conditions.

There&#8217;s a real chance that the work put into the wave last week will be superseded in priority by new work identified this week. We don&#8217;t push that other work out just because the priority changed, we just insert the higher priority stuff where it belongs. This accounts for the occasional bloating of the wave, and we compensate by not adding to it next time.

Sometimes there is no priority work to be brought into the wave, or no stories that we can get enough information on yet, so we just let it go for that week and let it shrink in size. If you&#8217;ll pardon the metaphor, we let the size of this backlog ebb and flow fluidly.

The picture of the wave at any given time allows us to make decisions about what work will be delayed if new priority work is identified, and we can share that easily with project stakeholders. Because we know that we&#8217;re talking about a month or so of work, we are able to make statements about timelines of work that has been specified in enough detail and given enough priority to be in the wave. This makes external parties much happier.

### The Roadmap

The sections farthest to the right are our next quarter/next year roadmap. This is where we would understand longer-running strategic initiatives or targets that we will ideally get to if, and only if, <em>current conditions remain the same.</em> This includes items from both the corporate initiatives roadmap, and our internal project roadmap. This could be anything from &#8220;In Q4 we are likely going to introduce a new product line&#8221; to &#8220;we&#8217;d really like to replace our hand-rolled data access with NHibernate.&#8221; We put this stuff on the roadmap to serve as the mile markers for where we (the organization, not just the developers) want to take our software.
</div>

Some items on the roadmap will very likely get implemented, and we may know it well in advance, but their priority or maybe external dependencies aren&#8217;t such that we could reliably be planning this work yet, so it goes out here to the right for the time being.

Some of the items on the roadmap could very well never get implemented. These aren&#8217;t just the &#8220;man it would be great if&#8230;&#8221; items, though those are on there. They are also the items that are totally valid, have strategic value, but somehow never seem to win the priority battle with other items. These are the items that usually end up becoming factors in the decision to increase staff or potentially purchase something.

Or maybe they are items that get totally replaced by something better. As an example, we had a project out here in this space for almost two years. Everyone wanted to do it. The business was hyped on it. They kept asking when we could get to it, and kept insisting it was going to be a key part of our service offerings. However, it never could beat out other priorities. In two years it never once won a priority battle. Recently we uncovered a vendor that would provide us with a 90% solution that would take mere weeks to integrate, versus what was looking like a multi-month project. The original target came off the list, replaced by the new hotness.

If we had spent any real time planning this project beyond a very basic understanding of its scope and keeping it as sort of an &#8216;idea bucket&#8217; that work would have been completely wasted. As it stands, no harm no foul.

### The Lie

The last part of the continuum I want to address is what we have affectionately dubbed &#8220;The Lie&#8221;. This is the point past which any projections you make on time/cost/when/where/who/how something will get done may as well have come from a magic 8 ball. When asked for this type of long-long-range (usually this is somewhere in the neighborhood of 6 months from now for us) information, we play it straight up. We say &#8220;this is a lie. what we are about to say will not come true at all.&#8221; For some reason we can get stakeholders to _accept and understand_ that it&#8217;s a lie, but we cannot get them to _stop asking_ for the lie. It boggles the mind. But whatever. We&#8217;re up front about it, and we refuse to be held to it. Part of effective planning is identifying the issues and constraints that will make the plan go astray, presenting those, and sticking to your guns when they happen.

_As a side note, I want to point out that these time thresholds we have come up with have been a moving target, and yours will differ based on the size of your team, how fast they work, the nature of your organization, and a ton of other factors. So just be prepared to experiment._

<!-- Technorati Tags Start -->

Technorati Tags:
  
<a href="http://technorati.com/tag/how                   2e                   6o                   1t" rel="tag">how we do it</a>, <a href="http://technorati.com/tag/improvement" rel="tag">improvement</a>, <a href="http://technorati.com/tag/lean" rel="tag">lean</a>, <a href="http://technorati.com/tag/management" rel="tag">management</a>, <a href="http://technorati.com/tag/quality" rel="tag">quality</a>, <a href="http://technorati.com/tag/software" rel="tag">software</a>, <a href="http://technorati.com/tag/team" rel="tag">team</a>, <a href="http://technorati.com/tag/planning" rel="tag">planning</a> 

<!-- Technorati Tags End -->
