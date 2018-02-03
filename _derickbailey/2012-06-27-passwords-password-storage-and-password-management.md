---
wordpress_id: 950
title: Passwords, Password Storage And Password Management
date: 2012-06-27T11:50:27+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=950
dsq_thread_id:
  - "742542505"
categories:
  - Security
  - Tools and Vendors
---
There&#8217;s no shortage of news about companies that are being hacked and having usernames and passwords stolen these days. The latest of which is [Tuts+ Premium](http://notes.envato.com/general/tuts-premium-security/). Now I&#8217;m not one for blaming companies that get hacked. That happens. We do our best, and it still happens. You can&#8217;t do anything but do your best.

## Plain Text Passwords

Hackers happen. Do your best and it still happens. You can&#8217;t be blamed for hackers. But I will squarely blame you and any company that is dumb enough to store passwords in plain text.

I&#8217;ll take that three steps further, actually, and flat out say.

**If you store passwords in plain text or advocate storing them in plain text for any reason, you should be fired, fined HEAVILY, have legal action taken against you by your users, and be given a court order that bans you from building applications and web sites that require authentication. You fail &#8220;security 101&#8221; so hard that it cannot in any way ever be forgiven.**

There is no excuse for this. Period. End of story, no discussion. I don&#8217;t care if it was a third party plugin. It&#8217;s still your fault for not properly evaluating the third party plugin, and not understanding that it stored passwords in plain text. The third party should should also have the above actions taken against them, but that doesn&#8217;t let you off the hook.

## Tuts+ Almost Responded Correctly

After the breach at Tuts+ was discovered, they responded fairly well.

> The breach was discovered earlier today, the exploits have been tracked down and removed, and the whole service shut down to ensure the compromise is isolated.

But the problem with this is that they didn&#8217;t respond this way until after the breach happened. They knew, by their own admission, that the plugin was storing plain text passwords before this breach happened.

The correct response to that knowledge is not &#8220;a plan currently in progress to upgrade away from the current plugin.&#8221; The correct response, on finding out that your site is storing passwords in plain text, is to immediately shut down the site. Take all servers offline and fix the plain text password problem. 

The embarrassment and revenue loss of doing this proactively will save you the lost customers, public outrage, and 1000x embarrassment from ending up in the same situation as Tuts+. Your users may even thank you for being proactive and not ending up in this situation, if you correctly word the apology letter and press release that you send to your users, for the self-imposed downtime.

## Tuts+ Is Just A Poser-Child

I&#8217;m picking on Tuts+ because they are the example today. It has nothing to do with their specific scenario, or them as a company. I like them as people, as a company, and for what they do on the web with education and tutorials in the technology world.  It&#8217;s horribly unfortunate that they didn&#8217;t take more proactive action, and ended up in this situation. It could have and should have been prevented.

But Tuts+ isn&#8217;t the first (anyone remember Sony and LinkedIn?) and won&#8217;t be the last that we hear of, with problems like this. And because of that, it falls on us as people who use websites and services that require authentication, to protect ourselves.

## Password Management For Users

The corollary to the harsh statements about being fired, fined, etc above is that as people who sign up for various services on the internet, we have a responsibility to guard against the companies that don&#8217;t value our security. But we also need to guard against the eventual hack on companies that do value our security &#8211; the companies that do store our passwords encrypted, but are hacked still hacked.

I&#8217;ll make an equally as strong statement as I did above, regarding passwords: 

**You should not know your password for any website or application that you log in to, with the one and only exception of the password management app or service that you use.**

No excuses. 

(Note that I am excluding hardware / operating systems. You can&#8217;t use a password management app to get your Windows password, when you have to log in to Windows to get to your password management app)

With the number of sites and databases that are being compromised on a regular basis, we hold the key to our own security in our own hands … or… minds… or written on sheets of paper: passwords. If we don&#8217;t protect ourselves against the hackers of the world and against the stupidity of companies that store passwords in a way that makes them easy for hackers to get, then we&#8217;re just as guilty as the companies being hacked.

The problem is that most people use the same password (or maybe 2 or 3 passwords) for every site, service and app. When a hacker gets your password, then, they can log in to any system that you have signed up with because they know the one password that you are using. By using a different password for every website and service, you don&#8217;t have to worry about this. If (WHEN!) a hacker gets your password for a specific site, they will not be able to do anything other than screw up that one site for you. They won&#8217;t be able to log in to any other service because they won&#8217;t know your password for the other service.

But it&#8217;s not possible to remember every password for every site, unless you have a photographic memory. Instead, you should be using a password management system, app or service. These apps and services will securely store your usernames and passwords (and often times other info and items that need digital security) in a way that lets you have a different password for every site, without having to remember the password for each site. You only need to remember the one password for the app / service, and then use that app / service to log in to your other sites.

There are dozens of password management systems around. The three that I&#8217;ve used and would recommend looking at are:

  * [1Password](https://agilebits.com/onepassword) (my current choice, as it has apps for osx, windows, ios and android)
  * [LastPass](https://lastpass.com/)
  * [KeePass](http://keepass.info/)

There are dozens of others. Just do some google search for password managers. Also, please list your favorite in the comments here on this post.

## Education Is Cheaper Than Fraud / Identity Theft Cleanup

The current billion dollar industry in the insurance and banking world is fraud and identity theft clean up. You see services advertised all the time for this, and for good reason. Identity theft and fraud are rampant and the digital age makes them easier. You owe it to yourself to protect yourself at least a small amount. Invest the time and $50 (if that) to at least create one level of protection against hackers, fraud and identity theft by using a password management system. 

While your at it, share this information with your friends and family that are slightly less tech-savvy. Educate them. Get them to use a password management system that you are comfortable with so that you can support them in their needs. And yes, I am telling you to volunteer your time to do this because putting up with the pain-in-the-* tech questions from your parents for a few hours ever few weeks is cheaper, easier and more pleasant than hiring lawyers, insurance companies, and other fraud / identity theft cleaners.