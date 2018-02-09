---
wordpress_id: 1197
title: Stitching Together A Saas Of SaaS (And Never Owning A Single Server)
date: 2014-01-14T07:19:23+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1197
dsq_thread_id:
  - "2117440519"
categories:
  - Analysis and Design
  - Business
  - Management
  - Networking
  - Product Reviews
  - Productivity
  - SignalLeaf
  - Tools and Vendors
  - WatchMeCode
  - Web
---
In the late 90&#8217;s and early 2000&#8217;s, I spent a lot of time working with IT / operations departments to get servers procured, setup, configured and running the web apps that I was building. This was a large part of my job, honestly. There were network configurations to consider, firewalls and DMZs, mail services to set up, database servers, web servers, middle-tier app services, and so many other things that had to be in place. It took a lot of coordination and effort and I typically spent several weeks per project to get everything working correctly, with constant maintenance and support throughout the life of the system. I had to know about server configurations. I had to know about server hardware. I had to know about network topologies. I had to know a lot of things that were not directly related to writing code because these were things that directly affected my teams&#8217; ability to write and deploy apps.

Somewhere in the last 5 or 10 years, though, the world of software development IT related services has shifted. We as software developers seem to have moved from a tight integration with the IT and operations world, to viewing them as a service to consume.

## The Explosion Of *aaS

In many cases &#8211; as with small startups and side projects, and even in growing apps and services &#8211; we have moved almost entirely to a service based world. This is a world where nearly anyone that can write code can also publish a live app that consumes as many or more services than I had ever touched, all without owning or caring about a single server setup or network configuration.

There are more Software-as-a-Service (SaaS), Platform-as-a-Service (PaaS), Back-end-as-a-Service (BaaS), and You-Name-It-as-a-Service (WAT?) than I had ever imagined possible. This new world of services is quite amazing, really. With all of these services available, I&#8217;m able to take a process that used to consume weeks and months of my life, every year, and boil it down to minutes for signing up, creating an instance of whatever service, and configuring my code to use that service. And it seems that at least once a month, I hear about a new type of *aaS service &#8211; a new letter in front of that acronym allowing me to reduce the amount of code that I need to write and the amount of hardware I need to understand, even further.

From web servers, email services and database services, to file storage, content delivery networks and and user management, building a SaaS for your job or your side project has never been easier. I&#8217;ve spent a few months of part time, after-hours working on [SignalLeaf](http://signalleaf.com), for example, and have been able to stitch together a service of services that boggles my 2006 era mind. There is simply no way I would have been able to pull off this system with the reliability, capabilities and simplicity in setup, code and deployment, only a few years ago.

## A List Of *aaS To Stitch Your SaaS Together

