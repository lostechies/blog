---
wordpress_id: 1148
title: 'SignalLeaf: Hacking A Podcast Audio Service Together'
date: 2013-08-20T08:07:20+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1148
enclosure:
  - |
    http://signalleaf.com/embed/my-token/my-file.mp3
    21
    audio/mpeg
    
dsq_thread_id:
  - "1620751867"
categories:
  - Hacking
  - Service
  - SignalLeaf
---
Yesterday (August 19th) was [_whyDay](http://whyday.org) &#8211; a day for hacking on new things, learning, and generally doing awesome things that you normally wouldn&#8217;t do for whatever reason. I&#8217;ve known about _whyDay for a few years now, but had never done anything on this day in the past. Well, yesterday found me with an idea and a desire to build something new. So I couldn&#8217;t pass up the chance.

## Podcast Audio File Hosting

A week or two ago, a friend was asking about hosting podcast audio files. He had been using WordPress for the website, but it was more than he needed. He was thinking about doing something like Jekyll for the site, and cloud storage of some sort for the file. That got me wondering: what would it take to build a service that lets you upload your audio files to some cloud storage, and then provide an embeddable player for your site.

So I started hacking&#8230; and after a few hours of work, I had an Amazon S3 account with a sample file (audio track from one of my screencasts) in it, and a very basic embedded player using an \`iframe\`. 

**The result: [SignalLeaf.com](http://signalleaf.com) **&#8211; an idea for hosting embedded podcast audio for your website. 

[<img src="http://lostechies.com/derickbailey/files/2013/08/signalleaf_logo.png" alt="Signalleaf logo" width="380" height="125" border="0" />](http://signalleaf.com)

The basic idea is this: You have the subject matter expertise, the talent, the network of people who will listen, and the perfect guest list for your podcast. You even have the chops to build the ultimate website for your idea. But what about hosting and streaming those audio files that you&#8217;ve meticulously edited?

Let me handle that for you. All you need to do is upload your audio file to SignalLeaf, and then add an \`iframe\` to your web page:

<span class="webkit-html-tag" style="font-family: monospace"><iframe <br /><span class="webkit-html-attribute-name"> src</span>=&#8221;http://signalleaf.com/embed/my-token/my-file.mp3&#8243; <br /><span class="webkit-html-attribute-name"> width</span>=&#8221;<span class="webkit-html-attribute-value">400</span>&#8221; <span class="webkit-html-attribute-name">height</span>=&#8221;<span class="webkit-html-attribute-value">50</span>&#8221; <span class="webkit-html-attribute-name">frameborder</span>=&#8221;<span class="webkit-html-attribute-value"></span>&#8220;><br /></span><span class="webkit-html-tag" style="font-family: monospace"></iframe></span>

And your web page gets something like this, embedded in it. 

<img src="http://lostechies.com/derickbailey/files/2013/08/screenshot.png" alt="Screenshot" width="423" height="75" border="0" /> 

 A complete audio player, with your podcast file streaming from the cloud.

## Good Idea? Dumb Idea? I Need Feedback

I don&#8217;t know if this is a good idea or not. I haven&#8217;t done any research on the need for a service like this. I know there are a lot of services that specialize in hosting podcasts, already. I&#8217;ve seen those sites and have used one or two in the past. I didn&#8217;t build this because I thought there was a gap in what was out there, honestly. I just wanted to hack something together to see if I could. It turns out I could get it done pretty quickly. So I set up a landing page, bought a domain name, hacked together a quick logo, and put the landing page online with a way to [**sign up for a mailing list**](http://signalleaf.com).

I&#8217;m looking for feedback at this point. If you&#8217;re interested in what this service may offer, sign up for the mailing list on the site. Follow the twitter account [**@signalleaf**](http://twitter.com/signalleaf), and let me know that you want to see this service go live!