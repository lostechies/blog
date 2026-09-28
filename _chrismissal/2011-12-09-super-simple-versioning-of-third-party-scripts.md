---
wordpress_id: 3390
title: Super Simple Versioning of Third Party Scripts
date: 2011-12-09T06:21:53+00:00
author: Chris Missal
layout: post
wordpress_guid: http://lostechies.com/chrismissal/?p=91
dsq_thread_id:
  - "498680762"
categories:
  - Continuous Improvement
  - JavaScript
---
_My attention span decreases every day too&#8230; __**tl;dr** &#8211;__ Scroll to bottom of page for a neat code example&#8230;_

Working on a large eCommerce web site gives me the &#8220;privilege&#8221; of working with other companies that integrate with us via JavaScript files placed in our code. Privilege is a euphemism here, it&#8217;s usually a pain. Some are good yes, but many of these companies write crappy JavaScript. Coming from me, that&#8217;s a harsh statement, I love JavaScript but I&#8217;m not as good at it as I&#8217;d like to be.

One of these companies has a couple files on their servers that are slow loading for our users at times. Since we sell to most anybody worldwide our users can come from all over the world. These files are slow to load sometimes because our partner doesn&#8217;t have a very robust server network. We were told that they could not be downloaded from them and served through our domain because they change too often. We were skeptical so I thought it would be interesting to see how often they actually change.

I posted a question on <a title="Me on Twitter" href="http://twitter.com/ChrisMissal" target="_blank">Twitter</a> asking for a program that could be scheduled at a configured interval to download a file via http and version it. I&#8217;d like to see how the file changes over time. It seemed to me like something was probably out there and that I shouldn&#8217;t write something myself, this is why I asked before I started coding like a mad-man. I got some good responses and [cron](http://en.wikipedia.org/wiki/Cron) was the most common response, but I&#8217;m running Windows because that the best OS for our company and the work we do.

The smart and talented [Brian Hogan](http://www.bphogan.com/) (follow him, seriously, do it!) suggested [wget](http://en.wikipedia.org/wiki/Wget), which I already had on my machine at work. In my limited experience with wget, I realized I could schedule a task to run a batch file to issue the wget command. Simple enough, right? Now, when it comes to versioning&#8230; we use [git](http://en.wikipedia.org/wiki/Git_(software)) for all of our source control so why not just set up a local git repo? Brian&#8217;s suggestion and my love of git made this task super simple.

The code is (generically) as follows:

_(you have to run &#8216;git init&#8217; and commit your first version, but from then on&#8230;)_

{% gist 1450416 %}

The moral of this <del>story</del> blog post is that there&#8217;s probably already a good way to do something that I just haven&#8217;t figured out yet. It&#8217;s super common, but can be tough to consider at times. This is why we pair when coding, ask for advice on code design and generally shouldn&#8217;t work in a &#8220;silo&#8221;. Just some food for thought!

If you have more questions on this hit me up on Twitter [@ChrisMissal](http://twitter.com/ChrisMissal).