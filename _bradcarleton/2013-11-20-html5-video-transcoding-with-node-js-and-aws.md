---
id: 43
title: 'HTML5 Video: Transcoding with Node.js and AWS'
date: 2013-11-20T23:00:58+00:00
author: Brad Carleton
layout: post
guid: http://lostechies.com/bradcarleton/?p=43
dsq_thread_id:
  - "1983946648"
categories:
  - AWS
  - HTML5
  - node.js
  - Video
---
<p dir="ltr">
  I recently worked on a video project, and I had a chance to use the relatively new AWS Elastic Transcoder with Node.js.  Along the way, I learned a lot about video on the web, and I thought I&#8217;d share some of my experiences.
</p>

<h1 dir="ltr">
  Current State of Video on the Web
</h1>

<p dir="ltr">
  The current state of video on the web is a bit confusing, so here goes my best explanation of it.
</p>

<p dir="ltr">
  Before HTML5, the most prominent technology used for video on the Web was Flash. However, because Flash is a proprietary technology, the Web community decided that an open standard was needed.  Thus the <code>&lt;video&gt;</code> tag was born.
</p>

<p dir="ltr">
  The good news is that most browser support the <code>&lt;video&gt;</code> tag.  Unfortunately, that is where a lot of the cross compatibility stops.
</p>

<p dir="ltr">
  Every video file has a specific video container format that describes how the images, sound, subtitles etc. are laid out in the video file.  There are currently three popular video container formats on the Web:
</p>

  * mp4
  * webm
  * ogg

Because video files are so enormous they are almost always compressed.  The compression algorithm used is called a video codec.  These are the most popular video codecs being used on the Web:

  * vp8
  * h.264
  * theora

<p dir="ltr">
  I found this nifty image from <a href="http://www.pitivi.org/manual/codecscontainers.html" target="_blank">here</a>, that helps show the video file layout:
</p>

<p dir="ltr">
  <a href="http://clayvessel.org/clayvessel/wp-content/uploads/2013/11/codecscontainers.png"><img class="alignnone size-full wp-image-53" title="Video Codecs Containers" src="http://clayvessel.org/clayvessel/wp-content/uploads/2013/11/codecscontainers.png" alt="" width="400" height="440" /></a>
</p>

<p dir="ltr">
  The problem is that there is no standard video container/codec for the web due to disputes over licensing issues, and therefore you have to transcode videos into multiple formats.  Fortunately, it seems that you can get pretty widespread browser support with just two codecs/container combinations, <strong><code>mp4/h.264</code></strong> and <strong><code>webm/vp8</code></strong>.
</p>

<h1 dir="ltr">
  Transcoding with AWS and Node.js
</h1>

In May of this year, Amazon released an official <a title="AWS SDK for Node.js" href="http://docs.aws.amazon.com/AWSJavaScriptSDK/guide/" target="_blank">SDK for Node.js</a>. It&#8217;s a superbly written library that has code for almost all of the AWS services.

Also earlier this year, Amazon released <a title="AWS Elastic Transcoder" href="http://aws.amazon.com/elastictranscoder/" target="_blank">Elastic Transcoder</a>.  Elastic Transcoder is a pretty slick service that allows you to transcode videos from just about any fomat into one of the standard web video formats above.

The Elastic Transcoder retrieves and processes videos to and from Amazon S3.  The architecture looks like this:

[<img class="alignnone size-full wp-image-54" title="AWS S3 Elastic Transcoder" src="http://clayvessel.org/clayvessel/wp-content/uploads/2013/11/aws-arch.png" alt="" width="580" height="327" />](http://clayvessel.org/clayvessel/wp-content/uploads/2013/11/aws-arch.png)

Node.js is a great platform to build a standalone video processing server that manages resources between S3 and Elastic Transcoder.  Node&#8217;s streaming capabilities and non-blocking nature make it a perfect fit for chunking video files to S3 and managing video transcoding.

Here&#8217;s a snippet of Node.js code that shows how easy it can be to create a transcoding job with Elastic Transcoder:

<pre name="code" class="javascript">elastictranscoder.createJob({ 
  PipelineId: pipelineId, // specifies output/input buckets in S3 
  OutputKeyPrefix: '/videos' 
  Input: { 
    Key: 'my-new-video', 
    FrameRate: 'auto', 
    Resolution: 'auto', 
    AspectRatio: 'auto', 
    Interlaced: 'auto', 
    Container: 'auto' }, 
  Output: { 
    Key: 'my-transcoded-video.mp4', 
    ThumbnailPattern: 'thumbs-{count}', 
    PresetId: presetId, // specifies the output video format
    Rotate: 'auto' } 
  }, 
}, function(error, data) { 
    // handle callback 
});</pre>

# Video.js: The Open Source HTML5 Video Player

<p dir="ltr">
  <span style="font-size: 16px;">Unfortunately, the HTML5 video tag only gets you about half the way there.  There are a lot of missing features between different browsers.  Luckily the guys at <a title="Bright Cove" href="http://www.brightcove.com/en/" target="_blank">Brightcove</a> wrote <a href="http://www.videojs.com/" target="_blank">video.js</a>.  Which is an awesome library that helps provide cross browser HTML5 video support with fallback support to Flash.</span>
</p>

<p dir="ltr">
  Here is a snippet that shows how things are tied together on the frontend with video.js:
</p>

<pre name="code" class="html">&lt;link href="//vjs.zencdn.net/4.2/video-js.css" rel="stylesheet"&gt;
&lt;script src="//vjs.zencdn.net/4.2/video.js"&gt;&lt;/script&gt;

&lt;video id="example_video" class="video-js vjs-default-skin"
  controls preload="auto" width="640" height="264"
  data-setup='{"example_option":true}'&gt;
 &lt;source src="//video.techpines.com/cats.mp4" type='video/mp4' /&gt;
 &lt;source src="//video.techpines.com/cats.webm" type='video/webm' /&gt;
&lt;/video&gt;</pre>

<p class="html">
  I hope that helps with anyone looking to understand video on the Web.
</p>