---
id: 72
title: Great time to be a developer
date: 2012-01-31T23:09:58+00:00
author: Joshua Flanagan
layout: post
guid: http://lostechies.com/joshuaflanagan/2012/01/31/great-time-to-be-a-developer/
dsq_thread_id:
  - "559813509"
categories:
  - Heroku
  - Ruby
  - Sinatra
---
I am in awe of the free tools available to software developers today. It is amazing how fast, and cheaply, you can turn an idea into productive code. I was so pumped by a recent experience, I decided to share.

## The Problem

My employer is moving to a new location in a part of the city that I&#8217;m not very familiar with. I have no idea what the traffic patterns are like, and I&#8217;m wondering when to leave for work in the morning. I tried looking at various web mapping services. Some factor in _current_ traffic, but I couldn&#8217;t find any that could tell me historical traffic information, making it impossible to make a decision about departure time in advance.

## Idea

Tracking historical travel times for the world would be a huge task, but what if I could create a small history of my specific route? The TomTom Live Traffic Route Planner site can give me directions to work, and estimate travel time based on current traffic conditions. I discovered that it returns a lot of the trip information from a single AJAX call. A quick copy/paste of the URL to <font size="4" face="Cordia New">curl</font> confirmed that I could repeat the call and get the same data. I just need to hit that endpoint at various times in the morning and store the results. Later, I&#8217;ll be able to analyze the results and determine the best time to leave for work.

## Keep it Minimal

Now I have an idea, but I don&#8217;t know if it is worth pursuing. I don&#8217;t know if the data I&#8217;m getting is accurate (it worked once or twice from curl _now_, but maybe the long URL contains some session id that will expire?). I don&#8217;t want to invest a lot of time or money in building it out. Also, it&#8217;s 6pm Tuesday night, I only have 3 more days left this week before I make the commute to the new office. I need to start collecting data as soon as possible; hopefully Wednesday morning. It&#8217;s time to write some code. Fast.

This is where the quality of available tools really make an impact. To name a few:

> <a href="http://www.ruby-lang.org" target="_blank">Ruby</a> &#8211; low ceremony scripting with a vast ecosystem of libraries to accomplish common tasks.
> 
> <a href="https://github.com/jnunemaker/httparty" target="_blank">HTTParty</a> &#8211; crazy simple library to call a URL and get a Ruby hash of the response data &#8211; no parsing, no Net:HTTP.
> 
> <a href="http://www.heroku.com/" target="_blank">Heroku</a> &#8211; There is no better option for hosting applications in the early proving stage. Create and deploy a new app in seconds, for free. The free <a href="http://addons.heroku.com/scheduler" target="_blank">Heroku Scheduler</a> add-on lets me run a script every 10 minutes in my hosted environment &#8212; exactly what I need for my data collection.
> 
> <a href="http://www.mongodb.org/" target="_blank">MongoDB</a> &#8211; natural fit for persisting an array (the trips calculated every 10 minutes) of ruby hashes (responses from traffic service). No schema, no mapping, no fuss.  
> &nbsp;  
> <a href="http://addons.heroku.com/mongolab" target="_blank">MongoLabs</a> &#8211; free MongoDB hosting on Heroku. One click to add, and I have a connection string for my own 240MB in the cloud. Sweet.

By 11pm Tuesday night, my script is running in the cloud, ready to start collecting data Wednesday morning. I&#8217;m not going to spend any time on building a UI until I know if the data collection works.

## Checkpoint

On Wednesday night, I use the mongo console to review the trip data that was collected in the morning. I see that the trip duration changes for each request, which gives me hope that I&#8217;ll have meaningful data to answer my question. However, I also notice that the reported &#8220;traffic delay&#8221; time is always zero. I&#8217;m a little concerned that my data source isn&#8217;t reliable. I&#8217;m glad I haven&#8217;t invested too much yet. At this point, I can just write off the time as a well-spent refresher of MongoDB.

## Further exploration

I&#8217;m still curious to see a visualization of the data. I decide to spend a couple hours to see if I can build a minimal UI to chart the departure vs. duration times. Again, the available tools gave me fantastic results with minimal effort:

> <a href="http://www.sinatrarb.com/" target="_blank">sinatra</a> &#8211; an incredibly simple DSL for exposing your ruby code to the web. All I needed was a single endpoint that would pull data from mongo and dump it to the client to render a chart. Anything more than sinatra would be overkill, and anything less would be tedious.
> 
> <a href="http://www.highcharts.com/" target="_blank">Highcharts JS</a> &#8211; amazing javascript library for generating slick client-side charts. A ton of options (including the very helpful <a href="http://www.highcharts.com/demo/spline-irregular-time" target="_blank">datetime x-axis</a>), well-documented, and free for non-commercial use. I didn&#8217;t have a &#8220;go-to&#8221; option for client-side charting, so I had to do a quick survey of what was available. This is the first one I tried, and it left me with absolutely no reason to look at others.

After a couple hours (mostly to learn Highcharts), I have my chart and a potential answer (leave before 7:45, or after 9):  
[<img style="background-image: none; border-right-width: 0px; margin: 0px 0px 24px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="traveltime_chart" border="0" alt="traveltime_chart" src="http://clayvessel.org/clayvessel/wp-content/uploads/2012/01/traveltime_chart_thumb.png" width="571" height="349" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/01/traveltime_chart.png)

## Conclusion

I essentially spent one evening writing the data collection script, and another night building the web page that rendered the chart. I&#8217;ve proven to myself that the idea was sound, if not the data source. I will continue to poke around to see if I can find a more reliable API for travel times, but otherwise consider this project &#8220;done.&#8221; In years past, getting to this point would have meant a _lot_ more effort on my part. It is awesome how much of the hard work was done by the people and companies that support a great developer ecosystem.