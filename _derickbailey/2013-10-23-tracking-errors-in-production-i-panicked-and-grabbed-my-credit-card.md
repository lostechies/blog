---
id: 1169
title: 'Tracking Errors In Production: I Panicked And Grabbed My Credit Card'
date: 2013-10-23T08:58:41+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=1169
dsq_thread_id:
  - "1891240496"
categories:
  - Marionette
  - Product Reviews
  - Tools and Vendors
---
What&#8217;s the #1 sign that a product is adding significant value to my life as a developer? When my trial period runs out and I panic, scrambling to find my credit card so I can continue using the service! 

## Picking An Error Handling Service

I&#8217;ve been building web apps for many years now, and I&#8217;ve never really thought I needed to have any kind of serious error tracking service. But when I look back at what I&#8217;ve been building, it&#8217;s largely been internal applications. Whether it was internal to my company, or for a client, the application&#8217;s error handling didn&#8217;t need to be anything particularly special. I would set up a global error handler of some sort, log it to a database and maybe send an email with error info. 

As I begin my journey in to building software services, like [SignalLeaf](http://signalleaf.com), I find myself thinking the same thing. Oh, it&#8217;s no big deal. I&#8217;ll make sure I test things well and I shouldn&#8217;t have any problems, right? I don&#8217;t really need an error tracking service. 

A few weeks ago, though, I decided to try out Raygun. I was debating between [Airbrake](http://airbrake.io/), [Crashlytics](http://crashlytics.com), and [Raygun](http://raygun.io) on the premise that all three of them are built with MarionetteJS on the front end. I&#8217;ve used [Airbrake](http://airbrake.io/) in the past (back when it was called Hoptoad), and it was great. Having used it made me a little more interested in trying one of the others, though. That&#8217;s nothing against Airbrake by any means, though. I think they are a great service. I just wanted to see what else was out there and see what the differences were. So between Crashlytics and Raygun, I decided to go with Raygun for 2 reasons: they sent me a t-shirt a few months ago, and offered to give me a discount. I can&#8217;t say not to free stuff and discounted services, so I went with [Raygun](http://raygun.io) and I&#8217;m glad I did. Airbrake also sent me a shirt, and I&#8217;ve used them in the past. That made the decision difficult. But I chose Raygun because I had not used them yet.

## Error Tracking: The Service I Didn&#8217;t Know I Needed

Since I first launched the initial alpha bits of [SignalLeaf](http://signalleaf.com), I&#8217;ve learned a lot about error handling in NodeJS. I&#8217;ve moved from doing stupid things like ignoring errors and returning raw error information to the client browser, to handling errors a little better and at least throwing errors when I can&#8217;t do anything about them. It wasn&#8217;t until I started realizing that my error handling was terrible, that I started to see the value in a service like Raygun. After getting through some initial &#8220;I have no idea what I&#8217;m doing&#8221; learning curves, I started to realize that my site was actually throwing errors &#8211; a lot of them. Like, 500+ errors in a few weeks. And that&#8217;s with only one or two people using SignalLeaf!

It turns out that [my original blog post announcing SignalLeaf](http://lostechies.com/derickbailey/2013/08/20/signalleaf-hacking-a-podcast-audio-service-together/), I had a little bit of pseudo-code in a gist, where I showed the idea of embedding an audio episode in to a web page. It was meant to be an example, knowing that the end result would be something slightly different. What I didn&#8217;t realize, though, was that some RSS readers out there would see the embedded HTML example and actually try to parse the HTML and the links. So when I started changing the site to account for the real needs and functionality of what was going on, I started getting errors. The RSS readers that were parsing the URLs were making calls out to the URL in question. This URL was invalid in a way that caused one of my route handlers to throw errors &#8211; and I didn&#8217;t know it for a long time.

It wasn&#8217;t until I integrated [RayGun](http://raygun.io) into SignalLeaf and started fixing my error handling in my code, that I realized what was happening. And I freaked out. I had no idea what was going on, for a long time. But with the help of the error details that were being logged, I was able to track down the source of the problem &#8211; my original blog post. I was also able to track down at least one of the online RSS readers that was trying to parse and fetch the URL in that blog post. I reached out to the people that build that RSS reader service and explained what was happening. They confirmed my suspicions, saying that their software was attempting to fetch the URL from that blog post. 

This is what sold me on Raygun and using an error handling service &#8211; being able to track down an error that was tangentially caused by my service.

## That Moment Of Panic

Like I said in the opening of this post, I found myself in a panic recently. This morning, actually. I received an error notification from Raygun and I clicked the link to view the details only to find out that my trial period had expired. It was an error message that I had not seen before, so I was not familiar with the cause. Knowing that there was an error and not being able to see the details led to a quick moment of panic and a rush to find my credit card. This has happened to me twice in the last year, and it&#8217;s a sure sign that a product or service I am trying has added a significant amount of value to my life as a developer. 

If you&#8217;re not using an error reporting service in your software systems, you probably should be. If you&#8217;re looking for a recommendation on one to try out, I can safely and confidently suggest both [Raygun.io](http://raygun.io/) and [Airbrake.io](http://airbrake.io/). These are both rock solid services. I&#8217;m sticking with Raygun right now, because I already have it integrated in to my app and I like what I see so far. It has provided enough value, and brought about that sure sign that I need to maintain my subscription. I&#8217;m certain that [Crashlytics](http://crashlytics.com) is also a fine service, and I could probably recommend them as a third alternative. They&#8217;re becoming quite popular, and being a part of the Twitter universe, I&#8217;m sure they have enough knowledge and expertise on all fronts to provide a great service. It also helps that all three of these services are built with [MarionetteJS](http://marionettejs.com). 🙂