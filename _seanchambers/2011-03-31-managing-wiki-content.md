---
wordpress_id: 3230
title: Managing Wiki content
date: 2011-03-31T20:37:22+00:00
author: Sean Chambers
layout: post
wordpress_guid: http://lostechies.com/seanchambers/?p=111
dsq_thread_id:
  - "268019959"
categories:
  - Process
---
In the recent past we&#8217;ve setup a wiki in my organization, it is used by project managers and developers alike. As a result, we have had a surge of content placed onto the wiki without much organization or planning on what content should go where. Here&#8217;s some tips for managing wiki content if you&#8217;re using [MediaWiki](http://www.mediawiki.org/wiki/MediaWiki) like us, or any wiki software for that matter. Please note that I just recently started to organize our content so if you have any tips please add to the list!

**1. Use Categories**

[Categories](http://www.mediawiki.org/wiki/Help:Categories) provide an easy way to group wiki content. By adding a page to a category, it is added to an alphabetical list on the category page. You can even nest categories within categories for a hierarchical category listing.

**2. Group landing page content**

One thing that started to happen on our wiki was the landing page became the starting point for any wiki page. We all would place a link to the new page in a general area of where the content fit. Over time the landing page became a very large list of bullet points under a number of headings. Now that we started using categories, we&#8217;ve started to cut down on the number of content on the homepage and placing them in relevant category pages.

**3. Namespaces**

Although I haven&#8217;t played with namespaces yet, MediaWiki has a nifty way of &#8220;namespacing&#8221; your pages into higher level groups. MediaWiki comes with a list of [builtin namespaces](http://www.mediawiki.org/wiki/Namespaces) and you can add your own by making some modifications to the MediaWiki configuration.

**4. Use SpecialPages**

A great feature that they have in MediaWiki is &#8220;[SpecialPages](http://www.mediawiki.org/wiki/Special:SpecialPages)&#8220;. Special pages provide a great way to find dead content, unlinked pages, long pages and other ways to find content that needs to be refactored. Often, I use these pages as a starting point to target my refactorings. In much the same way that we use static code analysis tools to target refactorings, these pages are a great way to find a starting point.

I&#8217;m sure there&#8217;s several other great organizing techniques to keeping wiki&#8217;s up to date and would love to hear them from everyone and to share with the community. I had a hard time finding any good blog posts on wiki organization so hopefully this will aid someone in the future as a good starting point.