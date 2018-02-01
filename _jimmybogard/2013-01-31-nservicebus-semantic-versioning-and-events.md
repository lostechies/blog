---
id: 723
title: NServiceBus, Semantic Versioning and events
date: 2013-01-31T15:21:29+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=723
dsq_thread_id:
  - "1057153271"
categories:
  - NServiceBus
---
Something that caught us quite off guard when migrating from the 2.6 version of NServiceBus to the 3.x versions was around how NServiceBus treats assembly versions for publishing messages.

When a subscriber expresses intent for a subscription of a message type, it does so automatically via a subscription message sent to the publisher. This message contains metadata information about which message types the subscriber intends to subscribe to, including full assembly version. It’s then stored in some persistent store, RavenDB, SQL Server, etc.

[gist id=4683129]

Note that the assembly version is included in the subscription store. So here’s our picture right now:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2013/01/image_thumb.png" width="354" height="236" />](http://lostechies.com/jimmybogard/files/2013/01/image.png)

At some point in the future, Publisher bumps its version (for whatever reason) and its message assembly’s version is bumped as well. _However_, the subscriber hasn’t upgraded its message assembly (likely because nothing changed in the messages), and our picture is now this:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2013/01/image_thumb1.png" width="354" height="233" />](http://lostechies.com/jimmybogard/files/2013/01/image1.png)

What we’re finding is that the Publisher reads the subscription store and notices that it’s only publishing 2.0 of some event. But Subscriber is only subscribed to 1.0, so therefore, can’t fulfill the subscription. The Subscriber will receive no event message, nor will it receive any notification that its subscription was broken. A bit of a silent failure.

I’ve tried a variety of scenarios to make sure that the Subscriber gets its published message, regardless of the version. It seems the only reliable way to ensure that Subscriber gets its subscribed message is to upgrade the Subscriber’s messages assembly to the latest version, _regardless_ if anything has actually changed in the type of the message:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2013/01/image_thumb2.png" width="354" height="236" />](http://lostechies.com/jimmybogard/files/2013/01/image2.png)

Once this common version is the same everything seems to work. I’ve tried “fooling” NServiceBus by fiddling with the subscription store’s version, but that had mixed results, and I couldn’t get it to reliably work.

This only applies to major version bumps – v1.1 messages will be published to v1.0 subscribers. But v2.0 will not be delivered to v1.5, v1.3 etc. It’s only the major version that’s looked at when determining who is subscribed.

This is a breaking change from the NServiceBus versions prior to 3.0 (2.6 and earlier). Previously, assembly version was not considered for dispatching events.

### 

### 

### Fixing your versions

In many environments, Semantic Versioning is not practiced for internal components. In fact, version numbers have a very wide variety of uses. I like to embed date information, “2013.1.31.1349” in my versions, because I’m pushing out so many builds and there is no one that really cares about semantic versioning. Other teams use years and quarters to signify releases. The versions are more release numbers than an indication that anything is broken.

Until it becomes configurable, be very careful about your version numbers in your message assemblies. To avoid silent production breakages, either:

  * Keep the major version constant. Use assembly file version or something else for descriptive version numbers
  * Always upgrade subscribers to major versions to avoid breakage

A bit of a hassle, but necessary if you don’t want to accidentally break consumers by bumping your assembly versions.

Happy messaging!