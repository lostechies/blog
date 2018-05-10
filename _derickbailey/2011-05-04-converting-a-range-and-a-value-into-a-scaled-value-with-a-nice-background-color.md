---
wordpress_id: 293
title: Converting A Range And A Value Into A Scaled Value, With A Nice Background Color
date: 2011-05-04T06:36:17+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=293
dsq_thread_id:
  - "295035761"
categories:
  - Analysis and Design
  - HAML
  - Math
  - Rails
  - Ruby
  - SASS
---
I&#8217;m working on a web app that receives HL7 formatted medical data through my import utility that I&#8217;ve talked about a lot, recently. Once I receive those results, I have to parse them out of the file and then display a nice little chart that shows the value of the results we care about with a color-coded indicator of health risk.

It&#8217;s essentially supposed to look like the 1st and 2nd columns of this sample data file:

<img src="https://lostechies.com/content/derickbailey/uploads/2011/04/Screen-shot-2011-04-28-at-3.54.32-PM.png" border="0" alt="Screen shot 2011 04 28 at 3 54 32 PM" width="600" height="148" />

 

### The Rules And Ranges

Here&#8217;s the core set of requirements with examples:

  * I have a range, which could be made of two integers or a floating point numbers, and a value within that range. 
  * I need to convert the range to a fixed size range (0..10) and adjust the value accordingly
  * if the value is below the range, return 0.
  * if the value is above the range, return 10.

For example, If I have a range of 1 through 100 with a value of 50, when I  convert to range 0 through 10, the adjusted value is 5. Once I have the adjusted value, I can use a range of css classes to get the correct color for the background of the value I am displaying.

It&#8217;s not quite that simple, though. In the above picture, I&#8217;ve included the last three columns to illustrate the types of ranges that I have to deal with. Most of them are fairly straight forward ranges, but none of them are close to same. We have ranges that vary from 3.55 => 8 to 200 => 239. On top of that, some of the ranges are inverted, such as HDL-C where the range is 40 => 20, higher to lower.

 

### A Math Lesson: Scaling The Range And Value

