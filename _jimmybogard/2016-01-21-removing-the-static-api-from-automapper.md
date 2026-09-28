---
wordpress_id: 1170
title: Removing the static API from AutoMapper
date: 2016-01-21T20:19:36+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1170
dsq_thread_id:
  - "4511678082"
categories:
  - AutoMapper
---
As I work towards the 4.2 release of AutoMapper, I got a little inspiration. Over the past year or so I’ve given some talks/podcasts about a long-lived open source codebase. One of my biggest regrets was that I made AutoMapper have a static API from literally the very beginning. The first tests/prototypes of AutoMapper all started out with “Mapper.CreateMap” and “Mapper.Map”. I showed my boss, Jeffrey Palermo, at the time and asked what he thought, and he said “looks great Jimmy, maybe you shouldn’t make it static” and I said “PFFFFFFFFFFFT NO WAY”.

Well, I’ve seen the problems with static and I’ve regretted it ever since. With the upcoming release, I’ve had a chance to prototype what it might look like without static – it worked great – and I’m ready to mark the entire static API as obsolete.

This is a huge shift in AutoMapper, not so much the API, but forcing everything to be static. Here’s the before:

{% gist e50774659800b0869852 %}

Or if you’re doing things the Right Way™ you used Initialize:

{% gist 63cd3a1119e469fb61e5 %}

There are a number of issues with this approach, most of which just result from having a static API. The static API was just a wrapper around instances, but the main API was all static.

With 4.2, you’ll be able to, and encouraged, to do this:

{% gist 64eb628063a1ac636091 %}

The IMapper interface is a lot lighter, and the underlying type is now just concerned with executing maps, removing a lot of the threading problems I was having before.

I’m keeping the existing functionality and API there, just all obsoleted. The one difficult piece will be the LINQ extensions, since those as extensions methods are inherently static. You’d have to do something like this:

{% gist da1f3bd632249103fffd %}

It’s not exactly ideal, so I’m playing with doing something like this:

{% gist a60ba6a0230d962c3a7c %}

Expressions can’t depend on any runtime values, and can be more or less explicitly tied to the configuration.

The pre-release versions of AutoMapper on MyGet now have this API, so it’s not release yet as 4.2. Before I pushed 4.2 out the door, I wanted to get some feedback.

So do you like this idea? Let me know! I’ve got a GitHub issue to track the progress: [https://github.com/AutoMapper/AutoMapper/issues/1031](https://github.com/AutoMapper/AutoMapper/issues/1031 "https://github.com/AutoMapper/AutoMapper/issues/1031")