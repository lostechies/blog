---
wordpress_id: 1115
title: Building A Better SlideChop With Teensy 3.0
date: 2013-06-03T08:04:04+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1115
dsq_thread_id:
  - "1355504009"
categories:
  - Arduino
  - C
  - Hardware
  - SlideChop
  - Teensy
---
[My previous post](http://lostechies.com/derickbailey/2013/04/27/slap-slides-proof-of-concept/) showed a working prototype for what I&#8217;m now calling SlideChop (huge thanks to [Eric Anderson](https://twitter.com/eric_anderson) for the name!) Since then, I&#8217;ve upgraded things a bit and now have a much more stable, much easier to use version. It no longer requires a NodeJS server, and now works on Mac, Linux and Windows. 

![](http://lostechies.com/derickbailey/files/2013/04/NewImage.png)

## Teensy 3.0

The secret is in the use of [a Teensy 3.0 for the controller](http://www.pjrc.com/teensy/). This little device is an [Arduino](http://arduino.cc) compatible micro controller that has a few very specific advantages: it can emulate a mouse, keyboard, joystick or any other native serial communications device, through the hardware itself! All I had to do was write a little bit of C code to handle the click of the physical button, and then call the Mouse.click() method from the Teensy API. Teensy handles the rest for me.

Here are a few images of the Teensy in the hardware setup for the SlideChop:

<img title="IMAG1664.jpg" src="http://lostechies.com/derickbailey/files/2013/06/IMAG1664.jpg" alt="IMAG1664" width="600" height="338" border="0" /> 

<img title="IMAG1666.jpg" src="http://lostechies.com/derickbailey/files/2013/06/IMAG1666.jpg" alt="IMAG1666" width="600" height="338" border="0" />

<img title="IMAG1670.jpg" src="http://lostechies.com/derickbailey/files/2013/06/IMAG1670.jpg" alt="IMAG1670" width="600" height="338" border="0" />

<img title="IMAG1672.jpg" src="http://lostechies.com/derickbailey/files/2013/06/IMAG1672.jpg" alt="IMAG1672" width="338" height="600" border="0" />

If you want to build a hardware device that acts as a human input device, you really need to look at getting a Teensy. I highly recommend them. Do note that you&#8217;ll need to be comfortable with soldering if you want to use one, though. They don&#8217;t come with any header pins attached to them. Be sure to buy pins if you don&#8217;t have any on hand (and why don&#8217;t you? you always need header pins on hand.)

## TeensyDuino

Once you have the hardware, you&#8217;ll want to write software for it. The easiest way to do this is to use the [TeensyDuino plugin](http://www.pjrc.com/teensy/teensyduino.html) for the [Arduino IDE](http://arduino.cc/en/Main/Software). There are command line and other tools available for Teensy, but I prefer the TeensyDuino at this point. It&#8217;s easy and it works well. It&#8217;s also familiar since I&#8217;ve been working with Arduino.

Once you have it installed, you&#8217;ll get some extra menu items in the Arduino IDE. Select the &#8220;Teensy 3.0&#8221; from the Board type menu, and then select &#8220;Keyboard / Mouse / Joystick&#8221; from the &#8220;USB Type&#8221; menu.

<img title="ArduinoToolsMenu.png" src="http://lostechies.com/derickbailey/files/2013/06/ArduinoToolsMenu.png" alt="ArduinoToolsMenu" width="600" height="441" border="0" />

 

 <img title="ArduinoBoardType.png" src="http://lostechies.com/derickbailey/files/2013/06/ArduinoBoardType.png" alt="ArduinoBoardType" width="600" height="208" border="0" />

 

<img title="ArduinoUSBType.png" src="http://lostechies.com/derickbailey/files/2013/06/ArduinoUSBType.png" alt="ArduinoUSBType" width="600" height="175" border="0" /> 

 

Now the Teensy will emulate a Keyboard / Mouse / Joystick, and you can use [the appropriate API for that](http://www.pjrc.com/teensy/td_mouse.html). There&#8217;s no need to include any specific header files or libraries, either. If you have selected the right USB type, then the API is made available without doing anything else.

## SlideChop Code

The code for this is [available from this repository](https://github.com/derickbailey/slidechop). It&#8217;s fairly simple, but I&#8217;m terrible at C code and even worse with run loops. So there are a few bugs in here… most notably is when you hold down the button for a &#8220;right click&#8221;, it sometimes does a left click as well as a right click. I have no idea why… someone else with better C / run loop skillz can probably school me in this pretty quickly, though.

The Teensy has a built in LED and I&#8217;m taking advantage of that. When you plug the SlideChop in to your computer, I blink the LED twice. This tells you that the SlideChop is ready to roll. When you slap the button down, I blink the light. And when you hold the button down for more than a second, I tell the SlideChop to do a right-click and turn the light on for you. This extra little bit of LED goodness is there just to tell you that the code is working. 

## Misc Other Stuff

The veggie chopper itself is the cheapest one I could find at my local grocery store. I tore the metal blade out of it and then mounted a standard [momentary pushbutton](https://www.sparkfun.com/products/97) on to the platform that sits between the veggie holder and the blade itself. I used a small perf-board and some [female headers](https://www.sparkfun.com/products/115) to create a slot that the Teensy can mount in to. The button also connects to the board the same way, and I used a [10K resistor](https://www.sparkfun.com/products/11508) to create a [pull-down resistor](http://en.wikipedia.org/wiki/Pull-up_resistor) setup for the button. The button is mounted to the plastic platform with silicon and soldered to some wires that create the needed 5v power, ground and signal. These wires are soldered to some male header pins that plug in to the female headers on the board.

The veggie compartment has a hole drilled through it with a rubber grommet silicon&#8217;d in place to keep it there. I run the USB cable through this and connect the Teensy to my USB port on my laptop. The Teensy is immediately recognized as a generic human input device. It takes about 10 seconds for a new laptop to configure the driver for this, the first time you plug it in. Then you&#8217;re good to go! Start slapping that button to use it as a standard mouse click. Hold the button down for a second and it will right click, too.

<img title="IMAG1673.jpg" src="http://lostechies.com/derickbailey/files/2013/06/IMAG1673.jpg" alt="IMAG1673" width="600" height="338" border="0" />

## The Demo Video