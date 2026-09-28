---
wordpress_id: 86
title: Infinity ErgoDox
date: 2015-11-02T23:25:00+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: https://lostechies.com/joshuaflanagan/?p=86
dsq_thread_id:
  - "4284829146"
categories:
  - Hardware
---
I’ve always been picky about my keyboard, but recently discovered an entirely new world of keyboard enthusiasts. [Aaron Patterson was on the Ruby Rogues podcast](https://devchat.tv/ruby-rogues/200-rr-200th-episode-free-for-all-) talking about mechanical keyboard kits. As in, keyboards you build yourself. You pick out the key switches (get just the right clicky feel), you pick out the keycaps, you pick a layout, etc. And then you solder all the parts together. That sounded pretty extreme to me! But I was just getting back into hardware hacking (arduino, etc) and figured it would make for a fun project.

Intrigued, I did some research, and discovered that Massdrop was just starting an effort to build the [Infinity ErgoDox](https://www.massdrop.com/buy/infinity-ergodox) &#8211; an update to the popular ErgoDox. Perfect, I placed an order (I went with Cherry MX Blue switches and blank DCS
  
keycaps, in case that means anything to you). And waited. That was back in April. I pretty much forgot about it until a box arrived from Massdrop a couple weeks ago.

![parts](http://www.joshuaflanagan.com/blog/assets/infinity_ergodox_parts.jpg)

I finally got a rainy weekend to dedicate some time to it. Reading the forums, people were saying that this was a much easier build than the ErgoDox, with one mentioning a 20 minute build time. I think it took me 20 minutes to get all my tools out and unwrap everything. This was not a cheap keyboard, the parts are currently scarce, and most of the documentation seems to assume more knowledge of the process than I had. But taking my time, soldering the key switches to the PCB, installing the stabilizers, assembling the case, I had a working keyboard about four hours later!
  
![a keyboard](http://www.joshuaflanagan.com/blog/assets/infinity_ergodox_assembled.jpg)

Well, kinda. The hardware is only half of the story. The cool thing about the Infinity ErgoDox is that it has a [completely customizable (open source) firmware](https://github.com/kiibohd/controller). Now that I have a device with a bunch of keys on it, I can decide exactly
  
what all of the keys do. It has an online configurator to build your customized firmware for you, if all you want to do is re-map keys. But if you really want to get fancy, you can build the firmware from source. This exposes all of the capabilities of the device. Specifically, this keyboard kit includes a 128&#215;32 LCD panel, as well as a controller to individually address each key’s backlight LED (not included in the kit &#8211; bring your own fun colors).

The best part is that there is a lot of unexplored territory. The existing firmware code has some very crude support for the LCD and LEDs &#8211; just enough to prove that they work. So there is a lot of room to flesh them out further, to try and support all the silly things people might want to light up while they type. That’s the part I am most excited about. Eventually, I’ll probably enjoy typing on it, too.

_Originally posted at <http://www.joshuaflanagan.com/blog/2015/11/03/infinity-ergodox.html>_