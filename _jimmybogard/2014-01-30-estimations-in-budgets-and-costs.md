---
wordpress_id: 853
title: Estimations in budgets and costs
date: 2014-01-30T14:44:05+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=853
dsq_thread_id:
  - "2195453112"
categories:
  - Agile
---
It’s been many years since I’ve estimated feature effort in meaningless measurements, such as “story points” or “feature points”, and this makes me quite happy. Several years ago, on a long agile project, we estimated all effort in points. But nobody knew what that meant. What is a point? How do you know what a point is? Relative complexity? We heard comments describing this process as a “Shell Game”.

Ultimately, our currency is time. Looking at the iron triangle, where we see “schedule”, the only true constant is time:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2014/01/image_thumb.png" width="534" height="335" />](http://lostechies.com/jimmybogard/files/2014/01/image.png)

I’ve seen budgets change, I’ve seen scope added and removed, but I’ve rarely seen a deadline extended. And unless a we’re traveling a significant percentage of the speed of light, we can’t really stretch our time.

Yet I meet many teams that still estimate in points. But to anyone that actually writes a check, a point is meaningless. Teams have a known cost in salary, and the salary is paid on a periodic basis. We can calculate with great certainty the cost of a developer. Those approving projects and budgets deal in dollars and cents. Coming to them with the cost of software in imaginary points is a quick way to get laughed out of the room.

Instead, I want to deal in concretes. Hours or dollars. How much is this feature expected to cost me? Points vary over time. What was complex last month might be easy this month. Time doesn’t change, however. If the people approving projects and budgets deal with dollars or time, our estimates should match their expectations and their realities, not our own fictional cost.

### Budgets and costs

Instead of thinking in terms of estimates, I want to deal in costs. How much is this feature going to cost me? How much should I allocate to specific areas?

When looking at personal finance, we generally deal in budgets. There’s a certain amount of income per month, and a certain amount of dollars we want to allocate to certain areas:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2014/01/image_thumb1.png" width="416" height="372" />](http://lostechies.com/jimmybogard/files/2014/01/image1.png)

We know we cannot exceed our total spend (there’s no credit in software development), but what we can play with is the relative amounts within each area. Software estimation works the same way. There are different areas of concern (reporting, administration, etc.) that can be given a certain amount of budget (time) within a certain scope of release. This budget can be made of either time or dollars, but those are effectively equivalent if we average salaries in our team.

From there, we start looking at costs of individual items. We don’t know _exactly_ what our electric bill may be this month, but we can make an educated guess, looking at past months. In estimating software features, we need two things to estimate well:

  * Small, understandable scope
  * Well understood, agreed upon design

Typically, I like a story to be flushed out well. “Card and a conversation” is OK for initial planning, but for deciding what to actually work on, lots of details need to be understood to get an accurate understanding of cost. For an item that costs 3 days of development, I might expect a day of design/elaboration/documentation. All parties involved need to have a shared expectation of what is to be delivered. Shared expectations means much, much less rework. I like my stories to be in a persistent medium, whether it’s a wiki, JIRA, Google Docs, whatever. A card on a wall can only really be a pointer to the real story, not the actual story itself. Small stories are important. If the estimate is over 2-3 days, it’s less accurate and more difficult to design, develop, test and generally agree upon.

Budget’s aren’t perfect, and neither are estimates. But the ultimate constant is our overall available time allocation. If bills are unexpectedly higher one month, we have less to spend on movies and entertainment. Similarly, our stories have priorities so that if something goes over, something gets pushed out. It’s the only sane way to maintain a sustainable pace. If something goes wildly over, we have a quick retrospective to understand why and how we can fix it (no need to wait for some periodic meeting to do so, have the conversation while the wound is fresh).

The cone of uncertainty still applies, which is why we talk in budgets instead of costs early on. I can’t know how much I’ll spend on a meal a year from now, but I can at least commit to a budget for a group of meals, and vary the scope of meals as I understand exactly where and when I’ll be eating.

Ultimately, points mean nothing. What we do have is dollars and time. By approaching estimation similar to budgeting, everyone, including stakeholders, can share a common understanding of costs and priorities. We can finally bypass tiresome arguments about what exactly a story point means.