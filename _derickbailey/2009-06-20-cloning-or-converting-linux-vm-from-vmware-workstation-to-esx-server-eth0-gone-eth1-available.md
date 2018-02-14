---
wordpress_id: 62
title: 'Cloning Or Converting Linux VM From VMWare Workstation To ESX Server: ETH0 Gone. ETH1 Available?'
date: 2009-06-20T18:57:01+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/06/20/cloning-or-converting-linux-vm-from-vmware-workstation-to-esx-server-eth0-gone-eth1-available.aspx
dsq_thread_id:
  - "262068230"
categories:
  - Linux
  - Networking
redirect_from: "/blogs/derickbailey/archive/2009/06/20/cloning-or-converting-linux-vm-from-vmware-workstation-to-esx-server-eth0-gone-eth1-available.aspx/"
---
I ran into a fun situation yesterday. I downloaded a virtual appliance for the [Agilo Trac Plugin](http://www.agile42.com/cms/pages/agilo/) (which, if you’re a [Trac](http://trac.edgewall.org/) user and trying to do sprints or iterations with it, you need to get this. It’s free and it rocks.) Turns out this VM is a Debian distribution. (I’m certainly no linux guru, but I can usually find my way around.)

Starting up the VM on my local VMWare Workstation worked fine. The distro is configured for DHCP, and my VM network bridged to my box, found the company network and found an IP for the VM. You can see the IP show up in the screen shot below:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="326" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_188BD95A.png" width="449" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_6ACE3661.png) 

After playing with the Agilo app for a few minutes, I wanted to share it with my coworkers and get their opinions. Fortunately for me, I’ve been helping the company grow a rather nice VMWare ESX Server infrastructure for our development needs. So, I thought the easy thing to do would be to migrate the VM up to a server and make it available.

I go through the “Export” process from VMWare Workstation and send it up to a server with no problems. I configured a static IP address in the /etc/network/interfaces file, [as described in this article](http://www.cyberciti.biz/tips/howto-ubuntu-linux-convert-dhcp-network-configuration-to-static-ip-configuration.html). However, when I get the server based VM up and running again, I run into a problem:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="335" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_27FEC55C.png" width="497" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_03B9E0DA.png)&#160; 

Note the first error circled: “eth0: error fetching interface information: Device not found”. And the second error circled: no ip address!!! That’s not good… how am I supposed to get to the box without an IP address… so, I check the network adapters through ifconfig to see if I can get eth0 back up. 

No luck &#8211; “eth0: ERROR while getting interface flags: No such device”

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="62" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_249D2DB4.png" width="552" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_3E0530EE.png) 

Checking ifconfig, i see that there’s only an “eth1” configured in the vm.

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="351" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_5FC0E3B2.png" width="507" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_2F5A8509.png) 

After some serious hair-pulling-out frustration, several coworkers not having any clue, and a general sense of doom and gloom; I managed to pull some serious google-fu out, [and found this post](http://www.nabble.com/Changing-NIC-in-existing-Server-results-in-no-ETH0-td19956170.html). The information provided looked like what I needed:

> _either </p> 
> 
> &#8211; the kernel in Lenny is newer and **has** a driver that is missing (or **not**   
> &#160; fully functional for your hardware) on the other system   
> </em>       _  
> or   
>_        _  
> &#8211; the new card was assigned **eth1** because the previous card&#8217;s mac address   
> &#160; is still listed in the database of persistent **ethernet** device names_ 
> 
> _Boot the problematic system and run "/sbin/ifconfig". If you see the   
> 3Com NIC listed as **eth1** then you can edit the file </p> 
> 
> **/etc/udev/rules.d/70-persistent-net.rules   
>**   
> to assign **eth0** to it. (Remove or comment out the entry for the old NIC.) </em></blockquote> 
> 
> As it turned out, the conversion process from local VMWare workstation up to VMWare ESX Server caused the virtual NIC’s MAC Address to change. So I go hunting for the file they talk about, and it’s not there. Fortunately, it was only a few characters off from my debian box:
> 
> > /etc/udev/rules.d/z25-persistent-net.rules
> 
> looking at the contents of this file, I found the system’s configuration for all of the network adapters, and noticed that there are two of them in my file:
> 
> [<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="116" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_66B0706A.png" width="733" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_6EA812CC.png) 
> 
> but I know that the VM only has one virtual NIC. so, following the advice from the post above, I comment out the current “eth0” and rename “eth1” to “eth0”.
> 
> [<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="111" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_532310C9.png" width="733" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_2D2D6073.png) 
> 
> Reboot the box and it works!
> 
> [<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="135" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_3D59286C.png" width="416" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_19A000D2.png)