---
wordpress_id: 3137
title: Another reason to love MonoRail
date: 2007-09-26T00:50:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2007/09/25/another-reason-why-i-love-monorail.aspx
dsq_thread_id:
  - "635100898"
categories:
  - monorail aspnet
---
W3C Validation is easy!!


  


I won&#8217;t mention the site that I am fixing validation for because it is in a horrid state and I am quite embarassed =)


  


The fact of the matter is, I fixed quite a few errors in moments simply by modifying my NVelocity templates. This is how it was meant to be!


  


A number of years ago (~2000), I worked at a web design company and worked mainly with PHP and MySql. There was a templating engine that I believe is still widely used with PHP called SmartyTemplate. This was a great feature that I think is underrated, not only for PHP but for any web based language. It allowed you to have seperate template files and used basic variable notation to display data that was generated from the PHP file. This way you seperated all of your logic from your presentation. It made for a very nice seperation, especially in PHP where people were used to mixing presentation code with application code.


  


I feel very strongly about having a template display my content for me. It enforces you to not be able to mix application code with presentation code which isn&#8217;t the case with asp.net.


  


When I first started to play with MonoRail I decided to use NVelocity over Brail. This was because Brail allowed you to mix the two together but only in a very slight degree, as well as the fact that it seemed (at the time), there was more support for nvelocity. This is one area that I would really like to see alot of attention when Microsoft comes out with their new MVC framework. Without a proper templating engine I firmly believe that little can be gained from the solution as a whole. Not because it doesn&#8217;t have a templating engine, but because no matter how the say it &#8220;should&#8221; be used, people will abuse it and dillute the whole idea of having an ignorant template and slowly begin to create poor MVC architectures and think they are doing it correctly which Microsoft will probably help along a bit.


  


I digress from the main topic though, letting my dislike for Microsoft methodologies get the best of me =)


  


Bottom line is, your template should be basic and &#8220;dumb&#8221; so to speak. It shouldn&#8217;t know how to retrieve data, or even think about going about performing any complex application logic. MonoRail and NVelocity to the rescue!!