---
wordpress_id: 1055
title: Some Notes On Screencasting
date: 2013-02-19T16:55:24+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1055
dsq_thread_id:
  - "1093539701"
categories:
  - OSX
  - Quality
  - Screencast
  - Tools and Vendors
---
I put together some notes for my team, on building some screencasts. I thought they came out fairly well, so I wanted to share with the rest of the world.  Note that these are my opinions based on the work that I&#8217;ve done with [WatchMeCode](http://www.watchmecode.net/), [PragProg](http://pragprog.com/screencasts/v-dback/hands-on-backbone-js), [Tekpub](http://tekpub.com/) and now with [Kendo UI](http://www.kendoui.com/). I know there are 1,000 ways to do any / all of this, and I would love to hear your thoughts on what you do and how you get things done as well. I&#8217;m always looking for ways to improve what I do.

## Getting Started

Read Rob Conery&#8217;s series on screencasting. He was kind enough to blog everything that I wouldn&#8217;t have been able to say as well as he does. 🙂

<http://wekeroad.com/2012/08/22/screencasting-like-a-pro-beginning-middle-end>  
<http://wekeroad.com/2012/08/24/screencasting-like-a-pro-the-script>  
<http://wekeroad.com/2012/08/31/screencasting-like-a-pro-the-demos>

Also read Scott Burtton&#8217;s article on audio compression. Note that this is not file compression… this is audio compression, as in sound engineering.

<https://gist.github.com/scottburton11/3222152>

**Equipment / software:**

You need a minimum amount of hardware and software for building screencasts. This list should be fairly obvious:

  * A computer (duh?)
  * A high quality microphone
  * Screen/video recording / editing software
  * Audio recording / editing software

<div>
  <p>
    <strong>Microphone:</strong>
  </p>
  
  <p>
    Don&#8217;t use your laptop&#8217;s built in microphone. Don&#8217;t use a skype/g+ hangout/IM quality headset from BestBuy. These microphones are terrible. Buy something of high quality. There are high quality headsets that can be purchased, but it would be best to buy a microphone that is built for recording / broadcasting human voice.
  </p>
  
  <p>
    I recommend one of these two:
  </p>
  
  <ul>
    <li>
      <a href="http://www.amazon.com/gp/product/B000JM46FY/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B000JM46FY&linkCode=as2&tag=derickbailey-20">Rode Podcaster</a> (what I have)
    </li>
    <li>
      <a href="http://www.amazon.com/gp/product/B002VA464S/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B002VA464S&linkCode=as2&tag=derickbailey-20">Blue Yeti</a>
    </li>
  </ul>
  
  <p>
    You can get others, of course. These are the industry standards for podcasting / screencasting, though. They are broadcast quality, USB powered Microphones. The Blue Yeti is the cheaper of the two, but the Rode Podcaster is the more professional one.
  </p>
</div>

## Notes On Recording

Things to keep in mind when recording the audio and video

**For recording the video:**

  * Close all programs that are not part of the recording / coding / screencasting process &#8211; especially email and IM apps
  * Record the entire desktop, not just part of it
  * Record at your normal screen resolution. Don&#8217;t change the monitor resolution or anything else, to record.
  * Re-size all windows that you are going to record, down to 1280&#215;720 (720p) resolution
  * Do not record computer audio
  * Do not record any audio while recording your screen (the exception to this is if you need to record yourself talking to yourself, so that you can take notes for the real audio recording)

<div>
  <p>
    <strong>Movement In Video:</strong>
  </p>
  
  <p>
    Limit the amount of on-screen movement while recording. Don&#8217;t jump back and forth between windows and tabs a lot. Don&#8217;t scroll excessively.
  </p>
  
  <p>
    You can, of course, move things around as much as you need when doing your rough recordings. But the end result should be edited so that these extra animations, cmd-tab (alt-tab) screen-switching transitions, and other movement are gone from the final video.
  </p>
  
  <p>
    Move your mouse as little as possible. Move it slowly and deliberately so that a person watching can easily track it with their eyes.
  </p>
  
  <p>
    Keep this kind of motion limited so the user can focus on the content, not the movement of the screen.
  </p>
  
  <p>
    <strong>Post-Recording Slides And Animation:</strong>
  </p>
  
  <p>
    Any time your audio script comes to a point where you are pausing the video to discuss or describe something, you will want to have a slide, an arrow, or some other highlight to point out what you are talking about.
  </p>
  
  <p>
    Slides are good for tangential subject matters &#8211; things that people should be aware of, but are not directly covered by the video content. Plan for a few slides, but keep them limited.
  </p>
  
  <p>
    Highlights, arrows, word overlays on the video, etc, are good for pointing out the content that you are describing. Plan for a few highlights to illustrate what you&#8217;re talking about, but keep them limited to what&#8217;s important.
  </p>
  
  <p>
    <strong>Rendering Video:</strong>
  </p>
  
  <p>
    The final video output should be 1280&#215;720 (720p HD) resolution. I prefer to export MP4 (mpeg layer 4) files as .m4v. This works pretty much everywhere &#8211; iPad, iPhone (though I wouldn&#8217;t recommend that), Windows, Mac, etc.
  </p>
