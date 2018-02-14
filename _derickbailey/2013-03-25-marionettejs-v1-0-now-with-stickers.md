---
wordpress_id: 1080
title: MarionetteJS v1.0
date: 2013-03-25T07:19:08+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1080
dsq_thread_id:
  - "1160413660"
categories:
  - Backbone
  - JavaScript
  - Marionette
  - Open Source
---
Hot on the heels of the [Backbone v1.0 release](http://ashkenas.com/backbonejs-1.0/), I present [MarionetteJS v1.0](http://marionettejs.com)!

I quietly released it over the weekend, and I&#8217;m glad I did. I already had a bug report and have released v1.0.1 to fix it. 😀

The last few years of working on Marionette have been tremendously fun, exciting, frustrating at time, and have provided much more work and opportunity for me than I had ever imagined. I started this project out of need, and hoped that it might help a few people out &#8211; at least show them what could be done and give them ideas on how to do it. I never expected that this project would have 1/10th the number of stars it has on Github, or that this project would lead to working with dozens of amazing companies, travelling around the world, create new friendships, and land me some awesome speaking opportunities on podcasts and at conferences! 

## What&#8217;s New

There&#8217;s a ton of new things that have happened since I started the 1.0 release candidates. And actually, going in to &#8220;release candidate&#8221; model was probably the worst mistake I&#8217;ve made with Marionette, so far. I had far too many breaking changes, far too many times for it to really be a release candidate series. But things are stable now, and have been for a bit. There were a few additions and breaks in this release, some of which came from dependencies.

You can **read the complete [change log](https://github.com/marionettejs/backbone.marionette/blob/master/changelog.md) and [upgrade guide](https://github.com/marionettejs/backbone.marionette/blob/master/upgradeGuide.md) in the repository**, but I want to highlight a few of the notable things quickly.

### Backbone.Wreqr Updates

Backbone.Wreqr is an integral part of Marionette and helps to provide a lot of the communication infrastructure for scaling applications. 

In the latest release of Wreqr, I&#8217;ve renamed &#8220;addHandler&#8221; to &#8220;setHandler&#8221; for all Wreqr objects. There was confusion around the name &#8220;addHander&#8221; as it implied the ability to add multiple handlers. Since none of Wreqr allows multiple handlers for any one registered name, I changed this to &#8220;setHandler&#8221;. Anyone updating to Wreqr v0.2.0, along with Marionette v1.0.0, will need to account for this.

I&#8217;ve also made the commands somewhat persistent when there is no handler currently registered. Several people noted that they were running in to situations where a command needed to be executed, but due to the order of module loading being unpredictable, the handler wasn&#8217;t there. To fix this, a command can be executed whether or not the handler is available. As soon as the handler is available, the actual execution of the command will take place. Commands will persist in memory, for the life of the page. Refreshing the page or navigating to another page will destroy the not-yet-executed commands.

### Marionette.RegionManager

One of the most requested features in recent times has been the ability to add and remove regions from layouts. I set out to solve this and realized that half of the code I needed was already in the Application object, and the other half was in the Layout object. So I consolidated most of this code in to a single object called RegionManager. Both the Application and Layout now use a RegionManager to manage their regions. This allows a more consistent way of managing the regions, and provides all of the add and remove functionality that is needed, on both.

## STICKERS!!!!

WOOO! STICKERS!!! 😀

 [<img title="marionette-sticker-detail.jpg" src="http://lostechies.com/content/derickbailey/uploads/2013/03/marionette-sticker-detail.jpg" alt="Marionette sticker detail" width="400" height="400" border="0" />](http://www.devswag.com/products/marionette-stickers-4)

You can [order yours from DevSwag](http://www.devswag.com/products/marionette-stickers-4). They are providing order management and fulfillment for stickers, for Marionette and many other amazing open source projects.

## Semantic Versioning: A Goal

I have a goal, moving forward, of using [Semantic Versioning](http://semver.org) for the version numbers. I don&#8217;t think I can promise perfect semantic versions, though, for a few reasons. First off, this is my first project to hit v1.0. I know I&#8217;m going to make mistakes and screw up some little detail here and there. But for the most part, I plan on following semver. Secondly, and more importantly, though, Marionette relies on other libraries which have their own release cycles. Sometimes releases coincide. Other times they don&#8217;t. Sometimes they break Marionette, other times they don&#8217;t. This will make it challenging to follow semver.

## What&#8217;s Next?

It&#8217;s been a whirlwind ride with near constant updates along the way. I&#8217;ve learned a ton about JavaScript and running an open source project. And this is the first time I&#8217;ve pushed an open source project to 1.0, so I&#8217;m sure there are still a ton of lessons left to learn.

There are still more than 50 tickets open in the Marionette repository, and a lot of things that I want to do to help re-stucture some of the ugly parts. I want to tear apart Modules, for example, and create separated namespacing, sub-applications and components. There are a lot of other feature requests and issues reported that need big changes, too. I&#8217;m looking forward to where Marionette will head, and hope to continue to build a strong community around it &#8211; including a more active core contributor team.).

## Thank You!

Yes, it&#8217;s the grammy-award speech time! Someone start the &#8220;wrap it up&#8221; timer&#8230;

<img title="NewImage.png" src="http://lostechies.com/content/derickbailey/uploads/2013/03/NewImage.png" alt="NewImage" width="275" height="183" border="0" />

I owe an especially large thanks to Jarrod Overson, Matt Briggs, Brian Mann and Tony Abou-Assaleh. These guys have been a great core team to bounce ideas around with, to help out with issues, and provide needed support and feedback. And to Ruben Vreeken for all the work he puts in to the Google group, answering questions. 🙂

Marionette wouldn&#8217;t be what it is without [the amazing contributors](https://github.com/marionettejs/backbone.marionette/contributors). Everyone that has contributed in any way &#8211; answering questions in the google group, sending issue reports, ideas, pull requests, writing blog posts and articles, screencasts, and talking at user groups and conferences. I&#8217;m still and continuously amazed at how much has been done in the community with this library. Thank you all!

A special thanks to Backbone, of course, which is what got me into JavaScript again, and allowed me to build Marionette. Thank you to [MedienFreunde](http://medienfreunde.com/) for the amazing logo and website.

And thank you to all of the awesome people building apps with Marionette. Projects like [Halo Waypoint](http://app.halowaypoint.com), [Redbull Music Academy](http://www.redbullmusicacademy.com/), and [StubHub](http://www.stubhub.com/) are among the most widely known systems built with Marionette &#8211; then there&#8217;s the three error reporting / analytics tools: [AirBrake.io](http://airbrake.io/), [RayGun.io](http://raygun.io/) and [CrashLytics](http://crashlytics.com/). But there are so many more out there, still It&#8217;s been awesome seeing Marionette in all these places, and I&#8217;m looking forward to seeing where it goes from here! 🙂