---
wordpress_id: 431
title: Natural selection in IT
date: 2010-09-08T13:11:15+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/09/08/natural-selection-in-it.aspx
dsq_thread_id:
  - "264716574"
categories:
  - Agile
redirect_from: "/blogs/jimmy_bogard/archive/2010/09/08/natural-selection-in-it.aspx/"
---
Or, survival of the fittest.&#160; When I worked for a large IT organization a few years back, there was an effort to purge the company of what were referred to as “Client Supported Systems”.&#160; In other words, systems the business was using that weren’t maintained under the official IT umbrella.&#160; When the number of these applications was finally tallied, **the sheer volume was _staggering_**.&#160; Tens of thousands of micro applications around the business, helping to generate revenue or support the business in some way.&#160; This was in a Fortune 50 company whose business centered around technology.

At the time, it made a lot of sense to me that the business shouldn’t be running on applications that IT didn’t develop or support.&#160; It seemed rather dangerous to have potentially critical business processes designed outside of IT governance.&#160; Especially when activities like upgrades, deployments, monitoring and support can only really adequately be provided by IT, having 80 different ways of deploying an application can inflict rather serious costs when views in the large.

As a consulting company, we often get brought in to replace these “Client Supported Systems”.&#160; What’s always fun is finding out exactly how much these systems have woven their way into the fabric of a company’s critical business processes, and completely unintentionally.&#160; These systems were designed to solve a specific problem, solved them well, and grew as the value in these applications proved themselves over time.&#160; Quite frankly, it’s really quite amazing how far you can go with Office, VBA, COM and Excel macros.&#160; In one case, a VBA macro in Excel automated filling out online forms based on values in a spreadsheet.&#160; The whole time the IT personnel never knew why traffic spiked at very specific hours during the day, simply because it wasn’t possible for the number of people to physically fill out those forms that quickly.

But I’m starting to see a different take than the old IT department I used to work for.&#160; Instead of squashing these systems, I think there should be an environment of fostering these application’s growth, usage, and then later transition to IT-build and supported applications.

### Incubating innovation

In a heavily-centralized IT organization, a business unit must go through IT to acquire resources (people + infrastructure) to build an application or system.&#160; IT, being constrained on resources, must then decide which applications to build, which to support, and which to retire.&#160; This is often called “portfolio management”.&#160; The business unit must then basically prove to IT (or whoever governs portfolio management) that this not-yet-existing application is worth developing.

This can be done by forecasting revenue gained, cost savings and so on, but in my experience these numbers were often very optimistically estimated, yet rarely measured.&#160; It was a game of who could paint the best picture of the benefits of their application.&#160; IT also has a say in things, as they could lay down the hammer of risk incurred, staying away from riskier or more nebulous requirements by painting a picture of higher risk.

<img style="margin-left: 0px;margin-right: 0px" align="right" src="http://www.moviemobsters.com/wp-content/uploads/2009/11/jeff_goldblum.jpg" width="197" height="240" />What inevitably happens is that the business unit mirrors nature, and **“life…finds a way”**. 

Application development on the frontlines of the business can often be speculative work.&#160; Some ideas work, some ideas don’t.&#160; It can be quite difficult to know what will work and won’t work before actually trying it out.&#160; IT organizations simply aren’t equipped for this highly iterative, highly communicative, highly involved line of work.&#160; **Nor should they be.**

It would be highly wasteful for IT to try and bend to the demands of every business unit’s whim.&#160; The applications we have typically replaced **do not have any kind of predictable growth over time, nor could their value have in any way been predicted from the onset.**

If the some of the most valuable business applications to an organization cannot be predictably designed, how can we ensure their creation?&#160; By creating an incubator for innovation, and actually encouraging the business to use technology to find ways of being more productive, increasing revenue, lowering cost and expanding business opportunities, with our without IT’s involvement.

### Passing the torch

Incubating innovation is all well and good, but eventually these kinds of applications, if successful, outgrow their skins very quickly and sharply.&#160; The technologies that allow non-technical business people to build applications just aren’t built for long-term, sustainable, scalable development.&#160; **Nor should they be.**

A single Excel application going against a shared Access database is fine for a handful of users, but it’s not a system that scales to more than a dozen or so users.&#160; The transition to an application that supports dozens of users, or large numbers of records, or more complex business functions is better suited for actual application development in frameworks like .NET.

Unfortunately, the business often sees these original applications as a liability, or even worse, a sunk cost.&#160; The question is asked “how much time do we spend maintaining this app?” or “this critical app is running under Bob’s desk?” or “you mean this database is NEVER BACKED UP?!?!”&#160; If every application needed IT to back it up, how much innovation would be squashed?

The business then tries to salvage the code in the interest of reducing cost, or the perception that the new application is a “rewrite”.&#160; **This** **glosses over the most important values extracted from these applications**:

  * Proven business value
  * Concrete behavior, open to characterization
  * Explicit system boundaries

In short, we have a system that has proven its worth, and an explicit list of behavior, features and interactions on _why_ the system has proven its worth.&#160; It’s a blueprint for success.

The mistake comes when the business tries to use the code from the original client-supported system.&#160; Don’t do it.&#160; **Throw away the code, keep the requirements.**&#160; Requirements are far, far more valuable than code.&#160; You rewrite the code to build the system right, you characterize the existing application to build the right system.

And any time a software vendor promises to improve this transition by “improving” the business-built application through code gen, they’re missing the point.

### Survival of the fittest

<img style="margin-left: 0px;margin-right: 0px" align="left" src="http://blog.ponoko.com/wp-content/uploads/2008/12/homer-car.gif" width="240" height="137" />Unlike actual biological evolution, software systems don’t evolve well over time into completely new organisms.&#160; Instead, evolution tends to follow the Homer car.&#160; **New features are added until simplicity is lost**, and you have some kind of monstrosity where each individual feature seems important, yet the sum total is a hot mess.

Systems do evolve and change over time, but it is important to gauge when the existing system has outgrown the constraints of the architecture it’s built upon, and transition into a different architecture.&#160; Architecture can evolve, but in many platforms, architecture is pretty much locked in from the outset.&#160; You can’t really evolve an Access application to support an entire division.&#160; However, **not every Access application built needs to support an entire division,** so why would we want to build these applications up to such standards?&#160; It doesn’t make any business sense.

For IT to continue to be relevant, it has to stop squashing business innovation, stop asserting its control through games of risk, and embrace an order of natural selection.&#160; The best business applications will prove themselves to be so, and it’s up to IT to transition these applications to a supported, stable and scalable platform.&#160; It’s up to the business not to paint the original application as a sunk cost, or lament over a “rewrite”.&#160; **Software is easy.&#160; Requirements are hard**.