---
id: 135
title: Best tool for the job
date: 2008-01-28T13:18:55+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/01/28/best-tool-for-the-job.aspx
dsq_thread_id:
  - "265665631"
categories:
  - Agile
  - Tools
---
I&#8217;m not sure if this is a trap, but I find myself doing this more and more.&nbsp; Let&#8217;s say you have a short (less than 2 weeks) project to work on, and maybe it&#8217;s for a church website or something similar.&nbsp; Non-business critical, but the customer wants it to look nice, wants it simple, and doesn&#8217;t want to pay much (or anything) for it.

You have two choices for the application architecture.&nbsp; One is the Evans&#8217; style, the &#8220;new default architecture&#8221; that has a nice layered approach to it.&nbsp; The other is to use lots of WYSIWYG designer tools, such as LINQ to SQL, that can get you up and running quickly.

What I tend to do is opt for the more complex architecture _first_, even though the customer explicitly doesn&#8217;t need it.&nbsp; [YAGNI](http://c2.com/xp/YouArentGonnaNeedIt.html) tells me that I should opt for the cheaper architecture, and add complexity when required.&nbsp; Pragmatism tells me that it&#8217;s difficult to switch the entire architecture of an application.&nbsp; It&#8217;s difficult to switch from designer-based infrastructure to something more robust like NHibernate.

To make it easy to move away from LINQ to SQL, I&#8217;d need to abstract away my interactions with that library so I can switch it out for something else.&nbsp; The problem is that it&#8217;s just as much work to implement a layered approach as it is to try an abstract away LINQ to SQL.

And this is my dilemma: **By locking myself in to a less flexible technology, I&#8217;ve limited the future complexity my solution can handle**.&nbsp; Even though LINQ to SQL is great for forms-over-data, I can&#8217;t predict what my church website might need in the future.&nbsp; Since customer&#8217;s needs always change, how can I guess about future complexity?

I don&#8217;t really know if my customer will need more complexity in the future, but I assume they will.&nbsp; If the customer needs more complexity, and the architecture can&#8217;t handle it, I&#8217;m stuck re-writing significant portions of the application to use NHibernate instead.

Even though NHibernate isn&#8217;t always the simplest thing that could possibly work, I find myself opting to use it first as I know it can handle future complexity much better than the alternatives.