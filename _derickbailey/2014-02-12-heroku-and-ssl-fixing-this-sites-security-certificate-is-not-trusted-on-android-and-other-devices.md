---
wordpress_id: 1255
title: 'Heroku And SSL: Fixing &#8220;This site&#8217;s security certificate is not trusted!&#8221; on Android and other devices'
date: 2014-02-12T10:09:48+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1255
dsq_thread_id:
  - "2256919682"
categories:
  - DNSimple
  - Heroku
  - SignalLeaf
  - SSL
---
I recently received a report of [SignalLeaf](http://signalleaf.com) being &#8220;blacklisted&#8221; by Chrome. After a bit of panic, and asking twitter to see if the site was having issues, I got confirmation that Android phones and other devices / browsers were getting a security warning about the SSL certificate I had installed on SignalLeaf.

<img src="http://lostechies.com/derickbailey/files/2014/02/SSL-Cert-Issue-3.png" alt="SSL Cert Issue 3" width="337" height="600" border="0" /> <img src="http://lostechies.com/derickbailey/files/2014/02/SSL-Cert-Issue-1.png" alt="SSL Cert Issue 1" width="337" height="600" border="0" />

This sent me in to a bit more of a panic, as I had no clue what was wrong or how to fix it. Time to start googling error messages and random combinations of words related to the services I&#8217;m using&#8230;

## DNSimple, Heroku, RapidSSL And Certificate Chains

I use [DNSimple](http://dnsimple.com) for my domain name hosting (if you&#8217;re not using DNSimple, I feel sorry for you, having to put up with other services). I also use [Heroku](http://heroku.com) for hosting SignalLeaf. This is an epic combination of awesome when it comes to buying and setting up an SSL certificate. So awesome, in fact, that [Heroku uses DNSimple as the canonical example](https://devcenter.heroku.com/articles/ssl-certificate-dnsimple) of how to set up SSL in their help pages.

When you buy an SSL certificate through DNSimple, it is issued through a service called [RapidSSL](http://www.rapidssl.com/). This is a legit service, and the certs that you get are as good as any other cert. The &#8220;issue&#8221; that I ran in to, is that RapidSSL is not yet trusted on every browser and device around the world. They have not been around forever, and are not as big as some other certificate authorities, so they don&#8217;t have trusted status everywhere (yet). But like I said, they are legit and they are certified by GeoTrust to prove their legit status.

Because RapidSSL is not a big name certificate authority, and because they are not yet trusted by every browser and device, yet, you need to install a set of intermediate certificates on your server, when you set up a RapidSSL certificate. This certificate &#8220;chain&#8221; provides the authority that older browsers and devices need, in order to completely trust RapidSSL certificates. 

## Setting Up A Certificate Chain On Heroku

The Heroku help files show the basics of how to set up a chain of certificates, by creating a &#8220;.pem&#8221; file &#8211; this is a group of certificates that form a certificate chain, concatenated in to a single file. Heroku also recommends grabbing [a specific PEM bundle for RapidSSL](https://devcenter.heroku.com/articles/ssl-certificate-dnsimple#rapidssl-certificate-bundle), but it doesn&#8217;t really say what to do with it.

After some additional digging and some help from the DNSimple people (have I mentioned how awesome they are?), I figured out that you need to install the PEM file with your certificate. Assuming you have a &#8220;server.crt&#8221; for your actual certificate, a &#8220;bundle.pem&#8221; file for the RapidSSL bundle, and a &#8220;server.key&#8221; for your server&#8217;s secret key, the command you want to run is this:

`heroku certs:add server.crt bundle.pem server.key --app my-app-name`

This will install the actual SSL certificate along with the RapidSSL bundle.pem file (from the link above), and verify everything with your server&#8217;s SSL key. (The `--app my-app-name` option is only needed if you are running this command from a folder that is not already tied to a Heroku app instance.)

## Updating A Certificate Chain On Heroku

If you&#8217;ve already installed your certificate but you need to update the chain or the certificate itself, run certs:update instead of add.

<span style="font-family: monospace">heroku certs:update server.crt bundle.pem server.key &#8211;app my-app-name</span>

This will update your app with the right certs and chain. Heroku will warn you that this is potentially destructive, so be sure you have the right certs lined up. Confirm the update and you should see an instant trust on your site certificates.

## Fixing The &#8220;Key could not be read since it&#8217;s protected by a passphrase&#8221; Issue

Along the way to fixing my SSL certificate, I ran in to this error message. I found a StackOverflow question that said this happens when you have an older version of the Heroku Toolbelt installed. It turns out I had an old one on my system Ruby version. I had installed the original Ruby Gems version of the Toolbelt a few years ago. For various reasons, my default Ruby version changed a while back, but I reset it to the system ruby recently. Doing this caused the old Heroku Toolbelt to be the one in use on my system. To fix that problem, I had to uninstall the old toolbelt:

`gem uninstall heroku-toolbelt`

and then install the latest version of the toolbelt (through Homebrew in my case)

`brew install heroku`

Once I had the right version of the Heroku Toolbelt installed, the error went way and I was able to install the certificate chain.

## This Is Still Easier Than It Used To Be

For as many problems as I had getting this fixed, this is still 1,000 times easier than it used to be. I remember the days when buying an SSL certificate cost several hundred dollars and required a verification process on your business in the United States. It took weeks, certificates were mailed to you (not email&#8230; actual mail), and installation / configuration of SSL often took hours or days. If you got something wrong in the initial configuration, you would have to start over. 

These days, with DNSimple and Heroku, buying and setting up an SSL certificate took me less than 1 hour total. It was only because of a mistake that I made and not understanding the need for intermediate certificates that I had these problems. Even with these problems and the few hours of research and troubleshooting, I am more than happy to have paid a small fee for the SSL certificate, and the monthly fee to host on Heroku with SSL. 