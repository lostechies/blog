---
wordpress_id: 203
title: 'An Interesting &#8220;Feature&#8221; In Ruby&#8217;s DateTime.Parse'
date: 2010-12-15T02:13:33+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/12/14/an-interesting-quot-feature-quot-in-ruby-s-datetime-parse.aspx
dsq_thread_id:
  - "262216407"
categories:
  - Ruby
redirect_from: "/blogs/derickbailey/archive/2010/12/14/an-interesting-quot-feature-quot-in-ruby-s-datetime-parse.aspx/"
---
It&#8217;s not all rainbows and unicorns in the Ruby world&#8230; everything now and then you run into something that really makes you go &#8220;WHAT THE?!&#8221; &#8230; today&#8217;s misadventure comes curtesy of Ruby&#8217;s DateTime.parse method. Generally speaking, this method is quite useful and quite forgiving in what it can parse. It will take a large number of formats and do what it can, even with very little.

For example, did you know that this string will correctly parse: &#8220;SHOW ME THE MONEY!!!&#8221; &#8230; it results in a very &#8220;interesting&#8221; date&#8230; like this:

> => #<DateTime: 2010-12-13T00:00:00+00:00 (4911087/2,0/1,2299161)>

Don&#8217;t believe me? Open up IRB in ruby 1.9.2 and run this:</p> 

Crazy, eh?! I thought so. Here&#8217;s the real fun, though&#8230; the ability for DateTime.parse to work with what should be a completely invalid date string caused a false-positive in a unit test for me earlier today. I wasn&#8217;t using &#8220;SHOW ME THE MONEY!!!&#8221; as the text, but I was passing in a string as &#8220;six\_months\_to\_one\_year&#8221;. The code that was parsing this string had some logic in it that was supposed to produce a value of &#8220;1&#8221; for any date that fell within the range of six months to one year. Oddly enough, this code and logic produced that result because DateTime.parse(&#8220;six\_months\_to\_one\_year&#8221;) parsed as a date that fell within the range I was looking for.

Needless to say, I was expecting an exception to be thrown when this string was parsed and was shocked when the test passed. My incredulity only increased as I tried out various random strings, date ranges in the form of strings, and nonsensical garbage characters &#8211; some of which parsed, too my surprise, and some of which didn&#8217;t, again to my surprise. For example &#8220;how many days are there?&#8221; throws an exception, but &#8220;how many days are there before the wedding?&#8221; does parse.

It&#8217;s crazy I tell you.

After some time, I began to notice a pattern in what parsed, though. At first, I noticed that any string with the word &#8220;month&#8221; in it parsed correctly. I started narrowing down the text until i only had the world &#8220;month&#8221;, then &#8220;mont&#8221;, then &#8220;mon&#8221; &#8211; so far, so good. But then &#8220;mo&#8221; failed. Aha! &#8220;mon&#8221; is the abbreviation for Monday! and what did the original &#8220;six\_months\_to\_one\_year&#8221; parse as? &#8220;Monday, December 13th.&#8221;

See the pattern with the other strings, yet? &#8220;show me the <span style="text-decoration: underline">MON</span>ey&#8221; and &#8220;how many days are the until the <span style="text-decoration: underline">WED</span>ding?&#8221;, or &#8220;I <span style="text-decoration: underline">sat</span> on a thumbtack today! Ouch!&#8221; &#8230; they all have a day&#8217;s abbreviation in them.

No matter how badly munged the rest of the string is, the DateTime.parse will find that abbreviation and parse it as a date because of it. &#8230; at least in Ruby 1.9.2 &#8211; I haven&#8217;t tried on any other versions, yet.

Crazy, eh? Threw me for a serious loop, for quite some time.

 

 