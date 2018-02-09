---
wordpress_id: 787
title: 'Don&#8217;t Rely Solely On jQuery&#8217;s &#8220;keyup&#8221; Event'
date: 2012-01-27T08:09:05+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=787
dsq_thread_id:
  - "554590730"
categories:
  - Backbone
  - JavaScript
  - JQuery
  - Test Automation
  - Validation
---
A few days ago I pushed some changes to the form validation up to my [WatchMeCode](http://watchmecode.net) website. I was trying to fix a scenario where a browser cache would have some of the data in the purchase form already filled in. In that scenario, a potential customer would have to modify each field, even though they were already filled in, in order for my  Backbone code to see the data in the field.

To &#8220;fix&#8221; the problem, I switched my code from a &#8220;change&#8221; event to a &#8220;keyup&#8221; event for the text boxes … bad idea!

## Browser Auto-Fill

Most (if not all) browsers have an auto-fill feature, these days. I use it in Chrome a lot. It saves me a few seconds here and there and generally makes it easier for me to fill in the same repetitious information across websites.

<img title="Screen Shot 2012-01-27 at 7.53.37 AM.png" src="http://lostechies.com/derickbailey/files/2012/01/Screen-Shot-2012-01-27-at-7.53.37-AM.png" border="0" alt="Screen Shot 2012 01 27 at 7 53 37 AM" width="423" height="361" />

But there&#8217;s a problem with auto-fill. It doesn&#8217;t fire the &#8220;keyup&#8221; event. It fires the &#8220;change&#8221; event for the things it fills in, but not &#8220;keyup&#8221;. This resulted in the data being truncated when it populated my Backbone model.

In the above screenshot, since i had typed &#8220;deri&#8221; in to the email address, the email that is stored in the Backbone model would only be &#8220;deri&#8221; &#8211; and that&#8217;s obviously not a valid email address.

## Easy To Fix

There are a number of very easy ways to fix this.

  * Validate the email address format
  * Use a combination of &#8220;blur&#8221;, &#8220;change&#8221;, and &#8220;keyup&#8221; events
  * Delay reading the data until the user clicks the &#8220;Purchase&#8221; button
  * Use a KVO (key-value observer) plugin like my Backbone.ModelBinding and let it deal with that for you

For the quick-fix to get my site working properly, I went with the combination of &#8220;change&#8221; and &#8220;keyup&#8221; events. I&#8217;ll be re-writing my purchase form sometime soon, and will likely delay reading the values until they click the &#8220;Purchase&#8221; button. I&#8217;m also going to put in better email address validation to make sure it at least has an @ and a . in it, and I&#8217;ll likely use the HTML5 &#8220;email&#8221; field and see how that will help me, if at all.

## Not So Easy To Automate Testing

When I originally made the change to use the &#8220;keyup&#8221; event, I did all my usual testing &#8211; which did not include using auto-fill. All of my testing passed, so I pushed the site live.

How do you test for bugs like this in an automated way? Is there even an automated way to test a browser&#8217;s auto-fill? I&#8217;d like to avoid mistakes like this in the future, and some automated testing around it would certainly be nice.

## Lesson Learned: Don&#8217;t Rely Solely On &#8220;keyup&#8221;

There certainly are some great things you can do with the &#8220;keyup&#8221; event &#8211; like autocomplete, for one &#8211; but it&#8217;s not a great idea to only use this when there&#8217;s a chance that the browser&#8217;s auto-fill will be used.

And unfortunately for me, 2 of my customers ran in to this problem before I got it fixed. It makes it very hard to email someone the download instructions for their order. One of them contacted me and I corrected the order. But the other purchaser has not yet contacted me, and I don&#8217;t have enough information to figure out who they are, so I can&#8217;t track them down. I hope this person realizes that they didn&#8217;t get their order, they contact me. My contact info is all over the site… so … hopefully … the lessons learned for running an e-commerce site are sometimes painful.

 