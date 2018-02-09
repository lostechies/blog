---
wordpress_id: 610
title: Quick Hack To Work Around Jasmine-jQuery Fixture Limitations
date: 2011-10-14T14:53:03+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=610
dsq_thread_id:
  - "443586029"
categories:
  - Jasmine
  - JavaScript
---
I use Jasmine-jQuery to help out my Jasmine tests. It&#8217;s a great little plugin and generally makes my life easier. I ran into an issue today, though, and rather than trying to fix the real problem (which I think is going to be difficult), I created a quick workround in my own code.

## The Problem: setFixtures Wipes Out Previous Fixtures

That pretty much sums it up… when you call \`setFixtures(&#8220;….&#8221;)\` to add some HTML fixture to your app, this call will wipe out all of the previous fixtures that you had set up. This means you can&#8217;t have call calls to setFixtures, and means you have to set up all of your fixtures at the same time in the same place.

This doesn&#8217;t work well with the way I wrote my tests. I use helper methods to set up various bits of context, including fixtures that I need. So, I need a way to add more fixtures over time. <span style="white-space: pre;"></span>

## <span style="white-space: pre;">T</span>he Hack: \`addFixture\` And \`clearMyFixtures\` Methods

Here&#8217;s the gist of my hack to work around it. Add this code to a .js file in \`spec/javascript/helpers/\`

{% gist 1288292 1.js %}

Then you can call \`addFixture\` in your \`beforeEach\` method. Be sure to call \`clearMyFixtures\` in an \`afterEach\` block as well.

{% gist 1288292 2.js %}

The \`beforeEach\` method keeps a running tally of all the fixtures that you want to add, in a simple array. Every time you call this method it appends the new fixture to the existing list, joins them all together and calls the real setFixture method. This works around the limitation of how setFixtures will wipe out your existing fixtures.

In order to prevent every fixture from appending over and over and over forever, though, I needed a method to clean it all up. The \`clearMyFixtures\` method does exactly this. It deletes the array of fixtures that I&#8217;m storing so the next time you call \`addFixture\`, it starts over with an empty list.

## No Really, It&#8217;s Just A Hack

I don&#8217;t plan on using this forever. At some point I want to see if I can help out the Jasmine-jQuery plugin and fix the underlying problem (as I see it, anways). For now, this hack will do.