Having spent so much time building [SignalLeaf](http://signalleaf.com) as well as other apps and services (such as [WatchMeCode](http://watchmecode.net)) in the last few years, I have a go-to list of resources and services that I use. I&#8217;m always looking for new services, of course, and trading out services that no longer fit my needs for those that do. But with a handful of services from this list (and some others, depending on your needs), you can stitch together a SaaS in next to no time and never have to think about owning or configuring a server, again.

[**DNSimple**](https://dnsimple.com/r/0a606a71c39045)

Every SaaS, website, blog, etc. needs DNS &#8211; it&#8217;s how you get your name set up so the world can find you. I spent near 20 years with one particular company that has turned in to a spam-house of shady business practices in the last 5 or so years. Enter DNSimple &#8211; the most awesome DNS service ever, with no spammy garbage. I love the way DNSimple has various one-click service configurations. Things like Google Apps, Heroku, Github Pages, Amazon AWS, and so many more services are no longer a pain to configure. One click and you&#8217;re done. I highly recommend DNSimple for your DNS needs, and I&#8217;m migrating all of my domain names over here. 

**[Heroku](http://heroku.com) **

Heroku is my web server / platform of choice for most apps. What started as a simple way to deploy Ruby on Rails apps with git, has turned in to an easy way to deploy a lot of different web frameworks and service types. I deploy ruby apps and nodejs apps to Heroku quite regularly, and I&#8217;ve been using Heroku for around 4 years, I think. It hasn&#8217;t let me down yet. I know there are alternatives such as [Azure](http://www.windowsazure.com) and I do need to check it out some time, but at this point, I don&#8217;t have a good reason to switch from Heroku.

**[GitHub](http://github.com) / Github Pages**

GitHub is the defacto-standard in distributed source control and issue management for open source projects. I host all of my private repositories here for all of my business and personal things, as well. I love working with a distribute source control system and using GitHub as an online repository makes me feel all warm and fuzzy, not having to set up and host my own source control services and create backup services for it, etc.

In addition to awesome source control, I&#8217;ve built many-a-blog on top of Github&#8217;s Pages feature, including AlbacoreBuild.net and Blog.SignalLeaf.com. If you&#8217;re a paying customer, you can&#8217;t beat adding a static website built with Jekyll / Octopress, for no extra charge. Once again, DNSimple comes to the rescue here when configuring the DNS/URL for the site, too. 

[**Amazon AWS**](http://aws.amazon.com/)

Amazon offers far more services than I could list, at this point. If you haven&#8217;t checked in to AWS, you need to. Chances are, they offer something that you need. For my current projects, I&#8217;m using S3 (Simple Storage Services) to host podcast audio files on SignalLeaf. The ability to store file securely, and have them distributed via Amazon&#8217;s infrastructure ensure SignalLeaf is never the bottleneck for downloads. Even better, I&#8217;ll be able to silently switch downloads over to use Amazon CloudFront when I need to get a CDN in place for the files. Having a cloud service like AWS available makes it a no-brainer to get a lot services up and running quickly, and many of the *aaS services that I rely on are hosted via AWS. 

[**Google Apps**](http://apps.google.com)

Love them or hate them, Google provides some great services when you get in to the ones that let you pay. I use Google Apps to host all my email for all of my domain names, and do a few other related things. Once again, DNSimple makes this a one-click configuration. 

[**MongoLab**](https://mongolab.com)

MongoLab provides hosted MongoDB database services. This is what I&#8217;m using for SignalLeaf. It was easy to set up via Heroku AddOns, but once I did that I realized that it would have been just as easy to create my own account directly through MongoLab.com. If you&#8217;re using MongoDB and need a host, this is a good choice. 

[**Telerik Everlive**](http://telerik.com/everlive)

Telerik&#8217;s Everlive is a backend as a service, providing document based data storage and retrieval, email services, file storage, and more, through a RESTful API or through SDKs for various languages (which talk to the REST API). I&#8217;ve used Everlive in a handful of projects and I really like it. It provides all the core services that smaller apps need, including user management and permissions. It&#8217;s an all-in-one stop for back-end services that are typically written in to NodeJS / Ruby apps. If you&#8217;re looking at building a mobile app or a web app that doesn&#8217;t need a ton of custom logic and handling for services, you should check out Everlive. It&#8217;s one of the easiest services I&#8217;ve used to get up and running, to create a new application back-end.

**[Raygun](http://raygun.io/) /** [**Telerik Analytics**](http://www.telerik.com/analytics)

Error handling and logging is a tremendously important thing in software these days. You want to be on top of any issues that your users are running in to. Using a service like RayGun or Telerik Analytics is necessary so that you can be &#8211; log your errors and get notified of them as they happen, so you can be proactive in fixing things before you start losing customers.

I&#8217;m currently using RayGun for SignalLeaf, but am keeping my eye on Telerik Analytics as it provides more than just error reporting.

**[Keen.io](http://keen.io) / [Telerik Analytics](http://www.telerik.com/analytics)**

There&#8217;s a high likelihood that you&#8217;re not in the business of designing and running analytics on business data and feature usage. You&#8217;re probably building an service or app that does something unrelated to this, but needs these services anyways.

In my case, I need to deliver a series of analytics reports to my SignalLeaf customers &#8211; things like RSS Subscriber count, downloads and listens for podcast episodes, etc. Keen.io fits this need perfectly for me. I ship off event data to Keen.io, and use their API to run analytics and get data back that I can display to the podcasters using SignalLeaf.

When it comes to understanding which parts of your application are being used and how often, though, Telerik Analytics is pretty darn amazing. While Keen.io and Telerik Analytics do have a very similar overview in capturing event data and reporting analytics, Telerik&#8217;s setup is meant to be a back-end admin feature. A the time of writing this, it doesn&#8217;t provide report data that you can show to your users through an API. Instead, it is focused on capturing usage information for your apps so that you can decide which features need to go, which need to stay, which need to be modified or streamlined, etc. 

[**CloudAMQP**](http://www.cloudamqp.com/)

Running all of your app in-process and synchronously is a great way to destroy application performance and usability, not to mention creating a giant monolithic beast of code to deal with. Using a message queue and service bus infrastructure within your code is needed when you have processes that take more time than the user needs to be aware of. I chose RabbitMQ for my service bus and queue needs, and am using CloudAMQP for my online hosting. It gives me a simple way to stand up new RabbitMQ servers, set the features and scale of those services, and run my processes out of band by publishing messages and subscribing to them, to handle them later. SignalLeaf takes advantage of this to track and report usage, RSS subscribers, and more. Like a lot of other services I use, it is hosted through Amazon AWS &#8211; I have more confidence in services hosted on AWS, honestly, because I know how easy it is to do amazing things with AWS.

[**MailChimp**](http://eepurl.com/MiHhj)

MailChimp is an amazing service for maintaining a mailing list. I use it for all my mailing lists at this point. If you&#8217;re building a service, blogging, or trying to build an audience of any kind, you should have a mailing list. It will be your most valuable asset as you release new products and services.

[**Mandrill**](https://mandrillapp.com/)

From the same company that built MailChimp, Mandrill is an email sending service. No more worries about your email server turning in to a relay for spam. No more blacklists, whitelists and fear of being blacklisted. No more configuring arcane mail services on a linux box. Mail services were my nightmare in apps that I built and deployed way back when. Mandrill makes my life easy. I can set up an email service and send mail from my apps with ease, now. All of the email that comes from SignalLeaf goes through Mandrill.

[**Stripe**](https://stripe.com/)

The easiest way to set up payments of any kind, IMO. I created subscription services for SignalLeaf and had them up and running in only a few hours. I also accept individual payments for screencast episodes at WatchMeCode using Stripe. Stripe will transfer money directly in to your bank account when you receive payment from customers.

[**GetDPD**](https://getdpd.com/?referrer=up8ii03364gwo0kg)

For sales of digital goods, I found GetDPD to be extremely useful and easy to set up. It currently runs WatchMeCode&#8217;s shopping cart and handles all of the delivery of digital goods, billing, coupons and more. I&#8217;ve been using this for WatchMeCode for some time now. Honestly, I might use Amazon S3 + Stripe for this if I were to rebuild, but I have everything running so smoothly with GetDPD that I don&#8217;t want to change it. It was easy to set up and required no knowledge of writing code to get things sold. If you&#8217;re starting out with digital sales, definitely look at DPD.

[**Leanpub**](https://leanpub.com/)

If you want to self-publish an ebook, you won&#8217;t do better than Leanpub. I buy a lot of books through Leanpub and I&#8217;ve written 2 books through Leanpub and thoroughly enjoy the experience. Similar to DPD, Leanpub will handle everything for you, except writing the book. They&#8217;ll produce the PDF/mobi/epub files, handle sales, deliver the content to customers and deposit money in to your account. You can&#8217;t make ebook writing and sales any easier than this.

[**Disqus**](http://disqus.com/)

My go-to for comments on any blog or website that I run, including this one! Drop me a line below and see just how easy it is to work within the Disqus comment system. 

## But Wait! There&#8217;s More!

The ability to build and deploy a SaaS has never been easier. You don&#8217;t need to worry about building and configuring infrastructure anymore. You don&#8217;t need to have a handful of network certifications to get your services online. You don&#8217;t need to be both a developer and an IT / operations expert. You can build your service, your app, your product, your whatever, and get it online and available for others to use without having to own or configure a single server.

I&#8217;ve only touched on the tip of the iceberg for services that are available, these days. These are the services I&#8217;m using, though, and the ones that I highly recommend. What other services are you using to build your apps, products and SaaS? Drop a comment below and let me know!