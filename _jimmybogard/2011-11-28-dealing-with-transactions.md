---
id: 559
title: Dealing with transactions
date: 2011-11-28T17:05:42+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=559
dsq_thread_id:
  - "486515557"
categories:
  - Architecture
---
In the [last post on NServiceBus](http://lostechies.com/jimmybogard/2011/11/22/stop-premature-email-sending-with-nservicebus/), I got quite a few comments that one way to fix the problem of dealing with non-transactional operations that must happen if some transaction succeeds is to simply move the non-transactional operation after the transactional one, so that I know that the transaction succeeds. If we delay the sending of an email until _after_ the transaction succeeds, our picture now looks like this:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/11/image_thumb3.png" width="575" height="321" />](http://lostechies.com/jimmybogard/files/2011/11/image3.png)

The steps are slightly altered so that the Commit happens before Send. If step 2 fails, step 3 never happens. I see a couple of problems with this approach, namely in that it assumes:

  1. I have explicit control over when transactions happen
  2. I _want_ explicit control over when transactions happen

If #1 is true, I have to wonder if #2 is also desirable. In most cases I run into, I don’t want explicit control over transactions. I don’t want to think about them, or mess with them, or deal with them. I want these to just happen without me having to do any work.

I instead like the idea of a unit of work, or at the very least, a concept of [required infrastructure](http://ayende.com/blog/136193/the-required-infrastructure-frees-you-from-infrastructure-decisions) for transaction management. Regardless of the host environment I’m working with, WCF, WPF, ASP.NET, NServiceBus etc., my day to day development takes on a picture like this:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/11/image_thumb4.png" width="607" height="400" />](http://lostechies.com/jimmybogard/files/2011/11/image4.png)

Day to day, I’m living in the green section. I don’t want to “remember” to create transactions, deal with a pattern of saving, committing, rolling back etc. This should just be taken care of for me, through required infrastructure. One example is in Ayende’s example of the RavenController in MVC:

[gist]https://gist.github.com/1401053[/gist]

On every request, a Raven session is opened, and everything saved at the end of the request. All developers have to do to make sure that transactions are used properly is simply inherit from this controller.

With every application framework I look at, one of the first items I put in is the concept of implicit contextual transactions. The scope of what code I’m working with naturally fits inside a transaction, so it’s not something I want to have to worry about.

If I have to remember to call Commit on a transaction every time I introduce new data manipulation code, that’s just something I’m going to forget to do. Instead, transactions and unit of work management should wrap around my normal application code, without me needing to do anything to manage it.

In the next post, I’ll look at various alternatives to messaging for doing something non-transactional like sending emails (or calling web services), and examine the benefits and drawbacks of each approach.