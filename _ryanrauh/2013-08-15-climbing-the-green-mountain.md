---
wordpress_id: 4391
title: Climbing the green mountain
date: 2013-08-15T17:41:12+00:00
author: Ryan Rauh
layout: post
wordpress_guid: http://lostechies.com/ryanrauh/?p=242
dsq_thread_id:
  - "1608490755"
categories:
  - Uncategorized
---
# How to defeat the evil green mountain

## what is the green mountain?

<img style="max-width: 100%" src="http://f.cl.ly/items/2f2a2R3Y3a2R0i2t0X3G/Image%202013-08-14%20at%209.47.36%20AM.png" />

A picture is worth a thousand words. The green mountain is the response time graph from huboard. From time to time the GitHub api hangs and takes a _really_ long time to return data which causes huge spikes in the response time for huboard. I recently release some fixes to huboard to help mitigate this problem.

## Ways to fix the green mountain

First and easiest method is to add a retry mechanism in your api library and set a low timeout for your requests. Since huboard uses the api library [ghee](https://api.github.com/rauhryan/ghee), which I happen to know very well since I wrote it. It was really easy.

Ghee uses [faraday](https://github.com/lostisland/faraday) it was very easy to [configure ghee](https://github.com/rauhryan/huboard/blob/master/lib/bridge/huboard.rb#L36-45) to retry requests it was also quite easy to add some middleware into faraday to [set the timeout](https://github.com/rauhryan/huboard/blob/master/lib/bridge/middleware/mimetype.rb#L19-20) to 1 second

The second way is to cache responses from the github api. This turned out to be a bit of a technical challenge. The GitHub has support for making [conditional requests](http://developer.github.com/v3/#conditional-requests) the send an e-tag header with every request made. The twist is that you need to return that e-tag in your next api call to see if anything has changed. It gets complicated when you make several api requests within a single request you have to cache the entire request and then pull out the cached request to get the last e-tag and _then_ send a request to GitHub to see if anything has changed. Thankfully it wasn&#8217;t too hard to implement with ghee. Yeah for the [power of middleware](https://github.com/rauhryan/huboard/blob/master/lib/bridge/middleware/caching.rb) <img style="max-width: 100%" src="http://f.cl.ly/items/021U2o0d0q2n3r2m3R0n/Screen%20Shot%202013-08-15%20at%2012.26.35%20PM.png" />

So far so good, there are still spikes but you will notice that the legend on the left side is _much_ lower, going from spikes up to 3 seconds to every request being under a second! Thats a pretty big win for me and the users of course.

Happy huboarding!!!