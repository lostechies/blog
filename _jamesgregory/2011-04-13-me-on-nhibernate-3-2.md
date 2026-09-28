---
wordpress_id: 21
title: Me on NHibernate 3.2
date: 2011-04-13T19:31:38+00:00
author: James Gregory
layout: post
wordpress_guid: http://lostechies.com/jamesgregory/?p=21
dsq_thread_id:
  - "278661441"
categories:
  - Uncategorized
tags:
  - fluent-nhibernate
  - NHibernate
---
> tl;dr No hard feelings. Life goes on. FNH is safe.

So, [NHibernate 3.2 comes with a Fluent Interface](http://fabiomaulo.blogspot.com/2011/04/nhibernate-32-part-2-mapping-by-code.html) (sorry Fabio, a &#8220;loquacious&#8221; interface), fluent configuration, and an externally available alternate mapping in the shape of [ConfORM](http://code.google.com/p/codeconform/). I made some remarks on Twitter earlier today which kicked up a bit of a storm (one I was notably absent from for the most part). I want to take a moment to articulate my thoughts a bit better, and clear up any misunderstandings.

This is not a coup d&#8217;état. I have been approached by the NHibernate guys before about collaborating—three years ago—but I declined. The reasons have been lost in time, but I do feel now that was perhaps a missed opportunity. Since that moment, there&#8217;s always been the overarching thought that there would eventually be an official NHibernate code-first interface. And here we are.

There, that should get rid of the sympathy vote and the rage faces. I brought it on myself.

Fluent NHibernate is not going anywhere. NHibernate is notorious for having an obtuse and unfriendly API, and nothing has changed in that respect; there&#8217;s still a place for Fluent NHibernate.

There was no way Fluent NHibernate would be merged in to NHibernate Core, before anyone asks. Our codebase is not in any shape to be integrated into anything. I definitely would not suggest that is a good solution to the problem; however, I do think they could&#8217;ve spent some time to design an interface which isn&#8217;t _completely unreadable_.

Few people recognise that an API—especially a Fluent Interface—is a user interface and should be designed like anything else the user interacts with. And we all know how good developers are at designing interfaces.

<p style="text-align:center">
  <a href="http://twitter.com/#!/jagregory/status/58117568505987072" title="Still can't decide about FNH. Got some fun ideas, but seems kinda pointless if they'll just get ripped into NH in the next version."><img src="/content/jamesgregory/uploads/2011/04/tweet1.png" /></a>
</p>

My thoughts now lie in whether there&#8217;s the need for me to continue devoting my time to a project which has been made somewhat redundant. By devoting, I mean contributing my weekends or evenings and everything in between.

People have approached me and said &#8220;but FNH is so much better!&#8221;—and yes it is—but it used to be 100% better than vanilla NHibernate, while now it&#8217;s only say 25% better. I could justify the time needed to create a framework that would drastically improve peoples development experience, but can I justify the time for one which&#8217;ll marginally improve their experience? That&#8217;s a harder sell to the fiancée.

<p style="text-align:center">
  <a href="http://twitter.com/#!/jagregory/status/58117849293656065" title="Can always be more agile and ahead of the curve, but I'd rather dedicate the effort to something that is valuable."><img src="/content/jamesgregory/uploads/2011/04/tweet2.png" /></a>
</p>

Fluent NHibernate is smaller and more flexible than NHibernate, it&#8217;s also more opinionated. I can easily keep ahead with innovative ideas and try experimental things out that NHibernate can&#8217;t; however, what&#8217;s to stop NHibernate 3.3 or 3.4 from implementing those ideas? Nothing, of course, and nor should there be.

The question is, do I want to be playing a game of cat and mouse with the elephant in the room? _(woah, mixed metaphors)_

No, I really do not. Competition is only fun when there&#8217;s something to gain. If this was a business and my livelihood was on the line, then of course I&#8217;d compete, but it&#8217;s not; instead, it&#8217;s my free time, and I gain time by not competing.

This is a burgeoning thought about my life in .Net in general, but is quite apt for Fluent NHibernate too: Do I continue to neglect my family life, my free time, and my other projects to make life easier for users on a platform—NHibernate in this case—which will inevitably reinvent anything (successful) I do?

I haven&#8217;t decided.

All that being said, I like Fluent NHibernate and more-so I like it&#8217;s users. Fluent NHibernate isn&#8217;t going anywhere, and you have my word I&#8217;m not going to just turn the lights off and be done with it.

There are two courses of action, and I&#8217;m undecided which I&#8217;ll be taking yet:

  1. Put Fluent NHibernate into maintenance mode and progressively hand-over responsibility to the community.
  2. Get my head down and knock out 2.0, and show the NHibernate guys how you should design a programmatic UI

I&#8217;m leaning towards the latter.

And that&#8217;s all I&#8217;m saying on the matter. Too frequent have these clogging of the Twitter tubes been.

I leave you with this thought:

<p style="text-align:center">
  <a href="" title="As much as I love OSS, I can't help but think that my time could've been spent doing something to get me closer to my millions. You know?"><img src="/content/jamesgregory/uploads/2011/04/tweet3.png" /></a>
</p>