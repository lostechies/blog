---
wordpress_id: 1160
title: How To Set A Page Title And H1 Tag With A Single Jade Template Block
date: 2013-10-10T07:54:08+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1160
dsq_thread_id:
  - "1843012887"
categories:
  - Uncategorized
---
Yesterday, I accidentally figured out that you can use a [Jade template](http://jade-lang.com/) &#8220;block&#8221; in more than one location, and any content you put into the block will show up in all of the locations. It&#8217;s a pretty simple trick, but it made setting the page <title> and <h1> title blocks in [SignalLeaf](http://signalleaf.com) a lot easier than I expected.

## Setup The Blocks

In your layout.jade file, add a `block title` to your `<title>` tag, and also in the body of your document where you want the page title to be displayed.

[gist id=6918552 file=layout.jade]

Notice the extra info that I included in the `<title>` tag. You can put whatever you want prior to, inside of, and after the `block title`  The resulting `<title>` tag will contain all of the content that you specify, including the content within the block, by default. This gives you a default page title for any page that forgets to include a `block title`.

## Set The Title In A Page

Once you have the layout set up, you can specify a `block title` in any content page that extends from the layout.

[gist id=6918552 file=somePage.jade]

When you do this, the result is a page that has both the `<title>` tag and the page&#8217;s `<h1>` title set to the same content.