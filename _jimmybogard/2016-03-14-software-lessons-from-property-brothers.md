---
id: 1178
title: Software Lessons from Property Brothers
date: 2016-03-14T21:00:59+00:00
author: Jimmy Bogard
layout: post
guid: https://lostechies.com/jimmybogard/?p=1178
dsq_thread_id:
  - "4662740881"
categories:
  - Agile
  - Architecture
---
Yes, I know the “software is like construction” metaphor has been overplayed, but hear me out here. One of my guilty pleasures is a home improvement show on HGTV, Property Brothers. The show covers a home buyer who wants the house of their dreams, and renovates an older, more affordable home to do so. The gimmick is it’s one twin that helps the home buyer select a house to purchase, and the other to renovate it.

### 

### Scoping Phase

The show starts off with Drew (the Realtor) working with the home buyers for their “must-haves” in their ideal home, as well as their max all-in budget. Typically this list is something like:

  * Open floor plan
  * Hardwood floors/granite countertops
  * Big chef-style kitchen
  * Spacious master bedroom/walk-in closet/master bath
  * Big yard
  * Man cave (but never a woman cave because reasons)
  * X many extra bedrooms and Y bathrooms
  * Location close to work/family/city

Drew then takes them to a house that meets every single one of their criteria. The homeowners fall in love with this house, seeing a move-in ready home that has everything they want. Then Drew asks them, “how much do you think this house is on the market for”.

At this point I wonder if the homeowners are universally idiots, having done zero research or it’s just the Magic Of Television. The homeowners will guess a price maybe 10-20% more than their max budget. Drew then does the reveal of a price at a minimum of 50% over budget, sometimes 100-200% over. They’re looking for a dream house of $500K but in reality it would cost $750K and up.

This serves not to shock the homeowners, but to **reset expectations**. If the homeowners want the perfect house in the perfect location, they’ll have to pay a lot for it.

We have to do this quite a bit in software development. Reset expectations of what someone thinks they can get for a certain amount of dollars/time/people to what is actually attainable. And like home renovations, throwing more people at the problem won’t necessarily speed things up, there is a physical constraint in the space you’re working in as well as dependencies between steps (can’t paint the walls until you actually build the walls). You can’t easily parallelize work, and when you do, there’s a lot of management/coordination overhead to doing so.

### Design Phase

Once the homeowner picks a “fixer upper”, Jonathan, the other twin and licensed contractor, takes over and directs the renovation of the house. He goes over a proposed design (that’s not exact on the little things but on the bigger things like where bathrooms should be) and budget. He works in a contingency budget, typically 10-20% of the overall budget, that he saves for “nice to haves”.

The proposed design is interesting in that it parallels a lot of the architectural and design decisions we make up front in software. We work out the hard problems that are hard to change, architecture, and provide a vision of the design typically through a couple of wire framed interactions along with a style guide. Nothing is set in stone, and Jonathan’s design shows colors, furniture and the like but none of the cosmetics are set in stone. These are the items that wouldn’t really affect the overall budget but get an idea of what the final design would look like.

### Implementation Phase

Once the homeowner picks a house, they put in an offer and through the Magic Of Television have the offer accepted. Although not always, sometimes the homeowners decide they know how to negotiate better than a professional, tell Drew to put in an insultingly low offer and it gets rejected without a counter and the homeowners are disappointed (to my chagrin). But a house is eventually purchased, and the project moves to demolition and renovation.

Inevitably curve balls are thrown in. A wall they wanted to open up turns out to be load bearing, and the owners have to decide to keep the wall, or put in a supporting beam at the cost of trading off some other element. It’s always tradeoffs, and it’s always in the homeowner’s court to decide what they would like to trade off. The contractor tries to hold them to their budget, because typically no one is happy if they spent more than they planned (even if in the moment it seems like a good idea).

Individual elements can be decided as they go, such as what kind of cabinets, flooring, furniture and the like, but the big decisions on how the rooms and plumbing should be laid out are decided up front. It’s just too costly to change these later. We see this in our projects, too. You could go the route of building small prototypes/services/whatever and expect to throw them away, but these still cost time and money to build. It’s worth instead taking some time up front to evaluate priorities and make some decisions on the big choices, but deferring the smaller decisions until you’re really forced to – the last responsible moment.

The metaphor isn’t perfect, but it does at least serve as a common reference/talking point when trying to explain how software design and development works, in a way that brings the client along with the process, keeps them involved but shepherds them along a well-worn path to success.