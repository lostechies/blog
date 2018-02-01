---
id: 445
title: The developer’s true goal
date: 2011-01-05T13:53:36+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2011/01/05/the-developer-s-true-goal.aspx
dsq_thread_id:
  - "264716624"
categories:
  - Process
---
Having been a part of several large, long-term products and projects, I’ve come to a bit of an epiphany on what our goal as developers truly is.&#160; For the longest time, I believed that our goal was to write **good** software.&#160; That was a little nebulous, so you start to see distillations towards **high quality** or **maintainable** software.

All of these miss the mark.&#160; Our true goal is to **write as little software as possible**.&#160; In order to provide the highest long-term value to our customers, any solution should absolutely minimize the amount of software created.

Why should we minimize software?&#160; The most valuable software, most used software, easiest to change, maintain, understand, least complex all have one thing in common – they minimize the software developed as much as possible, but in a variety of ways.

### Bloat Sources

Traditionally, movements like software craftsmanship and even XP tend to focus on the engineering aspects of minimizing software.&#160; These are important sources, but focusing solely on these ignores more large sources of bloat.&#160; If we look further up the development pipeline, the requirements fed in to the developer’s process, we can also see sources of bloat from:

  * Complex features
  * Worthless features
  * Confusing features
  * Gold-plating

Complex, confusing and worthless features are those that won’t be used by the end user of the system.&#160; Additionally, complexity carries a maintenance cost that is often glossed over or ignored because of the assumption that complexity does not need to be re-learned when the component needs to change.

The bottom line is only the most important, most useful features should be developed.&#160; Everything else should not.&#160; Putting it in modern terms, the joke about the “new twitter” page is that the “old twitter” page is what Steve Jobs would have created had he seen “new twitter”.&#160; Users want simplicity.&#160; Complexity leads to confusion, lost users and support calls.

### 

### Fighting Bloat

In our projects, we strive to fight code bloat with a two-pronged attack: **develop the minimum set of features to release to production, and with as little code duplication as is cost-effective given the constraints of the project**.

We can do as much research as we can to determine what features will be used, but that can vary from greenfield, new product development versus upgrading or replacing existing systems.&#160; But in either direction, if we focus on releasing usable production software, software that is actually used in production, we’ll optimize for the features that most of our users will use most of the time.&#160; For both greenfield and brownfield, those are going to be the most valuable features.&#160; _Side note – this is where many “rewrite” projects go awry – the assumption that ALL features have equal priority to be transplanted to the new system._

By opting for a more continuous delivery model, we can better adapt to changing users needs, as well as prioritize features for use in production.&#160; For existing systems, this can be a lot easier question to answer.&#160; When our teams look to replacing legacy systems, and these systems are ALREADY in production, it’s merely an exercise of profiling at all levels of the system to determine what modules/applications/databases etc. are being used.

On the flip side of the coin, fighting duplication removes bloat from code that we’ve already committed to writing or already exists.&#160; Fighting duplication is equally as critical as fighting feature bloat, but not more or less!&#160; The entire development pipeline from “[concept to cash](http://www.amazon.com/Implementing-Lean-Software-Development-Concept/dp/0321437381)” as it were is important to optimize, not just the middle, hands-on-the-keyboard stage.