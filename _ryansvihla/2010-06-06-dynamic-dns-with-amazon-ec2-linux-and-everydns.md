---
wordpress_id: 41
title: Dynamic DNS with Amazon EC2 Linux and EveryDNS
date: 2010-06-06T18:02:32+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2010/06/06/dynamic-dns-with-amazon-ec2-linux-and-everydns.aspx
dsq_thread_id:
  - "1071427002"
categories:
  - EC2
---
So I finally sat down and did the math and found out Amazon EC2 was quite a bit cheaper than what I’d been paying for hosting as long as I was willing to prepay for at least a year.&#160; However, with EC2 you are getting a dynamic ip’s so what to do? Well I’ve been using EveryDNS for years for my dns hosting and despite it’s recent acquisition by Dyn, Inc it’s still works the same. The scripts that are described below can be downloaded <a href="http://unstabletransit.com/blogfiles/dyndns.tgz" target="_blank">here</a>, what follows is a brief walkthrough.

  1. Download EveryDns update script from <http://www.everydns.com/dynamic.php>&#160; and place it in something like /usr/local/bin. 
  2. Create a convenience script in /usr/local/bin that will get your external ip and have it contain the following lines and call it **external-ip.sh .** This is using Amazon’s suggested curl command to find out your EC2 instance Ip address. 
      1. [<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="external-ip" src="http://lostechies.com/ryansvihla/files/2011/03/externalip_thumb_7E5DADA6.png" width="670" height="168" />](http://lostechies.com/ryansvihla/files/2011/03/externalip_03406163.png) 
  3. Then create a script for the actual dynamic DNS update in /usr/local/bin/ and call it updatedns-sh. This is using the set command to grab the output of external ip and storing it in the variable $1, and then passing that value to the update command. **NOTE: this will update the dns record of ALL your domains with everydns set to dynamic**. If you need to use specific domain names there is a –d flag for the eDNS client.[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="update" src="http://lostechies.com/ryansvihla/files/2011/03/update_thumb_547D3971.png" width="677" height="169" />](http://lostechies.com/ryansvihla/files/2011/03/update_3944E070.png) 
  4. create a cron job on your linux distro of choice but the cron job line should look like the following. 
      1. [<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="cron" src="http://lostechies.com/ryansvihla/files/2011/03/cron_thumb_51D70E71.png" width="754" height="38" />](http://lostechies.com/ryansvihla/files/2011/03/cron_791157A6.png) 

For those wishing to comment I’ve cross posted to my blogger account.

<http://ryansvihla.blogspot.com/2010/06/dynamic-dns-with-amazon-ec2-linux-and.html>