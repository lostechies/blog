---
wordpress_id: 29
title: 'Udi&#8217;s SOA Class Made Me Smart'
date: 2008-10-26T16:07:41+00:00
author: Ray Houston
layout: post
wordpress_guid: /blogs/rhouston/archive/2008/10/26/udi-s-soa-class-made-me-smart.aspx
categories:
  - SOA
---
[Chris](http://www.lostechies.com/blogs/chris_patterson) challenged me to write a post showing how smart I am after taking the class. 😉 While I know that &#8220;made me smart&#8221; is completely unbelievable, I did manage learn a great deal.

I&#8217;m slow to getting around to this post, but little over a week ago I finished up [Udi Dahan&#8217;s](http://www.udidahan.com/) week long class called &#8220;Advanced Distributed Systems Design using SOA & DDD&#8221;. As [Aaron](http://codebetter.com/blogs/aaron.jensen/archive/2008/10/19/udi-dahan-s-soa-bootcamp.aspx) has already stated, it was awesome. The class was very well put together. The materials were clear and concise and Udi did a fantastic job presenting it. It was a good mixture of lecture, coding, and question and answer. I fully expected that I would be taking notes like crazy, but it was so well laid out that the only thing I wrote down the entire course was what I wanted for lunch. Udi provided us with all the lecture materials and everyone has access to all of the samples which are in the [nServiceBus](http://www.nservicebus.com/) trunk.

Now I know why Udi is the &#8220;Software Simplist.&#8221; I was amazed to find that all the code and solutions were indeed very simple. Your day to day DDD code doesn&#8217;t change (if you&#8217;re doing it well). All the hard stuff is dealt with at the bus level. You as the architect need to know what&#8217;s going on so that you can apply the patterns appropriately, but a developer in the domain should not be writing code that deals with things like threading. If you are, you&#8217;re doing it wrong. The patterns that Udi presented keep things simple by isolating complexity so that it doesn&#8217;t creep into your day to day code. The domain code looks the same if it&#8217;s running in a single process or if it&#8217;s running in 100 processes.

Udi kept saying that the code is simple, but defining the right boundaries is the hard part. Often the questions we gave Udi were solved by diving deeper into the real business requirement and giving the business choices as to what their requirements really mean in terms of performance, latency, durability, etc. You get into trouble when you try to make a technical problem out of what should be a business decision.

Two great quotes from the lecture materials:

> _Best practices have yet to catch up to &#8220;best thinking&#8221;_
> 
> _Technology cannot solve all problems_

Good SOA is not about applying one single thing over and over again. It&#8217;s about knowing your requirements, your options, and planning accordingly. I feel lucky that I got to spend a week with Udi and absorb some of this. I highly recommend that you attend his class if your doing or thinking of doing distributed systems.

In the coming months, I plan to start working on some SOA projects at [TOPAZ](http://wwww.topazti.com) and applying what I have learned. I hope to be able to blog about my experience and that Udi will correct me when I say something incorrect. 😉