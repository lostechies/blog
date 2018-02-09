---
wordpress_id: 1089
title: A First Look At My Arduino BBQ Thermometer
date: 2013-04-10T11:01:07+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1089
dsq_thread_id:
  - "1201213779"
categories:
  - Arduino
  - C
  - Hardware
  - JSON
  - KendoUI
  - Mobile
---
I&#8217;ve uploaded a first look at the [Arduino](http://arduino.cc/) powered BBQ thermometer and software that I&#8217;m building. It&#8217;s using an [Arduino Uno](http://www.amazon.com/gp/product/B006H06TVG/ref=as_li_ss_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B006H06TVG&linkCode=as2&tag=avocadosoftwa-20) with [Ethernet shield](http://www.amazon.com/gp/product/B006UT97FE/ref=as_li_ss_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B006UT97FE&linkCode=as2&tag=avocadosoftwa-20). 



The probe is a 100K &#8220;meat probe&#8221; (aka &#8220;thermistor&#8221;) that I took from a store bought meat thermometer. Something like [this replacement probe](http://www.amazon.com/gp/product/B0048GD8RY/ref=as_li_ss_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B0048GD8RY&linkCode=as2&tag=avocadosoftwa-20) would work great. It&#8217;s a bit of a guessing game as to wether the probe is a 10k or 100k Ohm probe. I tried 10, 100, 1k, 10k and finally 100k resistors in my thermistor setup. You can read about thermistor setup on [the Arduino playground](http://playground.arduino.cc/ComponentLib/Thermistor), and at [Hacktronics](http://www.hacktronics.com/Tutorials/arduino-thermistor-tutorial.html).

The Arduino code produces a JSON document when I make an HTTP request to it. The software is built with [Kendo UI Mobile](http://www.kendoui.com/mobile), and reads the JSON document on a 1 second interval.

I&#8217;ll be blogging about this more, and hopefully soon, with plans on going through a step by step &#8220;how I learned&#8221; series &#8211; at least, that&#8217;s the plan. For now, this little teaser video should give you a good idea of what can be done with an Arduino, some simple parts from a store, and a mobile app framework like [Kendo UI Mobile](http://www.kendoui.com/mobile). 🙂

… I need to learn how to optimize my C code for battery life. I&#8217;ve run that 9volt battery maybe 10 or 20 minutes, total, and it&#8217;s already dead. 😛