</div>

**For recording the audio:**

  * Turn off your phone. Srsly &#8211; I&#8217;ve seen screencasts where people say &#8220;hold on…&#8221; and check txt messages. WAT
  * Wear a headset if you need to hear the computer&#8217;s audio while recording the audio
  * Record your voice-over separately from the screen recording
  * Edit the audio to remove clicks, pops, breathing and other noises
  * Use a small to moderate amount of audio compression, to keep the audio levels closer to even (see the above link to Scott Burton&#8217;s article on audio compression)
  * Export the audio at the highest possible quality, using a lossless audio format. Do not export as MP3 or any other file format that would reduce the quality of audio

When recording audio, be aware of background noise. A broadcast quality mic will pick up everything. If your office has wood / tile floors, like mine, you probably don&#8217;t want to record in that room because of echo. Find a room with no bare walls, with as few hard surfaces as possible, and with as much &#8220;soft&#8221; stuff to absorb sound, as possible.

I have a small set up in my closet for recording audio, with a mic stand and a portable sound booth. I don&#8217;t expect everyone to have this kind of set up, but using a closet full of clothing will reduce the background noise and create a &#8220;dead room&#8221; effect, where your voice is more natural.

## On a Mac

I work on a Mac these days, so I have more specific info about this than I do windows.

  * Do not record video on a Retina display
  * Use [Screenflow](http://www.telestream.net/screenflow/overview.htm) to record and edit video
  * Use [GarageBand](http://www.apple.com/ilife/garageband/) to record and edit audio
  * Splice the audio together with the video, inside of ScreenFlow, after editing the audio separately
  * To resize your apps to the appropriate size, use a tool like [SizeUp](http://www.irradiatedsoftware.com/sizeup/) or applescript [like I talked about in another post](https://lostechies.com/derickbailey/2012/09/08/screencasting-tip-resize-your-app-to-720p-1280x720-in-osx/).

<div>
  You can also use Screeny if you need to save money. If you&#8217;re dirt-cheap/poor (how did you get a mac?) then you can use Quicktime and iMovie, but this is awful and painful.
</div>

<div>
   
</div>

<div>
  For advanced animations and awesome stuff, use <a href="http://www.apple.com/finalcutpro/motion/">Motion 5</a>. 
</div>

**Screenflow settings:**

  * Go to &#8220;Preferences&#8221;, &#8220;Advanced&#8221;, and set &#8220;Screen Recording Preferences&#8221; from &#8220;Adaptive&#8221; to &#8220;Lossless&#8221;
  * Go to &#8220;Preferences&#8221;, &#8220;Advanced&#8221;, and set &#8220;Video Magnification&#8221; to &#8220;Smooth&#8221;
  * Go to &#8220;Preferences&#8221;, &#8220;Timeline&#8221;, and set the default transition to &#8220;Cross Dissolve&#8221;

## On Windows

Use Camtasia … is there anything else? Not sure about anything else here&#8230; suggestions? What is the Garage Band equivalent on Windows?

## The Video And Audio Script

Like most things in software development, iteration is the key to success. Learn to iterate your script for both audio and video. This usually means writing one of them first, while thinking about the other. Then writing the other while editing the first to adjust for the things you forgot about.

Organize your scripts as if you were writing blog posts &#8211; short sections with a beginning, middle, and end in each section. Be sure the entire episode also has a beginning, middle and end, as well. 

When writing the audio script details, write as if you are speaking &#8211; because you are. Don&#8217;t write for written publications. Write for a an audience that is listening to you do a presentation at a user group. Write in your speaking voice.

You need to be able to record the audio and video in short bursts &#8211; 1 to 2 minutes, maybe 3 to 5 minutes at most. This is critical because you will make mistakes, and you will have to re-record parts and you want to minimize the amount of audio and video that you have to re-record. Building your audio and video script in small, distinct segments will help facilitate this.