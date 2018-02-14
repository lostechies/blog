---
wordpress_id: 1167
title: 'Minimum Viable Reports: A NodeJS Script And console.log'
date: 2013-10-18T19:35:13+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1167
dsq_thread_id:
  - "1873791897"
categories:
  - Continuous Improvement
  - JavaScript
  - Pragmatism
  - Productivity
  - SignalLeaf
---
I&#8217;ve spent around 2 months building [SignalLeaf](http://signalleaf.com), so far. It&#8217;s all after-hours and weekends, but I got the job done &#8230; well&#8230; I got a minimum viable product done. I at least solved some pain that I had been seeing in the land of podcasting. Along the way, I focused almost exclusively on the features that users would be working with to create podcasts, add episodes, setup RSS feeds and get a very basic amount of traffic information for an episode. This is all great from the user&#8217;s perspective. It&#8217;s things that podcasters need in order to get their job done. But along the way, I have purposely neglected the back-end system &#8211; the code and feature sets that \*I\* need in order to understand how my app is shaping up and manage it. But I realized something today: if I&#8217;m looking for the minimum deliverable and I&#8217;m looking at creating a service for the users first and for myself second, I really don&#8217;t need to spend a lot of time building a fancy set of pages that I can see from the web site directly. In fact, I don&#8217;t need much of any code to start with, for the back-end. After all, I have code that I can run from my machine and grab data from the production database, so why not do that? Why not create a minimum viable report to show me the information I need?

## Minimum Viable Report

The first thing I want to know is how many customer accounts and podcasts I have in [SignalLeaf](http://signalleaf.com). This will give me some idea of how well I&#8217;m doing w/ marketing effort, feature advertisement, pricing, etc. It&#8217;s not going to give me much, but it&#8217;s a start and it at least feeds my vanity metic of having customers. Rather than spend a lot of time building out an administrative back-end for my app, though, I decided to just hack together a quick script that gives me the information I need. I really just wanted to see without having to go through MongoDB&#8217;s command line tools directly. 

So I built this little script:

{% gist 7050627 customers.js %}

And that&#8217;s it. It&#8217;s just an import of my system&#8217;s basic modules, a database connection, a query to get some information and then aggregating that information in to a simple console.log output. To run my report, I just run &#8220;node customers.js&#8221; and it will connect to my local database. If I want to run it against production, I only need to set &#8220;NODE_ENV=production&#8221; prior to running the script and BAM! I have a report of my production app:

<img src="http://lostechies.com/content/derickbailey/uploads/2013/10/Screen-Shot-2013-10-18-at-8.24.11-PM.png" alt="Screen Shot 2013 10 18 at 8 24 11 PM" width="600" height="159" border="0" />

(Yes, I know this is a meagerly pathetic # of accounts and podcasts. But that&#8217;s not the point.)

## Iterating, Scaling, Improving

One of the things that I like the most about this, is being able to hack together any script I want and get information I want, quickly. I don&#8217;t have to worry about designing a proper report format. I don&#8217;t have to worry about creating a bunch of HTML, route handlers, and other things involved in getting a real report setup on the site. I can hack a script, iterate, fix it, run it as needed and move on.

Of course, this type of reporting doesn&#8217;t scale to more than just administrative people with direct access to the code and database &#8211; which is really just me, anyways. But it does get me down the path of being able to see the information I need, when I need it, and moving on to the next feature that my customers need. 

From here, I&#8217;ll be able to tweak the core of the reports to get the information I really do need. Then once I have some of the basics done and ready to roll, I&#8217;ll be able to work on the UI side of things and already have the data available.
