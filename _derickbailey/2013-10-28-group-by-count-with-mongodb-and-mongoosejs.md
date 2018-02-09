---
wordpress_id: 1172
title: Group By Count With MongoDB And MongooseJS
date: 2013-10-28T17:30:38+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1172
dsq_thread_id:
  - "1912406878"
categories:
  - Command Line
  - Design
  - JavaScript
  - MongoDB
  - MongooseJS
  - New Category
  - Reporting
  - SignalLeaf
---
In [my last post about reports](http://lostechies.com/derickbailey/2013/10/18/minimum-viable-reports-a-nodejs-script-and-console-log/), I showed a simple script that gave me a count of customers. I used a similar query in [SignalLeaf](http://signalleaf.com) to give me the count of listens / downloads for episodes, too. This gave me a very basic traffic report for how many episodes had been served up, total. But the raw [count](http://mongoosejs.com/docs/api.html#model_Model.count) feature of MongooseJS / MongoDB doesn&#8217;t give me any kind of detail. It literally just returns a count of the things that match the query parameters. What I really want to see is a list of episodes with a total # of plays for each episode.

## Group-By

The challenge that I have in getting this data is that I am tracking downloads/listens in a separate MongoDB collection. I have a Podcasts collection and each Podcast has Episodes. Then I have a Tracking collection, where each Tracking instance contains a podcastId and episodeId to tell me which podcast/episode is being tracked. I have some other data in there, too, but it isn&#8217;t relevant right now. 

I knew I needed to group the Tracking table by episodeId to start with, so I called on the [aggregate](http://mongoosejs.com/docs/api.html#model_Model.aggregate) function to do this. 

{% gist 7205671 group.js %}

This gives me back a list of unique episodeId entries in the Tracking collection &#8211; that&#8217;s the first problem solved. But now I need to get a count of each episodeId in the Tracking collection as well.

## Group By Count &#8211; Failures

At first I thought I was going to have to loop through the list of episode IDs and make a separate call for each. That would be a horrible performance nightmare, though. So I tried to add a total value to the grouped output using a 

{% gist 7205671 count.js %}

This failed miserably because the [group aggregation operators](http://docs.mongodb.org/manual/reference/operator/aggregation-group/) does not support $count. It looked like I was back to iterating and querying for each for a moment. Then I had a thought that seemed kind of stupid but might work.

## Sum Of 1 As A Counter

I&#8217;ve used [the $sum function](http://docs.mongodb.org/manual/reference/operator/aggregation/sum/#grp._S_sum) to get totals in another place within [SignalLeaf](http://signalleaf.com). Why not use that for my count, by doing a sum of a hard coded value of 1? The configuration of the group query options is a JavaScript object, after all, so I&#8217;ll just hard code 1 in to the value instead of using a string to tell it which field to sum.

{% gist 7205671 group-by-count.js %}

And it worked!

## The Result: Group By Count For MongoDB

Each entry for a given episode ID was given a value of &#8220;1&#8221; which was added to all of the other entries, creating a group-by count result in MongoDB! And I now I have a fancy little report that shows me totals per episode, along with the total traffic for episode deliveries:

<img src="http://lostechies.com/derickbailey/files/2013/10/Screen-Shot-2013-10-28-at-5.09.59-PM.png" alt="Screen Shot 2013 10 28 at 5 09 59 PM" width="600" height="436" border="0" />
