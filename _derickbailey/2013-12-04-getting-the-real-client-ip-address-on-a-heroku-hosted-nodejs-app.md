---
wordpress_id: 1181
title: Getting The Real Client IP Address On A Heroku Hosted NodeJS App
date: 2013-12-04T09:35:55+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1181
dsq_thread_id:
  - "2024117376"
categories:
  - Heroku
  - JavaScript
  - Metrics
  - Podcast
  - SignalLeaf
---
I was building a new report for [SignalLeaf](http://signalleaf.com) last weekend, to get the RSS Subscriber count for a given podcast. Along the way, I was doing some research in to the best way to track that information. It turned out to be mostly simple: track the IP address for every machine that gets the RSS feed for a given podcast, along with the user-agent for each (and a few other bits of info). Once you take out the known list of bots and crawlers, you can use a &#8220;distinct&#8221; combination of IP and user-agent to get a good idea of how many subscribers a podcast has. 

I was rocking the code, getting data tracked and analyzed, and I got the first version of the report published. So naturally, I went out to [my own podcast](http://blog.signalleaf.com/blog/categories/podcast/) that I have set up and started refreshing the RSS feed from my browser and from curl commands. I wanted to see what would happen in the staging and production environments, on Heroku.

**To my horror, I found my RSS subscriber count increasing by 1 every time I refreshed the feed!**

<img src="https://lostechies.com/content/derickbailey/uploads/2013/12/Screen-Shot-2013-12-04-at-9.27.15-AM.png" alt="Screen Shot 2013 12 04 at 9 27 15 AM" width="344" height="187" border="0" />

## Digging In To The Issue

Now this wasn&#8217;t happening on my local machine&#8230; I was properly counting distinct IP addresses as 1 subscriber&#8230; but when I deployed my code to my staging or production environments, it was not working as expected. Like any good JavaScript developer, I did the only reasonable thing: add some console.log statements to see if I can figure out what&#8217;s going on and re-deploy.

By adding a console.log on the IP address that I was tracking, I found out that **I was getting a new IP address for every refresh, all within the 10.##.###.### IP Address range**. I know this is a private IP range, used internally on networks, so this didn&#8217;t make sense to me at all.

A few quick searches later, and I found some info that told me how **Heroku uses an internal routing system to forward the original request** to any of the actual machines running your process. The IP address that your process actually receives is not the original requesting IP address, but the internal router or proxy or whatever it is. 

## Getting The Real IP Address

Fortunately, there is a way to get the real IP Address for a client that is connected to your app. Heroku attaches a &#8220;x-forwarded-for&#8221; header to requests, and gives you an array of IP Addresses as the value. All you need to do is read this array by splitting the raw string at &#8220;,&#8221; and then find the last item in the array. This will be the real IP address of the client.

So in my app, I added this code:

{% gist 7789509 real-ip.js %}

And now I have the real IP address to track RSS activity and produce the right report.

## Artificial Bump In Subscribers

Of course, my RSS subscriber history has a large bump in the first day, from all my errant subscriber counts:

<img src="https://lostechies.com/content/derickbailey/uploads/2013/12/Screen-Shot-2013-12-04-at-9.27.54-AM.png" alt="Screen Shot 2013 12 04 at 9 27 54 AM" width="462" height="297" border="0" />

But the good news is that most people aren&#8217;t going to sit there, refreshing their RSS feed every few seconds, dozens of times. So no one else really had the problem of an extra bump in subscribers that first day. And as you can see, my count is now leveled out where it should be.

<img src="https://lostechies.com/content/derickbailey/uploads/2013/12/Screen-Shot-2013-12-04-at-9.34.27-AM.png" alt="Screen Shot 2013 12 04 at 9 34 27 AM" width="326" height="178" border="0" />

Hopefully I&#8217;ll be able to bump that number back up &#8230; legitimately &#8230; as I produce more episodes, though. 🙂
