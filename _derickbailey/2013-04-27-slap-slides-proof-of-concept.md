---
wordpress_id: 1095
title: 'Slap-Slides: Arduino Powered Veggie Chopper Slide Deck Controller'
date: 2013-04-27T14:31:39+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1095
dsq_thread_id:
  - "1239993490"
categories:
  - Arduino
  - JavaScript
  - JohnnyFive
  - Prototype
---
A few weeks ago I half-jokingly tweeted about my desire to turn a SlapChop in to a presentation controller

<img title="NewImage.png" src="http://lostechies.com/derickbailey/files/2013/04/NewImage.png" alt="NewImage" width="320" height="320" border="0" />

… like I said … &#8220;half-jokingly&#8221;

I give you the Slap-Slides, proof of concept! (no audio)



The code is written in [Johnny-Five](https://github.com/rwldrn/johnny-five), running in NodeJS, connected to an [Arduino Nano](http://www.amazon.com/gp/product/B00761NDHI/ref=as_li_ss_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B00761NDHI&linkCode=as2&tag=avocadosoftwa-20). I bought the cheapest veggie-chopper I could find at my local grocery store, ripped the blade out and mounted a 10k button on to the plate that the blade was previously on.

I&#8217;ll be soldering this in to a proper set up housed entirely in the veggie-chopper, and stabilizing the button (right now it fails every 2 or 3 clicks because of the mounting in the veggie chopper.

## **UPDATE: I have it nearly complete.**

I have the primary circuitry soldered on to a component board, and some holes cut in the housing in order to clean up the entrance of a USB cable in to the chopper.

Here&#8217;s a series of pictures that show the components and assembly… making code skinny, one slap at a time 😀

<img title="IMAG1507.jpg" src="http://lostechies.com/derickbailey/files/2013/04/IMAG1507.jpg" alt="IMAG1507" width="338" height="600" border="0" />

<img title="IMAG1509.jpg" src="http://lostechies.com/derickbailey/files/2013/04/IMAG1509.jpg" alt="IMAG1509" width="600" height="338" border="0" />

<img title="IMAG1510.jpg" src="http://lostechies.com/derickbailey/files/2013/04/IMAG1510.jpg" alt="IMAG1510" width="600" height="338" border="0" />

<img title="IMAG1511.jpg" src="http://lostechies.com/derickbailey/files/2013/04/IMAG1511.jpg" alt="IMAG1511" width="600" height="338" border="0" />

<img title="IMAG1512.jpg" src="http://lostechies.com/derickbailey/files/2013/04/IMAG1512.jpg" alt="IMAG1512" width="600" height="338" border="0" />

<img title="IMAG1514.jpg" src="http://lostechies.com/derickbailey/files/2013/04/IMAG1514.jpg" alt="IMAG1514" width="600" height="338" border="0" />

<img title="IMAG1515.jpg" src="http://lostechies.com/derickbailey/files/2013/04/IMAG1515.jpg" alt="IMAG1515" width="600" height="338" border="0" />

<img title="IMAG1476.jpg" src="http://lostechies.com/derickbailey/files/2013/04/IMAG1476.jpg" alt="IMAG1476" width="600" height="338" border="0" />