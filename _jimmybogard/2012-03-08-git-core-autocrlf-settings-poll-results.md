---
wordpress_id: 602
title: Git core.autocrlf settings poll results
date: 2012-03-08T14:42:52+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/03/08/git-core-autocrlf-settings-poll-results/
dsq_thread_id:
  - "603360711"
categories:
  - git
---
The results from [last week’s poll](http://lostechies.com/jimmybogard/2012/03/02/twtpoll-your-git-global-core-autocrlf-settings/) are in! And they couldn’t be [more (less) clear](http://twtpoll.com/tts3oj):

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2012/03/image_thumb1.png" width="485" height="293" />](http://lostechies.com/jimmybogard/files/2012/03/image1.png)

A highly unscientific poll shows an even split between true and false, with a minority choosing the other two options. So that settles it!

What’s interesting is that everyone except the GitHub employees on Twitter were adamant in choosing “false”, while the GitHub employees were adamant for “true”:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2012/03/image_thumb2.png" width="531" height="166" />](http://lostechies.com/jimmybogard/files/2012/03/image2.png)

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2012/03/image_thumb3.png" width="535" height="188" />](http://lostechies.com/jimmybogard/files/2012/03/image3.png)

It’s still so, so silly that this is something we have to worry about. For more reading on the issue, check out:

<http://timclem.wordpress.com/2012/03/01/mind-the-end-of-your-line/>

What will I set? I’m going to try out the .gitattributes way of doing things and just how it goes. But I think we can all agree that core.autocrlf is not something we should have to worry about, up front, for Git users on Windows.