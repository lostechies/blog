---
wordpress_id: 468
title: Gawker sites breaking the web
date: 2011-04-05T13:11:38+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/04/05/gawker-sites-breaking-the-web/
dsq_thread_id:
  - "271581770"
categories:
  - Rant
---
Another baffling feature of the new Gawker sites re-design is that it appears that they’ve broken the browser’s Back button. Starting at <http://gizmodo.com>, I’ll click a link for an article:

[<img style="border-bottom: 0px;border-left: 0px;padding-left: 0px;padding-right: 0px;border-top: 0px;border-right: 0px;padding-top: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/04/image_thumb.png" width="1015" height="535" />](https://lostechies.com/content/jimmybogard/uploads/2011/04/image.png)

That brings up the Web 3.0 Frames magic and replaces the left frame of the screen:

[<img style="border-bottom: 0px;border-left: 0px;padding-left: 0px;padding-right: 0px;border-top: 0px;border-right: 0px;padding-top: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/04/image_thumb1.png" width="1059" height="602" />](https://lostechies.com/content/jimmybogard/uploads/2011/04/image1.png)

Note the fun “[hash-bang](http://isolani.co.uk/blog/javascript/BreakingTheWebWithHashBangs)” URLs in the address bar. When I click the “Back” button or navigate using the browser’s Back command, the address bar changes but nothing else does:

[<img style="border-bottom: 0px;border-left: 0px;padding-left: 0px;padding-right: 0px;border-top: 0px;border-right: 0px;padding-top: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/04/image_thumb2.png" width="1039" height="577" />](https://lostechies.com/content/jimmybogard/uploads/2011/04/image2.png)

The title bar and main content stays the same, but the address bar goes back to the home page. Nothing else happens, I don’t get back to the original screen I was on. I suppose I’m intended to use only the in-document navigation?

When I first started doing AJAX applications back in 2004-5 or so, one of the cardinal rules we adhered to was “**Don’t break the Back button**”. Has this rule changed, or is the Gawker site design really that bad?