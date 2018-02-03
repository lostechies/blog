---
wordpress_id: 1082
title: 'Upgrading NServiceBus &#8211; A painful experience'
date: 2015-07-07T11:06:59+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1082
dsq_thread_id:
  - "3912913753"
categories:
  - upgrade
---
This post is mostly for self documentation but if someone else benefits from it I am more than happy. In one of my projects I had to update [NServiceBus](http://particular.net/) (NSB) from an old version (4.x) to the newest stable version (5.2.3 at the time of writing). This whole update is not a fun exercise at all specifically if the application we need to upgrade consists of many parts. The upgrade documentation is also not very helpful to say the least mostly because the relevant information is distributed throughout many (online) documents.

Now to my problem: After I had upgraded all my NSB handlers and clients by using the Nuget console (e.g. upgrade-package NServiceBus, etc.) and changed the configuration I tried to start one of the handlers. We are using the NServiceBus.Host to host all NSB handlers. When I started the handler from Visual Studio the normal console window would appear and I could see NSB bootstrapping until a certain point when it failed with the error message:

_InvalidOperationException was unhandled by user code&#8230; IWantQueueCreated implementation NServiceBus.Unicast.Queuing.Installers.ForwardReceivedMessagesToQueueCreator returned a null address_

[<img class="alignnone size-full wp-image-1083" title="NSB Error Message" src="https://lostechies.com/gabrielschenker/files/2015/07/Capture2.png" alt="" width="458" height="190" />](https://lostechies.com/gabrielschenker/files/2015/07/Capture2.png)

Google-ing for any help was not successful at all. Other that another unrelated issue I did not find any information. The error per se is so non-descriptive and totally misleading that I started to pull my hair. After trying various things without success I decided to create a sample project that had all the same configuration than the original NSB handler. Of course the sample project just ran fine without the slightest hiccup. When I compared the EndPointConfig class and the app.config line by line at first I realized no difference. Finally I discovered a tiny difference in the config files. I didn&#8217;t even think that it would make any difference but I wanted to exclude all possibilities. It turned out that in the original config file I had this

[<img class="alignnone size-full wp-image-1084" title="Original config file" src="https://lostechies.com/gabrielschenker/files/2015/07/Capture.png" alt="" width="709" height="65" />](https://lostechies.com/gabrielschenker/files/2015/07/Capture.png)

whilst in the new config file I had this

[<img class="alignnone size-full wp-image-1085" title="New config file" src="https://lostechies.com/gabrielschenker/files/2015/07/Capture1.png" alt="" width="1050" height="142" />](https://lostechies.com/gabrielschenker/files/2015/07/Capture1.png)

Note how in the old config file we had the definition of the audit queue in the UnicastBusConfig node whilst in the new config we explicitly define a node AuditConfig for the audit queue. This little annoying difference cost me several hours of painful hairpulling and swearing 😉

After changing the configuration everything just worked fine. What an experience! What I have confirmed yet once again is the benefit of creating a sample application outside of the scope of the application I am debugging which only concentrates on the feature that does not work or needs to be debugged&#8230;