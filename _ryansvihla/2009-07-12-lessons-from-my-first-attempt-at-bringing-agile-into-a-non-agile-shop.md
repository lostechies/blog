---
id: 22
title: Lessons From My First Attempt At Bringing Agile Into A Non-Agile shop.
date: 2009-07-12T07:06:08+00:00
author: Ryan Svihla
layout: post
guid: /blogs/rssvihla/archive/2009/07/12/lessons-from-my-first-attempt-at-bringing-agile-into-a-non-agile-shop.aspx
dsq_thread_id:
  - "425624250"
categories:
  - Agile
  - lean
---
Since I’m moving on from my current employer I figure now is a great time to share my post-mortem of my time there, specifically what worked, what didn’t and what did I learn.

### 

### Iterations Of Any Length

We tried 3 weeks, 2 weeks, 1 week, monthly and eventually just sort of tossed the system out all together as our team got shrunk from 5 to 2.&#160; We did find get a fairly desirable result ultimately but more on that later.&#160; Ultimately our problem was especially as we got smaller, dealing with our “particular” realities made iterations tend to fall apart, we were spending a fair amount of time trying to torture ever more atomic stories together.&#160; Cutting iterations out all together and focusing on features being completed was MUCH more time effective for us.

### Continuous Integration 

We had 3 different build servers at various points. All worked well, and our scripts were build server agnostic enough to not take long to switch over. There was a bit of a learning curve with some projects and the build system (modular dll’s and app domains especially).&#160; While in the end this worked well for our purposes, I failed in sharing the knowledge here, and never figured out how to get other members of the team to get up to speed on the entire build server concept .&#160; 

Note: oddly no “build applet” was nearly as effective at letting people know the build failed as sending them an email automatically on failure. 

### TDD, BDD And Unit Testing

Very mixed bag here. I was successful in getting the concept of unit testing in, but not TDD.&#160; However, our tests still are not totally flexible, and the training to do that is significant (creates dependencies on a fair amount of knowledge not specifically related to testing).&#160; For my part it honestly took me a year to be able to write a test that was not brittle.&#160; 

I’m still a bit stumped how to get a typically trained Microsoft developer team to really dive into the concept of TDD, “writing the code you want” was met with blank stares.&#160; Data driven mindset was maintained to some degree throughout my time there.

BDD took me awhile to get something I felt comfortable with so I don’t think I trained with the proper approach. I emphasized specification and example a lot and for some reason this lead to everyone striving for functional tests.&#160; 

Finally, handing customers spec results was somewhat helpful. Still had some things “be fine” then “that’s not what I meant”, but it still cut down the amount of misunderstanding.

### SOLID Principles

This was the easiest thing overall. DIP and IoC was resisted heavily at first, but it was not much effort to come up with scenarios where it was patently obvious how much more flexible code became.&#160; I focused a ton of “different data sources” since we have a number of api’s we deal with that gave me the buy-in I needed.

SRP took a bit but once they got it they got it big (almost too well). Ultimately, I think the dev’s enjoyed having “another box to check off” as they finished each class.&#160; Resharper training also helped cut down the time to make classes and methods I believed this also had a role in SRP adoption. 

OCP came with focusing on IoC and DiP so heavily.

LSP only came up occasionally since we tended to have a lot of small classes.

### YAGNI And DRY

YAGNI &#8211; Always fought this myself, and correspondingly my team struggled with both as well.&#160; YAGNI by the end started to work just because I began stripping out all extra requirements full stop, and immediately stopping any development when “extra” features were added out of the blue by an enthusiastic developer. This took a heavy hand and vigilance, and convincing was less the issue than fighting habits developed over years.

DRY – Was especially rampant in our test code, and we had our bits of duplication across projects and different developers. Like our YAGNI violations I think this was years of habits holding us back.

### 

### Automated Acceptance Tests

Never got close. Not enough stakeholders were interested, the training on acceptance tests ran into the same problem I had with build scripts that no one understood systems enough to make this function properly unless I was involved heavily, and then breaks also required my involvement. Finally scrapped them and moved to specs and manual acceptance testing by the stakeholders that cared about it in the way that they cared about it.

### Release Frequently Release Often

The more we released the better it worked for us. For us there was a clear link between stakeholder satisfaction and frequent releases (10+ some weeks). I have a few theories about this:

  1. We had stakeholders with various levels of comfort on their subject matter. Domain experts that knew everything about their domain did not need as much “final product” feedback as some others, who really were only happy when they saw the end product after every request. 
  2. Most of our projects had few moving parts. The tendency of past development seems to have been drawn to complexity, even when the raw domain didn’t need it.&#160; Simple projects can be released more often when less moving parts are there to break.
  3. Our stakeholders seemed to be far more results driven than UI driven. We seemed to attract a lot of process driven people who were content with having a lousy limited UI as long as the file went out in the correct format. We could again release more often with a stubbed in UI without any real penalty, as ultimately they just wanted at least one front to back business case working.

### Summary

There is more that I’m sure that I’m missing that may be useful. In the end, I was disappointed in my attempt to move the shop to an Agile concept only because I was not able to spread the knowledge effectively. My inexperience at the time in Agile myself made it rougher on everyone else trying to learn from me.

If I had to do it over again, I’d focus on SOLID, YAGNI, DRY and training a systems administrator in build scripts (it’s just a hard skill set for the average MS developer), and of course release often. If I had focused on these things first the immediate dividends would have been far larger.&#160; Once they had the necessary engineering credentials, TDD would have been less of a time sink, and maybe we’d have had the discipline for Iterations.&#160; Someday I hope to have the opportunity to build an Agile team from scratch again.&#160; I’m grateful to my employer and my co-workers who gave me the opportunity to try and advance things forward (which we did, just not as far as I would have liked).