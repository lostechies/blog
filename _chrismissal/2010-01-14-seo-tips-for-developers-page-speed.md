---
wordpress_id: 3372
title: 'SEO Tips for Developers : Page Speed'
date: 2010-01-14T02:15:31+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2010/01/13/seo-tips-for-developers-page-speed.aspx
dsq_thread_id:
  - "262175101"
categories:
  - Best Practices
  - SEO
redirect_from: "/blogs/chrismissal/archive/2010/01/13/seo-tips-for-developers-page-speed.aspx/"
---
I have been paying a good amount of attention to <strike>Google</strike> search engines since I started at my current job almost 3 years ago. Working on a public web site has more of a need for creating a robot friendly, content rich web pages than an internal web application. I don’t like to keep things to myself (I find it rude) so I thought I’d share some quick tips. These are more aimed at developers, than designers or content writers, of web sites.

## Speed, speedier and speediest!

The start of a new year is always a good time to begin something new. Google has <strike>decided</strike>&#160;_hinted_ that they’re going to begin giving higher page rank to faster web sites. This makes sense, I don’t want to click on the first result if it is dog-slow, I’d rather click on something almost equally relevant that is faster. As a developer, think about how you serve the requests that are made. According to Google, a page loading in 1.4 seconds isn’t even in the top 20% of all measured web sites and 3.2 second page load is in the bottom half.

> ### <u>Enable compression of the files you send</u>
> 
> How do you do this? I’m not going to explain it when there are so many others already have (much better than I could too!). A simple search will give you plenty of results describing how to enable this with your specific server set-up. Even fellow blogger [Keith Dahlby describes how to enable this in IIS](/blogs/dahlbyk/archive/2010/01/08/script-to-enable-http-compression-gzip-deflate-in-iis-6.aspx "Enable Compression in IIS").
> 
> ### <u>Send fewer bytes per file</u>
> 
> This one is beneficial two-fold. The first gain is going to be quicker downloads to the client and the second is that the browser can “paint” the page faster; especially if you’re doing any kind of DOM manipulation when the document is ready. This is also relevant for your images, the smaller the file size, the faster the download. 
> 
> ### <u>Minify JS and CSS files</u>
> 
> While similar to the previous tip. This is different in that you remove comments and whitespace where available. Depending on the size of your JavaScript and CSS files, you can save quite a lot by doing this. You obviously don’t want to keep them minified in source control, so do this as part of a build or deployment process.

### 

I think it’s common for developers to look at server code when thinking about performance. Not only do you want your C#, Ruby or Java to run quickly, but also all the tiny pieces that tie things together. You’ll likely find bigger gains in some of these tips than in others, but even the little things can help you in the long run. Imagine increasing your traffic by twenty times? What about new features slowly adding more “bloat” to your pages? It’s the little things that can help combat those types of speed bumps.

That’s going to wrap it up for now, there will be more SEO tips for developers to come later. If you want to know more details of how I’ve accomplished these speed tips, hit me up on Twitter (<a href="http://twitter.com/ChrisMissal" rel="nofollow">@ChrisMissal</a>) or leave a comment!

> _Also, here are some helpful links, use them, know them:_
> 
>   * _[Google Webmaster Tools](http://www.google.com/webmasters/)_ 
>   * _[Ben Lowery’s HttpCompress](http://blowery.org/httpcompress/)_ 
>   * _[YUI Compressor](http://developer.yahoo.com/yui/compressor/)_