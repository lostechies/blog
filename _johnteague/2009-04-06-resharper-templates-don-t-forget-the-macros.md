---
wordpress_id: 27
title: 'Resharper templates: Don&#8217;t forget the Macros'
date: 2009-04-06T04:36:17+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2009/04/06/resharper-templates-don-t-forget-the-macros.aspx
dsq_thread_id:
  - "262055623"
categories:
  - Resharper
---
I use Resharper templates (among other features) on a daily basis.&#160; Most of them create very small pieces of code that I use VERY frequently.&#160; For instance, I have a set of templates that help me build out my test classes and cases very quickly.&#160; One of the very cool features you can add to your templates is to use Macros that let&#8217;s R# do more work for you.

The lates template I created was to create the MockRepository.GenerateStub<Type>() line for me.&#160; It’s a simple one liner, with one variable $INTERFACE$

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="46" alt="image" src="http://lostechies.com/johnteague/files/2011/03/image_thumb_0CE98DCD.png" width="721" border="0" />](http://lostechies.com/johnteague/files/2011/03/image_0D55C0C2.png) 

I then added a Macro to the template to guess the type the variable should be.

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="375" alt="image" src="http://lostechies.com/johnteague/files/2011/03/image_thumb_1815A8C8.png" width="347" border="0" />](http://lostechies.com/johnteague/files/2011/03/image_35F42CC9.png) 

Now I can use this macro ( it’s named gs) on this line.

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="63" alt="image" src="http://lostechies.com/johnteague/files/2011/03/image_thumb_351E5790.png" width="593" border="0" />](http://lostechies.com/johnteague/files/2011/03/image_4E865ACA.png) 

And it fills out the generic type of the GenerateStub method for me.

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="31" alt="image" src="http://lostechies.com/johnteague/files/2011/03/image_thumb_274EA246.png" width="913" border="0" />](http://lostechies.com/johnteague/files/2011/03/image_0C164945.png) 

As you can see, this is really a big time saver, especially for the really tedious generic types.&#160; Small time optimizations like these add up over a few hundred tests.