To keep things simple at first, I decided to start with the normal ranges; lower number => higher number. Even at that, it took me a while to figure this out. Fortunately I had some [help from David Alpert and Dean Weber in verifying what I was doing](https://gist.github.com/946728).

It&#8217;s much easier to think about the scale of one range compared to another, when we think about the size of the ranges, not the actual numbers that are contained within them. With any given range, the actual values are somewhat arbitrary. For example, a range of 0 => 50 has a size of 50. Similarly, a range of 133 => 183 also has a size of 50.  If we are given a range with a size of 50, and we need to scale that down to a range with a size of 10, the scale is pretty obvious; 50/10 or 5:1.

Using the size of the range is a much easier way to look at an arbitrary range, such as the 200 => 239 range for Total Cholesterol. Instead of trying to figure out how to scale this range, we only need to figure out how to scale it&#8217;s size.

Once we have the proper scale in place, we can apply that scale to the value that we have within the original range. For example, in a range of 100 => 150, a value of 125 is halfway through the range. We also know that in our target scale of 0 => 10, 5 is the halfway point. It&#8217;s easy to infer, then, that a value of 125 in our 100 => 150 range will scale down to a value of 5 in our 0 => 10 scale. We can use this knowledge as a basic test to ensure we have the correct scaling / adjustment code.

After adjusting the range by subtracting the low end from the high end, we need to adjust the value in the same manner. That is, we need to take the value and subtract the lower end of the range. Since 150 minus 100 is 50, to give us the size of our range, we will now take our value of 125 and subtract 100, which gives us 25.

Next, we take the scale of our range compared to the target, 5:1, and reverse that into a fraction: 1/5th. If we calculate 1 / 5, we get 0.2 or 20%. We can then multiple the adjusted value of 25 by 0.2 (a.k.a 20%, a.k.a 1/5th, a.k.a 5:1 ratio). 25 * 0.2 == 5; halfway between 0 and 10, our target range. To verify, we take our adjusted value of 25 and divide it by the range size of 50. This gives us a value of 0.5 or 50%. Given our target range has a size of 10, 50% of 10 is 5.

To verify our math, let&#8217;s apply it to another range and value: range 275 => 295 and value 290. The size of this range is 295 &#8211; 275 == 20. The scale of a range of size 20 compared to the target range of 10 is 2:1, or 1/2 or 0.5. The adjusted value is 290 &#8211; 275 == 15.  When we scale the adjusted value of 15 down by 0.5, we end up with 7.5, which is 75% of the way through our range size of 10. To verify, we can divide 15 by 20 (the adjusted value and range size) and we get 0.75 or 75%.

Notice that we can&#8217;t use the literal values to do the verification. If we took 125 / 150 from the first example, we would end up with 0.8333333. If we took 290 / 295 from the second example, we would end up with 0.98305. Neither of these is correct because we are not looking at a range of 0 to 150 or a range of 0 to 295. Therefore, It&#8217;s not the literal numbers that are valuable in these calculations, but the size of the range that we are dealing with and the value adjusted accordingly.

 

### Implementing The Math In Ruby

In spite of the long explanation of the solution, the code is fairly short. You can see the full implementation of my ruby class via [the github gist that David, Dean and I used to discuss the problem](https://gist.github.com/946728). Here&#8217;s the gist of the gist, though. (In this case I chose to use the words &#8220;goal&#8221; to represent the low end of the range, and &#8220;high_risk&#8221; to represent the upper end of the range. I did this because these are the meaningful terms used in the system. Proper modeling of the domain is always a good idea).

<pre>def score(value)
  range_size = self.high_risk_above - self.goal_below

  adjusted_value = (value - self.goal_below)
  adjusted_value = 0 if adjusted_value &lt; 0
  adjusted_value = range_size if value &gt; self.high_risk_above

  value_percent = (adjusted_value / range_size)

  raw_score = (10 * value_percent)

  score = raw_score.round(0).to_i<br />end </pre>

 

Note that my code is rather verbose so that I could easily identify everything that was happening along the way. David provided a much more terse version of my solution in the comments of the gist.

We can run several tests on this to verify that is works correctly, too:

<pre>range = RangeResults.new(:goal_below =&gt; 10, :high_risk_above =&gt; 60)

range.score(10) #=&gt; 0
range.score(5) #=&gt; 0
range.score(20) #=&gt; 2
range.score(35) #=&gt; 5
range.score(60) #=&gt; 10
range.score(80) #=&gt; 10</pre>

 

(If anyone is really interested, I have a full set of rspec tests that provide executable proof that my code works. I can provide this via github if you want.)

 

### Using CSS To Determine The Cell Color

Now that I have my score calculation all set and I am reliably receiving the correct values, I need to create a way to display the correct color for the score. There were several options for this, of course. I could use back ground images to create the nice little blocks I need. I could use a dive with a background image that is a flat color and have a css border. Or I could go with pure css and set the background color, border and anything else that I need. I decided to go with the pure css approach. To do this, I created 10 classes in my css file, named &#8220;zero&#8221; through &#8220;ten&#8221;, along with a &#8220;result&#8221; class that sets up the box with border.

<pre>p.result
  +column(1)
  +border-radius
  padding: 2px
  border: 1px solid $gray
  text-align: center
p.zero
  background-color: #00ff00
p.one
  background-color: #33ff00
p.two
  background-color: #66ff00
p.three
  background-color: #99ff00
p.four
  background-color: #ccff00
p.five
  background-color: #ffff00
p.six
  background-color: #ffcc00
p.seven
  background-color: #ff9900
p.eight
  background-color: #ff6600
  color: #ffffff
p.nine
  background-color: #ff3300
  color: #ffffff
p.ten
  background-color: #ff0000
  color: #ffffff</pre>

 

Note that I am using SASS and not straight CSS. The &#8220;+column&#8221; and &#8220;+border-radius&#8221; are SASS mixins that give me all of the CSS that I need to create a box that is 1 column wide (with a column width being defined elsewhere) and css rounded corners for my border.

 

### Putting It All Together Into A Nice Pretty Page

I need a way to turn 0 => 10 as integer values, into &#8220;zero&#8221; through &#8220;ten&#8221; as string values. This was easy enough:

<pre>def i_to_s(i)<br />  ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"][i]<br />end </pre>

 

Now that I have all of the css in place and I have the score coming back correctly to tell me what css class I need, I have to put it all together in my rails view. I&#8217;m using HAML to generate my views, which makes it fairly simple to specify a css class based on the value from a model. My model, of course, represents the lipids that I&#8217;m dealing with and each of the lipids values.

<pre>%ul
  %li
    %p Total:
    %p{:class =&gt; "result #{lipids.total.score}"}= lipids.total.value if lipids
  %li
    %p HDL:
    %p{:class =&gt; "result #{lipids.hdl.score}"}= lipids.hdl.value if lipids
  %li ...
</pre>

 

Our actual page design does not reflect the original image that I showed above, completely. That image came from a lab results document and not from the page design for our system. Our pages do not need all of that information, only some of it, to be useful.

The end result looks like this:

<img src="https://lostechies.com/content/derickbailey/uploads/2011/04/Screen-shot-2011-04-28-at-9.29.48-PM.png" border="0" alt="Screen shot 2011 04 28 at 9 29 48 PM" width="402" height="237" />

 

### A Few Additional Requirements

Looking back at the original requirements, there are some obvious items missing from my code and a few of the colors shown in the end result are incorrect, because of these additional requirements.

For example, I haven&#8217;t shown how to handle the inverse ratios. I also haven&#8217;t shown how to handle the value being above or below the actual range (which is valid in my case; note the < and > on the ranges in the image at the top of this post). These are fairly trivial exercises to do, though they do require a little more thought about the size of ranges and how to calculate the adjusted values.

I&#8217;ll give you a hint for the inverse ranges: you&#8217;ll need to find the absolute value of the size and you&#8217;ll need to min and max the uppder and lower values of the range. But that&#8217;s all I&#8217;m going to say right now. I&#8217;ll leave these additional requirements for you to solve, if you&#8217;re interested in doing that.

 

### Math: A Fun Little Diversion For A Developer

I hope my little math lesson and solution were enlightening. I certainly had fun figuring this out. I don&#8217;t get to do any significant amounts of math in most of my projects. I do thoroughly enjoy it, though, so when I have the opportunity to implement something like this, I really like to dig in and understand why the math works, not just how.