---
id: 503
title: Endemic simplicity
date: 2011-07-08T13:21:41+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2011/07/08/endemic-simplicity/
dsq_thread_id:
  - "352967853"
categories:
  - Rails
---
I was setting up a new website for AutoMapper the other day, and needed to get both a domain name and integration into Heroku, where my site is hosted (for free, by the way). When you host your site with third party application servers, you often need to do work to make sure your DNS records point to the third-party application servers correctly. This ensures that <http://automapper.org> can be handled by where my Heroku site is hosted, at <http://automapper.heroku.com>.

Someone on twitter pointed me at [dnsimple.com](https://dnsimple.com/), which made it dead-simple to both register a new domain and add services. Here’s a screenshot for what I had to do to enable Heroku records:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/07/image_thumb.png" width="644" height="290" />](http://lostechies.com/jimmybogard/files/2011/07/image.png)

See that “Add” button? That’s it, I click that button, and now my DNS host adds the appropriate records for hosting at [Heroku](http://www.heroku.com/). Wow, that was tough. I have a couple of other sites hosted with Heroku, and their DNS manipulation actually required me to fill out the textual DNS entries. In the above case, I have no idea what the entries are, but dnsimple takes care of it all. As you can see, Heroku is just one of many third-party application hosting providers supported.

Simple.

Would anyone be surprised that dnsimple is a Rails application? Not me, anymore. The site is small, targeted, simple and intuitive. The corresponding .NET DNS management sites I’ve used are big, complicated, ugly and hard to use.

To me, this stems more from the endemic simplicity in the Rails community than anything else.

Too bad that Rails is only meant for toy apps 😉