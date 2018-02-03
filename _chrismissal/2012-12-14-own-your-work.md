---
wordpress_id: 358
title: Own Your Work
date: 2012-12-14T07:50:30+00:00
author: Chris Missal
layout: post
wordpress_guid: http://lostechies.com/chrismissal/?p=358
dsq_thread_id:
  - "973622456"
categories:
  - Best Practices
  - Continuous Integration
  - Deployment
  - SOLID
  - Testing
tags:
  - collective code ownership
  - continuous deployment
  - continuous integration
  - links
  - refactoring
  - testing
---
This post is mostly here to share a link. [Jeremy Miller](https://twitter.com/jeremydmiller) posted &#8216;[&#8220;Code Complete&#8221; is a polite fiction, &#8220;Done, done, done&#8221; is the hard truth](http://jeremydmiller.com/2012/12/13/code-complete-is-a-polite-fiction-done-done-done-is-the-hard-truth/ "“Code Complete” is a polite fiction, “Done, done, done” is the hard truth")&#8216;. Before clicking through I thought I was going to disagree. After reading through, I agree 100%.

Read it first, it&#8217;s not long&#8230;

Done? Now my take on this:

**Stop being lazy!** I have been in places where the process has become one where you take the requirements from somebody else, do your best to deliver, and then throw it over the fence for QA, testing, or whoever. In my experience, this makes people less accountable for what gets pushed to production.

**Own your work**. Some of the best quality I have ever provided was in an environment where I was the one in charge of understanding problem, coming up with the <del>best</del> appropriate solution, and watching it all the way to production and eventually, the user.

The key ingredients to this recipe for success:

  1. **Quality tests** &#8211; sometimes TDD, sometimes test first, and sometimes test after.
  2. **Refactor to your heart&#8217;s content** &#8211; if you&#8217;re afraid to change code because it might break something, you have problems. Follow [SOLID principles](http://lostechies.com/chadmyers/2008/03/08/pablo-s-topic-of-the-month-march-solid-principles/ "S.O.L.I.D.") as best as you responsibly can and you&#8217;ll have fewer problems here.
  3. **Continuous integration** &#8211; make sure everything is working all the time. It helps in the long run (and by long run, I mean tomorrow). Oh, and by CI, I mean CI done right.
  4. **Collective code ownership** &#8211; everybody owns this feature; it&#8217;s not just my own. a.k.a. No [silos](http://en.wikipedia.org/wiki/Information_silo). Also, your victories must be shared, but your failures are also not your own.
  5. **Deploy early and often** &#8211; The best time to deploy a feature is the moment it&#8217;s declared &#8220;Done&#8221; (or Done, done, done). The longer the span between this time and delivery, the more likely it is to fail.

Your mileage may vary, but these have worked for me and I suggest you try them if you&#8217;re having trouble moving quality from concept to cash.