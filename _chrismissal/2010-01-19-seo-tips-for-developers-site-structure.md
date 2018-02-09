---
wordpress_id: 3373
title: 'SEO Tips for Developers : Site Structure'
date: 2010-01-19T04:06:35+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2010/01/18/seo-tips-for-developers-site-structure.aspx
dsq_thread_id:
  - "262175076"
categories:
  - Best Practices
  - SEO
redirect_from: "/blogs/chrismissal/archive/2010/01/18/seo-tips-for-developers-site-structure.aspx/"
---
Continuing in this series of tips for improving your search engine goodness, we’re going to take a look at some tips to designing the structure of your site so that it is friendly for our robot/spider friends.

### Easy to Read URLs

This might be obvious to some, but maybe not others. URLs such as **http://www.lostechies.com/blogs.aspx?blog=52&post=12923** do not have any meaning at face value; I can’t figure out what is on that page unless I click. People don’t like these and the bots don’t either. Strive for URLs like **http://www.lostechies.com/blog/chris-missal/seo-tips-for-developers-site-structure** or something similar. Given some certain situations, these aren’t always easy to come by. However, if you’re designing a site from scratch, give this high priority!

### Good Hyperlinks

Give your users the ability to navigate your site no matter what page they’re on. Dead-end pages and the required usage of the back button is frustrating. You want actual links too, not JavaScript links or the “post-back links” that ASP.NET WebForms provides. Not only are they good for human users, but the spiders will follow them better too.

Ensure that links pointing back to users’ personal sites or other hyperlinks of which you don’t have immediate control, take advantage of the rel=”nofollow” attribute. This encourages search engines to treat the link with little or no weight towards that page. This helps keep your page’s importance higher. If the link is relevant to the content of the page, keep it normal (without the attribute). In other words, do good deeds and don’t try to “game” the system.

### Your Site Template

Based on some of my experience, here’s a few pointers I can share on how to template and build your pages.

  1. Every page that has unique content should have a unique title. Avoid missing or duplicate titles on your pages. This can be tricky when you have lots and lots of overlapping, dynamic content results. 
  2. Make use of the important elements: h1-h6, title, strong, a. These should be used appropriately for the content they’re describing and linking to. These elements carry the highest values of importance across your page. Do your best to connect them to the structure of words that describe your data. 
  3. Similar to point #1, keep your content canonical. This means there should be one location to access that information, not many. By producing one “true location” to the source of the data, you’ll make that page the most relevant place to go and less diluted. Produce canonical or normalized URLs. (see <link rel=”canonical” />)

It may sound a little hokey, but done correctly, these tips can be huge game-changers for you site. Bumping your pages up to the front page of Google gives you far more exposure than the second page and it only gets worse as you go further down the page list.