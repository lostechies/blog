---
wordpress_id: 3383
title: Comments are the Devil
date: 2010-08-18T15:07:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2010/08/18/comments-are-the-devil.aspx
dsq_thread_id:
  - "272576070"
categories:
  - Comments
  - CSS
  - Design
  - DRY
redirect_from: "/blogs/chrismissal/archive/2010/08/18/comments-are-the-devil.aspx/"
---
I recently read Chris Coyier&#8217;s article entitled [Show Markup in CSS Comments](http://css-tricks.com/show-markup-in-css-comments/). I was actually a bit angry that so many responses praised this and so few were turned off from the idea. I appreciate the idea of making things easier for working with CSS, but there are just so many better alternatives.

Some were quick to point out that this is a maintenance nightmare. That is my biggest concern with the coding style. Coyier does well to say:

> Yes, this would require maintenance. If it doesn&rsquo;t make it easier for yourself or for the people you are providing the code to, don&rsquo;t do it.

	<span></span>

I&#8217;m guessing that those who attempt this &#8220;technique&#8221; will soon find out that they won&#8217;t be doing it for long, likely due to the intense headaches it will induce. Coyier also mentions that a tool could be created to automate this. Am I way off here, but isn&#8217;t there a tool already for this? Another window? Split view? A second (or third) monitor?

Like I mentioned earlier, making things easier is great, but whenever you&#8217;re considering using comments to make things easier, try again, &#8220;Comments are always failures.&#8221;<sup>1</sup>

<p style="font-size:smaller">
  1. Robert Martin &#8211; Clean Code
</p>