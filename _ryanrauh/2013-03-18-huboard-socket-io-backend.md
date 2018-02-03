---
wordpress_id: 221
title: 'Huboard &#8211; socket.io backend'
date: 2013-03-18T16:27:29+00:00
author: Ryan Rauh
layout: post
wordpress_guid: http://lostechies.com/ryanrauh/?p=221
dsq_thread_id:
  - "1147050683"
categories:
  - Uncategorized
tags:
  - huboard
---
# [huboard.com](http://huboard.com)!

Your favorite [open source](https://github.com/rauhryan/huboard) kanban board built on top of the [GitHub](https://github.com) [api](http://developer.github.com/) has gotten a little bit more awesome. I&#8217;ve decided to release the socket.io backend that is keeping [huboard.com](http://huboard.com) all up to date and super fancy.

# Why nodejs (express + socket.io)?

## 1. Simple

Nodejs (express + socket.io) was by far the easiest thing for me to get running on [heroku](https://devcenter.heroku.com/articles/using-socket-io-with-node-js-on-heroku). The [original version](http://lostechies.com/ryanrauh/2012/08/23/huboard-goes-realtime/) I published back in August was only about 26 lines of javascript.

## 2. Reliable

I&#8217;m absolutely amazed, I pushed that code up to heroku back in August and haven&#8217;t touched it. It ran for about 6 months and I never even checked on it. As far as I can tell it never even crashed.

## 3. Documentation

There is a ton of great tutorials and blog posts just a google search away on getting socket.io up and running on heroku.

  * [Heroku &#8211; Dev Center](https://devcenter.heroku.com/articles/using-socket-io-with-node-js-on-heroku)
  * [Socket.io site](http://socket.io/#how-to-use)

## 4. Cheap (free as in beer)

Plain vanilla install of socket.io and express configured to use [xhr-polling](http://en.wikipedia.org/wiki/Comet_(programming)) has been running problem free on heroku with one free dyno for 6 months. I&#8217;m not exactly sure how far that will scale using the MemoryStore (eventually I&#8217;ll run out of RAM) but huboard is sitting at nearly 4000 users and haven&#8217;t had any problems _yet_

## Other options

I did explore other options

  * .NET &#8211; server sent events &#8211; (fubumvc or signalr)
    
      * [FubuMVC.ServerSentEvents](https://github.com/DarthFubuMVC/FubuMVC.ServerSentEvents) 
          * Not supported by heroku (see #1 && #4)
          * SSE only &#8211; no fallback support 
          * Very little documentation
      * [SignalR] 
          * Not supported by heroku
          * Not as stable (at the time)

  * Ruby &#8211; EventMachine
    
      * I originally wanted to use something simple on top of ruby. I tried several different approaches and ultimately I just couldn&#8217;t figure out how to host a HTTP POST endpoint && the socket connections inside the same app.

# Why did it take you so long to release it?

Well the TL;DR; is that it wasn&#8217;t secure. It was largely experimental. Back when I published the [RealTime™](http://lostechies.com/ryanrauh/2012/08/23/huboard-goes-realtime/) support the socket.io server was only about 26 lines of [nodejs](http://nodejs.org). It had no security because I didn&#8217;t know how to set it up. So I secure it the best I could (with a simple correlation string) and called it a day. The code wasn&#8217;t published so hackers at least had a _harder_ time connecting to the socket than if the code was in the open. Security by obscurity (I know shame on me, I&#8217;m sorry).

# How are you going to make it secure?

Step one is open sourcing it, people who are using huboard and know more than I do will hopefully care enough to help me make it as secure as possible.

  * Things I&#8217;m doing already. 

All my users trust me with their OAuth token and I take that responsibility seriously. I try my best to make sure your authorization key doesn&#8217;t get into the wrong hands. Huboard **never** exposes your authorization key unencrypted.

The socket server now performs a handshake when making a connection. Your **encrypted** OAuth token is passed into socket.io via query string, which turns around and passes the **encrypted** key to a huboard api endpoint that **decrypts** your token and asks the GitHub api if its valid.

&#42;**| Disclaimer &#42;**| I&#8217;m not a security expert, I&#8217;m not happy that I&#8217;m passing the token back to huboard for verification. It doesn&#8217;t feel _right_. I tried for days to decrypt the token using node in order to validate the token inside the handshake code but I just ran into dead ends. I think it has something to do with the encoding of ruby vs node but I had very similar encryption code on both platforms and could figure out how to get node to decrypt a string from ruby or visa versa. [Please help](https://github.com/rauhryan/huboard.socket.io/issues/1)!