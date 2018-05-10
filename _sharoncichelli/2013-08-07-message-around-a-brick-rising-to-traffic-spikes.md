---
wordpress_id: 215
title: 'Message around a brick: Rising to traffic spikes'
date: 2013-08-07T17:30:53+00:00
author: Sharon Cichelli
layout: post
wordpress_guid: http://lostechies.com/sharoncichelli/?p=215
dsq_thread_id:
  - "1582702286"
categories:
  - Uncategorized
tags:
  - Distributed
  - high-availability
  - messaging
  - SOA
---
[LEGO.com](http://www.lego.com/) impressed me with its ability to scale to handle a spike in traffic last Thursday. Seeing it through the lens of [Jimmy Bogard&#8217;s](https://lostechies.com/jimmybogard/) presentation &#8220;[Telephones and postcards: Our brave new world of messaging](http://vimeo.com/68327243),&#8221; I paid attention to what LEGO was doing to cope with our voracious demand for [DeLoreans](http://shop.lego.com/en-US/The-DeLorean-time-machine-21103).

The gist of Jimmy&#8217;s talk is that, when designing a messaging-based distributed system, look at real-world solutions for the same problem. _People_ can handle a full queue of orders for the fry cook; systems can follow the same patterns. His presentation gave me that brain-expandy-stretchy feeling when something obvious is being revealed in a non-obvious way that makes you look differently at problems and solutions. It&#8217;s a neat talk; check it out.

The much-anticipated Back to the Future set (with both a Marty and a Doc mini-fig!) went on sale August 1st. The evening of the 31st, I thought to myself, &#8220;It&#8217;s Thursday _somewhere_.&#8221; I wasn&#8217;t alone in this epiphany. The website was getting hammered. Everybody needs a DeLorean, apparently.

At check-out time, the page showed a message stating that, due to technical difficulties, it could take up to 24 hours to finalize my purchase. I was able to complete my transaction; then 9 hours later I got an email confirmation that the order had actually been placed. Because of Jimmy&#8217;s talk on real-world solutions for high-throughput systems, I thought: &#8220;Sure. Stack &#8217;em up in an inbox, process through them when the crowd dies down.&#8221;

Cloud-hardware-based solutions to spikes in load engage my imagination&mdash;I like the idea of spinning up a new virtual machine on demand, and retiring it when the demand passes&mdash;but LEGO&#8217;s solution seems more robust and possibly less expensive, especially when the spikes are unpredictable. Most importantly, they were able to book the sale.

In speech pathology, you have to guess at what parts of the brain do based on what people stop being able to do when they suffer brain damage. You&#8217;re not really allowed to conduct _experiments_. In the same way, I noticed other things about LEGO&#8217;s architecture based on what went funny. 

The website states that free shipping is automatically applied to orders over $75. But at check-out time, my order still included a shipping cost. I thought about pinging their tech support team, or waiting, or&#8230; I WANT MY DeLOREAN! So I just processed the order with the shipping charge; it wasn&#8217;t a deal breaker, anyway. When the actual order-confirmation email arrived, it zeroed out the shipping charge. From that I&#8217;m guessing the logic that applies the shipping discount is also an &#8220;on hold, get to it later&#8221; service.

My bricks arrived on Tuesday. I was not charged for shipping. I even got a surprise freebie kit! Thanks to the thoughtful engineers who asked themselves: How would I solve this if we still used paper?