---
wordpress_id: 1306
title: Testing Stripe.com WebHooks With Requestb.in
date: 2014-03-11T06:00:30+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1306
dsq_thread_id:
  - "2407255040"
categories:
  - API
  - Runscope
  - SignalLeaf
  - Stripe
  - Testing
---
[SignalLeaf](http://signalleaf.com) uses [Stripe.com](http://stripe.com) for billing. One of the cool things it does is provide web hooks to get events so that you can have your system do things in response to those events. Examples of events include customer creation, customer subscription changes, charges being made to a customer, charges failing, and a whole lot more. 

I find myself needing to use these webhooks (well, ok&#8230; I needed to be using them 6 months ago, but I&#8217;m here now and I&#8217;m finally getting it done) and began wondering how I could get sample data and sample requests &#8211; not just documentation or &#8220;Events & Webhooks&#8221; list on the Stripe site. I want to see the actual request headers, body and payload of the request as a web server will see it. Call me paranoid&#8230; I just don&#8217;t trust documentation and logs all that much &#8211; even from a company that I trust with my business. 

Enter, [Requestb.in](http://requestb.in/) &#8211; an epic little service from [Runscope](https://www.runscope.com/) that lets me set up a sandbox URL to receive HTTP requests and log all the pretty details that I want to see. 

## Setting Up The Bin

To get stripe integration working, you need to create a bin first. Hit the Requestb.in site and click the big button

<img src="http://lostechies.com/derickbailey/files/2014/03/NewImage.png" alt="NewImage" width="300" border="0" />

I checked &#8220;private&#8221; for mine, cause I don&#8217;t want anyone else to be able to see the data. Once you have the bin created, you&#8217;ll see this nice big page with your URL and a ton of examples plastered all over it.

<img src="http://lostechies.com/derickbailey/files/2014/03/NewImage1.png" alt="NewImage" width="300" height="198" border="0" />

Copy the URL out of that box and then head over to your Stripe.com account.

## Set Up Your Web Hooks

Open your account preferences, and click on the Webhooks tab.

<img src="http://lostechies.com/derickbailey/files/2014/03/NewImage2.png" alt="NewImage" width="300" height="189" border="0" />

Click the &#8220;Add URL&#8221; button in the bottom right. Add your bin&#8217;s URL.

<img src="http://lostechies.com/derickbailey/files/2014/03/NewImage3.png" alt="NewImage" width="400" height="174" border="0" />

Since you&#8217;re interested in testing the web hooks to get access to the real data, make sure the &#8220;Mode&#8221; is set to test. Click the &#8220;Create&#8221; button when you&#8217;re done and it will show up in the list of webhooks.

<img src="http://lostechies.com/derickbailey/files/2014/03/NewImage4.png" alt="NewImage" width="300" height="190" border="0" />

## Test It

Now that you have it configured, you can do some testing. Set up subscriptions, test customers and all that jazz. For me, I had a bunch of test customers in my test mode already. So I just went in and invoiced one of them that had a subscription. Be sure you&#8217;re in test mode, first.

<img src="http://lostechies.com/derickbailey/files/2014/03/NewImage5.png" alt="NewImage" width="250" height="84" border="0" />

After you do some stuff with a sample account and subscription or whatever else, hit refresh on the Requestb.in and you&#8217;ll see all the beautiful details of the request!

<img src="http://lostechies.com/derickbailey/files/2014/03/NewImage6.png" alt="NewImage" width="400" height="340" border="0" />

From there, you can save the request details and use that as an example to build your code.

## But Wait! There&#8217;s More!

Of course that isn&#8217;t all that [Runscope](http://runscope.com) can do &#8211; [Requestb.in](http://requestb.in) is only one tool that it provides as a service. Be sure to check out the rest of Runscope including what John Sheehan calls the &#8220;super-charged version&#8221; of [request-capture](https://www.runscope.com/docs/request-capture).

<blockquote class="twitter-tweet" lang="en">
  <p>
    <a href="https://twitter.com/derickbailey">@derickbailey</a> you should try the super-charged version: <a href="https://t.co/RsQeJhIH3y">https://t.co/RsQeJhIH3y</a>
  </p>
  
  <p>
    — John Sheehan (@johnsheehan) <a href="https://twitter.com/johnsheehan/statuses/440331845025423360">March 3, 2014</a>
  </p>
</blockquote>

Runscope seems like something that will be a regular part of my toolbox in the near future.