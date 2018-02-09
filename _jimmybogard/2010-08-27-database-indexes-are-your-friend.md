---
wordpress_id: 430
title: Database indexes are your friend
date: 2010-08-27T02:47:25+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/08/26/database-indexes-are-your-friend.aspx
dsq_thread_id:
  - "265688334"
categories:
  - Misc
redirect_from: "/blogs/jimmy_bogard/archive/2010/08/26/database-indexes-are-your-friend.aspx/"
---
I guess I assumed that creating a foreign key constraint would automatically create a non-clustered index.&#160; I mean, a primary key _is_ a clustered index, why wouldn’t a foreign key also create an index?

A batch process today slowed from completing in about 4 hours to an estimated completion time of around 3 days.&#160; Since this was a process that needed to complete daily, well obviously it should complete in less than a day.&#160; First order of business was looking at the profiler to see what was going on.

It was exactly one SELECT statement per transaction, no joins, and one predicate in the WHERE clause, on a foreign key.&#160; And it took an average of 23 seconds to execute.&#160; Yikes.

Next up was checking the execution plan and statistics.&#160; This was on a table that doubled in size in one day, to 7 million rows.&#160; The culprit naturally was a table scan, and the 230K reads showed why the query took so long.&#160; A coworker pointed out that the statistics plan also provided a hint for performance tuning, to add an index.

I really couldn’t believe the foreign key didn’t have an index, but sure enough, it didn’t.&#160; Added the index on the foreign key, and the query time was reduced from 23 seconds to nearly instantaneous, 2-3 orders of magnitude better.

And that 4 hour batch process?&#160; It finished in about 5 minutes.

Yes, database indexes are your friend.&#160; Assuming database indexes are already in place, not your friend.

\*sigh\*