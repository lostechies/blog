---
wordpress_id: 103
title: Why WordPress Sucks, and what you can do about it
date: 2014-01-22T18:49:39+00:00
author: Brad Carleton
layout: post
wordpress_guid: http://lostechies.com/bradcarleton/?p=103
dsq_thread_id:
  - "2159641002"
categories:
  - AWS
  - JavaScript
  - node.js
  - phantom.js
  - wordpress
---
While great as a CMS, wordpress really sucks as your forward facing production environment. After one week in production with our redesigned <a title="TechPines" href="http://techpines.com" target="_blank">wordpress site</a>, we had already racked up **8 hours of downtime** due to database failures.

Also, we&#8217;re paying a hefty **$43 bucks per month** to host the Apache/PHP/Mysql monstrosity on Amazon EC2.

When I play the word association game with WordPress these are the things that come to mind:

  * Downtime
  * Database failures
  * Hackers, and hack bots from all over the Internet
  * Slowness
  * Scaling issues
  * Expensive

Also, WordPress has made some very bizarre design decisions around absolute URLs that I would describe as &#8220;dumb&#8221;.  Here are some actual forum topics on the subject.

  * WP Forum: <a href="http://wordpress.org/support/topic/uploaded-images-why-absolute-urls-its-so-stupid" target="_blank">Why Absolute URLs, it&#8217;s so stupid</a>
  * WP Forum: <a href="http://wordpress.org/support/topic/please-remove-absolute-urls-from-wp" target="_blank">Please remove absolute URls from WordPress</a>

## How I fixed WordPress

The only thing that can fix bad technology is good technology, so I came up with a solution that involved using Amazon S3 and Node.js/Phantom.js to build a rock solid, high performance frontend for super cheap.

[<img class="alignnone size-full wp-image-105" title="wordpress" src="/content/bradcarleton/uploads/2014/01/wordpress.png" alt="wordpress" width="598" height="442" srcset="/content/bradcarleton/uploads/2014/01/wordpress.png 598w, /content/bradcarleton/uploads/2014/01/wordpress-300x222.png 300w" sizes="(max-width: 598px) 100vw, 598px" />](/content/bradcarleton/uploads/2014/01/wordpress.png)

By using Phantom.js and Node.js, I was able to crawl the entire site, and pull every single resource from wordpress and the pipe it over to S3 for Static Web Hosting.

If you&#8217;re looking for a tutorial on static web hosting, read this [excellent post](http://chadthompson.me/2013/05/06/static-web-hosting-with-amazon-s3/) by Chad Thompson.

## Life on Amazon S3 is Nice

So now, my production environment on Amazon S3 has these wonderful qualities:

  * **99.99% Uptime**
  * **$0.01/month** Hosting Cost (based on 100MB of data)
  * Fast response times
  * Scales automatically with traffic
  * Built to sustain the loss of two concurrent data centers
  * Hackers now have to hack Amazon (good luck with that)

If you go to the <a title="TechPines" href="http://techpines.com" target="_blank">new site</a>, and open up a javascript console, you should see this:

[<img class="alignnone size-full wp-image-110" title="techpines-console-with-marks" src="/content/bradcarleton/uploads/2014/01/techpines-console-with-marks.png" alt="" width="598" height="337" srcset="/content/bradcarleton/uploads/2014/01/techpines-console-with-marks.png 598w, /content/bradcarleton/uploads/2014/01/techpines-console-with-marks-300x169.png 300w" sizes="(max-width: 598px) 100vw, 598px" />](/content/bradcarleton/uploads/2014/01/techpines-console-with-marks.png)

Notice, it&#8217;s all the familiar URLs from wordpress, **/wp-content** and **/wp-content/themes**, but all coming from Amazon&#8217;s rock solid S3 service.

As an added bonus, I have the option of doing additional processing of resources as they are piped, so I could compact and minify JS and CSS resources, or create 2X size images for retina displays or any other kind of processing without ever touching the backend of the wordpress site.  Pretty cool.

_Side Note: If you&#8217;ve got a WordPress site, and you&#8217;re interested in hearing more about this, please feel free to contact me._