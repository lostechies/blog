---
id: 1155
title: 'Getting Audio File Information With HTML&#8217;s File API And Audio Element'
date: 2013-09-23T08:11:26+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=1155
dsq_thread_id:
  - "1789477711"
categories:
  - audio
  - FileAPI
  - HTML5
  - JavaScript
  - JQuery
  - SignalLeaf
---
I&#8217;ve been cranking out features and capabilities on [**SignalLeaf**](http://signalleaf.com) for just over a month now, and it&#8217;s ever so close to being ready for some public beta testing. I do have one alpha tester, though. [John Sonmez](http://simpleprogrammer.com/) is slowly moving some of his &#8220;[Get Up And Code](http://getupandcode.com/)&#8221; podcast over to SignalLeaf, and is providing feedback to me along the way. One of the features that he asked for, after uploading his first file, was automatic file information gathering from the .mp3 file. It turns out information such as the file&#8217;s content type, size and duration can all be obtained quite easily with modern browsers &#8211; no server side code needed. This was a huge relief for me as I&#8217;m hosting SignalLeaf on Heroku and did not want to stand up a real server somewhere, to store files and process the audio file.

## Basic File Info With The File API

Most of the file information that I need can be gathered with the [HTML File API](http://www.w3.org/TR/FileAPI/). File name, size and content type, for example, can be pulled from this easily. The only thing you need is a <file> input element and a little bit of JavaScript (jQuery in this case).

[gist id=6670383 file=fileInfo.html]

[gist id=6670383 file=fileInfo.js]

When the &#8220;change&#8221; event on the file input fires, you can grab the file information using the .files attribute of the input element. In this case, I&#8217;m using jQuery to capture the &#8220;change&#8221; event, but I&#8217;m grabbing the e.currentTarget directly after that. This gives me the HTML file input element, which has the .files attribute on it. This attribute is an array of files, for scenarios where you are selecting multiple files. In this case, there is only a single file selected so I&#8217;m grabbing the first item in the array.

Once I have the file object, I can get the .name, .size and .type information and populate the HTML in my document, store these in <input> fields, or do whatever else I need to do with them. But while this information is great, it isn&#8217;t enough. I need to know the song duration as well, so that podcasters uploading an mp3 file to SignalLeaf won&#8217;t have to manually enter the song duration.

## Audio Element And Duration

After some tweeting and asking if I there was a JavaScript library to get song duration in the browser, I found out that the HTML <audio> element has this built in to it. Once the <audio> element has loaded the file set in it&#8217;s &#8220;src&#8221; attribute, I can read the .duration of the element which returns the song duration in seconds.

[gist id=6670383 file=audioElement.html]

Once I had that in place, I set up a &#8220;[canplaythrough](https://developer.mozilla.org/en-US/docs/Web/Reference/Events/canplaythrough)&#8221; event listener to tell me when the song had been loaded. This event fires when the song is loaded and can play all the way through. From there, I read the duration and then using momentjs, I convert the duration from seconds in to a more useful &#8220;hh:mm:ss&#8221; format.

[gist id=6670383 file=audio-duration.js]

This worked well for files hosted somewhere on the web, but I needed to load the file from the local machine of the person using SignalLeaf, before it was uploaded anywhere. It turns out there are a couple of options for this.

## First Attempt: FileReader And Data URL

The first thing I tried to do was read the file contents in to memory and create a Data URI with the FileReader API. I found [this article on HTML5 Rocks](http://www.html5rocks.com/en/tutorials/file/dndfiles/), and it gave me all the information I needed for this attempt. So I set up a FileReader and built a Data URL &#8211; a base64 encoded version of a binary file.

[gist id=6670383 file=fileReader.js]

My first test was successful! I was able to get the file information that I wanted. But when I tried to use this on files that were more than a few seconds long, I noticed the browser was locking up. The larger the file, the longer it locked up.

It turns out this is a really bad idea for large audio files. Even with an audio file that is only 6 minutes long, my browser locked up for 3 or 4 seconds. Now imagine a podcast episode that is 30 or 40 minutes long. It would likely lock up the browser for 20 or 30 seconds, or even crash the browser. The problem is that using the Data URL encoded file gives you a base64 encoded version of the file, which is then stuffed in to the <audio> tag&#8217;s &#8220;src&#8221; property. You can imagine a browser not liking the 30 or 40 megs worth of data, and having a hard time encoding it and storing the string in this element.

## Fixing It With Object URLs

Shortly after running in to this problem and complaining about it on twitter, [Chris Wagner suggested I use URL.createObjectURL](https://twitter.com/chris_a_wagner/status/381470768648839168) instead. I&#8217;ve used URL.createObjectURL in the past, but had forgotten about it. The last time I used it was when I was helping to build [the Hilo.js sample app](http://hilojs.codeplex.com/) for Microsoft Patterns & Practices.

The gist of [the URL.createObjectUrl function](https://developer.mozilla.org/en-US/docs/Web/API/URL.createObjectURL), is that it returns a URL that points to a memory location in the browser, for an object. This object URL can be used in most places where a URL is supported. I used this to load large image files into memory for that project, and it makes sense to use it for a large audio file as well.

[gist id=6670383 file=createObjectURL.js]

Now when I select a file, the audio information is parsed and displayed nearly instantly. It doesn&#8217;t seem to matter whether I load a 5 meg or 50 meg audio file, either. The browser is pulling the file in to memory, and the <audio> element is pointed at that memory location.

**One important note:** if you&#8217;re building a single page application and using createObjectURL, you will also need to know about [revokeObjectURL](https://developer.mozilla.org/en-US/docs/Web/API/URL.revokeObjectURL). I spent 2 weeks profiling the Hilo.js app memory usage, to figure out that we were leaking memory everywhere with our use of createObjectURL. Revoking the URL will release the memory, allowing your single page app to clean itself up.

## A Complete Demo

WIth all that said and done, It&#8217;s fairly easy to get the complete set of audio information that I need from a .mp3 file. Here&#8217;s a complete demo of the code, which can be found at [this JSFiddle](http://jsfiddle.net/derickbailey/s4P2v/).



Find a .mp3 file, or other audio file that the <audio> input element supports. Once you have selected it with the file chooser, you will see the file name, type, size and duration loaded in to the HTML &#8211; all thanks to the File API, <audio> element and URL.createObjectURL.

By the way, if you want to know more about SignalLeaf and how it is simplifying podcast audio hosting, be sure to sign up for the mailing list at the bottom of [SignalLeaf.com](http://signalleaf.com).