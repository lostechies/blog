---
wordpress_id: 3385
title: Quirk with Invalid Git Config
date: 2010-12-23T00:34:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2010/12/22/quirk-with-invalid-git-config.aspx
dsq_thread_id:
  - "262175209"
categories:
  - git
redirect_from: "/blogs/chrismissal/archive/2010/12/22/quirk-with-invalid-git-config.aspx/"
---
I bumped into what seems like a weird quirk with one of my git config files today. A bad value was reported:

<pre>error: Malformed value for branch.autosetuprebase<br />fatal: bad config file line 18 in .git/config</pre>

![](//lostechies.com/chrismissal/files/2011/03/git-line-18.png)&nbsp;

_In the image, you&#8217;ll notice the branch reads &#8220;(ref: re&#8230;)&#8221;_

I was getting this error because I incorrectly had the value of &#8220;true&#8221; for branch.autosetuprebase instead of &#8220;always&#8221;. Luckily, the error line tells me which setting has the incorrect value, but reports it as line 18 when in actuality, the line is 17. If I misspell autosetuprebase, the following error is reported:

<pre>fatal: bad config file line 17 in .git/config</pre>

![](//lostechies.com/chrismissal/files/2011/03/git-line-17.png)

It seems weird that an error on the same line would report two different line numbers depending on whether it was the key or the value that contained the issue. If you run across a config error like this, just try to remember to look at the value if it supplies you with the setting. If it&#8217;s generic enough like the second error, it&#8217;s probably the right line number. Since I&#8217;m not a pro at git, I&#8217;d be curious to know why it behaves this way if anybody can provide any insight.