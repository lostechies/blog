---
wordpress_id: 4638
title: 'Biztalk and WCF &#8211; When two big beasts collide'
date: 2008-10-28T21:35:51+00:00
author: Colin Jack
layout: post
wordpress_guid: /blogs/colinjack/archive/2008/10/28/biztalk-and-wcf-when-two-big-beasts-collide.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/colinjack/archive/2008/10/28/biztalk-and-wcf-when-two-big-beasts-collide.aspx/"
---
I spent the entirety of last week trying to create a ridiculously simple Biztalk orchestration and trying to get it to talk to a simple WCF service and I thought I should describe what I &#8220;learned&#8221;.

**Biztalk**

If you follow me on [Twitter](http://twitter.com/colin_jack) you&#8217;ll know how unbelievably annoyed the results made me and although I didn&#8217;t learn much from the experience I thought I should put down some tips:

  1. If Biztalk gives you an error DO NOT read it, the message itself is bound to be utter jibberish and the correct response is to put it straight into Google. 
      * If Biztalk behaves like a problem is with step N don&#8217;t assume that step N-1 passed especially if step N-1 is a transformation. You can test the transformation in isolation within the IDE using a sample document so do it, 
          * If you are having real problems working out why Biztalk and WCF aren&#8217;t playing ball then it might well be XML namespaces that are the issue. 
              * If you&#8217;re thinking of renaming the orchestration or anything in it be careful and take a backup first. </ol> 
            **WCF**
            
            Whilst Biztalk left me cold the WCF side of it was a joy, mainly because [Johnny Hall](http://www.johnnyhall.co.uk/) pointed me at the [Castle WCF Facility](http://www.castleproject.org/container/facilities/trunk/wcf/index.html) and his own usages of it. Using the WCF Facility configuring your services is an utter joy, definitely when compared to the XML based approach that you get with bog-standard WCF. The documentation isn&#8217;t great but the tests that you get with the Castle [source code](http://svn.castleproject.org:8080/svn/castle/trunk/) are the real way to see how to use its fluent interface.
            
            Johnny also suggested we use a console application to host the service when testing and a Windows Service when deploying for a real. The console application makes testing locally a lot easier, just CTRL+F5 and your host is loaded and ready for you to fire requests at it. 
            
            If only Biztalk was as enjoyable to use&#8230;