---
wordpress_id: 488
title: From sprints to pull-based flow
date: 2011-05-13T14:17:47+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/05/13/from-sprints-to-pull-based-flow/
dsq_thread_id:
  - "302801933"
categories:
  - Agile
---
In the last post, I talked about a large, long-term agile project and how we [consolidated individual teams’ story flows into one, big story wall](https://lostechies.com/jimmybogard/2011/05/12/visualizing-the-entire-flow/). All teams were now united into one visible process for getting a story from inception to “done”. In the lean literature I’ve gone through, “done” really means “in production”, but in our case that wasn’t possible (more on that later).

Once we had the entire flow visible and “correct”, in that it actually represented the real flow of a story as well as the real “current state” of the entire story delivery system, we were able to make more informed decisions about the true health of the project. We had a lot of speculation about which areas were slowing down, needed tweaking and so on, but it wasn’t until we saw the entire pipeline that some obvious truths came to light.

### Segregated workflows

One situation that our dev team knew was a problem was that we would often be starved for work. Because we were performing work in 1-week timeboxed sprints, we often saw that at the end of the sprint, our story wall would look like:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/05/image_thumb3.png" width="644" height="345" />](https://lostechies.com/content/jimmybogard/uploads/2011/05/image3.png)

The stories would be pretty much done, with the exception of them being accepted by the product owners and stakeholders. Our team would have to find work to do, usually around refactoring, optimizations and the like. But this was completely obscure to the product owners, so we adopted a model where the product owners could introduce “tweak stories” into the process.

Tweak stories were things like “adjust the spacing” or “move this field” that would take less than an hour to accomplish. We found two problems with this:

  * It allowed a back door for anyone to increase the scope of the project
  * The tweak stories were worked on ahead of other real stories, artificially increasing the tweak story’s priority

### Pulling stories early

The dev team knew this was a problem, but the lack of a complete vision of the entire pipeline prevented us from bringing up that question in an appropriate setting. However, with a combined flow, our wall in the above scenario looked like this (other before/after stages removed):

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/05/image_thumb4.png" width="629" height="317" />](https://lostechies.com/content/jimmybogard/uploads/2011/05/image4.png)

Tweak stories were in a different flow altogether. At this point, we had the entire vision of the story production pipeline, so it became much easier to introduce a pull-based story workflow. At the daily stand up, I asked the question to the executive sponsor, “We have some development capacity and idle developers. Should we work on these tweak stories, or work on one of these stories ready for development?”.

Absolutely a no-brainer on that one. I didn’t get the question fully out before the answer came “work on a story”. And that’s how we introduced pull-based flow into our scrum-based workflow. We formulated the language around “pulling stories early” rather than “let’s ditch sprints”, to make the transition to pull-based flow more palatable for everyone.

_Side note – changing processes can be a big deal to a lot of people. Good communication skills in this area is VERY IMPORTANT to maintaining the trust of all parties involved._

By pulling stories in early, we were able to adopt a more continuous flow of stories, while still maintaining our contractual obligations to commit to stories for each sprint. But instead of sitting idle or allowing feature requests to subvert the story process, a unified view allowed us to fully realize the maximum throughput of producing stories.