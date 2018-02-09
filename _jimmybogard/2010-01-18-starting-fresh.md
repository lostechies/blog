---
wordpress_id: 383
title: Starting fresh
date: 2010-01-18T15:12:51+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/01/18/starting-fresh.aspx
dsq_thread_id:
  - "264716397"
categories:
  - Design
redirect_from: "/blogs/jimmy_bogard/archive/2010/01/18/starting-fresh.aspx/"
---
While prepping for the Headspring MVC Boot Camp last week, I had a couple of choices for getting the examples project up and going.&#160; I wanted the examples to use an actual domain model, a real IoC tool, and a real ORM underneath the covers.&#160; Getting these pieces up and going isn’t necessarily a trivial affair, and time spent doing that is time taken away from preparing the other parts of the course.&#160; So I had two options: The first option would be to take an existing application and pare away the pieces I don’t need.&#160; The second option would be to bite the bullet and just start from scratch.

So what did I wind up doing?&#160; (Drumroll please)&#160; **Start from scratch**.

And it was _sooooooo_ liberating.&#160; With our existing applications, there’s always one piece or another that doesn’t fit quite right, but you don’t change because “it’s how things are done” or “it already works”.&#160; That’s great for a lot of solutions, but I’m now seeing is a poor choice for micro-design solutions.&#160; For example, I don’t really want to design templated HTML builders for every project, nor do I want to design an object-object mapper every time either.&#160; Those types of pieces can be abstracted into mini-frameworks to consume.

But then you have things like “how to use NHibernate”, the default Repository design, the “right way” to read from files and so on.&#160; For those pieces, I just tossed out _everything_ and started over.&#160; As in, let’s completely re-evaluate how I use these 3rd-party libraries and how I’ve solved these problems in the past.&#160; I wound up with a completely different design than I’ve used before, and one that I like better than ones I’ve used in the past.&#160; Had I merely incrementally improved my existing approach, I wouldn’t have arrived at the point I used in the class.

Incremental design doesn’t just mean making small changes to one class.&#160; Incremental design isn’t merely incremental change.&#160; Sometimes, you just need to throw everything out, build on what you’ve learned, and take a clean approach to get to a better final design.

Existing code is baggage, be careful how much you pull from previous projects and existing work.&#160; While it can be tempting to try and set a high starting point, it may set you back in the long run.&#160; On our current project, we held ourselves back for quite a while by sticking with designs we did not consciously choose in the first place.&#160; Once we got over our fear of change, we landed in a much better place than where we started.

However liberating this was, **it’s still not one I’d do on every project**.&#160; For smaller projects, it’s great to have an existing infrastructure in place so you can start delivering value on day 1.&#160; But for longer-term projects, where only innovation will keep your velocity from stagnating or even dropping over time, we found that only by throwing out our existing prejudices and assumptions could we have the right state of mind to truly embrace change.