---
wordpress_id: 756
title: 'HTML5 And Internet Explorer: Modernizr To The Rescue!'
date: 2012-01-23T07:33:24+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=756
dsq_thread_id:
  - "549662643"
categories:
  - HTML5
  - User Experience
---
My wife wanted to see my [WatchMeCode](http://www.watchmecode.net) website so she could post it on her Pinterest (which is a site I don&#8217;t understand… but that&#8217;s beyond the point).

## IE Hates HTML5

She pulled it up on her work laptop, which was equipped with… IE8! … and it looked like this:

<img title="Screen Shot 2012-01-22 at 8.01.29 PM.png" src="http://lostechies.com/content/derickbailey/uploads/2012/01/Screen-Shot-2012-01-22-at-8.01.29-PM.png" border="0" alt="Screen Shot 2012 01 22 at 8 01 29 PM" width="600" height="477" />

Of course that&#8217;s not at all what I expected the site to look like. I expected it to look more like this:

<img title="Screen Shot 2012-01-22 at 8.06.43 PM.png" src="http://lostechies.com/content/derickbailey/uploads/2012/01/Screen-Shot-2012-01-22-at-8.06.43-PM.png" border="0" alt="Screen Shot 2012 01 22 at 8 06 43 PM" width="600" height="540" />

This site is one of the first I&#8217;ve built using the modern HTML5 tags like <header>, <section>, <article>, and <footer>. I know IE doesn&#8217;t like tags that it doesn&#8217;t recognize and IE8 or below certainly don&#8217;t recognize HTML5 tags.

## Modernizr To The Rescue!

The answer is simple, fortunately. Grab a build of [Modernizr](http://www.modernizr.com/) and drop it in to your site… only, I already had it in my site. So why was it still looking all broken and stupid?

It turns out I had the Modernizr script at the very bottom of the HTML <body> tag &#8211; one of the tricks for performance optimization of loading scripts. However, including Modernizr at this point means that IE won&#8217;t recognize the new HTML5 tags until after the page has already loaded, thus the broken site design.

Push the Modernizr script up to the top of the <head> and everything works. Of course, I&#8217;m using some CSS3 so it&#8217;s not perfect, but it&#8217;s certainly nice in comparison to the broken version:

<img title="Screen Shot 2012-01-22 at 8.03.45 PM.png" src="http://lostechies.com/content/derickbailey/uploads/2012/01/Screen-Shot-2012-01-22-at-8.03.45-PM.png" border="0" alt="Screen Shot 2012 01 22 at 8 03 45 PM" width="600" height="479" />

Now the interesting bit is that I don&#8217;t really need IE support in my website. I only get 3.6% of my traffic from IE users &#8211; I really don&#8217;t expect people that are interested in the guts of JavaScript to be IE users after all. But with a fix as simple as this, it&#8217;s not a big deal to go ahead and add minimal support just to keep the site

## Use Modernizr&#8230; At The Top Of Your HTML

The morale of the story: use Modernizr. It&#8217;s just that easy. Of course it does a lot more than just include an HTML5 shim for older browsers, too. There&#8217;s a ton of great stuff in it. But in my case, that&#8217;s all I really needed it for.

And when you do use it, be sure to include it in the <head> of your HTML so that it applies before the rest of your page loads.