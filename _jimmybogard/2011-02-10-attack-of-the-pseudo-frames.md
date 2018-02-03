---
wordpress_id: 453
title: Attack of the pseudo-frames
date: 2011-02-10T13:47:35+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2011/02/10/attack-of-the-pseudo-frames.aspx
dsq_thread_id:
  - "264716681"
categories:
  - Rant
---
AKA, folks are getting a little too clever in AJAX-land.&#160; There was a joke going around when “new twitter” launched that “old twitter” is what Steve Jobs would have designed if his engineers started with “new twitter”.&#160; Looking at any of the Gawker family of sites this week, you’d notice a stark change:[<img style="border-bottom: 0px;border-left: 0px;padding-left: 0px;padding-right: 0px;border-top: 0px;border-right: 0px;padding-top: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_28F4C7DC.png" width="521" height="512" />](http://lostechies.com/jimmybogard/files/2011/03/image_7A5EBEF9.png)

Two really strange things going on here.&#160; First, the left side of the screen scrolls independent of the right.&#160; The right set of that indicates links to articles will stay static.&#160; But you can see that one of the articles on the right is cut off halfway through an image.&#160; There’s nowhere to scroll to get see the rest of the content.&#160; Instead, there’s a silly little link, “Next Headlines” that pushes the content up.

I don’t usually mind this design, as Gmail and Google Reader have used this style for ages.&#160; However, they still use normal scrollbars inside a clearly demarcated area that has its own scrolling behavior.&#160; In Google Reader, the entire page is fixed, except for a window into your feeds.

Searching some articles on this new design, it turns out that the charlie-foxtrot that is the new Gawker design decided to go all-in into [bastardizing URLs with “hash-bang” URLs](http://isolani.co.uk/blog/javascript/BreakingTheWebWithHashBangs).&#160; So not only is the UX broken, they’ve decided to break how the web fundamentally behaves with URIs.&#160; As a comment in that post says, “If site content doesn’t load through [curl](http://curl.haxx.se/), it’s broken”.

Web users still have to put up with [obnoxious Flash-only restaurant websites](http://theoatmeal.com/comics/restaurant_website), can we all just collectively agree that hash-bang URI, AJAX-only websites are an abomination, a failed experiment, and should be retired to the same pastures as the blink tag?