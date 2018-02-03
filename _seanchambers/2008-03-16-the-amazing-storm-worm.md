---
wordpress_id: 3171
title: The amazing Storm botnet
date: 2008-03-16T13:45:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2008/03/16/the-amazing-storm-worm.aspx
dsq_thread_id:
  - "268123784"
categories:
  - virii
---
I originally heard about the <A class="" href="http://en.wikipedia.org/wiki/Storm_botnet" target="_blank">storm worm/botnet</A> about 6 months ago but wrote it off as another b.s. botnet used by spammers for mediocre spreading of email. Recently I saw some newer articles and started looking into it again. This is when I realized how diabolical, beautiful and well crafted of a worm this beast actually is.


  


Originally discovered in early 2007, the storm worm was thought to just be another worm that spread randomly infecting machines via e-mail. Upon further investigation, experts realized that this worm was something much more dangerous than a basic worm infecting machines. The storm worm uses an exploit in Windows XP to propogate to machines. No surprise there.


  


The storm worm is actually multiple different programs rolled into one. It is actually a massive well crafted botnet consisting of anywhere from 160,000 to 50 million machines total. Recently, security experts have developed spiders to crawl the botnet and place the estimate more towards 160,000 computers rather than several million. Along with worm propogation the botnet also performs DDoS attacks, spamming, command and control servers, an e-mail address stealer along with many other duties.


  


An interesting attribute that the botnet possesses is resistance to probing and inspection, almost like a defensive barrier that reacts to any outside intervention. Upon scanning and/or crawling the botnet, experts found that the botnet instantly recognizes that someone is trying to inspect it and retaliates with a DDoS attack. Whether this is an automated process or is being controlled by a user is unknown, although experts assume that it is the former. A very innovative feature indeed.


  


With enough processing power to rival most of the worlds supercomputers it is a scary idea that such a resource is being controlled by criminal intent. When the botnet does commit a DDoS attack, it contains enough firepower to take an entire country offline. To quote wikipedia, &#8220;The webmaster of Artists Against 419 said that the website&#8217;s server succumbed after the attack increased to over 400 gigabits per hour of data, the equivalent of over 170,000 ADSL-connected machines&#8221;. This is an amazing amount of bandwidth and a scary prospect indeed.


  


The botnet operates on a modified version of eDonkey&#8217;s peer-to-peer networking which makes it almost impossible to take the botnet offline. Just like file-sharing p2p networks, no matter where you attempt to disassemble the network there are always other machines to take the place of patched ones.


  


Only specific portions of the botnet are dedicated to certain tasks. A small portion provides DDoS attacks, another portion is strictly for spreading the worm to other machines while an even smaller portion is used as command centers to spread commands to the dormant machines.


  


So you ask why can&#8217;t you just find out where the commands and updated virus packages are being sent from? Good question. The controllers of the botnet are using a constantly changing DNS technique called &#8220;<A class="" href="http://en.wikipedia.org/wiki/Fast_flux" target="_blank">fast-flux</A>&#8220;, this allows the host machines to be almost impossible to find. Couple that with the fact that almost all communication within the botnet is encrypted and one can see the difficultly in analyzing such a beast.


  


There are speculations that the size of the botnet has recently decreased but it still remains a very real threat to the internet as a whole. Especially being in the hands of criminals. I am considering setting up a dummy box to purposely get infected to &#8220;play&#8221; with the worm so to speak. Although, this could very well mean the death of my cable connection =)