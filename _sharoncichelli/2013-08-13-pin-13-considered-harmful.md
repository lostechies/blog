---
id: 222
title: Pin 13 Considered Harmful
date: 2013-08-13T22:20:13+00:00
author: Sharon Cichelli
layout: post
guid: http://lostechies.com/sharoncichelli/?p=222
dsq_thread_id:
  - "1604811121"
categories:
  - Arduino
  - electronics
tags:
  - arduino
---
The scariest thing about teaching is the risk of being wrong. 

Maybe you can relate? Written some blog posts, given a few talks, published an article, and _then_ found out your spiel contained a piece of inaccurate&mdash;or even damaging&mdash;information? Hits right in the pit of your stomach, doesn&#8217;t it.

Yeah, well.

Please allow me to correct something I&#8217;ve learned since starting my [Hello, Arduino](http://www.girlwritescode.com/2013/01/hello-arduino-lets-get-started.html) talks and writing my [Arduino article for _CODE Magazine_](http://code-magazine.com/Article.aspx?quickid=1305081).

I&#8217;ve plugged an LED directly into pin 13 and GND. Don&#8217;t do this.<figure id="attachment_223" style="max-width: 398px" class="wp-caption alignnone">

[<img src="http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/led_bb_sm.png" alt="Although the leads of an LED fit conveniently into pins 13 and Ground, this can damage the LED." title="led_bb_sm" width="398" height="405" class="size-full wp-image-223" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/led_bb_sm.png 398w, http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/led_bb_sm-295x300.png 295w" sizes="(max-width: 398px) 100vw, 398px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/led_bb_sm.png)<figcaption class="wp-caption-text">Don&#8217;t plug an LED directly into pin 13.</figcaption></figure> 

An LED can handle only so much current. The limit is printed on the packaging, usually something like 20 mA (milliAmps). If you exceed that, you&#8217;ll either gradually or immediately burn out the LED, and possibly damage the pin on the microcontroller chip. Therefore, LEDs must always be put in-series with a current-limiting resistor. Like this:<figure id="attachment_226" style="max-width: 470px" class="wp-caption alignnone">

[<img src="http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/led_wResistor_bb_and_schem1.png" alt="A resistor should be included in-series with the LED." title="led_wResistor_bb_and_schem" width="470" height="500" class="size-full wp-image-226" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/led_wResistor_bb_and_schem1.png 470w, http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/led_wResistor_bb_and_schem1-282x300.png 282w" sizes="(max-width: 470px) 100vw, 470px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2013/08/led_wResistor_bb_and_schem1.png)<figcaption class="wp-caption-text">Use a resistor to limit the current to the LED.</figcaption></figure> 

The formula for current is voltage divided by resistance. By convention, current is abbreviated as I, so you have: I = V/R. V is the 5 volts supplied by the Arduino, and you can see that if resistance (R) is really tiny (almost zero), current (I) gets huge! Followed by&#8230; _bzorch._

Figuring out the right R value for your circuit is a blog post unto itself. In the meantime, there are plenty of online calculators, such as this [current-limiting resistor calculator for LEDs](http://ledcalc.com/).

The early-earliest revisions of the Arduino included a resistor on pin 13. Current versions do still have a resistor in series with the on-board LED attached to pin 13, but not with the pin itself. This was likely what confused me and keeps this incorrect advice bouncing around the &#8216;net. When a friendly electrical engineer at [TechShop](http://www.techshop.ws/) set me straight, it was, of course, after my article had hit the newsstands.

Ah, well. Another day, another chance to fry some components and become wiser. Forgive me, learn with me, use a resistor with your LEDs, and build great things!