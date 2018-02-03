---
wordpress_id: 3143
title: Staying on top of Test Coverage
date: 2007-10-09T17:15:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2007/10/09/staying-on-top-of-code-coverage.aspx
dsq_thread_id:
  - "284219678"
categories:
  - TDD
---
<IMG height="369" hspace="20" src="http://i184.photobucket.com/albums/x270/dkode8880/coverage.jpg" width="345" align="left" border="1" />It&#8217;s always a good idea to make sure you stay on top of&nbsp;test coverage. As the image to the left clearly displays, it will quickly get out of hand and before you know it your coverage is in the toilet =)


  


I am usually pretty good about staying on top of my test coverage. In this instance there was a very strict timeline and the launch date could not be moved. Thus, some tests got skipped. Not alot, but as you can see the whole Services namespace has no coverage at all. BAD! BAD! BAD! &nbsp;Especially since the Services.Authentication namespace manages authentication of clients logging into this peticular application.


  


It&#8217;s very easy to say to yourself, &#8220;I&#8217;ll write a test for this method later&#8221; and then forget about it. This is probably one of my most poorly covered code bases, besides legacy apps. All of my other tdd projects have at the very minimum a 80% coverage, alot of them have 90% coverage. The classes that have no possible way of being tested (HttpPostedFileAdapter as an example), I place in their own namespace and exclude them from NCoverExplorer&#8217;s coverage output. This way I am not including code that I have no way of testing. The screenshot to the left is code that should have 90% coverage but doesn&#8217;t.


  


On another note, it is a HUGE undertaking to bring a poorly covered project back up to proper coverage after the fact.Another reason why it should be done from the start. Originally this code base started out at 45% test coverage =(&nbsp; It took me a week just to bring it up 12%!!! Granted, I spent a day fixing some nant stuff in there and also doing alot of refactoring that wasn&#8217;t done before.


  


Lacking on test coverage will only make it hurt worse later down the line. We all know how important it is to deliver a product on time, but is a product deadline excuse enough to let test coverage slip? By doing that you are only decreasing maintaintability, scalability and money later down the line. Probably even more so then originally because now you are retrofitting legacy code with tests. That&#8217;s right, as soon as you deliver that product, the pain of writing tests becomes much worse. Why not do it correctly the first time?


  


If I could go back in time to when this project first started, I would probably have suggested that we pushed the launch date back at least 2 months.


  


&nbsp;Bottom line is, stay on top of your test coverage. If not you&#8217;ll regret it like me =)