---
wordpress_id: 26
title: Learning TDD
date: 2008-09-24T01:22:19+00:00
author: Ray Houston
layout: post
wordpress_guid: /blogs/rhouston/archive/2008/09/23/learning-tdd.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/rhouston/archive/2008/09/23/learning-tdd.aspx/"
---
Learning TDD takes time and can be especially tough if you don&#8217;t have an opportunity to work with folks that are already doing TDD. It requires you to think and work differently and there are many pitfalls along the way. I know that I&#8217;ve made a ton of mistakes.

When I started working with automated testing, I was writing tests that hit the database. They were big, slow and complex and required a lot of maintenance to keep the data population scripts in check. The tests were very fragile and it seemed like it was almost a full time job to keep them going. At the time, I thought that doing TDD was just about writing your tests first so I tried doing it, but it was just too hard because I wasn&#8217;t writing my code in a manner that could be tested easily.

Next I learned about dependency injection and IoC containers which allowed me to decouple my classes and test them in isolation. I learned how to create a mock instance of an interface and pass it into the classes that I was testing to see if they interacted with it properly. This was a million times better than the tests that ran against the database, but I still wasn&#8217;t doing it right. I wrote all my tests as interaction tests (versus state base tests) and I ended up with a big mess of fragile unreadable tests that gave me very little feed back to the source of problems when they occurred. Refactoring was painful because I&#8217;d have to go fix a ton of tests that I could no longer understand what they were trying to test in the first place.

There are a lot of other mistakes that I&#8217;m forgetting right now (or just too embarrassed to mention) and I&#8217;m sure there are tons of other people who have made the same ones. As [Jimmy pointed out](https://lostechies.com/blogs/jimmy_bogard/archive/2008/09/21/ten-tips-to-maximize-the-return-on-your-tdd-investment.aspx), hiring a good coach can be well worth it in avoiding some of the mistakes like I made.

If you&#8217;re interested in talking with other folks about TDD, [Los Techies](https://lostechies.com/) is hosting a free event in Austin, TX called &#8220;Pablo&#8217;s Days of TDD&#8221; (PDoTDD). It will be held on Friday October 3rd, 2008 from 2PM-5PM and Saturday, October 4th, 2008 from 9AM to 5PM. This event is for all levels from beginners to masters and will include workshops, discussion, practice, and training around automated unit testing, specifically the practice of TDD. For more information, please see Chad&#8217;s post [here](https://lostechies.com/blogs/chad_myers/archive/2008/09/15/announcing-pablo-s-days-of-tdd-in-austin-tx.aspx).

<div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  Technorati Tags: <a href="http://technorati.com/tags/TDD" rel="tag">TDD</a>
</div>