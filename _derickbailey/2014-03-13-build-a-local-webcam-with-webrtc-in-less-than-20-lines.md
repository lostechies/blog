---
wordpress_id: 1316
title: Build A (local) Webcam With WebRTC In Less Than 20 Lines!
date: 2014-03-13T06:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1316
dsq_thread_id:
  - "2409461774"
categories:
  - HTML5
  - JavaScript
  - WebRTC
---
[WebRTC](http://www.webrtc.org/) is all kinds of super ninja epic awesomesauce stuff. If you haven&#8217;t looked in to it yet, you&#8217;re going to want to get on that soon. I&#8217;d suggest starting with [the HTML5 Rocks post on getUserMedia](http://www.html5rocks.com/en/tutorials/getusermedia/intro/).

## Build Your Own Web Cam

Just how awesome is it? You can build a web page that shows your webcam and hooks up your microphone in 20 lines of JavaScript&#8230; and that includes feature detection with an error message for browsers that don&#8217;t support it!

[gist id=9493718 file=webcam.js]

The gist of it is this:

The first few line sets the options to ignore audio and get video. The next 3 lines do a bit of browser normalization to make sure &#8220;getUserMedia&#8221; is available. Then do the other half of feature detection, and exit the IIFE if it&#8217;s not available at all. Once you&#8217;re certain it&#8217;s ok, run the getUsermedia with the options that were previously set. If there&#8217;s an error, report it via console. If there&#8217;s no error, run the success function and tell the <video> element to play the video from the webcam.

You&#8217;ll need a couple lines of HTML and to make it look nice, a bit of CSS, too.

[gist id=9493718 file=webcam.html]

[gist id=9493718 file=webcam.css]

Note the use of the &#8220;autoplay&#8221; setting in the <video> element. Without this, you&#8217;ll just get a freeze frame from the video. The CSS just makes the video element huge, which is fun.  

## How Well Does It Work?

See for yourself, with [this fancy schamcy JSBin](http://jsbin.com/hokavera/1) (and make sure you hit &#8220;allow&#8221; when your browser prompts you to access your camera:

[WebRTC WebCam](http://jsbin.com/hokavera/1/embed?output){.jsbin-embed}

  


If this doesn&#8217;t work for you, you&#8217;ll end up seeing a link that just says &#8220;WebRTC WebCam&#8221;&#8230; which won&#8217;t surprise me if you&#8217;re reading this in an RSS reader or in Safari or Internet Explorer. WebRTC is only workable in Chrome, Firefox and Opera at the time that I&#8217;m writing this. Be sure to check the usual &#8220;is it ready?&#8221; sites, for more info:

<http://caniuse.com/#feat=stream>

<http://iswebrtcreadyyet.com/>

## Be More Awesome

From here, there are a lot of things you could do with WebRTC, including real-time chat rooms with audio and video. This gets pretty hairy pretty quickly, though. You&#8217;ll need to get [some crazy STUN server awesomeness](http://www.html5rocks.com/en/tutorials/webrtc/basics/) going in order to get peer to peer negotiations of video and audio formats handled. It&#8217;s a bit of a mess, at the moment, quite honestly. But the future looks amazing. And I&#8217;m diving in head first.