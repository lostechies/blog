---
wordpress_id: 264
title: 'How to *easily* apt-get update &#8220;offline&#8221;'
date: 2015-01-28T17:14:10+00:00
author: Ryan Rauh
layout: post
wordpress_guid: http://lostechies.com/ryanrauh/?p=264
dsq_thread_id:
  - "3463628590"
categories:
  - Uncategorized
---
## Building a Virtual Appliance is hard.

> A virtual appliance is a pre-configured virtual machine image, ready to run on a hypervisor; virtual appliances are a subset of the broader class of software appliances. Installation of a software appliance on a virtual machine and packaging that into an image creates a virtual appliance. Like software appliances, virtual appliances are intended to eliminate the installation, configuration and maintenance costs associated with running complex stacks of software.
    
> [via Wikipedia](http://en.wikipedia.org/wiki/Virtual_appliance)

Put simply, a virtual applicance is a VM export (typically in [OVF](http://en.wikipedia.org/wiki/Open_Virtualization_Format) via an ova file) with your application pre-installed on it. Sometimes thats enough to sell your product or install your product on-premises, but to truely deliver on the above promise of eliminating installation, configuration, and maintenace costs you need to provide a few basic things.

  1. Basic network configuration
  2. User interface to input configuration 
  3. Upload endpoint for updates
  4. Disconnected Installation/Provisioning process (No internet!)

By far the most challenging part of building a virtual applicance is provisioning the machine while disconnected from the internet. It&#8217;s easy to take for granted the ease and simplicity of `apt-get install` and as it turns out, &#8220;offline&#8221; apt support isn&#8217;t a trivial endevour.

Like most things in linux there are [many](http://www.reddit.com/r/linux/comments/1yrwy6/download_packageall_dependencies_for_offline/) [many](http://www.reddit.com/r/linux/comments/1yrwy6/download_packageall_dependencies_for_offline/) [many](http://manpages.ubuntu.com/manpages/dapper/man1/apt-ftparchive.1.html) [many](http://manpages.ubuntu.com/manpages/oneiric/man1/dpkg-scansources.1.html) ways to skin a cat but I think I&#8217;ve found a strong solution.

First step, you need a clean distro of linux. You need to start with a machine image that effectively a fresh install from an iso.

**Install apt-cacher-ng before you install anything else**

`apt-get install apt-cacher-ng`

Next you&#8217;ll need to configure apt to use apt-cacher-ng as a proxy server.

`echo 'Acquire::http { Proxy "http://localhost:3142"; };' > /etc/apt/apt.conf.d/02Proxy`

Now you can provision your machine as would normally, personally we use [puppet](http://puppetlabs.com/puppet/what-is-puppet).

`puppet apply`

Next you&#8217;ll want to package up the apt-cacher-ng cache folder that&#8217;s located at /var/cache/apt-cacher-ng. For HuBoard:Enterprise we use debian files as our &#8220;file delivery&#8221; mechanism. We have a simple rake script that uses fpm to build a debian package containing the cache folder, but a tarball will work just as well.

{% gist 0bace9f91326a9f65d59 Apt-packager.rake %}

Ok, so now you have a base line, you&#8217;ve effectively built a 1.0 version of every debian package installed on your image. It&#8217;s important understand the concept of your &#8220;offline&#8221; image and your &#8220;online&#8221; image. The **offline** image is the Virtual Appliance that your have given to your customer your **online** image is your snapshot of the image before you exported it to the OVF. Here is where it can get a little tricky, let imagine that you&#8217;ve released 1.0 of your amazing product&#8230; Let&#8217;s call it HuBoard:Enterprise 😉

You shipped your customers the MVP to get your application to work and update, but your getting flooded with support requests that your customers would like to monitor the resources your Appliance is using, so you&#8217;re like &#8220;I know, I&#8217;ll use collectd&#8221;. Here is how you would do it.

First step, on your **online** machine, install collectd like you normally would.

`apt-get install collectd`

Next package up the apt-cacher-ng folder

`rake package`

Now upload the _cached_ folder to your offline machine and install it right over top the baseline cache folder. If your using debian like we are&#8230;

`dpkg -i apt-cacher-offline_1.0.1_all.deb<br />
chown -R apt-cacher-ng:apt-cacher-ng /var/cache/apt-cacher-ng`

Now what&#8217;s really cool about this approach is that apt-cacher-ng builds legit bonifide apt repositories so you can point your sources.list directly at your /var/cache folder.

Here&#8217;s an example

{% gist 0bace9f91326a9f65d59 sources.list %}

Ok now that you&#8217;ve pointed your offline machine at your local file system, you can install the missing packages extremely easy

`apt-get update<br />
apt-get install collectd`

Here&#8217;s a link to the [GitHub gist](https://gist.github.com/rauhryan/0bace9f91326a9f65d59) if you prefer to read the post in gist form.

  * Ryan
